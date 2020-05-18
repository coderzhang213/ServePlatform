//
//  StoreTopView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "StoreTopView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "ShoppingCarVC.h"
#import "CMLMobClick.h"
#import "CMLSearchVC.h"

@interface StoreTopView()

@property (nonatomic,strong) UIView *moveLine;

@property (nonatomic,strong) UIButton *recmmendbtn;


@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong)  UIButton *brandbtn;

@property (nonatomic,strong) UIButton *sbCar;

@property (nonatomic,strong) UIButton *searchBtn;

@end

@implementation StoreTopView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                StatusBarHeight + 80*Proportion);
        [self loadViews];
        [self selectRecommend];
    }
    
    return self;
}

- (void) loadViews{
    
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setImage:[UIImage imageNamed:MainInfaceSearchImg] forState:UIControlStateNormal];
    [self.searchBtn sizeToFit];
    self.searchBtn.frame = CGRectMake(WIDTH - 80*Proportion - 20*Proportion,
                                  StatusBarHeight,
                                  80*Proportion,
                                  80*Proportion);

    [self.searchBtn addTarget:self action:@selector(enterSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchBtn];
    
    
    self.recmmendbtn = [[UIButton alloc] init];
    [self.recmmendbtn setTitle:@"单 品" forState:UIControlStateNormal];
    [self.recmmendbtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
    [self.recmmendbtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.recmmendbtn.titleLabel.font = KSystemBoldFontSize15;
    [self.recmmendbtn sizeToFit];
    self.recmmendbtn.frame = CGRectMake(WIDTH/2.0 - self.recmmendbtn.frame.size.width/2.0,
                                        StatusBarHeight,
                                        self.recmmendbtn.frame.size.width,
                                        80*Proportion);
//    self.recmmendbtn.frame = CGRectMake(self.serveBtn.frame.origin.x - 50*Proportion - self.recmmendbtn.frame.size.width, StatusBarHeight, self.serveBtn.frame.size.width, 80*Proportion);
    [self addSubview:self.recmmendbtn];
   
    
    [self.recmmendbtn addTarget:self action:@selector(selectRecommend) forControlEvents:UIControlEventTouchUpInside];
    
    self.serveBtn = [[UIButton alloc] init];
    [self.serveBtn setTitle:@"服 务" forState:UIControlStateNormal];
    [self.serveBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
    [self.serveBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.serveBtn.titleLabel.font = KSystemBoldFontSize15;
    [self.serveBtn sizeToFit];
    self.serveBtn.frame = CGRectMake(self.recmmendbtn.frame.origin.x - 50*Proportion - self.serveBtn.frame.size.width ,
     StatusBarHeight,
     self.serveBtn.frame.size.width,
     80*Proportion);
    
//    self.serveBtn.frame = CGRectMake(WIDTH/2.0 - self.serveBtn.frame.size.width/2.0, StatusBarHeight, self.serveBtn.frame.size.width, 80*Proportion);
    
    [self addSubview:self.serveBtn];
    [self.serveBtn addTarget:self action:@selector(selectServe) forControlEvents:UIControlEventTouchUpInside];
     self.serveBtn.selected = YES;
    
    self.brandbtn = [[UIButton alloc] init];
    [self.brandbtn setTitle:@"品 牌" forState:UIControlStateNormal];
    [self.brandbtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
    [self.brandbtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.brandbtn.titleLabel.font = KSystemBoldFontSize15;
    [self.brandbtn sizeToFit];
    self.brandbtn.frame = CGRectMake(CGRectGetMaxX(self.recmmendbtn.frame) + 50*Proportion,
                                     StatusBarHeight,
                                     self.brandbtn.frame.size.width,
                                     80*Proportion);
    [self addSubview:self.brandbtn];
    [self.brandbtn addTarget:self action:@selector(selectBrand) forControlEvents:UIControlEventTouchUpInside];
    
    self.moveLine = [[UIView alloc] initWithFrame:CGRectMake(self.serveBtn.center.x - 55*Proportion/2.0,
                                                             self.frame.size.height - 4*Proportion,
                                                             55*Proportion,
                                                             4*Proportion)];
    self.moveLine.backgroundColor = [UIColor CMLBrownColor];
    self.moveLine.layer.cornerRadius = 4*Proportion/2.0;
    [self addSubview:self.moveLine];
    
    self.sbCar = [[UIButton alloc] init];
    [self.sbCar setImage:[UIImage imageNamed:SBCarImg] forState:UIControlStateNormal];
    self.sbCar.contentMode = UIViewContentModeLeft;
    self.sbCar.frame = CGRectMake(20*Proportion,
                                      StatusBarHeight,
                                      80*Proportion,
                                      80*Proportion);
    [self addSubview:self.sbCar];
    [self.sbCar addTarget:self action:@selector(enterShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    [CMLMobClick StoreHeadPageRecommend];
}

- (void) selectRecommend{
    
    [CMLMobClick StoreHeadPageRecommend];
    
    if (!self.recmmendbtn.selected) {
        self.recmmendbtn.titleLabel.font = KSystemRealBoldFontSize15;
        self.serveBtn.titleLabel.font = KSystemBoldFontSize15;
        self.brandbtn.titleLabel.font = KSystemBoldFontSize15;
        self.recmmendbtn.selected = YES;
        self.serveBtn.selected = NO;
        self.brandbtn.selected = NO;
        [self.delegate selectIndex:0];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
          
            weakSelf.moveLine.center = CGPointMake(self.recmmendbtn.center.x, weakSelf.moveLine.center.y);
        }];
    }
    
}

- (void) selectBrand{
    
    [CMLMobClick StoreBrandPageRecommend];
    
    if (!self.brandbtn.selected) {
        
        self.serveBtn.selected = NO;
        self.recmmendbtn.selected = NO;
        self.brandbtn.selected = YES;
        self.recmmendbtn.titleLabel.font = KSystemBoldFontSize15;
        self.serveBtn.titleLabel.font = KSystemBoldFontSize15;
        self.brandbtn.titleLabel.font = KSystemRealBoldFontSize15;
        [self.delegate selectIndex:2];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.brandbtn.center.x, weakSelf.moveLine.center.y);
        }];
    }

}

- (void) selectServe{
    
    if (!self.serveBtn.selected) {
        
        self.serveBtn.selected = YES;
        self.recmmendbtn.selected = NO;
        self.brandbtn.selected = NO;
        self.recmmendbtn.titleLabel.font = KSystemBoldFontSize15;
        self.serveBtn.titleLabel.font = KSystemRealBoldFontSize15;
        self.brandbtn.titleLabel.font = KSystemBoldFontSize15;
        [self.delegate selectIndex:1];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.serveBtn.center.x, weakSelf.moveLine.center.y);
        }];
    }
}

- (void) enterShoppingCar{
    
    ShoppingCarVC *vc = [[ShoppingCarVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterSearchVC{
    
    CMLSearchVC *vc = [[CMLSearchVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) refreshSelectIndex:(int) index{
    
    if (index == 0) {
        
        self.recmmendbtn.selected = YES;
        self.serveBtn.selected = NO;
        self.brandbtn.selected = NO;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.recmmendbtn.center.x, weakSelf.moveLine.center.y);
        }];

    }else if (index == 1){
        
        self.serveBtn.selected = YES;
        self.recmmendbtn.selected = NO;
        self.brandbtn.selected = NO;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.serveBtn.center.x, weakSelf.moveLine.center.y);
        }];
        
    }else{
        
        self.serveBtn.selected = NO;
        self.recmmendbtn.selected = NO;
        self.brandbtn.selected = YES;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.brandbtn.center.x, weakSelf.moveLine.center.y);
        }];
        
    }
    
}
@end
