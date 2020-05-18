//
//  CMLStroreSpecialServeRecommdView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/27.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLStoreSpecialServeRecommdView.h"
#import "BaseResultObj.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLModuleObj.h"
#import "NetWorkTask.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "CMLBannerObj.h"
#import "WebViewLinkVC.h"
#import "ActivityDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLBrandVC.h"
#import "InformationDefaultVC.h"
#import "CMLSpecialTopicVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"


@interface CMLStoreSpecialServeRecommdView()

@property (nonatomic,strong) BaseResultObj *leftObj;

@property (nonatomic,strong) BaseResultObj *rightObj;

@property (nonatomic,strong) UIView *leftServeView;

@property (nonatomic,strong) UIView *rightTopServeView;

@property (nonatomic,strong) UIView *rigthBottomServeView;

@end

@implementation CMLStoreSpecialServeRecommdView

- (instancetype)initWith:(BaseResultObj *) Leftobj and:(BaseResultObj *) rightObj{
    
    self = [super init];
    
    if (self) {
        self.leftObj = Leftobj;
        self.rightObj = rightObj;
        self.backgroundColor = [UIColor whiteColor];
        [self loadViews];
        
        
    }
    return self;
}

- (void) loadViews{
    
    
    if (self.leftObj.retData.dataList.count == 0 || self.rightObj.retData.dataList.count < 2) {
        
        
        self.currentHeight = 0;
        self.hidden = YES;
        
    }else{
        
        UILabel *promName = [[UILabel alloc] init];
        promName.backgroundColor = [UIColor whiteColor];
        promName.text = @"特别推荐";
        promName.layer.masksToBounds = YES;
        promName.font =KSystemRealBoldFontSize17;
        [promName sizeToFit];
        promName.frame = CGRectMake(30*Proportion,
                                    0,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [self addSubview:promName];
        
        self.leftServeView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      CGRectGetMaxY(promName.frame) + 20*Proportion,
                                                                      320*Proportion,
                                                                      426*Proportion)];
        self.leftServeView.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:self.leftServeView];
        
        CMLModuleObj *currentLeftObj = [CMLModuleObj getBaseObjFrom:[self.leftObj.retData.dataList firstObject]];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:self.leftServeView.bounds];
        leftImage.contentMode = UIViewContentModeScaleAspectFill;
        leftImage.clipsToBounds = YES;
        leftImage.userInteractionEnabled = YES;
        leftImage.layer.cornerRadius = 10*Proportion;
        [self.leftServeView addSubview:leftImage];
        [NetWorkTask setImageView:leftImage WithURL:currentLeftObj.coverPic placeholderImage:nil];
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:leftImage.bounds];
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftImage addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(enterLeftRecomm) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightTopServeView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - 366*Proportion,
                                                                          CGRectGetMaxY(promName.frame) + 20*Proportion,
                                                                          366*Proportion,
                                                                          211*Proportion)];
        self.rightTopServeView.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:self.rightTopServeView];
        
        CMLModuleObj *currentRightObj = [CMLModuleObj getBaseObjFrom:[self.rightObj.retData.dataList firstObject]];
        
        UIImageView *rightTopImage = [[UIImageView alloc] initWithFrame:self.rightTopServeView.bounds];
        rightTopImage.contentMode = UIViewContentModeScaleAspectFill;
        rightTopImage.clipsToBounds = YES;
        rightTopImage.userInteractionEnabled = YES;
        rightTopImage.layer.cornerRadius = 10*Proportion;
        [self.rightTopServeView addSubview:rightTopImage];
        [NetWorkTask setImageView:rightTopImage WithURL:currentRightObj.coverPic placeholderImage:nil];
        
        UIButton *rightTopBtn = [[UIButton alloc] initWithFrame:rightTopImage.bounds];
        rightTopBtn.backgroundColor = [UIColor clearColor];
        [rightTopImage addSubview:rightTopBtn];
        [rightTopBtn addTarget:self action:@selector(enterRightTopRecomm) forControlEvents:UIControlEventTouchUpInside];
        
        self.rigthBottomServeView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - 366*Proportion,
                                                                             CGRectGetMaxY(self.leftServeView.frame) - 210*Proportion,
                                                                             366*Proportion,
                                                                             210*Proportion)];
        self.rigthBottomServeView .backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:self.rigthBottomServeView];
        
        CMLModuleObj *currentRightBottomObj = [CMLModuleObj getBaseObjFrom:[self.rightObj.retData.dataList lastObject]];
        
        UIImageView *rightBottomImage = [[UIImageView alloc] initWithFrame:self.rightTopServeView.bounds];
        rightBottomImage.contentMode = UIViewContentModeScaleAspectFill;
        rightBottomImage.clipsToBounds = YES;
        rightBottomImage.userInteractionEnabled = YES;
        rightBottomImage.layer.cornerRadius = 10*Proportion;
        [self.rigthBottomServeView addSubview:rightBottomImage];
        [NetWorkTask setImageView:rightBottomImage WithURL:currentRightBottomObj.coverPic placeholderImage:nil];
        
        UIButton *rightBottomBtn = [[UIButton alloc] initWithFrame:rightBottomImage.bounds];
        rightBottomBtn.backgroundColor = [UIColor clearColor];
        [rightBottomImage addSubview:rightBottomBtn];
        [rightBottomBtn addTarget:self action:@selector(enterRightBottomRecomm) forControlEvents:UIControlEventTouchUpInside];
        
        self.currentHeight = CGRectGetMaxY(self.leftServeView.frame) + 60*Proportion;
        
    }
    

}

- (void) enterLeftRecomm{
    
    CMLBannerObj *currentLeftObj = [CMLBannerObj getBaseObjFrom:[self.leftObj.retData.dataList firstObject]];
//    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentLeftObj.objId];
//    [[VCManger mainVC] pushVC:vc animate:YES];
    [self pushVCWithObj:currentLeftObj];
}

- (void) enterRightTopRecomm{
    
    CMLBannerObj *currentRightObj = [CMLBannerObj getBaseObjFrom:[self.rightObj.retData.dataList firstObject]];
//    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentRightObj.objId];
//    [[VCManger mainVC] pushVC:vc animate:YES];
    [self pushVCWithObj:currentRightObj];
    
}

- (void) enterRightBottomRecomm{
    
    CMLBannerObj *currentRightObj = [CMLBannerObj getBaseObjFrom:[self.rightObj.retData.dataList lastObject]];
//    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentRightObj.objId];
//    [[VCManger mainVC] pushVC:vc animate:YES];
    [self pushVCWithObj:currentRightObj];
    
}

- (void) pushVCWithObj:(CMLBannerObj *) bannerObj{
    
    if ([bannerObj.isCanPublish intValue] == 1) {
        if ([bannerObj.objType intValue] == 2){
            
            
            CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
            
        }else if ([bannerObj.objType intValue] == 3){
            
            CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([bannerObj.objType intValue] == 7){
            
            
            CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
        
        
    }else{
      
        if ([bannerObj.dataType intValue] == 3) {
            
            /**外链*/
            WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
            vc.url = bannerObj.viewLink;
            vc.name = bannerObj.title;
            //        vc.isDetailMes = YES;
            [[VCManger mainVC] pushVC:vc animate:YES];
            vc.shareUrl = bannerObj.shareUrl;
            vc.isShare = bannerObj.shareStatus;
            vc.desc = bannerObj.desc;
            if (bannerObj.shareImg) {
                
                vc.imageUrl = bannerObj.shareImg;
            }else{
                
                vc.imageUrl = bannerObj.coverPic;
            }
            
        }else if ([bannerObj.dataType intValue] == 1){
            
            if([bannerObj.objType intValue] == 1){
                
                /**咨询*/
                InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
                
            }else if([bannerObj.objType intValue] == 2){
                
                /**活动详情*/
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 3){
                
                /**服务详情*/
                ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 4){
                
                /**相册*/
//                CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:bannerObj.objId ImageName:@""];
//                [[VCManger mainVC] pushVC:vc animate:YES];
                CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:bannerObj.objId ImageName:@""];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 7){
                
                /**商品*/
                CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else if ([bannerObj.objType intValue] == 8){
                
                /**商品*/
                //            CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:bannerObj.objId];
                //            [[VCManger mainVC] pushVC:vc animate:YES];
            }else if([bannerObj.objType intValue] == 98){
                
                CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 100){
                
                //            CMLUserTopicVC *vc = [[CMLUserTopicVC alloc] initWithObj:bannerObj.objId];
                //            [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 9){
                
                CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:bannerObj.coverPic
                                                         andDetailMes:bannerObj.desc
                                                         LogoImageUrl:bannerObj.logoPic
                                                              brandID:bannerObj.objId];
                vc.goodsNum = bannerObj.goodsCount;
                vc.serveNum = bannerObj.projectCount;
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }
            
        }else if ([bannerObj.dataType intValue] == 2){
            
            //        /**专题*/
            CMLSpecialTopicVC *vc = [[CMLSpecialTopicVC alloc] initWithImageUrl:bannerObj.coverPic
                                                                           name:bannerObj.title
                                                                     shortTitle:bannerObj.shortTitle
                                                                           desc:bannerObj.desc
                                                                       viewLink:bannerObj.viewLink
                                                                      currentId:bannerObj.bannerIndexId];
            
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([bannerObj.dataType intValue] == 5){
            
            //        CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
            //        [[VCManger mainVC] pushVC:vc animate:YES];
            
        }
    }
    

}
@end
