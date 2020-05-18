//
//  CMLALLBrandTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/29.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLALLBrandTableView.h"
#import "VCManger.h"
#import "CMLAllBrandTVCell.h"
#import "MJRefresh.h"
#import "NewTopicObj.h"
#import "SpecialParaDicProduce.h"
#import "CMLBrandVC.h"
#import "BrandModuleObj.h"
#import "CMLStoreBrandHeaderView.h"

#define PageSize             10

#define CellAroundMargin     15
#define CellImageLeftMargin  30

@interface CMLALLBrandTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *currentTypeID;

@property (nonatomic,strong) CMLStoreBrandHeaderView *storeBrandHeaderView;


@end

@implementation CMLALLBrandTableView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
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
        self.rowHeight = (WIDTH - CellImageLeftMargin*Proportion*2)/16*9 + CellAroundMargin*Proportion*2;
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
        
        self.currentTypeID = [NSNumber numberWithInt:0];
        
        [self loadData];
        
    }
    
    return self;
}



- (void) loadData{
    
    self.page = 1;
    [self.baseTableViewDlegate startRequesting];
    
    [self setBrandModuleRequest];
    
}

- (void) pullRefreshOfHeader{
    
    
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
    [paraDic setObject:self.currentTypeID forKey:@"type"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"orderByType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask getRequestWithApiName:ALlBrandList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = ALlBrandList;
 
    
}

- (void) setBrandModuleRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    
    [NetWorkTask getRequestWithApiName:StoreRecommendBrand
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = StoreRecommendBrand;
    
    
}

- (void) refreshTableViewWithTypeID:(NSNumber *) typeID{
    
    if([typeID intValue] != 100){
        
        self.currentTypeID = typeID;
        self.page = 1;
        [self.baseTableViewDlegate startRequesting];
        [self pullRefreshOfHeader];
        
        if ([typeID intValue] == 0) {
            
            self.tableHeaderView = self.storeBrandHeaderView;
        } else {
            self.tableHeaderView = [[UIView alloc] init];
        }
        
    }
}

- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:ALlBrandList]) {
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self pullRefreshOfHeader];
            }else{
                
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];

    if ([self.currentApiName isEqualToString:ALlBrandList]) {
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            
            [self reloadData];
            

            
        }else if ([obj.retCode intValue] == 100101){
            
            
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
    } else {
    
        self.storeBrandHeaderView = [[CMLStoreBrandHeaderView alloc] initWithObj: obj];
        self.tableHeaderView = self.storeBrandHeaderView;
        
        [self pullRefreshOfHeader];
        
    }

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
    
    CMLAllBrandTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLAllBrandTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor CMLWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataArray.count > 0) {
        
        BrandModuleObj *obj = [BrandModuleObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentCellWith:obj.brandListPic];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BrandModuleObj *obj = [BrandModuleObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:obj.coverPic
                                             andDetailMes:obj.desc
                                             LogoImageUrl:obj.logoPic
                                                  brandID:obj.currentID];
    vc.goodsNum = obj.goodsCount;
    vc.serveNum = obj.projectCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
    
}


@end
