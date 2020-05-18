//
//  CMLWriteTypeSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/19.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLWriteTypeSelectView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLWriteVC.h"
#import "VCManger.h"
#import "LMWordViewController.h"
#import "LMWordViewOfGoodsController.h"

@implementation CMLWriteTypeSelectView

- (instancetype)init{

    self = [super init];
    
    if (self) {

        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                HEIGHT);
        self.backgroundColor = [[UIColor CMLBlackColor]colorWithAlphaComponent:0.5];
        [self loadViews];
    }
    
    return self;
}


- (void) loadViews{

    
    
    UIView *writeActivityBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 200*Proportion/2.0,
                                                                          HEIGHT/2.0 - (200*Proportion*2 + 50*Proportion)/2.0,
                                                                          200*Proportion,
                                                                          200*Proportion)];
    writeActivityBgView.backgroundColor = [UIColor CMLWhiteColor];
    writeActivityBgView.layer.cornerRadius = 200*Proportion/2.0;
    [self addSubview:writeActivityBgView];
    
    UIButton *writeActivityBtn = [[UIButton alloc] initWithFrame:CGRectMake(200*Proportion/2.0 - 180*Proportion/2.0,
                                                                           200*Proportion/2.0 - 180*Proportion/2.0,
                                                                           180*Proportion,
                                                                           180*Proportion)];
    writeActivityBtn.layer.cornerRadius = 180*Proportion/2.0;
    writeActivityBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    writeActivityBtn.layer.borderWidth = 1;
    [writeActivityBtn setTitle:@"发活动" forState:UIControlStateNormal];
    [writeActivityBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    writeActivityBtn.titleLabel.font = KSystemBoldFontSize16;
    [writeActivityBgView addSubview:writeActivityBtn];
    [writeActivityBtn addTarget:self action:@selector(enterWriteActivityVC) forControlEvents:UIControlEventTouchUpInside];
    
/*/    UIView *writeServeBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 200*Proportion/2.0,
//                                                                           CGRectGetMaxY(writeActivityBgView.frame) + 50*Proportion,
//                                                                           200*Proportion,
//                                                                           200*Proportion)];
//    writeServeBgView.backgroundColor = [UIColor CMLWhiteColor];
//    writeServeBgView.layer.cornerRadius = 200*Proportion/2.0;
//    [self addSubview:writeServeBgView];
    
//    UIButton *writeServeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200*Proportion/2.0 - 180*Proportion/2.0,
//                                                                            200*Proportion/2.0 - 180*Proportion/2.0,
//                                                                            180*Proportion,
//                                                                            180*Proportion)];
//    writeServeBtn.layer.cornerRadius = 180*Proportion/2.0;
//    writeServeBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
//    writeServeBtn.layer.borderWidth = 1;
//    [writeServeBtn setTitle:@"发服务" forState:UIControlStateNormal];
//    [writeServeBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
//    writeServeBtn.titleLabel.font = KSystemBoldFontSize16;
//    [writeServeBgView addSubview:writeServeBtn];
//    [writeServeBtn addTarget:self action:@selector(enterWriteServeVC) forControlEvents:UIControlEventTouchUpInside];
    */
    UIView *writeGoodsBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 200*Proportion/2.0,
                                                                        CGRectGetMaxY(writeActivityBgView.frame) + 50*Proportion,
                                                                        200*Proportion,
                                                                        200*Proportion)];
    writeGoodsBgView.backgroundColor = [UIColor CMLWhiteColor];
    writeGoodsBgView.layer.cornerRadius = 200*Proportion/2.0;
    [self addSubview:writeGoodsBgView];
    
    UIButton *writeGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(200*Proportion/2.0 - 180*Proportion/2.0,
                                                                         200*Proportion/2.0 - 180*Proportion/2.0,
                                                                         180*Proportion,
                                                                         180*Proportion)];
    writeGoodsBtn.layer.cornerRadius = 180*Proportion/2.0;
    writeGoodsBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    writeGoodsBtn.layer.borderWidth = 1;
    [writeGoodsBtn setTitle:@"发商品" forState:UIControlStateNormal];
    [writeGoodsBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    writeGoodsBtn.titleLabel.font = KSystemBoldFontSize16;
    [writeGoodsBgView addSubview:writeGoodsBtn];
    [writeGoodsBtn addTarget:self action:@selector(enterWriteGoodsVC) forControlEvents:UIControlEventTouchUpInside];

    
    
}

- (void) enterVIPVC{

    [self removeFromSuperview];
    
    CMLWriteVC *vc = [[CMLWriteVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterProjectVC{

    [self removeFromSuperview];
    
    LMWordViewController *vc = [[LMWordViewController alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterWriteActivityVC{
    
    [self removeFromSuperview];
    
    LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
    vc.currentType = 1;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterWriteServeVC{
  
    [self removeFromSuperview];
    
    LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
    vc.currentType = 3;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterWriteGoodsVC{
    
    [self removeFromSuperview];
    
    LMWordViewOfGoodsController *vc = [[LMWordViewOfGoodsController alloc] init];
    vc.currentType = 2;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];
}
@end
