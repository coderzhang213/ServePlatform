//
//  CMLSearchGoodsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLSearchGoodsVC.h"
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

@interface CMLSearchGoodsVC ()<NavigationBarProtocol,UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol>


@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) NSString *keyWord;

@end

@implementation CMLSearchGoodsVC

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)initWithSearchStr:(NSString *) str{

    self = [super init];
    
    if (self) {
        
        self.keyWord = str;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
    [self loadViews];
    
    if ([self.keyWord isEqualToString:@""]) {
        
        [self.navBar setTitleContent:@"单品"];
    }
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
}


- (void) loadMessageOfVC{
    
    
    
    [self loadData];
}

- (void) loadData{
    
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self startLoading];
    [self setRequest];
}

- (void) setRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:self.keyWord forKey:@"keyword"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    [NetWorkTask getRequestWithApiName:SearchGoodsList param:paraDic delegate:delegate];
}

- (void) loadViews{
    
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(360*Proportion ,[self getCellHeight]);
    layout.minimumLineSpacing = 50*Proportion;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                             WIDTH,
                                                                             HEIGHT - CGRectGetMaxY(self.navBar.frame) - 20*Proportion - SafeAreaBottomHeight)
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[SearchGoodsTVCell class] forCellWithReuseIdentifier:idetifier];
    self.collectionView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.collectionView];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    /**上拉加载*/
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchGoodsTVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor CMLWhiteColor];
    if (indexPath.row%2 == 0) {
        
        cell.isMoveModule = YES;
    }else{
        
        cell.isMoveModule = NO;
    }
    if (self.dataArray.count > 0) {
     
        SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCVCell:detailObj];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultObj *detailObj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:detailObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}



- (CGFloat) getCellHeight{
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = KSystemBoldFontSize14;
    label1.text = @"测试";
    [label1 sizeToFit];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"¥100";
    label2.font = KSystemRealBoldFontSize17;
    [label2 sizeToFit];
    
    return label1.frame.size.height*2 + label2.frame.size.height + 10*Proportion + 30*Proportion + 330*Proportion + 34*Proportion + 15*Proportion + 10*Proportion;
    
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
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
        }else{
            
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
        }
        
    }else{
        
        [self showNetErrorTipOfNormalVC];
    }
    [self.collectionView reloadData];
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self showNetErrorTipOfNormalVC];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setRequest];
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setRequest];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
@end
