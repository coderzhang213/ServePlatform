        //
//  CMLVoiceAndLight.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/9/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLVoiceAndLight.h"

@interface CMLVoiceAndLight ()

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, assign) float leftCurrentY;

@property (nonatomic, assign) float leftLastY;

@property (nonatomic, assign) float rightCurrentY;

@property (nonatomic, assign) float rightLastY;

@property (nonatomic, assign) float light;

@property (nonatomic, assign) float voice;

@end

@implementation CMLVoiceAndLight

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addVoiceAndLight];
    }
    return self;
}

- (void)addVoiceAndLight {
    
    self.mpMusicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
    self.voice = self.mpMusicPlayerController.volume;
    
    self.leftCurrentY  = 0.0f;
    self.leftLastY     = 0.0f;
    self.rightCurrentY = 0.0f;
    self.rightLastY    = 0.0f;
    self.light = [UIScreen mainScreen].brightness;
    
    self.leftView = [[UIView alloc] init];
    [self addSubview:self.leftView];
    
    self.centerView = [[UIView alloc] init];
    [self addSubview:self.centerView];
    
    self.rightView = [[UIView alloc] init];
    [self addSubview:self.rightView];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.centerView.mas_left).offset(0);
        make.width.lessThanOrEqualTo(self.centerView);
        make.height.equalTo(self.centerView);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.rightView.mas_left).offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(self.rightView);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.centerView.mas_right).offset(0);
        make.width.equalTo(self.leftView);
        make.height.equalTo(self.leftView);
    }];
    
    self.leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanGestureRecognizer:)];
    [self.leftView addGestureRecognizer:self.leftPanGestureRecognizer];
    
    self.centerSwipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerSwipeGestureRecognizerLeft:)];
    [self.centerView addGestureRecognizer:self.centerSwipeGestureRecognizerLeft];
    
    self.centerSwipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerSwipeGestureRecognizerRight:)];
    [self.centerView addGestureRecognizer:self.centerSwipeGestureRecognizerRight];
    
    self.rightPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanGestureRecognizer:)];
    [self.rightView addGestureRecognizer:self.rightPanGestureRecognizer];
        
}

- (void)leftPanGestureRecognizer:(UIPanGestureRecognizer *)leftSwipe {
    
    /*滑动方法获取当前位置y坐标*/
    self.leftCurrentY = [leftSwipe translationInView:self].y;
    
    /*当前坐标大于上一次移动的坐标--向下滑动*/
    if (self.leftCurrentY > self.leftLastY) {
        if (self.light > 0) {
            /*向下滑动亮度下降*/
            self.light = self.light - 0.01;
        }else {
            self.light = 0;/*下滑不小于0*/
        }
    }else {/*向上滑动*/
        if (self.light < 1) {
            self.light = self.light + 0.01;
        }else {
            self.light = 1;/*上滑不大于1*/
        }
    }
    /*设置屏幕亮度*/
    [UIScreen mainScreen].brightness = self.light;
    self.leftLastY = self.leftCurrentY;/*重置当前位置y坐标为上一次滑动的位置y坐标*/
    
}

- (void)rightPanGestureRecognizer:(UIPanGestureRecognizer *)rightSwipe {
    self.rightCurrentY = [rightSwipe translationInView:self.rightView].y;
    if (self.rightCurrentY > self.rightLastY) {
        if (self.voice > 0) {
            self.voice = self.voice - 0.01;
        }else {
            self.voice = 0;
        }
    }else {
        if (self.voice < 1) {
            self.voice = self.voice + 0.01;
        }else {
            self.voice = 1;
        }
    }
    /*设置音量*/
    self.mpMusicPlayerController.volume = self.voice;
    self.rightLastY = self.rightCurrentY;
}

- (void)centerSwipeGestureRecognizerLeft:(UISwipeGestureRecognizer *)centerSwipeLeft {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fastBack)]) {
        [self.delegate fastBack];
    }
}

- (void)centerSwipeGestureRecognizerRight:(UISwipeGestureRecognizer *)centerSwipeRight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fastFront)]) {
        [self.delegate fastFront];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
