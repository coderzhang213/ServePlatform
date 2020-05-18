//
//  CMLINtgrationRulesVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLINtgrationRulesVC.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"

@interface CMLINtgrationRulesVC ()<NavigationBarProtocol>

@end

@implementation CMLINtgrationRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    self.navBar.titleContent = @"积分规则";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC]dismissCurrentVC];

}

@end
