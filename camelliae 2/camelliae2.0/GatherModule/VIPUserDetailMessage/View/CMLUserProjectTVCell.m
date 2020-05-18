//
//  CMLUserProjectTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLUserProjectTVCell.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLImageObj.h"
#import "CMLLine.h"
#import "CMLVIPNewsImageShowVC.h"
#import "VCManger.h"
#import "CMLVIPNewDetailVC.h"
#import "ActivityDefaultVC.h"
#import "ProjectInfoObj.h"
#import "CMLUserProjectDetailVC.h"

#define UserImageWidth         80
#define LeftMargin             20
#define TopMargin              30

@interface CMLUserProjectTVCell ()<NetWorkProtocol>

@property (nonatomic,strong) RecommendTimeLineObj *obj;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *userNameLab;

@property (nonatomic,strong) UILabel *userTitleLab;

@property (nonatomic,strong) UIImageView *userMemberLvl;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *topicLab;

@property (nonatomic,strong) UIImageView *BigImage;

@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIImageView *tagImage;

@property (nonatomic,strong) UIButton *deleteBtn;
@end

@implementation CMLUserProjectTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   TopMargin*Proportion,
                                                                   UserImageWidth*Proportion,
                                                                   UserImageWidth*Proportion)];
    self.userImage.clipsToBounds = YES;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.cornerRadius = UserImageWidth*Proportion/2.0;
    self.userImage.userInteractionEnabled = YES;
    [self addSubview:self.userImage];
    
    UIButton *userBtn = [[UIButton alloc] initWithFrame:self.userImage.bounds];
    userBtn.backgroundColor = [UIColor clearColor];
    [self.userImage addSubview:userBtn];
    [userBtn addTarget:self action:@selector(enterUserDetail) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.font = KSystemFontSize14;
    self.userNameLab.textAlignment = NSTextAlignmentLeft;
    self.userNameLab.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.userNameLab];
    
    self.userTitleLab = [[UILabel alloc] init];
    self.userTitleLab.font = KSystemFontSize12;
    self.userTitleLab.textAlignment = NSTextAlignmentLeft;
    self.userTitleLab.textColor = [UIColor CMLLineGrayColor];
    [self addSubview:self.userTitleLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize11;
    self.timeLab.textColor = [UIColor CMLtextInputGrayColor];
    [self addSubview:self.timeLab];
    
    self.userMemberLvl = [[UIImageView alloc] init];
    [self addSubview:self.userMemberLvl];
    
    self.topicLab = [[UILabel alloc] init];
    self.topicLab.textAlignment = NSTextAlignmentLeft;
    self.topicLab.font = KSystemFontSize14;
    self.topicLab.numberOfLines = 2;
    self.topicLab.textColor = [UIColor CMLBrownColor];
    [self addSubview:self.topicLab];
    
    self.tagImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ProjectTagImg]];
    [self.tagImage sizeToFit];
    [self addSubview:self.tagImage];
    
    self.BigImage = [[UIImageView alloc] init];
    self.BigImage.contentMode = UIViewContentModeScaleAspectFill;
    self.BigImage.clipsToBounds = YES;
    self.BigImage.backgroundColor = [UIColor CMLNewGrayColor];
    self.BigImage.userInteractionEnabled = YES;
    [self addSubview:self.BigImage];
    
    
    
    self.attentionBtn = [[UIButton alloc] init];
    [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
    [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
    [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateSelected];
    self.attentionBtn.titleLabel.font = KSystemFontSize11;
    self.attentionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.attentionBtn];
    [self.attentionBtn addTarget:self action:@selector(changeBtnStatus) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn = [[UIButton alloc] init];
    [self.commentBtn setContentMode:UIViewContentModeLeft];
    [self.commentBtn setImage:[UIImage imageNamed:UserTimelIneCommentImg] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = KSystemFontSize11;
    self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.commentBtn];
    [self.commentBtn addTarget:self action:@selector(enterDetailProject) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setContentMode:UIViewContentModeRight];
    [self.deleteBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = KSystemFontSize12;
    [self addSubview:self.deleteBtn];
    self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.deleteBtn addTarget:self action:@selector(deleteCurrentProject) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.bottomLine];
    
}
- (void) refreshCurrentCellWith:(RecommendTimeLineObj *) obj atIndexPath:(NSIndexPath *)indexPath{
    
    self.obj = obj;

    
    [NetWorkTask setImageView:self.userImage  WithURL:obj.gravatar placeholderImage:nil];
    
    self.userNameLab.frame = CGRectZero;
    self.userNameLab.text = obj.nickName;
    [self.userNameLab sizeToFit];
    self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                        self.userImage.center.y - 10*Proportion/2.0 - self.userNameLab.frame.size.height,
                                        self.userNameLab.frame.size.width,
                                        self.userNameLab.frame.size.height);
    
    self.userTitleLab.frame = CGRectZero;
    self.userTitleLab.text = obj.signature;
    [self.userTitleLab sizeToFit];
    self.userTitleLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                         CGRectGetMaxY(self.userNameLab.frame) + 10*Proportion,
                                         WIDTH - (CGRectGetMaxX(self.userImage.frame) + 20*Proportion*2),
                                         self.userTitleLab.frame.size.height);
    
    if (obj.signature.length == 0) {
        
        self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            self.userImage.center.y - self.userNameLab.frame.size.height/2.0,
                                            self.userNameLab.frame.size.width,
                                            self.userNameLab.frame.size.height);
    }else{
        
        self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            TopMargin*Proportion + 10*Proportion,
                                            self.userNameLab.frame.size.width,
                                            self.userNameLab.frame.size.height);
    }
    
    
    switch ([obj.memberLevel intValue]) {
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
    self.userMemberLvl.frame = CGRectMake(CGRectGetMaxX(self.userNameLab.frame) + 10*Proportion,
                                          self.userNameLab.center.y - self.userMemberLvl.frame.size.height/2.0,
                                          self.userMemberLvl.frame.size.width,
                                          self.userMemberLvl.frame.size.height);
    
    self.timeLab.frame = CGRectZero;
    self.timeLab.text = obj.publishTimeStr;
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(WIDTH - 20*Proportion - self.timeLab.frame.size.width,
                                    self.userNameLab.center.y - self.timeLab.frame.size.height/2.0,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    
    self.tagImage.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                     CGRectGetMaxY(self.userImage.frame) + 10*Proportion,
                                     self.tagImage.frame.size.width,
                                     self.tagImage.frame.size.height);
    
    self.topicLab.frame = CGRectZero;
    self.topicLab.text = obj.timelineProjectTitle;
    
    [self.topicLab sizeToFit];
    if (self.topicLab.frame.size.width > 600*Proportion) {
        
        self.topicLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                         CGRectGetMaxY(self.tagImage.frame) + 20*Proportion,
                                         600*Proportion,
                                         self.topicLab.frame.size.height*2);
    }else{
        
        self.topicLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                         CGRectGetMaxY(self.tagImage.frame) + 20*Proportion,
                                         600*Proportion,
                                         self.topicLab.frame.size.height);
    }
    
    
    
    [NetWorkTask setImageView:self.BigImage WithURL:obj.objCoverPic placeholderImage:nil];
    
    self.BigImage.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                     CGRectGetMaxY(self.topicLab.frame) + 10*Proportion,
                                     600*Proportion,
                                     360*Proportion);
    
    [self setOtherBtn:CGRectGetMaxY(self.BigImage.frame)];
    

}

- (void) setOtherBtn:(CGFloat) height{
    
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"%@",self.obj.likeNum] forState:UIControlStateNormal];
    [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",self.obj.commentCount] forState:UIControlStateNormal];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    
    if ([self.obj.isUserLike intValue] ==1) {
        
        self.attentionBtn.selected = YES;
    }
    
    
    self.attentionBtn.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                         height,
                                         90*Proportion,
                                         90*Proportion);
    
    
    
    self.commentBtn.frame = CGRectMake(CGRectGetMaxX(self.attentionBtn.frame) + 20*Proportion,
                                       height,
                                       90*Proportion,
                                       90*Proportion);
    
    if ([self.obj.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        
        self.deleteBtn.hidden = NO;
        self.deleteBtn.frame = CGRectMake(WIDTH - 30*Proportion - 90*Proportion,
                                          height,
                                          90*Proportion,
                                          90*Proportion);
    }else{
        
        self.deleteBtn.hidden = YES;
    }
    
    self.bottomLine.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                       height + 90*Proportion + 10*Proportion,
                                       WIDTH - (CGRectGetMaxX(self.userImage.frame) + 20*Proportion),
                                       1);
    
    
    
    self.currentCellHeight = CGRectGetMaxY(self.commentBtn.frame) + 13*Proportion;
    
    
}


- (void) enterUserDetail{
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.nickName
//                                                          currnetUserId:self.obj.userId
//                                                     isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) changeBtnStatus{
    
    self.attentionBtn.selected = !self.attentionBtn.selected;
    
    if (self.attentionBtn.selected) {
        
        int num = [self.attentionBtn.currentTitle intValue];
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
        [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
        [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    }else{
    
        int num = [self.attentionBtn.currentTitle intValue];
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
        [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
        [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    }
    [self likeCurrent];
}

#pragma mark - likeCurrent
- (void) likeCurrent{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.obj.recordId forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:98] forKey:@"objTypeId"];
    if (!self.attentionBtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.recordId,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }else{
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.recordId,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }
    
    [NetWorkTask postResquestWithApiName:LikeCurrent paraDic:paraDic delegate:delegate];
    
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
  
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
}


- (void) refreshCurrentCellLikebtnStatus:(NSNumber *) status andNum:(int) number{
    
    if ([status intValue] == 1) {
        
        self.attentionBtn.selected = YES;
        
    }else{
        
        self.attentionBtn.selected = NO;
    }
    
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
    [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
}

- (void) deleteCurrentProject{
    
    self.deleteProject(self.obj.recordId);
}

- (void) enterDetailProject{
    CMLUserProjectDetailVC *vc = [[CMLUserProjectDetailVC alloc] initWithObj:self.obj.recordId];
    vc.cell = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

@end
