//
//  OldSearchView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/8/3.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "OldSearchView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"

#define MoreLength            40
#define BtnLeftAndRightSpace  20
#define BtnTopAndBottomSpace  30

@implementation OldSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        

    }
    return self;
}


- (void) refreshOldSelectView{
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.dataArray.count > 0) {
     
        float currentLeft = self.contentLeftMargin;
        float currentY = self.contentTopMargin;
        float currentRow = 0;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"历史搜索";
        label.font = KSystemFontSize13;
        [label sizeToFit];
        label.frame = CGRectMake(self.contentLeftMargin,
                                 40*Proportion,
                                 label.frame.size.width,
                                 label.frame.size.height);
        label.textColor = [UIColor CMLtextInputGrayColor];
        [self addSubview:label];
        
        
        UIImageView *deleteImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DeleteOldSearchImg]];
        [deleteImg sizeToFit];
        deleteImg.contentMode = UIViewContentModeScaleAspectFill;
        deleteImg.userInteractionEnabled = YES;
        deleteImg.clipsToBounds = YES;
        deleteImg.frame = CGRectMake(WIDTH - deleteImg.frame.size.width - 40*Proportion,
                                     label.center.y - deleteImg.frame.size.height/2.0,
                                     deleteImg.frame.size.width,
                                     deleteImg.frame.size.height);
        [self addSubview:deleteImg];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn sizeToFit];
        btn.frame =CGRectMake(0,
                              0,
                              btn.frame.size.width*2,
                              btn.frame.size.height*2);
        btn.backgroundColor = [UIColor clearColor];
        btn.center = deleteImg.center;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(deleteCurrentSearchRecord) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        currentY = CGRectGetMaxY(label.frame) + 20*Proportion;
        
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
            button.frame = CGRectMake(currentLeft,
                                      currentY,
                                      button.frame.size.width + MoreLength*Proportion,
                                      button.frame.size.height);
            button.layer.cornerRadius = 6.0*Proportion;
            
            /**初始化btn状态*/
            if (i == self.currentIndex && self.isSelectedState) {
                button.selected = YES;
                button.backgroundColor = [UIColor CMLYellowColor];
            }
            
            currentLeft = currentLeft + button.frame.size.width + BtnLeftAndRightSpace*Proportion;
            
            if (currentLeft > [UIScreen mainScreen].bounds.size.width) {
                
                currentLeft = self.contentLeftMargin;
                currentRow ++;
                
                if (currentRow >= 2) {
                    
                    button.frame = CGRectMake(currentLeft,
                                              currentY,
                                              0,
                                              0);
                }else{
                    
                    currentY = (BtnTopAndBottomSpace*Proportion + button.frame.size.height)*currentRow + (CGRectGetMaxY(label.frame) + 20*Proportion);
                    [button sizeToFit];
                    button.frame = CGRectMake(currentLeft,
                                              currentY,
                                              button.frame.size.width,
                                              button.frame.size.height);
                    
                    currentLeft = currentLeft +  button.frame.size.width + BtnLeftAndRightSpace*Proportion;
                    
                    if (currentLeft > [UIScreen mainScreen].bounds.size.width) {
                     
                        button.frame = CGRectMake(button.frame.origin.x,
                                                  currentY,
                                                  WIDTH - button.frame.origin.x - self.contentLeftMargin,
                                                  button.frame.size.height);
                    }
                    
                }
 
                
            }
            
            [self addSubview:button];
            
            if (i == (self.dataArray.count - 1)) {
                self.selectViewHeight = currentY + button.frame.size.height + 40*Proportion;
            }
        }
        
    }else{
        
        self.selectViewHeight = 0;
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
    
    [self.delegate selectOldSearchIndex:(button.tag - 1) title:self.dataArray[button.tag - 1]];
}

- (void) deleteCurrentSearchRecord{
    
    [self.delegate deleteAllSearch];
}
@end
