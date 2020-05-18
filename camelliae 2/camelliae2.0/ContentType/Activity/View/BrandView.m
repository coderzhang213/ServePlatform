//
//  BrandView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BrandView.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "MerchantInfo.h"
#import "NetWorkTask.h"
#import "CommonFont.h"

@interface BrandView ()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation BrandView


- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        
        [self loadViews];
    }
    
    return self;
}

- (void)loadViews{

    
//    if ([self.obj.retData.merchantInfoStatus intValue] == 2) {
    
        self.currentheight = 0 ;
        self.hidden = YES;
//    }else{

        
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
//                                                                  0,
//                                                                  WIDTH - 20*Proportion*2,
//                                                                  240*Proportion)];
//        bgView.backgroundColor = [UIColor CMLWhiteColor];
//        bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//        bgView.layer.shadowOpacity = 0.05;
//        bgView.layer.shadowOffset = CGSizeMake(0, 0);
//        [self addSubview:bgView];
//
//        UIImageView *bgimage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
//                                                                             bgView.frame.size.height - 150*Proportion - 20*Proportion,
//                                                                             bgView.frame.size.width - 20*Proportion*2,
//                                                                             150*Proportion)];
//        bgimage.contentMode = UIViewContentModeScaleAspectFill;
//        bgimage.clipsToBounds = YES;
//        [bgView addSubview:bgimage];
//
//        [NetWorkTask setImageView:bgimage WithURL:self.obj.retData.merchantInfo.objCoverPic placeholderImage:nil];
//
//        UIView *imagebgWView = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2.0 - 100*Proportion/2.0,
//                                                                        20*Proportion,
//                                                                        100*Proportion,
//                                                                        100*Proportion)];
//        imagebgWView.backgroundColor = [UIColor CMLWhiteColor];
//        imagebgWView.layer.cornerRadius = 100*Proportion/2.0;
//        [bgView addSubview:imagebgWView];
//
//
//        UIImageView *brandImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*Proportion/2.0 - 90*Proportion/2.0,
//                                                                                100*Proportion/2.0 - 90*Proportion/2.0,
//                                                                                90*Proportion,
//                                                                                90*Proportion)];
//        brandImage.contentMode = UIViewContentModeScaleAspectFill;
//        brandImage.clipsToBounds = YES;
//        brandImage.layer.cornerRadius = 90*Proportion/2.0;
//        [imagebgWView addSubview:brandImage];
//
//
//        [NetWorkTask setImageView:brandImage WithURL:self.obj.retData.merchantInfo.objLogoPic placeholderImage:nil];
//
//        UILabel *brandName = [[UILabel alloc] init];
//        brandName.font = KSystemFontSize16;
//        brandName.textColor = [UIColor CMLWhiteColor];
//        brandName.text = self.obj.retData.merchantInfo.merchantsName;
//        [brandName sizeToFit];
//        brandName.frame = CGRectMake(bgView.frame.size.width/2.0 - brandName.frame.size.width/2.0,
//                                     130*Proportion,
//                                     brandName.frame.size.width,
//                                     brandName.frame.size.height);
//        [bgView addSubview:brandName];
//
//        UILabel *describe = [[UILabel alloc] init];
//        describe.font = KSystemFontSize11;
//        describe.textColor = [UIColor CMLWhiteColor];
//        describe.textAlignment = NSTextAlignmentCenter;
//        describe.numberOfLines = 0;
//        describe.text = self.obj.retData.merchantInfo.describe;
//
//        CGRect currentRect = [describe.text boundingRectWithSize:CGSizeMake(bgimage.frame.size.width - 20*Proportion*2, 1000)
//                                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                                      attributes:@{NSFontAttributeName:KSystemFontSize11}
//                                                         context:nil];
//        describe.frame = CGRectMake(40*Proportion,
//                                    CGRectGetMaxY(brandName.frame) + 10*Proportion,
//                                    bgimage.frame.size.width - 20*Proportion*2,
//                                    currentRect.size.height);
//        [bgView addSubview:describe];
//
//
//
//
//        self.currentheight = CGRectGetMaxY(describe.frame) + 40*Proportion;
//
//        bgimage.frame = CGRectMake(20*Proportion,
//                                   70*Proportion,
//                                   bgView.frame.size.width - 20*Proportion*2,
//                                   self.currentheight - 20*Proportion - 70*Proportion);
//
//        bgView.frame = CGRectMake(20*Proportion,
//                                  0,
//                                  WIDTH - 20*Proportion*2,
//                                  self.currentheight);
//
//
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:bgimage.bounds];
//        toolbar.alpha = 0.5;
//        toolbar.barStyle = UIBarStyleBlackTranslucent;
//        [bgimage addSubview:toolbar];
//    }

    
}

@end
