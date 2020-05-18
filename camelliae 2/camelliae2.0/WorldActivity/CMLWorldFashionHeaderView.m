//
//  CMLWorldFashionHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/20.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLWorldFashionHeaderView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLBannerObj.h"
#import "VCManger.h"
#import "WebViewLinkVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLGiftVC.h"
#import "CMLUserArticleVC.h"
#import "CMLUserTopicVC.h"
#import "CMLBrandVC.h"
#import "CMLSpecialTopicVC.h"
#import "CMLUserPushGoodsVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushActivityDetailVC.h"

@interface CMLWorldFashionHeaderView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIPageControl *currentPageControl;

@property (nonatomic,strong) UIScrollView *worldScrollView;

@property (nonatomic,strong) UIScrollView *todayScrollView;

@property (nonatomic,strong) UIView *scrollLineView;

@end

@implementation CMLWorldFashionHeaderView


- (instancetype)initWithObj:(BaseResultObj *)obj{
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void) refreshCurrentView{
    
    [self loadViews];
}

- (void) loadViews{
    
    self.worldScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                          20*Proportion,
                                                                          WIDTH,
                                                                          WIDTH/16*9)];
    self.worldScrollView.pagingEnabled = YES;
    self.worldScrollView.delegate = self;
    self.worldScrollView.tag = 1;
    self.worldScrollView.showsVerticalScrollIndicator = NO;
    self.worldScrollView.showsHorizontalScrollIndicator = NO;
    self.worldScrollView.contentSize = CGSizeMake(WIDTH*self.topScrollNarray.count,
                                                  self.worldScrollView.frame.size.height);
    [self addSubview:self.worldScrollView];
    
    for (int i = 0; i < self.topScrollNarray.count; i++) {
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i + 30*Proportion,
                                                                                 WIDTH/16*9/2.0 - (WIDTH - 30*Proportion*2)/16*9/2.0,
                                                                                 WIDTH - 30*Proportion*2,
                                                                                 (WIDTH - 30*Proportion*2)/16*9)];
        moduleImage.clipsToBounds = YES;
        moduleImage.userInteractionEnabled = YES;
        moduleImage.layer.cornerRadius = 10*Proportion;
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.worldScrollView addSubview:moduleImage];
        CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.topScrollNarray[i]];
        [NetWorkTask setImageView:moduleImage WithURL:bannerObj.coverPic placeholderImage:nil];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                   0,
                                                                   WIDTH,
                                                                   WIDTH/16*9)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [self.worldScrollView addSubview:btn];
        [btn addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(self.worldScrollView.frame),
                                                                              self.frame.size.width,
                                                                              40*Proportion)];
    self.currentPageControl.currentPage = 0;
    self.currentPageControl.numberOfPages = self.topScrollNarray.count;
    self.currentPageControl.userInteractionEnabled = NO;
    self.currentPageControl.currentPageIndicatorTintColor = [UIColor CMLBrownColor];
    self.currentPageControl.pageIndicatorTintColor = [[UIColor CMLBrownColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.currentPageControl];
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemRealBoldFontSize18;
    titleLab.textColor = [UIColor CMLBlackColor];
    titleLab.text = @"今日焦点";
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(WIDTH/2.0 - titleLab.frame.size.width/2.0,
                                CGRectGetMaxY(self.currentPageControl.frame) + 30*Proportion,
                                titleLab.frame.size.width,
                                titleLab.frame.size.height);
    [self addSubview:titleLab];
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.font = KSystemFontSize12;
    descLab.text = @"街力强袭，#经典由你#PUMA SUEDE 50热力持续，再掀潮流话题";
    [descLab sizeToFit];
    descLab.frame = CGRectMake(WIDTH/2.0 - descLab.frame.size.width/2.0, CGRectGetMaxY(titleLab.frame) + 30*Proportion, descLab.frame.size.width, descLab.frame.size.height);
//    [self addSubview:descLab];
    
   
    self.todayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                          CGRectGetMaxY(titleLab.frame) + 30*Proportion,
                                                                          WIDTH - 30*Proportion*2,
                                                                          (WIDTH - 30*Proportion*2)/16*9 + descLab.frame.size.height + 20*Proportion)];
    self.todayScrollView.pagingEnabled = YES;
    self.todayScrollView.tag = 2;
    self.todayScrollView.delegate = self;
    self.todayScrollView.showsHorizontalScrollIndicator = NO;
    self.todayScrollView.showsVerticalScrollIndicator = NO;
    self.todayScrollView.contentSize = CGSizeMake(self.todayScrollView.frame.size.width * self.todayFocusNarray.count, self.todayScrollView.frame.size.height);
    [self addSubview:self.todayScrollView];
    
    
    for (int i = 0; i < self.todayFocusNarray.count; i++) {
        
        CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.todayFocusNarray[i]];
        
        UILabel *descLab = [[UILabel alloc] init];
        descLab.font = KSystemFontSize12;
        descLab.text = bannerObj.title;
        descLab.textAlignment = NSTextAlignmentCenter;
        [descLab sizeToFit];
        descLab.frame = CGRectMake(self.todayScrollView.frame.size.width*i,
                                   0,
                                   self.todayScrollView.frame.size.width,
                                   descLab.frame.size.height);
        [self.todayScrollView addSubview:descLab];
        

        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.todayScrollView.frame.size.width*i,
                                                                                 CGRectGetMaxY(descLab.frame) + 20*Proportion,
                                                                                 self.todayScrollView.frame.size.width,
                                                                                 self.todayScrollView.frame.size.width/16*9)];
        moduleImage.clipsToBounds = YES;
        moduleImage.userInteractionEnabled = YES;
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.todayScrollView addSubview:moduleImage];
        
        [NetWorkTask setImageView:moduleImage WithURL:bannerObj.coverPic placeholderImage:nil];

        /*遮罩*/
        UIView *overView = [[UIView alloc] initWithFrame:CGRectMake(self.todayScrollView.frame.size.width*i,
                                                                    CGRectGetMaxY(descLab.frame) + 20*Proportion,
                                                                    self.todayScrollView.frame.size.width,
                                                                    self.todayScrollView.frame.size.width/16*9)];
        overView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
        overView.userInteractionEnabled = YES;
        [self.todayScrollView addSubview:overView];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                   0,
                                                                   WIDTH,
                                                                   WIDTH/16*9)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [self.todayScrollView addSubview:btn];
        [btn addTarget:self action:@selector(selectTodayIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
    

    UIView *pageControlView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 635*Proportion/2.0,
                                                                       CGRectGetMaxY(self.todayScrollView.frame) - 42*Proportion - 6*Proportion,
                                                                       635*Proportion,
                                                                       6*Proportion)];
    pageControlView.layer.cornerRadius = 6*Proportion/2.0;
    pageControlView.backgroundColor = [[UIColor CMLSerachLineGrayColor] colorWithAlphaComponent:0.5];
    [self addSubview:pageControlView];
    
    self.scrollLineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   635*Proportion/self.todayFocusNarray.count,
                                                                   6*Proportion)];
    self.scrollLineView.backgroundColor = [UIColor CMLScrollLineWhiterColor];
    self.scrollLineView.layer.cornerRadius = 6*Proportion/2.0;
    [pageControlView addSubview:self.scrollLineView];
    
    if (self.todayFocusNarray.count < 2) {
        pageControlView.hidden = YES;
    }
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.todayScrollView.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:bottomView];
    
    UILabel *worldTitleLab = [[UILabel alloc] init];
    worldTitleLab.font = KSystemRealBoldFontSize18;
    worldTitleLab.text = @"全球动态";
    [worldTitleLab sizeToFit];
    worldTitleLab.frame = CGRectMake(WIDTH/2.0 - worldTitleLab.frame.size.width/2.0,
                                     60*Proportion + CGRectGetMaxY(bottomView.frame),
                                     worldTitleLab.frame.size.width,
                                     worldTitleLab.frame.size.height);
    [self addSubview:worldTitleLab];
    
    self.frame = CGRectMake(WIDTH/2.0 - worldTitleLab.frame.size.width/2.0,
                            CGRectGetMaxY(worldTitleLab.frame) + 40*Proportion,
                            WIDTH,
                            CGRectGetMaxY(worldTitleLab.frame) + 40*Proportion);
    
}

- (void) selectTodayIndex: (UIButton *) btn{
    
    
    CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.todayFocusNarray[btn.tag]];
    
    if ([bannerObj.rootTypeId intValue] == 2) {
       
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:bannerObj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:bannerObj.objId];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}

- (void) selectIndex:(UIButton *) btn{
    
    
    CMLBannerObj *bannerObj = [CMLBannerObj getBaseObjFrom:self.topScrollNarray[btn.tag]];

    if ([bannerObj.isCanPublish intValue] == 1) {
        
        if ([bannerObj.objType intValue] == 2) {
          
            CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([bannerObj.objType intValue] == 3){
            
            CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC]pushVC:vc animate:YES];
            
        }else if ([bannerObj.objType intValue] == 7){
            
            CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:bannerObj.objId];
            [[VCManger mainVC ] pushVC:vc animate:YES];
            
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
                //            InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:bannerObj.objId];
                //            [[VCManger mainVC] pushVC:vc animate:YES];
                
                
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
            
        }else if ([bannerObj.dataType intValue] == 6){
            
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:bannerObj.objId forKey:@"objId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:dic];
        }
        
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1) {
        
        self.currentPageControl.currentPage = (int)(self.worldScrollView.contentOffset.x/WIDTH);
    }else if (self.todayScrollView){
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.scrollLineView.frame = CGRectMake(self.todayScrollView.contentOffset.x/self.todayScrollView.frame.size.width*(635*Proportion/self.todayFocusNarray.count),
                                                       0,
                                                       self.scrollLineView.frame.size.width,
                                                       self.scrollLineView.frame.size.height);
        }];
    }
    
}

@end
