//
//  CMLCodeScanViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/29.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCodeScanViewController.h"
#import "CMLNavigationBar.h"
#import "VCManger.h"

@interface CMLCodeScanViewController ()<NavigationBarProtocol, UINavigationBarDelegate>

@end

@implementation CMLCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleContent = @"扫码结果";
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    resultLabel.center = self.contentView.center;
    resultLabel.text = self.resultString;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor CMLYellowD9AB5EColor];
    resultLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    [self.contentView addSubview:resultLabel];
}

- (void)didSelectedLeftBarItem {
    
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
