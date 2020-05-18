//
//  CMLUserPushActivityDetailVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/16.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLUserPushActivityDetailVC.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "ActivityFooterView.h"
#import "CMLUserPushProjectMessageView.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "ActivityPayTypeView.h"
#import "CMLVIPNewDetailVC.h"
#import "CMLInvitationView.h"
#import "CMLSubscribeDefaultVC.h"

@interface CMLUserPushActivityDetailVC ()<UIScrollViewDelegate,UIWebViewDelegate,NavigationBarProtocol,NetWorkProtocol,UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,ActivityFooterViewDelegate,UserPushProjectMessageViewDelegate,ActivityPayTypeViewDelegate, InvitationViewDelegate, CMLSubscribeDefaultVCDelegate>

@property (nonatomic,strong) UIView *userBgView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIWebView *detailView;

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) ActivityFooterView *activityFooterView;

@property (nonatomic,strong) UIView *activityShadowView;

@property (nonatomic,strong) CMLUserPushProjectMessageView *activityAppointmentMessageView;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,strong) ActivityPayTypeView *activityPayTypeView;

@property (nonatomic,strong) CMLInvitationView  *invitationView;

@property (nonatomic,strong) UIImageView *QRImageView;

@end

@implementation CMLUserPushActivityDetailVC

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPayError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"successPayOfZFB" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
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
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ActivityInfo paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityInfo;
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
    self.activityFooterView = [[ActivityFooterView alloc] initUserPushWith:self.obj];
    self.activityFooterView.delegate = self;
    self.activityFooterView.frame = CGRectMake(0,
                                               HEIGHT - UITabBarHeight - SafeAreaBottomHeight,
                                               WIDTH,
                                               self.activityFooterView.currentHeight);
    [self.contentView addSubview:self.activityFooterView];
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
    userImage.userInteractionEnabled = YES;
    [self.userBgView addSubview:userImage];
    [NetWorkTask setImageView:userImage WithURL:self.obj.retData.user.gravatar placeholderImage:nil];
    
    UIButton *userBtn = [[UIButton alloc] initWithFrame:userImage.bounds];
    userBtn.backgroundColor = [UIColor clearColor];
    [userImage addSubview:userBtn];
    [userBtn addTarget:self action:@selector(enterUserDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    /*昵称*/
    UILabel *userNickNameLab = [[UILabel alloc] init];
    userNickNameLab.font = KSystemRealBoldFontSize14;
    userNickNameLab.text = self.obj.retData.user.nickName;
    [userNickNameLab sizeToFit];
    userNickNameLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                       userImage.frame.origin.y + 3,
                                       userNickNameLab.frame.size.width,
                                       userNickNameLab.frame.size.height);
    [self.userBgView addSubview:userNickNameLab];
    
    /*定位-简介*/
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
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                               CGRectGetHeight(self.userBgView.frame) - 1,
                                                               WIDTH - 20*Proportion*2,
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
    addressLab.text = self.obj.retData.address;
    addressLab.font = KSystemFontSize11;
    [addressLab sizeToFit];
    addressLab.frame = CGRectMake(CGRectGetMaxX(addressImg.frame) + 10*Proportion,
                                  addressImg.center.y - addressLab.frame.size.height/2.0,
                                  addressLab.frame.size.width,
                                  addressLab.frame.size.height);
    [self.mainScrollView addSubview:addressLab];
    
    UIImageView *timeImg = [[UIImageView alloc] init];
    timeImg.contentMode = UIViewContentModeScaleAspectFill;
    timeImg.image = [UIImage imageNamed:ListActivityTimeImg];
    timeImg.clipsToBounds = YES;
    [timeImg sizeToFit];
    timeImg.frame = CGRectMake(CGRectGetMaxX(addressLab.frame) + 20*Proportion, addressImg.center.y - timeImg.frame.size.height/2.0, timeImg.frame.size.width, timeImg.frame.size.height);
    [self.mainScrollView addSubview:timeImg];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = KSystemFontSize11;
    timeLab.textColor = [UIColor CMLtextInputGrayColor];
    timeLab.text = self.obj.retData.actDateZone;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(CGRectGetMaxX(timeImg.frame) + 10*Proportion,
                               timeImg.center.y - timeLab.frame.size.height/2.0,
                               timeLab.frame.size.width,
                               timeLab.frame.size.height);
    [self.mainScrollView addSubview:timeLab];

    
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

- (void) setActivityAppointmentMes:(NSNumber *) type{

    [self.activityShadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.activityAppointmentMessageView = [[CMLUserPushProjectMessageView alloc] initWith:self.obj andType:type];
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
    [self.cancelBtn addTarget:self action:@selector(hiddenShaDowView) forControlEvents:UIControlEventTouchUpInside];

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
    
    if ([self.currentApiName isEqualToString:ActivityInfo]) {
        NSLog(@"***%@",responseResult);
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        self.navBar.titleContent = self.obj.retData.title;
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.QRImageView = [[UIImageView alloc] init];
            [NetWorkTask setImageView:self.QRImageView WithURL:self.obj.retData.activityQrCode placeholderImage:nil];
            
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
            [self hiddenShaDowView];
            [self showSuccessTemporaryMes:@"支付成功"];
//            [self setCurrentInvitationView];
            /*进入订单详情*/
            [self enterCenterOrderVC];

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
    };
    
    self.sharesErrorBlock = ^(){
        [weakSelf hiddenCurrentVCShareView];
    };
    
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

#pragma mark - ActivityFooterViewDelegate

- (void) showActivityMessage{
    
    /*花伴-活动-立即预订*/
    self.activityShadowView.alpha = 1;
    [self setActivityAppointmentMes:[NSNumber numberWithInt:0]];
   
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


#pragma mark - UserPushProjectMessageViewDelegate
- (void) activityAppointmentSuccess:(NSString *) str{
    
    self.orderID = self.activityAppointmentMessageView.orderID;
    if ([str isEqualToString:@"生成订单"]) {
        [self setCurrentActivityPayTypeView];
    }else{
        [self hiddenShaDowView];
        [self showSuccessTemporaryMes:str];
        [self.activityFooterView confirmAppointment];
//        [self setCurrentInvitationView];
        /*进入订单页面*/
        [self enterCenterOrderVC];
    }
}

- (void)enterCenterOrderVC {
    
    CMLSubscribeDefaultVC *vc = [[CMLSubscribeDefaultVC alloc] initWithOrderId:self.orderID isDeleted:[NSNumber numberWithInt:1]];/*直接传1：未删除*/
    vc.delegate = self;
    vc.orderSuccess = [NSNumber numberWithInt:1];/*1:预订成功后跳转*/
    [[VCManger mainVC] pushVC:vc animate:YES];
}

/*邀请函*/
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

- (void) enterUserDetailVC{
    
    CMLVIPNewDetailVC *vc  = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.retData.user.nickName
                                                           currnetUserId:self.obj.retData.user.userId
                                                      isReturnUpOneLevel:NO];
    
    [[VCManger mainVC] pushVC:vc animate:YES];
    
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
    [self viewDidLoad];
    [self setNetWork];
    
}

#pragma mark CMLSubscribeDefaultVCDelegate
- (void)refreshCurrentVC {
    [self refreshLoadMessageOfVC];
}

@end
