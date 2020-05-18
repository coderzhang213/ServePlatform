//
//  ActivitySimpleMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ActivitySimpleMessageView.h"
#import "BaseResultObj.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "ActivityDetailMessageVC.h"
#import "CommonFont.h"
@interface ActivitySimpleMessageView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation ActivitySimpleMessageView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
        
        self.obj = obj;
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                           0,
                                                           WIDTH - 20*Proportion*2,
                                                           100*Proportion)];
    self.bgView.backgroundColor = [UIColor CMLWhiteColor];
    self.bgView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.05;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:self.bgView];
    
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.text = @"﹣ 活动详情 ﹣";
    promLab.font = KSystemBoldFontSize13;
    [promLab sizeToFit];
    promLab.frame = CGRectMake(self.bgView.frame.size.width/2.0 - promLab.frame.size.width/2.0,
                               50*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self.bgView addSubview:promLab];
    
    UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                 CGRectGetMaxY(promLab.frame) + 30*Proportion,
                                                                 self.bgView.frame.size.width - 20*Proportion*2,
                                                                 0)];
    testLab.text = self.obj.retData.describeDetail;
    testLab.textColor = [UIColor blackColor];
    
    testLab.numberOfLines = 0;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.obj.retData.describeDetail dataUsingEncoding:NSUnicodeStringEncoding]
                                                                    options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                         documentAttributes:nil
                                                                      error:nil];
    testLab.attributedText = attrStr;
    testLab.font = KSystemFontSize14;
    testLab.textAlignment = NSTextAlignmentCenter;
    [testLab sizeToFit];
    testLab.frame = CGRectMake(20*Proportion,
                               CGRectGetMaxY(promLab.frame) + 30*Proportion,
                               self.bgView.frame.size.width - 20*Proportion*2,
                               testLab.frame.size.height);
    [self.bgView addSubview:testLab];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.bgView.frame.size.width/2.0 - 230*Proportion/2.0,
                                                                 CGRectGetMaxY(testLab.frame),
                                                                 230*Proportion,
                                                                 56*Proportion)];
    button.layer.cornerRadius = 6*Proportion;
    button.backgroundColor = [UIColor CMLBrownColor];
    button.titleLabel.font = KSystemFontSize13;
    [button setTitle:@"查看完整活动详情" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterTestVC) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.bgView.frame.size.width/2.0 - (button.frame.size.width + 20*Proportion)/2.0,
                              CGRectGetMaxY(testLab.frame),
                              button.frame.size.width + 20*Proportion,
                              56*Proportion);
    [self.bgView addSubview:button];
    
    self.bgView.frame = CGRectMake(20*Proportion,
                                   0,
                                   WIDTH - 20*Proportion*2,
                                   CGRectGetMaxY(button.frame) + 50*Proportion);
    
    self.currentHeight = CGRectGetMaxY(self.bgView.frame);
    
    
    
    
}

- (void) enterTestVC{
    ActivityDetailMessageVC *vc = [[ActivityDetailMessageVC alloc] initWithObjId:self.obj];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
