//
//  CMLSBUserPushGoodsTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/14.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLSBUserPushGoodsTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"
#import "UILabel+CMLAdaptive.h"


@interface CMLSBUserPushGoodsTVCell ()

@property (nonatomic,strong) UIView *userMesBgView;

@property (nonatomic,strong) UIImageView *userLvlImg;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UIButton *userBtn;

@property (nonatomic,strong) UILabel *userNickNameLab;

@property (nonatomic,strong) UILabel *userPositionLab;

@property (nonatomic,strong) UIImageView *mainImg;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UIView *endView;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy) NSString *currentNickName;

@property (nonatomic,strong) NSNumber *currentUserID;

/*新增：审核状态*/
@property (nonatomic, strong) UILabel *checkStatusLabel;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;

@end

@implementation CMLSBUserPushGoodsTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.mainImg = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                 40*Proportion,
                                                                 381*Proportion,
                                                                 389*Proportion)];
    self.mainImg.clipsToBounds = YES;
    self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImg.layer.cornerRadius = 6*Proportion;
    self.mainImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mainImg];
    
    self.userMesBgView = [[UIView alloc] initWithFrame: CGRectMake(CGRectGetMaxX(self.mainImg.frame),
                                                                   self.mainImg.frame.origin.y,
                                                                   WIDTH - CGRectGetMaxX(self.mainImg.frame) - 30*Proportion,
                                                                   55*Proportion)];
    self.userMesBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.userMesBgView];
    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                   0,
                                                                   55*Proportion,
                                                                   55*Proportion)];
    self.userImage.layer.cornerRadius = 55*Proportion/2.0;
    self.userImage.clipsToBounds = YES;
    self.userImage.userInteractionEnabled = YES;
    [self.userMesBgView addSubview:self.userImage];
    
    self.userBtn = [[UIButton alloc] initWithFrame:self.userImage.bounds];
    self.userBtn.backgroundColor = [UIColor clearColor];
    [self.userImage addSubview:self.userBtn];
    [self.userBtn addTarget:self action:@selector(enterUserDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.userLvlImg = [[UIImageView alloc] init];
    self.userLvlImg.backgroundColor = [UIColor CMLWhiteColor];
    self.userLvlImg.layer.cornerRadius = self.userLvlImg.frame.size.width/2.0;
    [self.userMesBgView addSubview:self.userLvlImg];
    
    
    /****/
    self.userNickNameLab = [[UILabel alloc] init];
    self.userNickNameLab.font = KSystemBoldFontSize12;
    self.userNickNameLab.textColor = [UIColor CMLBlackColor];
    [self.userMesBgView addSubview:self.userNickNameLab];
    
    self.userPositionLab = [[UILabel alloc] init];
    self.userPositionLab.font = KSystemFontSize11;
    self.userPositionLab.textColor = [UIColor CMLBrownColor];
    [self.userMesBgView addSubview:self.userPositionLab];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize15;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.numberOfLines = 0;
    [self.contentView addSubview:self.titleLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.textColor = [UIColor CMLBrownColor];
    self.priceLab.font = KSystemBoldFontSize18;
    [self.contentView addSubview:self.priceLab];
    
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
    
    
    self.endView = [[UIView alloc] init];
    self.endView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self.contentView addSubview:self.endView];
    
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
    self.userNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            self.userImage.center.y - 5*Proportion/2.0 - self.userNickNameLab.frame.size.height,
                                            self.userNickNameLab.frame.size.width,
                                            self.userNickNameLab.frame.size.height);
    
    self.userPositionLab.text = obj.signature;
    [self.userPositionLab sizeToFit];
    self.userPositionLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            CGRectGetMaxY(self.userNickNameLab.frame) + 5*Proportion,
                                            self.userPositionLab.frame.size.width,
                                            self.userPositionLab.frame.size.height);
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text = obj.title;
    self.titleLab.lineBreakMode = NSLineBreakByCharWrapping;
    [self.titleLab sizeToFit];
    
    CGSize titleSize = [self.titleLab sizeAdaptiveWithText:obj.title textFont:KSystemBoldFontSize15 textMaxSize:CGSizeMake(WIDTH - 30*Proportion*2 - 20*Proportion - self.mainImg.frame.size.width, self.mainImg.height) textLineSpacing:10*Proportion];
    
    self.titleLab.frame = CGRectMake(20*Proportion + CGRectGetMaxX(self.mainImg.frame),
                                     CGRectGetMaxY(self.userMesBgView.frame) + 12*Proportion,
                                     titleSize.width,
                                     titleSize.height);
    
    self.priceLab.text  = [NSString stringWithFormat:@"¥%@",obj.price];
    [self.priceLab sizeToFit];
    self.priceLab.frame = CGRectMake(WIDTH - 30*Proportion - self.priceLab.frame.size.width,
                                     CGRectGetMaxY(self.mainImg.frame) - self.priceLab.frame.size.height,
                                     self.priceLab.frame.size.width,
                                     self.priceLab.frame.size.height);
    
    /*新增：浏览量*/
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(CGRectGetMaxX(self.mainImg.frame) + 20*Proportion,
                                         self.priceLab.center.y - self.hitImageView.frame.size.height/2.0,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    
    if (obj.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", obj.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }
    
    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.hitImageView.frame) + 10*Proportion,
                                     self.priceLab.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
    
    self.endView.frame = CGRectMake(0, CGRectGetMaxY(self.mainImg.frame) + 40*Proportion,
                                    WIDTH,
                                    20*Proportion);
    
    
    
    
    self.cellHeight = CGRectGetMaxY(self.mainImg.frame) + 40*Proportion + 20*Proportion;;
    
    /*新增：审核状态 1-审核通过 3-审核中*/
    if ([obj.status intValue] == 3 && obj.userId == [[DataManager lightData] readUserID]) {
        self.checkStatusLabel.hidden = NO;
    }else {
        self.checkStatusLabel.hidden = YES;
    }
    
    
    /*新增：编辑+删除*/
    NSLog(@"%@", self.isEdit ? @"YES" : @"NO");
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
        [deleteBtn addTarget:self action:@selector(deleteGoodsCell) forControlEvents:UIControlEventTouchUpInside];
        
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
        [editBtn addTarget:self action:@selector(editGoodsCell) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)deleteGoodsCell {
    
    [self.delegate deleteGoodsTVCellWithIndexPath:self.cellIndexPath];
    
}

- (void)editGoodsCell {
    
    [self.delegate editGoodsTVCellWithIndexPath:self.cellIndexPath];
    
}

- (CGFloat) getCurrentHeigth{
    
    return 40*Proportion + 389*Proportion + 40*Proportion + 20*Proportion;
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
        
    }
    return _checkStatusLabel;
}



@end
