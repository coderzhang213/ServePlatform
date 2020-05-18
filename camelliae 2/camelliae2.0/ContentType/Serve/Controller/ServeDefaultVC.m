//
//  ServeDefaultVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/4.
//  Copyright © 2016年 张越. All rights reserved.
//  服务详情

#import "ServeDefaultVC.h"
#import "VCManger.h"
#import "WebViewLinkVC.h"
#import "NSString+CMLExspand.h"
#import "DefaultTransition.h"
#import "CustomTransition.h"
#import "ServeTopMessageView.h"
#import "ServeFooterView.h"
#import "CMLNewAssociatedProductsView.h"
#import "ServeHeaderView.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLRecommendOfDetailView.h"
#import "RecommendInfo.h"
#import "CMLCurrentBrandView.h"
#import "CMLCommodityPayMessageVC.h"
#import "CMLALLRecommendVC.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"
#import "UITextView+Placeholder.h"
#import "CMLContentModuleView.h"
#import "CMLScrollSelectView.h"
#import "AppDelegate.h"
#import "CMLCanGetCouponView.h"

#define CommemtListVCTextInputTopMargin    40
#define CommemtListVCTextInputLeftMargin   30
#define CommemtListVCTextInputBtnTopMargin 26


@interface ServeDefaultVC ()<NetWorkProtocol,UIScrollViewDelegate,UIScrollViewDelegate,UINavigationBarDelegate,ServeFooterDelegate,ServeHeaderDelegate,UITextViewDelegate,CMLRecommendOfDetailViewDelegate,ServeTopMessageViewDelegate,CMLContentModuleViewDelegate,CMLNewAssociatedProductsViewDelegate,CMLScrollSelectViewDelegate, CMLCanGetCouponViewDelegate>


@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,assign) BOOL footerIsHidden;

@property (nonatomic,assign) CGFloat cuurentOffSet;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) CGFloat currentOffSetY;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,assign) BOOL isInput;


/***********************************************/

@property (nonatomic,strong) BaseResultObj *obj;

/**topMessage*/
@property (nonatomic,strong) ServeTopMessageView *topMessageView;

@property (nonatomic,strong) ServeFooterView *serveFooterView;

@property (nonatomic,strong) CMLNewAssociatedProductsView *associateProductView;

@property (nonatomic,strong) CMLContentModuleView *productWebView;

@property (nonatomic,strong) CMLContentModuleView *brandStoryWebView;

@property (nonatomic,strong) CMLContentModuleView *productPriceWebView;

@property (nonatomic,strong) ServeHeaderView *detailHeaderView;

@property (nonatomic,strong) CMLRecommendOfDetailView *recommendUserView;

@property (nonatomic,strong) CMLCurrentBrandView *currentBrandView;

@property (nonatomic,strong) CMLScrollSelectView *topScrollSelectView;

@property (nonatomic,strong) UIView *commentInputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIButton *pushBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIView *shadowView;

/**************************/

@property (nonatomic,assign) CGFloat productDetailY;

@property (nonatomic,assign) CGFloat priceY;

@property (nonatomic,assign) CGFloat recommedY;

/**************************/
@property (nonatomic, strong) CMLCanGetCouponView *canGetCouponView;

@property (nonatomic, strong) UIView *shadowTwoView;

@end

@implementation ServeDefaultVC

- (instancetype)initWithObjId:(NSNumber *)objId{
    
    self = [super init];
    if (self) {
        self.objId = objId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    //分享页面关闭
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCurrentView)
                                                 name:@"refershServeView"
                                               object:nil];
    
    [MobClick beginLogPageView:@"PageThreeOfServeDefaultVC"];
    
}

#pragma mark - 离开页面移除通知
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refershServeView" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [MobClick endLogPageView:@"PageThreeOfServeDefaultVC"];
    
    [self.recommendUserView stopVideo];
    
    [self.topMessageView removeVideo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.hidden = YES;
    self.footerIsHidden = NO;
    
    [self loadMessageOfVC];
    
    /**刷新*/
    __weak typeof(self) weakSlef = self;
    self.refreshViewController = ^(){
    
        [weakSlef hideNetErrorTipOfNormalVC];
        [weakSlef loadMessageOfVC];
    
    };
    
}

- (void) loadMessageOfVC{

    [self setNetWork];
    
}

- (void) setNetWork{
    
    [self startLoading];
    
    /**request*/
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [paraDic setObject:[NSNumber numberWithInt:[appDelegate.pid intValue]] forKey:@"pId"];
    
    [NetWorkTask getRequestWithApiName:ProjectInfo param:paraDic delegate:delegate];
    self.currentApiName = ProjectInfo;

}


- (void) loadViews{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT - SafeAreaBottomHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
    /**设置头部内容*/
    self.topMessageView = [[ServeTopMessageView alloc] initWith:self.obj];
    self.topMessageView.frame = CGRectMake(0,
                                           0,
                                           WIDTH,
                                           self.topMessageView.currentHeight);
    self.topMessageView.delegate = self;
    [self.mainScrollView addSubview:self.topMessageView];
    
    /*推荐人*/
    self.recommendUserView = [[CMLRecommendOfDetailView alloc] initWith:self.obj];
    self.recommendUserView.delegate = self;
    self.recommendUserView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.topMessageView.frame),
                                              WIDTH,
                                              self.recommendUserView.currentHeight);
    [self.mainScrollView addSubview:self.recommendUserView];
    
    /*来自品牌*/
    self.currentBrandView = [[CMLCurrentBrandView alloc] initWith:self.obj];
    self.currentBrandView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.recommendUserView.frame),
                                              WIDTH,
                                              self.currentBrandView.currentHeight);
    [self.mainScrollView addSubview:self.currentBrandView];
    
    
    /**设置主要内容web*/
    [self setMainContentView];
    
    /*返回-唤起服务电话-收藏*/
    self.detailHeaderView = [[ServeHeaderView alloc] initWith:self.obj];
    self.detailHeaderView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             NavigationBarHeight + StatusBarHeight);
    self.detailHeaderView.delegate = self;
    self.detailHeaderView.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0];
    [self.contentView addSubview:self.detailHeaderView];
    
    /*商品-详情-价格*/
    self.topScrollSelectView = [[CMLScrollSelectView alloc] initWith:self.obj];
    self.topScrollSelectView.delegate = self;
    self.topScrollSelectView.alpha = 0;
    self.topScrollSelectView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.detailHeaderView.frame),
                                                WIDTH,
                                                self.topScrollSelectView.currentHeight);
    [self.contentView addSubview:self.topScrollSelectView];
    [self.contentView bringSubviewToFront:self.topScrollSelectView];

    /**底部预定状态*/
    self.serveFooterView = [[ServeFooterView alloc] initWith:self.obj];
    self.serveFooterView.backgroundColor = [UIColor CMLWhiteColor];
    self.serveFooterView.frame = CGRectMake(0,
                                            self.contentView.frame.size.height - self.serveFooterView.currentHeight,
                                            WIDTH,
                                            self.serveFooterView.currentHeight);
    self.serveFooterView.delegate = self;
    [self.contentView addSubview:self.serveFooterView];
    
    
    /**shadowView*/
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.alpha = 0;
    [self.contentView addSubview:self.shadowView];
    
    self.shadowTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  HEIGHT)];
    self.shadowTwoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowTwoView.alpha = 0;
    [self.contentView addSubview:self.shadowTwoView];
    
    /**输入底板*/
    self.commentInputView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     HEIGHT,
                                                                     WIDTH,
                                                                     HEIGHT/4)];
    self.commentInputView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.commentInputView];
    
    /**双击头部回滚*/
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


- (void) setMainContentView{

    self.productWebView = [[CMLContentModuleView alloc] initWith:self.obj andType:productDetail];
    self.productWebView.delegate = self;
    self.productWebView.hidden = YES;
    [self.mainScrollView addSubview:self.productWebView];

}


#pragma mark - dismissCurrentVC
- (void) dismissCurrentVC{

    [[VCManger mainVC] dismissCurrentVC];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.pid = @"0";
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:ProjectInfo]) {
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {

            /**打点*/
            [CMLMobClick serveEventWithType:obj.retData.subTypeName parentType:obj.retData.parentTypeName];
            
            self.currentID = obj.retData.currentID;
            
            [self loadViews];
            /************shareMes**************/
            [NSThread detachNewThreadSelector:@selector(setShareMes) toTarget:self withObject:nil];
            /************************/
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            ServeHeaderView *detailHeaderView = [[ServeHeaderView alloc] initWith:nil];
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
    
    }else if ([self.currentApiName isEqualToString:MailPostCommend]){
        
        [CMLMobClick Recommending];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        
        if ([obj.retCode intValue] == 0) {
            
            [self.recommendUserView refreshCurrentRecommendView:self.textView.text];
            
            if (self.obj.retData.recommendInfo.dataList.count == 0) {
                
                self.recommendUserView.frame = CGRectMake(self.recommendUserView.frame.origin.x,
                                                          self.recommendUserView.frame.origin.y,
                                                          self.recommendUserView.frame.size.width,
                                                          self.recommendUserView.currentHeight);
                
                self.productWebView.frame = CGRectMake(self.currentBrandView.frame.origin.x,
                                                         CGRectGetMaxY(self.recommendUserView.frame),
                                                         self.currentBrandView.frame.size.width,
                                                         self.currentBrandView.currentHeight);
                
                self.productPriceWebView.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.currentBrandView.frame),
                                                            WIDTH,
                                                            self.productPriceWebView.currentHeight);
                
                self.brandStoryWebView.frame = CGRectMake(0,
                                                          CGRectGetMaxY(self.productPriceWebView.frame),
                                                          WIDTH,
                                                          self.brandStoryWebView.currentHeight);
                
                self.associateProductView.frame = CGRectMake(0,
                                                             CGRectGetMaxY(self.brandStoryWebView.frame),
                                                             WIDTH,
                                                             self.associateProductView.currentHeight);
                self.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                             CGRectGetMaxY(self.associateProductView.frame) + 80*Proportion + UITabBarHeight + SafeAreaBottomHeight);
                
                self.productDetailY = CGRectGetMaxY(self.currentBrandView.frame) - 207*Proportion;
                self.priceY = CGRectGetMaxY(self.productWebView.frame) - 207*Proportion;
                self.recommedY = CGRectGetMaxY(self.productPriceWebView.frame) - 207*Proportion;
                
            }
            
        }else{
            
            [self showFailMessage:obj.retMsg];
        }
        
        [self cancelComment];
        [self stopIndicatorLoading];
        
    }else if ([self.currentApiName isEqualToString:MailAddCar]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        [self stopIndicatorLoading];
        
        if ([obj.retCode intValue] == 0) {
            
            [self showSuccessTemporaryMes:@"加入购物车"];
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }

    
    [self hideNetErrorTipOfNormalVC];

}


- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
   
    if ([self.currentApiName isEqualToString:ProjectInfo]) {
       
        [self showNetErrorTipOfNormalVC];
    }
    
    [self hiddenShadowView];
    [self stopIndicatorLoading];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];

}

#pragma mark - showShareView
- (void) showShareView{
    
    [self showCurrentVCShareView];
}

#pragma mark - showShadowView
- (void) showShadowView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
    }];
}

#pragma mark - hiddenShadowView
- (void) hiddenShadowView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
}


- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:3],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}


- (void) handleDoubleTapFrom{
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - cancelAppointment
- (void) closeAppointmentView{

    [self hiddenShadowView];
    
}



#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.cuurentOffSet = self.mainScrollView.contentOffset.y;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.mainScrollView.contentOffset.y > 0) {
     __weak typeof(self) weakSelf = self;
        if (self.mainScrollView.contentOffset.y > self.cuurentOffSet) {
            
            if (!self.footerIsHidden) {
                
                [UIView animateWithDuration:0.25 animations:^{

                    self.serveFooterView.frame = CGRectMake(0,
                                                            HEIGHT,
                                                            WIDTH,
                                                            self.serveFooterView.frame.size.height);
                } completion:^(BOOL finished) {
                    weakSelf.footerIsHidden = YES;
                }];
            }
            
        }else{
            
            if (self.footerIsHidden) {
                [UIView animateWithDuration:0.25 animations:^{

                    self.serveFooterView.frame = CGRectMake(0,
                                                            self.contentView.frame.size.height - self.serveFooterView.frame.size.height,
                                                            WIDTH,
                                                            self.serveFooterView.frame.size.height);
                } completion:^(BOOL finished) {
                    weakSelf.footerIsHidden = NO;
                }];
            }
        }
        
        /***/
        if (self.mainScrollView.contentOffset.y > 500*Proportion) {
            
            
            self.detailHeaderView.backgroundColor = [UIColor CMLWhiteColor];
            self.topScrollSelectView.alpha = 1;
            
            if (!self.topScrollSelectView.isTouch) {
             
                if (self.mainScrollView.contentOffset.y > self.productDetailY && self.mainScrollView.contentOffset.y <= self.priceY) {
                    
                    [self.topScrollSelectView refreshScrollSelectViewWith:1];
                }else if (self.mainScrollView.contentOffset.y <= self.recommedY && self.mainScrollView.contentOffset.y > self.priceY){
                    
                    [self.topScrollSelectView refreshScrollSelectViewWith:2];
                    
                }else if (self.mainScrollView.contentOffset.y > self.recommedY){
                    
                    [self.topScrollSelectView refreshScrollSelectViewWith:3];
                }
                
            }
            
        }else{
            
            self.detailHeaderView.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:self.mainScrollView.contentOffset.y/(500*Proportion)];
            self.topScrollSelectView.alpha = self.mainScrollView.contentOffset.y/(500*Proportion);
            self.detailHeaderView.titleLab.alpha = self.mainScrollView.contentOffset.y/(500*Proportion);
            [self.topScrollSelectView refreshScrollSelectViewWith:0];
            

        }
    }
    
    if (self.mainScrollView.contentOffset.y == 0) {
        
        self.topScrollSelectView.alpha = 0;
        self.detailHeaderView.titleLab.alpha = 0;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.topScrollSelectView.isTouch = NO;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return [CustomTransition transitionWith:PushCustomTransition];
        
    }else{
        
        return [DefaultTransition transitionWith:PopDefaultTransition];
    }
}


#pragma mark - setShareMes
- (void) setShareMes{


    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    /********shareblock********/
    __weak typeof(self) weakSelf = self;
    
    self.baseShareTitle = self.obj.retData.title;
    self.baseShareContent = self.obj.retData.briefIntro;
    self.baseShareImage = image;
    self.baseShareLink = self.obj.retData.shareLink;
    self.shareSuccessBlock = ^(){
        
        [weakSelf sendShareAction];
    };
    
    self.sharesErrorBlock = ^(){
        
    };
}

#pragma mark - ServeFooterDelegate
- (void) progressSuccessWith:(NSString *)str{

    [self showSuccessTemporaryMes:str];
}

- (void) progressErrorWith:(NSString *)str{

    [self showFailTemporaryMes:str];
}

- (void) showProjectMessage{
    
    if ([self.obj.retData.is_video_project intValue] == 1) {
        
        if ([self.obj.retData.is_buy intValue] != 1) {
            
            CMLCommodityPayMessageVC *vc = [[CMLCommodityPayMessageVC alloc] init];
            vc.buyNum = 1;
            vc.obj = self.obj;
            vc.parentType = [NSNumber numberWithInt:3];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
        
    }else{
    
        if ([self.obj.retData.sysApplyStatus intValue] == 5) {
            
            WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
            vc.url = self.obj.retData.actionViewLink;
            vc.isDetailMes = YES;
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
            /*商品/服务支付页面*/
            CMLCommodityPayMessageVC *vc = [[CMLCommodityPayMessageVC alloc] init];
            vc.buyNum = 1;
            vc.obj = self.obj;
            vc.parentType = [NSNumber numberWithInt:3];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }
        
    }
    
}

- (void) addSBCar{
    
    
    if ([self.obj.retData.is_video_project intValue] == 1) {
     
        if ([self.obj.retData.is_buy intValue] != 1) {
            
            [self addSBCarRequest];
        }else{
            
            [self showFailTemporaryMes:@"该视频服务您已购买"];
        };
    }else{
        
        [self addSBCarRequest];
        
    }
    
    
}

#pragma mark - ServeHeaderDelegate

- (void) showDetailShareMessage{

    [self showShareView];
}

- (void) dissCurrentDetailVC{

    [[VCManger mainVC] dismissCurrentVC];
    
    
}

/*************/
#pragma mark - CMLContentModuleViewDelegate

- (void) finshLoadDetailView:(ContentType) currentType{
    
    if (currentType == productDetail) {
        
        self.productWebView.hidden = NO;
        self.productWebView.frame = CGRectMake(0,
                                               CGRectGetMaxY(self.currentBrandView.frame),
                                               WIDTH,
                                               self.productWebView.currentHeight);
        
        self.productDetailY = CGRectGetMaxY(self.currentBrandView.frame) - 207*Proportion;
        
        self.productPriceWebView = [[CMLContentModuleView alloc] initWith:self.obj andType:costDetail];
        self.productPriceWebView.delegate = self;
        self.productPriceWebView.hidden = YES;
        [self.mainScrollView addSubview:self.productPriceWebView];
        
    }else if (currentType == costDetail){
        
        self.productPriceWebView.hidden = NO;
        self.productPriceWebView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.productWebView.frame),
                                                    WIDTH,
                                                    self.productPriceWebView.currentHeight);
        
        self.priceY = CGRectGetMaxY(self.productWebView.frame) - 207*Proportion;
        self.recommedY = CGRectGetMaxY(self.productPriceWebView.frame) - 207*Proportion;
        
        self.brandStoryWebView = [[CMLContentModuleView alloc] initWith:self.obj andType:brandStory];
        self.brandStoryWebView.delegate = self;
        self.brandStoryWebView.hidden = YES;
        [self.mainScrollView addSubview:self.brandStoryWebView];


    }else if (currentType == brandStory){
        
        [self stopLoading];
        self.brandStoryWebView.hidden = NO;
        self.brandStoryWebView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.productPriceWebView.frame),
                                                    WIDTH,
                                                    self.brandStoryWebView.currentHeight);
        
        self.associateProductView = [[CMLNewAssociatedProductsView alloc] initWith:self.obj];
        self.associateProductView.delegate = self;
        self.associateProductView.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.brandStoryWebView.frame),
                                                     WIDTH,
                                                     self.associateProductView.currentHeight);
        
        
        [self.mainScrollView addSubview:self.associateProductView];
        
        self.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                     CGRectGetMaxY(self.associateProductView.frame) + 80*Proportion + UITabBarHeight + SafeAreaBottomHeight);
        
    }
}




#pragma mark - CMLNewAssociatedProductsViewDelegate

- (void) changeShowView{

    self.associateProductView.frame = CGRectMake(0,
                                                 CGRectGetMaxY(self.brandStoryWebView.frame),
                                                 WIDTH,
                                                 self.associateProductView.currentHeight);
    self.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                 CGRectGetMaxY(self.associateProductView.frame) + 80*Proportion + UITabBarHeight + SafeAreaBottomHeight);
}

/******/
- (void) setCommentTextView{
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                                                 CommemtListVCTextInputTopMargin*Proportion,
                                                                 WIDTH - CommemtListVCTextInputLeftMargin*Proportion*2,
                                                                 200*Proportion)];
    self.textView.font = KSystemFontSize12;
    self.textView.textColor = [UIColor CMLBlackColor];
//    self.textView.placeholder = @"请输入您的推荐语，250字以内";
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入您的推荐语，250字以内" attributes:@{NSForegroundColorAttributeName : [UIColor CMLPromptGrayColor]}];
    self.textView.attributedPlaceholder = placeholderAtt;
    
    self.textView.backgroundColor = [UIColor CMLWhiteColor];
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    [self.commentInputView addSubview:self.textView];
    
    self.pushBtn = [[UIButton alloc] init];
    [self.pushBtn setTitle:@"确认推荐" forState:UIControlStateNormal];
    [self.pushBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.pushBtn.titleLabel.font = KSystemFontSize14;
    [self.pushBtn addTarget:self action:@selector(pushComment) forControlEvents:UIControlEventTouchUpInside];
    [self.pushBtn sizeToFit];
    self.pushBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) - self.pushBtn.frame.size.width,
                                    CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                    self.pushBtn.frame.size.width,
                                    self.pushBtn.frame.size.height);
    [self.commentInputView addSubview:self.pushBtn];
    
    
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = KSystemFontSize14;
    [self.cancelBtn addTarget:self action:@selector(cancelComment) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn sizeToFit];
    self.cancelBtn.frame = CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                      CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                      self.cancelBtn.frame.size.width,
                                      self.cancelBtn.frame.size.height);
    [self.commentInputView addSubview:self.cancelBtn];
    
    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             self.commentInputView.frame.origin.y,
                                             self.commentInputView.frame.size.width,
                                             CGRectGetMaxY(self.cancelBtn.frame) + CommemtListVCTextInputBtnTopMargin*Proportion);
    [self.textView becomeFirstResponder];
    
    
}

#pragma mark - showCommentView
- (void) showCommentView{
    
    [self setCommentTextView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

- (void) removeCommentTextView{
    
    [self.textView removeFromSuperview];
    [self.pushBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification *) noti{
    
    
    NSDictionary *info = [noti userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             HEIGHT -  (self.commentInputView.frame.size.height + keyboardSize.height),
                                             self.commentInputView.frame.size.width,
                                             self.commentInputView.frame.size.height);
    
}

#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden:(NSNotification *) noti{
    
    if (!self.isInput) {
     
        self.commentInputView.frame = CGRectMake(0,
                                                 HEIGHT,
                                                 self.commentInputView.frame.size.width,
                                                 self.commentInputView.frame.size.height);
        [self removeCommentTextView];
        
    }else{
        
        self.isInput = NO;
    }
}

#pragma mark - pushComment
- (void) pushComment{
    
    if (self.textView.text.length > 0) {
        
        if (self.textView.text.length >= 250) {
            
            self.isInput = YES;
            [self showFailTemporaryMes:@"请精简您的输入内容至250字"];
            
        }else{
            
            [self setPostCommentRequest];
        }
        
        
    }else{
        self.isInput = YES;
        [self showFailTemporaryMes:@"请输入推荐内容"];
    }
}

- (void) cancelComment{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

- (void) setPostCommentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objType"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.textView.text forKey:@"detail"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:3],reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:MailPostCommend paraDic:paraDic delegate:delegate];
    self.currentApiName = MailPostCommend;
    
    [self startIndicatorLoading];
    
}

#pragma mark - CMLRecommendOfDetailViewDelegate
- (void) showWriteView{
    
    [self setCommentTextView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
    }];
}

- (void) showFailMessage:(NSString *) mes{
    
    [self showFailTemporaryMes:mes];

}

- (void) enterRecommendVC{
    
    CMLALLRecommendVC *vc = [[CMLALLRecommendVC alloc] initWIthBrandID:self.objId
                                                               andType:[NSNumber numberWithInt:3]];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) addSBCarRequest{
    
    PackDetailInfoObj *obj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    [paraDic setObject:self.obj.retData.brandId forKey:@"brandId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objType"];
    [paraDic setObject:obj.currentID forKey:@"packageId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"goodsNum"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                           self.objId,
                                                           [NSNumber numberWithInt:3],
                                                           obj.currentID,
                                                           reqTime,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:MailAddCar paraDic:paraDic delegate:delegate];
    self.currentApiName = MailAddCar;
    [self startIndicatorLoading];
}

- (void) refreshCurrentView{
    
    [self loadMessageOfVC];
}

- (void) showErrorWith:(NSString *)str{
    
    [self showFailTemporaryMes:str];
}

#pragma mark - CMLScrollSelectViewDelegate
- (void) scrollTag:(int) currentTag{
    
    self.topScrollSelectView.isTouch = YES;
    if (currentTag == 0) {
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.detailHeaderView.backgroundColor = [[UIColor CMLWhiteColor] colorWithAlphaComponent:0];
        self.topScrollSelectView.alpha = 0;
    }else if (currentTag == 1){

        [self.mainScrollView setContentOffset:CGPointMake(0, self.productDetailY) animated:YES];
        
    }else if (currentTag == 2){
        
        [self.mainScrollView setContentOffset:CGPointMake(0, self.priceY) animated:YES];

        
    }else if (currentTag == 3){
        
     [self.mainScrollView setContentOffset:CGPointMake(0, self.recommedY) animated:YES];
    }
    
}

#pragma mark - ServeTopMessageViewDelegate
- (void)showCanGetCouponViewOfServeTopMessageViewWith:(BaseResultObj *)obj {
    
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
