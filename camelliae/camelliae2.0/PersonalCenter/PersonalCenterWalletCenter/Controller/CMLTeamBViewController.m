//
//  CMLTeamBViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLTeamBViewController.h"
#import "CMLWalletCenterTeamCell.h"
#import "CMLWalletCenterModel.h"
#import "VCManger.h"
#import "CMLWalletCenterTableView.h"
#import "CMLWalletCenterMyTeamCell.h"

@interface CMLTeamBViewController ()<NetWorkProtocol, CMLBaseTableViewDlegate, NavigationBarProtocol>

@property (nonatomic, strong) CMLWalletCenterTableView *teamTableView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *currentApiName;

@end

@implementation CMLTeamBViewController

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

- (UITableView *)teamTableView {
    
    if (!_teamTableView) {
        
        _teamTableView = [[CMLWalletCenterTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), WIDTH, HEIGHT - UITabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain withTeamType:1];
        _teamTableView.backgroundColor = [UIColor whiteColor];
        if (self.titleName) {
            _teamTableView.titleName = self.titleName;
        }
//        _teamTableView.isTeamB = YES;
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
