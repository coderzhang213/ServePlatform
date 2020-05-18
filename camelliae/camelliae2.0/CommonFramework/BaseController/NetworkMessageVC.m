//
//  NetworkMessageVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/4/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "NetworkMessageVC.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "VCManger.h"

@interface NetworkMessageVC ()<NavigationBarProtocol>

@end
@implementation NetworkMessageVC


- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.titleContent = @"网络问题解决方案";
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = KSystemBoldFontSize14;
    titleLabel.textColor = [UIColor CMLBlackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"建议按照以下方法检查网络连接\n1.打开手机“设置”并把“Wi-Fi”开关保持开启状态。\n2.打开手机“设置”-“蜂窝移动网络”，并找到“卡枚连”APP把“蜂窝移动数据”开关保持开启状态。\n3.如果仍无法连接网络，请检查手机接入的“Wi-Fi”是否已接入互联网或者咨询网络运营商。";
    CGRect currentRect= [titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:KSystemBoldFontSize14}
                                                      context:nil];
    titleLabel.frame = CGRectMake(30*Proportion, CGRectGetMaxY(self.navBar.frame) + 30*Proportion, WIDTH - 30*Proportion*2, currentRect.size.height);
    [self.view addSubview:titleLabel];

}
- (void) didSelectedLeftBarItem{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
