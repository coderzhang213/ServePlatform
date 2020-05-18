//
//  CMLCouponViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/8.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCouponViewController.h"
#import "VCManger.h"
#import "CMLMyCouponsTopView.h"
#import "CMLMyCouponsTableView.h"

@interface CMLCouponViewController ()<NavigationBarProtocol, CMLMyCouponsTopViewDelegate, CMLBaseTableViewDlegate>

@property (nonatomic, strong) CMLMyCouponsTopView *myCouponsTopView;

@property (nonatomic, strong) CMLMyCouponsTableView *firstTableView;

@property (nonatomic, strong) CMLMyCouponsTableView *secondTableView;

@property (nonatomic, strong) CMLMyCouponsTableView *thirdTableView;

@property (nonatomic, assign) int selectIndex;

@property (nonatomic,assign) int page;

@end

@implementation CMLCouponViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"CMLCouponViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"CMLCouponViewController"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"我的卡券";
    [self.navBar setLeftBarItem];
    self.navBar.titleColor = [UIColor CMLBlack2D2D2DColor];
    self.navBar.delegate = self;
    self.selectIndex = 0;

    [self loadViews];
}

- (void)loadMessageOfVC {
    [self loadViews];
}

- (void)loadViews {
    
    if (!self.myCouponsTopView) {
        self.myCouponsTopView = [[CMLMyCouponsTopView alloc] initWithFrame:CGRectMake(0,
                                                                                      CGRectGetMaxY(self.navBar.frame),
                                                                                      WIDTH,
                                                                                      100*Proportion)];
    }
    self.myCouponsTopView.delegate = self;
    [self.contentView addSubview:self.myCouponsTopView];
    
    self.firstTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetMaxY(self.myCouponsTopView.frame) + 15 * Proportion,
                                                                                  WIDTH,
                                                                                  HEIGHT - CGRectGetMaxY(self.myCouponsTopView.frame) - SafeAreaBottomHeight)
                                                                 style:UITableViewStylePlain
                                                             withIsUse:[NSNumber numberWithInt:0]
                                                           withProcess:nil
                                                               withObj:nil
                                                       withCouponsType:MyCouponsTableType
                                                             withPrice:nil];
    self.firstTableView.baseTableViewDlegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.firstTableView.estimatedRowHeight = 0;
        self.firstTableView.estimatedSectionHeaderHeight = 0;
        self.firstTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.firstTableView];

}

- (void)didSelectedLeftBarItem {
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

#pragma CMLMyCouponsTopViewDelegate
- (void)selectOfMyCouponsTypeIndex:(int)index {
    
    self.selectIndex = index;
    
    if (index == 0) {
        self.firstTableView.hidden = NO;
        self.secondTableView.hidden = YES;
        self.thirdTableView.hidden = YES;
    }else if (index == 1) {
        self.firstTableView.hidden = YES;
        [self loadSecondTableView];
        self.thirdTableView.hidden = YES;
    }else {
        self.firstTableView.hidden = YES;
        self.secondTableView.hidden = YES;
        [self loadThirdTableView];
    }
    
}

- (void)loadSecondTableView {
    
    if (!self.secondTableView) {
        self.secondTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                       CGRectGetMaxY(self.myCouponsTopView.frame) + 15 * Proportion,
                                                                                       WIDTH,
                                                                                       HEIGHT - 100 * Proportion - SafeAreaBottomHeight)
                                                                      style:UITableViewStylePlain
                                                                  withIsUse:[NSNumber numberWithInt:1]
                                                                withProcess:nil
                                                                    withObj:nil
                                                            withCouponsType:MyCouponsTableType
                                                                  withPrice:nil];
        self.secondTableView.baseTableViewDlegate = self;
        
        if (@available(iOS 11.0, *)) {
            self.secondTableView.estimatedRowHeight = 0;
            self.secondTableView.estimatedSectionHeaderHeight = 0;
            self.secondTableView.estimatedSectionFooterHeight = 0;
        }
        [self.contentView addSubview:self.secondTableView];
    }else {
        self.secondTableView.hidden = NO;
    }
    
}

- (void)loadThirdTableView {
    
    if (!self.thirdTableView) {
        self.thirdTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                      CGRectGetMaxY(self.myCouponsTopView.frame) + 15 * Proportion,
                                                                                      WIDTH,
                                                                                      HEIGHT - 100 * Proportion - SafeAreaBottomHeight)
                                                                     style:UITableViewStylePlain
                                                                 withIsUse:[NSNumber numberWithInt:3]
                                                               withProcess:[NSNumber numberWithInt:3]
                                                                   withObj:nil
                                                           withCouponsType:MyCouponsTableType
                                                                 withPrice:nil];
        self.thirdTableView.baseTableViewDlegate = self;
        
        if (@available(iOS 11.0, *)) {
            self.thirdTableView.estimatedRowHeight = 0;
            self.thirdTableView.estimatedSectionHeaderHeight = 0;
            self.thirdTableView.estimatedSectionFooterHeight = 0;
        }
        [self.contentView addSubview:self.thirdTableView];
    }else {
        self.thirdTableView.hidden = NO;
    }
    
}

#pragma CMLBaseTableViewDlegate
- (void)startRequesting {
    [self startLoading];
}

- (void)endRequesting {
    [self stopLoading];
}

- (void)showSuccessActionMessage:(NSString *)str {
    [self showSuccessTemporaryMes:str];
}

- (void)showFailActionMessage:(NSString *)str {
    [self showFailTemporaryMes:str];
}

- (void)showAlterView:(NSString *)text {
    [self showAlterViewWithText:text];
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
