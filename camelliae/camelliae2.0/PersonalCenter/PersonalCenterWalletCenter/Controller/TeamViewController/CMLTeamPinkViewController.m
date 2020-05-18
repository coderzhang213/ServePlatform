//
//  CMLTeamPinkViewController.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/8/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLTeamPinkViewController.h"
#import "CMLWalletCenterTableView.h"
#import "VCManger.h"


@interface CMLTeamPinkViewController ()<NavigationBarProtocol, NetWorkProtocol, CMLBaseTableViewDlegate>

@property (nonatomic, strong) CMLWalletCenterTableView *teamTableView;

@end

@implementation CMLTeamPinkViewController

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
        _teamTableView = [[CMLWalletCenterTableView alloc] initWithFrame:CGRectMake(0,
                                                                                    CGRectGetMaxY(self.navBar.frame),
                                                                                    WIDTH,
                                                                                    HEIGHT - UITabBarHeight - SafeAreaBottomHeight)
                                                                   style:UITableViewStylePlain
                                                            withTeamType:self.teamType];
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

- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
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
