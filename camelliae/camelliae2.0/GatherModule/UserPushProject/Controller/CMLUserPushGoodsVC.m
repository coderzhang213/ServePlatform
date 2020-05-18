//
//  CMLUserPushGoodsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/17.
//  Copyright © 2018 张越. All rights reserved.
//  花伴商品

#import "CMLUserPushGoodsVC.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "CMLUserPushServeFooterView.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "GoodsAttributeView.h"
#import "CMLUserPushBuyMessageVC.h"
#import "CMLVIPNewDetailVC.h"
#import "CMLMyCouponsModel.h"
#import "CMLCanGetCouponView.h"
#import "AppDelegate.h"

@interface CMLUserPushGoodsVC ()<UIScrollViewDelegate,UIWebViewDelegate,NavigationBarProtocol,NetWorkProtocol,UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,ServeFooterDelegate,GoodsAttributeViewDelegate, CMLCanGetCouponViewDelegate>


@property (nonatomic,strong) UIView *userBgView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIWebView *detailView;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) CMLUserPushServeFooterView *serveFooterView;

@property (nonatomic,strong) UIView *activityShadowView;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,strong) UIView *goodsBgShadowView;

/*可用优惠券*/
@property (nonatomic, strong) UIView *couponView;

@property (nonatomic, strong) CMLMyCouponsModel *chooseCouponsModel;

@property (nonatomic, strong) UILabel *couponContentLabel;

@property (nonatomic, strong) UIView *shadowTwoView;

@property (nonatomic, strong) CMLCanGetCouponView *canGetCouponView;

@end

@implementation CMLUserPushGoodsVC

- (instancetype)initWithObjId:(NSNumber *) currentID{
    self = [super init];
    if (self) {
        self.objId = currentID;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    
    [self.navBar setLeftBarItem];
    [self.navBar setNewShareBarItem];
    [self setNetWork];
    [self loadViews];
    
    self.shadowTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT)];
    self.shadowTwoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowTwoView.alpha = 0;
    [self.contentView addSubview:self.shadowTwoView];
    
}

- (void) setNetWork{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [paraDic setObject:[NSNumber numberWithInt:[appDelegate.pid intValue]] forKey:@"pId"];
    [NetWorkTask postResquestWithApiName:GoodsDetailMessage paraDic:paraDic delegate:delegate];
    self.currentApiName = GoodsDetailMessage;
    
    [self startLoading];

    
}


- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.mainScrollView];
    
    self.activityShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       WIDTH,
                                                                       HEIGHT)];
    self.activityShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityShadowView.alpha = 0;
    [self.contentView addSubview:self.activityShadowView];
    
}

- (void) loadFooterView{
    
    /**预约状态条*/
    self.serveFooterView = [[CMLUserPushServeFooterView alloc] initWith:self.obj andGoods:YES];
    self.serveFooterView.delegate = self;
    self.serveFooterView.frame = CGRectMake(0,
                                            HEIGHT - self.serveFooterView.currentHeight,
                                            WIDTH,
                                            self.serveFooterView.currentHeight);
    [self.contentView addSubview:self.serveFooterView];
}

- (void) loadUserMessage{
    
    self.userBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               160*Proportion)];
    self.userBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:self.userBgView];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                           160*Proportion/2.0 - 80*Proportion/2.0,
                                                                           80*Proportion,
                                                                           80*Proportion)];
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = 80*Proportion/2.0;
    [self.userBgView addSubview:userImage];
    [NetWorkTask setImageView:userImage WithURL:self.obj.retData.user.gravatar placeholderImage:nil];
    
    UIButton *userBtn = [[UIButton alloc] initWithFrame:userImage.bounds];
    userBtn.backgroundColor = [UIColor clearColor];
    [userImage addSubview:userBtn];
    [userBtn addTarget:self action:@selector(enterUserDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *userNickNameLab = [[UILabel alloc] init];
    userNickNameLab.font = KSystemRealBoldFontSize14;
    userNickNameLab.text = self.obj.retData.user.nickName;
    [userNickNameLab sizeToFit];
    userNickNameLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                       userImage.center.y - 10*Proportion - userNickNameLab.frame.size.height,
                                       userNickNameLab.frame.size.width,
                                       userNickNameLab.frame.size.height);
    [self.userBgView addSubview:userNickNameLab];
    
    UILabel *userSignature = [[UILabel alloc] init];
    userSignature.font = KSystemFontSize12;
    userSignature.text = self.obj.retData.user.signature;
    [userSignature sizeToFit];
    userSignature.textColor = [UIColor CMLLineGrayColor];
    userSignature.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                     CGRectGetMaxY(userNickNameLab.frame) + 10*Proportion,
                                     userSignature.frame.size.width,
                                     userSignature.frame.size.height);
    [self.userBgView addSubview:userSignature];
    
    UIImageView *userLvlImg = [[UIImageView alloc] init];
    userLvlImg.backgroundColor = [UIColor CMLWhiteColor];
    switch ([self.obj.retData.user.memberLevel intValue]) {
        case 1:
            
            userLvlImg.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
            
        case 2:
            
            userLvlImg.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
            
        case 3:
            
            userLvlImg.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
            
        case 4:
            
            userLvlImg.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    
    [userLvlImg sizeToFit];
    userLvlImg.frame = CGRectMake(CGRectGetMaxX(userImage.frame) - userLvlImg.frame.size.width,
                                  CGRectGetMaxY(userImage.frame) - userLvlImg.frame.size.height,
                                  userLvlImg.frame.size.width,
                                  userLvlImg.frame.size.height);
    userLvlImg.layer.cornerRadius = userLvlImg.frame.size.width/2.0;
    [self.userBgView addSubview:userLvlImg];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetHeight(self.userBgView.frame) - 1,
                                                               WIDTH,
                                                               1)];
    endLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.userBgView addSubview:endLine];
    
    /*花伴商品返利*/
    UILabel *rebateLabel = [[UILabel alloc] init];
    rebateLabel.backgroundColor = [[UIColor CMLDarkOrangeColor] colorWithAlphaComponent:0.8f];
    rebateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    rebateLabel.textColor = [UIColor CMLWhiteColor];
    rebateLabel.layer.cornerRadius = 24 * Proportion;
    rebateLabel.clipsToBounds = YES;
    rebateLabel.text = [NSString stringWithFormat:@"    分享返￥%@", self.obj.retData.rebateMoney];
    rebateLabel.textAlignment = NSTextAlignmentLeft;
    rebateLabel.hidden = YES;
    [rebateLabel sizeToFit];
    rebateLabel.frame = CGRectMake(WIDTH - CGRectGetWidth(rebateLabel.frame) - 24 * Proportion,
                                   CGRectGetHeight(self.userBgView.frame)/2 - 48 * Proportion/2,
                                   CGRectGetWidth(rebateLabel.frame) + 24 * Proportion * 3,
                                   48 * Proportion);
    [self.userBgView addSubview:rebateLabel];
    if (self.obj.retData.isEnjoyRebate.length > 0) {
        if ([self.obj.retData.isEnjoyRebate intValue] == 1) {
            if ([self.obj.retData.rebateMoney floatValue] != 0) {
                rebateLabel.hidden = NO;
            }else {
                rebateLabel.hidden = YES;
            }
        }else {
            rebateLabel.hidden = YES;
        }
    }
    
}

/*可领取优惠券*/
- (void)currentCanGetCouponsView {
    if (self.obj.retData.couponsInfo) {
        /*花伴商品详情可领取优惠券*/
        self.couponView = [[UIView alloc] init];
        self.couponView.backgroundColor = [UIColor CMLWhiteColor];
        self.couponView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.userBgView.frame),
                                           WIDTH,
                                           74 * Proportion);
        [self.mainScrollView addSubview:self.couponView];
        
        UILabel *couponTitleLabel = [[UILabel alloc] init];
        couponTitleLabel.backgroundColor = [UIColor clearColor];
        couponTitleLabel.text = @"优惠";
        couponTitleLabel.font = KSystemFontSize13;
        [couponTitleLabel sizeToFit];
        couponTitleLabel.frame = CGRectMake(30 * Proportion,
                                            CGRectGetHeight(self.couponView.frame)/2.0 - CGRectGetHeight(couponTitleLabel.frame)/2.0,
                                            CGRectGetWidth(couponTitleLabel.frame),
                                            CGRectGetHeight(couponTitleLabel.frame));
        [self.couponView addSubview:couponTitleLabel];
        
        UIImageView *enterCouponView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLEnterDiscountCouponIcon]];
        enterCouponView.backgroundColor = [UIColor clearColor];
        [enterCouponView sizeToFit];
        enterCouponView.frame = CGRectMake(WIDTH - 30 * Proportion - CGRectGetWidth(enterCouponView.frame),
                                           CGRectGetMidY(couponTitleLabel.frame) - CGRectGetHeight(enterCouponView.frame)/2.0,
                                           CGRectGetWidth(enterCouponView.frame),
                                           CGRectGetHeight(enterCouponView.frame));
        [self.couponView addSubview:enterCouponView];
        
        self.couponContentLabel = [[UILabel alloc] init];
        self.couponContentLabel.backgroundColor = [UIColor clearColor];
        self.couponContentLabel.text = self.obj.retData.couponsName;
        self.couponContentLabel.textColor = [UIColor CMLYellowD9AB5EColor];
        self.couponContentLabel.font = KSystemFontSize13;
        self.couponContentLabel.textAlignment = NSTextAlignmentRight;
        [self.couponContentLabel sizeToFit];
        self.couponContentLabel.frame = CGRectMake(CGRectGetMinX(enterCouponView.frame) - 15 * Proportion - 450 * Proportion,
                                                   CGRectGetMidY(couponTitleLabel.frame) - CGRectGetHeight(self.couponContentLabel.frame)/2.0,
                                                   450 * Proportion,
                                                   CGRectGetHeight(self.couponContentLabel.frame));
        [self.couponView addSubview:self.couponContentLabel];
        
        UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetHeight(self.couponView.frame) - 1,
                                                                   WIDTH,
                                                                   1)];
        endLine.backgroundColor = [UIColor CMLNewGrayColor];
        [self.couponView addSubview:endLine];
        
        /*覆盖整行*/
        UIButton *couponBtn = [[UIButton alloc] initWithFrame:self.couponView.bounds];
        couponBtn.backgroundColor = [UIColor clearColor];
        [self.couponView addSubview:couponBtn];
        [couponBtn addTarget:self action:@selector(discountCouponClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    
}

/*标题+web内容详情*/
- (void) loadWebView{
    
    UILabel *articleTitleLab = [[UILabel alloc] init];
    articleTitleLab.font = KSystemBoldFontSize15;
    articleTitleLab.textColor = [UIColor CMLBlackColor];
    articleTitleLab.numberOfLines = 0;
    articleTitleLab.text = self.obj.retData.title;
    CGRect currentRect =  [articleTitleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, HEIGHT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:KSystemRealBoldFontSize16}
                                                             context:nil];
    articleTitleLab.frame = CGRectMake(30*Proportion,
                                       30*Proportion + CGRectGetMaxY(self.userBgView.frame) + CGRectGetHeight(self.couponView.frame),
                                       WIDTH - 30*Proportion*2,
                                       currentRect.size.height);
    [self.mainScrollView addSubview:articleTitleLab];
    
    
    self.detailView = [[UIWebView alloc] init];
    self.detailView.backgroundColor = [UIColor CMLWhiteColor];
    self.detailView.delegate = self;
    self.detailView.frame = CGRectMake(0,
                                       CGRectGetMaxY(articleTitleLab.frame) + 20*Proportion,
                                       WIDTH,
                                       400);
    self.detailView.scrollView.scrollEnabled = NO;
    [self.detailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.detailUrl]]];
    [self.mainScrollView addSubview:self.detailView];
    
    /*花伴商品下单返利*/
    UILabel *orderRebateLabel = [[UILabel alloc] init];
    orderRebateLabel.backgroundColor = [[UIColor CMLDarkOrangeColor] colorWithAlphaComponent:0.8f];
    orderRebateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    orderRebateLabel.textColor = [UIColor CMLWhiteColor];
    orderRebateLabel.layer.cornerRadius = 24 * Proportion;
    orderRebateLabel.clipsToBounds = YES;
    orderRebateLabel.text = [NSString stringWithFormat:@"    下单返￥%@", self.obj.retData.orderRebateMoney];
    orderRebateLabel.textAlignment = NSTextAlignmentLeft;
    orderRebateLabel.hidden = YES;
    [orderRebateLabel sizeToFit];
    orderRebateLabel.frame = CGRectMake(WIDTH - CGRectGetWidth(orderRebateLabel.frame) - 24 * Proportion,
                                        CGRectGetMaxY(self.userBgView.frame) + 100 * Proportion,
                                        CGRectGetWidth(orderRebateLabel.frame) + 24 * Proportion * 3,
                                        48 * Proportion);
    [self.mainScrollView addSubview:orderRebateLabel];
    
    if ([self.obj.retData.isEnjoyOrderRebate intValue] == 1) {
        if ([self.obj.retData.orderRebateMoney floatValue] != 0) {
            orderRebateLabel.hidden = NO;
        }else {
            orderRebateLabel.hidden = YES;
        }
    }else {
        orderRebateLabel.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [[self.detailView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.detailView.frame = CGRectMake(webView.frame.origin.x,
                                       webView.frame.origin.y,
                                       webView.frame.size.width,
                                       height);
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailView.frame) + UITabBarHeight);

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GoodsDetailMessage]) {
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        self.navBar.titleContent = self.obj.retData.title;
        if ([obj.retCode intValue] == 0 && obj) {
            [self loadFooterView];
            [self loadUserMessage];
            [self currentCanGetCouponsView];
            [self loadWebView];
            /**分享内容处理*/
            [NSThread detachNewThreadSelector:@selector(setActivityShareMes) toTarget:self withObject:nil];
        }else{
            [self stopLoading];
            [self showReloadView];
        }
        [self stopLoading];
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showNetErrorTipOfNormalVC];
    [self stopIndicatorLoading];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}


- (void) didSelectedLeftBarItem{
    
//    if ([[[DataManager lightData] readIsLoginOfPush] intValue] == 1) {
//        [[DataManager lightData] saveIsLoginOfPush:[NSNumber numberWithInt:0]];
//        [[VCManger mainVC] popToRootVC];
//        [[VCManger homeVC] showCurrentViewController:0];
//    }
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) didSelectedRightBarItem{
    [self showCurrentVCShareView];
}

- (void) setActivityShareMes{
    
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.baseShareLink = self.obj.retData.shareLink;
    self.baseShareImage = image;
    self.baseShareContent = self.obj.retData.briefIntro;
    self.baseShareTitle = self.obj.retData.title;
    
    __weak typeof(self) weakSelf = self;
    self.shareSuccessBlock = ^(){
        
        [weakSelf hiddenCurrentVCShareView];
        //        [weakSelf sendShareAction];
    };
    
    self.sharesErrorBlock = ^(){
        
        [weakSelf hiddenCurrentVCShareView];
    };
    
}

#pragma mark - ServeFooterDelegate
- (void) progressSuccessWith:(NSString *)str{
    
}

- (void) progressErrorWith:(NSString *)str{

}

- (void) showProjectMessage{
    
    [self enterGoodsBuyMessageVC];
}

- (void) enterGoodsBuyMessageVC{
    
    self.goodsBgShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      WIDTH,
                                                                      HEIGHT)];
    self.goodsBgShadowView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.goodsBgShadowView];
    
    GoodsAttributeView *goodsAttributeView = [[GoodsAttributeView alloc] initWithFrame:CGRectMake(0,
                                                                                                  HEIGHT,
                                                                                                  WIDTH,
                                                                                                  HEIGHT - SafeAreaBottomHeight)];
    goodsAttributeView.obj = self.obj;
    goodsAttributeView.tag = 1;
    goodsAttributeView.delegate = self;
    [self.goodsBgShadowView addSubview:goodsAttributeView];
    
    [UIView animateWithDuration:0.3 animations:^{
        goodsAttributeView.frame = CGRectMake(0,
                                              0,
                                              WIDTH,
                                              HEIGHT - SafeAreaBottomHeight);
    }];

}

- (void) closeGoodsAttributeView{
    
    if ([self.goodsBgShadowView viewWithTag:1]) {
        
        GoodsAttributeView *goodsAttributeView = [self.goodsBgShadowView viewWithTag:1];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.goodsBgShadowView.backgroundColor = [UIColor clearColor];
            goodsAttributeView.frame = CGRectMake(0,
                                                  HEIGHT,
                                                  WIDTH,
                                                  HEIGHT);
        }completion:^(BOOL finished) {
            
            [weakSelf.goodsBgShadowView removeFromSuperview];
        }];
        
    }else if ([self.goodsBgShadowView viewWithTag:2]){
        
        GoodsAttributeView *goodsAttributeView = [self.goodsBgShadowView viewWithTag:2];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.goodsBgShadowView.backgroundColor = [UIColor clearColor];
            goodsAttributeView.frame = CGRectMake(0,
                                                  HEIGHT,
                                                  WIDTH,
                                                  HEIGHT);
        }completion:^(BOOL finished) {
            
            [weakSelf.goodsBgShadowView removeFromSuperview];
        }];
        
    }
    
}

- (void) showErrorMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) selectPackageID:(NSNumber *) packageID andBuyNum:(int) buyNum{
    
        
        CMLUserPushBuyMessageVC *vc = [[CMLUserPushBuyMessageVC alloc] init];
        vc.buyNum = buyNum;
        vc.obj = self.obj;
        vc.packageID = packageID;
        vc.parentType = [NSNumber numberWithInt:7];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterUserDetailVC{
    
    CMLVIPNewDetailVC *vc  = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.retData.user.nickName
                                                           currnetUserId:self.obj.retData.user.userId
                                                      isReturnUpOneLevel:NO];
    
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

/*点击领取优惠券*/
- (void)discountCouponClicked {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowTwoView.alpha = 1;
    }];
    
    self.canGetCouponView = [[CMLCanGetCouponView alloc] initWithFrame:CGRectMake(0,
                                                                                  HEIGHT/3,
                                                                                  WIDTH,
                                                                                  HEIGHT*2/3)
                                                               withObj:self.obj];
    self.canGetCouponView.delegate = self;
    [self.contentView addSubview:self.canGetCouponView];
    
}

#pragma mark - CMLCanGetCouponViewDelegate
- (void)cancelCanGetCouponView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowTwoView.alpha = 0;
    }];
    [self.canGetCouponView removeFromSuperview];
    
}

@end
