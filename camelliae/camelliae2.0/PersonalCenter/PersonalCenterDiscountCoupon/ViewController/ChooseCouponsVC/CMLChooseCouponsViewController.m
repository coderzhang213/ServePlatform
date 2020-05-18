//
//  CMLChooseCouponsViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLChooseCouponsViewController.h"
#import "CMLMyCouponsTableView.h"
#import "VCManger.h"
#import "CMLMyCouponsModel.h"

@interface CMLChooseCouponsViewController ()<NavigationBarProtocol, NetWorkProtocol, CMLBaseTableViewDlegate, CMLMyCouponsTableViewDelegate>

@property (nonatomic, strong) CMLMyCouponsTableView *myCouponsTableView;

@property (nonatomic, strong) CMLMyCouponsModel *chooseCouponsModel;

@end

@implementation CMLChooseCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"选择优惠券";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    [self loadMessageOfVC];
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^{
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
}

- (void)loadMessageOfVC {
    
    [self loadViews];
    
}

- (void)loadViews {
    NSLog(@"CMLChooseCouponsViewController-self.price%@", self.price);
    if (!self.myCouponsTableView) {
        self.myCouponsTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                          CGRectGetMaxY(self.navBar.frame),
                                                                                          WIDTH,
                                                                                          HEIGHT -  CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)
                                                                         style:UITableViewStylePlain
                                                                     withIsUse:[NSNumber numberWithInt:0]
                                                                   withProcess:[NSNumber numberWithInt:2]
                                                                       withObj:self.detailObj
                                                               withCouponsType:CanUseCouponsTableType
                                                                     withPrice:self.price];
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48*Proportion)];
    self.myCouponsTableView.tableHeaderView = view;
    self.myCouponsTableView.couponsTableDelegate = self;
    self.myCouponsTableView.baseTableViewDlegate = self;
    if (@available(iOS 11.0, *)) {
        self.myCouponsTableView.estimatedRowHeight = 0;
        self.myCouponsTableView.estimatedSectionFooterHeight = 0;
        self.myCouponsTableView.estimatedSectionHeaderHeight = 0;
    }
    [self.contentView addSubview:self.myCouponsTableView];
    
    if (self.isSelect) {
        [self.myCouponsTableView refreshWith:self.row with:self.isSelect];
    }
    
}

- (void)didSelectedLeftBarItem {
    [[VCManger mainVC] dismissCurrentVC];
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

#pragma CMLMyCouponsTableViewDelegate
- (void)backCouponsSelectObj:(CMLMyCouponsModel *)chooseCouponsModel wihtRow:(NSInteger)row withIsSelect:(BOOL)isSelect {
    
    self.row = row;
    NSLog(@"ChooseVC-self.row %ld", (long)self.row);
    self.isSelect = isSelect;
    self.chooseCouponsModel = chooseCouponsModel;
    [self.chooseVCDelegate backChooseCouponsModelOFChooseVC:self.chooseCouponsModel withRow:[NSNumber numberWithInteger:self.row] withIsSelect:self.isSelect];
    
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
