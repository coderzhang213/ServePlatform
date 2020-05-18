//
//  CMLMyChangeVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLMyChangeVC.h"
#import "VCManger.h"
#import "OwnExchangeTVCell.h"
#import "MJRefresh.h"
#import "VCManger.h"
#import "CMLOrderObj.h"
#import "CMLOrderDefaultVC.h"
#import "CMLExchangePhyscialOrderDetailVC.h"
#import "CMLExchangeVirtualOrderDetailVC.h"

#define PageSize  10

@interface CMLMyChangeVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSNumber *datacount;

@property (nonatomic,assign) CGFloat currentCelHeight;

@end

@implementation CMLMyChangeVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self loadViews];
    
    [self.navBar setLeftBarItem];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleContent = @"我的兑换";
    self.navBar.delegate = self;
    self.page = 1;
    
    [self getCurrentCellHeight];
    
    [self loadViews];
    
    [self setNetwork];
    
    [self startLoading];
}

- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.bounces = YES;
    self.mainTableView.bouncesZoom = YES;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    /**下拉刷新*/
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (UIView *) setCurrentServeTableFooterView{

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT - self.navBar.frame.size.height)];
    footerView.backgroundColor = [UIColor CMLWhiteColor];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NoExchangeGoodsImg]];
    [bgImage sizeToFit];
    bgImage.frame = CGRectMake(WIDTH/2.0 - bgImage.frame.size.width/2.0,
                               footerView.frame.size.height/2.0 - bgImage.frame.size.height/2.0 - 50*Proportion,
                               bgImage.frame.size.width,
                               bgImage.frame.size.height);
    [footerView addSubview:bgImage];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"你还没有兑换精美礼品";
    label.font = KSystemFontSize14;
    label.textColor = [UIColor CMLLineGrayColor];
    [label sizeToFit];
    label.frame = CGRectMake(footerView.frame.size.width/2.0 - label.frame.size.width/2.0,
                             CGRectGetMaxY(bgImage.frame) + 20*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [footerView addSubview:label];
    
    return footerView;
    
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *identifier = @"myCell";
    
    OwnExchangeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[OwnExchangeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    if (self.dataArray.count > 0) {

        CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.imageUrl = obj.coverPicThumb;
        cell.orderName = obj.title;
        cell.price = obj.point;
        cell.orderId = obj.orderInfo.orderId;
        cell.expressStatus = obj.orderInfo.expressStatus;
        cell.expressUrl = obj.orderInfo.expressUrl;
        [cell refreshCurrentCell];
        
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        return self.currentCelHeight;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
    if ([obj.isPhysicalObject intValue] == 1) {
        
        CMLExchangePhyscialOrderDetailVC * vc  = [[CMLExchangePhyscialOrderDetailVC alloc] initWithOrderId:obj.orderInfo.orderId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
    
        CMLExchangeVirtualOrderDetailVC * vc  = [[CMLExchangeVirtualOrderDetailVC alloc] initWithOrderId:obj.orderInfo.orderId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }

}
- (void) setNetwork{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"orderStatusType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ExchangeGiftList paraDic:paraDic delegate:delegate];
    self.currentApiName = ExchangeGiftList;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ExchangeGiftList]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.datacount = obj.retData.dataCount;
            if (self.page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            if (self.page > 1) {
                self.page--;
            }
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
        [self.mainTableView reloadData];
        if (self.dataArray.count == 0 ) {
            self.mainTableView.tableFooterView = [self setCurrentServeTableFooterView];
            self.mainTableView.bounces = NO;
            self.mainTableView.bouncesZoom = NO;
        }else{
            self.mainTableView.tableFooterView = [[UIView alloc] init];
            self.mainTableView.bounces = YES;
            self.mainTableView.bouncesZoom = YES;
        }
    }
    
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if (self.page > 1) {
        self.page--;
    }
    [self showNetErrorTipOfNormalVC];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self setNetwork];
    
}



#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:ExchangeGiftList]) {
        
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != [self.datacount intValue]) {
                self.page++;
                [self setNetwork];
                
            }else{
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void) getCurrentCellHeight{
    
    OwnExchangeTVCell *cell = [[OwnExchangeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell.imageUrl = @"";
    cell.orderName = @"测试";
    cell.price = [NSNumber numberWithInt:1];
    cell.orderId = @"测试";
    [cell refreshCurrentCell];
    self.currentCelHeight = cell.cellHeight;
}
@end
