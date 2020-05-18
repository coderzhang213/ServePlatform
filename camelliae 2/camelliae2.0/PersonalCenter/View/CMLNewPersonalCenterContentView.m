//
//  CMLNewPersonalCenterModelView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/8/10.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLNewPersonalCenterContentView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "CMLGoodsOrderListVC.h"
#import "CMLPersonalCenterOrderVC.h"
#import "CMLNewIntegrationVC.h"
#import "PersonalCenterCollectionVC.h"
#import "CMLFeedBackVC.h"
#import "CMLInviteFriendsVC.h"
#import "CMLVIPInviteVC.h"
#import "CMLWalletCenterViewController.h"
#import "CMLCouponViewController.h"
#import "CMLCouponsCenterVC.h"
#import "CMLVIPPinkGoldInviteVC.h"
#import "CMLInviteOfRelationVC.h"
#import "CMLCodeScanViewController.h"
#import "ScanHelper.h"
#import "CMLCodeViewController.h"

@interface CMLNewPersonalCenterContentView()<UIScrollViewDelegate>

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) UIView *firstModule;

@property (nonatomic, strong) UIView *secondModule;

@property (nonatomic, strong) UIView *thirdModule;

@property (nonatomic, strong) UIImageView *needSignImg;

@property (nonatomic, strong) UIImageView *originImageView;

@property (nonatomic, strong) UIScrollView *endScrollView;

@property (nonatomic, strong) UIImageView *invitebImg;

@property (nonatomic, strong) UIImageView *allianceImg;

@property (nonatomic, strong) UIImageView *invitePinkImg;/*邀请粉色*/

@property (nonatomic, strong) UIButton *walletBtn;

@end

@implementation CMLNewPersonalCenterContentView

- (instancetype)initWithObj:(BaseResultObj *)obj {
    
    self = [super init];
    
    if (self) {
        self.obj = obj;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    [self setFirstModuleContent];
    /*灰色间隔条1*/
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.firstModule.frame),
                                                                 WIDTH,
                                                                 20*Proportion)];
    spaceView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:spaceView];
    
    [self setSecondModuleContentWithY:CGRectGetMaxY(spaceView.frame)];
    
    /*灰色间隔条2*/
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.secondModule.frame),
                                                                 WIDTH,
                                                                 20*Proportion)];
    spaceView2.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:spaceView2];
    
    [self setThridModuleContentWith:CGRectGetMaxY(spaceView2.frame)];
    
    self.currentHeight = CGRectGetMaxY(self.thirdModule.frame);
    
}

- (void) setFirstModuleContent{
    
    self.firstModule = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                WIDTH,
                                                                200*Proportion)];
    self.firstModule.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.firstModule];
    
    CGFloat currentLeft = 30*Proportion;
    NSArray *titleArray;
    NSArray *imageArray;

    if ([[[DataManager lightData] readRoleId] intValue] < 3) {
        titleArray = @[@"我的订单",@"我的预订",@"我的积分",@"我的收藏"];
        imageArray = @[PersonalCenterUserOrderImg,
                       PersonalCenterUserAppointmentImg,
                       PersonalCenterPointsImg,
                       PersonalCenterUsercollectImg];
    }else {
        titleArray = @[@"我的订单",@"我的预订",@"我的积分",@"我的收藏",@"我的卡券"];
        imageArray = @[PersonalCenterUserOrderImg,
                       PersonalCenterUserAppointmentImg,
                       PersonalCenterPointsImg,
                       PersonalCenterUsercollectImg,
                       PersonalCenterDiscountCouponImg];
    }
    titleArray = @[@"我的订单",@"我的预订",@"我的积分",@"我的收藏",@"我的卡券"];
    imageArray = @[PersonalCenterUserOrderImg,
                   PersonalCenterUserAppointmentImg,
                   PersonalCenterPointsImg,
                   PersonalCenterUsercollectImg,
                   PersonalCenterDiscountCouponImg];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = titleArray[i];
        nameLab.font = KSystemFontSize13;
        [nameLab sizeToFit];
        nameLab.frame = CGRectMake(currentLeft,
                                   self.firstModule.frame.size.height - 43*Proportion - nameLab.frame.size.height,
                                   nameLab.frame.size.width,
                                   nameLab.frame.size.height);
        [self.firstModule addSubview:nameLab];
        
        UIImageView *currentImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
        currentImg.contentMode =  UIViewContentModeScaleAspectFill;
        [currentImg clipsToBounds];
        currentImg.userInteractionEnabled = YES;
        [currentImg sizeToFit];
        currentImg.frame = CGRectMake(nameLab.center.x - currentImg.frame.size.width/2.0,
                                      nameLab.frame.origin.y - 24*Proportion - currentImg.frame.size.height,
                                      currentImg.frame.size.width,
                                      currentImg.frame.size.height);
        [self.firstModule addSubview:currentImg];
        
        UIButton *tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(currentImg.frame.origin.x - currentImg.frame.size.width/2.0,
                                                                      currentImg.frame.origin.y - currentImg.frame.size.height/2.0,
                                                                      currentImg.frame.size.width*2,
                                                                      currentImg.frame.size.height*2)];
        tagBtn.backgroundColor = [UIColor clearColor];
        tagBtn.tag = i;
        [tagBtn addTarget:self action:@selector(enterVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.firstModule addSubview:tagBtn];

        /*间隔*/
        CGFloat currentSpace = (WIDTH - 2*30*Proportion - titleArray.count * nameLab.frame.size.width)/(titleArray.count - 1);
        currentLeft += (nameLab.frame.size.width + currentSpace);//92*Proportion);
        
    }
    
}

- (void) setSecondModuleContentWithY:(CGFloat) currentY{

    self.secondModule = [[UIView alloc] init];
    self.secondModule.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.secondModule];
    
    /***钱包中心-图标***/
    UIImageView *walletImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalNewWalletImg]];
    walletImg.contentMode =  UIViewContentModeScaleAspectFill;
    [walletImg clipsToBounds];
    walletImg.frame = CGRectMake(31*Proportion,
                                 33*Proportion,
                                 36*Proportion,
                                 36*Proportion);
    [self.secondModule addSubview:walletImg];
    /*钱包中心-button*/
    self.walletBtn = [[UIButton alloc] init];
    [self.walletBtn setTitle:@"钱包中心" forState:UIControlStateNormal];
    self.walletBtn.titleLabel.font = KSystemFontSize13;
    [self.walletBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self.walletBtn sizeToFit];
    self.walletBtn.frame = CGRectMake(CGRectGetMaxX(walletImg.frame) + 18*Proportion,
                                      walletImg.center.y - self.walletBtn.frame.size.height/2.0,
                                      self.walletBtn.frame.size.width,
                                      self.walletBtn.frame.size.height);
    [self.secondModule addSubview:self.walletBtn];
    [self.walletBtn addTarget:self action:@selector(enterWalletCenter) forControlEvents:UIControlEventTouchUpInside];
    
    /*覆盖整行*/
    UIButton *walletLineButton = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                        self.walletBtn.center.y - 109*Proportion/2.0,
                                                                        WIDTH - 30*Proportion*2,
                                                                        109*Proportion)];
    walletLineButton.backgroundColor = [UIColor clearColor];
    [self.secondModule addSubview:walletLineButton];
    [walletLineButton addTarget:self action:@selector(enterWalletCenter) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *walletBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
    walletBack.contentMode = UIViewContentModeScaleAspectFill;
    walletBack.clipsToBounds = YES;
    [walletBack sizeToFit];
    walletBack.frame = CGRectMake(WIDTH - 30*Proportion - walletBack.frame.size.width,
                                  self.walletBtn.center.y - walletBack.frame.size.height/2.0,
                                  walletBack.frame.size.width,
                                  walletBack.frame.size.height);
    
    [self.secondModule addSubview:walletBack];
    /*新黛色提示*/
    [self loadOriginImageView];
    
    /***领券中心-图标***/
    UIImageView *couponImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalGetCouponsImg]];
    couponImg.contentMode =  UIViewContentModeScaleAspectFill;
    [couponImg clipsToBounds];
    couponImg.frame = CGRectMake(CGRectGetMidX(walletImg.frame) - 36*Proportion/2.0,
                                 46*Proportion + CGRectGetMaxY(self.walletBtn.frame),
                                 36*Proportion,
                                 36*Proportion);
    [self.secondModule addSubview:couponImg];
    /*领券中心-button*/
    UIButton *couponBtn = [[UIButton alloc] init];
    [couponBtn setTitle:@"领券中心" forState:UIControlStateNormal];
    couponBtn.titleLabel.font = KSystemFontSize13;
    [couponBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [couponBtn sizeToFit];
    couponBtn.frame = CGRectMake(CGRectGetMinX(self.walletBtn.frame),
                                 couponImg.center.y - couponBtn.frame.size.height/2.0,
                                 couponBtn.frame.size.width,
                                 couponBtn.frame.size.height);
    [self.secondModule addSubview:couponBtn];
    [couponBtn addTarget:self action:@selector(enterCouponsCenterVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
    back2.contentMode = UIViewContentModeScaleAspectFill;
    back2.clipsToBounds = YES;
    [back2 sizeToFit];
    back2.frame = CGRectMake(WIDTH - 30*Proportion - back2.frame.size.width,
                             couponBtn.center.y - back2.frame.size.height/2.0,
                             back2.frame.size.width,
                             back2.frame.size.height);
    
    [self.secondModule addSubview:back2];
    /*领券中心覆盖btn*/
    UIButton *couponLineButton = [[UIButton alloc] initWithFrame:CGRectMake(30 * Proportion,
                                                                            CGRectGetMidY(couponBtn.frame) - 109 * Proportion/2.0,
                                                                            WIDTH - 30 * Proportion * 2,
                                                                            109 * Proportion)];
    couponLineButton.backgroundColor = [UIColor clearColor];
    [self.secondModule addSubview:couponLineButton];
    [couponLineButton addTarget:self action:@selector(enterCouponsCenterVC) forControlEvents:UIControlEventTouchUpInside];

    /**扫一扫*/
    UIImageView *codeScanImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalCenterCodeScanImg]];/*warning更换扫一扫图标*/
    codeScanImg.contentMode = UIViewContentModeScaleAspectFit;
    [codeScanImg clipsToBounds];
    [codeScanImg sizeToFit];
    codeScanImg.frame = CGRectMake(CGRectGetMidX(walletImg.frame) - 36*Proportion/2.0,
                                   46 * Proportion + CGRectGetMaxY(couponBtn.frame),
                                   36 * Proportion,
                                   36 * Proportion);
    [self.secondModule addSubview:codeScanImg];
    /*扫一扫btn*/
    UIButton *codeScanBtn = [[UIButton alloc] init];
    [codeScanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    codeScanBtn.titleLabel.font = KSystemFontSize13;
    [codeScanBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [codeScanBtn sizeToFit];
    codeScanBtn.frame = CGRectMake(CGRectGetMinX(self.walletBtn.frame),
                                   CGRectGetMidY(codeScanImg.frame) - CGRectGetHeight(codeScanBtn.frame)/2.0,
                                   CGRectGetWidth(codeScanBtn.frame),
                                   CGRectGetHeight(codeScanBtn.frame));
    [self.secondModule addSubview:codeScanBtn];
    [codeScanBtn addTarget:self action:@selector(enterCodeScanVC) forControlEvents:UIControlEventTouchUpInside];
    /*进入扫一扫*/
    UIImageView *codeScanBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
    codeScanBack.contentMode = UIViewContentModeScaleAspectFill;
    [codeScanBack clipsToBounds];
    [codeScanBack sizeToFit];
    codeScanBack.frame = CGRectMake(WIDTH - 30 * Proportion - CGRectGetWidth(codeScanBack.frame),
                                    CGRectGetMidY(codeScanImg.frame) - CGRectGetHeight(codeScanBack.frame)/2.0,
                                    CGRectGetWidth(codeScanBack.frame),
                                    CGRectGetHeight(codeScanBack.frame));
    [self.secondModule addSubview:codeScanBack];
    /*覆盖整行*/
    UIButton *codeScanLineButton = [[UIButton alloc] initWithFrame:CGRectMake(30 * Proportion,
                                                                              CGRectGetMidY(codeScanBtn.frame) - 109 * Proportion/2.0,
                                                                              WIDTH - 30 * Proportion * 2,
                                                                              109 * Proportion)];
    codeScanLineButton.backgroundColor = [UIColor clearColor];
    [self.secondModule addSubview:codeScanLineButton];
    [codeScanLineButton addTarget:self action:@selector(enterCodeScanVC) forControlEvents:UIControlEventTouchUpInside];
    
    /***签到领积分***/
    UIImageView *recommendImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalNewSignImg]];
    recommendImg.contentMode =  UIViewContentModeScaleAspectFill;
    [recommendImg clipsToBounds];
    [recommendImg sizeToFit];
    recommendImg.frame = CGRectMake(CGRectGetMidX(walletImg.frame) - 36*Proportion/2.0,
                                    46*Proportion + CGRectGetMaxY(codeScanBtn.frame),
                                    36*Proportion,
                                    36*Proportion);
    [self.secondModule addSubview:recommendImg];
    
    UIButton *recommendBtn = [[UIButton alloc] init];
    [recommendBtn setTitle:@"签到领积分" forState:UIControlStateNormal];
    recommendBtn.titleLabel.font = KSystemFontSize13;
    [recommendBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [recommendBtn sizeToFit];
    recommendBtn.frame = CGRectMake(CGRectGetMinX(self.walletBtn.frame),
                                    recommendImg.center.y - recommendBtn.frame.size.height/2.0,
                                    recommendBtn.frame.size.width,
                                    recommendBtn.frame.size.height);
    [self.secondModule addSubview:recommendBtn];
    [recommendBtn addTarget:self action:@selector(SignCurrentApp) forControlEvents:UIControlEventTouchUpInside];
    
    /*未签到提示*/
    self.needSignImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UserVerbImg]];
    if ([[[DataManager lightData] readSignStatus] intValue] == 1) {

        self.needSignImg.hidden = YES;
    }
    self.needSignImg.contentMode = UIViewContentModeScaleAspectFill;
    self.needSignImg.clipsToBounds = YES;
    [self.needSignImg sizeToFit];
    self.needSignImg.frame = CGRectMake(CGRectGetMaxX(recommendBtn.frame) + 20*Proportion,
                                        recommendBtn.center.y - self.needSignImg.frame.size.height/2.0,
                                        self.needSignImg.frame.size.width,
                                        self.needSignImg.frame.size.height);
    [self.secondModule addSubview:self.needSignImg];
    
    /*覆盖整行*/
    UIButton *recommendBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         recommendBtn.center.y - 109*Proportion/2.0,
                                                                         WIDTH - 30*Proportion*2,
                                                                         109*Proportion)];
    recommendBtn1.backgroundColor = [UIColor clearColor];
    [self.secondModule addSubview:recommendBtn1];
    [recommendBtn1 addTarget:self action:@selector(SignCurrentApp) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *back1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
//    back1.contentMode = UIViewContentModeScaleAspectFill;
//    back1.clipsToBounds = YES;
//    [back1 sizeToFit];
//    back1.frame = CGRectMake(WIDTH - 30*Proportion - back1.frame.size.width,
//                             recommendBtn.center.y - back1.frame.size.height/2.0,
//                             back1.frame.size.width,
//                             back1.frame.size.height);
//
//    [self.secondModule addSubview:back1];
    self.secondModule.frame = CGRectMake(0,
                                         currentY,
                                         WIDTH,
                                         CGRectGetMaxY(recommendImg.frame) + 50*Proportion);
}


- (void)loadOriginImageView {
    
    self.originImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.walletBtn.frame),
                                                                         CGRectGetMinY(self.walletBtn.frame) + 4 * Proportion,
                                                                         8 * Proportion,
                                                                         8 * Proportion)];
    self.originImageView.backgroundColor = [UIColor redColor];
    self.originImageView.clipsToBounds = YES;
    self.originImageView.layer.cornerRadius = 8 * Proportion/2;
    self.originImageView.hidden = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBuySucceed"] intValue] == 1) {
        self.originImageView.hidden = NO;
    }
    [self.secondModule addSubview:self.originImageView];
    
}

#pragma mark delegate
- (void)showoriginImageView {
    
    self.originImageView.hidden = NO;
    
}
#pragma mark delegate

- (void) setThridModuleContentWith:(CGFloat) currentY{
    
    self.thirdModule = [[UIView alloc] init];
    self.thirdModule.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.thirdModule];
    
    self.endScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                        47*Proportion,
                                                                        WIDTH,
                                                                        216*Proportion)];
    self.endScrollView.showsVerticalScrollIndicator = NO;
    self.endScrollView.showsHorizontalScrollIndicator = NO;
    self.endScrollView.pagingEnabled = YES;
    self.endScrollView.delegate = self;
    [self.thirdModule addSubview:self.endScrollView];
    
    /*邀请*/
    if ([[[DataManager lightData] readUserLevel] integerValue] == 1 || [[[DataManager lightData] readRoleId] integerValue] < 5) {
        /*粉色会员邀请*/
        self.endScrollView.contentSize = CGSizeMake(WIDTH, 216*Proportion);
        self.endScrollView.scrollEnabled = NO;
        
        self.invitebImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalAdvertisementImg]];
        self.invitebImg.clipsToBounds = YES;
        self.invitebImg.contentMode = UIViewContentModeScaleAspectFill;
        self.invitebImg.userInteractionEnabled = YES;
        [self.invitebImg sizeToFit];
        self.invitebImg.frame = CGRectMake(30*Proportion,
                                           0,
                                           WIDTH - 30*Proportion*2,
                                           216*Proportion);
        [self.endScrollView addSubview:self.invitebImg];
        UIButton *invaiteBtn = [[UIButton alloc] initWithFrame:self.invitebImg.bounds];
        invaiteBtn.backgroundColor = [UIColor clearColor];
        [self.invitebImg addSubview:invaiteBtn];
        [invaiteBtn addTarget:self action:@selector(enterInvaiteVC) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        self.allianceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalAdvertisement1Img]];
        self.allianceImg.clipsToBounds = YES;
        self.allianceImg.contentMode = UIViewContentModeScaleAspectFill;
        self.allianceImg.userInteractionEnabled = YES;
        [self.allianceImg sizeToFit];
        self.allianceImg.frame = CGRectMake(CGRectGetMaxX(self.invitebImg.frame) + 10*Proportion,
                                            0,
                                            WIDTH - 30*Proportion*2,
                                            216*Proportion);
        [self.endScrollView addSubview:self.allianceImg];
        
        UIButton *vipInvaiteBtn = [[UIButton alloc] initWithFrame:self.allianceImg.bounds];
        vipInvaiteBtn.backgroundColor = [UIColor clearColor];
        [self.allianceImg addSubview:vipInvaiteBtn];
        [vipInvaiteBtn addTarget:self action:@selector(enterVIPInvaiteVC) forControlEvents:UIControlEventTouchUpInside];
         */
    }else{
        /*黛色会员邀请*/
        self.endScrollView.contentSize = CGSizeMake(WIDTH * 3, 216*Proportion);
//        self.endScrollView.scrollEnabled = NO;
        self.allianceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalAdvertisement1Img]];
        self.allianceImg.clipsToBounds = YES;
        self.allianceImg.contentMode = UIViewContentModeScaleAspectFill;
        self.allianceImg.userInteractionEnabled = YES;
        [self.allianceImg sizeToFit];
        self.allianceImg.frame = CGRectMake(30*Proportion,
                                            0,
                                            WIDTH - 30*Proportion*2,
                                            216*Proportion);
        [self.endScrollView addSubview:self.allianceImg];
        
        UIButton *vipInvaiteBtn = [[UIButton alloc] initWithFrame:self.allianceImg.bounds];
        vipInvaiteBtn.backgroundColor = [UIColor clearColor];
        [self.allianceImg addSubview:vipInvaiteBtn];
        [vipInvaiteBtn addTarget:self action:@selector(enterVIPInvaiteVC) forControlEvents:UIControlEventTouchUpInside];
        
        /*粉金粉钻邀请*/
        self.invitebImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalAdPinkGoldCardImg]];
        self.invitebImg.clipsToBounds = YES;
        self.invitebImg.contentMode = UIViewContentModeScaleAspectFill;
        self.invitebImg.userInteractionEnabled = YES;
        [self.invitebImg sizeToFit];
        self.invitebImg.frame = CGRectMake(CGRectGetMaxX(self.allianceImg.frame) + 10*Proportion,
                                           0,
                                           WIDTH - 30*Proportion*2,
                                           216*Proportion);
    
        [self.endScrollView addSubview:self.invitebImg];
        UIButton *invaiteBtn = [[UIButton alloc] initWithFrame:self.invitebImg.bounds];
        invaiteBtn.backgroundColor = [UIColor clearColor];
        [self.invitebImg addSubview:invaiteBtn];
        [invaiteBtn addTarget:self action:@selector(enterVIPPinkGoldInvaiteVC) forControlEvents:UIControlEventTouchUpInside];
        
        /*黛色邀请普通粉色*/
        self.invitePinkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PersonalAdvertisementImg]];
        self.invitePinkImg.clipsToBounds = YES;
        self.invitePinkImg.contentMode = UIViewContentModeScaleAspectFill;
        self.invitePinkImg.userInteractionEnabled = YES;
        [self.invitePinkImg sizeToFit];
        self.invitePinkImg.frame = CGRectMake(CGRectGetMaxX(self.invitebImg.frame) + 10*Proportion,
                                              0,
                                              WIDTH - 30*Proportion*2,
                                              216*Proportion);
        
        [self.endScrollView addSubview:self.invitePinkImg];
        UIButton *invaitePinkBtn = [[UIButton alloc] initWithFrame:self.invitePinkImg.bounds];
        invaitePinkBtn.backgroundColor = [UIColor clearColor];
        [self.invitePinkImg addSubview:invaitePinkBtn];
        [invaitePinkBtn addTarget:self action:@selector(enterInviteOfRelationVC) forControlEvents:UIControlEventTouchUpInside];

    }

    self.thirdModule.frame = CGRectMake(0,
                                        currentY,
                                        WIDTH,
                                        CGRectGetMaxY(self.endScrollView.frame) + 50);
}

- (void) enterVC:(UIButton *) btn{
    
    if (btn.tag == 0) {
        
        
        /**打点*/
        [CMLMobClick personalOrderEvent];
        /*我的订单*/
        CMLGoodsOrderListVC *vc = [[CMLGoodsOrderListVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (btn.tag == 1){
        
        /**打点*/
        [CMLMobClick peraonalAppointmentEvent];
        
        /**我的预订*/
        CMLPersonalCenterOrderVC *vc = [[CMLPersonalCenterOrderVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else if (btn.tag == 2){
        /*我的积分*/
        CMLNewIntegrationVC *vc = [[CMLNewIntegrationVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (btn.tag == 3){
        
        [CMLMobClick personalCollectionEvent];
        /*我的收藏*/
        PersonalCenterCollectionVC *vc = [[PersonalCenterCollectionVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if (btn.tag == 4) {
        
        [CMLMobClick personalDiscountCoupons];
        /*优惠券*/
        CMLCouponViewController *vc = [[CMLCouponViewController alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
    
}

- (void) enterOpinionsVC{
    
    CMLFeedBackVC *vc = [[CMLFeedBackVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

/*普通邀请粉色*/
- (void) enterInvaiteVC{
    
    CMLInviteFriendsVC *vc = [[CMLInviteFriendsVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];

}

/*黛色邀请粉色-建立关系*/
- (void)enterInviteOfRelationVC {
    CMLInviteOfRelationVC *vc = [[CMLInviteOfRelationVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

/*黛色邀请粉金黛色等*/
- (void) enterVIPInvaiteVC{
    
    CMLVIPInviteVC *vc = [[CMLVIPInviteVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

/*黛色赠送粉金*/
- (void)enterVIPPinkGoldInvaiteVC {
    CMLVIPPinkGoldInviteVC *vc = [[CMLVIPPinkGoldInviteVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) shareCurrentApp{
    
    [self.delegate shareCML];
}

- (void) SignCurrentApp{

    [self.delegate signCML];
    self.needSignImg.hidden = YES;
    
}

- (void)enterCouponsCenterVC {
    CMLCouponsCenterVC *vc = [[CMLCouponsCenterVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)enterCodeScanVC {
//    CMLScrollViewController *vc = [[CMLScrollViewController alloc] init];
    CMLCodeViewController *vc = [[CMLCodeViewController alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

/*钱包中心*/
- (void)enterWalletCenter {
    /*提示圆点*/
    self.originImageView.hidden = YES;

    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBuySucceed"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    CMLWalletCenterViewController *vc = [[CMLWalletCenterViewController alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    __weak typeof(self) weakSelf = self;
    
    if (self.endScrollView.contentOffset.x == 0) {
       
        [UIView animateWithDuration:0.3f animations:^{
            
            weakSelf.allianceImg.frame = CGRectMake(30*Proportion,
                                                    0,
                                                    self.invitebImg.frame.size.width,
                                                    self.invitebImg.frame.size.height);
            
            weakSelf.invitebImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.allianceImg.frame) + 10*Proportion,
                                                   0,
                                                   self.allianceImg.frame.size.width,
                                                   self.allianceImg.frame.size.height);
            
            weakSelf.invitePinkImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.invitebImg.frame) + 10*Proportion,
                                                   0,
                                                   self.invitebImg.frame.size.width,
                                                   self.invitebImg.frame.size.height);
            
        }];

    }else if (self.endScrollView.contentOffset.x == WIDTH) {
       
        [UIView animateWithDuration:0.3f animations:^{
        
            weakSelf.allianceImg.frame = CGRectMake(80*Proportion,
                                                    0,
                                                    self.invitebImg.frame.size.width,
                                                    self.invitebImg.frame.size.height);
            
            weakSelf.invitebImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.allianceImg.frame) + 10*Proportion,
                                                   0,
                                                   self.allianceImg.frame.size.width,
                                                   self.allianceImg.frame.size.height);
            
            weakSelf.invitePinkImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.invitebImg.frame) + 10*Proportion,
                                                      0,
                                                      self.invitebImg.frame.size.width,
                                                      self.invitebImg.frame.size.height);

        }];
    
    }else {
        
        [UIView animateWithDuration:0.3f animations:^{
            
            weakSelf.allianceImg.frame = CGRectMake(80*Proportion + 50* Proportion,
                                                    0,
                                                    self.invitebImg.frame.size.width,
                                                    self.invitebImg.frame.size.height);
            
            weakSelf.invitebImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.allianceImg.frame) + 10*Proportion,
                                                   0,
                                                   self.allianceImg.frame.size.width,
                                                   self.allianceImg.frame.size.height);
            
            weakSelf.invitePinkImg.frame = CGRectMake(CGRectGetMaxX(weakSelf.invitebImg.frame) + 10*Proportion,
                                                      0,
                                                      self.invitebImg.frame.size.width,
                                                      self.invitebImg.frame.size.height);
            
        }];
        
    }

}

@end
