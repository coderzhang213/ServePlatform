//
//  CMLIvviteFriendsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLInviteFriendsVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "WebViewLinkVC.h"
#import "CMLNewIntegrationVC.h"


@interface CMLInviteFriendsVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (copy,nonatomic) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLInviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.titleContent = @"邀请好友送积分";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    [self.navBar setLeftBarItem];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 114*Proportion - 30*Proportion,
                                                               (self.navBar.frame.size.height - StatusBarHeight)/2.0 - 40*Proportion/2.0 + StatusBarHeight,
                                                               114*Proportion,
                                                               40*Proportion)];
    btn.titleLabel.font = KSystemFontSize11;
    [btn setTitle:@"积分兑换" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor CMLBlackColor].CGColor;
    btn.layer.borderWidth = 1*Proportion;
    btn.layer.cornerRadius = 2*Proportion;
    [self.navBar addSubview:btn];
    [btn addTarget:self action:@selector(enterPointsVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setRequest];
    
}

- (void) loadViews{

    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:InviteFriendsBgImg]];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds = YES;
    bgImage.frame = CGRectMake(0,
                               CGRectGetMaxY(self.navBar.frame),
                               WIDTH,
                               HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight);
    [self.contentView addSubview:bgImage];
    
    UIImageView *mainImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:InviteFriendsDetailImg]];
    [mainImage sizeToFit];
    mainImage.frame = CGRectMake(WIDTH/2.0 - mainImage.frame.size.width/2.0,
                                 CGRectGetMaxY(self.navBar.frame) + 90*Proportion,
                                 mainImage.frame.size.width,
                                 mainImage.frame.size.height);
    [self.contentView addSubview:mainImage];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.textColor = [UIColor CMLtextInputGrayColor];
    
    promLab.text = [NSString stringWithFormat:@"已成功邀请%@位好友",self.obj.retData.dataCount];
    promLab.font = KSystemFontSize11;
    [promLab sizeToFit];
    promLab.frame = CGRectMake(mainImage.frame.size.width/2.0 - promLab.frame.size.width/2.0,
                               mainImage.frame.size.height*294/619,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [mainImage addSubview:promLab];
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.font = KSystemFontSize15;
    bottomLab.textColor = [UIColor CMLBrownColor];
    bottomLab.text = @"· 时尚生活尽在卡枚连 ·";
    [bottomLab sizeToFit];
    bottomLab.frame = CGRectMake(WIDTH/2.0 - bottomLab.frame.size.width/2.0,
                                 CGRectGetMaxY(mainImage.frame) + 20*Proportion,
                                 bottomLab.frame.size.width,
                                 bottomLab.frame.size.height);
    [self.contentView addSubview:bottomLab];
    
    UIButton *gameRulesBtn = [[UIButton alloc] init];
    gameRulesBtn.titleLabel.font = KSystemFontSize12;
    [gameRulesBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [gameRulesBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
    [gameRulesBtn setImage:[UIImage imageNamed:MoreMessageImg] forState:UIControlStateNormal];
    CGSize strSize = [gameRulesBtn.currentTitle sizeWithFontCompatible:KSystemFontSize12];
    [gameRulesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                      - gameRulesBtn.currentImage.size.width,
                                                      0,
                                                      0)];
    [gameRulesBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                      strSize.width + gameRulesBtn.currentImage.size.width,
                                                      0,
                                                      0)];
    
    [gameRulesBtn sizeToFit];
    gameRulesBtn.frame = CGRectMake(WIDTH/2.0 - (gameRulesBtn.frame.size.width + 50*Proportion)/2.0,
                                    CGRectGetMaxY(bottomLab.frame) + 50*Proportion,
                                    gameRulesBtn.frame.size.width + 50*Proportion,
                                    gameRulesBtn.frame.size.height);
    [self.contentView addSubview:gameRulesBtn];
    [gameRulesBtn addTarget:self action:@selector(enterWebVC) forControlEvents:UIControlEventTouchUpInside];
    

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(gameRulesBtn.frame) + 30*Proportion,
                                                             WIDTH,
                                                             HEIGHT - (CGRectGetMaxY(gameRulesBtn.frame) + 30*Proportion + SafeAreaBottomHeight))];
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
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
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

- (void) shareMessage:(UIButton *) btn{

    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.shareImgUrl]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.baseShareImage = image;
    self.baseShareLink = self.obj.retData.shareUrl;
    self.baseShareTitle = self.obj.retData.title;
    self.baseShareContent = self.obj.retData.desc;
    [self changeShareStyle:btn];

}

- (void) enterWebVC{

    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.url = self.obj.retData.actRulesUrl;
    vc.name = @"积分规则";
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterPointsVC{

    CMLNewIntegrationVC *vc = [[CMLNewIntegrationVC alloc] init];
    [[VCManger mainVC]pushVC:vc animate:YES];
}
@end
