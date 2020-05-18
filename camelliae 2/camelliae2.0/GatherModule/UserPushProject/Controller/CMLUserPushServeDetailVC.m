//
//  CMLUserPushServeDetailVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/17.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLUserPushServeDetailVC.h"
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
#import "CMLUserPushBuyMessageVC.h"
#import "CMLVIPNewDetailVC.h"


@interface CMLUserPushServeDetailVC ()<UIScrollViewDelegate,UIWebViewDelegate,NavigationBarProtocol,NetWorkProtocol,UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,ServeFooterDelegate>

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

@end

@implementation CMLUserPushServeDetailVC

- (instancetype)initWithObjId:(NSNumber *) currentID{
    
    self = [super init];
    if (self) {
        
        self.objId = currentID;
        [self setNetWork];
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
    
    [self loadViews];
    
}

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
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:ProjectInfo param:paraDic delegate:delegate];
    self.currentApiName = ProjectInfo;
    
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
    self.serveFooterView = [[CMLUserPushServeFooterView alloc] initWith:self.obj];
    self.serveFooterView.delegate = self;
    self.serveFooterView.frame = CGRectMake(0,
                                            HEIGHT - self.serveFooterView.currentHeight - SafeAreaBottomHeight,
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
    
}

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
                                       30*Proportion + CGRectGetMaxY(self.userBgView.frame),
                                       WIDTH - 30*Proportion*2,
                                       currentRect.size.height);
    [self.mainScrollView addSubview:articleTitleLab];
    
    UIImageView *addressImg = [[UIImageView alloc] init];
    addressImg.contentMode = UIViewContentModeScaleAspectFill;
    addressImg.image = [UIImage imageNamed:ListActivityAddressImg];
    addressImg.clipsToBounds = YES;
    [addressImg sizeToFit];
    addressImg.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(articleTitleLab.frame) + 20*Proportion,
                                  addressImg.frame.size.width,
                                  addressImg.frame.size.height);
    [self.mainScrollView addSubview:addressImg];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = [UIColor CMLtextInputGrayColor];
    addressLab.text = self.obj.retData.provinceName;
    addressLab.font = KSystemFontSize11;
    [addressLab sizeToFit];
    addressLab.frame = CGRectMake(CGRectGetMaxX(addressImg.frame) + 10*Proportion,
                                  addressImg.center.y - addressLab.frame.size.height/2.0,
                                  addressLab.frame.size.width,
                                  addressLab.frame.size.height);
    [self.mainScrollView addSubview:addressLab];
    
    self.detailView = [[UIWebView alloc] init];
    self.detailView.backgroundColor = [UIColor CMLWhiteColor];
    self.detailView.delegate = self;
    self.detailView.frame = CGRectMake(0,
                                       CGRectGetMaxY(addressLab.frame) + 50*Proportion,
                                       WIDTH,
                                       400);
    self.detailView.scrollView.scrollEnabled = NO;
    [self.detailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.obj.retData.detailUrl]]];
    [self.mainScrollView addSubview:self.detailView];
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
    
    if ([self.currentApiName isEqualToString:ProjectInfo]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        
        NSLog(@"***%@",responseResult);
        self.navBar.titleContent = self.obj.retData.title;
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self loadFooterView];
            [self loadUserMessage];
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
    
    CMLUserPushBuyMessageVC *vc = [[CMLUserPushBuyMessageVC alloc] init];
    vc.buyNum = 1;
    vc.obj = self.obj;
    vc.parentType = [NSNumber numberWithInt:3];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterUserDetailVC{
    
    CMLVIPNewDetailVC *vc  = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.retData.user.nickName
                                                           currnetUserId:self.obj.retData.user.userId
                                                      isReturnUpOneLevel:NO];
    
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

@end

