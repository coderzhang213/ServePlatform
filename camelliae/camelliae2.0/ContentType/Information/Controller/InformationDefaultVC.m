//
//  InformationDefaultVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "InformationDefaultVC.h"
#import "VCManger.h"
#import "MoreMesView.h"
#import "DefaultTransition.h"
#import "CustomTransition.h"
#import "WKWebView+CMLExspand.h"
#import "InformationWkView.h"
#import "InformationHeaderView.h"

#define InformationDefaultVCLeftMargin            20
#define InformationDefaultVCNameTopMargin         30
#define InformationDefaultVCNameBottomMargin      20
#define InformationDefaultVCNumLabelBottomMargin  40


@interface InformationDefaultVC ()<NetWorkProtocol,UINavigationBarDelegate,UIScrollViewDelegate,InformationHeaderDelegate>

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *contentHeaderView;

@property (nonatomic,strong) MoreMesView *moreMesView;

@property (nonatomic,assign) CGFloat cuurentOffSet;

@property (nonatomic,assign) BOOL headerIsHidden;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) CGFloat currentOffSetY;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) InformationHeaderView *informationHeaderView;

@end

@implementation InformationDefaultVC

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
    
    [MobClick beginLogPageView:@"PageThreeOfInformationDefaultVC"];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    
    [MobClick endLogPageView:@"PageThreeOfInformationDefaultVC"];
    
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
    [NetWorkTask postResquestWithApiName:NewsInfo paraDic:paraDic delegate:delegate];
    self.currentApiName = NewsInfo;
    
    [self startLoading];
    
}
- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         NavigationBarHeight + StatusBarHeight,
                                                                         WIDTH,
                                                                         HEIGHT - NavigationBarHeight - StatusBarHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
   
}

- (void) setCurrentVCHeaderView{
    
    if ([self.obj.retData.totalAmount intValue] == 0) {
     
        self.informationHeaderView = [[InformationHeaderView alloc] initWith:self.obj];
        self.informationHeaderView.frame = CGRectMake(0,
                                                      StatusBarHeight,
                                                      WIDTH,
                                                      NavigationBarHeight);
        
        __weak typeof(self) weakSelf = self;
        self.informationHeaderView.shareBlock = ^(){
            
            [weakSelf showCurrentVCShareView];
            
        };
        self.informationHeaderView.delegate = self;
        [self.view addSubview:self.informationHeaderView];
    }else{
    
        UIButton *backbtn = [[UIButton alloc] init];
        [backbtn setImage:[UIImage imageNamed:PrefectureInfoBackImg] forState:UIControlStateNormal];
        [backbtn sizeToFit];
        backbtn.frame =CGRectMake(30*Proportion,
                                  StatusBarHeight,
                                  backbtn.frame.size.width,
                                  backbtn.frame.size.height);
        [self.view addSubview:backbtn];
        [backbtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shareBtn = [[UIButton alloc] init];
        [shareBtn setImage:[UIImage imageNamed:PrefectureInfoShareImg] forState:UIControlStateNormal];
        [shareBtn sizeToFit];
        shareBtn.frame =CGRectMake(WIDTH - shareBtn.frame.size.width - 30*Proportion,
                                   StatusBarHeight,
                                   shareBtn.frame.size.width,
                                   shareBtn.frame.size.height);
        [self.view addSubview:shareBtn];
        
        [shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void) setContentHeaderView{

    /**设置头部内容*/
    self.contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      WIDTH,
                                                                      1000)];

    [self.mainScrollView addSubview:self.contentHeaderView];
    self.contentHeaderView.backgroundColor = [UIColor whiteColor];
    
    if ([self.obj.retData.totalAmount intValue] == 0) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = KSystemBoldFontSize18;
        nameLabel.textColor = [UIColor CMLUserBlackColor];
        nameLabel.text = self.obj.retData.title;
        nameLabel .numberOfLines = 0;
        
        CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 2*InformationDefaultVCLeftMargin*Proportion ,1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:KSystemBoldFontSize18}
                                                       context:nil];
        nameLabel.frame = CGRectMake(InformationDefaultVCLeftMargin*Proportion,
                                     InformationDefaultVCNameTopMargin*Proportion,
                                     WIDTH - 2*InformationDefaultVCLeftMargin*Proportion,
                                     nameRect.size.height);
        [self.contentHeaderView addSubview:nameLabel];
        
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.font = KSystemFontSize12;
        numLabel.textColor = [UIColor CMLtextInputGrayColor];
        numLabel.text = [NSString stringWithFormat:@"收藏 %@ · 浏览 %@",self.obj.retData.favNum,self.obj.retData.hitNum];
        [numLabel sizeToFit];
        numLabel.frame = CGRectMake(InformationDefaultVCLeftMargin*Proportion,
                                    CGRectGetMaxY(nameLabel.frame) + InformationDefaultVCNameBottomMargin*Proportion,
                                    numLabel.frame.size.width,
                                    numLabel.frame.size.height);
        [self.contentHeaderView addSubview:numLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = self.obj.retData.publishTimeStr;
        timeLabel.font = KSystemFontSize10;
        timeLabel.textColor = [UIColor CMLLineGrayColor];
        [timeLabel sizeToFit];
        
        timeLabel.frame =CGRectMake(WIDTH - InformationDefaultVCLeftMargin*Proportion - timeLabel.frame.size.width,
                                    CGRectGetMaxY(numLabel.frame) - timeLabel.frame.size.height,
                                    timeLabel.frame.size.width,
                                    timeLabel.frame.size.height);
        [self.contentHeaderView addSubview:timeLabel];
        
        CMLLine *lineTwo = [[CMLLine alloc] init];
        lineTwo.startingPoint = CGPointMake(InformationDefaultVCLeftMargin*Proportion, CGRectGetMaxY(numLabel.frame) + InformationDefaultVCNumLabelBottomMargin*Proportion);
        lineTwo.lineWidth = 0.5;
        lineTwo.lineLength = WIDTH - 2*InformationDefaultVCLeftMargin*Proportion;
        lineTwo.LineColor = [UIColor CMLPromptGrayColor];
        lineTwo.directionOfLine = HorizontalLine;
        [self.contentHeaderView addSubview:lineTwo];
        
        self.contentHeaderView.frame = CGRectMake(0,
                                                  0,
                                                  WIDTH,
                                                  CGRectGetMaxY(numLabel.frame) + InformationDefaultVCNumLabelBottomMargin*Proportion + 0.5);

    }else{
    
        UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/3*2)];
        topImage.contentMode = UIViewContentModeScaleAspectFill;
        topImage.clipsToBounds = YES;
        [self.contentHeaderView addSubview:topImage];
        [NetWorkTask setImageView:topImage WithURL:self.obj.retData.coverPic placeholderImage:nil];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = KSystemBoldFontSize18;
        nameLabel.textColor = [UIColor CMLUserBlackColor];
        nameLabel.text = self.obj.retData.title;
        nameLabel .numberOfLines = 0;
        
        CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 2*InformationDefaultVCLeftMargin*Proportion ,1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:KSystemBoldFontSize18}
                                                       context:nil];
        nameLabel.frame = CGRectMake(InformationDefaultVCLeftMargin*Proportion,
                                     InformationDefaultVCNumLabelBottomMargin*Proportion + CGRectGetMaxY(topImage.frame),
                                     WIDTH - 2*InformationDefaultVCLeftMargin*Proportion,
                                     nameRect.size.height);
        [self.contentHeaderView addSubview:nameLabel];
        
        CMLLine *line = [[CMLLine alloc] init];
        line.startingPoint = CGPointMake(InformationDefaultVCLeftMargin*Proportion, CGRectGetMaxY(nameLabel.frame) + InformationDefaultVCNumLabelBottomMargin*Proportion);
        line.lineWidth = 0.5;
        line.lineLength = WIDTH - 2*InformationDefaultVCLeftMargin*Proportion;
        line.LineColor = [UIColor CMLPromptGrayColor];
        line.directionOfLine = HorizontalLine;
        [self.contentHeaderView addSubview:line];
        
        UILabel *promLab = [[UILabel alloc] init];
        promLab.textColor = [UIColor CMLGreeenColor];
        promLab.font = KSystemRealBoldFontSize14;
        promLab.text = @"·拍品详情·";
        [promLab sizeToFit];
        promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                   CGRectGetMaxY(nameLabel.frame) + InformationDefaultVCNumLabelBottomMargin*Proportion*2,
                                   promLab.frame.size.width,
                                   promLab.frame.size.height);
        [self.contentHeaderView addSubview:promLab];
        
        self.contentHeaderView.frame = CGRectMake(0,
                                                  0,
                                                  WIDTH,
                                                  CGRectGetMaxY(promLab.frame) + 20*Proportion);
        
    
    }
}

- (void) setMainContentView{
    
    self.informationWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
    self.informationWkView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.contentHeaderView.frame) + 20*Proportion,
                                              WIDTH,
                                              1000);
    self.informationWkView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.informationWkView];
    
    __weak typeof(self) weakSelf = self;
    self.informationWkView.loadWebViewFinish = ^(CGFloat height){
    
        weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                            weakSelf.informationWkView.frame.origin.y,
                                            WIDTH,
                                            height);
        
        [weakSelf stopLoading];
        
        [weakSelf setContentFooterView];
        
        weakSelf.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                         self.contentHeaderView.frame.size.height  + height + self.moreMesView.frame.size.height + UITabBarHeight);
    
    };

}

- (void) setContentFooterView{

    [self.moreMesView removeFromSuperview];
    
    self.moreMesView = [[MoreMesView alloc] init];
    self.moreMesView.List = self.obj.retData.recommList;
    self.moreMesView.currentClass = [NSNumber numberWithInt:1];
    self.moreMesView.isInfo = YES;
    [self.moreMesView createViews];
    self.moreMesView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.informationWkView.frame),
                                        WIDTH,
                                        self.moreMesView.currentHeight);
    [self.mainScrollView addSubview:self.moreMesView];
    
    if ([self.obj.retData.totalAmount intValue] != 0) {
        
        self.moreMesView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.informationWkView.frame),
                                            WIDTH,
                                            0);
        self.moreMesView.hidden = YES;
        
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:InformationBottomImg]];
        [bgImage sizeToFit];
        bgImage.frame = CGRectMake(0,
                                   HEIGHT - bgImage.frame.size.height,
                                   WIDTH,
                                   bgImage.frame.size.height);
        [self.view addSubview:bgImage];
        
        UIView *oldLab = [self.view viewWithTag:100];
        [oldLab removeFromSuperview];
        
        UIButton *oldBtn = [self.view viewWithTag:101];
        [oldBtn removeFromSuperview];
        
        UIView *priceBgView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                      HEIGHT - 20*Proportion - 92*Proportion,
                                                                      420*Proportion,
                                                                       92*Proportion)];
        priceBgView.backgroundColor = [UIColor CMLWhiteColor];
        priceBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        priceBgView.layer.shadowOpacity = 0.3;
        priceBgView.tag = 100;
        priceBgView.layer.shadowOffset = CGSizeMake(0, 0);
        [self.view addSubview:priceBgView];
        
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.backgroundColor = [UIColor CMLWhiteColor];
        priceLab.text = [NSString stringWithFormat:@"¥%@",self.obj.retData.totalAmount];
        priceLab.font = KSystemBoldFontSize18;
        [priceLab sizeToFit];
        priceLab.frame = CGRectMake(420*Proportion/2.0 - priceLab.frame.size.width/2.0,
                                    92*Proportion/2.0 - priceLab.frame.size.height/2.0,
                                    priceLab.frame.size.width,
                                    priceLab.frame.size.height);
        priceLab.textAlignment = NSTextAlignmentCenter;
        priceLab.textColor = [UIColor CMLBlackColor];
        [priceBgView addSubview:priceLab];
        
        
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 270*Proportion - 20*Proportion,
                                                                      HEIGHT - 20*Proportion - 92*Proportion,
                                                                      270*Proportion,
                                                                       92*Proportion)];
        [callBtn setTitle:self.obj.retData.buyInfo forState:UIControlStateNormal];
        [callBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        callBtn.backgroundColor = [UIColor CMLGreeenColor];
        callBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        callBtn.tag = 101;
        callBtn.layer.shadowOpacity = 0.3;
        callBtn.layer.shadowOffset = CGSizeMake(0, 0);
        callBtn.titleLabel.font = KSystemBoldFontSize16;
        [self.view addSubview:callBtn];
        [callBtn addTarget:self action:@selector(confirmCall) forControlEvents:UIControlEventTouchUpInside];
    }

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

            if ([self.obj.retData.totalAmount intValue] != 0) {
                
                self.mainScrollView.frame = CGRectMake(0,
                                                       0,
                                                       WIDTH,
                                                       HEIGHT);
            }
            
            [self setCurrentVCHeaderView];
            
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
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
 
    if ([self.currentApiName isEqualToString:NewsInfo]) {

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
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.cuurentOffSet = self.mainScrollView.contentOffset.y;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self.obj.retData.totalAmount intValue] == 0) {
        
        if (self.mainScrollView.contentOffset.y > 0) {
            __weak typeof(self) weakSelf = self;
            if (self.mainScrollView.contentOffset.y > self.cuurentOffSet) {
                
                if (!self.headerIsHidden) {
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        self.informationHeaderView.frame = CGRectMake(0,
                                                                      - NavigationBarHeight - StatusBarHeight,
                                                                      WIDTH,
                                                                      NavigationBarHeight);
                        self.mainScrollView.frame = CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT);
                    } completion:^(BOOL finished) {
                        
                        weakSelf.headerIsHidden = YES;
                    }];
                }
            }else{
                
                if (self.headerIsHidden) {
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.informationHeaderView.frame = CGRectMake(0,
                                                                      StatusBarHeight,
                                                                      WIDTH,
                                                                      NavigationBarHeight);
                        self.mainScrollView.frame = CGRectMake(0,
                                                               NavigationBarHeight + StatusBarHeight,
                                                               WIDTH,
                                                               HEIGHT - NavigationBarHeight - StatusBarHeight);
                    } completion:^(BOOL finished) {
                        weakSelf.headerIsHidden = NO;
                    }];
                }
            }
        }else{
            
            if (self.headerIsHidden) {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.informationHeaderView.frame = CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  NavigationBarHeight);
                    self.mainScrollView.frame = CGRectMake(0,
                                                           NavigationBarHeight + StatusBarHeight,
                                                           WIDTH,
                                                           HEIGHT - NavigationBarHeight - StatusBarHeight);
                } completion:^(BOOL finished) {
                    weakSelf.headerIsHidden = NO;
                }];
                
            }
        }
    }
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

#pragma mark - InformationHeaderDelegate
- (void) informationFavSuccess:(NSString *) str{

    [self showSuccessTemporaryMes:str];

}

- (void) informationFavError:(NSString *) str{

    [self showFailTemporaryMes:str];
}

- (void) backVC{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) confirmCall{
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.obj.retData.officialMobile]]];
}

@end
