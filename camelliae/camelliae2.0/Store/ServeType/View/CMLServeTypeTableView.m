//
//  CMLServeTypeTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLServeTypeTableView.h"
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

#import "CMLSBUserPushServeTVCell.h"
#import "CMLUserPushServeDetailVC.h"

#define PageSize 10

@interface CMLServeTypeTableView ()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CLTableViewCellDelegate>


@property (nonatomic,strong) NSNumber *parentTypeID;

@property (nonatomic,strong) NSNumber *typeID;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;


@end


@implementation CMLServeTypeTableView

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


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
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
        
        
    }
    
    return self;
}

- (void) refreshTableWithParentServeTypeID:(NSNumber *) parentID andTypeID:(NSNumber *) typeID{
    
    self.parentTypeID = parentID;
    self.typeID = typeID;
    self.page = 1;
    
    [self setServeList];
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
        
         CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
        
        if ([obj.isUserPublish intValue] == 0) {

            static NSString *identifier = @"myCell";
            CMLMailServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                cell = [[CMLMailServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            [cell refreshCurrent:obj];
            
            [self.heightDic setObject:[NSNumber numberWithFloat:cell.currentheight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            return cell;

        }else{
            
            static NSString *identifier = @"myCell3";
            CMLSBUserPushServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLSBUserPushServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell refrshShoppingTVCellOf:obj];
            [cell hiddienAddress];
            [self.heightDic setObject:[NSNumber numberWithFloat:cell.noAddressHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//            [self.heightDic setObject:[NSNumber numberWithFloat:cell.cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            return cell;
            

        }
        
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
        [_playerView destroyPlayer];
        _cell = nil;
        
    }
}
#pragma mark - 点击播放代理
- (void)cl_tableViewCellPlayVideoWithCell:(CMLMailServeTVCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:cell.imageRect];
    _playerView = playerView;
    [cell addSubview:_playerView];
    //    //重复播放，默认不播放
    //    _playerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    //    _playerView.isLandscape = YES;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    //    _playerView.fillMode = ResizeAspectFill;
    //设置进度条背景颜色
//    _playerView.progressBackgroundColor = [UIColor grayColor];
//    //设置进度条缓冲颜色
//    _playerView.progressBufferColor = [UIColor grayColor];
//    //设置进度条播放完成颜色
//    _playerView.progressPlayFinishColor = [UIColor whiteColor];
//    //    //全屏是否隐藏状态栏
//    _playerView.fullStatusBarHiddenType = FullStatusBarHiddenNever;
    //    //转子颜色
    //    _playerView.strokeColor = [UIColor redColor];
    //视频地址
    CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[cell.currentTag]];
    _playerView.url = [NSURL URLWithString:obj.video_url];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView destroyPlayer];
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        _cell = nil;
        NSLog(@"播放完成");
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLServeObj *obj = [CMLServeObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    if ([obj.isUserPublish intValue] == 0) {
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:obj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

    
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
    [paraDic setObject:self.typeID forKey:@"projectTypeId"];
    [paraDic setObject:self.parentTypeID forKey:@"serveType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.typeID,[NSNumber numberWithInt:1],reqTime,self.parentTypeID,[[DataManager lightData] readSkey]]];
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
    
    if ([self.currentApiName isEqualToString:MailServeList]){
        
   
        
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
    }
}



- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
