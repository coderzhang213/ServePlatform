//
//  ShoppingCarFooterView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ShoppingCarFooterView.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommonImg.h"

@interface ShoppingCarFooterView ()

@property (nonatomic,strong) UIButton *buyBtn;

@property (nonatomic,strong) UILabel *totalMoney;

@property (nonatomic,strong) UIButton *selectAllBtn;

@property (nonatomic,strong) UILabel *selectAllProm;

@end

@implementation ShoppingCarFooterView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.layer.shadowOffset = CGSizeMake(0, -2);
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.frame = CGRectMake(0,
                                HEIGHT - 100*Proportion - SafeAreaBottomHeight,
                                WIDTH,
                                100*Proportion);
        [self loadViews];
    }
    return self;
}


- (void) loadViews{
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 250*Proportion,
                                                             0,
                                                             250*Proportion,
                                                             100*Proportion)];
    self.buyBtn.titleLabel.font = KSystemRealBoldFontSize17;
    [self.buyBtn setTitle:@"结算" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    self.buyBtn.backgroundColor = [UIColor CMLGreeenColor];
    [self addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalMoney = [[UILabel alloc] init];
    self.totalMoney.font = KSystemRealBoldFontSize15;
    self.totalMoney.textColor = [UIColor CMLBlackColor];
    self.totalMoney.text = @"总计：0";
    [self.totalMoney sizeToFit];
    self.totalMoney.frame = CGRectMake(WIDTH - self.buyBtn.frame.size.width - 30*Proportion - self.totalMoney.frame.size.width,
                                       self.frame.size.height/2.0 - self.totalMoney.frame.size.height/2.0,
                                       self.totalMoney.frame.size.width,
                                       self.totalMoney.frame.size.height);
    [self addSubview:self.totalMoney];
    
    self.selectAllBtn = [[UIButton alloc] init];
    [self.selectAllBtn setImage:[UIImage imageNamed:MailCarBrandNoSelectImg] forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:MailCarBrandSelectedImg] forState:UIControlStateSelected];
    self.selectAllBtn.contentMode = UIViewContentModeLeft;
    [self.selectAllBtn sizeToFit];
    self.selectAllBtn.frame = CGRectMake(30*Proportion,
                                         0,
                                         self.selectAllBtn.frame.size.width + 20*Proportion,
                                         self.frame.size.height);
    [self.selectAllBtn addTarget:self action:@selector(selectAllBrand) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectAllBtn];
    
    self.selectAllProm = [[UILabel alloc] init];
    self.selectAllProm.font = KSystemBoldFontSize13;
    self.selectAllProm.text = @"全选";
    [self.selectAllProm sizeToFit];
    self.selectAllProm.frame = CGRectMake(CGRectGetMaxX(self.selectAllBtn.frame),
                                          self.frame.size.height/2.0 - self.selectAllProm.frame.size.height/2.0,
                                          self.selectAllProm.frame.size.width,
                                          self.selectAllProm.frame.size.height);
    [self addSubview:self.selectAllProm];
    
}

- (void) refreshCurrentWithTotalMoney:(int) totalMoney{
    
    self.totalMoney.text = [NSString stringWithFormat:@"总计：%d",totalMoney];
    [self.totalMoney sizeToFit];
    self.totalMoney.frame = CGRectMake(WIDTH - self.buyBtn.frame.size.width - 30*Proportion - self.totalMoney.frame.size.width,
                                       self.frame.size.height/2.0 - self.totalMoney.frame.size.height/2.0,
                                       self.totalMoney.frame.size.width,
                                       self.totalMoney.frame.size.height);
}

- (void) selectAllBrand{
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
     
        [self.delegate selectAll];
        
    }else{
        
        [self.delegate cancelAll];
    }
}

- (void) buyAll{
    
    [self.delegate buyAllBrand];
}

- (void) changeAllSelectStatus{
    self.selectAllBtn.selected = NO;
}
@end
