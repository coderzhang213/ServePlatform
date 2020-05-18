//
//  ActivityPromMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityPromMessageView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NewPersonDetailInfoVC.h"
#import "VCManger.h"

#define ActivityDefaultVCShowMesWidth                       620
#define ActivityDefaultVCVideoHeiight                       400
#define ActivityDefaultVCVideoTopMargin                     40

@implementation ActivityPromMessageView

- (instancetype)init{

    self = [super init];
    
    if (self) {
       
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 ActivityDefaultVCShowMesWidth*Proportion,
                                                                 0)];
    pointView.backgroundColor = [UIColor whiteColor];
    pointView.layer.cornerRadius = 8;
    
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.text = @"提示信息";
    pointLabel.font = KSystemBoldFontSize17;
    pointLabel.textColor = [UIColor CMLUserBlackColor];
    [pointLabel sizeToFit];
    pointLabel.frame = CGRectMake(ActivityDefaultVCShowMesWidth*Proportion/2.0 - pointLabel.frame.size.width/2.0,
                                  60*Proportion,
                                  pointLabel.frame.size.width,
                                  pointLabel.frame.size.height);
    [pointView addSubview:pointLabel];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake((ActivityDefaultVCShowMesWidth - 560)*Proportion/2.0, CGRectGetMaxY(pointLabel.frame) + 40*Proportion);
    line.lineWidth = 1;
    line.lineLength = 560*Proportion;
    line.LineColor = [UIColor CMLPromptGrayColor];
    [pointView addSubview:line];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"亲爱的花伴，您尚未绑定手机号，将影响您的活动预约，请先绑定您的手机号，等待您的再次预约";
    contentLabel.font = KSystemFontSize14;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor CMLUserBlackColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    CGRect contentSize = [contentLabel.text boundingRectWithSize:CGSizeMake(ActivityDefaultVCShowMesWidth*Proportion - 40*Proportion*2, 1000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                         context:nil];
    contentLabel.frame = CGRectMake(40*Proportion,
                                    CGRectGetMaxY(pointLabel.frame) + 60*Proportion + 40*Proportion,
                                    ActivityDefaultVCShowMesWidth*Proportion - 40*Proportion*2,
                                    contentSize.size.height);
    [pointView addSubview:contentLabel];
    
    CGFloat leftMargin = (ActivityDefaultVCShowMesWidth*Proportion - 200*Proportion*2)/3.0;
    
    UIButton *bindButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                      CGRectGetMaxY(contentLabel.frame) + 60*Proportion,
                                                                      200*Proportion,
                                                                      55*Proportion)];
    bindButton.layer.cornerRadius = 55*Proportion/2.0;
    bindButton.layer.borderWidth = 2*Proportion;
    bindButton.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    [bindButton setTitle:@"取消" forState:UIControlStateNormal];
    [bindButton setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    bindButton.titleLabel.font = KSystemFontSize14;
    [pointView addSubview:bindButton];
    [bindButton addTarget:self action:@selector(cancelThisAppointment) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + CGRectGetMaxX(bindButton.frame),
                                                                        CGRectGetMaxY(contentLabel.frame) + 60*Proportion,
                                                                        200*Proportion,
                                                                        55*Proportion)];
    cancelButton.layer.cornerRadius = 55*Proportion/2.0;
    cancelButton.layer.borderWidth = 2*Proportion;
    cancelButton.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    [cancelButton setTitle:@"去绑定" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = KSystemFontSize14;
    [cancelButton setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    [pointView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(enterPersonalInfoCenter) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat currentHeight = CGRectGetMaxY(cancelButton.frame) + 60*Proportion;
    pointView.frame = CGRectMake(0,
                                 0,
                                 pointView.frame.size.width,
                                 currentHeight);
    [self addSubview:pointView];

    self.currentWidth = pointView.frame.size.width;
    self.currentHeight = currentHeight;
    
}

- (void) enterPersonalInfoCenter{

    [self.delegate cancelcurrentAppointment];
    
    NewPersonDetailInfoVC *vc = [[NewPersonDetailInfoVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) cancelThisAppointment{

    [self.delegate cancelcurrentAppointment];
}
@end
