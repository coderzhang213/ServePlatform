//
//  CMLPersonalCenterOrderVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonalCenterOrderVC.h"
#import "VCManger.h"
#import "CMLOrderTVCell.h"
#import "CMLOrderObj.h"
#import "MJRefresh.h"
#import "CMLOrderDefaultVC.h"
#import "CMLSubscribeDefaultVC.h"
#import "CMLAppointmentObj.h"
#import "CMLInvitationView.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"


#define PageSize  10

#define BtnBgViewHeight          60
#define BtnTAroundMargin         10


@interface CMLPersonalCenterOrderVC ()<NavigationBarProtocol,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource,InvitationViewDelegate,CMLSubscribeDefaultVCDelegate>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *datacount;

@property (nonatomic,assign) CGFloat currentCelHeight;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) UIButton *activityBtn;

@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong) UIView *selectLine;

@property (nonatomic,strong) CMLInvitationView *invitationView;

@property (nonatomic,assign) int type;


@end

@implementation CMLPersonalCenterOrderVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfPersonalOrder"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfPersonalOrder"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"我的预订";
    self.navBar.titleColor = [UIColor CMLBlack2D2D2DColor];
    self.navBar.bottomLine.lineWidth = 1 * Proportion;
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    [self getCurrentCellHeight];
    self.type = 1;
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
  
        UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                     WIDTH,
                                                                     BtnBgViewHeight*Proportion)];
        btnBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:btnBgView];
        
        self.activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(BtnTAroundMargin*Proportion,
                                                                      BtnTAroundMargin*Proportion,
                                                                      WIDTH/2.0 - 2*BtnTAroundMargin*Proportion,
                                                                      BtnBgViewHeight*Proportion - 2*BtnTAroundMargin*Proportion)];
        self.activityBtn.titleLabel.font = KSystemFontSize14;
        [self.activityBtn setTitle:@"精彩活动" forState:UIControlStateNormal];
        [self.activityBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [self.activityBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        self.activityBtn.selected = YES;
        [self.activityBtn addTarget:self action:@selector(changeActivityList) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:self.activityBtn];
        
        self.serveBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - BtnTAroundMargin*Proportion - self.activityBtn.frame.size.width,
                                                                     BtnTAroundMargin*Proportion,
                                                                     WIDTH/2.0 - 2*BtnTAroundMargin*Proportion,
                                                                     BtnBgViewHeight*Proportion - 2*BtnTAroundMargin*Proportion)];
        self.serveBtn.titleLabel.font = KSystemFontSize14;
        [self.serveBtn setTitle:@"高端定制" forState:UIControlStateNormal];
        [self.serveBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [self.serveBtn addTarget:self action:@selector(changeServelList) forControlEvents:UIControlEventTouchUpInside];
        [self.serveBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [btnBgView addSubview:self.serveBtn];
    
        
        UILabel *testLab = [[UILabel alloc] init];
        testLab.font = KSystemFontSize14;
        testLab.text = @"精彩活动";
        [testLab sizeToFit];
    
        self.selectLine = [[UIView alloc] initWithFrame:CGRectMake(self.activityBtn.center.x - testLab.frame.size.width/2.0,
                                                                   btnBgView.frame.size.height - 4*Proportion,
                                                                   testLab.frame.size.width,
                                                                   4*Proportion)];
        self.selectLine.backgroundColor = [UIColor CMLBrownColor];
        self.selectLine.layer.cornerRadius = 4 * Proportion/2;
        self.selectLine.clipsToBounds = YES;
        [btnBgView addSubview:self.selectLine];
        
        self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(btnBgView.frame),
                                                                           WIDTH,
                                                                           HEIGHT - CGRectGetMaxY(btnBgView.frame) - SafeAreaBottomHeight)];
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.showsVerticalScrollIndicator = NO;
        self.mainTableView.backgroundColor = [UIColor whiteColor];
        self.mainTableView.tableFooterView = [[UIView alloc] init];
        self.mainTableView.tableHeaderView = [[UIView alloc] init];
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    label.text = @"快去预定美好生活吧";
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

- (UIView *) setCurrentActivityTableFooterView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT - self.navBar.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterNoAppointmentImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(bgView.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 bgView.frame.size.height/2.0 - imageView.frame.size.height,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"有趣的活动那么多，快去预约体验吧！";
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
        return self.currentCelHeight;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.type == 2) {
     
        static NSString *identifier = @"mycell";
        CMLOrderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLOrderTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray.count > 0) {
            CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = obj.coverPic;
            cell.orderName = obj.title;
            cell.isUserPush = obj.isUserPublish;
            cell.serveTime = obj.projectDateZone;
            cell.isActivityCell = NO;
            cell.price = obj.orderInfo.payAmtE2;
            cell.isHasTimeZone = obj.isHasTimeZone;
            [cell refreshCurrentCell];
        }
        return cell;
        
    }else{
    
        static NSString *identifier = @"mycell";
        CMLOrderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLOrderTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray.count > 0) {
            CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = obj.coverPic;
            cell.orderName = obj.title;
            cell.isUserPush = obj.isUserPublish;
            cell.serveTime = obj.actDateZone;
            cell.isActivityCell = YES;
            cell.price = obj.orderInfo.payAmtE2;
            cell.isHasTimeZone = obj.isHasTimeZone;
            __weak typeof(self) weakSelf = self;
            cell.showInvitationBlock = ^(){
            
                [weakSelf setCurrentInvitationView:(int) indexPath.row];
            };
            [cell refreshCurrentCell];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 2) {
    
        CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
        CMLOrderDefaultVC * vc  = [[CMLOrderDefaultVC alloc] initWithOrderId:obj.orderInfo.orderId isDeleted:obj.isDeleted];
        [[VCManger mainVC] pushVC:vc animate:YES];

        
    }else{
        CMLOrderObj *obj = [CMLOrderObj getBaseObjFrom:self.dataArray[indexPath.row]];
        CMLSubscribeDefaultVC *vc = [[CMLSubscribeDefaultVC alloc] initWithOrderId:obj.orderInfo.orderId isDeleted:obj.isDeleted];
        vc.delegate = self;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}
#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - 设置请求（服务）
- (void) setOrderRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey =[[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],[NSNumber numberWithInt:self.page],[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"payStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"orderStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"parentType"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    [NetWorkTask postResquestWithApiName:MyOrderList paraDic:paraDic delegate:delegate];
    self.currentApiName = MyOrderList;

}

#pragma mark - 设置请求（活动）
- (void) setAppointmentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey =[[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],[NSNumber numberWithInt:self.page],[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"payStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"orderStatusType"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"parentType"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    [NetWorkTask postResquestWithApiName:MyOrderList paraDic:paraDic delegate:delegate];
    self.currentApiName = MyOrderList;
    
    
}


#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MyOrderList]) {

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
    
    if (self.activityBtn.selected) {
        self.type = 1;
        [self.dataArray removeAllObjects];
        self.page = 1;
        [self setAppointmentRequest];
    }else{
    
        self.type = 2;
        [self.dataArray removeAllObjects];
        self.page = 1;
        [self setOrderRequest];
    }
    
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:MyOrderList]) {
     
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != [self.datacount intValue]) {
                self.page++;
                if (self.type == 2) {
                    [self setOrderRequest];
                }else{
                
                    [self setAppointmentRequest];
                }
                
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

    CMLOrderTVCell *cell = [[CMLOrderTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell.orderName = @"初始化";
    cell.serveTime = @"2016.7.5 - 2016.8.5";
    cell.price = [NSNumber numberWithInt:1];
    [cell refreshCurrentCell];
    self.currentCelHeight = cell.cellHeight;
}

#pragma mark - changeHotList
- (void) changeActivityList{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        weakSelf.selectLine.frame = CGRectMake(weakSelf.activityBtn.center.x - weakSelf.activityBtn.titleLabel.frame.size.width/2.0,
                                               weakSelf.selectLine.frame.origin.y,
                                               weakSelf.activityBtn.titleLabel.frame.size.width,
                                               4*Proportion);
    }];

    
    self.activityBtn.selected = YES;
    self.serveBtn.selected = NO;
    
    [self.mainTableView.mj_header beginRefreshing];
    
}

#pragma mark - changeSpecialList
- (void) changeServelList{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{

        weakSelf.selectLine.frame = CGRectMake(weakSelf.serveBtn.center.x - weakSelf.serveBtn.titleLabel.frame.size.width/2.0,
                                               weakSelf.selectLine.frame.origin.y,
                                               weakSelf.serveBtn.titleLabel.frame.size.width,
                                               4*Proportion);
    }];

    self.serveBtn.selected = YES;
    self.activityBtn.selected = NO;
    
    [self.mainTableView.mj_header beginRefreshing];
}

- (void) setCurrentInvitationView:(int) index{

    [self.invitationView removeFromSuperview];
    
    CMLAppointmentObj *appointmentObj = [CMLAppointmentObj getBaseObjFrom:self.dataArray[index]];
    
    self.invitationView = [[CMLInvitationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.invitationView.backgroundColor = [UIColor clearColor];
    self.invitationView.delegate = self;
    self.invitationView.userName = [[DataManager lightData] readUserName];
    self.invitationView.activityTitle = appointmentObj.title;
    self.invitationView.timeZone = appointmentObj.actDateZone;
    self.invitationView.address = appointmentObj.address;
    self.invitationView.bgImageType = appointmentObj.invitation;
    self.invitationView.QRImageUrl = appointmentObj.activityQrCode;
    [self.invitationView refershInvitationView];
    [self.contentView addSubview:self.invitationView];
}

#pragma mark - InvitationViewDelegate
- (void) hiddenCurrentInvitationView{

     [self.invitationView removeFromSuperview];
}

- (void) saveCurrentInvitationView:(NSString *) str{

    if ([str hasSuffix:@"成功"]) {
       [self showSuccessTemporaryMes:str];
    }else{
    
        [self showFailTemporaryMes:str];
    }
    
}

- (void) shareCurrentInvitationView:(NSString *)str{

    if ([str hasSuffix:@"成功"]) {
        [self showSuccessTemporaryMes:str];
    }else{
        
        [self showFailTemporaryMes:str];
    }
    
}

- (void) refreshCurrentVC{

    [self.mainTableView.mj_header beginRefreshing];
}
@end
