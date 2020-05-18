//
//  CMLStoreTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//  服务

#import "CMLStoreTableView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "MJRefresh.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "ActivityTypeObj.h"
#import "MJRefresh.h"
#import "CMLMailServeTVCell.h"
#import "CMLServeObj.h"
#import "CMLStoreRecommendView.h"
#import "CMLSelectScrollView.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "CLPlayerView.h"
#import "KrVideoPlayerController.h"

#define PageSize 10

@interface CMLStoreTableView ()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CMLStoreRecommendViewDelegate,UIScrollViewDelegate,CLTableViewCellDelegate>

@property (nonatomic,strong) CMLStoreRecommendView * storeRecommendView;


@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) CMLMailServeTVCell *cell;

@property (nonatomic,strong) KrVideoPlayerController *videoController;


@end

@implementation CMLStoreTableView

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    
    return _heightDic;
}

- (NSMutableArray *)currentDataArray{
    
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    
    return _currentDataArray;
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
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
        
        self.page = 1;
        [self setServeList];
    }
    
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.currentDataArray.count > 0) {
        
        return self.currentDataArray.count;
        
    }else{
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (self.currentDataArray.count > 0) {
        
        return [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        
    }else{
        
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.currentDataArray.count > 0) {
        
        static NSString *identifier = @"myCell";
        CMLMailServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[CMLMailServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
        cell.currentTag = (int)indexPath.row;
        cell.delegate = self;
        [cell refreshCurrent:obj];
        
        [self.heightDic setObject:[NSNumber numberWithFloat:cell.currentheight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        return cell;
        
    }else{
        
        static NSString *identifier = @"myCell2";
        
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_cell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
//        [_playerView destroyPlayer];
        [_cell showBtnView];
        [self.videoController dismiss];
        self.videoController = nil;
        _cell = nil;
   
    }
}
#pragma mark - 点击播放代理
- (void)cl_tableViewCellPlayVideoWithCell:(CMLMailServeTVCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    
    
    if (!self.videoController) {
       
        CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[cell.currentTag]];
        
        
        if ([obj.pre_video_url_suffix intValue] == 1) {
            
            self.videoController = [[KrVideoPlayerController alloc] initWithFrame:cell.imageRect];
            
        }else{
            
            
            [_cell hidenBtnView];
            self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(cell.imageRect.origin.x,
                                                                                             cell.imageRect.size.height - 40 + 30*Proportion,
                                                                                             cell.imageRect.size.width,
                                                                                             40)];
            self.videoController.videoControl.bottomBar.backgroundColor = [UIColor CMLBlackColor];
            
        }
        
        
        self.videoController.videoControl.fullScreenButton.hidden = YES;
        __weak typeof(self)weakSelf = self;
        self.videoController.view.backgroundColor = [UIColor whiteColor];
        [self.videoController setDimissCompleteBlock:^{
            
            [weakSelf.cell showBtnView];
            weakSelf.videoController = nil;
            
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            
            
            
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            
        }];
        
        [_cell addSubview:self.videoController.view]; //video 显示在 window 便于控制
        [self.videoController removeListeningRotating];
        
        if ([obj.is_video_project intValue] == 1) {
            
            self.videoController.contentURL = [NSURL URLWithString:obj.pre_video_url];
            
        }else{
            
            self.videoController.contentURL = [NSURL URLWithString:obj.video_url];
        }
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.videoController) {
         [self.videoController dismiss];
    }
   
    CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}


#pragma mark - request

- (void) setServeList{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"queryOrderId"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:2],reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask getRequestWithApiName:MailServeList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MailServeList;
    
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    
    [self setServeList];
}

- (void) loadMoreData{
    
    
    if (self.currentDataArray.count%PageSize == 0) {
        if (self.currentDataArray.count != [self.dataCount integerValue]) {
            
            self.page++;
            [self setServeList];
            
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MailServeList]){/*服务列表*/
      
       
        if (!self.storeRecommendView) {
            
            self.storeRecommendView = [[CMLStoreRecommendView alloc] initWithAttributeArray:[NSArray array]];
            self.storeRecommendView.delegate = self;
        }

        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = obj.retData.dataCount;
            
            if ( self.page == 1) {
                
                
                [self.currentDataArray removeAllObjects];
                [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
                
            }else{
                
                [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
            }
            
            [self reloadData];
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        [self.baseTableViewDlegate endRequesting];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
        [self.baseTableViewDlegate endRequesting];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - CMLStoreRecommendViewDelegate
- (void) refeshCurrentRecommendView{
    
    self.storeRecommendView.frame = CGRectMake(0,
                                               0,
                                               WIDTH,
                                               self.storeRecommendView.currentheight);
    self.tableHeaderView = self.storeRecommendView;
}

- (void) serveVerbSelect:(int) selectIndex{
    
    int queryOrderId = 0;
    
    if (selectIndex == 0) {
        
        queryOrderId = 2;
    }else if (selectIndex == 1){
        
        queryOrderId = 1;
    }else if (selectIndex == 2){
        
        queryOrderId = 3;
        
    }else if(selectIndex == 3){
        
        queryOrderId = 4;
    }
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    
    [paraDic setObject:[NSNumber numberWithInt:queryOrderId] forKey:@"queryOrderId"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:queryOrderId],reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    
    [NetWorkTask getRequestWithApiName:MailServeList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MailServeList;
    
    self.page = 1;
    
    [self.baseTableViewDlegate startRequesting];
    
}

@end
