//
//  CMLTansAndAttentionTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLFansAndAttentionTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"

#define CMLFansAndAttentionLeftMargin            30
#define CMLFansAndAttentionTopMargin             30
#define CMLFansAndAttentionUserHeadImageHeight   100
#define CMLFansAndAttentionBtnHeight             52
#define CMLFansAndAttentionBtnWidth              112

@interface CMLFansAndAttentionTVCell ()<NetWorkProtocol>

@property (nonatomic,strong) UIImageView *userHeadImage;

@property (nonatomic,strong) UIImageView *userMemberLvl;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UILabel *userPositionLabel;

@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLFansAndAttentionTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    /**用户头像*/
    self.userHeadImage = [[UIImageView alloc] init];
    self.userHeadImage.userInteractionEnabled = YES;
    self.userHeadImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userHeadImage.clipsToBounds = YES;
    [self addSubview:self.userHeadImage];
    self.userHeadImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.userHeadImage.layer.cornerRadius = 6*Proportion;
    self.userHeadImage.frame = CGRectMake(CMLFansAndAttentionLeftMargin*Proportion,
                                          CMLFansAndAttentionTopMargin*Proportion,
                                          CMLFansAndAttentionUserHeadImageHeight*Proportion,
                                          CMLFansAndAttentionUserHeadImageHeight*Proportion);
    
    /**用户名*/
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = KSystemFontSize14;
    self.userNameLabel.textColor = [UIColor CMLUserBlackColor];
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.userNameLabel];
    
     /**用户级别*/
    self.userMemberLvl = [[UIImageView alloc] init];
    [self addSubview:self.userMemberLvl];
   
    
    /**用户职位*/
    self.userPositionLabel = [[UILabel alloc] init];
    self.userPositionLabel.textColor = [UIColor CMLLineGrayColor];
    self.userPositionLabel.font = KSystemFontSize12;
    self.userPositionLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.userPositionLabel];
    
    /**关注按键*/
    self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30*Proportion - CMLFansAndAttentionBtnWidth*Proportion,
                                                                  (CMLFansAndAttentionTopMargin*2 + CMLFansAndAttentionUserHeadImageHeight)*Proportion/2.0 - CMLFansAndAttentionBtnHeight*Proportion/2.0,
                                                                  CMLFansAndAttentionBtnWidth*Proportion,
                                                                   CMLFansAndAttentionBtnHeight*Proportion)];
    self.attentionBtn.layer.cornerRadius = 4*Proportion;
    self.attentionBtn.layer.borderWidth = 2*Proportion;
    self.attentionBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    [self.attentionBtn setTitle:@"加关注" forState:UIControlStateNormal];
    
    [self.attentionBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
    [self addSubview:self.attentionBtn];
    self.attentionBtn.titleLabel.font = KSystemBoldFontSize12;
    [self.attentionBtn addTarget:self action:@selector(attentionCurrentUser) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) refershCurrentTVCell{

    [NetWorkTask setImageView:self.userHeadImage WithURL:self.userHeadeImageUrl placeholderImage:nil];
    
    self.userNameLabel.text = self.userName;
    [self.userNameLabel sizeToFit];
    self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userHeadImage.frame) + 20*Proportion,
                                          self.userHeadImage.center.y - 5*Proportion - self.userNameLabel.frame.size.height,
                                          self.userNameLabel.frame.size.width,
                                          self.userNameLabel.frame.size.height);
    
    switch ([self.userLevel intValue]) {
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
    self.userMemberLvl.frame = CGRectMake(CGRectGetMaxX(self.userNameLabel.frame) + 10*Proportion,
                                          self.userNameLabel.center.y - self.userMemberLvl.frame.size.height/2.0,
                                          self.userMemberLvl.frame.size.width,
                                          self.userMemberLvl.frame.size.height);
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = KSystemFontSize13;
    testLabel.text = @"测试";
    [testLabel sizeToFit];
    
    self.userPositionLabel.text = self.userPosition;
    [self.userPositionLabel sizeToFit];
    if (self.userPositionLabel.frame.size.width > (WIDTH - 20*Proportion*4 - self.userHeadImage.frame.size.width - CMLFansAndAttentionBtnWidth*Proportion)) {
        self.userPositionLabel.frame = CGRectMake(CGRectGetMaxX(self.userHeadImage.frame) + 20*Proportion,
                                                  CGRectGetMaxY(self.userNameLabel.frame) + 10*Proportion,
                                                  WIDTH - 20*Proportion*4 - self.userHeadImage.frame.size.width - CMLFansAndAttentionBtnWidth*Proportion,
                                                  testLabel.frame.size.height*2);
        
    }else{
        self.userPositionLabel.frame = CGRectMake(CGRectGetMaxX(self.userHeadImage.frame) + 20*Proportion,
                                                  CGRectGetMaxY(self.userNameLabel.frame) + 10*Proportion,
                                                  WIDTH - 20*Proportion*4 - self.userHeadImage.frame.size.width - CMLFansAndAttentionBtnWidth*Proportion,
                                                  testLabel.frame.size.height);
    }
    
   
    if (self.isOwnList) {
        
        [self.attentionBtn setTitle:@"" forState:UIControlStateSelected];
        [self.attentionBtn setImage:[UIImage imageNamed:BothFollowImg] forState:UIControlStateSelected];
        
    }else{
        
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [self.attentionBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
    }
    
    if ([self.isAttention intValue] == 1) {
        
        self.attentionBtn.selected = YES;
        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
        self.attentionBtn.userInteractionEnabled = NO;
    }else{
        self.attentionBtn.selected = NO;
        self.attentionBtn.userInteractionEnabled = YES;
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
    }
    
    if ([self.currentUserId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        self.attentionBtn.hidden = YES;
    }else{
       self.attentionBtn.hidden = NO;
    }
}

- (void) attentionCurrentUser{

    self.attentionBtn.selected = YES;
    self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
    self.attentionBtn.userInteractionEnabled = NO;
    
    [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:1] andUserId:self.currentUserId];

}


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
    self.currentApiName = AttentionVIPMember;
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:AttentionVIPMember]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"changeAttentionStatus%@",self.currentUserId] object:nil];
            self.attentionBtn.userInteractionEnabled = NO;
        }else{
            self.attentionBtn.userInteractionEnabled = YES;
            /**关注状态*/
            self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
            self.attentionBtn.selected = NO;

        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    

    if ([self.currentApiName isEqualToString:AttentionVIPMember]) {
        
        /**关注状态*/
        if (self.attentionBtn.selected) {
            self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
            self.attentionBtn.selected = NO;

        }else{
            self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
            self.attentionBtn.selected = YES;

        }
    }
}
@end
