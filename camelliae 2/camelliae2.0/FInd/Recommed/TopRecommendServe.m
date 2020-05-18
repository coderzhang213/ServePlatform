//
//  TopRecommendServe.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "TopRecommendServe.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

#define MainInterfaceLeftMargin              30
#define MainInterfaceSpace                   30
#define MainInterfaceOtherSpace              60
#define MainInterfaceTopMargin               30
#define MainInterfaceServeModelHeight        180
#define MainInterfaceShortTitleTopMargin     20

@interface TopRecommendServe ()

@property (nonatomic,strong) BaseResultObj *recommenModuleObj;

@end

@implementation TopRecommendServe

- (instancetype)initWith:(BaseResultObj *)obj{

    self = [super init];
    if (self) {
        
        self.recommenModuleObj = obj;
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    if (self.recommenModuleObj.retData.moduleProjectRecomm) {
        
        UILabel *promName = [[UILabel alloc] init];
        promName.backgroundColor = [UIColor whiteColor];
        promName.text = @"甄选服务";
        promName.layer.masksToBounds = YES;
        promName.font =KSystemRealBoldFontSize18;
        [promName sizeToFit];
        promName.frame = CGRectMake(WIDTH/2.0 - promName.frame.size.width/2.0,
                                    62*Proportion,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [bgView addSubview:promName];
        
        UILabel *shortTitleLab = [[UILabel alloc] init];
        shortTitleLab.text = @"高端定制为你定义生活新态度";
        shortTitleLab.font = KSystemBoldFontSize12;
        [shortTitleLab sizeToFit];
        shortTitleLab.frame = CGRectMake(WIDTH/2.0 - shortTitleLab.frame.size.width/2.0,
                                         CGRectGetMaxY(promName.frame) + 30*Proportion,
                                         shortTitleLab.frame.size.width,
                                         shortTitleLab.frame.size.height);
        [bgView addSubview:shortTitleLab];
        
        UIScrollView *promScrollView = [[UIScrollView alloc] init];
        promScrollView.showsVerticalScrollIndicator = NO;
        promScrollView.showsHorizontalScrollIndicator = NO;
        [bgView addSubview:promScrollView];
        
        
        for (int i = 0; i < self.recommenModuleObj.retData.moduleProjectRecomm.dataList.count; i++) {
            
            
            CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleProjectRecomm.dataList[i]];
            
            UIView *modelView = [[UIView alloc] init];
            modelView.backgroundColor = [UIColor CMLWhiteColor];
            [promScrollView addSubview:modelView];
//            modelView.layer.shadowColor = [UIColor blackColor].CGColor;
//            modelView.layer.shadowOpacity = 0.05;
//            modelView.layer.shadowOffset = CGSizeMake(0, 0);
            
            UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    500*Proportion,
                                                                                    300*Proportion)];
            modelImage.clipsToBounds = YES;
            modelImage.contentMode = UIViewContentModeScaleAspectFill;
            modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
            modelImage.userInteractionEnabled = YES;
            modelImage.layer.cornerRadius = 10*Proportion;
            [modelView addSubview:modelImage];
            [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
            
            UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
            preTag.backgroundColor = [UIColor CMLBlackColor];
            preTag.textColor = [UIColor CMLBrownColor];
            preTag.font = KSystemFontSize11;
            preTag.text = @"预售";
            preTag.textAlignment = NSTextAlignmentCenter;
            [modelImage addSubview:preTag];
            
            UILabel *modelLabel = [[UILabel alloc] init];
            modelLabel.text = currentObj.title;
            modelLabel.font = KSystemBoldFontSize14;
            modelLabel.numberOfLines = 0;
            [modelLabel sizeToFit];
            modelLabel.textAlignment = NSTextAlignmentLeft;
            modelLabel.textColor = [UIColor CMLBlackColor];
            modelLabel.backgroundColor = [UIColor whiteColor];
            modelLabel.contentMode = UIViewContentModeTop;
            [modelView addSubview:modelLabel];
            
            UILabel *modelPriceLabel = [[UILabel alloc] init];
            modelPriceLabel.font = KSystemBoldFontSize18;
            modelPriceLabel.backgroundColor = [UIColor whiteColor];
            modelPriceLabel.textAlignment = NSTextAlignmentCenter;
            if ([currentObj.isHasPriceInterval intValue] == 1 ) {
                
                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@起",currentObj.price];
                
            }else{
                
                modelPriceLabel.text = [NSString stringWithFormat:@"￥%@",currentObj.price];
            }
            
            modelPriceLabel.textColor = [UIColor CMLBrownColor];
            [modelPriceLabel sizeToFit];
            
            if (modelLabel.frame.size.width > modelImage.frame.size.width) {
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 13*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height*2);
                
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }else{
                
                modelLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                              CGRectGetMaxY(modelImage.frame) + 13*Proportion,
                                              modelImage.frame.size.width,
                                              modelLabel.frame.size.height);
                modelPriceLabel.frame = CGRectMake(modelImage.frame.origin.x,
                                                   CGRectGetMaxY(modelLabel.frame) + modelLabel.frame.size.height  + 20*Proportion,
                                                   modelPriceLabel.frame.size.width,
                                                   modelPriceLabel.frame.size.height);
            }
            
            [modelView addSubview:modelPriceLabel];
            
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
            
            if ([costObj.payMode intValue] == 1) {
                
                UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(modelPriceLabel.frame) + 10*Proportion,
                                                                             modelPriceLabel.center.y - 30*Proportion/2.0,
                                                                             50*Proportion,
                                                                             30*Proportion)];
                promLab.font = KSystemFontSize10;
                promLab.backgroundColor = [UIColor CMLBrownColor];
                promLab.layer.cornerRadius = 4*Proportion;
                promLab.clipsToBounds = YES;
                promLab.textColor = [UIColor CMLWhiteColor];
                promLab.textAlignment = NSTextAlignmentCenter;
                promLab.text = @"订金";
                [modelView addSubview:promLab];
                
            }
            
            if ([costObj.is_pre intValue] == 1) {
                
                preTag.hidden = NO;
            }else{
                
                preTag.hidden = YES;
            }
            
            modelView.frame = CGRectMake(30*Proportion + (500*Proportion + 30*Proportion)*i,
                                         30*Proportion,
                                         500*Proportion,
                                         CGRectGetMaxY(modelPriceLabel.frame) +30*Proportion);
            
            UIButton *modelBtn = [[UIButton alloc] initWithFrame:modelView.bounds];
            modelBtn.tag = i + 1;
            modelBtn.backgroundColor = [UIColor clearColor];
            [modelView addSubview:modelBtn];
            [modelBtn addTarget:self action:@selector(enterModuleProjectRecommVC:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == self.recommenModuleObj.retData.moduleProjectRecomm.dataList.count - 1) {
                promScrollView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(shortTitleLab.frame),
                                                  WIDTH,
                                                  CGRectGetMaxY(modelView.frame) + 30*Proportion);
                promScrollView.contentSize = CGSizeMake(CGRectGetMaxX(modelView.frame) + 30*Proportion,
                                                        promScrollView.frame.size.height);
                
                UIButton *morebtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 183*Proportion/2.0, CGRectGetMaxY(promScrollView.frame), 183*Proportion, 60*Proportion)];
                morebtn.backgroundColor = [UIColor CMLBlack010101Color];
                morebtn.titleLabel.font = KSystemBoldFontSize12;
                [morebtn setTitle:@"查看更多" forState:UIControlStateNormal];
                [bgView addSubview:morebtn];
                [morebtn addTarget:self action:@selector(showServeView) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(morebtn.frame) + 40*Proportion,
                                                                              WIDTH,
                                                                              20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
                [self addSubview:bottomView];

                bgView.frame = CGRectMake(0,
                                          0,
                                          WIDTH,
                                          CGRectGetMaxY(bottomView.frame));
                
                
                self.currentHeight = bgView.frame.size.height;
                
                
            }
            
        }
        
    }else{
        bgView.hidden = YES;
        self.currentHeight = 0;
        
    }

}

- (void) enterModuleProjectRecommVC:(UIButton *)button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleProjectRecomm.dataList[button.tag - 1]];
    
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void)showServeView{

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[VCManger homeVC] showCurrentViewController:homeStoreTag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectStoreServe" object:nil];
   
}
@end
