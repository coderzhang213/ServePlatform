//
//  BrandServeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BrandServeView.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"

@implementation BrandServeView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                HEIGHT);
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    UIImageView *promImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BrandServeImg]];
    promImage.contentMode = UIViewContentModeScaleAspectFill;
    [promImage sizeToFit];
    promImage.frame = CGRectMake(0,
                                 0,
                                 promImage.frame.size.width,
                                 promImage.frame.size.height);
    promImage.center = self.center;
    [self addSubview:promImage];
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{

        weakSelf.alpha = 1;
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}
@end
