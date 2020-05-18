//
//  SpecialTopicTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SpecialTopicTableView.h"
#import "VCManger.h"
#import "NewSpecialTopicTVCell.h"
#import "MJRefresh.h"
#import "NewTopicObj.h"
#import "CMLNewSpecialDetailTopicVC.h"
#import "SpecialParaDicProduce.h"
#import "CMLPrefectureVC.h"

#define PageSize             15

#define CellAroundMargin     15
#define CellImageLeftMargin  30

@interface SpecialTopicTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *zoneList;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) int page;

@end

@implementation SpecialTopicTableView

- (NSMutableArray *)dataArray{
 
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)zoneList {
    
    if (!_zoneList) {
        _zoneList = [NSMutableArray array];
    }
    return _zoneList;
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
        self.rowHeight = (WIDTH - CellImageLeftMargin*Proportion*2)/16*9 + CellAroundMargin*Proportion*2;
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
        
        
        [self pullRefreshOfHeader];
    }
    
    return self;
}

- (void) loadData{
    
    self.page = 1;
    [self.baseTableViewDlegate startRequesting];
    [self pullRefreshOfHeader];
}

- (void) pullRefreshOfHeader{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [SpecialParaDicProduce getTopicListParaDicWithPage:self.page andPageSize:PageSize];
    [NetWorkTask getRequestWithApiName:TopicList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = TopicList;
    
}

- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:TopicList]) {

        if (self.dataArray.count < self.dataCount) {
            self.page++;
            [self pullRefreshOfHeader];
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"TopicList %@", responseResult);
    if ([obj.retCode intValue] == 0) {
        
        self.dataCount = [obj.retData.dataCount intValue];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        if (obj.retData.zoneList) {/*添加专区数据*/
            
            NSLog(@"%d", [[[DataManager lightData] readTopicZone] intValue]);
            if ([[[DataManager lightData] readTopicZone] intValue] == 1) {
                self.dataCount = self.dataCount + 1;
                [self.dataArray addObjectsFromArray:obj.retData.zoneList];
            }
        }
        [self.dataArray addObjectsFromArray:obj.retData.dataList];
        [self reloadData];
        
    }else if ([obj.retCode intValue] == 100101){
    }else{
        [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
    }
    
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"myCell";
    
    NewSpecialTopicTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NewSpecialTopicTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (self.dataArray.count > 0) {
        
        NewTopicObj *currentObj = [NewTopicObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentCellWith:currentObj.picObjInfo.coverPic
                            andTitle:currentObj.title
                       andShortTitle:currentObj.shortTitle
                                 and:currentObj.countRecord
                          andPassTag:currentObj.pass_due];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewTopicObj *currentObj = [NewTopicObj getBaseObjFrom:self.dataArray[indexPath.row]];
    NSLog(@"%@", currentObj.dataType);
    if (currentObj.dataType) {
        if ([currentObj.dataType intValue] == 10) {
            CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
            vc.currentID = currentObj.currentID;
            [[VCManger mainVC] pushVC:vc animate:YES];
        }else {
            CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:currentObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
    }else {
        CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:currentObj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}

@end
