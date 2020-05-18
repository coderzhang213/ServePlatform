//
//  CMLV3PersonalHomepageVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVIPNewDetailVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "GetCodeVC.h"
#import "PerfectInfoVC.h"
#import "CMLNewVipUseTimeLineTVCell.h"
#import "CMLUserProjectTVCell.h"
#import "RecommendTimeLineObj.h"
#import "ReplaceTVCell.h"
#import "CMLV3HomePageTopMessageView.h"
#import "MJRefresh.h"
#import "CustomTransition.h"
#import "DefaultTransition.h"
#import "UpGradeVC.h"
#import "LMWordViewController.h"
#import "LMWordViewOfGoodsController.h"
#import "NewCardView.h"
#import "CMLTimeLineDetailMessageVC.h"
#import "CMLUserProjectDetailVC.h"
#import "CMLWriteVC.h"
#import "CMLArtcticleTVCell.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityTVCell.h"
#import "CMLSBUserPushGoodsTVCell.h"
#import "CMLSBUserPushServeTVCell.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import "PackageInfoObj.h"

#define PageSize  10
#define CardBtnHeight 38
#define CardBtnWidth  116
#define LeftMargin    30

@interface CMLVIPNewDetailVC ()<NetWorkProtocol,NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,CMLV3HomePageTopMessageViewDelegate,PushProjectDelegate,NewCardViewDelegate,WriteDelegate,UIAlertViewDelegate, CMLUserPushActivityTVCellDelegate, CMLSBUserPushGoodsTVCellDelegate, CMLSBUserPushServeTVCellDelegate>


@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,assign) BOOL isReturnUpOneLevel;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableDictionary *isRequestDic;

@property (nonatomic,strong) BaseResultObj *userObj;

@property (nonatomic,strong) UIView *moreView;

/****/
@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) CGFloat activityCellHeight;

@property (nonatomic,assign) CGFloat serveCellHeight;

@property (nonatomic,assign) CGFloat goodsCellHeight;

@property (nonatomic, strong) NSNumber *objId;

@property (nonatomic, strong) NSNumber *rootTypeId;

@property (nonatomic, strong) CMLUserPorjectObj *obj;

@property (nonatomic, assign) NSIndexPath *deleteIndexPath;

@end

@implementation CMLVIPNewDetailVC

- (NSMutableArray *)currentDataArray{
    
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    return _currentDataArray;
}


- (NSMutableDictionary *)isRequestDic{

    if (!_isRequestDic) {
        _isRequestDic = [NSMutableDictionary dictionary];
    }
    
    return _isRequestDic;
}

- (instancetype)initWithNickName:(NSString *) nickName currnetUserId:(NSNumber *) userId isReturnUpOneLevel:(BOOL) isReturnUpOneLevel{
    
    self = [super init];
    
    if (self) {
        self.nickName = nickName;
        self.userId = userId;
        self.isReturnUpOneLevel = isReturnUpOneLevel;
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    [self.navBar hiddenLine];
    [self.navBar setLeftBarItem];
    
//    if ([self.userId intValue] != [[[DataManager lightData] readUserID] intValue]) {
//        
//        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
//                                                                         StatusBarHeight,
//                                                                         NavigationBarHeight,
//                                                                         NavigationBarHeight)];
//        moreBtn.backgroundColor = [UIColor clearColor];
//        [moreBtn setImage:[UIImage imageNamed:AddBlackListImg] forState:UIControlStateNormal];
//        [self.navBar addSubview:moreBtn];
//        [moreBtn addTarget:self action:@selector(showMoreAction) forControlEvents:UIControlEventTouchUpInside];
//        
//
//    }else{
//        
//        
//        
//        UIButton *writeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
//                                                                        StatusBarHeight,
//                                                                        NavigationBarHeight,
//                                                                        NavigationBarHeight)];
//        writeBtn.backgroundColor = [UIColor clearColor];
//        [writeBtn setImage:[UIImage imageNamed:NewPushTimeLineImg] forState:UIControlStateNormal];
//        [self.navBar addSubview:writeBtn];
//        [writeBtn addTarget:self action:@selector(enterPushTimeline) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//    }
    
    [self getGoodsCellHeight];
    
    [self getServeCellHeight];
    
    [self getAcivityCellHeight];

    self.page = 1;
    
    [self loadViews];
    
    [self startLoading];
    
    [self setVIPDetailMesRequest];
}

- (void) setVIPDetailMesRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.userId forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.userId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:NewMemberUser paraDic:paraDic delegate:delegate];
    self.currentApiName = NewMemberUser;
    
}

- (void) setUserProjectRequest{
    
    if ([self.userObj.retData.user.isHaveProject intValue] == 0 && [self.userObj.retData.user.isHaveGoods intValue] == 0  && [self.userObj.retData.user.isHaveActivity intValue] == 0 ) {
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }else{
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        if (self.selectTableViewIndex == 0) {
            [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
            
        }else if(self.selectTableViewIndex == 1){
            [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objType"];
        }else{
            
            [paraDic setObject:[NSNumber numberWithInt:7] forKey:@"objType"];
        }
        
        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
        
        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        
        [paraDic setObject:self.userId forKey:@"userId"];
        
        [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"localId"];
        
        NSString *skey = [[DataManager lightData] readSkey];
        
        [paraDic setObject:skey forKey:@"skey"];
       
        [NetWorkTask postResquestWithApiName:UserPushProjectList paraDic:paraDic delegate:delegate];
         self.currentApiName = UserPushProjectList;

        [self startLoading];
    
    }
}

- (void)setGoodsDetailRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.objId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:@"1" forKey:@"getContent"];
    [NetWorkTask postResquestWithApiName:GoodsDetailMessage paraDic:paraDic delegate:delegate];
    self.currentApiName = GoodsDetailMessage;
    [self startLoading];
}

- (void)setActivityDetailRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.objId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:@"1" forKey:@"getContent"];
    [NetWorkTask postResquestWithApiName:ActivityInfo paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityInfo;
    [self startLoading];
}

- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight) style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
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
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    
    /******************/
    self.moreView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             HEIGHT,
                                                             WIDTH,
                                                             HEIGHT)];
    self.moreView.backgroundColor = [[UIColor CMLBlackColor]colorWithAlphaComponent:0.5 ];
    [self.view addSubview:self.moreView];
    
    UIButton *addBlackListBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                           HEIGHT - 80*Proportion - SafeAreaBottomHeight,
                                                                           WIDTH,
                                                                           80*Proportion)];
    [addBlackListBtn setTitle:@"拉黑" forState:UIControlStateNormal];
    [addBlackListBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    addBlackListBtn.backgroundColor = [UIColor CMLWhiteColor];
    addBlackListBtn.titleLabel.font = KSystemFontSize13;
    [self.moreView addSubview:addBlackListBtn];
    [addBlackListBtn addTarget:self action:@selector(addBlackListAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *letterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                     HEIGHT - 160*Proportion - SafeAreaBottomHeight,
//                                                                     WIDTH,
//                                                                     80*Proportion)];
//    [letterBtn setTitle:@"私信" forState:UIControlStateNormal];
//    [letterBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
//    letterBtn.backgroundColor = [UIColor CMLWhiteColor];
//    letterBtn.titleLabel.font = KSystemFontSize13;
//    [self.moreView addSubview:letterBtn];
//    [letterBtn addTarget:self action:@selector(contactVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    CMLLine *centerLine = [[CMLLine alloc] init];
    centerLine.startingPoint = CGPointMake(0, HEIGHT - 80*Proportion - SafeAreaBottomHeight);
    centerLine.LineColor = [UIColor CMLNewGrayColor];
    centerLine.lineWidth = 1;
    centerLine.lineLength = WIDTH;
    [self.moreView addSubview:centerLine];
    if ([[[DataManager lightData] readBlockListStatus] intValue] == 2) {
        
//        letterBtn.frame = CGRectMake(0,
//                                     HEIGHT - 80*Proportion - SafeAreaBottomHeight,
//                                     WIDTH,
//                                     80*Proportion);
        centerLine.hidden = YES;
        addBlackListBtn.hidden = YES;
    }

    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.currentDataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectTableViewIndex == 0) {
        
        if (self.currentDataArray.count > 0) {
            
            return self.activityCellHeight;
        }else{
            
            return 0;
        }

    }else if (self.selectTableViewIndex == 1){

        if (self.currentDataArray.count > 0) {
            
            return self.serveCellHeight;
        }else{
            
            return 0;
        }
    }else{
        
        if (self.currentDataArray.count > 0) {
            
            return self.goodsCellHeight;
        }else{
            
            return 0;
        }
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.selectTableViewIndex == 0){/*活动*/
        
        if (self.currentDataArray.count > 0) {
            
            static NSString *identifier = @"myCell4";
            CMLUserPushActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.delegate = self;
            if (!cell) {
                cell = [[CMLUserPushActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.isEdit = YES;
            cell.cellIndexPath = indexPath;
            CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
            [cell refrshCurrentTVCellOf:obj];
            
            return cell;

        }else{
            
            static NSString *identifier = @"myCell0";
            ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell reloadCurrentCell];
            return cell;
        }
        
    } else if(self.selectTableViewIndex == 1){/*服务*/
        
        if (self.currentDataArray.count > 0) {
            static NSString *identifier = @"myCell3";
            CMLSBUserPushServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLSBUserPushServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.isEdit = YES;
            cell.cellIndexPath = indexPath;
            CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
            [cell refrshCurrentTVCellOf:obj];
            
            return cell;
        }else{
            
            static NSString *identifier = @"myCell0";
            ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            [cell reloadCurrentCell];
            return cell;
        }
    }else{/*商品*/
        
        if (self.currentDataArray.count > 0) {
            static NSString *identifier = @"myCell2";
            CMLSBUserPushGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLSBUserPushGoodsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            cell.isEdit = YES;
            cell.cellIndexPath = indexPath;
            CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
            [cell refrshCurrentTVCellOf:obj];
            
            return cell;
        }else{
            
            static NSString *identifier = @"myCell0";
            ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell reloadCurrentCell];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    if ([obj.rootTypeId intValue] == 2) {
        
        CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:obj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([obj.rootTypeId intValue] == 3){
        
        CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:obj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        
        CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:obj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}

/*Cell侧滑*
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"  确认删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
            self.deleteIndexPath = indexPath;
            
            [self requestSlideDeleteDataWithIndexPath:indexPath];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];

    }];
    
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self leftSlideEditWithIndexPath:indexPath];
        NSLog(@"编辑");
    }];
    
    return @[deleteRowAction, editRowAction];
}
*/

/*返回侧滑删除数据*/
- (void)requestSlideDeleteDataWithIndexPath:(NSIndexPath *)indexPath {
    
    CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"userId"];
    [paraDic setObject:obj.rootTypeId forKey:@"objType"];
    [paraDic setObject:obj.objId forKey:@"objId"];
    
    [NetWorkTask postResquestWithApiName:ReleaseDelete paraDic:paraDic delegate:delegate];
    self.currentApiName = ReleaseDelete;
    [self startLoading];
    
}

/*侧滑编辑*/
- (void)leftSlideEditWithIndexPath:(NSIndexPath *)indexPath {
    
    CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    self.objId = obj.objId;
    if ([obj.rootTypeId intValue] == 2) {
        [self setActivityDetailRequest];
    }else {
        [self setGoodsDetailRequest];
    }
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewMemberUser]) {
        /**打点*/
        [CMLMobClick VIPShowEvent];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.userObj = obj;
            
            if ([self.userObj.retData.user.isHaveActivity intValue] == 1) {
                
                self.selectTableViewIndex = 0;
            }else{
                
                if ([self.userObj.retData.user.isHaveProject intValue] == 1) {
                    
                    self.selectTableViewIndex = 1;
                }else{
                    
                    self.selectTableViewIndex = 2;
                }
            }
            
            CMLV3HomePageTopMessageView *topiew = [[CMLV3HomePageTopMessageView alloc] initWithObj:obj];
            topiew.delegate = self;
            topiew.selectIndex = self.selectTableViewIndex;
            [topiew refreshCurrentHomePageView];
            self.mainTableView.tableHeaderView = topiew;
            
            if ([self.userObj.retData.user.isHaveProject intValue] == 0 && [self.userObj.retData.user.isHaveGoods intValue] == 0  && [self.userObj.retData.user.isHaveActivity intValue] == 0 ) {
                
                [self.mainTableView reloadData];
                self.mainTableView.tableFooterView = [self setTableViewFooterView];
                [self stopLoading];
            }else{
                
                [self setUserProjectRequest];
            }
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else if ([obj.retCode intValue] == 100327){
            
            [self showFailTemporaryMes:obj.retMsg];
            [[VCManger mainVC] dismissCurrentVC];
            [self stopLoading];
            
        }else{
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
            
        }
    }else if ([self.currentApiName isEqualToString:UserPushProjectList]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"商品列表：%@", responseResult);

        if ([obj.retCode intValue] == 0 && obj) {
        
            if (self.page == 1) {
                
                [self.currentDataArray removeAllObjects];
            }
            
            self.dataCount = [obj.retData.dataCount intValue];
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];

            [self.mainTableView reloadData];
            
            if (self.currentDataArray.count == 0) {
                
                self.mainTableView.tableFooterView = [self setTableViewFooterView];
            }else{
                
                self.mainTableView.tableFooterView = [[UIView alloc] init];
            }
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
        }
        [self stopLoading];
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
    } else if ([self.currentApiName isEqualToString:AddBlackList]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.delegate refreshCurrentViewController];
            [[VCManger mainVC] dismissCurrentVC];
        
        }
    }else if ([self.currentApiName isEqualToString:ReleaseDelete]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            [self.currentDataArray removeObjectAtIndex:self.deleteIndexPath.row];
            [self.mainTableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self showSuccessTemporaryMes:@"删除成功"];
        }else {
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:GoodsDetailMessage]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];

        if ([obj.retCode intValue] == 0) {
            
            if ([obj.retData.rootTypeId intValue] == 2) {
                /*活动2*/
                LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
                vc.currentType = 1;
                vc.obj = obj;
                vc.isEdit = YES;
                vc.objId = obj.retData.currentID;
                [[VCManger mainVC] pushVC:vc animate:YES];
        
            }else if ([obj.retData.rootTypeId intValue] == 7) {
                /*单品7*/
                LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
                vc.currentType = 2;
                vc.obj = obj;
                vc.isEdit = YES;
                vc.objId = obj.retData.currentID;
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            
        }else {
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
        
    }else if ([self.currentApiName isEqualToString:ActivityInfo]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            if ([obj.retData.rootTypeId intValue] == 2) {
                /*活动2*/
                LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
                vc.currentType = 1;
                vc.obj = obj;
                vc.isEdit = YES;
                vc.objId = obj.retData.currentID;
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([obj.retData.rootTypeId intValue] == 7) {
                /*单品7*/
                LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
                vc.currentType = 2;
                vc.obj = obj;
                vc.isEdit = YES;
                vc.objId = obj.retData.currentID;
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
        
        }else {
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
        
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}


- (void) didSelectedLeftBarItem{

    if (self.isReturnUpOneLevel) {
        
        [[VCManger mainVC] dismissCurrentVC];
        
    }else{
        
        
        NSArray *array = [VCManger mainVC].viewControllers;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            
            if ([array[i] isKindOfClass:[GetCodeVC class]] || [array[i] isKindOfClass:[PerfectInfoVC class]]) {
                
            }else{
                [tempArray addObject:array[i]];
            }
        }
        [[VCManger mainVC] setViewControllers:tempArray];
        
        
        [[VCManger mainVC] popToRootVCWithAnimated];
    }

}

#pragma mark - loadMoreData
- (void) loadMoreData{

        if (self.currentDataArray.count%PageSize == 0) {
            if ((int)self.currentDataArray.count != self.dataCount) {
                self.page++;
                [self setUserProjectRequest];
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    self.page = 1;
    
    [self setUserProjectRequest];
}

- (void) setAlterViewWithTimeLineId:(NSNumber *) timeLineId{
    
    if ([self.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确定删除吗？"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        alterView.tag = [timeLineId integerValue];
        [self.view addSubview:alterView];
        [alterView show];
    }else{
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认举报该内容"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:@"取消", nil];
        alterView.tag = [timeLineId integerValue];
        alterView.delegate=  self;
        [self.view addSubview:alterView];
        [alterView show];
        
    }

}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (alertView.tag == 100) {
//
//        if (buttonIndex == 0) {
//
//            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
//            delegate.delegate = self;
//
//            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//            NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
//            [paraDic setObject:reqTime forKey:@"reqTime"];
//            [paraDic setObject:self.userId forKey:@"objId"];
//            NSString *skey = [[DataManager lightData] readSkey];
//            [paraDic setObject:skey forKey:@"skey"];
//            NSString *hashToken = [NSString getEncryptStringfrom:@[self.userId,reqTime,skey]];
//            [paraDic setObject:hashToken forKey:@"hashToken"];
//            [NetWorkTask postResquestWithApiName:AddBlackList paraDic:paraDic delegate:delegate];
//            self.currentApiName = AddBlackList;
//
//            [self startIndicatorLoading];
//        }
//
//
//    }else{
//
//        if ([self.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
//
//            if (buttonIndex == 0) {
//
//                [self delegateTimeLine:[NSNumber numberWithInteger:alertView.tag]];
//            }
//        }else{
//
//            if (buttonIndex == 0) {
//
//                [self showAlterViewWithText:@"举报成功，工作人员会尽快处理"];
//            }
//        }
//    }
//}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return [CustomTransition transitionWith:PushCustomTransition];
        
    }else{
        
        return [DefaultTransition transitionWith:PopDefaultTransition];
        
    }
    
}


#pragma mark - CMLV3HomePageTopMessageViewDelegate
- (void) refreshCurrentVC{

    if (self.delegate) {
     
        [self.delegate refreshCurrentViewController];
    }
    
    [self setVIPDetailMesRequest];
}

- (void) selectCurrentType:(int) index{

    self.selectTableViewIndex = index;

    [self setUserProjectRequest];
}

- (UIView *) setTableViewFooterView{

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];

        
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NoProjectImg]];
    [bgView sizeToFit];
    bgImage.frame = CGRectMake(WIDTH/2.0 - bgImage.frame.size.width/2.0,
                               50*Proportion,
                               bgImage.frame.size.width,
                               bgImage.frame.size.height);
    [bgView addSubview:bgImage];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.text = @"没有发布任何项目哦";
    promLab.font = KSystemFontSize13;
    [promLab sizeToFit];
    promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                               CGRectGetMaxY(bgImage.frame) + 20*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [bgView addSubview:promLab];
        

    return bgView;
}

- (void) enterUpGradeVC{

    UpGradeVC *vc = [[UpGradeVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];

}

- (void) enterPushProject{

    LMWordViewController *vc = [[LMWordViewController alloc] init];
    vc.isUserVC = YES;
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterPushTimeline{
    
    CMLWriteVC *vc = [[CMLWriteVC alloc] init];
    vc.isDismissPop = YES;
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}
- (void) refreshVC{

    [self setUserProjectRequest];
}

- (void) showCardView{

    NewCardView *cardView = [[NewCardView alloc] init];
    cardView.userID = self.userObj.retData.user.uid;
    cardView.userImageUrl = self.userObj.retData.user.gravatar;
    cardView.nickName = self.userObj.retData.user.nickName;
    cardView.memeberLvl = self.userObj.retData.user.memberLevel;
    cardView.delegate = self;
    [cardView setCardView];
    
    [self.contentView addSubview:cardView];
    
}

#pragma mark - NewCardViewDelegate

- (void) startNewCardLoading{

    [self startLoading];
}

- (void) endNewCardLoading{

    [self stopLoading];
}

- (void) saveCurrentNewCardView:(NSString *) msg{
    
    if ([msg isEqualToString:@"存图片失败"]) {
        
        [self showFailTemporaryMes:@"保存失败"];
    }else{
    
        [self showSuccessTemporaryMes:@"保存成功"];
        
    }

}

- (void) addBlackListAction{
   
    
    self.moreView.frame = CGRectMake(0,
                                     HEIGHT,
                                     WIDTH,
                                     HEIGHT);
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认拉黑该用户"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
    alterView.delegate=  self;
    alterView.tag = 100;
    [self.view addSubview:alterView];
    [alterView show];
    
}


- (void) showMoreAction{
 
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        
        weakSelf.moreView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             HEIGHT);
    }];
    
}

- (void) refreshVIPDetailVC{
    
   [self setUserProjectRequest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        
        weakSelf.moreView.frame = CGRectMake(0,
                                             HEIGHT,
                                             WIDTH,
                                             HEIGHT);
    }];
}

- (void) getAcivityCellHeight{
    
    CMLUserPushActivityTVCell *cell = [[CMLUserPushActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test1"];
    self.activityCellHeight = [cell getCurrentHeigth];
    
}

- (void) getServeCellHeight{
    
    CMLSBUserPushServeTVCell *cell = [[CMLSBUserPushServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test2"];
    self.serveCellHeight = [cell getCurrentHeigth];
    
}

- (void) getGoodsCellHeight{
    
    CMLSBUserPushGoodsTVCell *cell = [[CMLSBUserPushGoodsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test3"];
    self.goodsCellHeight = [cell getCurrentHeigth];
    
}

#pragma cellDelegate
- (void)deleteActivityWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"  确认删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.deleteIndexPath = indexPath;
        
        [self requestSlideDeleteDataWithIndexPath:indexPath];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

    
    
}

- (void)editActivityWithIndexPath:(NSIndexPath *)indexPath {
    
    [self leftSlideEditWithIndexPath:indexPath];
    
}

/*商品*/
- (void)deleteGoodsTVCellWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"  确认删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.deleteIndexPath = indexPath;
        
        [self requestSlideDeleteDataWithIndexPath:indexPath];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)editGoodsTVCellWithIndexPath:(NSIndexPath *)indexPath {
    
    [self leftSlideEditWithIndexPath:indexPath];
    
}

@end
