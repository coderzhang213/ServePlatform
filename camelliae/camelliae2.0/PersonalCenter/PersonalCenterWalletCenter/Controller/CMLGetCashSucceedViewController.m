//
//  CMLGetCashSucceedViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/18.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLGetCashSucceedViewController.h"
#import "VCManger.h"
#import "CMLWalletCenterViewController.h"

@interface CMLGetCashSucceedViewController ()<NavigationBarProtocol>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UIButton *completeButton;

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation CMLGetCashSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"提现";
    [self.navBar setLeftBarItem];
    self.navBar.bottomLine.lineWidth = 2 * Proportion;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.hidden = NO;
    [self.contentView addSubview:self.navBar];
    [self loadWalletCenterView];
}

- (void)loadWalletCenterView {
    
    self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱包中心_提现申请成功"]];
    self.iconImage.backgroundColor = [UIColor clearColor];
    [self.iconImage sizeToFit];
    self.iconImage.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.iconImage.frame)/2, CGRectGetMaxY(self.navBar.frame) + 107 * Proportion, CGRectGetWidth(self.iconImage.frame), CGRectGetHeight(self.iconImage.frame));
    [self.contentView addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"提现申请成功";
    self.titleLabel.textColor = [UIColor CML383838Color];
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.titleLabel.frame)/2, CGRectGetMaxY(self.iconImage.frame) + 76 * Proportion, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    [self.contentView addSubview:self.titleLabel];
    
    self.introLabel = [[UILabel alloc] init];
    self.introLabel.text = @"请等待客服联系";
    self.introLabel.textColor = [UIColor CML888888Color];
    self.introLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.introLabel sizeToFit];
    self.introLabel.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.introLabel.frame)/2, CGRectGetMaxY(self.titleLabel.frame) + 5 * Proportion, CGRectGetWidth(self.introLabel.frame), CGRectGetHeight(self.introLabel.frame));
    [self.contentView addSubview:self.introLabel];
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.completeButton setImage:[UIImage imageNamed:@"钱包中心_完成"] forState:UIControlStateNormal];
    self.completeButton.backgroundColor = [UIColor clearColor];
    [self.completeButton sizeToFit];
    self.completeButton.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(self.completeButton.frame)/2,
                                           CGRectGetMaxY(self.introLabel.frame) + 71 * Proportion,
                                           CGRectGetWidth(self.completeButton.frame),
                                           CGRectGetHeight(self.completeButton.frame));
    [self.contentView addSubview:self.completeButton];
    [self.completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)completeButtonClick {
    
//    CMLWalletCenterViewController *vc = [[CMLWalletCenterViewController alloc] init];
//
//    [[VCManger mainVC] pushVC:vc animate:YES];
    [self popCMLWalletCenterViewController];
}

- (void) didSelectedLeftBarItem{
    [self popCMLWalletCenterViewController];
//    [[VCManger mainVC] dismissCurrentVC];
}

- (void)popCMLWalletCenterViewController {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[CMLWalletCenterViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
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
