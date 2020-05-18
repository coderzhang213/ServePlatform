//
//  CMLMyCouponsTopView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/16.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMyCouponsTopView.h"

@interface CMLMyCouponsTopView ()

@property (nonatomic, strong) UIView *btnBgView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *moveLine;

@end

@implementation CMLMyCouponsTopView

- (NSMutableArray *)btnArray {
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor CMLWhiteColor];
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    self.nameArray = @[@"未使用", @"已使用", @"已过期"];
    
    [self addSubview:self.btnBgView];
    
    for (int i = 0; i < self.nameArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/self.nameArray.count * i,
                                                                   0,
                                                                   WIDTH/self.nameArray.count,
                                                                   self.btnBgView.frame.size.height)];
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLNewYellowColor] forState:UIControlStateSelected];
        btn.titleLabel.font = KSystemFontSize15;
        [btn setTitle:self.nameArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i + 1;
        [self.btnBgView addSubview:btn];
        [btn addTarget:self action:@selector(selectClassIndexOfCoupons:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArray addObject:btn];
        
        /******/
        if (i == 0) {
            btn.titleLabel.font = KSystemRealBoldFontSize15;
            btn.selected = YES;
            self.moveLine = [[UIView alloc] init];
            self.moveLine.backgroundColor = [UIColor CMLNewYellowColor];
            self.moveLine.frame = CGRectMake(btn.center.x - 55 * Proportion/2.0,
                                             CGRectGetHeight(self.btnBgView.frame) - 5 * Proportion,
                                             55 * Proportion,
                                             5 * Proportion);
            self.moveLine.layer.cornerRadius = 5 * Proportion/2;
            self.moveLine.clipsToBounds = YES;
            [self.btnBgView addSubview:self.moveLine];
        }
    }
}

- (void)selectClassIndexOfCoupons:(UIButton *)button {
    
    if (!button.selected) {
        button.selected = YES;
        [self.delegate selectOfMyCouponsTypeIndex:(int)button.tag - 1];
        
        for (int i = 0; i < self.btnArray.count; i++) {
            UIButton *tempButton = self.btnArray[i];
            if (i == (int)(button.tag - 1)) {
                tempButton.selected = YES;
                tempButton.titleLabel.font = KSystemRealBoldFontSize15;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.moveLine.frame = CGRectMake(tempButton.center.x - 55 * Proportion/2, CGRectGetHeight(weakSelf.btnBgView.frame) - 5 * Proportion, CGRectGetWidth(weakSelf.moveLine.frame), CGRectGetHeight(weakSelf.moveLine.frame));
                }];
                
            }else {
                tempButton.selected = NO;
                tempButton.titleLabel.font = KSystemBoldFontSize15;
            }
        }
    }
}

- (UIView *)btnBgView {
    
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100 * Proportion)];
        _btnBgView.backgroundColor = [UIColor CMLWhiteColor];
    }
    return _btnBgView;
}

@end
