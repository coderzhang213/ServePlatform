//
//  CMLFansAndAttentionVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLFansAndAttentionVC.h"
#import "VCManger.h"
#import "CMLFansAndAttentionTVCell.h"
#import "VIPDetailObj.h"
#import "CMLVIPNewDetailVC.h"
#import "MJRefresh.h"

#define CMLFansAndAttentionCellHeight        160
#define PageSzie            20

@interface CMLFansAndAttentionVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *tempDataSourceArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@end

@implementation CMLFansAndAttentionVC

- (instancetype)initWithTitle:(NSString *) name userId:(NSNumber *) userId isFans:(BOOL) isfanVC{

    self = [super init];
    if (self) {
        
        self.isFansVC = isfanVC;
        self.vcName = name;
        self.userId = userId;
    }
    return self;
}

- (NSMutableArray *)tempDataSourceArray{

    if (!_tempDataSourceArray) {
        _tempDataSourceArray = [NSMutableArray array];
    }
    return _tempDataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.delegate = self;
    self.navBar.titleContent = self.vcName;
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf.tempDataSourceArray removeAllObjects];
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    
    };
}

- (void) loadMessageOfVC{

    self.page = 1;
    /***/
    [self loadViews];
    
    [self loadData];
    
}


- (void) loadData{

    [self startLoading];
    
    if (self.isFansVC) {
       
        [self setMyFansListRequest];
    }else{
    
        [self setMyWatchListRequest];
    }
}
- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame) ,
                                                                       WIDTH,
                                                                       HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.rowHeight = CMLFansAndAttentionCellHeight*Proportion;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.tableHeaderView = [[UIView alloc] init];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.tempDataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.tempDataSourceArray.count > 0) {
        
        VIPDetailObj *obj = [VIPDetailObj getBaseObjFrom:self.tempDataSourceArray[indexPath.row]];
        
        static NSString *identifier = @"userCell";
        CMLFansAndAttentionTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLFansAndAttentionTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.userHeadeImageUrl = obj.gravatar;
        cell.userName = obj.nickName;
        cell.specificLevel = obj.memberVipGrade;
        cell.userLevel = obj.memberLevel;
        cell.userPosition = obj.title;
        cell.currentUserId = obj.uid;
        cell.isBothAttention = obj.isBothFollow;
        cell.isAttention = obj.reqUserFollowStatus;
        if ([self.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        
            if (self.isFansVC) {
                
                cell.isOwnList = YES;
            }else{
                
                cell.isOwnList = NO;
            }
            
        }else{
        
            cell.isOwnList = NO;
        }
        [cell refershCurrentTVCell];
        return cell;
    }else{
    
        static NSString *noneIdentifier = @"noneDate";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noneIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noneIdentifier];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    VIPDetailObj *obj = [VIPDetailObj getBaseObjFrom:self.tempDataSourceArray[indexPath.row]];
    
//    CMLVIPNewDetailVC *vc  = [[CMLVIPNewDetailVC alloc] initWithNickName:obj.nickName currnetUserId:obj.uid isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];

    
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) setMyWatchListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[AppGroup appType] forKey:@"clientId"];
    [paraDic setObject:self.userId forKey:@"userId"];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:PageSzie] forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hasToken = [NSString getEncryptStringfrom:@[[AppGroup appType],self.userId,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hasToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:MyWatchList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MyWatchList;

}

- (void) setMyFansListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[AppGroup appType] forKey:@"clientId"];
    [paraDic setObject:self.userId forKey:@"userId"];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:PageSzie] forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hasToken = [NSString getEncryptStringfrom:@[[AppGroup appType],self.userId,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hasToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:MyFansList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MyFansList;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:MyWatchList]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                self.tempDataSourceArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.tempDataSourceArray addObjectsFromArray:obj.retData.dataList];
            }
            [self.mainTableView reloadData];
            
            if (self.tempDataSourceArray.count == 0) {
            
                self.mainTableView.tableFooterView = [self setNoMessageFooterView];
                self.mainTableView.scrollEnabled = NO;
            }else{
                self.mainTableView.tableFooterView = [[UIView alloc] init];
                self.mainTableView.scrollEnabled = YES;
            }
        }else{
            
            self.page -- ;
            [self showFailTemporaryMes:obj.retMsg];
        }

        
    }else if([self.currentApiName isEqualToString:MyFansList]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                self.tempDataSourceArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.tempDataSourceArray addObjectsFromArray:obj.retData.dataList];
            }
            [self.mainTableView reloadData];
            
            if (self.tempDataSourceArray.count == 0) {
                
                self.mainTableView.tableFooterView = [self setNoMessageFooterView];
                self.mainTableView.scrollEnabled = NO;
            }else{
                self.mainTableView.tableFooterView = [[UIView alloc] init];
                self.mainTableView.scrollEnabled = YES;
            }
        }else{
        
            self.page -- ;
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    self.page --;
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    
}

- (UIView *) setNoMessageFooterView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            HEIGHT - self.navBar.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor CMLPromptGrayColor];
    if (self.isFansVC) {
        label.text = @"暂无粉丝";
    }else{
        label.text = @"暂无关注";
    }
    label.font = KSystemBoldFontSize14;
    [label sizeToFit];
    label.frame = CGRectMake(0,
                             0,
                             label.frame.size.width,
                             label.frame.size.height);
    label.center = view.center;
    [view addSubview:label];
    
    return view;
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
//    if (self.tempDataSourceArray.count%PageSzie == 0) {
    
    
    
        if (self.tempDataSourceArray.count != self.dataCount) {
            self.page++;
            
            int count;
            if (self.dataCount%PageSzie == 0) {
             
                count = self.dataCount/PageSzie;
            }else{
                
                count = self.dataCount/PageSzie + 1;
            }

            if (self.page <= count) {
               
                if (self.isFansVC) {
                    [self setMyFansListRequest];
                }else{
                    [self setMyWatchListRequest];
                }

            }else{
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
//    }else{
//        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
//    }
}
@end
