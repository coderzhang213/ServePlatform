//
//  TopBannerScrollView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "TopBannerScrollView.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "CMLScrollView.h"
#import "CMLBannerObj.h"
#import "WebViewLinkVC.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"
#import "CMLSpecialTopicVC.h"
#import "BaseResultObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLGiftVC.h"
#import "CMLInviteFriendsVC.h"
#import "CMLTimeLineDetailMessageVC.h"
#import "CMLUserTopicVC.h"
#import "CMLUserArticleVC.h"
#import "CMLMobClick.h"
#import "CMLBrandVC.h"
#import "CMLPrefectureVC.h"

@interface TopBannerScrollView ()<CMLScrollViewDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) CMLScrollView *headerScrollView;

@end

@implementation TopBannerScrollView

- (instancetype)initWith:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
        self.obj = obj;
        self.backgroundColor = [UIColor whiteColor];
        [self loadViews];
        
        
    }
    return self;
}


- (void) loadViews{


    if (!self.headerScrollView) {
       
        self.headerScrollView = [[CMLScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                WIDTH,
                                                                                966*Proportion + 40*Proportion)];
        self.headerScrollView.backgroundColor = [UIColor CMLWhiteColor];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 0; i < self.obj.retData.dataList.count; i++) {
            CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.obj.retData.dataList[i]];
            
            if (bannerObj.coverPic) {
                [imageArray addObject:bannerObj.coverPic];
            }
        }
        
        self.headerScrollView.imagesUrlArray = imageArray;
        self.headerScrollView.delegate = self;
        [self.headerScrollView refreshCurrentView];
        [self addSubview:self.headerScrollView];
        self.currentHeight = 966*Proportion + 40*Proportion;
    }
    
    if (self.obj.retData.dataList.count == 0) {
        
        self.currentHeight = 0;
        self.hidden = YES;
    }
}

- (void) selectIndex:(NSInteger) index{

   
    CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.obj.retData.dataList[index]];
    
    [CMLMobClick MainInterface:[NSNumber numberWithInteger:index]];
    
    if ([bannerObj.isJumpOut intValue] == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerObj.viewLink]];
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
                CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else if([bannerObj.objType intValue] == 98){
                
                CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else if ([bannerObj.objType intValue] == 100){
                
                CMLUserTopicVC *vc = [[CMLUserTopicVC alloc] initWithObj:bannerObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
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
            
            /**专题*/
            CMLSpecialTopicVC *vc = [[CMLSpecialTopicVC alloc] initWithImageUrl:bannerObj.coverPic
                                                                           name:bannerObj.title
                                                                     shortTitle:bannerObj.shortTitle
                                                                           desc:bannerObj.desc
                                                                       viewLink:bannerObj.viewLink
                                                                      currentId:bannerObj.bannerIndexId];
            
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([bannerObj.dataType intValue] == 5){
            
            CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([bannerObj.dataType intValue] == 4) {
            
            CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
            vc.currentID = bannerObj.objId;
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }
    }
}
@end

