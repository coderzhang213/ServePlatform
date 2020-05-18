//
//  InformationListVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/3.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "InformationListVC.h"
#import "VCManger.h"
#import "CMLInfoObj.h"
#import "CMLSpecialInfoObj.h"
#import "CMLInfoTVCell.h"
#import "CMLSpecialTVCell.h"
#import "MJRefresh.h"
#import "InformationDefaultVC.h"
#import "TopicCVCell.h"
#import "CMLChannelVC.h"
#import "ReplaceTVCell.h"

#define PageSize                                10
#define PageSize1                               20

#define InformationListBtnBgViewHeight          60
#define InformationListBtnTAroundMargin         10

#define InformationListTopicCellHeightAndWidth  350

static NSString *identifier = @"collectionViewCell";

@interface InformationListVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UICollectionView *mainCollectionView;

@property (nonatomic,strong) UIButton *hotBtn;

@property (nonatomic,strong) UIButton *specialBtn;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) CGFloat infoCellHeight;

@property (nonatomic,assign) CGFloat replaceCellHeight;

@property (nonatomic,strong) UIView *selectLine;

@end

@implementation InformationListVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfInformationListVC"];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfInformationListVC"];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.delegate = self;
    self.navBar.titleContent = @"资讯";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    [self getInfoCellHeight];
    [self getReplaceTVCellHeight];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf.dataArray removeAllObjects];
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    
    };

}


- (void) loadMessageOfVC{

    self.page = 1;

    [self loadViews];
    
    [self loadData];

}

- (void) loadData{

    [self startLoading];
    [self setHotNewsListRequest];
}

- (void) loadViews{
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                 WIDTH,
                                                                 InformationListBtnBgViewHeight*Proportion)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:btnBgView];
    
    self.hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(InformationListBtnTAroundMargin*Proportion,
                                                             InformationListBtnTAroundMargin*Proportion,
                                                             WIDTH/2.0 - 2*InformationListBtnTAroundMargin*Proportion,
                                                             InformationListBtnBgViewHeight*Proportion - 2*InformationListBtnTAroundMargin*Proportion)];
    self.hotBtn.titleLabel.font = KSystemFontSize14;
    [self.hotBtn setTitle:@"热门" forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    self.hotBtn.selected = YES;
    [self.hotBtn addTarget:self action:@selector(changeHotList) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:self.hotBtn];
    
    self.specialBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - InformationListBtnTAroundMargin*Proportion - self.hotBtn.frame.size.width,
                                                                 InformationListBtnTAroundMargin*Proportion,
                                                                 WIDTH/2.0 - 2*InformationListBtnTAroundMargin*Proportion,
                                                                 InformationListBtnBgViewHeight*Proportion - 2*InformationListBtnTAroundMargin*Proportion)];
    self.specialBtn.titleLabel.font = KSystemFontSize14;
    [self.specialBtn setTitle:@"频道" forState:UIControlStateNormal];
    [self.specialBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.specialBtn addTarget:self action:@selector(changeSpecialList) forControlEvents:UIControlEventTouchUpInside];
    [self.specialBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [btnBgView addSubview:self.specialBtn];
    
    self.selectLine = [[UIView alloc] initWithFrame:CGRectMake(self.hotBtn.center.x - 56*Proportion/2.0,
                                                               btnBgView.frame.size.height - 4*Proportion,
                                                               56*Proportion,
                                                               4*Proportion)];
    self.selectLine.backgroundColor = [UIColor CMLBlackColor];
    [btnBgView addSubview:self.selectLine];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.startingPoint = CGPointMake(0,btnBgView.frame.size.height - 0.5);
    bottomLine.lineWidth = 0.5;
    bottomLine.LineColor = [UIColor CMLPromptGrayColor];
    bottomLine.lineLength = HEIGHT;
    [btnBgView addSubview:bottomLine];
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(btnBgView.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(btnBgView.frame))
                                                      style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor CMLUserGrayColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat tempWidth = (WIDTH - 15*Proportion*4)/3.0;
    layout.itemSize = CGSizeMake(tempWidth , tempWidth);
    layout.minimumLineSpacing = 10*Proportion;
    layout.minimumInteritemSpacing = 10*Proportion;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(btnBgView.frame),
                                                                                 WIDTH,
                                                                                 HEIGHT - CGRectGetMaxY(btnBgView.frame))
                                                 collectionViewLayout:layout];
    self.mainCollectionView.backgroundColor =[UIColor whiteColor];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.hidden = YES;
    [self.contentView addSubview:self.mainCollectionView];
    [self.mainCollectionView registerClass:[TopicCVCell class] forCellWithReuseIdentifier:identifier];
    
    MJRefreshNormalHeader *header1 = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header1.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header1.lastUpdatedTimeLabel.hidden = YES;
    self.mainCollectionView.mj_header = header1;
    
    self.mainCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.currentApiName isEqualToString:HotNews]) {
        return self.dataArray.count;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        if ([self.currentApiName isEqualToString:HotNews]) {
            
            return self.infoCellHeight;
        }else{
            return 0;
        }
    }
    return self.replaceCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.currentApiName isEqualToString:HotNews]) {
        static NSString *identifier = @"mycell1";
        CMLInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLInfoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray.count > 0) {
                CMLInfoObj *obj = [CMLInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
                cell.isMainView = YES;
                [cell refrshInfoCellInInfoVC:obj];
        }
        return cell;
    }else{
        static NSString *identifier = @"mycell3";
        ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell reloadCurrentCell];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLInfoObj *obj = [CMLInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if ([self.currentApiName isEqualToString:TopicNews]) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([self.currentApiName isEqualToString:TopicNews]) {
        if (self.dataArray.count > 0) {
            CMLSpecialInfoObj *obj = [CMLSpecialInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = obj.coverPic;
            cell.name = obj.topicTypeName;
            [cell refreshCueerntCell];
        }
    }
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    
    return UIEdgeInsetsMake(15*Proportion, 15*Proportion,15*Proportion,15*Proportion);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 15*Proportion;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CMLSpecialInfoObj *obj = [CMLSpecialInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    CMLChannelVC *vc = [[CMLChannelVC alloc] initWithChannelName:obj.topicTypeName
                                                         objType:obj.topicTypeId
                                                        ImageUrl:obj.coverPic];
    [[VCManger mainVC] pushVC:vc animate:YES];

}

#pragma mark - changeHotList
- (void) changeHotList{

    self.selectLine.frame = CGRectMake(self.hotBtn.center.x - 56*Proportion/2.0,
                                       self.selectLine.frame.origin.y,
                                       56*Proportion,
                                       4*Proportion);
    
    self.currentApiName = HotNews;
    [self.mainTableView.mj_header beginRefreshing];
    /************************************************/
    self.mainTableView.hidden = NO;
    self.mainCollectionView.hidden = YES;
    /*********************************************/
    self.hotBtn.selected = YES;
    self.specialBtn.selected = NO;
    
}

#pragma mark - changeSpecialList
- (void) changeSpecialList{
   
    self.selectLine.frame = CGRectMake(self.specialBtn.center.x - 56*Proportion/2.0,
                                       self.selectLine.frame.origin.y,
                                       56*Proportion,
                                       4*Proportion);
    
    self.currentApiName = TopicNews;
    [self.mainCollectionView.mj_header beginRefreshing];
    /************************************************/
    self.mainTableView.hidden = YES;
    self.mainCollectionView.hidden = NO;
    /*********************************************/
    self.specialBtn.selected = YES;
    self.hotBtn.selected = NO;
    
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    if ([self.currentApiName isEqualToString:HotNews]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.dataCount = [obj.retData.dataCount intValue];
        if ([obj.retCode intValue] == 0 && obj) {
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
                
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }

            [self.mainTableView reloadData];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            if (self.page > 1) {
                self.page--;
            }

            [self showAlterViewWithText:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:TopicNews]){
        
        NSLog(@"********%@",responseResult);
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.dataCount = [obj.retData.dataCount intValue];
        if ([obj.retCode intValue] == 0 && obj) {
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.page = 1;
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
                
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }

            [self.mainCollectionView reloadData];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            if (self.page > 1) {
                self.page--;
            }

            [self showAlterViewWithText:obj.retMsg];
        }
    }

    
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainCollectionView.mj_footer endRefreshing];
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];

    [self performSelector:@selector(delayRefresh) withObject:nil afterDelay:0.5];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:HotNews] || [self.currentApiName isEqualToString:TopicNews]) {
        if (self.page > 1) {
            self.page--;
        }
    }
    
    if (([self.currentApiName isEqualToString:HotNews] || [self.currentApiName isEqualToString:TopicNews]) && self.dataArray.count == 0) {
        [self showNetErrorTipOfNormalVC];
    }

    [self showFailTemporaryMes:@"网络连接失败"];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainCollectionView.mj_footer endRefreshing];
    [self stopLoading];
    if ([self.currentApiName isEqualToString:HotNews]) {
        [self.mainTableView.mj_header endRefreshing];
    }else{
        [self.mainCollectionView.mj_header endRefreshing];
    }
    
}

#pragma mark - 设置热门请求
- (void) setHotNewsListRequest{
    
    

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask postResquestWithApiName:HotNews paraDic:paraDic delegate:delegate];
    self.currentApiName = HotNews;
}

#pragma mark - 设置专题请求
- (void) setSpecialNewsListRequest{

    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize1] forKey:@"pageSize"];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:TopicNews paraDic:paraDic delegate:delegate];
    self.currentApiName = TopicNews;
    
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:HotNews]) {
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self setHotNewsListRequest];
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        if (self.dataArray.count%PageSize1 == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self setSpecialNewsListRequest];
            }else{
                [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void) scrollViewScrollToTop{

    if ([self.currentApiName isEqualToString:HotNews]) {
        self.mainCollectionView.scrollsToTop = NO;
       [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        self.mainTableView.scrollsToTop = NO;
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void) pullRefreshOfHeader{

    self.page = 1;
    [self.dataArray removeAllObjects];

    if ([self.currentApiName isEqualToString:HotNews]) {
        [self setHotNewsListRequest];
    }else{
        [self setSpecialNewsListRequest];
    }
}

- (void) getInfoCellHeight{
    
    CMLInfoTVCell *cell = [[CMLInfoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell.isMainView = YES;
    [cell refrshInfoCellInInfoVC:nil];
    self.infoCellHeight = cell.cellheight;
}

- (void) getReplaceTVCellHeight{

    ReplaceTVCell *cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    [cell reloadCurrentCell];
    self.replaceCellHeight = cell.cellheight;
}

#pragma mark - delayRefresh
- (void) delayRefresh{

    if ([self.currentApiName isEqualToString:HotNews]) {
        [self.mainTableView.mj_header endRefreshing];
    }else{
        [self.mainCollectionView.mj_header endRefreshing];
    }

}
@end
