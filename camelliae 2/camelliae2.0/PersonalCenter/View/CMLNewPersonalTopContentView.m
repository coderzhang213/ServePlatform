//
//  CMLNewPersonalTopContentView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/8/13.
//  Copyright © 2018年 张越. All rights reserved.
//
/*CMLNewPersonalTopContentView-我的：设置、头像等、会员身份卡片*/

#import "CMLNewPersonalTopContentView.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "DataManager.h"
#import "NetWorkTask.h"
#import "CMLPersonCenterSettingVC.h"
#import "VCManger.h"
#import "NewPersonDetailInfoVC.h"
#import "UpGradeVC.h"
#import "CMLMessageViewController.h"
#import "NSString+CMLExspand.h"
#import "CMLNewPersonalMemberCardView.h"
#import "ScanHelper.h"
#import "CMLCodeScanViewController.h"

@interface CMLNewPersonalTopContentView()<CMLNewPersonalMemberCardViewDelegate>

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) UIImage *vImage;

@end

@implementation CMLNewPersonalTopContentView

- (instancetype)initWithObj:(BaseResultObj *)obj withCoverImage:(UIImage *)coverImage vImage:(UIImage *)vImage {
    
    self = [super init];
    
    if (self) {
        self.obj = obj;
        self.coverImage = coverImage;
        self.vImage = vImage;
        self.backgroundColor = [UIColor CMLNewCenterGrayColor];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    /*******************/
    /*右上消息按钮*/
    UIButton *messagebtn = [[UIButton alloc] init];
    messagebtn.backgroundColor = [UIColor clearColor];
    [messagebtn sizeToFit];
    [messagebtn setBackgroundImage:[UIImage imageNamed:PersonalCenterMessageImg] forState:UIControlStateNormal];

    if ([[[DataManager lightData] readBadgeNumber] intValue] > 0) {
        if ([NSString isSwitchAppNotification]) {
            [messagebtn setBackgroundImage:[UIImage imageNamed:PersonalCenterMessageStateImg] forState:UIControlStateNormal];
        }
    }
    messagebtn.frame = CGRectMake(WIDTH - 35*Proportion - 35*Proportion,
                                  34*Proportion + 20,
                                  42*Proportion,
                                  42*Proportion);
    [messagebtn addTarget:self action:@selector(enterMessageVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:messagebtn];
    
    /*右上设置按钮*/
    UIButton *settingbtn = [[UIButton alloc] init];
    settingbtn.backgroundColor = [UIColor clearColor];
    [settingbtn sizeToFit];
    [settingbtn setBackgroundImage:[UIImage imageNamed:PersonalCenterSettingImg] forState:UIControlStateNormal];
    settingbtn.frame = CGRectMake(WIDTH - 26*Proportion - 35*Proportion * 2 - 56* Proportion,
                                  38*Proportion + 20,
                                  35*Proportion,
                                  35*Proportion);
    [settingbtn addTarget:self action:@selector(enterSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingbtn];

    /*******************/
    
    /*头像外圈*/
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion ,
                                                              CGRectGetMaxY(settingbtn.frame) + 30*Proportion,
                                                              112*Proportion,
                                                              112*Proportion)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 112*Proportion/2.0;
    bgView.layer.shadowColor = [UIColor CMLNewYellowColor].CGColor;
    bgView.layer.shadowOpacity = 0.8;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:bgView];
    
    /*头像*/
    UIImageView *userImage = [[UIImageView alloc] init];
    userImage.frame = CGRectMake(30*Proportion,
                                 CGRectGetMaxY(settingbtn.frame) + 30*Proportion,
                                 112*Proportion,
                                 112*Proportion);
    userImage.clipsToBounds = YES;
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.layer.cornerRadius = 112*Proportion/2.0;
    userImage.layer.borderColor = [UIColor CMLNewYellowColor].CGColor;
    userImage.layer.borderWidth = 3*Proportion;
    userImage.userInteractionEnabled  = YES;
    [NetWorkTask setImageView:userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
    [self addSubview:userImage];
    UIButton *userBtn = [[UIButton alloc] initWithFrame:userImage.bounds];
    userBtn.backgroundColor = [UIColor clearColor];
    [userImage addSubview:userBtn];
    [userBtn addTarget:self action:@selector(enterEditVC) forControlEvents:UIControlEventTouchUpInside];
    

    /*昵称*/
    UILabel *userName = [[UILabel alloc] init];
    userName.text = [[DataManager lightData] readNickName];
    userName.font = KSystemBoldFontSize21;
    userName.backgroundColor = [UIColor clearColor];
    [userName sizeToFit];
    userName.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                userImage.center.y - userName.frame.size.height/2.0,
                                userName.frame.size.width,
                                userName.frame.size.height);
    [self addSubview:userName];
    
    /*身份卡片*/
    CMLNewPersonalMemberCardView *memberCardView = [[CMLNewPersonalMemberCardView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 690*Proportion/2.0,
                                                                                                                  274*Proportion,
                                                                                                                  690*Proportion,
                                                                                                                  293*Proportion)
                                                                                               withObj:self.obj
                                                                                        withCoverImage:self.coverImage
                                                                                                vImage:self.vImage];
    memberCardView.delegate = self;
    [self addSubview:memberCardView];
    self.currentHeight = CGRectGetMaxY(memberCardView.frame);
    
}

- (void)enterSettingVC {
    
    CMLPersonCenterSettingVC *vc = [[CMLPersonCenterSettingVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)enterEditVC {
    
    NewPersonDetailInfoVC *vc = [[NewPersonDetailInfoVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void)enterUpGradeVCWithRoleObj:(BaseResultObj *)roleObj {
    
    UpGradeVC *vc = [[UpGradeVC alloc] init];
    vc.roleObj = roleObj;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void)enterMessageVC {
    
    [[DataManager lightData] removeBadgeNumber];
    [self loadViews];
    CMLMessageViewController *vc = [[CMLMessageViewController alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - CMLNewPersonalMemberCardViewDelegate
- (void)enterMemberCenterOfCardViewWithRoleObj:(BaseResultObj *)roleObj {

    [self enterUpGradeVCWithRoleObj:roleObj];
}

@end
