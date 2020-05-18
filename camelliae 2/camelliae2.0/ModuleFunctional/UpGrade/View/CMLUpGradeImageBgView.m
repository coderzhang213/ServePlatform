//
//  CMLUpGradeImageBgView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/8.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLUpGradeImageBgView.h"
#import "ShowMemberEquityView.h"
#import "CMLPCMemberCardModel.h"

@interface CMLUpGradeImageBgView ()<ShowMemberEquityViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) ShowMemberEquityView *equityBgView;

@property (nonatomic, strong) BaseResultObj *roleObj;

@property (nonatomic, strong) CMLPCMemberCardModel *cardModel;

@end

@implementation CMLUpGradeImageBgView

- (instancetype)initWithFrame:(CGRect)frame withRoleObj:(BaseResultObj *)roleObj {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.roleObj = roleObj;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSInteger roleId = [[[DataManager lightData] readRoleId] integerValue];
    for (int i = 0; i < self.roleObj.retData.dataList.count; i++) {
        self.cardModel = [CMLPCMemberCardModel getBaseObjFrom:self.roleObj.retData.dataList[i]];
        if ([self.cardModel.role_id intValue] == 6) {
            self.cardModel.role_id = [NSNumber numberWithInteger:5];
        }
        /*角色背景*/
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberCenterLvlNoSelectBgImg]];
        if ([self.cardModel.role_id intValue] == roleId) {
//            [NetWorkTask setImageView:self.imageView WithURL:self.cardModel.logoUrl placeholderImage:[UIImage imageNamed:CMLMemberCenterLvlNoSelectBgImg]];
            NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardModel.logoUrl]];
            UIImage *image = [UIImage imageWithData:imageNata];
            self.imageView.image = image;
        }
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        [self.imageView sizeToFit];
        self.imageView.frame = CGRectMake(75*Proportion + 601*Proportion*i + 20 * Proportion * i,
                                          12*Proportion,
                                          601*Proportion,
                                          919*Proportion);

        [self addSubview:self.imageView];
        
        /*灰色背景*/
        UIImageView *imageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UserUpGradeBg1Img]];
        imageBgView.clipsToBounds = YES;
        imageBgView.contentMode = UIViewContentModeScaleAspectFill;
        imageBgView.userInteractionEnabled = YES;
        [imageBgView sizeToFit];
        imageBgView.frame = CGRectMake(self.imageView.center.x - imageBgView.frame.size.width/2.0,
                                       0,
                                       imageBgView.frame.size.width,
                                       imageBgView.frame.size.height);
        [self addSubview:imageBgView];
        [self sendSubviewToBack:imageBgView];

        if ([self.cardModel.role_id intValue] == 7) {
            /*金色会员权益介绍*/
            UIButton *introduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width - 55 * Proportion - 150 * Proportion,
                                                                                180 * Proportion,
                                                                                150 * Proportion,
                                                                                40 * Proportion)];
            introduceBtn.layer.cornerRadius = 10 * Proportion;
            introduceBtn.backgroundColor = [UIColor clearColor];
            introduceBtn.layer.borderWidth = 1;
            introduceBtn.layer.borderColor = [UIColor CMLWhiteColor].CGColor;
            introduceBtn.titleLabel.font = KSystemFontSize10;
            [introduceBtn setTitle:@"会员权益介绍" forState:UIControlStateNormal];
            [introduceBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
            [self.imageView addSubview:introduceBtn];
            [introduceBtn addTarget:self action:@selector(enterGoldIntroduce) forControlEvents:UIControlEventTouchUpInside];
        }
        
        /*会员有效期*/
        if ([self.cardModel.role_id intValue] == roleId) {
            /*readDistributionLevel 1-980 2-9800 3-38000（五年）4-38000（原来的分享成员）*/
            if ([[DataManager lightData] readDistributionEndTime].length > 0) {
                if ([[[DataManager lightData] readUserLevel] intValue] == 2 && [[[DataManager lightData] readDistributionLevel] intValue] == 4) {
                   
                }else {
                    UILabel *endTimeLabel = [[UILabel alloc] init];
                    endTimeLabel.text = [NSString stringWithFormat:@"会员至%@", [[DataManager lightData] readDistributionEndTime]];
                    endTimeLabel.font = KSystemFontSize10;
                    endTimeLabel.textColor = [UIColor whiteColor];
                    [endTimeLabel sizeToFit];
                    endTimeLabel.frame = CGRectMake(CGRectGetWidth(imageBgView.frame) - CGRectGetWidth(endTimeLabel.frame),
                                                    142 * Proportion,
                                                    CGRectGetWidth(endTimeLabel.frame),
                                                    CGRectGetHeight(endTimeLabel.frame));
                    [self.imageView addSubview:endTimeLabel];
                }
            }
        }
        /*会员专属权益*/
        self.equityBgView = [[ShowMemberEquityView alloc] initWithFrame:CGRectMake(30 * Proportion,
                                                                                   238 * Proportion,
                                                                                   self.imageView.frame.size.width - 2 * 30 * Proportion,
                                                                                   self.imageView.frame.size.height - 34 * Proportion - 238 * Proportion)
                                                      withRoleCardModel:self.cardModel];
        
        self.equityBgView.delegate = self;
        [self.imageView addSubview:self.equityBgView];
            
        [self loadTitleViewsWithNum:i];
        if ([self.cardModel.role_id intValue] >= roleId) {
            if ([self.cardModel.isSell intValue] == 1) {
                /*升级按钮*/
                UIButton *upGradeButton = [[UIButton alloc] init];
                upGradeButton.tag = [self.cardModel.role_id intValue];
                [upGradeButton setBackgroundImage:[UIImage imageNamed:CMLNewPersonalMemberEnterButton] forState:UIControlStateNormal];
                [upGradeButton setTitle:@"立即升级会员" forState:UIControlStateNormal];
                [upGradeButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
                [upGradeButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                if ([self.cardModel.role_id integerValue] == roleId) {
                    [upGradeButton setTitle:@"立即续费" forState:UIControlStateNormal];
                }
                [upGradeButton sizeToFit];
                upGradeButton.frame = CGRectMake(self.imageView.frame.size.width/2.0 - upGradeButton.frame.size.width/2.0,
                                                 self.imageView.frame.size.height - 63*Proportion - upGradeButton.frame.size.height,
                                                 upGradeButton.frame.size.width,
                                                 upGradeButton.frame.size.height);
                [self.imageView addSubview:upGradeButton];
                [upGradeButton addTarget:self action:@selector(pickBlackPigmentMember:) forControlEvents:UIControlEventTouchUpInside];
            
            }else {
                if ([self.cardModel.role_id intValue] == 11 && roleId < 11) {
                    /*申请按钮*/
                    UIButton *upGradeButton = [[UIButton alloc] init];
                    upGradeButton.tag = [self.cardModel.role_id intValue];
                    
                    [upGradeButton setBackgroundImage:[UIImage imageNamed:CMLNewPersonalMemberEnterButton] forState:UIControlStateNormal];
                    [upGradeButton sizeToFit];
                    upGradeButton.frame = CGRectMake(self.imageView.frame.size.width/2.0 - upGradeButton.frame.size.width/2.0,
                                                     self.imageView.frame.size.height - 63*Proportion - upGradeButton.frame.size.height,
                                                     upGradeButton.frame.size.width,
                                                     upGradeButton.frame.size.height);
                    [upGradeButton setTitle:@"立即申请" forState:UIControlStateNormal];
                    [upGradeButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
                    [upGradeButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                    [self.imageView addSubview:upGradeButton];
                    [upGradeButton addTarget:self action:@selector(cityPartnerApplyButtonClick) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}

/*会员身份标识等-金色以下*/
- (void)loadTitleViewsWithNum:(int)num {
    CMLPCMemberCardModel *cardModel = [CMLPCMemberCardModel getBaseObjFrom:self.roleObj.retData.dataList[num]];
    if ([cardModel.role_id intValue] == 6) {
        cardModel.role_id = [NSNumber numberWithInteger:5];
    }
    NSLog(@"[[[DataManager lightData] readRoleId] intValue] %d", num);    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.frame.size.width,
                                                                           238 * Proportion)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.clipsToBounds = YES;
    [self.imageView addSubview:titleView];
    
    /*横线*/
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(54 * Proportion,
                                                                   102 * Proportion,
                                                                   55 * Proportion,
                                                                   6 * Proportion)];
    lineLabel.backgroundColor = [UIColor CMLWhiteColor];
    lineLabel.layer.cornerRadius = 3 * Proportion;
    lineLabel.clipsToBounds = YES;
    [titleView addSubview:lineLabel];
    
    /*会员中心V图标*/
    UIImageView *vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberCenterLvlNoSelectIcon]];
    vImageView.backgroundColor = [UIColor clearColor];
    vImageView.contentMode = UIViewContentModeScaleAspectFill;
    [vImageView sizeToFit];
    vImageView.frame = CGRectMake(CGRectGetMinX(lineLabel.frame) - 14 * Proportion,
                                  CGRectGetMaxY(lineLabel.frame) + 15 * Proportion,
                                  vImageView.frame.size.width,
                                  vImageView.frame.size.height);
    [titleView addSubview:vImageView];

    NSInteger roleId = [[[DataManager lightData] readRoleId] integerValue];
    if ([cardModel.role_id intValue] == roleId) {
        [NetWorkTask setImageView:vImageView WithURL:cardModel.vUrl placeholderImage:[UIImage imageNamed:CMLMemberCenterLvlNoSelectIcon]];
    }
    
    /*会员身份*/
    UILabel *memberLabel = [[UILabel alloc] init];
    memberLabel.text = cardModel.group_name;
    memberLabel.textColor = [UIColor CMLWhiteColor];
    memberLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [memberLabel sizeToFit];
    memberLabel.frame = CGRectMake(CGRectGetMaxX(vImageView.frame),
                                   CGRectGetMidY(vImageView.frame) - CGRectGetHeight(memberLabel.frame)/2.0,
                                   CGRectGetWidth(memberLabel.frame),
                                   CGRectGetHeight(memberLabel.frame));
    [titleView addSubview:memberLabel];
    
    /*权益num*/
    UILabel *numLabel = [[UILabel alloc] init];
    NSString *numString = [NSString stringWithFormat:@"专属 %@ 项权益", cardModel.equityCount];
    numLabel.textColor = [UIColor CMLWhiteColor];
    numLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    NSMutableAttributedString *numAttString = [[NSMutableAttributedString alloc] initWithString:numString];
    [numAttString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"BanglaSangamMN" size:14]} range:NSMakeRange(3, 1)];
    numLabel.attributedText = numAttString;
    [numLabel sizeToFit];
    numLabel.frame = CGRectMake(CGRectGetMinX(lineLabel.frame),
                                CGRectGetMaxY(vImageView.frame) - 4 * Proportion,
                                CGRectGetWidth(numLabel.frame),
                                CGRectGetHeight(numLabel.frame));
    [titleView addSubview:numLabel];
    
}

/*立即申请：拨打电话*/
- (void)cityPartnerApplyButtonClick {
    [self.delegate cityPartnerApplyButtonClickOfUpGradeImageBgView];
}

- (void)pickBlackPigmentMember:(UIButton *)button {
    NSLog(@"(long)button.tag %ld", (long)button.tag);
    [self.delegate pickBlackPigmentMemberOfImageBgView:button];
}

- (void)showMessage:(UIButton *)button {
    
    [self.delegate showMessageOfImageBgView:button];
}

- (void)enterGoldIntroduce {
    
    [self.delegate enterGoldIntroduceOfImageBgView];
}

#pragma mark - ShowMemberEquityViewDelegate
- (void)showMemberEquityViewButtonClickedDelegateWith:(int)location {
    
    [self.delegate showMemberEquityViewOfImageBgViewWith:location];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
