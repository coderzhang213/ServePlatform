//
//  CMLGoodsOrderListVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGoodsOrderListVC.h"
#import "VCManger.h"
#import "CMLOrderObj.h"
#import "MJRefresh.h"
#import "CMLOrderDefaultVC.h"
#import "CMLSubscribeDefaultVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLAppointmentObj.h"
#import "CMLGoodsOrderTVCell.h"
#import "CMLGoodsOrderDetailVC.h"
#import "GoodsModuleDetailMesObj.h"
#import "CMLOrderListObj.h"

#define PageSize  10

#define BtnBgViewHeight          60
#define BtnTAroundMargin         10


@interface CMLGoodsOrderListVC ()<NavigationBarProtocol,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *datacount;

@property (nonatomic,assign) int page;


@end

@implementation CMLGoodsOrderListVC

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    return _heightDic;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfPersonalAppointment"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfPersonalAppointment"];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"我的订单";
    self.navBar.titleColor = [UIColor CMLBlack2D2D2DColor];
    self.navBar.bottomLine.lineWidth = 1 * Proportion;
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    [self getCurrentCellHeight];
    /*********/
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadMessageOfVC];
        
    };
}

- (void) loadMessageOfVC{
    
    [self loadViews];
    [self loadData];
}

- (void) loadData{
    self.page = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

- (void) loadViews{
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.tableHeaderView = [[UIView alloc] init];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT - self.navBar.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterNoOrderImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(bgView.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 bgView.frame.size.height/2.0 - imageView.frame.size.height,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无订单";
    label.font = KSystemFontSize14;
    label.textColor = [UIColor CMLLineGrayColor];
    [label sizeToFit];
    label.frame = CGRectMake(bgView.frame.size.width/2.0 - label.frame.size.width/2.0,
                             CGRectGetMaxY(imageView.frame) + 20*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [bgView addSubview:label];
    return bgView;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        return [[self.heightDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identifier = @"mycell";
        CMLGoodsOrderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLGoodsOrderTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray.count > 0) {
 
            CMLOrderListObj *obj = [CMLOrderListObj getBaseObjFrom:self.dataArray[indexPath.row]];
            [cell refreshCurrentCell:obj];
            [self.heightDic setObject:[NSString stringWithFormat:@"%f",cell.currentHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
        }
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
        CMLGoodsOrderDetailVC * vc  = [[CMLGoodsOrderDetailVC alloc] initWithOrderId:obj.orderInfo.orderId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
}
#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - 设置请求
- (void) setOrderRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],[NSNumber numberWithInt:self.page],[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"payStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"orderStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    [NetWorkTask getRequestWithApiName:GoodsOrderList param:paraDic delegate:delegate];
    self.currentApiName = GoodsOrderList;
    
}


#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GoodsOrderList]) {
        

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
    
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
    [self hideNetErrorTipOfNormalVC];
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
        [self setOrderRequest];
    
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:GoodsOrderList]) {
        
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != [self.datacount intValue]) {
                self.page++;
                [self setOrderRequest];
                
            }else{
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void) scrollViewScrollToTop{
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) getCurrentCellHeight{
    
//    CMLGoodsOrderTVCell *cell = [[CMLGoodsOrderTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//    cell.imageUrl = @"";
//    cell.orderName = @"测试";
//    cell.price = [NSNumber numberWithInt:1];
//    cell.orderId = @"测试";
//    cell.payMoney = [NSNumber numberWithInt:1];
//    [cell refreshCurrentCell];
//    self.currentCelHeight = cell.cellHeight;
}

@end
