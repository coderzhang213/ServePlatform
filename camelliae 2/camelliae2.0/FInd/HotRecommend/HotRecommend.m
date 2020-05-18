//
//  HotRecommend.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/22.
//  Copyright © 2017年 张越. All rights reserved.
//
#import "HotRecommend.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "DataManager.h"
#import "NSDate+CMLExspand.h"
#import "WebViewLinkVC.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"
#import "CMLGiftVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLInviteFriendsVC.h"
#import "CMLMobClick.h"

@implementation HotRecommend

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        [self showPromVersion];
    }
    
    return self;
}

- (void) showPromVersion{
    [AppGroup version];
    
    
    if ([[AppGroup appVersion] isEqualToString:@"4.0.0"]) {

        if ([[[DataManager lightData] readPromVersion] isEqualToString:@"4.0.0"]) {

            [self judgeTime];

        }else{

            /****/
            [[DataManager lightData] savePromVersion:@"4.0.0"];
            [self loadPromVersionView];
            /***/

        }

    }else{

        [self judgeTime];

    }
}

- (void) judgeTime{
    
        if ([[[DataManager lightData] readIsShow] intValue] == 1) {
            
            NSString *oldStr = [NSDate getStringDependOnFormatterCFromDate:[[DataManager lightData] readCurrentTime]];
            
            NSString *newStr = [NSDate getStringDependOnFormatterCFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
            
            NSArray *oldArray = [oldStr componentsSeparatedByString:@"-"];
            
            NSArray *newArray = [newStr componentsSeparatedByString:@"-"];
            
            int days = 0;
            
            if ([oldArray[1] intValue] != [newArray[1] intValue]) {
                
                if ([newArray[1] intValue] < [oldArray[1] intValue]) {
                    
                    days = 31 - [[oldArray lastObject] intValue] + [[newArray lastObject] intValue];
                    
                }else{
                    NSInteger allDays = [NSDate getMonthAllDays:[[DataManager lightData] readCurrentTime]];
                    days = (int)allDays - [[oldArray lastObject] intValue] + [[newArray lastObject] intValue];
                    
                }
            }else{
                
                days = [[newArray lastObject] intValue] - [[oldArray lastObject] intValue];
            }
            

            if (days != 0) {
                
                if (days % [[[DataManager lightData] readPeriod] intValue] == 0) {
                    
                    [[DataManager lightData] saveCurrentTime:[NSDate dateWithTimeIntervalSinceNow:0]];
                    [self loadNavcView];
                }else{
                    
                    self.hidden = YES;
                }
            }else{
                
                self.hidden = YES;
            }
        }

}

/*4.0.0版本内容提示*/
- (void) loadPromVersionView{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            HEIGHT);
    self.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.backgroundColor = [UIColor clearColor];
    bgImage.image = [UIImage imageNamed:VersionPromImg];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds = YES;
    [bgImage sizeToFit];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(0,
                               0,
                               WIDTH,
                               HEIGHT);
    [self addSubview:bgImage];

    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn sizeToFit];
    cancelBtn.frame = CGRectMake(0,
                                 0,
                                 WIDTH ,
                                 HEIGHT);
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];

}

- (void) loadNavcView{
    
    /*每个子视图都调用*/
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            HEIGHT);
    self.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - [[[DataManager lightData] readNavImageWidth] intValue]*Proportion/2.0,
                                                                         HEIGHT/2.0 - [[[DataManager lightData] readNavImageHeight] intValue]*Proportion/2.0,
                                                                         [[[DataManager lightData] readNavImageWidth] intValue]*Proportion,
                                                                         [[[DataManager lightData] readNavImageHeight] intValue]*Proportion)];
    
    
    bgImage.backgroundColor = [UIColor clearColor];
    bgImage.userInteractionEnabled = YES;
    [NetWorkTask setImageView:bgImage WithURL:[[DataManager lightData] readNavImageUrl] placeholderImage:nil];
    [self addSubview:bgImage];
    

    UIButton *enterbtn = [[UIButton alloc] initWithFrame:bgImage.bounds];
    enterbtn.backgroundColor = [UIColor clearColor];
    [bgImage addSubview:enterbtn];
    [enterbtn addTarget:self action:@selector(enterVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage imageNamed:AlterViewCloseBtnImg] forState:UIControlStateNormal];
    [cancelBtn sizeToFit];
    cancelBtn.frame = CGRectMake(WIDTH/2.0 - cancelBtn.frame.size.width/2.0,
                                 CGRectGetMaxY(bgImage.frame) + 40*Proportion,
                                 cancelBtn.frame.size.width ,
                                 cancelBtn.frame.size.height);
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) enterVC{
    
    [self removeFromSuperview];
    
    [CMLMobClick Popup];
    
    if ([[[DataManager lightData] readDataType] intValue] == 3) {
        
        /**外链*/
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = [[DataManager lightData] readWebUrl];
        vc.name = @"";
//        vc.isDetailMes = YES;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if ([[[DataManager lightData] readDataType] intValue] == 6){
        
        [[VCManger homeVC] showCurrentViewController:homeActivityTag];
        
        
    }else if ([[[DataManager lightData] readDataType] intValue] == 7){
        
        [[VCManger homeVC] showCurrentViewController:homeActivityTag];
        
        
    }else if ([[[DataManager lightData] readDataType] intValue] == 1){
        
        if([[[DataManager lightData] readObjType] intValue] == 1){
            
            /**咨询*/
            InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:[[DataManager lightData] readObjID]];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
            
        }else if([[[DataManager lightData] readObjType] intValue] == 2){
            
            /**活动详情*/
            ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:[[DataManager lightData] readObjID]];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([[[DataManager lightData] readObjType] intValue] == 3){
            
            /**服务详情*/
            ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:[[DataManager lightData] readObjID]];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([[[DataManager lightData] readObjType] intValue] == 4){
            
            /**相册*/
//            CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:[[DataManager lightData] readObjID] ImageName:@""];
//            [[VCManger mainVC] pushVC:vc animate:YES];
            CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:[[DataManager lightData] readObjID] ImageName:@""];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([[[DataManager lightData] readObjType] intValue] == 7){
            
            /**商品*/
            CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:[[DataManager lightData] readObjID]];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }else if ([[[DataManager lightData] readObjType] intValue] == 8){
            
            /**礼品*/
            CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:[[DataManager lightData] readObjID]];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
    }else if ([[[DataManager lightData] readDataType] intValue] == 2){
        
        
    }else if ([[[DataManager lightData] readDataType] intValue] == 5){
        
        CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
    
}

- (void) closeView{
    
    [self removeFromSuperview];
}

@end
