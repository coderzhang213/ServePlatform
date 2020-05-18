//
//  CMLRecommendOfDetailView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRecommendOfDetailView.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "ServeRecommedUserObj.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "RecommendInfo.h"
#import "DataManager.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"
#import <AVFoundation/AVFoundation.h>
#import "ZXYCircleProgress.h"

@interface CMLRecommendOfDetailView()

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIScrollView *detailMesBgView;

@property (nonatomic,strong) NSNumber *isUserRecommStatus;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) NSTimer *currentTimer;

@property (nonatomic,assign) int currentSecond;

@property (nonatomic,assign) int totalTime;

@property (nonatomic,strong) ZXYCircleProgress *circleProgress;;

@end

@implementation CMLRecommendOfDetailView

- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        
        self.obj = obj;
        self.isUserRecommStatus = self.obj.retData.isUserRecommStatus;
        self.backgroundColor = [[UIColor CMLNewGrayColor] colorWithAlphaComponent:0.5];
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    UILabel *promlab = [[UILabel alloc] init];
    promlab.font = KSystemBoldFontSize13;
    promlab.textColor = [UIColor CMLBrownColor];
    promlab.text = @"推荐人";
    [promlab sizeToFit];
    promlab.frame = CGRectMake(WIDTH/2.0 - promlab.frame.size.width/2.0,
                               50*Proportion,
                               promlab.frame.size.width,
                               promlab.frame.size.height);
    [self addSubview:promlab];
    
    UIView *leftView  = [[UIView alloc] initWithFrame:CGRectMake(promlab.frame.origin.x - 20*Proportion - 10*Proportion,
                                                                 promlab.center.y - 10*Proportion/2.0,
                                                                 10*Proportion,
                                                                 10*Proportion)];
    leftView.layer.borderWidth = 1*Proportion;
    leftView.layer.cornerRadius = 10*Proportion/2.0;
    leftView.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    [self addSubview:leftView];
    
    UIView *rightView  = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(promlab.frame) + 20*Proportion ,
                                                                 promlab.center.y - 10*Proportion/2.0,
                                                                 10*Proportion,
                                                                 10*Proportion)];
    rightView.layer.borderWidth = 1*Proportion;
    rightView.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    rightView.layer.cornerRadius = 10*Proportion/2.0;
    [self addSubview:rightView];
    
    
    
    self.detailMesBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(promlab.frame),
                                                                          WIDTH,
                                                                          0)];
    self.detailMesBgView.backgroundColor = [UIColor clearColor];
    self.detailMesBgView.showsVerticalScrollIndicator = NO;
    self.detailMesBgView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.detailMesBgView];
    
    [self loadMessageDetailView];
    

}

- (void) loadMessageDetailView{
    
    [self.detailMesBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ( self.obj.retData.recommendInfo.dataList.count == 0) {
        
        UIImageView *pushView = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                    30*Proportion,
                                                                    WIDTH - 30*Proportion*2,
                                                                    0)];
        pushView.layer.shadowOffset = CGSizeMake(0, 0);
        pushView.layer.shadowOpacity = 0.05;
        pushView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
        pushView.backgroundColor = [UIColor clearColor];
        pushView.userInteractionEnabled = YES;
        pushView.image = [UIImage imageNamed:FristRecommendBgImg];
        pushView.contentMode = UIViewContentModeScaleAspectFill;
        [self.detailMesBgView addSubview:pushView];
        
        UILabel *promLabOne = [[UILabel alloc] init];
        promLabOne.textColor = [UIColor CMLBlackColor];
        promLabOne.font = KSystemFontSize12;
        promLabOne.textAlignment = NSTextAlignmentCenter;
        promLabOne.numberOfLines = 0;
        promLabOne.text = @"好的商品需要让更多人知道，你的推荐可以帮助其他买家参考，快来推荐吧！";
        CGRect currentRect =  [promLabOne.text boundingRectWithSize:CGSizeMake(pushView.frame.size.width - 50*Proportion*2, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                            context:nil];
        promLabOne.frame = CGRectMake(50*Proportion,
                                      50*Proportion,
                                      pushView.frame.size.width - 50*Proportion*2,
                                      currentRect.size.height);
        [pushView addSubview:promLabOne];
        
        UILabel *promLabTwo  = [[UILabel alloc] init];
        promLabTwo.textColor = [UIColor CMLGreeenColor];
        promLabTwo.font = KSystemFontSize13;
        promLabTwo.text = @"发布第一条推荐";
        [promLabTwo sizeToFit];
        promLabTwo.frame = CGRectMake(pushView.frame.size.width/2.0 - promLabTwo.frame.size.width/2.0,
                                      CGRectGetMaxY(promLabOne.frame) + 50*Proportion,
                                      promLabTwo.frame.size.width,
                                      promLabTwo.frame.size.height);
        [pushView addSubview:promLabTwo];
        
        UIImageView *promImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FristRecommendpromImg]];
        promImage.contentMode = UIViewContentModeScaleAspectFill;
        [promImage sizeToFit];
        promImage.frame = CGRectMake(CGRectGetMaxX(promLabTwo.frame) + 5*Proportion,
                                     promLabTwo.center.y - promImage.frame.size.height/2.0,
                                     promImage.frame.size.width,
                                     promImage.frame.size.height);
        [pushView addSubview:promImage];
        pushView.frame = CGRectMake(pushView.frame.origin.x,
                                    pushView.frame.origin.y,
                                    pushView.frame.size.width,
                                    CGRectGetMaxY(promLabTwo.frame) + 50*Proportion);
        
        
        self.detailMesBgView.frame = CGRectMake(self.detailMesBgView.frame.origin.x,
                                                self.detailMesBgView.frame.origin.y,
                                                self.detailMesBgView.frame.size.width,
                                                CGRectGetMaxY(pushView.frame) + 40*Proportion);
        
        self.currentHeight = CGRectGetMaxY(self.detailMesBgView.frame);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:pushView.bounds];
        btn.backgroundColor = [UIColor clearColor];
        [pushView addSubview:btn];
        [btn addTarget:self action:@selector(psuhFirstRecommend) forControlEvents:UIControlEventTouchUpInside];
        
      
    }else{
        
        for (int i = 0; i < self.obj.retData.recommendInfo.dataList.count; i++) {

            UIImageView *pushView = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion + (30*Proportion + 640*Proportion)*i,
                                                                             30*Proportion,
                                                                             640*Proportion,
                                                                             360*Proportion)];
            pushView.layer.shadowOffset = CGSizeMake(0, 0);
            pushView.layer.shadowOpacity = 0.05;
            pushView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
            pushView.backgroundColor = [UIColor clearColor];
            pushView.userInteractionEnabled = YES;
            pushView.image = [UIImage imageNamed:RecommendBgImg];
            pushView.contentMode = UIViewContentModeScaleAspectFill;
            [self.detailMesBgView addSubview:pushView];
            
            ServeRecommedUserObj *tempObj = [ServeRecommedUserObj getBaseObjFrom:self.obj.retData.recommendInfo.dataList[i]];
            
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(pushView.frame.size.width/2.0 - 80*Proportion/2.0,
                                                                                   30*Proportion,
                                                                                   80*Proportion,
                                                                                   80*Proportion)];
            userImage.backgroundColor = [UIColor CMLNewGrayColor];
            userImage.layer.cornerRadius = 80*Proportion/2.0;
            userImage.clipsToBounds = YES;
            userImage.userInteractionEnabled = YES;
            [pushView addSubview:userImage];
            [NetWorkTask setImageView:userImage WithURL:tempObj.gravatar placeholderImage:nil];
            
            UIButton * btn = [[UIButton alloc] initWithFrame:userImage.bounds];
            btn.backgroundColor = [UIColor clearColor];
            [userImage addSubview:btn];
            btn.tag = [tempObj.userId intValue];
            [btn addTarget:self action:@selector(enterUserMes:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *userNickName = [[UILabel alloc] init];
            userNickName.font = KSystemRealBoldFontSize14;
            userNickName.textColor = [UIColor CMLBlackColor];
            userNickName.text = tempObj.nickName;
            [userNickName sizeToFit];
            userNickName.frame = CGRectMake(pushView.frame.size.width/2.0 - userNickName.frame.size.width/2.0,
                                            CGRectGetMaxY(userImage.frame) + 20*Proportion,
                                            userNickName.frame.size.width,
                                            userNickName.frame.size.height);
            [pushView addSubview:userNickName];
            
            UILabel *signatureLab = [[UILabel alloc] init];
            signatureLab.font = KSystemFontSize12;
            signatureLab.textColor = [UIColor CMLtextInputGrayColor];
            signatureLab.text = tempObj.signature;
            signatureLab.textAlignment = NSTextAlignmentCenter;
            [signatureLab sizeToFit];
            signatureLab.frame = CGRectMake(50*Proportion,
                                            CGRectGetMaxY(userNickName.frame) + 10*Proportion,
                                            pushView.frame.size.width - 50*Proportion*2,
                                            signatureLab.frame.size.height);
            [pushView addSubview:signatureLab];
            
            UILabel *recommendDetailLab = [[UILabel alloc] init];
            recommendDetailLab.textColor = [UIColor CMLBlackColor];
            recommendDetailLab.font = KSystemFontSize13;
            recommendDetailLab.textAlignment = NSTextAlignmentCenter;
            recommendDetailLab.numberOfLines = 3;
            recommendDetailLab.text = @"test";
            [recommendDetailLab sizeToFit];
            recommendDetailLab.frame = CGRectMake(50*Proportion,
                                                  CGRectGetMaxY(signatureLab.frame) + 30*Proportion,
                                                  pushView.frame.size.width - 50*Proportion*2,
                                                  recommendDetailLab.frame.size.height*3);
            recommendDetailLab.text = tempObj.recommDetail;
            [pushView addSubview:recommendDetailLab];
            
            if (tempObj.videoUrl.length > 0) {
                
                UIButton *userVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(pushView.frame.size.width - 44*Proportion - 60*Proportion,
                                                                                    userNickName.center.y - 44*Proportion/2.0,
                                                                                    44*Proportion,
                                                                                    44*Proportion)];
                [userVideoBtn setBackgroundImage:[UIImage imageNamed:RecommendUserVideoImg] forState:UIControlStateNormal];
                userVideoBtn.tag = i;
                [pushView addSubview:userVideoBtn];
                [userVideoBtn addTarget:self action:@selector(showVideo:) forControlEvents:UIControlEventTouchUpInside];
            }


            
            if (i == self.obj.retData.recommendInfo.dataList.count - 1) {
                
                UIImageView *pushRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                           30*Proportion,
                                                                                           300*Proportion,
                                                                                           165*Proportion)];
                pushRecommend.backgroundColor = [UIColor clearColor];
                pushRecommend.image = [UIImage imageNamed:PushRecommendImg];
                pushRecommend.contentMode = UIViewContentModeScaleAspectFill;
                pushRecommend.userInteractionEnabled = YES;
                [self.detailMesBgView addSubview:pushRecommend];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:pushRecommend.bounds];
                btn.backgroundColor = [UIColor clearColor];
                [pushRecommend addSubview:btn];
                [btn addTarget:self action:@selector(psuhFirstRecommend) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *allRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                          CGRectGetMaxY(pushView.frame) - 165*Proportion,
                                                                                          300*Proportion,
                                                                                          165*Proportion)];
                allRecommend.backgroundColor = [UIColor clearColor];
                allRecommend.userInteractionEnabled = YES;
                allRecommend.contentMode = UIViewContentModeScaleAspectFill;
                allRecommend.image = [UIImage imageNamed:RecommendAllImg];
                [self.detailMesBgView addSubview:allRecommend];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:allRecommend.bounds];
                btn2.backgroundColor = [UIColor clearColor];
                [allRecommend addSubview:btn2];
                [btn2 addTarget:self action:@selector(enterAllRecommend) forControlEvents:UIControlEventTouchUpInside];
                
                self.detailMesBgView.frame = CGRectMake(self.detailMesBgView.frame.origin.x,
                                                        self.detailMesBgView.frame.origin.y,
                                                        self.detailMesBgView.frame.size.width,
                                                        CGRectGetMaxY(pushView.frame) + 40*Proportion);
                
                self.detailMesBgView.contentSize = CGSizeMake(CGRectGetMaxX(pushRecommend.frame) + 30*Proportion, self.detailMesBgView.frame.size.height);
                
                self.currentHeight = CGRectGetMaxY(self.detailMesBgView.frame);
                
            }

        }
    }
}

- (void) psuhFirstRecommend{
    
    if ([self.isUserRecommStatus intValue] == 2) {
        [self.delegate showWriteView];
    }else{
        
        [self.delegate showFailMessage:@"不能重复推荐"];
    }
    
}
- (void) refreshCurrentRecommendView:(NSString *) mes{
    
    self.isUserRecommStatus = [NSNumber numberWithInt:1];
    
    [self.detailMesBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.detailMesBgView.contentOffset = CGPointMake(0, 0);
    
    if ( self.obj.retData.recommendInfo.dataList.count == 0) {
            
            UIImageView *pushView = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion ,
                                                                                  30*Proportion,
                                                                                  640*Proportion,
                                                                                  360*Proportion)];
            pushView.layer.shadowOffset = CGSizeMake(0, 0);
            pushView.layer.shadowOpacity = 0.05;
            pushView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
            pushView.backgroundColor = [UIColor clearColor];
            pushView.userInteractionEnabled = YES;
            pushView.image = [UIImage imageNamed:RecommendBgImg];
            pushView.contentMode = UIViewContentModeScaleAspectFill;
            [self.detailMesBgView addSubview:pushView];
            
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(pushView.frame.size.width/2.0 - 80*Proportion/2.0,
                                                                                   30*Proportion,
                                                                                   80*Proportion,
                                                                                   80*Proportion)];
            userImage.backgroundColor = [UIColor CMLNewGrayColor];
            userImage.layer.cornerRadius = 80*Proportion/2.0;
            userImage.clipsToBounds = YES;
            [pushView addSubview:userImage];
            [NetWorkTask setImageView:userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
            
            UILabel *userNickName = [[UILabel alloc] init];
            userNickName.font = KSystemRealBoldFontSize14;
            userNickName.textColor = [UIColor CMLBlackColor];
            userNickName.text = [[DataManager lightData] readNickName];
            [userNickName sizeToFit];
            userNickName.frame = CGRectMake(pushView.frame.size.width/2.0 - userNickName.frame.size.width/2.0,
                                            CGRectGetMaxY(userImage.frame) + 20*Proportion,
                                            userNickName.frame.size.width,
                                            userNickName.frame.size.height);
            [pushView addSubview:userNickName];
            
            UILabel *signatureLab = [[UILabel alloc] init];
            signatureLab.font = KSystemFontSize12;
            signatureLab.textColor = [UIColor CMLtextInputGrayColor];
            signatureLab.text = [[DataManager lightData] readSignature];
            signatureLab.textAlignment = NSTextAlignmentCenter;
            [signatureLab sizeToFit];
            signatureLab.frame = CGRectMake(50*Proportion,
                                            CGRectGetMaxY(userNickName.frame) + 10*Proportion,
                                            pushView.frame.size.width - 50*Proportion*2,
                                            signatureLab.frame.size.height);
            [pushView addSubview:signatureLab];
            
            UILabel *recommendDetailLab = [[UILabel alloc] init];
            recommendDetailLab.textColor = [UIColor CMLBlackColor];
            recommendDetailLab.font = KSystemFontSize13;
            recommendDetailLab.textAlignment = NSTextAlignmentCenter;
            recommendDetailLab.numberOfLines = 3;
            recommendDetailLab.text = @"test";
            [recommendDetailLab sizeToFit];
            recommendDetailLab.frame = CGRectMake(50*Proportion,
                                                  CGRectGetMaxY(signatureLab.frame) + 30*Proportion,
                                                  pushView.frame.size.width - 50*Proportion*2,
                                                  recommendDetailLab.frame.size.height*3);
            recommendDetailLab.text = mes;
            [pushView addSubview:recommendDetailLab];
                
            UIImageView *pushRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                       30*Proportion,
                                                                                       300*Proportion,
                                                                                       165*Proportion)];
            pushRecommend.backgroundColor = [UIColor clearColor];
            pushRecommend.userInteractionEnabled = YES;
            pushRecommend.image = [UIImage imageNamed:PushRecommendImg];
            [self.detailMesBgView addSubview:pushRecommend];
            pushRecommend.contentMode = UIViewContentModeScaleAspectFill;
        
            UIButton *btn = [[UIButton alloc] initWithFrame:pushRecommend.bounds];
            btn.backgroundColor = [UIColor clearColor];
            [pushRecommend addSubview:btn];
            [btn addTarget:self action:@selector(psuhFirstRecommend) forControlEvents:UIControlEventTouchUpInside];
        
            UIImageView *allRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                      CGRectGetMaxY(pushView.frame) - 165*Proportion,
                                                                                      300*Proportion,
                                                                                      165*Proportion)];
            allRecommend.backgroundColor = [UIColor clearColor];
            allRecommend.userInteractionEnabled = YES;
            allRecommend.image = [UIImage imageNamed:RecommendAllImg];
            allRecommend.contentMode = UIViewContentModeScaleAspectFill;
            [self.detailMesBgView addSubview:allRecommend];
        
            UIButton *btn2 = [[UIButton alloc] initWithFrame:allRecommend.bounds];
            btn2.backgroundColor = [UIColor clearColor];
            [allRecommend addSubview:btn2];
            [btn2 addTarget:self action:@selector(enterAllRecommend) forControlEvents:UIControlEventTouchUpInside];
        
            self.detailMesBgView.frame = CGRectMake(self.detailMesBgView.frame.origin.x,
                                                    self.detailMesBgView.frame.origin.y,
                                                    self.detailMesBgView.frame.size.width,
                                                    CGRectGetMaxY(pushView.frame) + 40*Proportion);
        
            self.detailMesBgView.contentSize = CGSizeMake(CGRectGetMaxX(pushRecommend.frame) + 30*Proportion, self.detailMesBgView.frame.size.height);
        
            self.currentHeight = CGRectGetMaxY(self.detailMesBgView.frame);
       
            
    }else{
        
        for (int i = 0; i <= self.obj.retData.recommendInfo.dataList.count; i++) {
            
            UIImageView *pushView = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion + (30*Proportion + 640*Proportion)*i,
                                                                                  30*Proportion,
                                                                                  640*Proportion,
                                                                                  360*Proportion)];
            pushView.layer.shadowOffset = CGSizeMake(0, 0);
            pushView.layer.shadowOpacity = 0.05;
            pushView.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
            pushView.backgroundColor = [UIColor CMLWhiteColor];
            pushView.userInteractionEnabled = YES;
            pushView.backgroundColor = [UIColor clearColor];
            pushView.image = [UIImage imageNamed:RecommendBgImg];
            pushView.contentMode = UIViewContentModeScaleAspectFill;
            [self.detailMesBgView addSubview:pushView];
            
            ServeRecommedUserObj *tempObj;
            
            if (i != 0) {
                
                tempObj = [ServeRecommedUserObj getBaseObjFrom:self.obj.retData.recommendInfo.dataList[i - 1]];
                
                if (tempObj.videoUrl.length > 0) {
                    
                    UIButton *userVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(pushView.frame.size.width - 44*Proportion - 60*Proportion,
                                                                                        pushView.frame.size.height/2.0 - 44*Proportion/2.0,
                                                                                        44*Proportion,
                                                                                        44*Proportion)];
                    [userVideoBtn setBackgroundImage:[UIImage imageNamed:RecommendUserVideoImg] forState:UIControlStateNormal];
                    userVideoBtn.tag = i - 1;
                    [pushView addSubview:userVideoBtn];
                    [userVideoBtn addTarget:self action:@selector(showVideo:) forControlEvents:UIControlEventTouchUpInside];
                }

                
            }
            
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(pushView.frame.size.width/2.0 - 80*Proportion/2.0,
                                                                                   30*Proportion,
                                                                                   80*Proportion,
                                                                                   80*Proportion)];
            userImage.backgroundColor = [UIColor CMLNewGrayColor];
            userImage.layer.cornerRadius = 80*Proportion/2.0;
            userImage.clipsToBounds = YES;
            userImage.userInteractionEnabled = YES;
            [pushView addSubview:userImage];
            UIButton * btn = [[UIButton alloc] initWithFrame:userImage.bounds];
            btn.backgroundColor = [UIColor clearColor];
            [userImage addSubview:btn];
            if (i != 0) {
                btn.tag = [tempObj.userId intValue];
                
            }else{
                btn.tag = [[[DataManager lightData] readUserID] intValue];
               
            }
            [btn addTarget:self action:@selector(enterUserMes:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0 ) {
                [NetWorkTask setImageView:userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
            }else{
             
                [NetWorkTask setImageView:userImage WithURL:tempObj.gravatar placeholderImage:nil];
            }
            
            
            UILabel *userNickName = [[UILabel alloc] init];
            userNickName.font = KSystemRealBoldFontSize14;
            userNickName.textColor = [UIColor CMLBlackColor];
            
            if (i == 0) {
                
                userNickName.text = [[DataManager lightData] readNickName];
            }else{
                
                userNickName.text = tempObj.nickName;
            }
            [userNickName sizeToFit];
            userNickName.frame = CGRectMake(pushView.frame.size.width/2.0 - userNickName.frame.size.width/2.0,
                                            CGRectGetMaxY(userImage.frame) + 20*Proportion,
                                            userNickName.frame.size.width,
                                            userNickName.frame.size.height);
            [pushView addSubview:userNickName];
            
            if (i != 0) {
                if (tempObj.videoUrl.length > 0) {
                    
                    UIButton *userVideoBtn = [[UIButton alloc] init];
                    [userVideoBtn setBackgroundImage:[UIImage imageNamed:RecommendUserVideoImg] forState:UIControlStateNormal];
                    userVideoBtn.tag = i - 1;
                    [userVideoBtn sizeToFit];
                    userVideoBtn.frame = CGRectMake(pushView.frame.size.width - 70*Proportion - 60*Proportion,
                                                    userNickName.center.y - 70*Proportion/2.0,
                                                    70*Proportion,
                                                    70*Proportion);
                    [pushView addSubview:userVideoBtn];
                    [userVideoBtn addTarget:self action:@selector(showVideo:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
            }
            
            UILabel *signatureLab = [[UILabel alloc] init];
            signatureLab.font = KSystemFontSize12;
            signatureLab.textColor = [UIColor CMLtextInputGrayColor];
            
            if (i == 0) {
                
                signatureLab.text = [[DataManager lightData] readSignature];
            }else{
                
                signatureLab.text = tempObj.signature;
            }
            
            signatureLab.textAlignment = NSTextAlignmentCenter;
            [signatureLab sizeToFit];
            signatureLab.frame = CGRectMake(50*Proportion,
                                            CGRectGetMaxY(userNickName.frame) + 10*Proportion,
                                            pushView.frame.size.width - 50*Proportion*2,
                                            signatureLab.frame.size.height);
            [pushView addSubview:signatureLab];
            
            UILabel *recommendDetailLab = [[UILabel alloc] init];
            recommendDetailLab.textColor = [UIColor CMLBlackColor];
            recommendDetailLab.font = KSystemFontSize13;
            recommendDetailLab.textAlignment = NSTextAlignmentCenter;
            recommendDetailLab.numberOfLines = 3;
            recommendDetailLab.text = @"test";
            
            [recommendDetailLab sizeToFit];
            recommendDetailLab.frame = CGRectMake(50*Proportion,
                                                  CGRectGetMaxY(signatureLab.frame) + 30*Proportion,
                                                  pushView.frame.size.width - 50*Proportion*2,
                                                  recommendDetailLab.frame.size.height*3);
            
            if (i == 0) {
                
                recommendDetailLab.text = mes;
            }else{
                
                recommendDetailLab.text = tempObj.recommDetail;
            }
            
            [pushView addSubview:recommendDetailLab];
            
            
            
            if (i == self.obj.retData.recommendInfo.dataList.count) {
                
                UIImageView *pushRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                           30*Proportion,
                                                                                           300*Proportion,
                                                                                           165*Proportion)];
                pushRecommend.backgroundColor = [UIColor clearColor];
                pushRecommend.image = [UIImage imageNamed:PushRecommendImg];
                pushRecommend.userInteractionEnabled = YES;
                pushRecommend.contentMode = UIViewContentModeScaleAspectFill;
                [self.detailMesBgView addSubview:pushRecommend];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:pushRecommend.bounds];
                btn.backgroundColor = [UIColor clearColor];
                [pushRecommend addSubview:btn];
                [btn addTarget:self action:@selector(psuhFirstRecommend) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *allRecommend = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pushView.frame) + 30*Proportion,
                                                                                          CGRectGetMaxY(pushView.frame) - 165*Proportion,
                                                                                          300*Proportion,
                                                                                          165*Proportion)];
                allRecommend.backgroundColor = [UIColor clearColor];
                allRecommend.userInteractionEnabled = YES;
                allRecommend.image = [UIImage imageNamed:RecommendAllImg];
                allRecommend.contentMode = UIViewContentModeScaleAspectFill;
                [self.detailMesBgView addSubview:allRecommend];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:allRecommend.bounds];
                btn2.backgroundColor = [UIColor clearColor];
                [allRecommend addSubview:btn2];
                [btn2 addTarget:self action:@selector(enterAllRecommend) forControlEvents:UIControlEventTouchUpInside];
                
                self.detailMesBgView.frame = CGRectMake(self.detailMesBgView.frame.origin.x,
                                                        self.detailMesBgView.frame.origin.y,
                                                        self.detailMesBgView.frame.size.width,
                                                        CGRectGetMaxY(pushView.frame) + 40*Proportion);
                
                self.detailMesBgView.contentSize = CGSizeMake(CGRectGetMaxX(pushRecommend.frame) + 30*Proportion, self.detailMesBgView.frame.size.height);
                
                self.currentHeight = CGRectGetMaxY(self.detailMesBgView.frame);
                
            }
        }
    }
}

- (void) enterAllRecommend{
    
    [self.delegate enterRecommendVC];
}

- (void) enterUserMes:(UIButton *) btn{
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:@""
//                                                          currnetUserId:[NSNumber numberWithInteger:btn.tag]
//                                                     isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) showVideo:(UIButton *) btn{
    
    ServeRecommedUserObj *tempObj = [ServeRecommedUserObj getBaseObjFrom:self.obj.retData.recommendInfo.dataList[btn.tag]];
    
    NSURL * url  = [NSURL URLWithString:tempObj.videoUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.totalTime = (int)CMTimeGetSeconds(songItem.asset.duration);
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [self.player play];
    
    [self.circleProgress removeFromSuperview];
    self.circleProgress = [[ZXYCircleProgress alloc] initWithFrame:CGRectMake(btn.frame.origin.x - 2.5*Proportion,
                                                                              btn.frame.origin.y - 2.55*Proportion,btn.frame.size.width + 5*Proportion,
                                                                              btn.frame.size.height + 5*Proportion)
                                                          progress:0];
    self.circleProgress.progressWidth = 2.5*Proportion;
    self.circleProgress.bottomColor = [UIColor clearColor];
    self.circleProgress.topColor = [UIColor CMLBrownColor];
    [btn.superview addSubview:_circleProgress];
//    [btn.superview sendSubviewToBack:self.circleProgress];
    
    [self addNotification];
    
    self.currentSecond = 0;
    self.currentTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshSilder) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimer forMode:NSDefaultRunLoopMode];

}

- (void) refreshSilder{
    
    self.currentSecond ++;
    self.circleProgress.progress = (float)self.currentSecond / self.totalTime;
    
}
- (void) stopVideo{
    
    if (self.player) {

         [self.player pause];
        self.circleProgress.progress = 1;
        [self.currentTimer invalidate];
        self.currentTimer = nil;
        [self.circleProgress removeFromSuperview];
    }
}


- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

// 播放完成通知
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    self.circleProgress.progress = 1;
    [self.currentTimer invalidate];
    self.currentTimer = nil;
    [self.circleProgress removeFromSuperview];
    
}

@end
