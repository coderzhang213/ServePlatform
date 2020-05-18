//
//  CMLCommodityDetailMessageVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommodityDetailMessageVC.h"
#import "VCManger.h"
#import "DefaultTransition.h"
#import "CustomTransition.h"
#import "WKWebView+CMLExspand.h"
#import "InformationWkView.h"
#import "CMLPicObjInfo.h"
#import "CMLCommodityPayMessageVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "GoodsAttributeView.h"
#import "CMLCommodityTopView.h"
#import "ServeFooterView.h"
#import "ServeHeaderView.h"
#import "CMLRecommendOfDetailView.h"
#import "RecommendInfo.h"
#import "CMLCurrentBrandView.h"
#import "CMLALLRecommendVC.h"
#import "UITextView+Placeholder.h"
#import "CMLNewMoreMesView.h"
#import "NewMoreMesObj.h"
#import "AppDelegate.h"
#import "CMLCanGetCouponView.h"

#define CommodityDetailVCLeftMargin            20
#define CommodityDetailVCNumLabelBottomMargin  40
#define CommemtListVCTextInputTopMargin    40
#define CommemtListVCTextInputLeftMargin   30
#define CommemtListVCTextInputBtnTopMargin 26

@interface CMLCommodityDetailMessageVC ()<NetWorkProtocol,UINavigationBarDelegate,UIScrollViewDelegate,GoodsAttributeViewDelegate,ServeFooterDelegate,ServeHeaderDelegate,CMLRecommendOfDetailViewDelegate,UITextViewDelegate, CMLCommodityTopViewDelegate, CMLCanGetCouponViewDelegate>

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) UIView *goodsBgShadowView;

@property (nonatomic,strong) NSMutableArray *packageInfoArray;

@property (nonatomic,strong) CMLCommodityTopView *commodityTopView;

@property (nonatomic,strong) ServeFooterView *serveFooterView;

@property (nonatomic,strong) ServeHeaderView *detailHeaderView;

@property (nonatomic,strong) CMLRecommendOfDetailView *recommendUserView;

@property (nonatomic,strong) CMLCurrentBrandView *currentBrandView;

@property (nonatomic,strong) UIView *commentInputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIButton *pushBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *shadowTwoView;

@property (nonatomic,assign) BOOL isInput;

@property (nonatomic,strong) CMLNewMoreMesView *moreMesView;

@property (nonatomic, strong) CMLCanGetCouponView *canGetCouponView;

@end

@implementation CMLCommodityDetailMessageVC

- (NSMutableArray *)packageInfoArray{

    if (!_packageInfoArray) {
        
        _packageInfoArray = [NSMutableArray array];
    }
    
    return _packageInfoArray;
}

- (instancetype)initWithObjId:(NSNumber *)objId{
    
    self = [super init];
    
    if (self) {
        
        self.objId = objId;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [CMLMobClick GoodsMessage];
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
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCurrentView)
                                                 name:@"refershGoodsView"
                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refershGoodsView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.recommendUserView stopVideo];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.hidden = YES;
    
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
    
}

- (void) loadMessageOfVC{
    
    /***loadView*/
    [self loadViews];
    /**loadData*/
    [self loadData];
}

- (void) loadData{
    
    [self setNetWork];
    
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
    
    [self.mainScrollView removeFromSuperview];
    
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         NavigationBarHeight + StatusBarHeight,
                                                                         WIDTH,
                                                                         HEIGHT - NavigationBarHeight - StatusBarHeight -SafeAreaBottomHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
    self.shadowTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowTwoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowTwoView.alpha = 0;
    [self.contentView addSubview:self.shadowTwoView];
    
    
}

- (void) setCurrentVCHeaderView{
    
    self.detailHeaderView = [[ServeHeaderView alloc] initWith:self.obj];
    self.detailHeaderView.isGoods = YES;
    self.detailHeaderView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             NavigationBarHeight + StatusBarHeight);
    self.detailHeaderView.delegate = self;
    [self.contentView addSubview:self.detailHeaderView];

}

- (void) setContentHeaderView{
    
    self.commodityTopView = [[CMLCommodityTopView alloc] initWith:self.obj];
    self.commodityTopView.delegate = self;
    self.commodityTopView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             self.commodityTopView.currentHeight);
    [self.mainScrollView addSubview:self.commodityTopView];
        
    
}

/* 推荐人 */
- (void) setRecommendView{
    
    self.recommendUserView = [[CMLRecommendOfDetailView alloc] initWith:self.obj];
    self.recommendUserView.delegate = self;
    self.recommendUserView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.commodityTopView.frame),
                                              WIDTH,
                                              self.recommendUserView.currentHeight);
    [self.mainScrollView addSubview:self.recommendUserView];
}

/*来自品牌*/
- (void) setBrandView{
    
    self.currentBrandView = [[CMLCurrentBrandView alloc] initWith:self.obj];
    self.currentBrandView.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.recommendUserView.frame),
                                             WIDTH,
                                             self.currentBrandView.currentHeight);
    [self.mainScrollView addSubview:self.currentBrandView];
}

/*web详情*/
- (void) setMainContentView{
    
    self.informationWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
    self.informationWkView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.currentBrandView.frame) + 20*Proportion,
                                              WIDTH,
                                              1000);
    self.informationWkView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.informationWkView];
    /*block重置webview高度*/
    __weak typeof(self) weakSelf = self;
    self.informationWkView.loadWebViewFinish = ^(CGFloat height){
        
        weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                                      weakSelf.informationWkView.frame.origin.y,
                                                      WIDTH,
                                                      height);
        
        weakSelf.moreMesView = [[CMLNewMoreMesView alloc] initWith:weakSelf.obj.retData.RelateRecomm.dataList];
        [weakSelf.mainScrollView addSubview:weakSelf.moreMesView];
        weakSelf.moreMesView.frame = CGRectMake(0, CGRectGetMaxY(weakSelf.informationWkView.frame), WIDTH, weakSelf.moreMesView.currentHeight);
        
        
        [weakSelf stopLoading];
        
        [weakSelf setContentFooterView];
        
        weakSelf.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                         CGRectGetMaxY(weakSelf.moreMesView.frame) + self.serveFooterView.currentHeight);
        
    };
    
}

- (void) setContentFooterView{
    
    /**底部预定状态*/
    self.serveFooterView = [[ServeFooterView alloc] initWith:self.obj andGoods:YES];
    self.serveFooterView.frame = CGRectMake(0,
                                            self.contentView.frame.size.height - self.serveFooterView.currentHeight,
                                            WIDTH,
                                            self.serveFooterView.currentHeight);
    self.serveFooterView.delegate = self;
    [self.contentView addSubview:self.serveFooterView];
    
    
}

- (void) recmmendPushView{
    
    /**shadowView*/
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.alpha = 0;
    [self.contentView addSubview:self.shadowView];
    
    /**输入底板*/
    self.commentInputView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     HEIGHT,
                                                                     WIDTH,
                                                                     HEIGHT/4)];
    self.commentInputView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.commentInputView];
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GoodsDetailMessage]) {

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];

        NSLog(@"detailGoods%@", responseResult);
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            
            for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
                
                
                PackDetailInfoObj *detailObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
                
                
                if ([detailObj.surplusStock intValue] > 0) {
                    
                    [self.packageInfoArray addObject:detailObj];
                    
                }
            }

            self.currentID = obj.retData.currentID;
            
                
            self.mainScrollView.frame = CGRectMake(0,
                                                   0,
                                                   WIDTH,
                                                   HEIGHT - SafeAreaBottomHeight);
            
            /**设置标头*/
            [self setContentHeaderView];
            
            [self setRecommendView];
            
            [self setBrandView];
            
            /**主要内容*/
            [self setMainContentView];
            
            [self setCurrentVCHeaderView];
            
            [self recmmendPushView];
            
            /**分享内容处理*/
            [NSThread detachNewThreadSelector:@selector(setShareMes) toTarget:self withObject:nil];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            [self setCurrentVCHeaderView];
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
                
                self.currentBrandView.frame = CGRectMake(self.currentBrandView.frame.origin.x,
                                                         CGRectGetMaxY(self.recommendUserView.frame),
                                                         self.currentBrandView.frame.size.width,
                                                         self.currentBrandView.currentHeight);
                
                self.informationWkView.frame = CGRectMake(0,
                                                          CGRectGetMaxY(self.currentBrandView.frame),
                                                          WIDTH,
                                                      self.informationWkView.frame.size.height);
                self.mainScrollView.contentSize =   CGSizeMake(WIDTH,
                                                             CGRectGetMaxY(self.informationWkView.frame) + 80*Proportion + UITabBarHeight + SafeAreaBottomHeight);
                
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
    
    if ([self.currentApiName isEqualToString:GoodsDetailMessage]) {
        
        [self showNetErrorTipOfNormalVC];
        
        [self setCurrentVCHeaderView];
    }
    
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
}

#pragma mark - showShareView
- (void) showShareView{
    
    [self showCurrentVCShareView];
}


- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}

- (void) handleDoubleTapFrom{
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenCurrentVCShareView];
    
    if (self.shadowView.alpha == 1) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.shadowView.alpha = 0;
        }];
        
        [self removeCommentTextView];
        
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.mainScrollView){
        
        if (self.mainScrollView.contentOffset.y > WIDTH) {
            
            [self.detailHeaderView changeBtnStyleOfLight];
            
        }else{
            
            [self.detailHeaderView changeBtnStyleOfDefault];
        }
        
    }
}


#pragma mark - setShareMes
- (void) setShareMes{
    
    /************shareMes**************/
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


- (void) enterGoodsBuyMessageVC{
    
//    if (self.packageInfoArray.count >1) {
    
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
//
//    }else{
//
//        CMLCommodityPayMessageVC *vc = [[CMLCommodityPayMessageVC alloc] init];
//        vc.buyNum = 1;
//        vc.obj = self.obj;
//        vc.parentType = [NSNumber numberWithInt:7];
//        [[VCManger mainVC] pushVC:vc animate:YES];
//
//    }
    
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

    
    
    if ([self.goodsBgShadowView viewWithTag:1]) {
      
        [self closeGoodsAttributeView];
        
        CMLCommodityPayMessageVC *vc = [[CMLCommodityPayMessageVC alloc] init];
        vc.buyNum = buyNum;
        vc.obj = self.obj;
        vc.packageID = packageID;
        vc.parentType = [NSNumber numberWithInt:7];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([self.goodsBgShadowView viewWithTag:2]){
        
        [self addSBCarRequestWith:packageID andBuyNum:[NSNumber numberWithInt:buyNum]];
        [self closeGoodsAttributeView];
        
        
    }
    
}


#pragma mark - ServeFooterDelegate
- (void) progressSuccessWith:(NSString *)str{
    
    [self showSuccessTemporaryMes:str];
}

- (void) progressErrorWith:(NSString *)str{
    
    [self showFailTemporaryMes:str];
}

- (void) showProjectMessage{
    
    [self enterGoodsBuyMessageVC];
    
}

- (void) addSBCar{
    
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
    goodsAttributeView.tag = 2;
    goodsAttributeView.delegate = self;
    [self.goodsBgShadowView addSubview:goodsAttributeView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        goodsAttributeView.frame = CGRectMake(0,
                                              0,
                                              WIDTH,
                                              HEIGHT - SafeAreaBottomHeight);
    }];
    
}

#pragma mark - ServeHeaderDelegate

- (void) showDetailShareMessage{
    
    [self showShareView];
}

- (void) dissCurrentDetailVC{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.pid = @"0";
    
    [[VCManger mainVC] dismissCurrentVC];
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
                                                               andType:[NSNumber numberWithInt:7]];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - CMLCommodityTopViewDelegate
- (void)showCanGetCouponViewOfCommodityTopViewWith:(BaseResultObj *)obj {
    
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
    
    [self removeCanGetCouponView];
    
}


/******/
- (void) setCommentTextView{
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                                                 CommemtListVCTextInputTopMargin*Proportion,
                                                                 WIDTH - CommemtListVCTextInputLeftMargin*Proportion*2,
                                                                 200*Proportion)];
    self.textView.font = KSystemFontSize12;
//    self.textView.placeholder = @"请输入您的推荐语，250字以内";
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入您的推荐语，250字以内" attributes:@{NSForegroundColorAttributeName : [UIColor CMLPromptGrayColor]}];
    self.textView.attributedPlaceholder = placeholderAtt;
    self.textView.textColor = [UIColor CMLBlackColor];
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

- (void)removeCanGetCouponView {
    
    [self.canGetCouponView removeFromSuperview];
    
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
        
        if (self.textView.text.length > 250) {
            
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
    [paraDic setObject:[NSNumber numberWithInt:7] forKey:@"objType"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.textView.text forKey:@"detail"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[
                                                           self.currentID,
                                                           [NSNumber numberWithInt:7],
                                                           reqTime,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:MailPostCommend paraDic:paraDic delegate:delegate];
    self.currentApiName = MailPostCommend;
    
    [self startIndicatorLoading];
    
}

- (void) addSBCarRequestWith:(NSNumber *) packageId andBuyNum:(NSNumber *) number{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    [paraDic setObject:self.obj.retData.brandId forKey:@"brandId"];
    [paraDic setObject:[NSNumber numberWithInt:7] forKey:@"objType"];
    [paraDic setObject:packageId forKey:@"packageId"];
    [paraDic setObject:number forKey:@"goodsNum"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[number,
                                                           self.objId,
                                                           [NSNumber numberWithInt:7],
                                                           packageId,
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



@end
