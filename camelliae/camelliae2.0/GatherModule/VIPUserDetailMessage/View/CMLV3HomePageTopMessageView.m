//
//  CMLV3HomePageTopMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLV3HomePageTopMessageView.h"
#import "BaseResultObj.h"
#import "VCManger.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "LoginUserObj.h"
#import "NewPersonDetailInfoVC.h"
#import "CMLFansAndAttentionVC.h"


#define UserImageHeight  140
#define NickNameTopMargin 30

@interface CMLV3HomePageTopMessageView ()<NewRefreshPersonalCenterDelegate,NetWorkProtocol>

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *userNickNameLab;

@property (nonatomic,strong) UIImageView *lvlImage;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIButton *editUserMessageBtn;

@property (nonatomic,strong) UIImageView *userMemberLvl;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *activityBtn;

@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong) UIButton *goodsBtn;

@property (nonatomic,strong) UIView *bottomLine;


@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLV3HomePageTopMessageView

- (instancetype)initWithObj:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {

        self.obj = obj;
        [self loadViews];
    }
    
    return self;

}


- (void) loadViews{

    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - UserImageHeight*Proportion/2.0,
                                                                   0,
                                                                   UserImageHeight*Proportion,
                                                                   UserImageHeight*Proportion)];
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = UserImageHeight*Proportion/2.0;
    self.userImage.clipsToBounds = YES;
    [self addSubview:self.userImage];
    
    [NetWorkTask setImageView:self.userImage WithURL:self.obj.retData.user.gravatar placeholderImage:nil];
    
    
    
    self.userNickNameLab = [[UILabel alloc] init];
    self.userNickNameLab.textColor = [UIColor CMLBlackColor];
    self.userNickNameLab.font = KSystemFontSize15;
    self.userNickNameLab.text = self.obj.retData.user.nickName;
    [self.userNickNameLab sizeToFit];
    self.userNickNameLab.frame = CGRectMake(WIDTH/2.0 - self.userNickNameLab.frame.size.width/2.0,
                                            CGRectGetMaxY(self.userImage.frame) + NickNameTopMargin*Proportion,
                                            self.userNickNameLab.frame.size.width,
                                            self.userNickNameLab.frame.size.height);
    [self addSubview:self.userNickNameLab];
    
    self.userMemberLvl = [[UIImageView alloc] init];
    self.userMemberLvl.backgroundColor = [UIColor CMLWhiteColor];
    switch ([self.obj.retData.user.memberLevel intValue]) {
        case 1:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
        case 2:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
        case 3:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
        case 4:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    [self.userMemberLvl sizeToFit];
    self.userMemberLvl.clipsToBounds = YES;
    self.userMemberLvl.layer.cornerRadius = 37*Proportion/2.0;
    self.userMemberLvl.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) - 37*Proportion,
                                          CGRectGetMaxY(self.userImage.frame) - 37*Proportion,
                                          37*Proportion,
                                          37*Proportion);
    [self addSubview:self.userMemberLvl];
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemFontSize12;
    self.titleLab.textColor = [UIColor CMLLineGrayColor];
    self.titleLab.text = self.obj.retData.user.signature;
    self.titleLab.numberOfLines = 0;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab sizeToFit];
    if (self.titleLab.frame.size.width > WIDTH - 30*Proportion*2) {
    
       CGRect currentRect =  [self.titleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, HEIGHT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                              context:nil];
        self.titleLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(self.userNickNameLab.frame) + 10*Proportion,
                                         WIDTH - 30*Proportion*2,
                                         currentRect.size.height);
        
    }else{
    
        self.titleLab.frame = CGRectMake(WIDTH/2.0 - self.titleLab.frame.size.width/2.0,
                                         CGRectGetMaxY(self.userNickNameLab.frame) + 10*Proportion,
                                         self.titleLab.frame.size.width,
                                         self.titleLab.frame.size.height);
    }
    
    [self addSubview:self.titleLab];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.bottomView];
    

    
    if ([self.obj.retData.user.uid intValue] == [[[DataManager lightData] readUserID] intValue]) {
    
        /****/
        
        self.editUserMessageBtn = [[UIButton alloc] init];
        self.editUserMessageBtn.titleLabel.font = KSystemFontSize13;
        [self.editUserMessageBtn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
        [self.editUserMessageBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        self.editUserMessageBtn.layer.borderWidth = 1;
        self.editUserMessageBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        [self.editUserMessageBtn sizeToFit];
        self.editUserMessageBtn.frame = CGRectMake(WIDTH/2.0 - (self.editUserMessageBtn.frame.size.width + 52*Proportion)/2.0,
                                                   CGRectGetMaxY(self.titleLab.frame) + 50*Proportion,
                                                   self.editUserMessageBtn.frame.size.width + 52*Proportion,
                                                   52*Proportion);
        self.editUserMessageBtn.layer.cornerRadius = 52*Proportion/2.0;
        [self addSubview:self.editUserMessageBtn];
        [self.editUserMessageBtn addTarget:self action:@selector(enterPersonalDetailMessageVC) forControlEvents:UIControlEventTouchUpInside];

        self.bottomView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.editUserMessageBtn.frame) + 50*Proportion,
                                           WIDTH,
                                           20*Proportion);
        
    }else{
    
    

        
        self.bottomView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.titleLab.frame) + 50*Proportion,
                                           WIDTH,
                                           20*Proportion);
    }

    self.activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.bottomView.frame),
                                                                  WIDTH/3.0,
                                                                  80*Proportion)];
    [self.activityBtn setTitle:@"活动" forState:UIControlStateNormal];
    self.activityBtn.tag = 0;
    [self.activityBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [self.activityBtn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
    self.activityBtn.titleLabel.font = KSystemBoldFontSize14;
    [self addSubview:self.activityBtn];
    [self.activityBtn addTarget:self action:@selector(selectTypeList:) forControlEvents:UIControlEventTouchUpInside];
    self.activityBtn.selected = YES;
    
    self.serveBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3.0,
                                                               CGRectGetMaxY(self.bottomView.frame),
                                                               WIDTH/3.0,
                                                               80*Proportion)];
    [self.serveBtn setTitle:@"服务" forState:UIControlStateNormal];
    self.serveBtn.tag = 1;
    [self.serveBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [self.serveBtn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
    self.serveBtn.titleLabel.font = KSystemFontSize14;
    [self addSubview:self.serveBtn];
    [self.serveBtn addTarget:self action:@selector(selectTypeList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.goodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3.0*2.0,
                                                               CGRectGetMaxY(self.bottomView.frame),
                                                               WIDTH/3.0,
                                                               80*Proportion)];
    [self.goodsBtn setTitle:@"商品" forState:UIControlStateNormal];
    self.goodsBtn.tag = 2;
    [self.goodsBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
    [self.goodsBtn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
    self.goodsBtn.titleLabel.font = KSystemFontSize14;
    [self addSubview:self.goodsBtn];
    [self.goodsBtn addTarget:self action:@selector(selectTypeList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.activityBtn.center.x - 40*Proportion/2.0,
                                                               CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                                               40*Proportion,
                                                               2*Proportion)];
    self.bottomLine.backgroundColor = [UIColor CMLBlackColor];
    [self addSubview:self.bottomLine];
    
    self.obj.retData.user.isHaveProject = 0;/*固定为0 不显示服务*/
    if ([self.obj.retData.user.isHaveActivity intValue] == 1 && [self.obj.retData.user.isHaveGoods intValue] == 1 && [self.obj.retData.user.isHaveProject intValue] == 1) {
        
        
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 1 && [self.obj.retData.user.isHaveGoods intValue] == 1 && [self.obj.retData.user.isHaveProject intValue] == 0){
        /*活动-商品-没有服务*/
        self.serveBtn.hidden = YES;
        self.activityBtn.frame = CGRectMake(WIDTH/3.0/2.0,
                                            CGRectGetMaxY(self.bottomView.frame),
                                            WIDTH/3.0,
                                            80*Proportion);
        self.goodsBtn.frame = CGRectMake(CGRectGetMaxX(self.activityBtn.frame),
                                         CGRectGetMaxY(self.bottomView.frame),
                                         WIDTH/3.0,
                                         80*Proportion);
        
        self.bottomLine.frame = CGRectMake(self.activityBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
        
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 1 && [self.obj.retData.user.isHaveGoods intValue] == 0 && [self.obj.retData.user.isHaveProject intValue] == 0){
        /*活动-没有商品-没有服务*/
        self.goodsBtn.hidden = YES;
        self.serveBtn.hidden = YES;
        self.activityBtn.userInteractionEnabled = NO;
        self.activityBtn.frame = CGRectMake(WIDTH/2.0 - WIDTH/3.0/2.0,
                                            CGRectGetMaxY(self.bottomView.frame),
                                            WIDTH/3.0,
                                            80*Proportion);
        self.bottomLine.hidden = YES;
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 1 && [self.obj.retData.user.isHaveGoods intValue] == 0 && [self.obj.retData.user.isHaveProject intValue] ==1){
        
        /*活动-服务-没有商品*/
        self.goodsBtn.hidden = YES;
        self.activityBtn.frame = CGRectMake(WIDTH/3.0/2.0,
                                            CGRectGetMaxY(self.bottomView.frame),
                                            WIDTH/3.0,
                                            80*Proportion);
        self.serveBtn.frame = CGRectMake(CGRectGetMaxX(self.activityBtn.frame),
                                         CGRectGetMaxY(self.bottomView.frame),
                                         WIDTH/3.0,
                                         80*Proportion);
        
        self.bottomLine.frame = CGRectMake(self.activityBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);

    }else if ([self.obj.retData.user.isHaveActivity intValue] == 0 && [self.obj.retData.user.isHaveGoods intValue] == 1 && [self.obj.retData.user.isHaveProject intValue] == 1){
        
        self.activityBtn.hidden = YES;
        self.serveBtn.frame = CGRectMake(WIDTH/3.0/2.0,
                                            CGRectGetMaxY(self.bottomView.frame),
                                            WIDTH/3.0,
                                            80*Proportion);
        self.goodsBtn.frame = CGRectMake(CGRectGetMaxX(self.serveBtn.frame),
                                         CGRectGetMaxY(self.bottomView.frame),
                                         WIDTH/3.0,
                                         80*Proportion);
        
        self.bottomLine.frame = CGRectMake(self.serveBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 0 && [self.obj.retData.user.isHaveGoods intValue] == 1 && [self.obj.retData.user.isHaveProject intValue] == 0){
        
        self.activityBtn.hidden = YES;
        self.serveBtn.hidden = YES;
        
        self.goodsBtn.userInteractionEnabled = NO;
        self.goodsBtn.frame = CGRectMake(WIDTH/2.0  - WIDTH/3.0/2.0,
                                         CGRectGetMaxY(self.bottomView.frame),
                                         WIDTH/3.0,
                                         80*Proportion);
        
        self.bottomLine.hidden = YES;

        
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 0 && [self.obj.retData.user.isHaveGoods intValue] == 0 && [self.obj.retData.user.isHaveProject intValue] ==1){
       
        self.activityBtn.hidden = YES;
        self.goodsBtn.hidden = YES;
        
        self.bottomLine.hidden = YES;
        
        self.serveBtn.userInteractionEnabled = NO;
        self.serveBtn.frame = CGRectMake(WIDTH/2.0  - WIDTH/3.0/2.0,
                                         CGRectGetMaxY(self.bottomView.frame),
                                         WIDTH/3.0,
                                         80*Proportion);
        
    }else if ([self.obj.retData.user.isHaveActivity intValue] == 0 && [self.obj.retData.user.isHaveGoods intValue] == 0 && [self.obj.retData.user.isHaveProject intValue] ==0){
        
        self.activityBtn.hidden = YES;
        self.goodsBtn.hidden = YES;
        self.serveBtn.hidden = YES;
     
        self.bottomLine.hidden = YES;
    }

    
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            CGRectGetMaxY(self.bottomView.frame) + 80*Proportion);

    
}

- (void) refreshCurrentHomePageView{

    if (self.selectIndex == 0) {
        
        self.activityBtn.selected = YES;
        self.serveBtn.selected = NO;
        self.goodsBtn.selected = NO;
        
        self.activityBtn.titleLabel.font = KSystemBoldFontSize14;
        self.serveBtn.titleLabel.font = KSystemFontSize14;
        self.goodsBtn.titleLabel.font = KSystemFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.activityBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }else if(self.selectIndex == 1){
        
        self.activityBtn.selected = NO;
        self.serveBtn.selected = YES;
        self.goodsBtn.selected = NO;
        
        self.activityBtn.titleLabel.font = KSystemFontSize14;
        self.serveBtn.titleLabel.font = KSystemBoldFontSize14;
        self.goodsBtn.titleLabel.font = KSystemFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.serveBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.serveBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }else{
        
        self.activityBtn.selected = NO;
        self.serveBtn.selected = NO;
        self.goodsBtn.selected = YES;
        
        self.activityBtn.titleLabel.font = KSystemFontSize14;
        self.serveBtn.titleLabel.font = KSystemFontSize14;
        self.goodsBtn.titleLabel.font = KSystemBoldFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.goodsBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.goodsBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }
}

- (void) selectTypeList:(UIButton *) btn{

    [self.delegate selectCurrentType:(int)btn.tag];
    
    if (btn.tag == 0) {
        
        self.activityBtn.selected = YES;
        self.serveBtn.selected = NO;
        self.goodsBtn.selected = NO;
        
        self.activityBtn.titleLabel.font = KSystemBoldFontSize14;
        self.serveBtn.titleLabel.font = KSystemFontSize14;
        self.goodsBtn.titleLabel.font = KSystemFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.activityBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.activityBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }else if(btn.tag == 1){
        
        self.activityBtn.selected = NO;
        self.serveBtn.selected = YES;
        self.goodsBtn.selected = NO;
        
        self.activityBtn.titleLabel.font = KSystemFontSize14;
        self.serveBtn.titleLabel.font = KSystemBoldFontSize14;
        self.goodsBtn.titleLabel.font = KSystemFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.serveBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.serveBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }else{
        
        self.activityBtn.selected = NO;
        self.serveBtn.selected = NO;
        self.goodsBtn.selected = YES;
        
        self.activityBtn.titleLabel.font = KSystemFontSize14;
        self.serveBtn.titleLabel.font = KSystemFontSize14;
        self.goodsBtn.titleLabel.font = KSystemBoldFontSize14;
        
        self.bottomLine.frame = CGRectMake(self.goodsBtn.center.x - 40*Proportion/2.0,
                                           CGRectGetMaxY(self.goodsBtn.frame) - 2*Proportion,
                                           40*Proportion,
                                           2*Proportion);
    }
}

- (void) enterPersonalDetailMessageVC{

    NewPersonDetailInfoVC *vc = [[NewPersonDetailInfoVC alloc] init];
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) refrshPersonalCenter{

    [self.delegate refreshCurrentVC];
    
}

- (void) enterCurrentUserAttentionVC{
    
    CMLFansAndAttentionVC *vc = [[CMLFansAndAttentionVC alloc] init];
    vc.isFansVC = NO;
    vc.userId = self.obj.retData.user.uid;
    if ([self.obj.retData.user.uid intValue] != [[[DataManager lightData] readUserID] intValue]) {
        
        if ([self.obj.retData.user.gender intValue] == 1) {
            
            vc.vcName = @"他的关注";
            
        }else if ([self.obj.retData.user.gender intValue] == 2){
            
            vc.vcName = @"她的关注";
            
        }else{
            
            vc.vcName = @"TA的关注";
        }
        
    }else{
        
        vc.vcName = @"我的关注";
    }
    
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterCurrentUserFanVC{
    
    CMLFansAndAttentionVC *vc = [[CMLFansAndAttentionVC alloc] init];
    vc.isFansVC = YES;
    vc.userId = self.obj.retData.user.uid;
    if ([self.obj.retData.user.uid intValue] != [[[DataManager lightData] readUserID] intValue]) {
        
        if ([self.obj.retData.user.gender intValue] == 1) {
            
            vc.vcName = @"他的粉丝";
            
        }else if ([self.obj.retData.user.gender intValue] == 2){
            
            vc.vcName = @"她的粉丝";
            
        }else{
            
            vc.vcName = @"TA的粉丝";
        }
        
    }else{
        
        vc.vcName = @"我的粉丝";
    }
    
    [[VCManger mainVC] pushVC:vc animate:YES];
}

//- (void) attentinUser:(UIButton *) btn {
//
//    self.attentionBtn.selected = !self.attentionBtn.selected;
//
//    if (self.attentionBtn.selected) {
//
//        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
//        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:1] andUserId:self.obj.retData.user.uid];
//    }else{
//
//        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
//        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:2] andUserId:self.obj.retData.user.uid];
//    }
//
//}

- (void) setAttentionVIPMemberRequest:(NSNumber *) actType andUserId:(NSNumber *) userId{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:userId forKey:@"userId"];
    [paraDic setObject:actType forKey:@"actType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],userId,actType,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:AttentionVIPMember paraDic:paraDic delegate:delegate];

    
}

/**网络请求回调*/
#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
        
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0 && obj) {
        
      
        [self.delegate refreshCurrentVC];
        
    }else{
        
//        self.attentionBtn.selected = !self.attentionBtn.selected;
    }

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
        
        /**关注状态*/
//        self.attentionBtn.selected = !self.attentionBtn.selected;

}

- (void) enterCardVC{

    [self.delegate showCardView];
}
@end
