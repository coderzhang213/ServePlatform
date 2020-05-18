//
//  PersonalCenterCellectionVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "PersonalCenterCollectionVC.h"
#import "VCManger.h"
#import "CMLActivityTVCell.h"
#import "CMLActivityObj.h"
#import "MJRefresh.h"
#import "ActivityDefaultVC.h"

#define PageSize     10


@interface PersonalCenterCollectionVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>


@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSNumber *selectObjID;


@property (nonatomic,assign) CGFloat activityCellHeight;



@end

@implementation PersonalCenterCollectionVC

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfPersonalCollection"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfPersonalCollection"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /******************************************/
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.titleContent = @"我的收藏";
    self.navBar.titleColor = [UIColor CMLBlack2D2D2DColor];
    self.navBar.delegate = self;
    /****获得不同cell的高度*************************************/
    

    [self getCurrentActivityCellHeight];
    /******************************************/
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
    [self sendRequestPage:self.page];
}

- (void) loadViews{
    
    /**主界面*/
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       self.navBar.frame.size.height,
                                                                       WIDTH,
                                                                       HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
   
}

- (UIView *) setCurrentTableFooterView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT - self.navBar.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterNoCollectionImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(bgView.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 bgView.frame.size.height/2.0 - imageView.frame.size.height,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"有喜欢的活动可以收藏哦";
    label.font = KSystemFontSize14;
    label.textColor = [UIColor CMLLineGrayColor];
    [label sizeToFit];
    label.frame = CGRectMake(bgView.frame.size.width/2.0 - label.frame.size.width/2.0,
                             CGRectGetMaxY(imageView.frame) + 20*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [bgView addSubview:label];
    return bgView;
    
}



#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.dataArray.count> 0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


        if (self.dataArray.count > 0) {

            return self.activityCellHeight;
        }
        return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


        static NSString *identifier = @"myCell2";
        CMLActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArray.count > 0) {
            CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
            [cell refrshActivityCellInActivityVC:activityObj];
            
            if ([activityObj.isDeleted intValue] == 2) {
                cell.backgroundColor = [UIColor CMLUserGrayColor];
            }else{
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
        if ([activityObj.isDeleted intValue] != 1) {
            ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:activityObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }else{
            [self showFailTemporaryMes:@"该活动已删除"];
        }
    

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            
        CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
        self.selectObjID = activityObj.currentID;

        [self setDisFavActRequest];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:FavList] ) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.dataCount = [obj.retData.dataCount intValue];
        if ([obj.retCode intValue] == 0 && obj) {
            if (self.page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            [self.mainTableView reloadData];
            
            if (self.dataArray.count == 0) {
                self.mainTableView.tableFooterView = [self setCurrentTableFooterView];
                self.mainTableView.bounces = NO;
                self.mainTableView.bouncesZoom = NO;
            }else{
                self.mainTableView.tableFooterView = [[UIView alloc] init];
                self.mainTableView.bounces = YES;
                self.mainTableView.bouncesZoom = YES;
            }
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            if (self.page > 1) {
                self.page--;
            }
        }

    }else if ([self.currentApiName isEqualToString:ActivityFav]){
         BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
           [self sendRequestPage:self.page];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }
    }

    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:FavList]) {
        if (self.page > 1) {
            self.page--;
        }
    }
    
    [self showNetErrorTipOfNormalVC];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    [self stopLoading];
}

#pragma mark - 收藏列表获取的请求
- (void) sendRequestPage:(int) page{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:userID forKey:@"userId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey =[[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],userID,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [NetWorkTask postResquestWithApiName:FavList paraDic:paraDic delegate:delegate];
    self.currentApiName = FavList;
    
}

- (void) setDisFavActRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"favTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.selectObjID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.selectObjID ,
                                                           [NSNumber numberWithInt:2],
                                                           reqTime,
                                                           [NSNumber numberWithInt:2],
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityFav;
    
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{

    [self.dataArray removeAllObjects];
    self.page = 1;
    [self sendRequestPage:self.page];
    
}

#pragma mark - loadMoreData
- (void) loadMoreData{

    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != self.dataCount) {
            self.page++;
            [self sendRequestPage:self.page];
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void) scrollViewScrollToTop{
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) getCurrentActivityCellHeight{

    CMLActivityTVCell *cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test2"];
    [cell refrshActivityCellInActivityVC:nil];
    self.activityCellHeight = cell.cellheight;
}


@end
