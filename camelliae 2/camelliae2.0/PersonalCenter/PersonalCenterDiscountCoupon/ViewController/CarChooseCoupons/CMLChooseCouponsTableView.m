
//
//  CMLChooseCouponsTableView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLChooseCouponsTableView.h"
#import "CMLMyCouponsModel.h"
#import "NetConfig.h"
#import "CMLCanUseCell.h"

@interface CMLChooseCouponsTableView ()<UITableViewDelegate, UITableViewDataSource, NetWorkProtocol, CMLChooseCouponsTableViewDelegate, CMLCanUseCellDelegate>

@property (nonatomic, strong) CMLMyCouponsModel *chooseCouponsModel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) int dataCount;

@property (nonatomic, strong) NSNumber *isUse;

@property (nonatomic, strong) NSNumber *process;

@property (nonatomic, copy)   NSString *currentApiName;

@property (nonatomic, assign) BOOL isChoosing;

@property (nonatomic, copy) NSString *carIdArr;

@property (nonatomic, copy) NSString *carPriceArr;

@property (nonatomic, assign) CGFloat couponCellHeight;

@property (nonatomic, strong) NSMutableArray *priceArray;

@property (nonatomic, strong) NSMutableArray *rowArray;

@property (nonatomic, strong) NSMutableDictionary *selectDict;

@property (nonatomic, strong) NSArray *chooseCouponsIdArray;

@end

@implementation CMLChooseCouponsTableView

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)priceArray {
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

- (NSMutableDictionary *)selectDict {
    if (!_selectDict) {
        _selectDict = [NSMutableDictionary dictionary];
    }
    return _selectDict;
}

- (NSArray *)chooseCouponsIdArray {
    if (!_chooseCouponsIdArray) {
        _chooseCouponsIdArray = [NSMutableArray array];
    }
    return _chooseCouponsIdArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style carId:(NSString *)carIdArr priceArr:(NSString *)priceArr chooseCouponsIdArray:(NSArray *)chooseCouponsIdArray {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.carPriceArr = priceArr;
        self.carIdArr = carIdArr;
        self.chooseCouponsIdArray = chooseCouponsIdArray;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10*Proportion)];
        self.tableHeaderView = view;
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

- (void)pullRefreshOfheader {
    
    self.page = 1;
    self.pageSize = 1000;
    [self.dataArray removeAllObjects];
    [self.baseTableViewDlegate startRequesting];
    [self setChooseRequest];
    
}

- (void)loadMoreData {
    
    if (self.dataArray.count % self.pageSize == 0) {
        if (self.dataArray.count != self.dataCount) {
            self.page++;
            [self setChooseRequest];
        }else {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }else {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)setChooseRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInt:self.pageSize] forKey:@"pageSize"];
    [dict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"process"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"isUse"];
    if (self.carPriceArr.length > 0) {
        [dict setObject:self.carPriceArr forKey:@"priceArr"];
    }
    if (self.carIdArr.length > 0) {
        [dict setObject:self.carIdArr forKey:@"carIdArr"];
    }
    NSLog(@"%@", dict);
    [NetWorkTask postResquestWithApiName:PersonCenterCarUseCoupons paraDic:dict delegate:delegate];
    self.currentApiName = PersonCenterCarUseCoupons;
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    if ([self.currentApiName isEqualToString:PersonCenterCarUseCoupons]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"PersonCenterCarUseCoupons %@", responseResult);
        if ([obj.retCode intValue] == 0) {
            self.dataCount = [obj.retData.dataCount intValue];
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            [self.chooseTableDelegate backCarCouponsPriceWith:self.dataCount with:obj];
            
            
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
        
        static NSString *identifier = @"canUseCouponsCell";
        CMLCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.delegate = self;
        [cell refreshCanUseCurrentCell:model withChooseCouponsIdArray:self.chooseCouponsIdArray withRow:indexPath.row];
        self.couponCellHeight = cell.currentHeight;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    return nil;
}

- (void)refreshWith:(NSInteger)row with:(BOOL)isSelect {
    self.row = row;
    self.isSelect = isSelect;
    NSLog(@"self.row %ld", (long)self.row);
    [self reloadData];
    
}

#pragma mark - CMLCanUseCellDelegate
- (void)backChooseButtonRow:(NSInteger)row withCurrentSelect:(BOOL)isSelect {
    /*
    self.row = row;
    self.isSelect = isSelect;

    [[NSUserDefaults standardUserDefaults] setBool:self.isSelect forKey:[NSString stringWithFormat:@"%ld", (long)self.row]];
    
//    if (chooseCoupons) {
//        CMLMyCouponsModel *model = [CMLMyCouponsModel getBaseObjFrom:chooseCoupons[[row intValue]]];
//        
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@", row]]) {
//            NSLog(@"breaksMoney %@", model.breaksMoney);
//            self.isSelect = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@", row]];
//            if (self.isSelect) {
//                self.couponPrice += [model.breaksMoney floatValue];
//            }else {
//                self.couponPrice -= [model.breaksMoney floatValue];
//            }
//        }
//        
//    }
    
    
    [self.chooseTableDelegate backCarCouponsSelectObj:self.dataArray wihtRow:row withIsSelect:isSelect];
    
    [self reloadData];
     */
}

- (void)changeChooseStatus:(BOOL)isSelect currentCouponsId:(NSString *)couponsId {
    NSLog(@"%@", couponsId);
    /*顺序传值-传入已选择的字典key*/
    if (self.chooseCouponsIdArray) {
        for (int i = 0; i < self.chooseCouponsIdArray.count; i++) {
            [self.selectDict setObject:[NSNumber numberWithInt:1] forKey:self.chooseCouponsIdArray[i]];
        }
    }
    if (isSelect) {
        [self.selectDict setObject:[NSNumber numberWithInt:1] forKey:couponsId];
    }else {
        [self.selectDict removeObjectForKey:couponsId];
    }

    [self.chooseTableDelegate backCarCouponsWithDataArray:self.dataArray WithDict:self.selectDict];
    NSLog(@"%@", self.selectDict);
    
}

#pragma mark - CMLCanUseCellDelegate
- (void)useContentButtonClickedOfCouponsCellWith:(CGFloat)height {
    self.couponCellHeight = height;
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
