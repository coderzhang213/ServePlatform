//
//  VMLMainInterfaceVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLMainInterfaceVC.h"
#import <UMAnalytics/MobClick.h>
#import "MianInterfaceRecommendView.h"
#import "CMLTelePhoneBindView.h"
#import "MainRecommendTableView.h"
#import "HotRecommend.h"
#import "CMLMainInterfaceTopView.h"
#import "SpecialTopicTableView.h"
#import "MainInterfaceImageTableView.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLGiftVC.h"
#import "VCManger.h"
#import "AppDelegate.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"
#import <SdkSample/SdkSample.h>
#import "CMLPrefectureVC.h"
#import "CMLPushMessageRemindView.h"

@interface CMLMainInterfaceVC ()<CMLTelePhoneBindViewDelegate,CMLBaseTableViewDlegate,CMLMainInterfaceTopViewDelegate, CMLPushMessageRemindViewDelegate>

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,strong) MainRecommendTableView *mainTableView;

@property (nonatomic,strong) SpecialTopicTableView *mainTableView1;

@property (nonatomic,strong) MainInterfaceImageTableView *mainTableView2;

@property (nonatomic,strong) CMLMainInterfaceTopView *topView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic, strong) CMLPushMessageRemindView *pushRemindView;

@property (nonatomic, strong) CMLTelePhoneBindView *bindView;

@end

@implementation CMLMainInterfaceVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageOneOfMainInterface"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOneOfMainInterface"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[DataManager lightData] readAbsoluteString].length > 0) {
        [self otherJumpVC];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JumpVC:) name:@"jumpVc" object:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.selectIndex = 0;
    
    [self loadViews];
    NSLog(@"readPhone %@", [[DataManager lightData] readPhone]);
    if ([[DataManager lightData] readPhone].length < 11) {
        [self performSelector:@selector(showMessage) withObject:nil afterDelay:1];
    }
    /*是否开启推送*/
    if (![NSString isSwitchAppNotification]) {
        if ([[[DataManager lightData] readIsMainOfPush] intValue] != 0) {
            /*记录已弹出*/
            [[DataManager lightData] saveIsMainOfPush:[NSNumber numberWithInt:0]];
            [self showPushRemindView];/*开启推送提示*/
        }
    }
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
    
    CMLPushMessageRemindView *pushRemindView = [[CMLPushMessageRemindView alloc] initWithFrame:CGRectMake(WIDTH/2 - 520 * Proportion/2,
                                                                                                          HEIGHT/2 - 630 * Proportion/2, 520 * Proportion, 630 * Proportion)];
    pushRemindView.delegate = self;
    [self.shadowView addSubview:pushRemindView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.shadowView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
}

- (void) showMessage{
    
    self.bindView = [[CMLTelePhoneBindView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           WIDTH,
                                                                           HEIGHT)];
    self.bindView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bindView];
    if ([[DataManager lightData] readPhone].length < 11) {   
    }else {
        [self.bindView removeFromSuperview];
    }
}

- (void) loadViews{
    
    [self startLoading];
    
    self.topView = [[CMLMainInterfaceTopView alloc] init];
    self.topView.delegate = self;
    [self.contentView addSubview:self.topView];

    self.mainTableView = [[MainRecommendTableView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetMaxY(self.topView.frame),
                                                                                  WIDTH,
                                                                                  HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight)
                                                                 style:UITableViewStylePlain];
    self.mainTableView.baseTableViewDlegate = self;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            StatusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    UITapGestureRecognizer *doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [view addGestureRecognizer:doubleRecognizer];
    
    HotRecommend *hotReommendView = [[HotRecommend alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:hotReommendView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hotReommendView];
    
}

- (void) otherJumpVC {
    
    NSString *targetStr = [[DataManager lightData] readAbsoluteString];
    
    //    NSArray *acceptNum = [targetStr componentsSeparatedByString:@"&id="];
    
    NSArray *acceptNum = [targetStr componentsSeparatedByString:@"&"];
    
    [[DataManager lightData] removeAbsoluteString];
    
    if([[acceptNum firstObject] intValue] == 1){
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        /**咨询*/
        InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]] ];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if([[acceptNum firstObject] intValue] == 2){
        
        /**活动详情*/
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([[acceptNum firstObject] intValue] == 3){
        
        /**服务详情*/
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableString *tempStr1 = [acceptNum lastObject];
        NSString *targetStr1 = [tempStr1 substringFromIndex:4];
        appDelegate.pid = targetStr1;
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if ([[acceptNum firstObject] intValue] == 4){
//        NSMutableString *tempStr = acceptNum[1];
//        NSString *targetStr = [tempStr substringFromIndex:4];
        
        /*专区*/
        CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if ([[acceptNum firstObject] intValue] == 7){
        
        /**商品*/
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
    
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableString *tempStr1 = [acceptNum lastObject];
        NSString *targetStr1 = [tempStr1 substringFromIndex:4];
        appDelegate.pid = targetStr1;
        
        CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([[acceptNum firstObject] intValue] == 8){
        
        /**礼品*/
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}


- (void) JumpVC:(NSNotification *) notification{
    

    NSDictionary *userInfo = [notification userInfo];

    NSString *targetStr = [userInfo objectForKey:@"jumpVc"];
    
//    NSArray *acceptNum = [targetStr componentsSeparatedByString:@"&id="];

    NSArray *acceptNum = [targetStr componentsSeparatedByString:@"&"];

    
    if([[acceptNum firstObject] intValue] == 1){
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        /**咨询*/
        InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]] ];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if([[acceptNum firstObject] intValue] == 2){
        
        /**活动详情*/
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([[acceptNum firstObject] intValue] == 3){
        
        /**服务详情*/
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        

        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableString *tempStr1 = [acceptNum lastObject];
        NSString *targetStr1 = [tempStr1 substringFromIndex:4];
        appDelegate.pid = targetStr1;
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if ([[acceptNum firstObject] intValue] == 22){
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];


    }else if ([[acceptNum firstObject] intValue] == 33){
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];

        
    }else if ([[acceptNum firstObject] intValue] == 77){
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
    else if ([[acceptNum firstObject] intValue] == 4){
        
        
    }else if ([[acceptNum firstObject] intValue] == 7){
        
        /**商品*/
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableString *tempStr1 = [acceptNum lastObject];
        NSString *targetStr1 = [tempStr1 substringFromIndex:4];
        appDelegate.pid = targetStr1;
        
        
        CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([[acceptNum firstObject] intValue] == 8){
        
        /**礼品*/
        
        NSMutableString *tempStr = acceptNum[1];
        NSString *targetStr = [tempStr substringFromIndex:3];
        
        CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:[NSNumber numberWithInt:[targetStr intValue]]];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

}

- (void) loadTopicTableView{
    
    if (!self.mainTableView1) {
        
        [self startLoading];
        self.mainTableView1 = [[SpecialTopicTableView alloc] initWithFrame:CGRectMake(0,
                                                                                      CGRectGetMaxY(self.topView.frame),
                                                                                      WIDTH,
                                                                                      HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight)
                                                                     style:UITableViewStylePlain];
        self.mainTableView1.baseTableViewDlegate = self;
        
        if (@available(iOS 11.0, *)){
            self.mainTableView1.estimatedRowHeight = 0;
            self.mainTableView1.estimatedSectionHeaderHeight = 0;
            self.mainTableView1.estimatedSectionFooterHeight = 0;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5*Proportion)];
        self.mainTableView1.tableHeaderView = view;
        
        [self.contentView addSubview:self.mainTableView1];
    }else{
        
        self.mainTableView1.hidden = NO;
    }
}

- (void) loadImagesTableVoew{
    
    if (!self.mainTableView2) {
        
        [self startLoading];
        self.mainTableView2 = [[MainInterfaceImageTableView alloc] initWithFrame:CGRectMake(0,
                                                                                            CGRectGetMaxY(self.topView.frame),
                                                                                            WIDTH,
                                                                                            HEIGHT - UITabBarHeight -   self.topView.frame.size.height - SafeAreaBottomHeight)
                                                                     style:UITableViewStylePlain];
        self.mainTableView2.baseTableViewDlegate = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20*Proportion)];
        self.mainTableView2.tableHeaderView = view;
        if (@available(iOS 11.0, *)){
            self.mainTableView2.estimatedRowHeight = 0;
            self.mainTableView2.estimatedSectionHeaderHeight = 0;
            self.mainTableView2.estimatedSectionFooterHeight = 0;
        }
        [self.contentView addSubview:self.mainTableView2];
    }else{
        
        self.mainTableView2.hidden = NO;
    }
}

#pragma mark- handleDoubleTapFrom
- (void) handleDoubleTapFrom{

    if (self.selectIndex == 0) {
     
        [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if(self.selectIndex == 1){
        
        [self.mainTableView1 setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else{
        
        [self.mainTableView2 setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - CMLTelePhoneBindViewDelegate
- (void) requestStartLoading{

    [self startIndicatorLoading];
}

- (void) requestFinshedLoading{

    [self stopIndicatorLoading];
}

- (void) showErrorMessageOfBindPhone:(NSString *) str{

    [self showFailTemporaryMes:str];
}

- (void) showSuccessMessageOfBindPhone:(NSString *) str{

    [self showSuccessTemporaryMes:str];
}

#pragma mark - CMLBaseTableViewDlegate

- (void) startRequesting{
    
    [self startLoading];
}

- (void) endRequesting{
    
    [self stopLoading];
}

- (void) showSuccessActionMessage:(NSString *) str{
    
    [self showSuccessTemporaryMes:str];
}

- (void) showFailActionMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) showAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];
    
}

- (void) tableScrollUp{
    
        if (!self.topView.isUp) {
            
            [self.topView moveUp];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                
                weakSelf.mainTableView.frame = CGRectMake(0,
                                                          CGRectGetMaxY(self.topView.frame),
                                                          WIDTH,
                                                          HEIGHT - UITabBarHeight - self.topView.frame.size.height + 80*Proportion - SafeAreaBottomHeight);
                
                weakSelf.mainTableView1.frame = CGRectMake(0,
                                                           CGRectGetMaxY(self.topView.frame),
                                                           WIDTH,
                                                           HEIGHT - UITabBarHeight - self.topView.frame.size.height + 80*Proportion - SafeAreaBottomHeight);
                
                weakSelf.mainTableView2.frame = CGRectMake(0,
                                                           CGRectGetMaxY(self.topView.frame),
                                                           WIDTH,
                                                           HEIGHT - UITabBarHeight - self.topView.frame.size.height + 80*Proportion - SafeAreaBottomHeight);
            }];
        }
    
}

- (void) tableScrollDown{
    
    if (self.topView.isUp) {
        
        [self.topView moveDown];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.mainTableView.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.topView.frame),
                                                      WIDTH,
                                                      HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);
            weakSelf.mainTableView1.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.topView.frame),
                                                      WIDTH,
                                                      HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);
            
            weakSelf.mainTableView2.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.topView.frame),
                                                       WIDTH,
                                                       HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);
        }];
    }
    
}

- (void) tableScrollZero{

    if (self.topView.isUp) {

        [self.topView moveDown];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{

            weakSelf.mainTableView.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.topView.frame),
                                                      WIDTH,
                                                      HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);
            weakSelf.mainTableView1.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.topView.frame),
                                                      WIDTH,
                                                      HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);

            weakSelf.mainTableView2.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.topView.frame),
                                                       WIDTH,
                                                       HEIGHT - UITabBarHeight - self.topView.frame.size.height - SafeAreaBottomHeight);
        }];
    }
}

#pragma mark - CMLMainInterfaceTopViewDelegate
- (void) selectTypeIndex:(int) index{
    
    self.selectIndex = index;
    
    if (index == 0) {
        
        self.mainTableView1.hidden = YES;
        self.mainTableView2.hidden = YES;
        self.mainTableView.hidden = NO;
    }else if (index == 1){
        
        self.mainTableView.hidden = YES;
        self.mainTableView2.hidden = YES;
        [self loadTopicTableView];
        
    }else{
        
        self.mainTableView.hidden = YES;
        self.mainTableView1.hidden = YES;
        [self loadImagesTableVoew];
        
    }
 
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

@end
