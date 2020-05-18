//
//  SelectView.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "SelectView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

#define MoreLength            40
#define BtnLeftAndRightSpace  40
#define BtnTopAndBottomSpace  30

@interface SelectView ()

@end
@implementation SelectView

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
    
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = KSystemFontSize13;
        [button sizeToFit];
        button.tag = i+1;
        [button addTarget:self action:@selector(selectContent:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [button setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        if (self.buttontitleColor) {
            [button setTitleColor:self.buttontitleColor forState:UIControlStateNormal];
        }
        
        
        [button sizeToFit];
        button.frame = CGRectMake(currentWidth,
                                  currentHeight,
                                  button.frame.size.width + MoreLength*Proportion,
                                  button.frame.size.height);
        button.layer.cornerRadius = 6*Proportion;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
        
        /**初始化btn状态*/
        if (i == self.currentIndex && self.isSelectedState) {
            button.selected = YES;
            button.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        }
        
        currentWidth += button.frame.size.width + BtnLeftAndRightSpace*Proportion;
        
        if (currentWidth > [UIScreen mainScreen].bounds.size.width) {
            
            currentWidth = self.contentLeftMargin;
            currentRow ++;
            currentHeight = (BtnTopAndBottomSpace*Proportion + button.frame.size.height)*currentRow + self.contentTopMargin;
            
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
                currentButton.layer.borderColor = [UIColor CMLBrownColor].CGColor;
            }else{
               
                currentButton.selected = NO;
                currentButton.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
            }
        }
    }
    
    [self.delegate selectIndex:(button.tag - 1) title:self.dataArray[button.tag - 1]];
}
@end
