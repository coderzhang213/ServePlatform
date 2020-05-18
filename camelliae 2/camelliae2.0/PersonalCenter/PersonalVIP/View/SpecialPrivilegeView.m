//
//  SpecialPrivilegeView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/16.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "SpecialPrivilegeView.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"
#import "DetailPrivilegeObj.h"
#import "NetWorkTask.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"

@interface SpecialPrivilegeView ()

@property (nonatomic,strong) NSArray *currentDataArray;

@end

@implementation SpecialPrivilegeView

- (instancetype) initWithDataArray:(NSArray *) dataArray{

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
        promLabel.text = @"增值特权";
        [promLabel sizeToFit];
        promLabel.frame = CGRectMake((20 + 30 + 4)*Proportion,
                                     30*Proportion + 24*Proportion/2.0 - promLabel.frame.size.height/2.0,
                                     promLabel.frame.size.width,
                                     promLabel.frame.size.height);
        [self addSubview:promLabel];
        
        
        UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
        enterImage.frame = CGRectMake(WIDTH - enterImage.frame.size.width - 30*Proportion,
                                      promLabel.center.y - enterImage.frame.size.height/2.0,
                                      enterImage.frame.size.width,
                                      enterImage.frame.size.height);
        [self addSubview:enterImage];
        
        UIButton *enterDetailMessageBtn = [[UIButton alloc] init];
        [enterDetailMessageBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [enterDetailMessageBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        enterDetailMessageBtn.titleLabel.font = KSystemBoldFontSize12;
        [enterDetailMessageBtn sizeToFit];
        enterDetailMessageBtn.frame = CGRectMake(enterImage.frame.origin.x - 10*Proportion - enterDetailMessageBtn.frame.size.width,
                                                 promLabel.center.y - enterDetailMessageBtn.frame.size.height/2.0,
                                                 enterDetailMessageBtn.frame.size.width,
                                                 enterDetailMessageBtn.frame.size.height);
        [self addSubview:enterDetailMessageBtn];
        [enterDetailMessageBtn addTarget:self action:@selector(enterDetailMessageVC) forControlEvents:UIControlEventTouchUpInside];
        
        
        CMLLine *hLine = [[CMLLine alloc] init];
        hLine.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(promLabel.frame) + 20*Proportion);
        hLine.lineWidth = 1*Proportion;
        hLine.lineLength = WIDTH - 30*Proportion*2;
        hLine.LineColor = [UIColor CMLPromptGrayColor];
        [self addSubview:hLine];
        
     
        
        /***********************/
        CGFloat leftMargin = 90*Proportion;
        CGFloat space = (WIDTH - 90*Proportion*2 - 40*Proportion*4)/3.0;
        for (int i = 0; i < self.currentDataArray.count; i++) {
            
            DetailPrivilegeObj *obj = [DetailPrivilegeObj getBaseObjFrom:self.currentDataArray[i]];
            
            UIImageView *privilegeImage = [[UIImageView alloc] init];
            [NetWorkTask setImageView:privilegeImage WithURL:obj.icon placeholderImage:[UIImage imageNamed:UpGradePigmentFirstprerogativeImg]];
            
            UILabel *privilegeLabel = [[UILabel alloc] init];
            privilegeLabel.font = KSystemFontSize12;
            privilegeLabel.textColor = [UIColor CMLUserBlackColor];
            privilegeLabel.text = obj.title;
            [privilegeLabel sizeToFit];
            
            if (i < 4) {
                
                privilegeImage.frame = CGRectMake(leftMargin + (40*Proportion + space)*i,
                                                  CGRectGetMaxY(promLabel.frame) + 20*Proportion + 40*Proportion,
                                                  40*Proportion,
                                                  40*Proportion);
                
            }else{
                
                privilegeImage.frame = CGRectMake(leftMargin + (40*Proportion + space)*(i - 4),
                                                  CGRectGetMaxY(promLabel.frame) + 20*Proportion + 40*Proportion*3 + privilegeLabel.frame.size.height + 10*Proportion,
                                                  40*Proportion,
                                                  40*Proportion);
                
            }
            
            privilegeLabel.frame = CGRectMake(privilegeImage.center.x - privilegeLabel.frame.size.width/2.0,
                                              CGRectGetMaxY(privilegeImage.frame) + 10*Proportion,
                                              privilegeLabel.frame.size.width,
                                              privilegeLabel.frame.size.height);
            
            
            [self addSubview:privilegeImage];
            [self addSubview:privilegeLabel];
            
            
            if (i == (self.currentDataArray.count - 1)) {
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(privilegeLabel.frame) + 40*Proportion,
                                                                              WIDTH,
                                                                              20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomView];
                
                self.currentHeight = CGRectGetMaxY(privilegeLabel.frame) + 40*Proportion + 20*Proportion;
            }
        }
        
    }else{
    
        self.currentHeight = 0;
    }
}

- (void) enterDetailMessageVC{

    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.url = self.viewLink;
    vc.name = @"特权详情";
    vc.isDetailMes = NO;
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
