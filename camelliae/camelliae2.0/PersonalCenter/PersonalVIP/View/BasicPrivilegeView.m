//
//  BasicPrivilegeView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/16.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BasicPrivilegeView.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"
#import "DetailPrivilegeObj.h"

@interface BasicPrivilegeView ()

@property (nonatomic,strong) NSArray *currentDataArray;


@end

@implementation BasicPrivilegeView

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
        promLabel.text = @"基础权益";
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

        
     
        for (int i = 0; i < self.currentDataArray.count; i++) {
            
            DetailPrivilegeObj *obj = [DetailPrivilegeObj getBaseObjFrom:self.currentDataArray[i]];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(promLabel.frame) + 20*Proportion + 80*Proportion*i,
                                                                      WIDTH,
                                                                      80*Proportion)];
            bgView.backgroundColor = [UIColor whiteColor];
            [self addSubview:bgView];
            
            UIView *dian = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                    bgView.frame.size.height/2.0 - 16*Proportion/2.0,
                                                                    16*Proportion,
                                                                    16*Proportion)];
            dian.backgroundColor = [UIColor CMLDarkOrangeColor];
            dian.layer.cornerRadius = 16*Proportion/2.0;
            [bgView addSubview:dian];
            
            UILabel *bigTitlelabel = [[UILabel alloc] init];
            bigTitlelabel.font = KSystemBoldFontSize14;
            bigTitlelabel.textColor = [UIColor CMLUserBlackColor];
            bigTitlelabel.text = obj.title;
            [bigTitlelabel sizeToFit];
            bigTitlelabel.frame = CGRectMake(CGRectGetMaxX(dian.frame) + 30*Proportion,
                                             bgView.frame.size.height/2.0 - bigTitlelabel.frame.size.height/2.0,
                                             bigTitlelabel.frame.size.width,
                                             bigTitlelabel.frame.size.height);
            [bgView addSubview:bigTitlelabel];
            
            UILabel *shortTitleLabel = [[UILabel alloc] init];
            shortTitleLabel.font = KSystemFontSize12;
            shortTitleLabel.textColor = [UIColor CMLLineGrayColor];
            shortTitleLabel.numberOfLines = 0;
            shortTitleLabel.textAlignment = NSTextAlignmentLeft;
            shortTitleLabel.text = obj.content;
            [shortTitleLabel sizeToFit];
            shortTitleLabel.frame = CGRectMake(CGRectGetMaxX(bigTitlelabel.frame) + 9*Proportion,
                                               bgView.frame.size.height/2.0 - bigTitlelabel.frame.size.height/2.0,
                                               WIDTH - 30*Proportion - CGRectGetMaxX(bigTitlelabel.frame) + 9*Proportion,
                                               bigTitlelabel.frame.size.height);
            [bgView addSubview:shortTitleLabel];
            
            CMLLine *bottomLine = [[CMLLine alloc] init];
            bottomLine.lineWidth = 1*Proportion;
            bottomLine.lineLength = WIDTH - 30*Proportion*2;
            bottomLine.startingPoint = CGPointMake(30*Proportion, bgView.frame.size.height - 1);
            bottomLine.LineColor = [UIColor CMLUserGrayColor];
            [bgView addSubview:bottomLine];
            
            
            if (i == self.currentDataArray.count - 1) {
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), WIDTH, 20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLNewGrayColor];
                [self addSubview:bottomView];
                
                self.currentHeight = CGRectGetMaxY(bottomView.frame);
                
                
            }
        }
    }else{
    
        self.currentHeight = 0;
    }


}
@end
