//
//  CMLNewSelectTypeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewSelectTypeView.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"

@interface CMLNewSelectTypeView()

@property (nonatomic,strong) NSArray *nameArray;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) UIView *moveLine;

@end

@implementation CMLNewSelectTypeView

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame andTypeNamesArray:(NSArray *) nameArray{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor CMLWhiteColor];
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOpacity = 0.05;
//        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.nameArray = nameArray;
    }
    
    return self;
    
}

- (void) refreshNewTypeViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnArray removeAllObjects];
    
    for (int i = 0; i < self.nameArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/self.nameArray.count*i,
                                                                   0,
                                                                   WIDTH/self.nameArray.count,
                                                                   self.frame.size.height)];
        
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font = KSystemFontSize13;
        [btn setTitle:self.nameArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(SelectClassIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
        
        
        if (i == self.currentSelectIndex) {
            
//            CMLLine *endLine = [[CMLLine alloc] init];
//            endLine.lineWidth = 1*Proportion;
//            endLine.lineLength = WIDTH;
//            endLine.LineColor = [UIColor CMLPromptGrayColor];
//            endLine.startingPoint = CGPointMake(0, CGRectGetHeight(self.frame) - 1*Proportion);
//            [self addSubview:endLine];
            
            btn.selected = YES;
            btn.titleLabel.font = KSystemRealBoldFontSize13;
            _moveLine = [[UIView alloc] init];
            _moveLine.backgroundColor = [UIColor CMLBrownColor];
            _moveLine.frame = CGRectMake(btn.center.x - 40*Proportion/2.0,
                                         CGRectGetHeight(self.frame) - 2,
                                         40*Proportion,
                                         2);
            _moveLine.layer.cornerRadius = 1;
            
            [self addSubview:_moveLine];
        }
    }

}

- (void) refreshSelectType:(int) inedx{
    
    UIButton *currentBtn = self.btnArray[inedx];
    
    if (!currentBtn.selected) {
        
        for (int i = 0; i < self.btnArray.count; i ++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (i == inedx) {
                
                tempBtn.selected = YES;
                tempBtn.titleLabel.font = KSystemRealBoldFontSize13;
                
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.moveLine.frame = CGRectMake(tempBtn.center.x - 40*Proportion/2.0,
                                                         CGRectGetHeight(self.frame) - 2,
                                                         40*Proportion,
                                                         2);
                }];

            }else{
                
                tempBtn.selected = NO;
                tempBtn.titleLabel.font = KSystemFontSize13;
            }
        }
    }
}


- (void) SelectClassIndex:(UIButton *) btn{
    
    if (!btn.selected) {
        
        btn.selected = YES;
     
        [self.delegate newSelectTypeViewSelect:(int)btn.tag];
        
        for (int i = 0; i < self.btnArray.count; i ++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (i == (int)btn.tag) {
                
                tempBtn.selected = YES;
                tempBtn.titleLabel.font = KSystemRealBoldFontSize13;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.moveLine.frame = CGRectMake(tempBtn.center.x - 40*Proportion/2.0,
                                                         CGRectGetHeight(self.frame) - 2,
                                                         40*Proportion,
                                                         2);
                }];

            }else{
                
                tempBtn.selected = NO;
                tempBtn.titleLabel.font = KSystemFontSize13;
            }
        }
    }
}

@end
