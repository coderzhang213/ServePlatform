//
//  PrefectureRecommendView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "PrefectureRecommendView.h"
#import "CommonFont.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "UIColor+SDExspand.h"
#import "AdLeftInfo.h"
#import "AdRightInfo.h"
#import "AdDetailInfoObj.h"
#import "NetWorkTask.h"
#import "WebViewLinkVC.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLAllImagesVC.h"
#import "CMLSpecialTopicVC.h"
#import "CMLPrefectureVC.h"
#import "CMLCommodityDetailMessageVC.h"

#define LeftMargin       30
#define TopMargin        40
#define FirstBtnHeigth   290
#define FirstBtnWidth    400
#define OtherBtnWidth    280
#define BottomMargin     40
#define BottomViewHeight 20


@interface PrefectureRecommendView ()

@property (nonatomic,strong) UIButton *firstBtn;

@property (nonatomic,strong) UIButton *secondBtn;

@property (nonatomic,strong) UIButton *thirdBtn;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation PrefectureRecommendView

- (instancetype)initWithObj:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
        self.obj = obj;
        self.backgroundColor = [UIColor CMLWhiteColor];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
   
    if (self.obj.retData.zoneAdInfoModule.dataList.count > 0) {
     
        CMLLine *line = [[CMLLine alloc] init];
        line.startingPoint = CGPointMake(LeftMargin*Proportion, TopMargin*Proportion);
        line.lineLength = WIDTH - LeftMargin*Proportion*2;
        line.lineWidth = 1;
        line.LineColor = [UIColor CMLNewGrayColor];
        [self addSubview:line];
        
        UIImageView *firstImg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                              TopMargin*Proportion*2,
                                                                              FirstBtnWidth*Proportion,
                                                                              FirstBtnHeigth*Proportion)];
        firstImg.contentMode = UIViewContentModeScaleAspectFill;
        firstImg.backgroundColor = [UIColor CMLPromptGrayColor];
        firstImg.clipsToBounds = YES;
        firstImg.layer.cornerRadius = 8*Proportion;
        firstImg.userInteractionEnabled = YES;
        [self addSubview:firstImg];
        AdDetailInfoObj *obj = [AdDetailInfoObj getBaseObjFrom:[self.obj.retData.zoneAdInfoModule.dataList firstObject]];
        [NetWorkTask setImageView:firstImg WithURL:obj.coverPic placeholderImage:nil];
        
        self.firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   TopMargin*Proportion*2,
                                                                   FirstBtnWidth*Proportion,
                                                                   FirstBtnHeigth*Proportion)];
        self.firstBtn.backgroundColor = [UIColor clearColor];
        self.firstBtn.layer.cornerRadius = 8*Proportion;
        [self addSubview:self.firstBtn];
        [self.firstBtn addTarget:self action:@selector(enterFirstModule) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *secondImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 10*Proportion,
                                                                               TopMargin*Proportion*2,
                                                                               OtherBtnWidth*Proportion,
                                                                               (FirstBtnHeigth - 10)*Proportion/2.0)];
        secondImg.contentMode = UIViewContentModeScaleAspectFill;
        secondImg.backgroundColor = [UIColor CMLPromptGrayColor];
        secondImg.clipsToBounds = YES;
        secondImg.layer.cornerRadius = 8*Proportion;
        secondImg.userInteractionEnabled = YES;
        [self addSubview:secondImg];
        AdDetailInfoObj *obj2 = [AdDetailInfoObj getBaseObjFrom:self.obj.retData.zoneAdInfoModule.dataList[1]];
        [NetWorkTask setImageView:secondImg WithURL:obj2.coverPic placeholderImage:nil];
        
        self.secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 10*Proportion,
                                                                    TopMargin*Proportion*2,
                                                                    OtherBtnWidth*Proportion,
                                                                    (FirstBtnHeigth - 10)*Proportion/2.0)];
        self.secondBtn.backgroundColor = [UIColor clearColor];
        self.secondBtn.layer.cornerRadius = 8*Proportion;
        [self addSubview:self.secondBtn];
        [self.secondBtn addTarget:self action:@selector(enterSecondModule) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *thirdImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 10*Proportion,
                                                                              CGRectGetMaxY(self.secondBtn.frame) + 10*Proportion,
                                                                              OtherBtnWidth*Proportion,
                                                                              (FirstBtnHeigth - 10)*Proportion/2.0)];
        thirdImg.contentMode = UIViewContentModeScaleAspectFill;
        thirdImg.backgroundColor = [UIColor CMLPromptGrayColor];
        thirdImg.clipsToBounds = YES;
        thirdImg.layer.cornerRadius = 8*Proportion;
        thirdImg.userInteractionEnabled = YES;
        [self addSubview:thirdImg];
        AdDetailInfoObj *obj3 = [AdDetailInfoObj getBaseObjFrom:[self.obj.retData.zoneAdInfoModule.dataList lastObject]];
        [NetWorkTask setImageView:thirdImg WithURL:obj3.coverPic placeholderImage:nil];
        
        self.thirdBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 10*Proportion,
                                                                   CGRectGetMaxY(self.secondBtn.frame) + 10*Proportion,
                                                                   OtherBtnWidth*Proportion,
                                                                   (FirstBtnHeigth - 10)*Proportion/2.0)];
        self.thirdBtn.backgroundColor = [UIColor clearColor];
        self.thirdBtn.layer.cornerRadius = 8*Proportion;
        [self addSubview:self.thirdBtn];
        [self.thirdBtn addTarget:self action:@selector(enterThirdModule) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.thirdBtn.frame) + BottomMargin*Proportion,
                                                                      WIDTH,
                                                                      BottomViewHeight*Proportion)];
        bottomView.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:bottomView];
        
        self.viewHeigth = CGRectGetMaxY(bottomView.frame);

    }else{
    
        self.viewHeigth = 0;
        self.hidden = YES;
    }
    
}

- (void) enterFirstModule{
    
    [MobClick event:@"RecommendLeftPosition"];
    
    AdDetailInfoObj *obj = [AdDetailInfoObj getBaseObjFrom:[self.obj.retData.zoneAdInfoModule.dataList firstObject]];
    
    [self selectAd:obj];
}

- (void) enterSecondModule{

    [MobClick event:@"RecommendRightTop"];
    
    AdDetailInfoObj *obj2 = [AdDetailInfoObj getBaseObjFrom:self.obj.retData.zoneAdInfoModule.dataList[1]];
    
    [self selectAd:obj2];
}

- (void) enterThirdModule{
    
    [MobClick event:@"RecommendRightBottom"];
    
    AdDetailInfoObj *obj3 = [AdDetailInfoObj getBaseObjFrom:[self.obj.retData.zoneAdInfoModule.dataList lastObject]];
    
    [self selectAd:obj3];
}

- (void) selectAd:(AdDetailInfoObj *) obj{
    
    

    if ([obj.dataType intValue] == 3) {
        
        /**外链*/
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = obj.viewLink;
        vc.name = obj.title;
        vc.shareUrl = obj.shareUrl;
        vc.isShare = obj.shareStatus;
        vc.desc = obj.desc;
        if (obj.shareImg) {
            
           vc.imageUrl = obj.shareImg;
        }else{
        
            vc.imageUrl = obj.coverPic;
        }
        
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([obj.dataType intValue] == 1){
        
        if([obj.objType intValue] == 1){
            
            /**咨询*/
            InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
            
        }else if([obj.objType intValue] == 2){
            
            /**活动详情*/
            ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([obj.objType intValue] == 3){
            
            /**服务详情*/
            ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([obj.objType intValue] == 4){
            
            /**相册*/
            CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:obj.objId ImageName:@""];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([obj.objType intValue] == 7){
            
            /**商品*/
            CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
    }else if ([obj.dataType intValue] == 2){
        
        /**专题*/
        CMLSpecialTopicVC *vc = [[CMLSpecialTopicVC alloc] initWithImageUrl:obj.coverPic
                                                                       name:obj.title
                                                                 shortTitle:obj.title
                                                                       desc:obj.desc
                                                                   viewLink:obj.viewLink
                                                                  currentId:obj.objId];
        
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([obj.dataType intValue] == 4){
        
        CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
}
@end
