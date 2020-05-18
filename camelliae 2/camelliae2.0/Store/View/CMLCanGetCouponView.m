//
//  CMLCanGetCouponView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//  可领取优惠券View

#import "CMLCanGetCouponView.h"
#import "CMLMyCouponsTableView.h"
#import "BaseResultObj.h"

@interface CMLCanGetCouponView ()

@property (nonatomic, strong) CMLMyCouponsTableView *couponTableView;

@property (nonatomic, strong) BaseResultObj *obj;

@end

@implementation CMLCanGetCouponView

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor CMLUserBlackColor];
    titleLabel.text = @"优惠券";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(42 * Proportion,
                                  100 * Proportion,
                                  CGRectGetWidth(titleLabel.frame),
                                  CGRectGetHeight(titleLabel.frame));
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    contentLabel.textColor = [UIColor CMLUserBlackColor];
    contentLabel.text = @"可领取优惠券";
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(42 * Proportion,
                                    CGRectGetMaxY(titleLabel.frame) + 25 * Proportion,
                                    CGRectGetWidth(contentLabel.frame),
                                    CGRectGetHeight(contentLabel.frame));
    [self addSubview:contentLabel];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setImage:[UIImage imageNamed:CloseImg] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton sizeToFit];
    cancelButton.frame = CGRectMake(WIDTH - CGRectGetWidth(cancelButton.frame) - 25 * Proportion,
                                    CGRectGetMidY(titleLabel.frame) - CGRectGetHeight(cancelButton.frame)/2.0,
                                    CGRectGetWidth(cancelButton.frame),
                                    CGRectGetHeight(cancelButton.frame));
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
        
    self.couponTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                   CGRectGetMaxY(contentLabel.frame) + 25 * Proportion,
                                                                                   WIDTH,
                                                                                   HEIGHT * 2/3 - CGRectGetMaxY(contentLabel.frame) - 25 * Proportion)
                            
                                                                  style:UITableViewStylePlain
                                                              withIsUse:[NSNumber numberWithInt:0]
                                                            withProcess:[NSNumber numberWithInt:2]
                                                                withObj:self.obj
                                                        withCouponsType:CanGetCouponsTableType
                                                              withPrice:self.obj.retData.totalAmountMin];
        
    if (@available(iOS 11.0, *)) {
        self.couponTableView.estimatedRowHeight = 0;
        self.couponTableView.estimatedSectionHeaderHeight = 0;
        self.couponTableView.estimatedSectionFooterHeight = 0;
    }
    [self addSubview:self.couponTableView];
}

- (void)cancelButtonClicked {
    [self.delegate cancelCanGetCouponView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
