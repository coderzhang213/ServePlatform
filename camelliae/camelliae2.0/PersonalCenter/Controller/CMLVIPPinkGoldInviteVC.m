//
//  CMLVIPPinkGoldInviteVC.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/13.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLVIPPinkGoldInviteVC.h"
#import "NetConfig.h"
#import "SVProgressHUD.h"
#import "VCManger.h"

@interface CMLVIPPinkGoldInviteVC ()<NavigationBarProtocol, NetWorkProtocol>

@property (copy,nonatomic) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLVIPPinkGoldInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navBar.titleContent = @"黛色会员邀请";
    self.navBar.titleColor = [UIColor CMLWhiteColor];
    self.navBar.backgroundColor = [UIColor CMLBlackColor];
    [self.navBar setCloseBarItem];
    self.navBar.delegate = self;
    
    [self setRequest];
}

- (void)setRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"userId"];
    [NetWorkTask postResquestWithApiName:InvitePinkGoldCard paraDic:paraDic delegate:delegate];
    self.currentApiName = InvitePinkGoldCard;
    
}

- (void)loadViews {
    [self loadData];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberInvitationPinkGoldBgImage]];
    bgImage.backgroundColor = [UIColor whiteColor];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds = YES;
    
    bgImage.frame = CGRectMake(0,
                               CGRectGetMaxY(self.navBar.frame) - 4*Proportion,
                               WIDTH,
                               HEIGHT - self.navBar.frame.size.height + 4*Proportion);
    
    [self.contentView addSubview:bgImage];
    
    UIButton *inviteButton = [[UIButton alloc] init];
    inviteButton.backgroundColor = [UIColor clearColor];
    [inviteButton setImage:[UIImage imageNamed:CMLMemberInvitationPinkBannerImage] forState:UIControlStateNormal];
    [inviteButton sizeToFit];
    inviteButton.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(inviteButton.frame)/2,
                                    HEIGHT - CGRectGetHeight(inviteButton.frame) - 150 * Proportion,
                                    CGRectGetWidth(inviteButton.frame),
                                    CGRectGetHeight(inviteButton.frame));
    [inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:inviteButton];
    
    UILabel *surplusLabel = [[UILabel alloc] init];
    surplusLabel.backgroundColor = [UIColor clearColor];
    surplusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    surplusLabel.textColor = [UIColor CMLOrangerFFA465Color];
    surplusLabel.text = [NSString stringWithFormat:@"线上剩余名额：%@", self.obj.retData.onLineSurplus];
    [surplusLabel sizeToFit];
    surplusLabel.frame = CGRectMake(WIDTH/2 - CGRectGetWidth(surplusLabel.frame) - 20 * Proportion,
                                    CGRectGetMaxY(inviteButton.frame) + 30 * Proportion,
                                    CGRectGetWidth(surplusLabel.frame),
                                    CGRectGetHeight(surplusLabel.frame));
    [self.contentView addSubview:surplusLabel];
    
    UILabel *offSurplusLabel = [[UILabel alloc] init];
    offSurplusLabel.backgroundColor = [UIColor clearColor];
    offSurplusLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    offSurplusLabel.textColor = [UIColor CMLOrangerFFA465Color];
    offSurplusLabel.text = [NSString stringWithFormat:@"线下剩余名额：%@", self.obj.retData.offLineSurplus];
    [offSurplusLabel sizeToFit];
    offSurplusLabel.frame = CGRectMake(WIDTH/2 + 20 * Proportion,
                                    CGRectGetMaxY(inviteButton.frame) + 30 * Proportion,
                                    CGRectGetWidth(offSurplusLabel.frame),
                                    CGRectGetHeight(offSurplusLabel.frame));
    [self.contentView addSubview:offSurplusLabel];
    
    

}

- (void)inviteButtonClick {
    if ([self.obj.retData.onLineSurplus intValue] > 0) {
        [self showCurrentVCShareViewWith:1];
    }else {
        [SVProgressHUD showErrorWithStatus:@"线上剩余名额不足" duration:1];
    }
}

- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
}

- (void)loadData {
    
    /*判断是否可以推荐*/
    if ([[[DataManager lightData] readUserLevel] intValue] != 1 || [[[DataManager lightData] readRoleId] intValue] > 4) {
        
        NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.shareImgUrl]];
        UIImage *image = [UIImage imageWithData:imageNata];
        self.baseShareImage = image;
        
        self.baseShareLink = self.obj.retData.url;
        self.baseShareTitle = [NSString stringWithFormat:@"%@邀请您一起加入卡枚连",[[DataManager lightData] readNickName]];
        self.baseShareContent = @"卡枚连是一家高端生活方式服务平台，加入卡枚连，随时随地宠爱自己。";
        
    }else{
        
        [self showFailTemporaryMes:@"对不起!此功能只对黛色会员并开通账本系统者开放"];
        
    }
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"%@", responseResult);
    self.obj = obj;
    
    if ([obj.retCode intValue] == 0) {
        [self loadViews];
    }else {
        [SVProgressHUD showErrorWithStatus:@"获取分享链接失败，请稍后重试"];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    [SVProgressHUD showErrorWithStatus:@"网络连接错误，请稍后重试"];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
