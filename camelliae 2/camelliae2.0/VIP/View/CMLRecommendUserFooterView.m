//
//  CMLRecommendUserFooterView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/2.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRecommendUserFooterView.h"
#import "LoginUserObj.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "NSString+CMLExspand.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "CMLVIPNewDetailVC.h"

@interface CMLRecommendUserFooterView()<NetWorkProtocol,CMLVIPNewDetailDlegate>

@property (nonatomic,strong) NSMutableArray *currentDataArray;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLRecommendUserFooterView

- (NSMutableArray *)currentDataArray{
    
    if(!_currentDataArray){
        
        _currentDataArray = [NSMutableArray array];
    }
    
    return _currentDataArray;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {

        [self getNoTimeLineUserRecommendRequest];
    }
    
    return self;
}

- (void) loadViews{
  
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    
    
    UIImageView *proImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NoAttentionUserImg]];
    [proImage sizeToFit];
    proImage.frame = CGRectMake(WIDTH/2.0 - proImage.frame.size.width/2.0,
                                50*Proportion,
                                proImage.frame.size.width,
                                proImage.frame.size.height);
    [bgView addSubview:proImage];
    
    UILabel *promLabOne = [[UILabel alloc] init];
    promLabOne.text = @"还没有关注的好友";
    promLabOne.font = KSystemFontSize14;
    [promLabOne sizeToFit];
    promLabOne.frame = CGRectMake(WIDTH/2.0 - promLabOne.frame.size.width/2.0,
                                  CGRectGetMaxY(proImage.frame) + 20*Proportion,
                                  promLabOne.frame.size.width,
                                  promLabOne.frame.size.height);
    
    [bgView addSubview:promLabOne];
    UILabel *promLabTwo = [[UILabel alloc] init];
    promLabTwo.text = @"关注好友及时了解TA的近况";
    promLabTwo.font = KSystemFontSize12;
    promLabTwo.textColor = [UIColor CMLtextInputGrayColor];
    [promLabTwo sizeToFit];
    promLabTwo.frame = CGRectMake(WIDTH/2.0 - promLabTwo.frame.size.width/2.0,
                                  CGRectGetMaxY(promLabOne.frame) + 10*Proportion,
                                  promLabTwo.frame.size.width,
                                  promLabTwo.frame.size.height);
    [bgView addSubview:promLabTwo];
    
    UIView *bottomView1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(promLabTwo.frame) + 50,
                                                                   WIDTH,
                                                                   20*Proportion)];
    bottomView1.backgroundColor = [UIColor CMLNewGrayColor];
    [bgView addSubview:bottomView1];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.text = @"大家都喜欢";
    promLab.textColor = [UIColor CMLBrownColor];
    promLab.font = KSystemBoldFontSize14;
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               CGRectGetMaxY(bottomView1.frame) + 30*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [bgView addSubview:promLab];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(promLab.frame),
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLWhiteColor];
    [bgView addSubview:bottomView];
    
    for (int i = 0; i < self.currentDataArray.count; i++) {
        
        LoginUserObj * obj = [LoginUserObj getBaseObjFrom:self.currentDataArray[i]];
        
        UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(bottomView.frame) + 160*Proportion*i,
                                                                      WIDTH,
                                                                      160*Proportion)];
        moduleView.backgroundColor = [UIColor CMLWhiteColor];
        [bgView addSubview:moduleView];
        
        UIImageView *userImgae = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                               moduleView.frame.size.height/2.0 - 80*Proportion/2.0,
                                                                               80*Proportion,
                                                                               80*Proportion)];
        userImgae.clipsToBounds = YES;
        userImgae.layer.cornerRadius = 80*Proportion/2.0;
        
        [NetWorkTask setImageView:userImgae WithURL:obj.gravatar placeholderImage:nil];
        userImgae.userInteractionEnabled = YES;
        [moduleView addSubview:userImgae];
        
        UIButton *enterUserVCBtn = [[UIButton alloc] initWithFrame:userImgae.bounds];
        enterUserVCBtn.backgroundColor = [UIColor clearColor];
        enterUserVCBtn.tag = i;
        [userImgae addSubview:enterUserVCBtn];
        [enterUserVCBtn addTarget:self action:@selector(enterUserDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *userNameLab = [[UILabel alloc] init];
        userNameLab.font = KSystemFontSize14;
        userNameLab.text = obj.nickName;
        [userNameLab sizeToFit];
        userNameLab.frame = CGRectMake(CGRectGetMaxX(userImgae.frame) + 20*Proportion,
                                       userImgae.center.y - 10*Proportion/2.0 - userNameLab.frame.size.height,
                                       userNameLab.frame.size.width,
                                       userNameLab.frame.size.height);
        [moduleView addSubview:userNameLab];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = KSystemFontSize13;
        titleLab.text = obj.signature;
        titleLab.textColor = [UIColor CMLLineGrayColor];
        [titleLab sizeToFit];
        titleLab.frame = CGRectMake(CGRectGetMaxX(userImgae.frame) + 20*Proportion,
                                    CGRectGetMaxY(moduleView.frame),
                                    titleLab.frame.size.width,
                                    titleLab.frame.size.height);
        UIImageView *lvlImage = [[UIImageView alloc] init];
        switch ([obj.memberLevel intValue]) {
            case 1:
                lvlImage.image = [UIImage imageNamed:CMLLvlOneImg];
                break;
            case 2:
                lvlImage.image = [UIImage imageNamed:CMLLvlTwoImg];
                break;
            case 3:
                lvlImage.image = [UIImage imageNamed:CMLLvlThreeImg];
                break;
            case 4:
                lvlImage.image = [UIImage imageNamed:CMLLvlFourImg];
                break;
                
            default:
                break;
        }
        [lvlImage sizeToFit];
        lvlImage.frame = CGRectMake(CGRectGetMaxX(userNameLab.frame) + 10*Proportion,
                                    userNameLab.center.y - lvlImage.frame.size.height/2.0,
                                    lvlImage.frame.size.width,
                                    lvlImage.frame.size.height);
        [moduleView addSubview:lvlImage];
        
        
        UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 118*Proportion - 30*Proportion,
                                                                            moduleView.frame.size.height/2.0 - 52*Proportion/2.0,
                                                                            118*Proportion,
                                                                            52*Proportion)];
        attentionBtn.layer.borderWidth = 1;
        attentionBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        attentionBtn.titleLabel.font = KSystemFontSize13;
        [attentionBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        attentionBtn.layer.cornerRadius = 26*Proportion;
        attentionBtn.tag = i;
        [moduleView addSubview:attentionBtn];
        [attentionBtn addTarget:self action:@selector(attentionSomeOne:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.currentDataArray.count - 1) {
            
            bgView.frame = CGRectMake(0,
                                      0,
                                      WIDTH,
                                      CGRectGetMaxY(moduleView.frame));
            [self addSubview:bgView];
            self.frame = CGRectMake(0,
                                    0,
                                    WIDTH,
                                    bgView.frame.size.height);
            
            [self.delegate initRecommendUserFooterView: self];
            
        }
    }
    
}

- (void) getNoTimeLineUserRecommendRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:NoUserTimeLineDataUserRecommend param:paraDic delegate:delegate];
    self.currentApiName = NoUserTimeLineDataUserRecommend;
    
}

- (void) attentionSomeOne:(UIButton *) btn{
    
    LoginUserObj * obj = [LoginUserObj getBaseObjFrom:self.currentDataArray[btn.tag]];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:obj.uid forKey:@"userId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],obj.uid,[NSNumber numberWithInt:1],reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:AttentionVIPMember paraDic:paraDic delegate:delegate];
    self.currentApiName = AttentionVIPMember;
    
}

- (void) enterUserDetail:(UIButton *) btn{
    
    LoginUserObj * obj = [LoginUserObj getBaseObjFrom:self.currentDataArray[btn.tag]];
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:obj.nickName
//                                                          currnetUserId:obj.uid
//                                                     isReturnUpOneLevel:YES];
//    vc.delegate = self;
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:AttentionVIPMember]) {
     
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            [self.delegate refershCurrentVCData];
            
        }
        
    }else if ([self.currentApiName isEqualToString:NoUserTimeLineDataUserRecommend]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        
        if ([obj.retCode intValue] == 0) {
            
            
            
            self.currentDataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            
            [self loadViews];
            
        }
    }
}
- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
 
    
}

#pragma mark - CMLVIPNewDetailDlegate

- (void) refreshCurrentViewController{
    
    [self.delegate refershCurrentVCData];
}
@end
