//
//  CMLMyCouponsTableView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/17.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMyCouponsTableView.h"
#import "CMLMyCouponsModel.h"
#import "NetConfig.h"
#import "CMLCouponCell.h"
#import "CMLCanUseCell.h"
#import "CMLCanGetCouponsCell.h"

@interface CMLMyCouponsTableView ()<UITableViewDelegate, UITableViewDataSource, NetWorkProtocol, CMLCouponCellDelegate, CMLCanGetCouponsCellDelegate, CMLCanUseCellDelegate>

@property (nonatomic, strong) BaseResultObj *detailObj;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) int dataCount;

@property (nonatomic, strong) NSNumber *isUse;

@property (nonatomic, strong) NSNumber *process;

@property (nonatomic, copy)   NSString *currentApiName;

@property (nonatomic, assign) CGFloat couponCellHeight;

@property (nonatomic, assign) CGFloat canUseCouponCellHeight;

@property (nonatomic, assign) CGFloat replaceCellHeight;

@property (nonatomic, strong) NSMutableDictionary *heightDict;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL isChoosing;

@property (nonatomic, assign) CouponsTableType couponsTableType;

@property (nonatomic, strong) NSNumber *price;

@end

@implementation CMLMyCouponsTableView

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDict {
    if (!_heightDict) {
        _heightDict = [NSMutableDictionary dictionary];
    }
    return _heightDict;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withIsUse:(NSNumber * _Nullable)isUse withProcess:(NSNumber * _Nullable)process withObj:(BaseResultObj * _Nullable)obj withCouponsType:(CouponsTableType)type withPrice:(NSNumber * _Nullable)price {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.detailObj = obj;
        self.couponsTableType = type;
        self.isUse = isUse;
        self.process = process;
        self.price = price;
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.backgroundColor = [UIColor CMLWhiteColor];

        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfheader)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        
        [self pullRefreshOfheader];
        
    }
    return self;
}

- (void)loadData {
    
    self.page = 1;
    self.pageSize = 10;
    self.selectedIndex = -1;
    [self.baseTableViewDlegate startRequesting];
    [self pullRefreshOfheader];
    
}

- (void)pullRefreshOfheader {
    
    self.page = 1;
    self.pageSize = 10;
    [self.dataArray removeAllObjects];
    [self.baseTableViewDlegate startRequesting];
    [self setMyCouponsRequest];
    
}

- (void)loadMoreData {
    
    if (self.dataArray.count % self.pageSize == 0) {
        if (self.dataArray.count != self.dataCount) {
            self.page++;
            [self setMyCouponsRequest];
        }else {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }else {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)setMyCouponsRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInt:self.pageSize] forKey:@"pageSize"];
    [dict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    if (self.process) {
        [dict setObject:self.process forKey:@"process"];/*查询已过期时传3*/
    }
    if (self.isUse) {
        [dict setObject:self.isUse forKey:@"isUse"];
    }
    
    if (self.detailObj) {
        if ([self.detailObj.retData.rootTypeId intValue] == 7) {
            [dict setObject:self.detailObj.retData.currentID forKey:@"goodsId"];
            [dict setObject:self.detailObj.retData.brandId forKey:@"brandId"];
        }else if ([self.detailObj.retData.rootTypeId intValue] == 3) {
            [dict setObject:self.detailObj.retData.currentID forKey:@"projectId"];
        }
    }
    
    if (self.price) {
        [dict setObject:self.price forKey:@"price"];
    }
    
    if (self.couponsTableType == CanGetCouponsTableType) {
        if (self.detailObj) {
            if ([self.detailObj.retData.rootTypeId intValue] == 7) {
                [dict setObject:self.detailObj.retData.brandId forKey:@"brandId"];
            }
        }
        [NetWorkTask postResquestWithApiName:PersonCenterCanGetCoupons paraDic:dict delegate:delegate];
        self.currentApiName = PersonCenterCanGetCoupons;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                NSLog(@"%@", dict);
    }else {
        [NetWorkTask postResquestWithApiName:PersonCenterMyCoupons paraDic:dict delegate:delegate];
        self.currentApiName = PersonCenterMyCoupons;
    }
    NSLog(@"%@", dict);
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    if ([self.currentApiName isEqualToString:PersonCenterMyCoupons]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"%@", responseResult);
        if ([obj.retCode intValue] == 0) {
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            
            [self reloadData];
            
        }else if ([obj.retCode intValue] == 100101) {
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }else {
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        if (self.dataArray.count == 0) {
            self.tableFooterView = [self setCurrentCouponsTableFooterView];
            self.tableHeaderView = [[UIView alloc] init];
            self.bounces = NO;
            self.bouncesZoom = NO;
        }else {
            self.tableFooterView = [[UIView alloc] init];
            self.bounces = YES;
            self.bouncesZoom = YES;
        }

    }else if ([self.currentApiName isEqualToString:PersonCenterCanGetCoupons]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"%@", responseResult);
        if ([obj.retCode intValue] == 0) {
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            
            [self reloadData];
        }else if ([obj.retCode intValue] == 100101) {
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }else {
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        if (self.dataArray.count == 0) {
            self.tableFooterView = [self setCurrentCouponsTableFooterView];
            self.bounces = NO;
            self.bouncesZoom = NO;
        }else {
            self.tableFooterView = [[UIView alloc] init];
            self.bounces = YES;
            self.bouncesZoom = YES;
        }

    }

    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
    
}

- (UIView *)setCurrentCouponsTableFooterView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              self.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterNoCouponsImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(bgView.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 CGRectGetHeight(self.frame) - HEIGHT/2 - imageView.frame.size.width,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [bgView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"还没有任何优惠券哦~";
    textLabel.font = KSystemFontSize14;
    textLabel.textColor = [UIColor CMLLineGrayColor];
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(bgView.frame.size.width/2.0 - textLabel.frame.size.width/2.0,
                                 CGRectGetMaxY(imageView.frame) + 20 * Proportion,
                                 textLabel.frame.size.width,
                                 textLabel.frame.size.height);
    [bgView addSubview:textLabel];
    
    return bgView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
        if (self.couponCellHeight > 0) {
            return self.couponCellHeight;
        }else {
            return 216 * Proportion + 20 * Proportion;
        }
    
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
        CMLMyCouponsModel *model = [CMLMyCouponsModel getBaseObjFrom:self.dataArray[indexPath.row]];
        if (self.couponsTableType == CanGetCouponsTableType) {
            static NSString *identifier = @"canGetCouponsCell";
            CMLCanGetCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLCanGetCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            [cell refreshCanGetCurrentCell:model withIsUse:self.isUse withProcess:self.process];/*可领取*/
            self.couponCellHeight = cell.currentHeight;
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
        }else if (self.couponsTableType == CanUseCouponsTableType) {
            
            static NSString *identifier = @"canUseCouponsCell";
            CMLCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            [cell refreshCanUseCurrentCell:model withIsUse:[self.isUse intValue] withProcess:[self.process intValue] withRow:indexPath.row];
            self.couponCellHeight = cell.currentHeight;

            if (self.row != indexPath.row) {
                cell.chooseButton.selected = NO;
            }else {
                cell.chooseButton.selected = self.isSelect;
            }
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
            
        }else {
            
            static NSString *identifier = @"myCouponsCell";
            CMLCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            NSLog(@"cell %f", cell.frame.size.height);
            [cell refreshCurrentCell:model withIsUse:[self.isUse intValue] withProcess:[self.process intValue]];/*优惠列表*/
            self.couponCellHeight = cell.currentHeight;
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
            
        }
    }
    return nil;
}

- (void)refreshWith:(NSInteger)row with:(BOOL)isSelect {
    self.row = row;
    self.isSelect = isSelect;
    NSLog(@"self.row %ld", (long)self.row);
    [self reloadData];
    
}

#pragma mark - CMLCouponCellDelegate
- (void)useContentButtonClickedOfCouponCellWith:(CGFloat)height {
    self.couponCellHeight = height;
    [self reloadData];
    
}

#pragma mark - CMLCanUseCellDelegate
- (void)useContentButtonClickedOfCouponsCellWith:(CGFloat)height {
    self.couponCellHeight = height;
    [self reloadData];
}

- (void)backChooseButtonRow:(NSInteger)row withCurrentSelect:(BOOL)isSelect {
    
    self.row = row;
    self.isSelect = isSelect;
    CMLMyCouponsModel *model = [CMLMyCouponsModel getBaseObjFrom:self.dataArray[row]];
    [self.couponsTableDelegate backCouponsSelectObj:model wihtRow:row withIsSelect:isSelect];
    NSLog(@"row %ld", (long)row);
    [self reloadData];
}

- (void)changeChooseStatus:(BOOL)isSelect currentCouponsId:(NSString *)couponsId {
}

#pragma mark - CMLCanGetCouponsCellDelegate
- (void)getCouponsClickedOfCanGetCouponsCell {
    
    [self pullRefreshOfheader];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
