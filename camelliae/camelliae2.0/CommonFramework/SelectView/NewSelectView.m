//
//  NewSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NewSelectView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

#define MoreLength            40
#define BtnLeftAndRightSpace  20
#define BtnTopAndBottomSpace  30

@implementation NewSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}


- (void) refreshSelectView{
    
    float currentWidth = self.contentLeftMargin;
    float currentHeight = self.contentTopMargin;
    float currentRow = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"热门搜索";
    label.font = KSystemFontSize13;
    [label sizeToFit];
    label.frame = CGRectMake(self.contentLeftMargin,
                             40*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    label.textColor = [UIColor CMLtextInputGrayColor];
    [self addSubview:label];
    
    currentHeight = CGRectGetMaxY(label.frame) + 20*Proportion;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = KSystemFontSize13;
        [button sizeToFit];
        button.tag = i+1;
        [button addTarget:self action:@selector(selectContent:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
        [button setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor CMLUserGrayColor];
        if (self.buttontitleColor) {
            [button setTitleColor:self.buttontitleColor forState:UIControlStateNormal];
        }
        
        
        [button sizeToFit];
        button.frame = CGRectMake(currentWidth,
                                  currentHeight,
                                  button.frame.size.width + MoreLength*Proportion,
                                  button.frame.size.height);
        button.layer.cornerRadius = 6.0*Proportion;
        
        /**初始化btn状态*/
        if (i == self.currentIndex && self.isSelectedState) {
            button.selected = YES;
            button.backgroundColor = [UIColor CMLYellowColor];
        }
        
        currentWidth += button.frame.size.width + BtnLeftAndRightSpace*Proportion;
        
        if (currentWidth > [UIScreen mainScreen].bounds.size.width) {
            
            currentWidth = self.contentLeftMargin;
            currentRow ++;
            currentHeight = (BtnTopAndBottomSpace*Proportion + button.frame.size.height)*currentRow + (CGRectGetMaxY(label.frame) + 20*Proportion);
            
            button.frame = CGRectMake(currentWidth,
                                      currentHeight,
                                      button.frame.size.width,
                                      button.frame.size.height);
            
            currentWidth += button.frame.size.width + BtnLeftAndRightSpace*Proportion;
            
        }
        
        [self addSubview:button];
        
        if (i == (self.dataArray.count - 1)) {
            self.selectViewHeight = currentHeight + button.frame.size.height + 40*Proportion;
        }
    }
    
}

- (void) selectContent:(UIButton *) button{
    
    if (self.isSelectedState) {
        
        for (int i = 0; i < self.dataArray.count ; i++) {
            
            UIButton *currentButton = [self viewWithTag:i+1];
            
            if (button.tag == (i+1)) {
                currentButton.selected = YES;
                currentButton.layer.borderColor = [UIColor CMLYellowColor].CGColor;
            }else{
                
                currentButton.selected = NO;
                currentButton.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
            }
        }
    }
    
    [self.delegate selectIndex:(button.tag - 1) title:self.dataArray[button.tag - 1]];
}

@end
