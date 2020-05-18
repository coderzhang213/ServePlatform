//
//  CMLVIPInviteVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/22.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLVIPInviteVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "WebViewLinkVC.h"
#import "CMLNewIntegrationVC.h"


@interface CMLVIPInviteVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (copy,nonatomic) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLVIPInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navBar.titleContent = @"黛色会员邀请";
    self.navBar.titleColor = [UIColor CMLWhiteColor];
    self.navBar.backgroundColor = [UIColor CMLBlackColor];
    [self.navBar setCloseBarItem];
    [self.navBar setRightShareBarItem];
    self.navBar.delegate = self;
    
    [self setRequest];
    
}

- (void) loadViews{
    [self loadData];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberInvitationBgImage]];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds = YES;
    
    bgImage.frame = CGRectMake(0,
                               CGRectGetMaxY(self.navBar.frame) - 4*Proportion,
                               WIDTH,
                               HEIGHT - self.navBar.frame.size.height + 4*Proportion);
    
    [self.contentView addSubview:bgImage];
    
    
    /*
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              HEIGHT - 295*Proportion,
                                                              WIDTH,
                                                              295*Proportion)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:bgView];
    
    CMLLine *topLine = [[CMLLine alloc] init];
    topLine.lineLength = WIDTH;
    topLine.lineWidth = 1*Proportion;
    topLine.LineColor = [UIColor CMLtextInputGrayColor];
    topLine.startingPoint = CGPointMake(0, 0);
    [bgView addSubview:topLine];
    
    UILabel *invitePromLab = [[UILabel alloc] init];
    invitePromLab.text = @"邀请好友";
    invitePromLab.font = KSystemFontSize13;
    invitePromLab.textColor = [UIColor CMLBlackColor];
    [invitePromLab sizeToFit];
    invitePromLab.frame = CGRectMake(WIDTH/2.0 - invitePromLab.frame.size.width/2.0,
                                     37*Proportion,
                                     invitePromLab.frame.size.width,
                                     invitePromLab.frame.size.height);
    [bgView addSubview:invitePromLab];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.lineWidth = 2*Proportion;
    bottomLine.lineLength = 72*Proportion;
    bottomLine.startingPoint = CGPointMake(WIDTH/2.0 - 72*Proportion/2.0, CGRectGetMaxY(invitePromLab.frame) + 25*Proportion);
    bottomLine.LineColor = [UIColor CMLBlackColor];
    bottomLine.directionOfLine = HorizontalLine;
    [bgView addSubview:bottomLine];
    
    
    NSArray *tagImgArray = @[InviteWechat_CShareImg,InviteWechat_momentShareImg,InviteSinaShareImg,InviteQQShareImg];
    NSArray *tagNameArray = @[@"微信",@"朋友圈",@"微博",@"QQ"];
    CGFloat imageWidth = (WIDTH - 90*Proportion*3 - 100*Proportion*2)/4.0;
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100*Proportion + (imageWidth + 90*Proportion)*i,
                                                                   bgView.frame.size.height - 83*Proportion - imageWidth,
                                                                   imageWidth,
                                                                   imageWidth)];
        [bgView addSubview:btn];
        btn.tag = i + 1;
        [btn setBackgroundImage:[UIImage imageNamed:tagImgArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = KSystemFontSize11;
        lab.textColor = [UIColor CMLBlackColor];
        lab.text = tagNameArray[i];
        [lab sizeToFit];
        lab.frame = CGRectMake(btn.center.x - lab.frame.size.width/2.0,
                               CGRectGetMaxY(btn.frame) + 20*Proportion,
                               lab.frame.size.width,
                               lab.frame.size.height);
        [bgView addSubview:lab];
        
        
        
    }
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void)didSelectedRightBarItem {
    
    [self showCurrentVCShareViewWith:2];
    
}

- (void)loadData {
    
    /*判断是否可以推荐*/
    if ([[[DataManager lightData] readUserLevel] intValue] != 1 || [[[DataManager lightData] readRoleId] intValue] > 4) {
        
        NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.shareImgUrl]];
        UIImage *image = [UIImage imageWithData:imageNata];
        self.baseShareImage = image;
        
        if ([NetWorkApiDomain isEqualToString:@"http://fakeapi.camelliae.com/"]) {
            self.baseShareLink = [NSString stringWithFormat:@"http://test.m.camelliae.com/v3/share/purple-project-share?pid=k%@",[[DataManager lightData] readUserID]];
        }else {
            self.baseShareLink = [NSString stringWithFormat:@"http://m.camelliae.com/v3/share/purple-project-share?pid=k%@",[[DataManager lightData] readUserID]];
        }
        
        self.baseShareTitle = [NSString stringWithFormat:@"%@邀请您一起加入卡枚连",[[DataManager lightData] readNickName]];
        self.baseShareContent = @"卡枚连是一家高端生活方式服务平台，加入卡枚连，随时随地宠爱自己。";
        
    }else{
        
        [self showFailTemporaryMes:@"对不起!此功能只对黛色会员并开通账本系统者开放"];
        
    }
    NSLog(@"readCanPushState%d%d", [[[DataManager lightData] readCanPushState] intValue], [[[DataManager lightData] readDistributionLevelStatus] intValue]);
}

- (void) setRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:InviteFriendDeatail paraDic:paraDic delegate:delegate];
    self.currentApiName = InviteFriendDeatail;
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    self.obj = obj;
    
    if ([obj.retCode intValue] == 0) {
        
        [self loadViews];
        
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
}


/*推荐到第三方显示的数据*
- (void) shareMessage:(UIButton *) btn{
    
    *判断是否可以推荐*
    if ([[[DataManager lightData] readCanPushState] intValue] == 1 && [[[DataManager lightData] readDistributionLevelStatus] intValue] == 1) {
     
        NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.shareImgUrl]];
        UIImage *image = [UIImage imageWithData:imageNata];
        self.baseShareImage = image;
        self.baseShareLink = [NSString stringWithFormat:@"http://test.m.camelliae.com/v3/share/purple-project-share?pid=k%@",[[DataManager lightData] readUserID]];
        self.baseShareTitle = [NSString stringWithFormat:@"%@邀请您一起加入卡枚连",[[DataManager lightData] readNickName]];
        self.baseShareContent = @"卡枚连是一家高端生活方式服务平台，加入卡枚连，随时随地宠爱自己。";
//        [self changeShareStyle:btn];
        
    }else{
        
        [self showFailTemporaryMes:@"对不起!此功能只对黛色会员并开通账本系统者开放"];
        
    }
    
}
*/
@end
