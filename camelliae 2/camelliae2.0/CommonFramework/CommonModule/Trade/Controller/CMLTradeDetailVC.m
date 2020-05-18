//
//  CMLTradeDetailVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/3.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLTradeDetailVC.h"
#import "VCManger.h"
#import "DefaultTransition.h"
#import "CustomTransition.h"
#import "WKWebView+CMLExspand.h"
#import "InformationWkView.h"
#import "InformationHeaderView.h"
#import "TradeTopImagesView.h"

#define TradeVCLeftMargin            20
#define TradeVCNameTopMargin         30
#define TradeVCNameBottomMargin      20
#define TradeVCNumLabelBottomMargin  40


@interface CMLTradeDetailVC ()<NetWorkProtocol,UINavigationBarDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) InformationWkView *TradeWkView;

@property (nonatomic,strong) TradeTopImagesView *tradeTopImagesView;

@property (nonatomic,strong) UIView *detailTopMessageView;

@end

@implementation CMLTradeDetailVC

- (instancetype)initWithObjId:(NSNumber *)objId{
    
    self = [super init];
    
    if (self) {
        
        self.objId = objId;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarHidden = YES;
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
    [NetWorkTask postResquestWithApiName:NewsInfo paraDic:paraDic delegate:delegate];
    self.currentApiName = NewsInfo;
    
    [self startLoading];
    
}
- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
    /**FooterView*/
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH - NavigationBarHeight*3,
                                                            StatusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UITapGestureRecognizer *doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [view addGestureRecognizer:doubleRecognizer];
    
}


- (void) setContentHeaderView{
    
    self.detailTopMessageView = [[UIView alloc] init];
    self.detailTopMessageView.backgroundColor = [UIColor clearColor];
    
    /**轮播图*/
    self.tradeTopImagesView = [[TradeTopImagesView alloc] initWithImageurlArray:[NSArray array]];
    self.tradeTopImagesView.frame = CGRectMake(0,
                                               0,
                                               self.tradeTopImagesView.viewWidth,
                                               self.tradeTopImagesView.viewHeight);
    [self.detailTopMessageView addSubview:self.tradeTopImagesView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemBoldFontSize18;
    titleLab.textColor = [UIColor CMLUserBlackColor];
    titleLab.text = self.obj.retData.title;
    titleLab .numberOfLines = 0;
    titleLab.text = @"test test set set";
    CGRect titleRect =  [titleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 20*Proportion*2, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:KSystemBoldFontSize18}
                                                    context:nil];
    titleLab.frame = CGRectMake(20*Proportion,
                                30*Proportion + CGRectGetMaxY(self.tradeTopImagesView.frame),
                                WIDTH - 20*Proportion*2,
                                titleRect.size.height);
    [self.detailTopMessageView addSubview:titleLab];
    
    self.detailTopMessageView.frame = CGRectMake(0,
                                                 0,
                                                 WIDTH,
                                                 CGRectGetMaxY(titleLab.frame) + 30*Proportion);
    
    [self.mainScrollView addSubview:self.detailTopMessageView];
}

- (void) setMainContentView{
    
    self.TradeWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
    self.TradeWkView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.detailTopMessageView.frame) + 20*Proportion,
                                        WIDTH,
                                        1000);
    self.TradeWkView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.TradeWkView];
    
    __weak typeof(self) weakSelf = self;
    self.TradeWkView.loadWebViewFinish = ^(CGFloat height){
        
        weakSelf.TradeWkView.frame = CGRectMake(weakSelf.TradeWkView.frame.origin.x,
                                                weakSelf.TradeWkView.frame.origin.y,
                                                WIDTH,
                                                height);
        
        [weakSelf stopLoading];
        
        
        weakSelf.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                         self.detailTopMessageView.frame.size.height + height + UITabBarHeight + SafeAreaBottomHeight);
        
    };
    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewsInfo]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**打点*/
            [CMLMobClick informationEventWithType:obj.retData.subTypeName];
            
            self.currentID = obj.retData.currentID;
            
            /**设置标头*/
            [self setContentHeaderView];
            
            /**主要内容*/
            [self setMainContentView];
            
            /**分享内容处理*/
            [NSThread detachNewThreadSelector:@selector(setShareMes) toTarget:self withObject:nil];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            
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
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewsInfo]) {
        
        [self showNetErrorTipOfNormalVC];
        
       
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

@end
