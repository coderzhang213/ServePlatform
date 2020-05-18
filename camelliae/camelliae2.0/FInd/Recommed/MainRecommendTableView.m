//
//  MainRecommendTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "MainRecommendTableView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "MJRefresh.h"
#import "CMLActivityTVCell.h"
#import "CMLCommIndexObj.h"
#import "ActivityDefaultVC.h"
#import "ReplaceTVCell.h"
#import "MianInterfaceRecommendView.h"
#import "CMLNewActivityAnInfoCell.h"
#import "CMLActivityObj.h"
#import "CMLUserArticleVC.h"
#import "AppDelegate.h"

#define PageSize  10


@interface MainRecommendTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,RecommendDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,assign) CGFloat activityHeight;

@property (nonatomic,assign) CGFloat replaceHeight;

/*****/
@property (nonatomic,strong)  MianInterfaceRecommendView *tablViewHeader;

@property (nonatomic, strong) BaseResultObj *obj;

@end
@implementation MainRecommendTableView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
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
        
        [self getActivityCellHeight];
        
        [self getReplaceTVCellHeight];
        
        [self pullRefreshOfHeader];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count > 0) {
        
        return self.dataArray.count;
        
    }else{
        
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"self.dataArray.count %lu", (unsigned long)self.dataArray.count);
    if (self.dataArray.count > 0) {
        
//        CMLCommIndexObj *commIndexObj = [CMLCommIndexObj getBaseObjFrom:self.dataArray[indexPath.row]];
//        
//        if ([commIndexObj.dataType intValue] == 3) {
//            
//            return 242*Proportion + 20*Proportion*2;
//            return WIDTH/16*9 + 20*Proportion;
            
//        }else if ([commIndexObj.dataType intValue] == 2) {
            
            return 242*Proportion + 20*Proportion*2;
//            return WIDTH/16*9 + 20*Proportion;
//        }else{
//            if ([commIndexObj.rootTypeId intValue] == 2) {
//
//                return self.activityHeight ;
//
//            }else {
//
//                return 0;
//
//            }
//        }
    }else{
        NSLog(@"replaceHeight %f", self.replaceHeight);
        return self.replaceHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        CMLActivityObj *commIndexObj = [CMLActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
        NSLog(@"%ld", (long)indexPath.row);
        static NSString *identifier = @"mycell4";
        
        CMLNewActivityAnInfoCell *cell4 = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell4) {
            
                cell4 = [[CMLNewActivityAnInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell4.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        [cell4 refrshActivityCellInActivityVC:commIndexObj];
        
        return cell4;
                
    }else{
        static NSString *identifier = @"mycell8";
        ReplaceTVCell *cell8 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell8) {
            cell8 = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell8.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell8 reloadCurrentCell];
        return cell8;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
    if ([activityObj.rootTypeId intValue] == 2) {
        
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:activityObj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:activityObj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isNetError) {
        [appDelegate setAppStartMes];
    }

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    self.dataCount = obj.retData.dataCount;
    NSLog(@"%@", responseResult);
    if ([obj.retCode intValue] == 0 && obj) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
            self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
        }else{
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
        }
        
        [self reloadData];
        [self.baseTableViewDlegate endRequesting];
        
    }else if ([obj.retCode intValue] == 100101){
        
        [self.baseTableViewDlegate endRequesting];
      
        
    }else{
        if (self.page > 1) {
            self.page--;
        }
        [self.baseTableViewDlegate endRequesting];
        [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
    }
    
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if (self.page > 1) {
        self.page--;
    }
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];//网络连接失败4
    [self.dataArray removeAllObjects];
    self.tablViewHeader = nil;
    [self reloadData];
    [self.baseTableViewDlegate endRequesting];
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];

    
}


- (void) getActivityCellHeight{
    
    self.activityHeight = 242*Proportion + 20*Proportion*2;
    
}


- (void) getReplaceTVCellHeight{
    
    ReplaceTVCell *cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    [cell reloadCurrentCell];
    self.replaceHeight = cell.cellheight;
}

- (void) setRecommIndexRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
//    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [NetWorkTask postResquestWithApiName:NewWorldIn paraDic:paraDic delegate:delegate];

}

- (void) pullRefreshOfHeader{

    self.page = 1;
    [self.dataArray removeAllObjects];
    [self setRecommIndexRequest];
    
    self.tablViewHeader = nil;
    self.tablViewHeader = [[MianInterfaceRecommendView alloc] init];
    self.tablViewHeader.delegate = self;
    
}

- (void) loadMoreData{

    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setRecommIndexRequest];
        }else{

            [self.mj_footer endRefreshingWithNoMoreData];
        }

    }else{
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - RecommendDelegate
- (void) loadViewSuccess{
    
    self.tableHeaderView = self.tablViewHeader;
    
}

- (void) progressSuccess{
    
    [self.baseTableViewDlegate endRequesting];
    
}

- (void) progressError:(NSString *) msg andCode:(int)code{
    
    if (code == -1) {
       
    }else if(code == 100101){
        [self.baseTableViewDlegate endRequesting];
    }
    
    [self.baseTableViewDlegate showFailActionMessage:msg];
    [self.baseTableViewDlegate endRequesting];
}

@end
