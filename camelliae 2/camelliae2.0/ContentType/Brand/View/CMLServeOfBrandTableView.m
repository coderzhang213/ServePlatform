//
//  CMLServeOfBrandTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLServeOfBrandTableView.h"
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
#import "MJRefresh.h"
#import "CMLMailServeTVCell.h"
#import "CMLServeObj.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "CLPlayerView.h"
#import "KrVideoPlayerController.h"

#define PageSize 10

@interface CMLServeOfBrandTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,UIScrollViewDelegate,CLTableViewCellDelegate>


@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,strong) NSNumber *currentBrandID;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;


@end

@implementation CMLServeOfBrandTableView


- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    
    return _dataSourceArray;
}

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    
    return _heightDic;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style brandID:(NSNumber *) brandID{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.currentBrandID = brandID;
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
        
        [self loadData];
        
    }
    
    return self;
}


- (void) loadData{
    
    self.page = 1;
    [self setServeList];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    if (self.dataSourceArray.count > 0) {
        
        return self.dataSourceArray.count;
        
    }else{
        
        return 0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.heightDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        
        return [[self.heightDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        
    }else{
        
        return 0;
    }
    
}

/**********/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray.count > 0) {
        
            
            static NSString *identifier = @"myCell";
            CMLMailServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                cell = [[CMLMailServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.dataSourceArray[indexPath.row]];
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
        [self.videoController dismiss];
        _cell = nil;
        
    }
}
#pragma mark - 点击播放代理
- (void)cl_tableViewCellPlayVideoWithCell:(CMLMailServeTVCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    
    
    self.videoController = [[KrVideoPlayerController alloc] initWithFrame:cell.imageRect];
    self.videoController.videoControl.fullScreenButton.hidden = YES;
    __weak typeof(self)weakSelf = self;
    self.videoController.view.backgroundColor = [UIColor whiteColor];
    [self.videoController setDimissCompleteBlock:^{
        
        
        weakSelf.videoController = nil;
        
        
        
    }];
    [self.videoController setWillBackOrientationPortrait:^{
        
        
        
    }];
    [self.videoController setWillChangeToFullscreenMode:^{
        
    }];
    
    [_cell addSubview:self.videoController.view]; //video 显示在 window 便于控制
    [self.videoController removeListeningRotating];
    
    CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.dataSourceArray[cell.currentTag]];
    self.videoController.contentURL = [NSURL URLWithString:obj.video_url];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.dataSourceArray[indexPath.row]];
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC]pushVC:vc animate:YES];
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
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"queryOrderId"];
    [paraDic setObject:self.currentBrandID forKey:@"brandId"];
        
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentBrandID ,
                                                           [NSNumber numberWithInt:1],
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
        
    [NetWorkTask getRequestWithApiName:MailServeList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MailServeList;
    NSLog(@"=======%@",paraDic);
    
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setServeList];
}

- (void) loadMoreData{
    
    
    if (self.dataSourceArray.count%PageSize == 0) {
        if (self.dataSourceArray.count != [self.dataCount integerValue]) {
            
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
    
     if ([self.currentApiName isEqualToString:MailServeList]){
        

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = obj.retData.dataCount;
            if (self.page == 1) {
                
                [self.dataSourceArray removeAllObjects];
                self.dataSourceArray  = [NSMutableArray arrayWithArray:obj.retData.dataList];
                
                
            }else{
                
                [self.dataSourceArray addObjectsFromArray:obj.retData.dataList];
            }
            
            
            [self reloadData];
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        [self.baseTableViewDlegate endRequesting];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }
}



- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
