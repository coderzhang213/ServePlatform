//
//  CMLNewVIPTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewVIPTableView.h"
#import "VCManger.h"
#import "VIPDetailObj.h"
#import "MJRefresh.h"
#import "CMLVIPTVCell.h"
#import "CMLWriteVC.h"
#import "ReplaceTVCell.h"
#import "RecommendTimeLineObj.h"
#import "CommonNumber.h"
#import "CMLTimeLineDetailMessageVC.h"
#import "CMLNewVIPTopView.h"
#import "CMLNewVIPRecommendView.h"
#import "CMLNewVipUseTimeLineTVCell.h"
#import "CMLUserProjectTVCell.h"
#import "CMLUserProjectDetailVC.h"
#import "CMLArtcticleTVCell.h"
#import "CMLUserArticleVC.h"
#import "CMLRecommendUserFooterView.h"
#import "CMLUserPushActivityTVCell.h"
#import "CMLSBUserPushGoodsTVCell.h"
#import "CMLSBUserPushServeTVCell.h"
#import "CMLUserPorjectObj.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"

#define PageSize   10

@interface CMLNewVIPTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CMLNewVIPRecommendViewDelegate,CMLRecommendUserFooterViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>


@property (nonatomic,copy) NSString *currentApiName;


@property (nonatomic,assign) int selectTableViewIndex;

@property (nonatomic,assign) CGFloat replaceCellHeight;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) CMLNewVIPRecommendView *headerView;

@property (nonatomic,strong) CMLNewVIPTopView *topView;

@property (nonatomic,strong) NSMutableArray *recommUserDataArray;

/****/

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) CGFloat activityCellHeight;

@property (nonatomic,assign) CGFloat serveCellHeight;

@property (nonatomic,assign) CGFloat goodsCellHeight;


@end

@implementation CMLNewVIPTableView

- (NSMutableArray *)currentDataArray{
    
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    return _currentDataArray;
}

- (NSMutableArray *)recommUserDataArray{

if (!_recommUserDataArray) {
    _recommUserDataArray = [NSMutableArray array];
}

return _recommUserDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        /**下拉刷新*/
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfHeader)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [self getReplaceTVCellHeight];
        
        [self loadData];
    }
    
    return self;
}

- (void)loadData {
    
    self.page = 1;
    [self getGoodsCellHeight];
    [self getServeCellHeight];
    [self getAcivityCellHeight];
    self.selectTableViewIndex = 0;
    [self topBannerRequest];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentDataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    if ([obj.rootTypeId intValue] == 2) {
        
        return  self.activityCellHeight;
        
    }else if ([obj.rootTypeId intValue] == 3){
        
        return  self.serveCellHeight;
        
    }else if ([obj.rootTypeId intValue] == 7){
        
        return self.goodsCellHeight;
    }else{
        
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    if ([obj.rootTypeId intValue] == 2) {
        
        static NSString *identifier = @"myCell4";
        CMLUserPushActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLUserPushActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
        [cell refrshCurrentTVCellOf:obj];

        return cell;
        
    }else if ([obj.rootTypeId intValue] == 3){
        
        static NSString *identifier = @"myCell3";
        CMLSBUserPushServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLSBUserPushServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CMLUserPorjectObj *obj = [CMLUserPorjectObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
        [cell refrshCurrentTVCellOf:obj];
        
        return cell;

        
    }else if ([obj.rootTypeId intValue] == 7){
        
        static NSString *identifier = @"myCell2";
        CMLSBUserPushGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLSBUserPushGoodsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


- (void) topBannerRequest{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:14] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
}

- (void) SetAllProjectRequest{
    
    if (self.selectTableViewIndex == 0) {
       
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
//        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        [NetWorkTask postResquestWithApiName:UnionAllList paraDic:paraDic delegate:delegate];
        self.currentApiName = UnionAllList;
        
    }else if (self.selectTableViewIndex == 1){
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
//        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        [NetWorkTask postResquestWithApiName:UnionList paraDic:paraDic delegate:delegate];
        self.currentApiName = UnionList;
        NSLog(@"====2");
        
    }else if (self.selectTableViewIndex == 2){
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        [paraDic setObject:[NSNumber numberWithInt:7] forKey:@"objType"];
        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
//        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        [NetWorkTask postResquestWithApiName:UnionList paraDic:paraDic delegate:delegate];
        self.currentApiName = UnionList;
        NSLog(@"====3");
        
    }
//    else if (self.selectTableViewIndex == 3){
//        
//        
//        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
//        delegate.delegate = self;
//        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//        NSString *skey = [[DataManager lightData] readSkey];
//        [paraDic setObject:skey forKey:@"skey"];
//        [paraDic setObject:[NSNumber numberWithInt:7] forKey:@"objType"];
//        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
//        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
//        [NetWorkTask postResquestWithApiName:UnionList paraDic:paraDic delegate:delegate];
//        self.currentApiName = UnionList;
//        NSLog(@"====7");
//    }
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:BannerIndex]){
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
    
            
            self.headerView = [[CMLNewVIPRecommendView alloc] init];
            self.headerView.recommend = obj;
            self.headerView.currentSelectIndex = self.selectTableViewIndex;
            
            self.headerView.delegate = self;
            [self.headerView refreshRecommendView];
            self.tableHeaderView = self.headerView;

            [self SetAllProjectRequest];
            
        }else{
            [self.baseTableViewDlegate endRequesting];
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:UnionList]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if (self.page == 1) {
            
            [self.currentDataArray removeAllObjects];
        }
        
        if ([obj.retCode intValue] == 0 && obj) {
         
            self.dataCount = [obj.retData.dataCount intValue];
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
        }
        
        [self reloadData];
        [self.baseTableViewDlegate endRequesting];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        
    }else if ([self.currentApiName isEqualToString:UnionAllList]){

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"%@", responseResult);
        if (self.page == 1) {
            
            [self.currentDataArray removeAllObjects];
        }
        
        if ([obj.retCode intValue] == 0 && obj) {
            self.dataCount = [obj.retData.dataCount intValue];
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
        }
        
        if (self.currentDataArray.count == 0) {
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2.0)];
            bgView.backgroundColor = [UIColor CMLWhiteColor];
            
            UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewTimeLineRecordIdImg]];
            [bgView sizeToFit];
            bgImage.frame = CGRectMake(WIDTH/2.0 - bgImage.frame.size.width/2.0,
                                       50*Proportion,
                                       bgImage.frame.size.width,
                                       bgImage.frame.size.height);
            [bgView addSubview:bgImage];
            
            UILabel *promLab = [[UILabel alloc] init];
            promLab.text = @"暂无相关内容";
            promLab.font = KSystemFontSize13;
            [promLab sizeToFit];
            promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                       CGRectGetMaxY(bgImage.frame) + 20*Proportion,
                                       promLab.frame.size.width,
                                       promLab.frame.size.height);
            [bgView addSubview:promLab];
            
            self.tableFooterView = bgView;
            
        }else{
            
            self.tableFooterView = [[UIView alloc] init];
            [self.mj_footer endRefreshingWithNoMoreData];
        }

        
        [self reloadData];
        [self.baseTableViewDlegate endRequesting];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        
    }else if ([self.currentApiName isEqualToString:UnionList]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
        }
        
        if (self.currentDataArray.count == 0) {
        
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2.0)];
            bgView.backgroundColor = [UIColor CMLWhiteColor];
            
            UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewTimeLineRecordIdImg]];
            [bgView sizeToFit];
            bgImage.frame = CGRectMake(WIDTH/2.0 - bgImage.frame.size.width/2.0,
                                       50*Proportion,
                                       bgImage.frame.size.width,
                                       bgImage.frame.size.height);
            [bgView addSubview:bgImage];
            
            UILabel *promLab = [[UILabel alloc] init];
            promLab.text = @"暂无相关内容";
            promLab.font = KSystemFontSize13;
            [promLab sizeToFit];
            promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                       CGRectGetMaxY(bgImage.frame) + 20*Proportion,
                                       promLab.frame.size.width,
                                       promLab.frame.size.height);
            [bgView addSubview:promLab];
            
            self.tableFooterView = bgView;
        
        }else{
            
            self.tableFooterView = [[UIView alloc] init];
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    
        
        [self reloadData];
        [self.baseTableViewDlegate endRequesting];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        
    }


}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if (self.page > 1) {
        
        self.page --;
    }
    [self.VIPTableViewDelegate tableViewNetError];
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.baseTableViewDlegate endRequesting];
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
    
}
#pragma mark - loadMoreData
- (void) loadMoreData{
        
        if (self.currentDataArray.count < self.dataCount) {
            if (self.currentDataArray.count != self.dataCount) {
                self.page++;
                [self SetAllProjectRequest];
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
            
        }
        
}

#pragma mark - pullRefreshOfHeader
- (void)pullRefreshOfHeader {
    
    self.page = 1;
    
    [self topBannerRequest];
}

- (void) getReplaceTVCellHeight{
    
    ReplaceTVCell *cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    [cell reloadCurrentCell];
    self.replaceCellHeight = cell.cellheight;
}

#pragma mark - CMLNewVIPRecommendViewDelegate
- (void) selectListIndex:(int) index{
    
    self.selectTableViewIndex = index;
    [self.baseTableViewDlegate startRequesting];
    [self SetAllProjectRequest];
    [self.mj_footer endRefreshing];
    [self.VIPTableViewDelegate tableViewSelctIndex:self.selectTableViewIndex];
}

- (void) setFooterView{
    
    CMLRecommendUserFooterView *recommendUserFooterView = [[CMLRecommendUserFooterView alloc] init];
    recommendUserFooterView.delegate = self;
    self.tableFooterView = recommendUserFooterView;
}

#pragma mark - CMLNewVIPRecommendViewDelegate

- (void) refreshCurrentVC{
    
    [self pullRefreshOfHeader];
}


#pragma mark - CMLRecommendUserFooterViewDelegate

- (void) refershCurrentVCData{
    
    [self pullRefreshOfHeader];
    
}

-(void)initRecommendUserFooterView:(UIView *)currentView{
    
    self.tableFooterView = currentView;
}

- (void) setAlterViewWithTimeLineId:(NSNumber *) timeLineId{
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认举报该内容"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
    alterView.tag = [timeLineId integerValue];
    alterView.delegate=  self;
    [self addSubview:alterView];
    [alterView show];
    
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self.baseTableViewDlegate showAlterView:@"举报成功，工作人员会尽快处理"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (self.contentOffset.y > self.headerView.selctTopY) {
        
        [self.VIPTableViewDelegate showSelectView:NO];

    }else{
        [self.VIPTableViewDelegate showSelectView:YES];
    }
    
}

- (void) refreshNewVIPTableViewIndex:(int) index{
    
    [self.mj_footer endRefreshing];
    self.contentOffset = CGPointMake(0, 0);
    self.selectTableViewIndex = index;
    self.tableFooterView = [[UIView alloc] init];
    [self.baseTableViewDlegate startRequesting];
    [self pullRefreshOfHeader];

    self.headerView.currentSelectIndex = self.selectTableViewIndex;
    [self.headerView refreshRecommendView];
    
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
@end
