//
//  CMLGainPointsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGainPointsVC.h"
#import "VCManger.h"
#import "CMLGainPointsTVCell.h"
#import "CMLIntegralModuleObj.h"
#import "GainPointsShadowView.h"
#import "CMLInviteFriendsVC.h"
#import "CMLSearchGoodsVC.h"
#import "NewPersonDetailInfoVC.h"
#import "MJRefresh.h"

@interface CMLGainPointsVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *pointsTableView;

@end

@implementation CMLGainPointsVC

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = @"赚积分";
    [self.navBar setLeftBarItem];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    
    [self loadViews];
    
    [self startLoading];
    [self setNetworkRequest];
    
}

- (void)loadViews {

    self.pointsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                        style:UITableViewStylePlain];
    self.pointsTableView.delegate = self;
    self.pointsTableView.dataSource = self;
    self.pointsTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.pointsTableView.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)){
        self.pointsTableView.estimatedRowHeight = 0;
        self.pointsTableView.estimatedSectionHeaderHeight = 0;
        self.pointsTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.pointsTableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.pointsTableView.mj_header = header;

}

- (void) didSelectedLeftBarItem;{

    [[VCManger mainVC] dismissCurrentVC];
}


- (void) setNetworkRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:IntegrationModule paraDic:paraDic delegate:delegate];
    self.currentApiName = IntegrationModule;
    

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        return 140*Proportion;
    }else{
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        static NSString *identifier = @"myCell";
        
        CMLGainPointsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        CMLIntegralModuleObj *obj = [CMLIntegralModuleObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        if (!cell) {
            cell = [[CMLGainPointsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.title = obj.title;
        cell.desc = obj.desc;
        cell.tyoe = obj.type;
        cell.finishStatus = obj.finishStatus;
        cell.finishStatusStr = obj.finishStatusStr;
        __weak typeof (self)weakSelf = self;
        cell.touchBlock = ^(NSNumber *currentType){
        
            [weakSelf touchBtnOfGettingPointsWithType:currentType];
        
        };

        [cell refreshCurrentTVCellWithIndex:indexPath.row];
        return cell;
    }else{
    
        static NSString *identifier = @"myCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        
        return cell;
    }

}


#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:IntegrationModule]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            
            [self.pointsTableView reloadData];
        }
    }else if ([self.currentApiName isEqualToString:IntegrationSign]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
           
            [self showSigninSuccessViewWithDays:obj.retData.totalSignDays andPoints:obj.retData.points]; 
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserCenterView" object:nil];
            
            [self setNetworkRequest];
            
        }
        
    }
    [self stopLoading];
    [self stopIndicatorLoading];
    [self hideNetErrorTipOfNormalVC];
    [self.pointsTableView.mj_header endRefreshing];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showNetErrorTipOfNormalVC];
    [self.pointsTableView.mj_header endRefreshing];
    
}

#pragma mark - touchBlock
- (void) touchBtnOfGettingPointsWithType:(NSNumber *)type{

    switch ([type intValue]) {
        case 1:
            [self enterInviteFriendsVC];
            break;
        case 2:
            
            [self signInRequest];
            break;
        case 3:
            
            [self enterPersonalVC];
            break;
        case 4:
            [self backToRootVC];
            break;
        case 5:
            
            [self backToRootVC];
            break;
        case 6:
            [self enterGoodsVC];
            break;
        case 7:
            [self showServeVC];
            break;
            
        default:
            break;
    }
}

- (void) enterInviteFriendsVC{

    CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
- (void) signInRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:IntegrationSign paraDic:paraDic delegate:delegate];
    self.currentApiName = IntegrationSign;
    [self stopIndicatorLoading];
}

- (void) showSigninSuccessViewWithDays:(NSNumber *) days andPoints:(NSNumber *) points{

    
    GainPointsShadowView *successView = [[GainPointsShadowView alloc] initWithDays:days
                                                                         andPoints:points];
    successView.frame = CGRectMake(0,
                                   0,
                                   WIDTH,
                                   HEIGHT);
    [self.contentView addSubview:successView];
}

- (void) enterPersonalVC{
    
    [self ChangePointsRequest];

    NewPersonDetailInfoVC *vc =[[NewPersonDetailInfoVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) backToRootVC{

    [[VCManger homeVC] showCurrentViewController:homeActivityTag];
    [[VCManger mainVC] popToRootVCWithAnimated];
}

- (void) enterGoodsVC{

    CMLSearchGoodsVC *vc = [[CMLSearchGoodsVC alloc] initWithSearchStr:@""];
    [[VCManger mainVC] pushVC:vc animate:YES];
}


- (void) showServeVC{

    
    [[VCManger homeVC] showCurrentViewController:homeActivityTag];
    
//    CMLNewActivityVC *vc = [VCManger homeVC].viewControllers[1];
    [[VCManger mainVC] popToRootVCWithAnimated];
    
}

- (void) pullRefreshOfHeader{

    [self setNetworkRequest];
}

- (void) ChangePointsRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ChangePointOfUser paraDic:paraDic delegate:delegate];
    self.currentApiName = ChangePointOfUser;
    
}
@end
