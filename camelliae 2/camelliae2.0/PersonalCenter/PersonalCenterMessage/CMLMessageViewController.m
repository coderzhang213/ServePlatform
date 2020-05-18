//
//  CMLMessageViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/10.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMessageViewController.h"
#import "VCManger.h"
#import "CMLMessageCell.h"
#import "CMLMessageObj.h"
#import "ActivityDefaultVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLNewSpecialDetailTopicVC.h"
#import "WebViewLinkVC.h"
#import "CMLPushMessageRemindView.h"
#import "NSString+CMLExspand.h"
#import "CMLPrefectureVC.h"

@interface CMLMessageViewController ()<NavigationBarProtocol, NetWorkProtocol, UITableViewDelegate, UITableViewDataSource, CMLPushMessageRemindViewDelegate>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *datacount;

@property (nonatomic,assign) int page;

@property (nonatomic, assign) BOOL isPoint;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic, strong) CMLPushMessageRemindView *pushRemindView;

@end

@implementation CMLMessageViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDic {
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    return _heightDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"系统消息";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    [self loadMessageOfVC];
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadMessageOfVC];
        
    };
}

- (void)loadMessageOfVC {
    
    [self loadViews];
    [self loadData];
    NSLog(@"isSwitchAppNotification:%@", [NSString isSwitchAppNotification] ? @"YES":@"NO");
    
    /*是否开启推送*/
    if (![NSString isSwitchAppNotification]) {
//        NSLog(@"%d", [[[DataManager lightData] readIsSettingOfPush] intValue]);
        if ([[[DataManager lightData] readIsSettingOfPush] intValue] != 1) {
            /*只在第一次进入消息列表的时候弹出一次*/
            /*记录已弹出*/
            [[DataManager lightData] saveIsSettingOfPush:[NSNumber numberWithInt:1]];
            [self showPushRemindView];/*开启推送提示*/
        }
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)loadData {
    
    self.page = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (void)showPushRemindView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 WIDTH,
                                                                 HEIGHT)];
    self.shadowView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.hidden = NO;
    
    CMLPushMessageRemindView *pushRemindView = [[CMLPushMessageRemindView alloc] initWithFrame:CGRectMake(WIDTH/2 - 520 * Proportion/2, HEIGHT/2 - 630 * Proportion/2, 520 * Proportion, 630 * Proportion)];
    pushRemindView.delegate = self;
    [self.shadowView addSubview:pushRemindView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.shadowView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
    
}

- (void)loadViews {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.tableHeaderView = [[UIView alloc] init];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullMessageRefreshOfHeader)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    
}

- (void)pullMessageRefreshOfHeader {
    
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self setMessageRequest];
    
}

- (void)loadMoreData {
    
    if ([self.currentApiName isEqualToString:MemberCenterMessage]) {
        if (self.dataArray.count%10 == 0) {
            if (self.dataArray.count != [self.datacount intValue]) {
                self.page++;
                [self setMessageRequest];
            }else {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
}

- (void)scrollViewScrollToTop {
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 0) {
        return [[self.heightDic valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"messageCell";
    
    CMLMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CMLMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        CMLMessageObj *obj = [CMLMessageObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentCell:obj];
        NSLog(@"刷新");
        [self.heightDic setObject:[NSString stringWithFormat:@"%f", cell.currentHeight] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLMessageObj *obj = [CMLMessageObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
    [self setReadMessageRequestWith:obj.currentID];/*刷新红点点击状态*/
    
    switch ([obj.objType intValue]) {
        case 1:
            {
                NSLog(@"首页");
                [[VCManger mainVC] popToRootVC];
                [[VCManger homeVC] showCurrentViewController:0];
            }
            break;
            
        case 2:
            {
                NSLog(@"活动");
                [[VCManger mainVC] popToRootVC];
                [[VCManger homeVC] showCurrentViewController:1];
            }
            break;
            
        case 3:
            {
                NSLog(@"商城");
                [[VCManger mainVC] popToRootVC];
                [[VCManger homeVC] showCurrentViewController:4];
            }
            break;
            
        case 4:
            {
                NSLog(@"花伴");
                [[VCManger mainVC] popToRootVC];
                [[VCManger homeVC] showCurrentViewController:2];
            }
            break;
            
        case 5:
            {
                /*活动详情页*/
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 6:
            {
                /*单品详情页*/
                CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];

            }
            break;
            
        case 7:
            {
                /*服务详情页*/
                ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 8:
            {
                /*花伴活动详情*/
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 9:
            {
                /*花伴单品详情*/
                CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 10:
            {
                /*专题详情页*/
                CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 11:
            {
                /*资讯详情页*/
                CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            break;
            
        case 12:
            {
                /*H5页面*/
                WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
                vc.url = obj.objUrl;
                vc.name = obj.content;
                //        vc.isDetailMes = YES;
                [[VCManger mainVC] pushVC:vc animate:YES];
//                vc.shareUrl = obj.shareUrl;
//                vc.isShare = obj.shareStatus;
//                vc.desc = obj.desc;


            }
            break;
            
        case 13:
        {
            /*专区*/
            [[VCManger homeVC] showCurrentViewController:3];
            CMLMessageViewController *baseVC = [[CMLMessageViewController alloc] init];
            [[VCManger mainVC] pushVC:baseVC animate:NO];
            CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
            vc.currentID = obj.objId;
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
            break;
            
        default:
        {
            [[VCManger mainVC] popToRootVC];/*回到根视图-如果处于二级页面*/
            [[VCManger homeVC] showCurrentViewController:0];
            NSLog(@"首页");
        }
            break;
    }
    
}

#pragma mark - NavigationBarProtocol
- (void)didSelectedLeftBarItem {
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - Request
- (void)setMessageRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:[AppGroup getCurrentDate]], [[DataManager lightData] readSkey]]];
    [paraDict setObject:hashToken forKey:@"hashToken"];
    [paraDict setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    
    [NetWorkTask postResquestWithApiName:MemberCenterMessage paraDic:paraDict delegate:delegate];
    self.currentApiName = MemberCenterMessage;
    
}

- (void)setReadMessageRequestWith:(NSNumber *)msgId {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:msgId forKey:@"msgId"];
    [paraDict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:MemberCenterMessageRead paraDic:paraDict delegate:delegate];
    self.currentApiName = MemberCenterMessageRead;
    
}

#pragma mark - NetWorkProtocol
- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    if ([self.currentApiName isEqualToString:MemberCenterMessage]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            self.datacount = obj.retData.dataCount;
            if (self.page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else {
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
        }else if ([obj.retCode intValue] == 100101) {
            [self stopLoading];
            [self showReloadView];
        }else {
            if (self.page > 1) {
                self.page--;
            }
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
        [self.mainTableView reloadData];
        if (self.dataArray.count == 0) {
            self.mainTableView.tableFooterView = [self setCurrentServeTableFooterView];
            self.mainTableView.bounces = NO;
            self.mainTableView.bouncesZoom = NO;
        }else {
            self.mainTableView.tableFooterView = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, WIDTH, 20 * Proportion)];
            self.mainTableView.bounces = YES;
            self.mainTableView.bouncesZoom = YES;
        }
    }else if ([self.currentApiName isEqualToString:MemberCenterMessageRead]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            [self loadData];
        }
    }
    
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
    [self hideNetErrorTipOfNormalVC];
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    if (self.page > 1) {
        self.page--;
    }
    [self showNetErrorTipOfNormalVC];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

- (UIView *)setCurrentServeTableFooterView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT - self.navBar.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterNoMesImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(bgView.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 bgView.frame.size.height/2.0 - imageView.frame.size.height - self.navBar.frame.size.height/2,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无消息";
    label.font = KSystemFontSize14;
    label.textColor = [UIColor CMLLineGrayColor];
    [label sizeToFit];
    label.frame = CGRectMake(bgView.frame.size.width/2.0 - label.frame.size.width/2.0,
                             CGRectGetMaxY(imageView.frame) + 20 * Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [bgView addSubview:label];
    
    return bgView;
}

#pragma mark - CMLPushMessageRemindViewDelegate
- (void)pushRemindViewCloseButtonClicked {
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.alpha = 0;
    }];
}

- (void)pushRemindViewOpenButtonClicked {
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.alpha = 0;
    }];

    if (@available(iOS 10.0, *)) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            }];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置页面打开通知" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
