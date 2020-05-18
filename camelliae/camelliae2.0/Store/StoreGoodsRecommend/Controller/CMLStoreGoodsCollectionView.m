//
//  CMLStoreGoodsCollectionView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/28.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLStoreGoodsCollectionView.h"
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
#import "CMLStoreGoodsTopRecommendView.h"
#import "CMLUserPushGoodsCVCell.h"
#import "CMLUserPushGoodsVC.h"

#define PageSize  10

static NSString *const idetifier = @"specialCell1";

static NSString *const idetifier1 = @"specialCell2";

@interface CMLStoreGoodsCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol,CMLStoreGoodsRecommendViewDelegate>

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSNumber *currentTypeID;

@property (nonatomic,strong) CMLStoreGoodsTopRecommendView *storeGoodsTopRecommendView;

@end

@implementation CMLStoreGoodsCollectionView

-(NSMutableArray *)currentDataArray{
    
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    
    return _currentDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[SearchGoodsTVCell class] forCellWithReuseIdentifier:idetifier];
        [self registerClass:[CMLUserPushGoodsCVCell class] forCellWithReuseIdentifier:idetifier1];
        
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
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
        
        self.storeGoodsTopRecommendView = [[CMLStoreGoodsTopRecommendView alloc] init];
        self.storeGoodsTopRecommendView.delegate = self;
        
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
    

    SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    if ([detailObj.isUserPublish intValue] == 0) {
        
        SearchGoodsTVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor CMLWhiteColor];
        
        if (indexPath.row%2 == 0) {
            
            cell.isMoveModule = YES;
        }else{
            
            cell.isMoveModule = NO;
        }
        
        [cell refreshCVCell:detailObj];
        
        return cell;

    }else{
        
        CMLUserPushGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier1 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor CMLWhiteColor];
        
        if (indexPath.row%2 == 0) {
            
            cell.isMoveModule = YES;
        }else{
            
            cell.isMoveModule = NO;
        }
        
        [cell refreshCVCell:detailObj];
        
        return cell;
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.currentDataArray[indexPath.row]];
    
    if ([detailObj.isUserPublish intValue] == 0) {
      
        CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:detailObj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:detailObj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
  
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
#pragma mark ----- 重用的问题
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.backgroundColor = [UIColor CMLWhiteColor];
    
    if ([self.currentTypeID intValue] == 0) {
        
        [header addSubview:self.storeGoodsTopRecommendView];
        
    }else{
        
        
    }
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    if ([self.currentTypeID intValue] == 0) {
        
        return CGSizeMake(WIDTH, self.storeGoodsTopRecommendView.currentheight);
        
    }else{
        
        return CGSizeMake(WIDTH, 0);
    }
    
    
}


- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"goods responseResult%@", responseResult);
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
    [self.storeGoodsCollectionViewDelegate stopLoadingViewOfRefresh];/*停止刷新动画*/
    [self.storeGoodsCollectionViewDelegate hideNetErrorOfStoreGoodsCollectionView];/*隐藏netError*/
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
 
    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
    [self.storeGoodsCollectionViewDelegate netErrorOfStoreGoodsCollectionView];
    [self.storeGoodsCollectionViewDelegate stopLoadingViewOfRefresh];/*停止刷新动画*/
    [self.baseCollectionViewDlegate collectionViewEndRequesting];
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setRequest];
    [self.storeGoodsTopRecommendView refreshDataOfPull];
    
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
    
    [self.baseCollectionViewDlegate collectionViewStartRequesting];
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:@"" forKey:@"keyword"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    if ([self.currentTypeID intValue] != 0) {
        [paraDic setObject:self.currentTypeID forKey:@"typeId"];
    }
    [NetWorkTask getRequestWithApiName:SearchGoodsList param:paraDic delegate:delegate];
    
}

- (void) refreshTableViewWithTypeID:(NSNumber *) typeID{
    NSLog(@"typeID %@", typeID);
    
    self.page = 1;
    self.currentTypeID = typeID;
    [self setRequest];
    
}

#pragma mark - CMLStoreRecommendViewDelegate
- (void) refeshCurrentRecommendView{
    
    self.storeGoodsTopRecommendView.frame = CGRectMake(0,
                                                       0,
                                                       WIDTH,
                                                       self.storeGoodsTopRecommendView.currentheight);
    [self loadData];
}

- (void) goodsVerbSelect:(int) selectIndex{
    
    self.page = 1;
    
    [self.baseCollectionViewDlegate collectionViewStartRequesting];
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:@"" forKey:@"keyword"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    if ([self.currentTypeID intValue] != 0) {
        [paraDic setObject:self.currentTypeID forKey:@"typeId"];
    }
    
    if (selectIndex == 0) {
        
        [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"queryOrderId"];
    }else{
        
        [paraDic setObject:[NSNumber numberWithInt:selectIndex + 1] forKey:@"queryOrderId"];
    }
    [NetWorkTask getRequestWithApiName:SearchGoodsList param:paraDic delegate:delegate];
}

- (void)netErrorOfStoreGoodsRecommendView {
    
    [self loadData];
    
}

@end
