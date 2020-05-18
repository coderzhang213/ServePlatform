//
//  CMLNewVipVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewVipVC.h"
#import "CMLNewVIPTopView.h"
#import "CMLNewVIPTableView.h"
#import "CMLNewSelectTypeView.h"


#define TopViewHeight                100

@interface CMLNewVipVC ()<CMLBaseTableViewDlegate,CMLNewSelectTypeViewDelegate,NewVIPTableViewDelegate>

@property (nonatomic,strong) CMLNewVIPTopView *topView;

@property (nonatomic,strong) CMLNewVIPTableView *VIPTableView;

@property (nonatomic,strong) CMLNewSelectTypeView *selectTypeView;

@end

@implementation CMLNewVipVC



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageOneOfVIP"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershTopView) name:@"refreshUserPoints" object:nil];
    [self refershTopView];
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageOneOfVIP"];
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.hidden = YES;
    
    [self startLoading];
    [self loadViews];
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
        [weakSelf hideNetErrorTipOfMainVC];
        [weakSelf loadViews];
    };
}

- (void) loadViews{
    
    self.VIPTableView = [[CMLNewVIPTableView alloc] initWithFrame:CGRectMake(0,
                                                                             TopViewHeight*Proportion + StatusBarHeight + 20*Proportion,
                                                                             WIDTH,
                                                                             HEIGHT - UITabBarHeight - TopViewHeight*Proportion - StatusBarHeight - SafeAreaBottomHeight - 20*Proportion)
                                                            style:UITableViewStylePlain];
    self.VIPTableView.baseTableViewDlegate = self;
    self.VIPTableView.VIPTableViewDelegate = self;
    [self.contentView addSubview:self.VIPTableView];
    
    
    
    self.selectTypeView = [[CMLNewSelectTypeView alloc] initWithFrame:CGRectMake(0,
                                                                                 TopViewHeight*Proportion + StatusBarHeight,
                                                                                 WIDTH,
                                                                                 80*Proportion)
                                                    andTypeNamesArray:@[@"全部",
                                                                        @"活动",
                                                                        @"商品"]];


    self.selectTypeView.currentSelectIndex = 0;
    [self.selectTypeView refreshNewTypeViews];
    self.selectTypeView.delegate = self;
    [self.contentView addSubview:self.selectTypeView];
    self.selectTypeView.hidden = YES;
    
    [self setTopView];

}

- (void) setTopView{

    self.topView = [[CMLNewVIPTopView alloc] initWithFrame:CGRectMake(0,
                                                                      StatusBarHeight,
                                                                      WIDTH,
                                                                      TopViewHeight*Proportion)];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.topView.layer.shadowOpacity = 0.05;
//    self.topView.layer.shadowOffset = CGSizeMake(0, 2);
    [self.contentView addSubview:self.topView];
    

    
    /**回滚*/
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            StatusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    UITapGestureRecognizer *doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewMainTableViewTop)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [view addGestureRecognizer:doubleRecognizer];

}

#pragma mark- handleDoubleTapFrom
- (void) scrollViewMainTableViewTop{
    
    [self.VIPTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void) refershTopView{

    [self.topView refreshUserImage];

}


#pragma mark - CMLBaseTableViewDlegate

- (void) startRequesting{
    
    [self startLoading];
}

- (void) endRequesting{
    
     [self stopLoading];
}

- (void) showSuccessActionMessage:(NSString *) str{
    
    [self showSuccessActionMessage:str];
}

- (void) showFailActionMessage:(NSString *) str{
    
     [self showFailTemporaryMes:str];
}

- (void) showAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];

}

#pragma mark - CMLNewSelectTypeViewDelegate
- (void) newSelectTypeViewSelect:(int) index{

    [self.VIPTableView refreshNewVIPTableViewIndex:index];

}

#pragma mark - NewVIPTableViewDelegate

- (void) tableViewSelctIndex:(int) index{
    
    self.selectTypeView.currentSelectIndex = index;
    [self.selectTypeView refreshNewTypeViews];

}

- (void) showSelectView:(BOOL) isShow{
    
    if (isShow) {
        
        self.selectTypeView.hidden = YES;
    }else{
        
        self.selectTypeView.hidden = NO;
    }
}

- (void)tableViewNetError {
    [self showNetErrorTipOfMainVC];
}

@end
