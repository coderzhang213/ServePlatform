//
//  ActivityDefaultVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityDefaultVC.h"
#import "VCManger.h"
#import "WebViewLinkVC.h"
#import "MoreMesView.h"
#import "CustomTransition.h"
#import "DefaultTransition.h"
#import "ActivityBriefInformationView.h"
#import "ActivityFooterView.h"
#import "ActivityAppointmentMessageView.h"
#import "ActivityPromMessageView.h"
#import "DetailWebView.h"
#import "NewActivityHeaderView.h"
#import "DetailMoreMessageWebView.h"
#import "ActivityPayTypeView.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"
#import "CMLInvitationView.h"
#import "ActivitySimpleMessageView.h"
#import "BrandView.h"
#import "CMLPicObjInfo.h"
#import "NewActivityTypeView.h"
#import "ActivityWebMessageView.h"
#import "CMLSubscribeDefaultVC.h"

@interface ActivityDefaultVC ()<NetWorkProtocol,UIScrollViewDelegate,UINavigationControllerDelegate,ActivityFooterViewDelegate,ActivityAppointmentMessageDelegate,ActivityPromMessageDelegate,NewActivityHeaderDelegate,ActivityPayTypeViewDelegate,InvitationViewDelegate,NewSelectViewDelegate, CMLSubscribeDefaultVCDelegate>

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,assign) CGFloat cuurentOffSet;

@property (nonatomic,assign) BOOL footerIsHidden;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) MoreMesView *moreMesView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) CGFloat currentOffSetY;

@property (nonatomic,strong) UIView *activityShadowView;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIImageView *springVelocityImage;

@property (nonatomic,strong) ActivityBriefInformationView *activityTopMessageView;

@property (nonatomic,strong) NewActivityHeaderView *activityHeaderView;

@property (nonatomic,strong) ActivityFooterView *activityFooterView;

@property (nonatomic,strong) ActivityAppointmentMessageView *activityAppointmentMessageView;

@property (nonatomic,strong) ActivityPromMessageView *activityPromMessageView;

@property (nonatomic,strong) DetailMoreMessageWebView *otherMessageWebView;

@property (nonatomic,strong) NewActivityTypeView *activitySelectTypeView;

@property (nonatomic,strong) ActivityPayTypeView *activityPayTypeView;

@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,strong) CMLInvitationView  *invitationView;

@property (nonatomic,strong) ActivitySimpleMessageView *activitySimpleMessageView;

@property (nonatomic,strong) BrandView *brandView;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) ActivityWebMessageView *activityWebMessageView;

@property (nonatomic,strong) UIImageView *QRImageView;


@end

@implementation ActivityDefaultVC

- (instancetype)initWithObjId:(NSNumber *)objId{

    self = [super init];
    
    if (self) {
        
        self.objId = objId;
    
    }
    
    return self;
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPayError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"successPayOfZFB" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    //微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(weixinPaySuccessOfActivity)
     
                                                 name:@"WXPaySuccess" object:nil];
    //支付宝支付
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ZFBPaySuccessOfActivity)
                                                 name:@"successPayOfZFB"
                                               object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.hidden = YES;
    
    self.contentView.backgroundColor = [UIColor CMLNewGrayColor];
    
    /**无网络刷新*/
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
        
    };
    
}

- (void) loadMessageOfVC{

    [self setNetWork];
}

/**信息*/
- (void) setNetWork{
    
    [self startLoading];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ActivityInfo paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityInfo;
}

- (void) loadViews{
    
    /**粘性头图*/
    self.springVelocityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             WIDTH,
                                                                             WIDTH)];
    self.springVelocityImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.springVelocityImage.contentMode = UIViewContentModeScaleAspectFill;
    self.springVelocityImage.clipsToBounds = YES;
    self.springVelocityImage.hidden = YES;
    [self.contentView addSubview:self.springVelocityImage];
    [NetWorkTask setImageView:self.springVelocityImage WithURL:self.obj.retData.objCoverPic placeholderImage:nil];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                       WIDTH/16*9 - 60*Proportion,
                                                                       WIDTH,
                                                                       20*Proportion)];
    self.pageControl.numberOfPages = self.obj.retData.coverPicArr.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor CMLBlackColor];
    self.pageControl.pageIndicatorTintColor = [[UIColor CMLBlackColor]colorWithAlphaComponent:0.5 ];
    self.pageControl.currentPage = 0;
    [self.springVelocityImage addSubview:self.pageControl];
    
    if (self.obj.retData.coverPicArr.count == 1) {
        self.pageControl.hidden = YES;
    }
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT - SafeAreaBottomHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
    self.activityHeaderView = [[NewActivityHeaderView alloc] initWith:self.obj];
    self.activityHeaderView.frame = CGRectMake(0,
                                               0,
                                               WIDTH,
                                               NavigationBarHeight + StatusBarHeight);
    self.activityHeaderView.delegate = self;
    [self.contentView addSubview:self.activityHeaderView];
    
    /**设置标头*/
    [self setContentHeaderView];
    
    /**主要内容*/ 
    [self setMainContentView];
    
    /**预约状态条*/
    self.activityFooterView = [[ActivityFooterView alloc] initWith:self.obj withIsJoin:self.isJoin];
    self.activityFooterView.delegate = self;
    self.activityFooterView.frame = CGRectMake(0,
                                               HEIGHT - UITabBarHeight - SafeAreaBottomHeight,
                                               WIDTH,
                                               self.activityFooterView.currentHeight);
    [self.contentView addSubview:self.activityFooterView];
    
    
    self.activityShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.activityShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityShadowView.alpha = 0;
    [self.contentView addSubview:self.activityShadowView];
    
    
    /**双击回滚*/
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(NavigationBarHeight,
                                                            0,
                                                            WIDTH - NavigationBarHeight*2,
                                                            StatusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    UITapGestureRecognizer *doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [view addGestureRecognizer:doubleRecognizer];
    
    
}


#pragma mark - 设置头图
- (void) setContentHeaderView{

    /*头图-小*/
    self.activityTopMessageView  = [[ActivityBriefInformationView alloc] initWith:self.obj];
    self.activityTopMessageView.frame = CGRectMake(0,
                                                   0,
                                                   WIDTH,
                                                   self.activityTopMessageView.currentHeight);
    [self.mainScrollView addSubview:self.activityTopMessageView];
    
    self.activityWebMessageView = [[ActivityWebMessageView alloc] initWithObj:self.obj];
    self.activityWebMessageView.frame = CGRectMake(0,
                                                   CGRectGetMaxY(self.activityTopMessageView.frame) + 20*Proportion,
                                                   WIDTH,
                                                   self.activityWebMessageView.currentHeight);
    [self.mainScrollView addSubview:self.activityWebMessageView];
    
    if (self.activityWebMessageView.currentHeight == 0) {
       
        self.activityWebMessageView.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.activityTopMessageView.frame),
                                                       WIDTH,
                                                       self.activityWebMessageView.currentHeight);
    }
   
}

- (void) setMainContentView{
    
    self.activitySimpleMessageView = [[ActivitySimpleMessageView alloc] initWithObj:self.obj];
    self.activitySimpleMessageView.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.activityWebMessageView.frame) + 20*Proportion,
                                                      WIDTH,
                                                      self.activitySimpleMessageView.currentHeight);
    [self.mainScrollView addSubview:self.activitySimpleMessageView];
    
    
        /**更多信息*/
    [self setContentFooterView];

}


- (void) setContentFooterView{
    

    self.otherMessageWebView = [[DetailMoreMessageWebView alloc] initWith:self.obj];
    self.otherMessageWebView.bottomHeight = 50*Proportion;
    self.otherMessageWebView.frame = CGRectMake(0,
                                               CGRectGetMaxY(self.activitySimpleMessageView.frame) + 20*Proportion,
                                               WIDTH,
                                               0);
    
    __weak typeof(self) weakSelf = self;
    self.otherMessageWebView.loadWebViewFinish = ^(CGFloat currentHeight){
        
        weakSelf.otherMessageWebView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(weakSelf.activitySimpleMessageView.frame) + 20*Proportion,
                                                        WIDTH,
                                                        currentHeight );
        
        
        [weakSelf.moreMesView removeFromSuperview];
        [weakSelf.brandView removeFromSuperview];
        
        weakSelf.brandView = [[BrandView alloc] initWithObj:weakSelf.obj];
        weakSelf.brandView.frame = CGRectMake(0,
                                              CGRectGetMaxY(weakSelf.otherMessageWebView.frame) + 20*Proportion,
                                              WIDTH,
                                              weakSelf.brandView.currentheight);
        [weakSelf.mainScrollView addSubview:weakSelf.brandView];
        
        if (weakSelf.brandView.currentheight == 0) {
            
            weakSelf.brandView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(weakSelf.otherMessageWebView.frame),
                                                  WIDTH,
                                                  weakSelf.brandView.currentheight);
        }
        
        
        weakSelf.moreMesView = [[MoreMesView alloc] init];
        weakSelf.moreMesView.List = weakSelf.obj.retData.recommList;
        weakSelf.moreMesView.currentClass = weakSelf.obj.retData.recommListTypeId;
        [weakSelf.moreMesView createViews];
        weakSelf.moreMesView.frame = CGRectMake(0,
                                                CGRectGetMaxY(weakSelf.brandView.frame) + 20*Proportion,
                                                WIDTH,
                                                weakSelf.moreMesView.currentHeight);
        [weakSelf.mainScrollView addSubview:weakSelf.moreMesView];
        
        if (weakSelf.moreMesView.currentHeight == 0) {
            
            weakSelf.moreMesView.hidden = YES;
        }

        UIImageView *bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewDEtailMessageBottomLogoImg]];
        bottomImage.backgroundColor = [UIColor clearColor];
        [bottomImage sizeToFit];
        bottomImage.frame = CGRectMake(WIDTH/2.0 - bottomImage.frame.size.width/2.0,
                                       CGRectGetMaxY(weakSelf.moreMesView.frame) ,
                                       bottomImage.frame.size.width,
                                       bottomImage.frame.size.height);
        [weakSelf.mainScrollView addSubview:bottomImage];
        /**重新设置scrollView的frame*/
        weakSelf.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                         CGRectGetMaxY(bottomImage.frame) + NavigationBarHeight );
        
        [weakSelf stopLoading];
        
        
    };
    
    [self.mainScrollView addSubview:self.otherMessageWebView];
    
    
}

#pragma mark - dismissCurrentVC
- (void) dismissCurrentVC{
    
    [[VCManger mainVC] dismissCurrentVC];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ActivityInfo]) {
        NSLog(@"ActivityInfo %@", responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**打点*/
            [CMLMobClick activityEventWithType:obj.retData.subTypeName memberLvl:obj.retData.memberLevelId];
            
            self.QRImageView = [[UIImageView alloc] init];
            [NetWorkTask setImageView:self.QRImageView WithURL:self.obj.retData.activityQrCode placeholderImage:nil];
            
            [self loadViews];
            
            /**分享内容处理*/
            [NSThread detachNewThreadSelector:@selector(setActivityShareMes) toTarget:self withObject:nil];

        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            NewActivityHeaderView *detailHeaderView = [[NewActivityHeaderView alloc] initWith:nil];
            detailHeaderView.frame = CGRectMake(0,
                                                StatusBarHeight,
                                                WIDTH,
                                                NavigationBarHeight);
            detailHeaderView.delegate = self;
            [self.contentView addSubview:detailHeaderView];

            
            [self stopLoading];
            [self showAlterViewWithText:obj.retMsg];
            
        }
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {

            [self hiddenCurrentVCShareView];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }
    }else if ([self.currentApiName isEqualToString:ConfirmAppointment]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if (([obj.retCode intValue] == 200503 || [obj.retCode intValue] == 0) && obj) {
            [self cancelAppointment];
            [self showSuccessTemporaryMes:@"支付成功"];
//            [self setCurrentInvitationView];
            /*进入订单详情*/
            [self enterCenterOrderVC];
            
            [CMLMobClick bookingActivityEventwithType:self.obj.retData.subTypeName
                                       address:self.obj.retData.address
                                     memberLvl:[NSString stringWithFormat:@"%@",self.obj.retData.memberLevelId]
                                          time:self.obj.retData.actDateZone];
                
            
            [self.activityFooterView confirmAppointment];
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:CancelAppointment]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            [self showSuccessTemporaryMes:@"取消支付"];
            /**取消支付*/
            [self hiddenShaDowView];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            /**取消支付*/
            [self hiddenShaDowView];
        }
    }
    
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    self.activityHeaderView = [[NewActivityHeaderView alloc] initWith:nil];
    self.activityHeaderView.frame = CGRectMake(0,
                                               0,
                                               WIDTH,
                                               NavigationBarHeight + StatusBarHeight);
    self.activityHeaderView.delegate = self;
    [self.activityHeaderView changeBlackView];
    [self.contentView addSubview:self.activityHeaderView];
    
    [self showNetErrorTipOfNormalVC];
    [self stopIndicatorLoading];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}

#pragma mark - showShaDowView
- (void) showShaDowView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.activityShadowView.alpha = 1;
    }];
}

#pragma mark - hiddenShaDowView
- (void) hiddenShaDowView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.activityShadowView.alpha = 0;
    }];
}

#pragma mark - 展示预订信息
- (void) setActivityMesView{
    

    if ([[[DataManager lightData] readPhone] valiMobile]) {
        
        [self showShaDowView];
        
        
        if ([self.obj.retData.packageInfo.dataCount intValue] == 1 ){
            
            [self setActivityAppointmentMes:[NSNumber numberWithInt:0]];
        }else{
            
            [self setActivityDifferentTypeMessage];

        }
        
    }else{
    
        [self.activityShadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self showShaDowView];
        
        self.activityPromMessageView = [[ActivityPromMessageView alloc] init];
        self.activityPromMessageView.delegate = self;
        self.activityPromMessageView.frame = CGRectMake(WIDTH/2.0 - self.activityPromMessageView.currentWidth/2.0,
                                                        HEIGHT/2.0 - self.activityPromMessageView.currentHeight/2.0,
                                                        self.activityPromMessageView.currentWidth,
                                                        self.activityPromMessageView.currentHeight);
        [self.activityShadowView addSubview:self.activityPromMessageView];
        
    }
}

- (void) setActivityAppointmentMes:(NSNumber *) type{
    
    [self.activityShadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.activityAppointmentMessageView = [[ActivityAppointmentMessageView alloc] initWith:self.obj andType:type];
    self.activityAppointmentMessageView.delegate = self;
    self.activityAppointmentMessageView.frame = CGRectMake(WIDTH/2.0 - self.activityAppointmentMessageView.currentWidth/2.0,
                                                           HEIGHT/2.0 - self.activityAppointmentMessageView.currentHeight/2.0,
                                                           self.activityAppointmentMessageView.currentWidth,
                                                           self.activityAppointmentMessageView.currentHeight);
    [self.activityShadowView addSubview:self.activityAppointmentMessageView];
    
    /**取消*/
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setImage:[UIImage imageNamed:AlterViewCloseBtnImg] forState:UIControlStateNormal];
    [self.cancelBtn sizeToFit];
    self.cancelBtn.frame = CGRectMake(WIDTH/2.0 - self.cancelBtn.frame.size.width/2.0,
                                      CGRectGetMaxY(self.activityAppointmentMessageView.frame) + 40*Proportion,
                                      self.cancelBtn.frame.size.width ,
                                      self.cancelBtn.frame.size.height);
    [self.activityShadowView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelAppointment) forControlEvents:UIControlEventTouchUpInside];
    
}

/*票种信息*/
- (void) setActivityDifferentTypeMessage{

    [self.activityShadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    self.activitySelectTypeView = [[NewActivityTypeView alloc] initWithObj:self.obj];
    self.activitySelectTypeView.frame = CGRectMake(0,
                                                   0,
                                                   WIDTH,
                                                   HEIGHT);
    self.activitySelectTypeView.delegate = self;
    [self.activityShadowView addSubview:self.activitySelectTypeView];

    
}

- (void) setCurrentActivityPayTypeView{

    [self.activityShadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.activityPayTypeView = [[ActivityPayTypeView alloc] init];
    self.activityPayTypeView.frame = CGRectMake(WIDTH/2.0 - self.activityPayTypeView.viewWidth/2.0, \
                                                      HEIGHT/2.0 - self.activityPayTypeView.viewHeight/2.0,
                                                      self.activityPayTypeView.viewWidth,
                                                      self.activityPayTypeView.viewHeight);
    self.activityPayTypeView.delegate = self;
    self.activityPayTypeView.orderId = self.orderID;
    [self.activityShadowView addSubview:self.activityPayTypeView];

}
#pragma mark - cancelAppointment
- (void) cancelAppointment{

    [self hiddenShaDowView];
}

#pragma mark - showShareView
- (void) showShareView{
    
    [self showCurrentVCShareView];

}

- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:2],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}


- (void) handleDoubleTapFrom{
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.activityAppointmentMessageView resignUserNameFirstResponder];
    [self hiddenCurrentVCShareView];
}

#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.mainScrollView) {

        self.cuurentOffSet = self.mainScrollView.contentOffset.y;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.mainScrollView) {
        
        if (self.mainScrollView.contentOffset.y >= 0) {
            
            self.springVelocityImage.hidden = YES;
            [self.activityTopMessageView showTopImage];
            
            __weak typeof(self) weakSelf = self;
            if (self.mainScrollView.contentOffset.y > self.cuurentOffSet) {
                
                if (!self.footerIsHidden) {
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.activityFooterView.frame = CGRectMake(0,
                                                                   HEIGHT,
                                                                   WIDTH,
                                                                   UITabBarHeight);
                    } completion:^(BOOL finished) {
                        weakSelf.footerIsHidden = YES;
                    }];
                }
            }else{
                
                if (self.footerIsHidden) {
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.activityFooterView.frame = CGRectMake(0,
                                                                   HEIGHT - UITabBarHeight - SafeAreaBottomHeight,
                                                                   WIDTH,
                                                                   UITabBarHeight);
                        
                    } completion:^(BOOL finished) {
                        weakSelf.footerIsHidden = NO;
                    }];
                }
            }
            
            
            if (self.mainScrollView.contentOffset.y > WIDTH/16*9 - StatusBarHeight - NavigationBarHeight - 20*Proportion) {
                
                [self.activityHeaderView changeBlackView];
            }else{
                
                [self.activityHeaderView changeDefaultView];
            }
            
        }else{
            
            if (self.activityTopMessageView.currentImage) {
                self.springVelocityImage.image = self.activityTopMessageView.currentImage.image;
            }
            
            self.pageControl.currentPage = self.activityTopMessageView.currentIndex;
            
            self.springVelocityImage.hidden = NO;
            
           
            [self.activityTopMessageView hiddenTopImage];
            self.springVelocityImage.frame = CGRectMake(self.mainScrollView.contentOffset.y,
                                                         0,
                                                         WIDTH - 2*self.mainScrollView.contentOffset.y,
                                                         WIDTH/16*9 - self.mainScrollView.contentOffset.y);
            self.pageControl.frame = CGRectMake(self.springVelocityImage.frame.size.width/2.0 - WIDTH/2.0,
                                                self.springVelocityImage.frame.size.height - 60*Proportion,
                                                WIDTH,
                                                20*Proportion);
            
            
        }

    }
    
    if (self.obj.retData.coverPicArr.count == 1) {
        
        self.pageControl.hidden = YES;
    }
    
}


#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification*) noti{
    
    self.cancelBtn.hidden = YES;
    
    NSDictionary *info = [noti userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.activityAppointmentMessageView.center = CGPointMake(self.contentView.center.x,
                                              HEIGHT - keyboardSize.height - self.activityAppointmentMessageView.frame.size.height/2.0);
    
}

- (void) keyboardWillBeHidden{
    
    self.cancelBtn.hidden = NO;
    self.activityAppointmentMessageView.center = self.view.center;
    
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
        
        [weakSelf sendShareAction];
    };
    
    self.sharesErrorBlock = ^(){
        
    };
    
}

#pragma mark - ActivityFooterViewDelegate
- (void) showActivityMessage{

    if ([self.obj.retData.sysApplyStatus intValue] == 5) {
        
        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = self.obj.retData.actionViewLink;
        vc.isDetailMes = YES;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        
        [self setActivityMesView];

    }
}


#pragma mark - ActivityAppointmentMessageDelegate
- (void) activityAppointmentSuccess:(NSString *) str{

    self.orderID = self.activityAppointmentMessageView.orderID;
    if ([str isEqualToString:@"生成订单"]) {
        [self setCurrentActivityPayTypeView];
    }else{
        [self cancelAppointment];
        [self showSuccessTemporaryMes:str];
        [self.activityFooterView confirmAppointment];
//        [self setCurrentInvitationView];
        [self enterCenterOrderVC];
    }
}
- (void) activityAppointmentError:(NSString *) str{

    [self showFailTemporaryMes:str];
}

- (void) activityStartAppoint{

    self.cancelBtn.userInteractionEnabled = NO;
    [self startIndicatorLoading];
}

- (void) activityStopAppoint{

    self.cancelBtn.userInteractionEnabled = YES;
    [self stopIndicatorLoading];
}

#pragma mark - ActivityPromMessageDelegate

- (void) cancelcurrentAppointment;{

    [self hiddenShaDowView];
}

#pragma mark - ActivityHeaderDelegate
- (void) collectProgressSuccess:(NSString *) str{

    [self showSuccessTemporaryMes:str];
}

- (void) collectProgressError:(NSString *) str{

    [self showFailTemporaryMes:str];
}

- (void) showDetailShareMessage{

    [self showShareView];
    
}

- (void) dissCurrentDetailVC{

    [self.delegate refreshFashionSalonEquity];
    [[VCManger mainVC] dismissCurrentVC];
    
}

#pragma mark - SelectViewDelegate
- (void) selectedActivityType:(int) index{

     [self setActivityAppointmentMes:[NSNumber numberWithInt:index]];
}

- (void) cancelSelectActivity{

    [self hiddenShaDowView];
}

#pragma mark - ActivityPayTypeViewDelegate
- (void) startActivityPayType{

    [self startIndicatorLoading];

}

- (void) activityPayTypeError:(NSString *) str{

    [self showFailTemporaryMes:str];
}

- (void) stopActivityPayType{

    [self stopIndicatorLoading];
}

- (void) cancelActivityPayProgress{

    [self setCancelAppointmentRequest];
}


- (void) ZFBPaySuccessOfActivity{
    
    if (self.orderID) {
        
        [self setConfirmAppointmentRequest];
        
        [self startIndicatorLoading];
    }
}


- (void) weixinPaySuccessOfActivity{
    
    [self setConfirmAppointmentRequest];
    [self startIndicatorLoading];
}

- (void) setConfirmAppointmentRequest{
    
    if (self.orderID) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.orderID forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];

        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.orderID,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:ConfirmAppointment paraDic:paraDic delegate:delegate];
        self.currentApiName = ConfirmAppointment;
    }
    
}

- (void) setCancelAppointmentRequest{
    
    if (self.orderID) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.objId forKey:@"objId"];
        [paraDic setObject:self.orderID forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"parentType"];
        
        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList lastObject]];
        [paraDic setObject:costObj.currentID forKey:@"packageId"];
        
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,[NSNumber numberWithInt:1],self.orderID,reqTime,skey,[NSNumber numberWithInt:2]]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:CancelAppointment paraDic:paraDic delegate:delegate];
        self.currentApiName = CancelAppointment;
        
    }
}

- (void) setCurrentInvitationView{
    
    [self.invitationView removeFromSuperview];
    
    
    self.invitationView = [[CMLInvitationView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              WIDTH,
                                                                              HEIGHT)];
    self.invitationView.backgroundColor = [UIColor clearColor];
    self.invitationView.delegate = self;
    self.invitationView.userName = [[DataManager lightData] readUserName];
    self.invitationView.activityTitle = self.obj.retData.title;
    self.invitationView.timeZone = self.obj.retData.actDateZone;
    self.invitationView.address = self.obj.retData.address;
    self.invitationView.bgImageType = self.obj.retData.invitation;
    self.invitationView.QRImageUrl = self.obj.retData.activityQrCode;
    self.invitationView.QRCurrentImage = self.QRImageView;
    [self.invitationView refershInvitationView];
    [self.contentView addSubview:self.invitationView];
}

#pragma mark - InvitationViewDelegate
- (void) hiddenCurrentInvitationView{
    
    [self refreshLoadMessageOfVC];
    [self.invitationView removeFromSuperview];
    
}

- (void) saveCurrentInvitationView:(NSString *) str{
    
    if ([str hasSuffix:@"成功"]) {
        [self showSuccessTemporaryMes:str];
    }else{
        
        [self showFailTemporaryMes:str];
    }
    
    [self refreshLoadMessageOfVC];

    [self.invitationView removeFromSuperview];

}

- (void) shareCurrentInvitationView:(NSString *)str{
    
    if ([str hasSuffix:@"成功"]) {
        [self showSuccessTemporaryMes:str];
    }else{
        
        [self showFailTemporaryMes:str];
    }
    [self refreshLoadMessageOfVC];
    [self.invitationView removeFromSuperview];

}

#pragma mark z邀请函页面消失后刷新页面
- (void)refreshLoadMessageOfVC {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self loadMessageOfVC];
    
}

#pragma mark CMLSubscribeDefaultVCDelegate
- (void)refreshCurrentVC {
    [self refreshLoadMessageOfVC];
}

- (void)enterCenterOrderVC {
    
    CMLSubscribeDefaultVC *vc = [[CMLSubscribeDefaultVC alloc] initWithOrderId:self.orderID isDeleted:[NSNumber numberWithInt:1]];/*直接传1：未删除*/
    vc.delegate = self;
    vc.orderSuccess = [NSNumber numberWithInt:1];/*1:预订成功后跳转*/
    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
