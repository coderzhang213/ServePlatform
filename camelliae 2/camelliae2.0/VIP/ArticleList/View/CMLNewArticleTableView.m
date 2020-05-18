//
//  CMLNewArticleTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/2.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewArticleTableView.h"
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

#define PageSize   10

@interface CMLNewArticleTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLNewArticleTableView

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    
    return _heightDic;
}

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
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
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
         [self setArtcileListRequest];
    }
    
    return self;
}

- (void) setArtcileListRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objType"];
    [NetWorkTask getRequestWithApiName:NewDynamicsList param:paraDic delegate:delegate];
    self.currentApiName = NewDynamicsList;
    
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
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
    
    
    if ([self.heightDic objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        
        NSNumber *cellHeight = [self.heightDic objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        
        return [cellHeight floatValue];
        
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        
        
        static NSString *identifier = @"myCell";
        CMLArtcticleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLArtcticleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self drawArticleCell:cell withIndexPath:indexPath];
        return cell;
    }else{
        
        static NSString *identifier = @"myCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}

- (void)drawArticleCell:(CMLArtcticleTVCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        
        RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        __weak typeof(self) weakSelf = self;
        cell.deleteArticle = ^(NSNumber *timeLineId){
            
            [weakSelf setAlterViewWithTimeLineId:timeLineId];
            
            
        };
        
        [cell refreshCurrentCellWith:obj atIndexPath:indexPath];
    }
    [self.heightDic setObject:[NSNumber numberWithFloat:cell.currentCellHeight]
                       forKey:[NSNumber numberWithInteger:indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
    CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:obj.recordId];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setArtcileListRequest];
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
    [self setArtcileListRequest];
    
}

#pragma mark- NetWorkProtocol

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewDynamicsList]) {
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self.baseTableViewDlegate showAlterView:@"举报成功，工作人员会尽快处理"];
    }
    
}
@end
