//
//  CMLNewVIPTopView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewVIPTopView.h"
#import "CMLWriteVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "DataManager.h"
#import "NetWorkTask.h"
#import "CMLVIPNewDetailVC.h"
#import "CMLWriteVC.h"
#import "VCManger.h"
#import "CMLWriteTypeSelectView.h"


#define TopViewHeight                100
#define PersonalImageHeightAndWidth  50
#define PersonalImageLeftMargin      20
#define personalImageAndTitleSpace   20

@interface CMLNewVIPTopView ()

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UIImageView *btnImage;

@property (nonatomic,strong) UIButton *writeBtn;


@end

@implementation CMLNewVIPTopView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = [UIColor CMLWhiteColor];
        
    }
    
    return self;
}

- (void)layoutSubviews{
   
     
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(PersonalImageLeftMargin*Proportion,
                                                                       (80 - PersonalImageHeightAndWidth)*Proportion/2.0 + 20*Proportion,
                                                                       PersonalImageHeightAndWidth*Proportion,
                                                                       PersonalImageHeightAndWidth*Proportion)];
        self.userImage.clipsToBounds = YES;
        self.userImage.contentMode = UIViewContentModeScaleAspectFill;
        self.userImage.userInteractionEnabled = YES;
        self.userImage.layer.cornerRadius = PersonalImageHeightAndWidth*Proportion/2.0;
        self.userImage.backgroundColor = [UIColor CMLPromptGrayColor];
        [self addSubview:self.userImage];
        [NetWorkTask setImageView:self.userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
        
        
        UIButton *personalBtn = [[UIButton alloc] init];
        personalBtn.backgroundColor = [UIColor clearColor];
        personalBtn.frame = CGRectMake(0,
                                       0,
                                       TopViewHeight*Proportion,
                                       TopViewHeight*Proportion);
        [self addSubview:personalBtn];
        [personalBtn addTarget:self action:@selector(enterPersonalVIPMainView) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPushTimeLineImg]];
    [self.btnImage sizeToFit];
    self.btnImage.frame = CGRectMake(WIDTH - PersonalImageLeftMargin*Proportion - PersonalImageHeightAndWidth*Proportion,
                                     80*Proportion/2.0 - 39*Proportion/2.0 + 20*Proportion,
                                     39*Proportion,
                                     39*Proportion);
    [self addSubview:self.btnImage];
    self.btnImage.userInteractionEnabled = YES;
    
    self.writeBtn = [[UIButton alloc] init];
    self.writeBtn.frame = CGRectMake(WIDTH - TopViewHeight*Proportion,
                                     0,
                                     TopViewHeight*Proportion,
                                     TopViewHeight*Proportion);
    [self addSubview:self.writeBtn];
    [self.writeBtn addTarget:self action:@selector(enterWirteView) forControlEvents:UIControlEventTouchUpInside];
    
     if ([[[DataManager lightData] readUserLevel] intValue] == 1 || [[[DataManager lightData] readDistributionLevelStatus] intValue] == 2) {
    
         self.btnImage.hidden = YES;
         self.writeBtn.hidden = YES;
    }
    
    UILabel *topLab = [[UILabel alloc] init];
    topLab.font = KSystemBoldFontSize16;
    topLab.text = @"花伴";
    topLab.textColor = [UIColor CMLBlackColor];
    [topLab sizeToFit];
    topLab.frame = CGRectMake(WIDTH/2.0 - topLab.frame.size.width/2.0,
                              80*Proportion/2.0 - topLab.frame.size.height/2.0 + 20*Proportion,
                              topLab.frame.size.width,
                              topLab.frame.size.height);
    [self addSubview:topLab];

}

- (void) refreshUserImage{
    
    if ([[[DataManager lightData] readUserLevel] intValue] == 1 || [[[DataManager lightData] readDistributionLevelStatus] intValue] == 2) {
        
        self.btnImage.hidden = YES;
        self.writeBtn.hidden = YES;
        
    }else{
        
        self.btnImage.hidden = NO;
        self.writeBtn.hidden = NO;
    }

    [NetWorkTask setImageView:self.userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
    
    
}

#pragma mark - enterPersonalVIPMainView
- (void) enterPersonalVIPMainView{
    
    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:[[DataManager lightData] readNickName]
                                                          currnetUserId:[[DataManager lightData] readUserID] isReturnUpOneLevel:YES];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - enterWirteView
- (void) enterWirteView{
    
//    if ([[[DataManager lightData] readUserLevel] intValue] == 1) {
//
//        CMLWriteVC *vc = [[CMLWriteVC alloc] init];
//        [[VCManger mainVC] pushVC:vc animate:YES];
//
//
//    }else{

        CMLWriteTypeSelectView *view = [[CMLWriteTypeSelectView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
//    }

}

@end
