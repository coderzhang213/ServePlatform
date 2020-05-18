//
//  CMLCarChooseCouponsVC.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCarChooseCouponsVC.h"
#import "CMLChooseCouponsTableView.h"
#import "VCManger.h"
#import "CMLMyCouponsModel.h"

@interface CMLCarChooseCouponsVC ()<NavigationBarProtocol, CMLBaseTableViewDlegate, CMLChooseCouponsTableViewDelegate>

@property (nonatomic, strong) CMLChooseCouponsTableView *chooseCouponsTableView;

@property (nonatomic, strong) CMLMyCouponsModel *chooseCouponsModel;

@end

@implementation CMLCarChooseCouponsVC

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
    
    NSString *st = {self.carPriceArr};
    NSString *s = {self.carIdArr};
    if (!self.chooseCouponsTableView) {
        self.chooseCouponsTableView = [[CMLChooseCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                                  CGRectGetMaxY(self.navBar.frame),
                                                                                                  WIDTH,
                                                                                                  HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)
                                                                                 style:UITableViewStylePlain
                                                                                 carId:s
                                                                              priceArr:st
                                                                  chooseCouponsIdArray:self.couponsIdArray];
    }
    NSLog(@"%ld", (long)self.couponsIdArray.count);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48*Proportion)];
    self.chooseCouponsTableView.tableHeaderView = view;
    self.chooseCouponsTableView.chooseTableDelegate = self;
    self.chooseCouponsTableView.baseTableViewDlegate = self;
    if (@available(iOS 11.0, *)) {
        self.chooseCouponsTableView.estimatedRowHeight = 0;
        self.chooseCouponsTableView.estimatedSectionFooterHeight = 0;
        self.chooseCouponsTableView.estimatedSectionHeaderHeight = 0;
    }
    [self.contentView addSubview:self.chooseCouponsTableView];
    
    if (self.isSelect) {
        [self.chooseCouponsTableView refreshWith:self.row with:self.isSelect];
    }
}

- (void)didSelectedLeftBarItem {
    [self.delegate backChooseCarCouponsRefreshPrice];
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
- (void)backCarCouponsSelectObj:(NSArray *)chooseCoupons wihtRow:(NSInteger)row withIsSelect:(BOOL)isSelect {
//    self.row = row;
//    NSLog(@"ChooseVC-self.row %ld", (long)self.row);
//    self.isSelect = isSelect;
//
//    [self.delegate backChooseCarModelOfChooseVC:chooseCoupons withRow:[NSNumber numberWithInteger:self.row] withIsSelect:self.isSelect];
    
}

- (void)backCarCouponsPriceWith:(int)dataCount with:(BaseResultObj *)carCouponsObj {
//    [self.delegate backChooseCarCouponsWithDataCount:dataCount with:carCouponsObj];
}

- (void)backCarCouponsWithDataArray:(NSArray *)dataArray WithDict:(NSMutableDictionary *)dict {

    [self.delegate backCarChooseCouponsWithDataArray:dataArray WithDict:dict];
    
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
