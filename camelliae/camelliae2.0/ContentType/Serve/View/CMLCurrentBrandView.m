//
//  CMLCurrentBrandView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCurrentBrandView.h"
#import "BaseResultObj.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "BrandModuleObj.h"
#import "VCManger.h"
#import "CMLBrandVC.h"

@interface CMLCurrentBrandView()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLCurrentBrandView

- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    
    if (self) {
     
        self.obj = obj;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              220*Proportion)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:bgView];
    
    UIImageView *brandImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                            30*Proportion,
                                                                            WIDTH - 30*Proportion*2,
                                                                            160*Proportion)];
    brandImage.contentMode = UIViewContentModeScaleAspectFill;
    brandImage.clipsToBounds = YES;
    brandImage.userInteractionEnabled = YES;
    [bgView addSubview:brandImage];
    [NetWorkTask setImageView:brandImage WithURL:self.obj.retData.brandInfo.coverPic placeholderImage:nil];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(67*Proportion, 160*Proportion/2.0 - 122*Proportion/2.0, 122*Proportion, 122*Proportion)];
    logoImage.clipsToBounds = YES;
    logoImage.backgroundColor = [UIColor CMLWhiteColor];
    logoImage.layer.cornerRadius = 122*Proportion/2.0;
    [brandImage addSubview:logoImage];
    [NetWorkTask setImageView:logoImage WithURL:self.obj.retData.brandInfo.logoPic placeholderImage:nil];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:brandImage.bounds];
    shadowView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
    [brandImage addSubview:shadowView];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize10;
    promLab.textColor = [UIColor CMLWhiteColor];
    promLab.text = @"来自品牌";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(brandImage.frame.size.width/2.0 - promLab.frame.size.width/2.0,
                               30*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [brandImage addSubview:promLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(promLab.center.x - 34*Proportion/2.0,
                                                                CGRectGetMaxY(promLab.frame) + 18*Proportion,
                                                                34*Proportion,
                                                                1*Proportion)];
    lineView.backgroundColor = [UIColor CMLWhiteColor];
    [brandImage addSubview:lineView];
    
    UILabel *brandname = [[UILabel alloc] init];
    brandname.font = KSystemBoldFontSize18;
    brandname.textColor = [UIColor CMLWhiteColor];
    brandname.text = self.obj.retData.brandInfo.name;
    [brandname sizeToFit];
    brandname.frame = CGRectMake(brandImage.frame.size.width/2.0 - brandname.frame.size.width/2.0,
                                 CGRectGetMaxY(promLab.frame) + 36*Proportion,
                                 brandname.frame.size.width,
                                 brandname.frame.size.height);
    [brandImage addSubview:brandname];
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(bgView.frame),
                                                               WIDTH,
                                                               20*Proportion)];
    endView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview: endView];
    
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:brandImage.bounds];
    enterBtn.backgroundColor = [UIColor clearColor];
    [brandImage addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(enterBrandVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentHeight = CGRectGetMaxY(endView.frame);
    
}

- (void) enterBrandVC{
    
    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:self.obj.retData.brandInfo.coverPic
                                             andDetailMes:self.obj.retData.brandInfo.desc
                                             LogoImageUrl:self.obj.retData.brandInfo.logoPic
                                                  brandID:self.obj.retData.brandInfo.currentID];
    vc.goodsNum = self.obj.retData.brandInfo.goodsCount;
    vc.serveNum = self.obj.retData.brandInfo.projectCount;
    [[VCManger mainVC]pushVC:vc animate:YES];
}

@end
