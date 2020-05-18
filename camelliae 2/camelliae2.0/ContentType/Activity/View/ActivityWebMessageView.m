//
//  ActivityWebMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ActivityWebMessageView.h"
#import "BaseResultObj.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "InformationDefaultVC.h"
#import "WebViewLinkVC.h"

@interface ActivityWebMessageView ()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation ActivityWebMessageView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {

        self.obj = obj;
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                             0,
                                                             WIDTH - 20*Proportion*2,
                                                             0)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOpacity = 0.05;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:bgView];
    

    if ([self.obj.retData.isHasReview intValue] == 1) {

        UILabel *reviewTypeLabel = [[UILabel alloc] init];
        reviewTypeLabel.text = @"资讯";
        if ([self.obj.retData.reviewType intValue] == 2) {
            reviewTypeLabel.text = @"外链";
        }
        
        reviewTypeLabel.textAlignment =NSTextAlignmentCenter;
        reviewTypeLabel.font = KSystemFontSize10;
        reviewTypeLabel.frame =CGRectMake(30*Proportion,
                                          30*Proportion,
                                          60*Proportion,
                                          36*Proportion);
        reviewTypeLabel.textColor = [UIColor CMLPurpleColor];
        reviewTypeLabel.layer.borderWidth =0.5;
        reviewTypeLabel.layer.borderColor =[UIColor CMLPurpleColor].CGColor;
        [bgView addSubview:reviewTypeLabel];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:AboutMesEnterImg]];
        [imageView sizeToFit];
        imageView.frame =CGRectMake(bgView.frame.size.width - 30*Proportion - imageView.frame.size.width,
                                    reviewTypeLabel.center.y - imageView.frame.size.height/2.0,
                                    imageView.frame.size.width,
                                    imageView.frame.size.height);
        [bgView addSubview:imageView];

        UILabel *name = [[UILabel alloc] init];
        name.text = self.obj.retData.title;
        if ([self.obj.retData.reviewType intValue] == 2) {
            name.text = self.obj.retData.reviewTitle;
        }
        name.font = KSystemFontSize14;
        name.textAlignment = NSTextAlignmentLeft;
        [name sizeToFit];
        name.frame = CGRectMake(CGRectGetMaxX(reviewTypeLabel.frame) + 30*Proportion,
                                30*Proportion,
                                WIDTH - 20*Proportion*2 - CGRectGetMaxX(reviewTypeLabel.frame) - 30*Proportion - (WIDTH - 20*Proportion*2 - imageView.frame.origin.x),
                                36*Proportion);
        [bgView addSubview:name];

        bgView.frame = CGRectMake(20*Proportion,
                                  0,
                                  WIDTH - 20*Proportion*2,
                                  36*Proportion + 30*Proportion*2);
        
        self.currentHeight = 36*Proportion + 30*Proportion*2;

        UIButton *button = [[UIButton alloc] initWithFrame:bgView.bounds];
        button.backgroundColor = [UIColor clearColor];
        [bgView addSubview:button];
        [button addTarget:self action:@selector(enterReviewVC) forControlEvents:UIControlEventTouchUpInside];


    }else{
        
        bgView.hidden = YES;
        self.currentHeight = 0;

    }

}

#pragma mark - enterReviewVC
- (void) enterReviewVC{
    
    if ([self.obj.retData.reviewType intValue] == 1) {
        
        InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:self.obj.retData.reviewObj];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = self.obj.retData.reviewObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}

@end
