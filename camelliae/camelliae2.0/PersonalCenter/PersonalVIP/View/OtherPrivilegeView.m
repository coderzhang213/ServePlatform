//
//  OtherPrivilegeView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/16.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "OtherPrivilegeView.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"
#import "DetailPrivilegeObj.h"

@interface OtherPrivilegeView ()

@property (nonatomic,strong) NSArray *currentDataArray;


@end

@implementation OtherPrivilegeView

- (instancetype)initWithDataArray:(NSArray *)dataArray{
    
    self = [super init];
    if (self) {
        
        self.currentDataArray = dataArray;
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    if (self.currentDataArray.count > 0) {
        
        CMLLine *vLine = [[CMLLine alloc] init];
        vLine.startingPoint = CGPointMake(30*Proportion, 30*Proportion);
        vLine.directionOfLine = VerticalLine;
        vLine.lineWidth = 4*Proportion;
        vLine.lineLength = 24*Proportion;
        vLine.LineColor = [UIColor CMLDarkOrangeColor];
        [self addSubview:vLine];
        
        UILabel *promLabel = [[UILabel alloc] init];
        promLabel.font = KSystemBoldFontSize12;
        promLabel.textColor = [UIColor CMLDarkOrangeColor];
        promLabel.text = @"其他权益";
        [promLabel sizeToFit];
        promLabel.frame = CGRectMake((20 + 30 + 4)*Proportion,
                                     30*Proportion + 24*Proportion/2.0 - promLabel.frame.size.height/2.0,
                                     promLabel.frame.size.width,
                                     promLabel.frame.size.height);
        [self addSubview:promLabel];
        
        
        CMLLine *hLine = [[CMLLine alloc] init];
        hLine.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(promLabel.frame) + 20*Proportion);
        hLine.lineWidth = 1*Proportion;
        hLine.lineLength = WIDTH - 30*Proportion*2;
        hLine.LineColor = [UIColor CMLPromptGrayColor];
        [self addSubview:hLine];
        
        
        CGFloat leftMargin = 30*Proportion;
        CGFloat topMargin = CGRectGetMaxY(promLabel.frame) + 40*Proportion + 20*Proportion;
        for (int i = 0; i < self.currentDataArray.count; i++) {
            
            DetailPrivilegeObj *obj = [DetailPrivilegeObj getBaseObjFrom:self.currentDataArray[i]];
            
            UILabel *privilegeLabel = [[UILabel alloc] init];
            privilegeLabel.font = KSystemBoldFontSize14;
            privilegeLabel.textColor = [UIColor CMLUserBlackColor];
            privilegeLabel.text = obj.title;
            [privilegeLabel sizeToFit];
            
            if (WIDTH - (privilegeLabel.frame.size.width + leftMargin) > 30*Proportion) {
                
                privilegeLabel.frame = CGRectMake(leftMargin,
                                                  topMargin,
                                                  privilegeLabel.frame.size.width,
                                                  privilegeLabel.frame.size.height);
                
                leftMargin += (70*Proportion + privilegeLabel.frame.size.width);
            }else{
            
                leftMargin = 30*Proportion;
                topMargin += (40*Proportion + privilegeLabel.frame.size.height);
                
                privilegeLabel.frame = CGRectMake(leftMargin,
                                                  topMargin,
                                                  privilegeLabel.frame.size.width,
                                                  privilegeLabel.frame.size.height);
                
                leftMargin += (70*Proportion + privilegeLabel.frame.size.width);
                
            }
            [self addSubview:privilegeLabel];
            
            if (i == (self.currentDataArray.count - 1)) {
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(privilegeLabel.frame) + 40*Proportion, WIDTH, 20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomView];
                
                self.currentHeight = CGRectGetMaxY(bottomView.frame);
            }
        }
        
    }else{
        
        self.currentHeight = 0;
    }

    
}
@end
