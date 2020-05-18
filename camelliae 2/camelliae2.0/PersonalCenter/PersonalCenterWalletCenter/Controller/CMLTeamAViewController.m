//
//  CMLTeamAViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/12.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLTeamAViewController.h"
#import "CMLWalletCenterTeamCell.h"
#import "CMLWalletCenterModel.h"
#import "VCManger.h"
#import "CMLWalletCenterTableView.h"
#import "CMLWalletCenterMyTeamCell.h"

#define PageSize 10

@interface CMLTeamAViewController ()<NavigationBarProtocol, NetWorkProtocol, CMLBaseTableViewDlegate>

@property (nonatomic, strong) CMLWalletCenterTableView *teamTableView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy)   NSString *currentApiName;

@property (nonatomic, strong) NSNumber *dataCount;

@property (nonatomic, assign) int page;

@end

@implementation CMLTeamAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLUserBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"我的团队";
    self.navBar.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.navBar setLeftBarItem];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.teamTableView];
}

- (CMLWalletCenterTableView *)teamTableView {

    if (!_teamTableView) {
        _teamTableView = [[CMLWalletCenterTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), WIDTH, HEIGHT - UITabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain withTeamType:0];
        _teamTableView.backgroundColor = [UIColor whiteColor];
        _teamTableView.baseTableViewDlegate = self;
        _teamTableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _teamTableView.estimatedRowHeight = 0;
            _teamTableView.estimatedSectionFooterHeight = 0;
            _teamTableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _teamTableView;
}

- (void)loadData {
    
    [self startLoading];
    
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

@end

