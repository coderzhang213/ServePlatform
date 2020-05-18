//
//  CMLGoodsOfBrandCollectionView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGoodsOfBrandCollectionView.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "SearchGoodsTVCell.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "MJRefresh.h"
#import "SearchResultObj.h"
#import "CMLCommodityDetailMessageVC.h"

#define PageSize  10

static NSString *const idetifier = @"specialCell1";


@interface CMLGoodsOfBrandCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSNumber *currentBrandID;


@end

@implementation CMLGoodsOfBrandCollectionView

-(NSMutableArray *)currentDataArray{
    
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    
    return _currentDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout brandID:(NSNumber *) brandID{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[SearchGoodsTVCell class] forCellWithReuseIdentifier:idetifier];
        self.backgroundColor = [UIColor CMLWhiteColor];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfHeader)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        /**上拉加载*/
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        self.currentBrandID = brandID;
        [self loadData];
    }
    
    return self;
}

- (void) loadData{
    
    self.page = 1;
    
    [self setRequest];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.currentDataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchGoodsTVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor CMLWhiteColor];
    if (indexPath.row%2 == 0) {
        
        cell.isMoveModule = YES;
    }else{
        
        cell.isMoveModule = NO;
    }
    if (self.currentDataArray.count > 0) {
        
        SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
        [cell refreshCVCell:detailObj];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:detailObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}


- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        
        self.dataCount = obj.retData.dataCount;
        
        if (self.page == 1) {
            
            [self.currentDataArray removeAllObjects];
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
        }else{
            
            [self.currentDataArray addObjectsFromArray:obj.retData.dataList];
        }
        
    }else{
        
        [self.baseCollectionViewDlegate collectionViewShowFailActionMessage:obj.retMsg];
    }
    
    [self reloadData];
    [self.baseCollectionViewDlegate collectionViewEndRequesting];
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseCollectionViewDlegate collectionViewEndRequesting];
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setRequest];
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if (self.currentDataArray.count%PageSize == 0) {
        if (self.currentDataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setRequest];
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void) setRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:@"" forKey:@"keyword"];
    [paraDic setObject:self.currentBrandID forKey:@"brandId"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    [NetWorkTask getRequestWithApiName:SearchGoodsList param:paraDic delegate:delegate];
}
@end
