//
//  CMLUserPushActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/13.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLUserPushActivityTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"
#import "NSDate+CMLExspand.h"

@interface CMLUserPushActivityTVCell()

@property (nonatomic,strong) UIView *userMesBgView;

@property (nonatomic,strong) UIImageView *userLvlImg;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UIButton *userBtn;

@property (nonatomic,strong) NSNumber *userID;

@property (nonatomic,strong) UILabel *userNickNameLab;

@property (nonatomic,strong) UILabel *userPositionLab;


@property (nonatomic,strong) UIImageView *mainImg;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIImageView *timeImg;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UIImageView *addressImg;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UILabel *addressLab;

@property (nonatomic,strong) UIView *endView;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy) NSString *currentNickName;

@property (nonatomic,strong) NSNumber *currentUserID;

/*新增：审核状态*/
@property (nonatomic, strong) UILabel *checkStatusLabel;

@property (nonatomic, strong) CMLUserPorjectObj *obj;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;

@end

@implementation CMLUserPushActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    self.userMesBgView = [[UIView alloc] initWithFrame: CGRectMake(0,
                                                                   0,
                                                                   WIDTH,
                                                                   162*Proportion)];
    self.userMesBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.userMesBgView];
    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   162*Proportion/2.0 - 80*Proportion/2.0,
                                                                   80*Proportion,
                                                                   80*Proportion)];
    self.userImage.layer.cornerRadius = 80*Proportion/2.0;
    self.userImage.userInteractionEnabled = YES;
    self.userImage.clipsToBounds = YES;
    self.userImage.backgroundColor = [UIColor CMLUserGrayColor];
    [self.userMesBgView addSubview:self.userImage];
    
    self.userBtn = [[UIButton alloc] initWithFrame:self.userImage.bounds];
    self.userBtn.backgroundColor = [UIColor clearColor];
    [self.userImage addSubview:self.userBtn];
    [self.userBtn addTarget:self action:@selector(enterUserDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    /*昵称*/
    self.userNickNameLab = [[UILabel alloc] init];
    self.userNickNameLab.font = KSystemRealBoldFontSize14;
    self.userNickNameLab.textColor = [UIColor CMLBlackColor];
    [self.userMesBgView addSubview:self.userNickNameLab];
    
    /*定位-简介*/
    self.userPositionLab = [[UILabel alloc] init];
    self.userPositionLab.font = KSystemFontSize12;
    self.userPositionLab.textColor = [UIColor CMLBrownColor];
    [self.userMesBgView addSubview:self.userPositionLab];
    
    
    self.mainImg = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                 CGRectGetMaxY(self.userMesBgView.frame),
                                                                 WIDTH - 30*Proportion*2,
                                                                 (WIDTH - 30*Proportion*2)/690*389)];
    self.mainImg.clipsToBounds = YES;
    self.mainImg.userInteractionEnabled = YES;
    self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImg.layer.cornerRadius = 6*Proportion;
    [self.contentView addSubview:self.mainImg];

    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize15;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.numberOfLines = 1;
    [self.contentView addSubview:self.titleLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.textColor = [UIColor CMLBrownColor];
    self.priceLab.font = KSystemBoldFontSize18;
    [self.contentView addSubview:self.priceLab];
    
    self.timeImg = [[UIImageView alloc] init];
    self.timeImg.contentMode = UIViewContentModeScaleAspectFill;
    self.timeImg.image = [UIImage imageNamed:ListActivityTimeImg];
    self.timeImg.clipsToBounds = YES;
    [self.contentView addSubview:self.timeImg];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize12;
    self.timeLab.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.contentView addSubview:self.timeLab];
    
    /*新增L：浏览量*/
    self.hitImageView = [[UIImageView alloc] init];
    self.hitImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hitImageView.image = [UIImage imageNamed:CMLHitImage];
    self.hitImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.hitImageView];
    
    self.hitLabel = [[UILabel alloc] init];
    self.hitLabel.font = KSystemFontSize12;
    self.hitLabel.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.contentView addSubview:self.hitLabel];
    
    self.addressImg = [[UIImageView alloc] init];
    self.addressImg.contentMode = UIViewContentModeScaleAspectFill;
    self.addressImg.image = [UIImage imageNamed:ListActivityAddressImg];
    self.addressImg.clipsToBounds = YES;
    [self.contentView addSubview:self.addressImg];
    
    self.addressLab = [[UILabel alloc] init];
    self.addressLab.font = KSystemFontSize12;
    self.addressLab.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.contentView addSubview:self.addressLab];
    
    self.endView = [[UIView alloc] init];
    self.endView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self.contentView addSubview:self.endView];
    
    
    self.userLvlImg = [[UIImageView alloc] init];
    self.userLvlImg.backgroundColor = [UIColor CMLWhiteColor];
    self.userLvlImg.clipsToBounds = YES;
    [self.contentView addSubview:self.userLvlImg];

    /*审核状态*/
    [self.mainImg addSubview:self.checkStatusLabel];
}

- (void) refrshCurrentTVCellOf:(CMLUserPorjectObj *) obj{
    
    
    [NetWorkTask setImageView:self.userImage WithURL:obj.gravatar placeholderImage:nil];
    [NetWorkTask setImageView:self.mainImg WithURL:obj.coverPic placeholderImage:nil];
    
    
    switch ([obj.memberLevel intValue]) {
        case 1:
            
            self.userLvlImg.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
            
        case 2:
            
            self.userLvlImg.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
            
        case 3:
            
            self.userLvlImg.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
            
        case 4:
            
            self.userLvlImg.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    
    [self.userLvlImg sizeToFit];
    self.userLvlImg.layer.cornerRadius = self.userLvlImg.frame.size.width/2.0;
    self.userLvlImg.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) - self.userLvlImg.frame.size.width,
                                       CGRectGetMaxY(self.userImage.frame) - self.userLvlImg.frame.size.height,
                                       self.userLvlImg.frame.size.width,
                                       self.userLvlImg.frame.size.height);
    self.currentNickName = obj.nickName;
    self.currentUserID = obj.userId;
    self.userNickNameLab.text = obj.nickName;
    [self.userNickNameLab sizeToFit];
    
    self.userPositionLab.text = obj.signature;
    [self.userPositionLab sizeToFit];
/*/    self.userNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
//                                            self.userImage.center.y - 10*Proportion/2.0 - self.userNickNameLab.frame.size.height,
//                                            self.userNickNameLab.frame.size.width,
//                                            self.userNickNameLab.frame.size.height);
//    self.userPositionLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
//                                            CGRectGetMaxY(self.userNickNameLab.frame) + 10*Proportion,
//                                            self.userPositionLab.frame.size.width,
//                                            self.userPositionLab.frame.size.height);
 */
    self.userNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            self.userImage.frame.origin.y + 3,
                                            self.userNickNameLab.frame.size.width,
                                            self.userNickNameLab.frame.size.height);
    self.userPositionLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            CGRectGetMaxY(self.userNickNameLab.frame) + 10*Proportion,
                                            self.userPositionLab.frame.size.width,
                                            self.userPositionLab.frame.size.height);
    
    self.titleLab.text = obj.title;
    [self.titleLab sizeToFit];
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.mainImg.frame) + 17*Proportion,
                                     WIDTH - 30*Proportion*2,
                                     self.titleLab.frame.size.height);
    if ([obj.price intValue] == 0) {
    
        self.priceLab.text  =  @"免费";
        
    }else{
        
       self.priceLab.text  =  [NSString stringWithFormat:@"¥%@",obj.price];
    }
    
    [self.priceLab sizeToFit];
    
#pragma /*多偏移1对齐上一行*/
    self.priceLab.frame = CGRectMake(30*Proportion - 1,
                                     CGRectGetMaxY(self.titleLab.frame) + 10*Proportion,
                                     self.priceLab.frame.size.width,
                                     self.priceLab.frame.size.height);
    
    self.addressLab.text = obj.cityName;
    [self.addressLab sizeToFit];
    self.addressLab.frame = CGRectMake(WIDTH - 30*Proportion - self.addressLab.frame.size.width ,
                                       CGRectGetMaxY(self.titleLab.frame) + 45*Proportion,
                                       self.addressLab.frame.size.width,
                                       self.addressLab.frame.size.height);
    
    [self.addressImg sizeToFit];
    self.addressImg.frame = CGRectMake(self.addressLab.frame.origin.x - 10*Proportion - self.addressImg.frame.size.width,
                                       self.addressLab.center.y - self.addressImg.frame.size.height/2.0,
                                       self.addressImg.frame.size.width,
                                       self.addressImg.frame.size.height);
    
    self.timeLab.text =  [NSString getProjectStartTime:obj.actBeginTime];
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(self.addressImg.frame.origin.x - 26*Proportion - self.timeLab.frame.size.width,
                                     self.addressLab.center.y - self.timeLab.frame.size.height/2.0,
                                     self.timeLab.frame.size.width,
                                     self.timeLab.frame.size.height);
    
    [self.timeImg sizeToFit];
    self.timeImg.frame = CGRectMake(self.timeLab.frame.origin.x - 10*Proportion - self.timeImg.frame.size.width,
                                    self.timeLab.center.y - self.timeImg.frame.size.height/2.0,
                                    self.timeImg.frame.size.width,
                                    self.timeImg.frame.size.height);
    
    /*新增：浏览量*/
    if (obj.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", obj.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }
    
    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(self.timeImg.frame.origin.x - 26*Proportion - self.hitLabel.frame.size.width,
                                    self.timeLab.center.y - self.hitLabel.frame.size.height/2.0,
                                    self.hitLabel.frame.size.width,
                                    self.hitLabel.frame.size.height);
    
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(self.hitLabel.frame.origin.x - 10*Proportion - self.hitImageView.frame.size.width,
                                    self.hitLabel.center.y - self.hitImageView.frame.size.height/2.0,
                                    self.hitImageView.frame.size.width,
                                    self.hitImageView.frame.size.height);
    
    
    self.endView.frame = CGRectMake(0, CGRectGetMaxY(self.timeImg.frame) + 37*Proportion,
                                    WIDTH,
                                    20*Proportion);
    
    self.cellHeight = CGRectGetMaxY(self.timeImg.frame) + 37*Proportion + 20*Proportion;
    
    /*新增：审核状态 1-审核通过 3-审核中*/
    if ([obj.status intValue] == 3 && obj.userId == [[DataManager lightData] readUserID]) {
        self.checkStatusLabel.hidden = NO;
    }else {
        self.checkStatusLabel.hidden = YES;
    }
    
    if (self.isEdit && obj.userId == [[DataManager lightData] readUserID]) {
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mainImg.frame) - 20 * Proportion - 120 * Proportion,
                                                                         CGRectGetMaxY(self.mainImg.frame) - 20 * Proportion - 46 * Proportion,
                                                                         120 * Proportion,
                                                                         46 * Proportion)];
        
        deleteBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
        deleteBtn.layer.cornerRadius = 6 * Proportion;
        deleteBtn.clipsToBounds = YES;
        deleteBtn.titleLabel.font = KSystemBoldFontSize14;//[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.contentView addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(deleteBtn.frame) - 20 * Proportion - 120 * Proportion,
                                                                         CGRectGetMaxY(self.mainImg.frame) - 20 * Proportion - 46 * Proportion,
                                                                         120 * Proportion,
                                                                         46 * Proportion)];
        
        editBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
        editBtn.layer.cornerRadius = 6 * Proportion;
        editBtn.clipsToBounds = YES;
        editBtn.titleLabel.font = KSystemBoldFontSize14;//[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.contentView addSubview:editBtn];
        [editBtn addTarget:self action:@selector(editCell) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)deleteCell {
    
    [self.delegate deleteActivityWithIndexPath:self.cellIndexPath];
    
}

- (void)editCell {
    
    [self.delegate editActivityWithIndexPath:self.cellIndexPath];
    
}

/*全球-全部-活动*/
- (void) refrshWorldTVCellOf:(CMLActivityObj *) obj{
    
    self.userMesBgView.hidden = YES;
    [self.userMesBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.mainImg.frame = CGRectMake(30*Proportion,
                                     0,
                                     WIDTH - 30*Proportion*2,
                                     (WIDTH - 30*Proportion*2)/690*389);

    
    [NetWorkTask setImageView:self.mainImg WithURL:obj.coverPic placeholderImage:nil];
    
    
    
    self.titleLab.text = obj.title;
    [self.titleLab sizeToFit];
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.mainImg.frame) + 17*Proportion,
                                     WIDTH - 30*Proportion*2,
                                     self.titleLab.frame.size.height);
    if ([obj.price intValue] == 0) {
        
        self.priceLab.text  =  @"免费";
        
    }else{
        
        self.priceLab.text  =  [NSString stringWithFormat:@"¥%@",obj.price];
    }

    [self.priceLab sizeToFit];
    self.priceLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.titleLab.frame) + 10*Proportion,
                                     self.priceLab.frame.size.width,
                                     self.priceLab.frame.size.height);
    
    self.addressLab.text = obj.cityName;
    [self.addressLab sizeToFit];
    self.addressLab.frame = CGRectMake(WIDTH - 30*Proportion - self.addressLab.frame.size.width ,
                                       CGRectGetMaxY(self.titleLab.frame) + 45*Proportion,
                                       self.addressLab.frame.size.width,
                                       self.addressLab.frame.size.height);
    
    [self.addressImg sizeToFit];
    self.addressImg.frame = CGRectMake(self.addressLab.frame.origin.x - 10*Proportion - self.addressImg.frame.size.width,
                                       self.addressLab.center.y - self.addressImg.frame.size.height/2.0,
                                       self.addressImg.frame.size.width,
                                       self.addressImg.frame.size.height);
    self.timeLab.text =  [NSString stringWithFormat:@"%@",[NSString getProjectStartTime:obj.actBeginTime]];
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(self.addressImg.frame.origin.x - 26*Proportion - self.timeLab.frame.size.width,
                                    self.addressLab.center.y - self.timeLab.frame.size.height/2.0,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    
    [self.timeImg sizeToFit];
    self.timeImg.frame = CGRectMake(self.timeLab.frame.origin.x - 10*Proportion - self.timeImg.frame.size.width,
                                    self.timeLab.center.y - self.timeImg.frame.size.height/2.0,
                                    self.timeImg.frame.size.width,
                                    self.timeImg.frame.size.height);
    
    self.endView.frame = CGRectMake(0, CGRectGetMaxY(self.timeImg.frame) + 37*Proportion,
                                    WIDTH,
                                    20*Proportion);
    
    self.cellHeight = CGRectGetMaxY(self.timeImg.frame) + 37*Proportion + 20*Proportion;
    
    

}

- (CGFloat) getCurrentHeigth{
    
    self.titleLab.text = @"title of activity";
    [self.titleLab sizeToFit];
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.mainImg.frame) + 17*Proportion,
                                     WIDTH - 30*Proportion*2,
                                     self.titleLab.frame.size.height);
    [self.addressImg sizeToFit];
    self.addressImg.frame = CGRectMake(self.addressLab.frame.origin.x - 10*Proportion - self.addressImg.frame.size.width,
                                       self.addressLab.center.y - self.addressImg.frame.size.height/2.0,
                                       self.addressImg.frame.size.width,
                                       self.addressImg.frame.size.height);
    
    return 162*Proportion + (WIDTH - 30*Proportion*2)/690*389 + 17*Proportion + self.titleLab.frame.size.height + 45*Proportion + self.addressImg.frame.size.height + 37*Proportion + 20*Proportion;
}

- (void) enterUserDetailVC{
    
        CMLVIPNewDetailVC *vc  = [[CMLVIPNewDetailVC alloc] initWithNickName:self.currentNickName
                                                               currnetUserId:self.currentUserID
                                                          isReturnUpOneLevel:NO];
        [[VCManger mainVC] pushVC:vc animate:YES];

}

/*审核状态*/
- (UILabel *)checkStatusLabel {
    
    if (!_checkStatusLabel) {
        _checkStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mainImg.frame) - 172 * Proportion, 0, 142 * Proportion + 6 * Proportion, 56 * Proportion)];
        _checkStatusLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
        _checkStatusLabel.layer.cornerRadius = 6 * Proportion;
        _checkStatusLabel.clipsToBounds = YES;
        _checkStatusLabel.textAlignment = NSTextAlignmentCenter;
        _checkStatusLabel.text = @"审核中";
        _checkStatusLabel.font = KSystemBoldFontSize14;
        _checkStatusLabel.textColor = [UIColor whiteColor];
        _checkStatusLabel.hidden = YES;
        
    }
    return _checkStatusLabel;
}

@end
