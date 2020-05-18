//
//  CMLStoreServeTopScroolView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/27.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLStoreServeTopScroolView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "NetWorkTask.h"
#import "CMLPageControl.h"
#import "CMLModuleObj.h"
#import "WebViewLinkVC.h"
#import "CMLBannerObj.h"
#import "CMLBrandVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "ActivityDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"/*替换CMLAllImagesVC.h*/
#import "InformationDefaultVC.h"
#import "CMLSpecialTopicVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"

@interface CMLStoreServeTopScroolView ()<UIScrollViewDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) CMLPageControl *pageControl;

@end
@implementation CMLStoreServeTopScroolView

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
    
    if (self.obj.retData.dataList.count == 0 ) {
        
        
        self.currentHeight = 0;
        self.hidden = YES;
        
    }else{
        
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                  0,
                                                                                  WIDTH,
                                                                                  486*Proportion)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:mainScrollView];
    mainScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.dataList.count, 486*Proportion);
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    
    self.currentHeight = 486*Proportion;
    
    for (int i = 0; i < self.obj.retData.dataList.count; i++) {
        
        CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.obj.retData.dataList[i]];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i*WIDTH,
                                                                  0,
                                                                  WIDTH,
                                                                  486*Proportion)];
        bgView.backgroundColor = [UIColor CMLWhiteColor];
        [mainScrollView addSubview:bgView];
        
        UIImageView *moduleImage =[[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                0,
                                                                                WIDTH - 30*Proportion*2,
                                                                                414*Proportion)];
        moduleImage.userInteractionEnabled = YES;
        moduleImage.layer.cornerRadius = 10*Proportion;
        moduleImage.clipsToBounds = YES;
        [bgView addSubview:moduleImage];
        [NetWorkTask setImageView:moduleImage WithURL:currentObj.coverPic placeholderImage:nil];
        UIButton *btn = [[UIButton alloc] initWithFrame:moduleImage.bounds];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [moduleImage addSubview:btn];
        [btn addTarget:self action:@selector(enterServeDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.pageControl = [[CMLPageControl alloc] initWithFrame:CGRectMake(0,
                                                                        414*Proportion - 40*Proportion,
                                                                        WIDTH,
                                                                        40*Proportion)];
    self.pageControl.selectColor = [UIColor CMLWhiteColor];
    self.pageControl.otherColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0.5];
    self.pageControl.pageLineSpace = 10*Proportion;
    self.pageControl.pageLineWidth = 20*Proportion;
    self.pageControl.pageNum = (int)self.obj.retData.dataList.count;
    [self addSubview:self.pageControl];

    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.pageControl refreshPageControl:scrollView.contentOffset.x/scrollView.frame.size.width];

}
- (void) enterServeDetailVC:(UIButton *) btn{
    
     CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.obj.retData.dataList[btn.tag]];
    

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
            
            /**专题*/
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
    

//    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentObj.objId];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
