//
//  CMLVIPTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLVIPTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NSString+CMLExspand.h"
#import "DataManager.h"
#import "VCManger.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"

#define CMLVIPTVCellLeftMargin           30
#define CMLVIPTVCellUserImageTopImage    40
#define CMLVIPTVCellUserImageHeight      100
#define CMLVIPTVCellAttentionBtnHeight   66
#define CMLVIPTVCellAttentionBtnWidth    144


@interface CMLVIPTVCell ()<NetWorkProtocol>


@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UILabel *positionLaabel;

@property (nonatomic,strong) UILabel *specialLvl;

@property (nonatomic,strong) UILabel *normalLvl;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UILabel *fanNumLabel;

@property (nonatomic,strong) UILabel *fanNumPromLabel;

@property (nonatomic,strong) UILabel *attentionLabel;

@property (nonatomic,strong) UILabel *attentionPromLabel;

@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isTemporarySelected;


@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *position;

@property (nonatomic,strong) NSNumber *fanNum;

@property (nonatomic,strong) NSNumber *attentionNum;

@property (nonatomic,strong) NSNumber *uid;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,copy) NSString *vipGrade;

@property (nonatomic,strong) NSNumber *memberPrivilegeLevel;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,strong) NSNumber *attentinState;

@property (nonatomic,assign) BOOL isHiddenAttentionBtn;


@end

@implementation CMLVIPTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(CMLVIPTVCellLeftMargin*Proportion,
                                                               CMLVIPTVCellUserImageTopImage*Proportion,
                                                               CMLVIPTVCellUserImageHeight*Proportion,
                                                               CMLVIPTVCellUserImageHeight*Proportion)];
    _userImage.clipsToBounds = YES;
    _userImage.contentMode = UIViewContentModeScaleAspectFill;
    _userImage.layer.cornerRadius = 8*Proportion;
    [self.contentView addSubview:_userImage];
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.font = KSystemRealBoldFontSize16;
    _nickNameLabel.textColor = [UIColor CMLUserBlackColor];
    _nickNameLabel.backgroundColor = [UIColor whiteColor];
    _nickNameLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_nickNameLabel];
    
    _positionLaabel = [[UILabel alloc] init];
    _positionLaabel.font = KSystemFontSize14;
    _positionLaabel.textColor = [UIColor CMLLineGrayColor];
    _positionLaabel.textAlignment =NSTextAlignmentLeft;
    _positionLaabel.backgroundColor = [UIColor whiteColor];
    _positionLaabel.layer.masksToBounds = YES;
    _positionLaabel.numberOfLines = 2;
    [self.contentView addSubview:_positionLaabel];
    
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:_line];
    
    
    _fanNumLabel = [[UILabel alloc] init];
    _fanNumLabel.font = KSystemBoldFontSize14;
    _fanNumLabel.textColor = [UIColor CMLUserBlackColor];
    _fanNumLabel.backgroundColor = [UIColor whiteColor];
    _fanNumLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_fanNumLabel];
    
    _fanNumPromLabel = [[UILabel alloc] init];
    _fanNumPromLabel.font = KSystemFontSize14;
    _fanNumPromLabel.textColor = [UIColor CMLtextInputGrayColor];
    _fanNumPromLabel.text = @"她的粉丝";
    _fanNumPromLabel.backgroundColor = [UIColor whiteColor];
    _fanNumPromLabel.layer.masksToBounds = YES;
    [_fanNumPromLabel sizeToFit];
    [self.contentView addSubview:_fanNumPromLabel];
    
    
    _attentionLabel = [[UILabel alloc] init];
    _attentionLabel.font = KSystemBoldFontSize14;
    _attentionLabel.textColor = [UIColor CMLUserBlackColor];
    _attentionLabel.backgroundColor = [UIColor whiteColor];
    _attentionLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_attentionLabel];
    
    _attentionPromLabel = [[UILabel alloc] init];
    _attentionPromLabel.font = KSystemFontSize14;
    _attentionPromLabel.textColor = [UIColor CMLtextInputGrayColor];
    _attentionPromLabel.text = @"她的关注";
    _attentionPromLabel.backgroundColor = [UIColor whiteColor];
    _attentionPromLabel.layer.masksToBounds = YES;
    [_attentionPromLabel sizeToFit];
    [self.contentView addSubview:_attentionPromLabel];
    
    self.attentionBtn = [[UIButton alloc] init];
    self.attentionBtn.layer.cornerRadius = 8*Proportion;
    self.attentionBtn.layer.borderWidth = 1;
    self.attentionBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    self.attentionBtn.titleLabel.font = KSystemBoldFontSize14;
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"加关注"] forState:UIControlStateNormal];
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"已关注"] forState:UIControlStateSelected];
    [self.attentionBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.contentView addSubview:self.attentionBtn];
    [self.attentionBtn addTarget:self action:@selector(changeAttentionStatus) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:_bottomView];
    
    
    
    
}

- (void) refreshVIPCellWith:(VIPDetailObj*) obj{


    if (obj) {
        self.nickName = obj.nickName;
        self.fanNum = obj.relFansCount;
        self.attentionNum = obj.relWatchCount;
        self.imageUrl = obj.gravatar;
        self.memberLevelId = obj.memberLevel;
        self.vipGrade = obj.memberVipGrade;
        self.position = obj.title;
        self.uid = obj.uid;
        self.gender = obj.gender;
        self.memberPrivilegeLevel = obj.memberPrivilegeLevel;
        self.attentinState = obj.isUserFollow;
        if ([obj.uid intValue] == [[[DataManager lightData] readUserID] intValue]) {
            self.isHiddenAttentionBtn = YES;
        }else{
            self.isHiddenAttentionBtn = NO;
        }
    }else{
    
        self.nickName = @"test";
        self.fanNum = [NSNumber numberWithInt:1];
        self.attentionNum = [NSNumber numberWithInt:1];
        self.imageUrl = @"test";
        self.memberLevelId = [NSNumber numberWithInt:1];
        self.vipGrade = @"test";
        self.position = @"test";
        self.uid = [NSNumber numberWithInt:1];
    
    }

    [self refreshCurrentCell];
}

- (void) refreshCurrentCell{
    
    [self.specialLvl removeFromSuperview];
    [self.normalLvl removeFromSuperview];
    
    
    if ([self.gender intValue] == 1) {
    
        _fanNumPromLabel.text = @"他的粉丝";
        _attentionPromLabel.text = @"他的关注";
        
    }else if ([self.gender intValue] == 2){
    
        _fanNumPromLabel.text = @"她的粉丝";
        _attentionPromLabel.text = @"她的关注";
        
    }else{
    
        _fanNumPromLabel.text = @"TA的粉丝";
        _attentionPromLabel.text = @"TA的关注";
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[NSString stringWithFormat:@"changeAttentionStatus%@",self.uid]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCurrentAttentionStatus:)
                                                 name:[NSString stringWithFormat:@"changeAttentionStatus%@",self.uid]
                                               object:nil];
    
    [NetWorkTask setImageView:_userImage WithURL:self.imageUrl placeholderImage:nil];
    
    self.nickNameLabel.text = self.nickName;
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                          self.userImage.frame.origin.y,
                                          self.nickNameLabel.frame.size.width,
                                          self.nickNameLabel.frame.size.height);
    
    self.specialLvl = [[UILabel alloc] init];
    self.specialLvl.font = KSystemRealBoldFontSize10;
    self.specialLvl.layer.borderWidth = 1*Proportion;
    self.specialLvl.layer.cornerRadius = 4*Proportion;
    self.specialLvl.textAlignment = NSTextAlignmentCenter;
    self.specialLvl.text = self.vipGrade;
    self.specialLvl.backgroundColor = [UIColor whiteColor];
    self.specialLvl.layer.masksToBounds = YES;
    [self.specialLvl sizeToFit];
    self.specialLvl.textAlignment = NSTextAlignmentCenter;
    self.specialLvl.frame = CGRectMake(CGRectGetMaxX(self.nickNameLabel.frame) + 11*Proportion,
                                       self.nickNameLabel.center.y - 32*Proportion/2.0,
                                       self.specialLvl.frame.size.width + 12*Proportion,
                                       32*Proportion);
    [self.contentView addSubview:self.specialLvl];
    self.specialLvl.layer.borderColor = [UIColor getLvlColor:self.memberLevelId].CGColor;
    self.specialLvl.textColor = [UIColor getLvlColor:self.memberLevelId];
    
    self.normalLvl = [[UILabel alloc] init];
    self.normalLvl.font = KSystemRealBoldFontSize10;
    self.normalLvl.layer.cornerRadius = 4*Proportion;
    self.normalLvl.layer.borderWidth = 1*Proportion;
    self.normalLvl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.normalLvl];

    switch ([self.memberPrivilegeLevel intValue]) {
        case 0:
            self.normalLvl.hidden = YES;
            break;
            
        case 1:
            self.normalLvl.hidden = YES;
        break;
        
        case 2:
            self.normalLvl.text = @"黛色特权";
            self.normalLvl.layer.borderColor = [UIColor CMLBlackPigmentColor].CGColor;
            self.normalLvl.textColor = [UIColor CMLBlackPigmentColor];
        break;
            
        case 3:
            self.normalLvl.text = @"金色特权";
            self.normalLvl.layer.borderColor = [UIColor CMLGoldColor].CGColor;
            self.normalLvl.textColor = [UIColor CMLGoldColor];
            break;
            
        case 4:
            self.normalLvl.hidden = YES;
            break;
            
        default:
            break;
    }

    [self.normalLvl sizeToFit];
    self.normalLvl.frame = CGRectMake(CGRectGetMaxX(self.specialLvl.frame) + 10*Proportion,
                                      self.specialLvl.frame.origin.y,
                                      self.normalLvl.frame.size.width + 12*Proportion,
                                      32*Proportion);

    
    /**昵称过长时*/
    if (CGRectGetMaxX(self.normalLvl.frame) > (WIDTH - 30*Proportion)) {
        
        self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                              self.userImage.frame.origin.y,
                                              WIDTH - self.specialLvl.frame.size.width - self.normalLvl.frame.size.width - 30*Proportion - 10*Proportion - 11*Proportion - CGRectGetMaxX(self.userImage.frame) - 20*Proportion - 12*Proportion*2,
                                              self.nickNameLabel.frame.size.height);
        
        self.specialLvl.frame = CGRectMake(self.normalLvl.frame.origin.x - 11*Proportion - self.specialLvl.frame.size.width - 12*Proportion,
                                           self.nickNameLabel.center.y - 32*Proportion/2.0,
                                           self.specialLvl.frame.size.width + 12*Proportion,
                                           32*Proportion);
        
        self.normalLvl.frame = CGRectMake(WIDTH - 30*Proportion - self.normalLvl.frame.size.width - 12*Proportion,
                                          self.specialLvl.frame.origin.y,
                                          self.normalLvl.frame.size.width + 12*Proportion,
                                          32*Proportion);
        
    }
    
    
    self.positionLaabel.text = self.position;
    CGRect positionRect = [self.positionLaabel.text boundingRectWithSize:CGSizeMake(WIDTH - CGRectGetMaxX(self.userImage.frame) - 20*Proportion - 30*Proportion, 1000)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                                 context:nil];
    
    self.positionLaabel.frame = CGRectMake(self.nickNameLabel.frame.origin.x,
                                           CGRectGetMaxY(self.nickNameLabel.frame) + 10*Proportion,
                                           WIDTH - CGRectGetMaxX(self.userImage.frame) - 20*Proportion - 30*Proportion,
                                           positionRect.size.height);
    
    self.line.frame = CGRectMake(30*Proportion,
                                 CGRectGetMaxY(self.userImage.frame) + 20*Proportion,
                                 WIDTH - 30*Proportion*2,
                                 1*Proportion);
    
    self.attentionLabel.text = [NSString stringWithFormat:@"%@",self.attentionNum];
    [self.attentionLabel sizeToFit];
    
    self.attentionPromLabel.frame = CGRectMake(self.userImage.frame.origin.x,
                                               CGRectGetMaxY(self.userImage.frame) + 20*Proportion + 30*Proportion + 10*Proportion + self.attentionLabel.frame.size.height,
                                               self.attentionPromLabel.frame.size.width,
                                               self.attentionPromLabel.frame.size.height);
    
    self.attentionLabel.frame = CGRectMake(self.attentionPromLabel.center.x - self.attentionLabel.frame.size.width/2.0,
                                           CGRectGetMaxY(self.userImage.frame) + 20*Proportion + 30*Proportion,
                                           self.attentionLabel.frame.size.width,
                                           self.attentionLabel.frame.size.height);
    
    self.fanNumLabel.text = [NSString stringWithFormat:@"%@",self.fanNum];
    [self.fanNumLabel sizeToFit];
    
    self.fanNumPromLabel.frame = CGRectMake(CGRectGetMaxX(self.attentionPromLabel.frame) + 135*Proportion,
                                            self.attentionPromLabel.frame.origin.y,
                                            self.fanNumPromLabel.frame.size.width,
                                            self.fanNumPromLabel.frame.size.height);
    self.fanNumLabel.frame = CGRectMake(self.fanNumPromLabel.center.x - self.fanNumLabel.frame.size.width/2.0,
                                        self.attentionLabel.frame.origin.y,
                                        self.fanNumLabel.frame.size.width,
                                        self.fanNumLabel.frame.size.height);
    

    
    
    self.attentionBtn.frame = CGRectMake(WIDTH - CMLVIPTVCellAttentionBtnWidth*Proportion - CMLVIPTVCellLeftMargin*Proportion,
                                         CGRectGetMaxY(self.fanNumPromLabel.frame) - CMLVIPTVCellAttentionBtnHeight*Proportion,
                                         CMLVIPTVCellAttentionBtnWidth*Proportion,
                                         CMLVIPTVCellAttentionBtnHeight*Proportion);
    
    
    
    
    if ([self.attentinState intValue] == 1) {
        self.attentionBtn.selected = YES;
        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
        
    }else{
        self.attentionBtn.selected = NO;
        self.attentionBtn.backgroundColor = [UIColor whiteColor];
    }

    
    _bottomView.frame = CGRectMake(0,
                                   CGRectGetMaxY(self.attentionBtn.frame) + 40*Proportion,
                                   WIDTH,
                                   20*Proportion);
    
    if (self.isHiddenAttentionBtn) {
        self.attentionBtn.hidden = YES;
    }
    
    /**长度*/
    
    self.cellHeight = CGRectGetMaxY(_bottomView.frame);
    
}

#pragma mark - changeAttentionStatus
- (void) changeAttentionStatus{
    self.attentionBtn.selected  = !self.attentionBtn.selected;
    /**关注状态*/
    if (self.attentionBtn.selected) {
        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:1] andUserId:self.uid];

    }else{
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:2] andUserId:self.uid];
    }
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
    
    
    /**打点*/
    [MobClick event:@"Attention"];
    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:AttentionVIPMember]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
        }else{
            /**关注状态*/
            if (self.attentionBtn.selected) {
                self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
                self.attentionBtn.selected = NO;

            }else{
                self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
                self.attentionBtn.selected = YES;

            }
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    /**关注状态*/
    if (self.attentionBtn.selected) {
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.attentionBtn.selected = NO;

    }else{
        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];
        self.attentionBtn.selected = YES;

    }
}

- (void) changeCurrentAttentionStatus:(NSNotification *) noti{
    
    if ([[noti.userInfo valueForKey:@"state"] intValue]== 1) {
        self.attentionBtn.selected = YES;
        self.attentionBtn.backgroundColor = [UIColor CMLBrownColor];


    }else{
        self.attentionBtn.selected = NO;
        self.attentionBtn.backgroundColor = [UIColor whiteColor];
    }
}


@end
