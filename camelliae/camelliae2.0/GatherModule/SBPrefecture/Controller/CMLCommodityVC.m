//
//  CMLCommodityVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommodityVC.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLCommodityCVCell.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "MJRefresh.h"
#import "AuctionDetailInfoObj.h"
#import "CMLCommodityDetailMessageVC.h"


#define PageSize  10

static NSString *const idetifier = @"specialCell1";

@interface CMLCommodityVC ()<NavigationBarProtocol,UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *currentTitle;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation CMLCommodityVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)initWithID:(NSNumber *) currentID andTitle:(NSString *) currentTitle{

    self = [super init];
    
    if (self) {
      
        self.currentID = currentID;
        self.currentTitle = currentTitle;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = self.currentTitle;
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
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
    [paraDic setObject:self.currentID forKey:@"parentZoneModuleId"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"version"];
    [NetWorkTask getRequestWithApiName:PrefectureList param:paraDic delegate:delegate];
    self.currentApiName = PrefectureList;
}

- (void) loadViews{
    
    

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(360*Proportion ,[self getCellHeight]);
    layout.minimumLineSpacing = 40*Proportion;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.navBar.frame),
                                                                             WIDTH,
                                                                             HEIGHT - CGRectGetMaxY(self.navBar.frame))
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[CMLCommodityCVCell class] forCellWithReuseIdentifier:idetifier];
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
    
    CMLCommodityCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.backgroundColor = [UIColor CMLWhiteColor];
    if (indexPath.row%2 == 0) {
        
        cell.isMoveModule = YES;
    }else{
    
        cell.isMoveModule = NO;
    }
     AuctionDetailInfoObj *detailObj = [AuctionDetailInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    [cell refreshCVCell:detailObj];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    AuctionDetailInfoObj *detailObj = [AuctionDetailInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:detailObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}



- (CGFloat) getCellHeight{

    UILabel *label1 = [[UILabel alloc] init];
    label1.font = KSystemBoldFontSize12;
    label1.text = @"测试";
    [label1 sizeToFit];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"¥100";
    label2.font = KSystemRealBoldFontSize16;
    [label2 sizeToFit];
    
    return label1.frame.size.height*2 + label2.frame.size.height + 20*Proportion*2 + 220*Proportion;
    
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
        [self loadViews];
    }else{
    
        [self showNetErrorTipOfNormalVC];
    }
    
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
