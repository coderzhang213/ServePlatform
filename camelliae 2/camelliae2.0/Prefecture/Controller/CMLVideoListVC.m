//
//  CMLVideoListVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVideoListVC.h"
#import "PrefectureInformationTVCell.h"
#import "VCManger.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "MJRefresh.h"
#import "AuctionDetailInfoObj.h"
#import "CMLVideoTVCell.h"
#import "CommonNumber.h"
#import "VideoDetailInfoObj.h"
#import <MediaPlayer/MediaPlayer.h>

#define PageSize  10

@interface CMLVideoListVC ()<UITableViewDelegate,UITableViewDataSource,NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *currentTitle;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation CMLVideoListVC

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
    
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = self.currentTitle;
    [self.navBar setLeftBarItem];
    
    
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
}

- (void) loadMessageOfVC{

    [self.dataArray removeAllObjects];
    [self loadData];
}

- (void) loadData{
    
    
    self.page = 1;
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
    [NetWorkTask getRequestWithApiName:PrefectureList param:paraDic delegate:delegate];
    self.currentApiName = PrefectureList;
}


- (void) loadViews{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame))
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.rowHeight = (WIDTH - 30*Proportion*2)/16*9 + 20*Proportion*2;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.mainTableView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    /**上拉加载*/
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"myCell";
    
    CMLVideoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLVideoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VideoDetailInfoObj *obj = [VideoDetailInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    [cell refeshCurrentCell:obj];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    VideoDetailInfoObj *obj = [VideoDetailInfoObj getBaseObjFrom:self.dataArray[indexPath.row]];
    [self openmovie:obj.urlLink];
}


#pragma mark - NavigationBarProtocol
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
    }else {
    
        [self showNetErrorTipOfNormalVC];
    }
    
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self showNetErrorTipOfMainVC];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
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
            [self.mainTableView.mj_footer endRefreshing];
        }
        
    }else{
        [self.mainTableView.mj_footer endRefreshing];
    }
}

#pragma mark - video

-(void)openmovie:(NSString*) url{
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    
    [movie.moviePlayer prepareToPlay];
    [[VCManger mainVC] pushVC:movie animate:NO];
    
    
    [movie.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(movieFinishedCallback:)
     
                                                name:MPMoviePlayerPlaybackDidFinishNotification
     
                                              object:movie.moviePlayer];
    
}
-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
     
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                 object:theMovie];
    
    [[VCManger mainVC] dismissCurrentVC];
}
@end
