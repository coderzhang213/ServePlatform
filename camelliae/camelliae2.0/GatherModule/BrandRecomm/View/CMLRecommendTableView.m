//
//  CMLRecommendTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRecommendTableView.h"
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
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "CMLRecommendTVCell.h"
#import "ServeRecommedUserObj.h"
#import "CMLVIPNewDetailVC.h"
#import <AVFoundation/AVFoundation.h>

#define PageSize 10

@interface CMLRecommendTableView ()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSNumber *brandID;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) AVPlayer *player;

@end

@implementation CMLRecommendTableView

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

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andBrandID:(NSNumber *) brandID andType:(NSNumber *) type{
    
    self = [super initWithFrame:frame style:style];
    
    self.brandID = brandID;
    self.type = type;
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
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
        
        [self loadData];
        
    }
    
    return self;
}


- (void) loadData{
    
    self.page = 1;
    [self setRecommendList];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count > 0) {
        
        return self.dataArray.count;

    }else{
        
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
      
        return [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
    }else{
        
         return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        
        static NSString *identifier = @"myCell1";
        
        CMLRecommendTVCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[CMLRecommendTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ServeRecommedUserObj *obj = [ServeRecommedUserObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.tag = indexPath.row;
        [cell refreshCurrentCell:obj];
        
        __weak typeof(self) weakSelf = self;
        cell.deleteCurrentLineBlock = ^(NSNumber *currentID){
            
            [weakSelf setDeleteRecommendRequest:currentID];
            
        };
        
        cell.playVideoBlock = ^(NSInteger currentTag){
            
            [weakSelf showVideo:currentTag];
            
        };
        [self.heightDic setObject:[NSString stringWithFormat:@"%f",cell.currentHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    


}


#pragma mark - request

- (void) setRecommendList{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:self.brandID
                forKey:@"objId"];
    [paraDic setObject:self.type
                forKey:@"objType"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.brandID,
                                                           self.type,
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask getRequestWithApiName:MailAllRecommList
                                 param:paraDic
                              delegate:delegate];
    
    self.currentApiName = MailAllRecommList;
}

- (void) setDeleteRecommendRequest:(NSNumber *) currentID{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:currentID
                forKey:@"objId"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[currentID,
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MailDeleteRecomm paraDic:paraDic delegate:delegate];
    self.currentApiName = MailDeleteRecomm;
    [self.baseTableViewDlegate startRequesting];
}


- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setRecommendList];
}

- (void) loadMoreData{
    
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount integerValue]) {
            
            self.page++;
            [self setRecommendList];
            
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
    
    if ([self.currentApiName isEqualToString:MailAllRecommList]) {
     
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            
            self.dataCount = obj.retData.dataCount;
            if (self.page == 1) {
                
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            
            [self reloadData];
            
        }else{
            
            [self.baseTableViewDlegate endRequesting];
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        [self.baseTableViewDlegate endRequesting];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
    }else{
       
         BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.baseTableViewDlegate endRequesting];
            
            [self pullRefreshOfHeader];
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        
    }
    
}




- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate endRequesting];
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败5"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void) showVideo:(NSInteger ) currentTag{
    
    ServeRecommedUserObj *obj = [ServeRecommedUserObj getBaseObjFrom:self.dataArray[currentTag]];
    NSURL * url  = [NSURL URLWithString:obj.videoUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [self.player play];
    
}


- (void) stopVideo{
    
    if (self.player) {
        
        [self.player pause];
    }
}
@end
