//
//  CMLVIPTopicTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/3.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVIPTopicTableView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "MJRefresh.h"
#import "CMLVIPTopicTVCell.h"
#import "RecommendTimeLineObj.h"
#import "CMLUserTopicVC.h"

#define PageSize  10


@interface CMLVIPTopicTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@end

@implementation CMLVIPTopicTableView

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
        [self setThemeListRequest];
    }
    
    return self;
}

- (void) setThemeListRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[@"",reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:ThemeList param:paraDic delegate:delegate];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 220*Proportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"myCell";
    
    CMLVIPTopicTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[CMLVIPTopicTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataArray.count > 0 ) {
        
        RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentTVCellWith:obj];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
    CMLUserTopicVC *vc = [[CMLUserTopicVC alloc] initWithObj:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setThemeListRequest];
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mj_footer endRefreshingWithNoMoreData];
        
    }
    
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setThemeListRequest];
    
}

#pragma mark- NetWorkProtocol

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
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
        
        [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        
    }
    
    [self.baseTableViewDlegate endRequesting];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接错误"];
    [self.baseTableViewDlegate endRequesting];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
@end
