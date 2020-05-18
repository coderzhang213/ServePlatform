//
//  CMLWalletCenterNavView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/25.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterNavView.h"

@interface CMLWalletCenterNavView ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, assign) BOOL isChanged;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CMLWalletCenterNavView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                StatusBarHeight + NavigationBarHeight);
        self.backgroundColor = [UIColor clearColor];
        self.isChanged = NO;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight,
                                                              NavigationBarHeight,
                                                              NavigationBarHeight)];
    [self.backBtn setImage:[UIImage imageNamed:VIPBackImg] forState:UIControlStateNormal];
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.titleContent;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.titleLabel.frame)/2, CGRectGetMidY(self.backBtn.frame) - CGRectGetHeight(self.titleLabel.frame)/2, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    
    [self addSubview:self.titleLabel];

}

- (void)changeDefaultView {
    
    if (self.isChanged) {
        
        [self.backBtn setImage:[UIImage imageNamed:VIPBackImg] forState:UIControlStateNormal];
        self.titleLabel.textColor = [UIColor whiteColor];

        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    self.isChanged = NO;
}

- (void)changeWhiteView {
    
    if (!self.isChanged) {
        
        [self.backBtn setImage:[UIImage imageNamed:NavcBackBtnImg] forState:UIControlStateNormal];
        
        self.titleLabel.textColor = [UIColor CMLUserBlackColor];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.isChanged = YES;
    }
    
}


- (void) touchBackBtn{
    
    [self.delegate dissCurrentDetailVC];
}

@end
