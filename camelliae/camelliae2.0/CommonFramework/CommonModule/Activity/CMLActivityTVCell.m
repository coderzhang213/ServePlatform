//
//  CMLActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLActivityTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import <UMAnalytics/MobClick.h>
#import "NSDate+CMLExspand.h"
#import "CommenClickBottomView.h"

#define CMLActivityCellLeftMargin            20
#define CMLActivityCellTitleTopMargin        20

#define CMLActivityCellBtnTopMargin        30
#define CMLActivityCellBtnBottomMargin     30
#define CMLActivityCellBtnAndBtnSpace      60
#define CMLActivityCellBtnImgAndTitleSpace 10
#define CMLActivityCellBottomViewHeight    20

@interface CMLActivityTVCell ()<NetWorkProtocol>

/**UI*/

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSNumber *typeID;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UILabel *levelLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *cityLabel;

@property (nonatomic,strong) CMLLine *bottomLine;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIImageView *subscribeImage;
/***数据*/
@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,copy) NSString *infoTitle;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *beginTime;

@property (nonatomic,strong) NSNumber *isUserSubscribe;

@property (nonatomic,copy) NSString *hitNum;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;


@end

@implementation CMLActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
        self.backgroundColor = [UIColor whiteColor];
        self.typeID =[NSNumber numberWithInt:2];
    }
    return self;
}

- (void) refrshActivityCellInActivityVC:(CMLActivityObj *) obj{

    if (obj) {
        self.imgUrl        = obj.objCoverPic;
        self.infoTitle     = obj.title;
        self.currentID     = obj.currentID;
        self.city          = obj.cityName;
        self.memberLevelId = obj.memberLevelId;
        self.beginTime     = obj.actBeginTime;
        self.isUserSubscribe = obj.isUserSubscribe;
        self.hitNum = obj.hitNum;
    }else{
        self.imgUrl        = @"";
        self.infoTitle     = @"test";
        self.currentID     = [NSNumber numberWithInt:1];
        self.city          = @"test";
        self.memberLevelId = obj.memberLevelId;
    
    }
    [self reloadCurrentCell];
}


- (void) loadViews{
    
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.layer.cornerRadius = 8*Proportion;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.frame = CGRectMake(30*Proportion,
                                          40*Proportion,
                                          WIDTH - 30*Proportion*2,
                                          (WIDTH - 30*Proportion*2)/16*9);
    [self.contentView addSubview:self.mainImageView];
    
    self.subscribeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ActivitySubscribeImg]];
    self.subscribeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.subscribeImage sizeToFit];
    self.subscribeImage.frame = CGRectMake(self.mainImageView.frame.size.width - self.subscribeImage.frame.size.width,
                                            0,
                                            self.subscribeImage.frame.size.width,
                                            self.subscribeImage.frame.size.height);
    [self.mainImageView addSubview:self.subscribeImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemBoldFontSize18;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];

    
    self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.layer.cornerRadius = 2;
    self.levelLabel.layer.borderWidth = 1*Proportion;
    self.levelLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.levelLabel.font = KSystemFontSize12;
    self.levelLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.levelLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.layer.cornerRadius = 2;
    self.timeLabel.layer.borderWidth = 1*Proportion;
    self.timeLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.timeLabel.font = KSystemFontSize12;
    self.timeLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.layer.cornerRadius = 2;
    self.cityLabel.layer.borderWidth = 1*Proportion;
    self.cityLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.cityLabel.font = KSystemFontSize12;
    self.cityLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.cityLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.bottomView.hidden = YES;
    [self.contentView addSubview:self.bottomView];
    
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
    
}

- (void) reloadCurrentCell{

    /*********/
    /**图片请求*/
    [NetWorkTask setImageView:self.mainImageView
                      WithURL:self.imgUrl
             placeholderImage:nil];
    
    if (self.isShowSubscribe) {
        
        if ([self.isUserSubscribe intValue] == 1) {
          
            self.subscribeImage.hidden = NO;
        }else{
        
            self.subscribeImage.hidden = YES;
        }
        
    }else{
    
        self.subscribeImage.hidden = YES;
    }
    
    /**名字*/
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.infoTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(_mainImageView.frame) + CMLActivityCellTitleTopMargin*Proportion,
                                       [UIScreen mainScreen].bounds.size.width - CMLActivityCellLeftMargin*Proportion*2,
                                       self.titleLabel.frame.size.height);
    
    
    switch ([self.memberLevelId intValue]) {
        case 1:
            self.levelLabel.text = @"粉色活动";
            break;
        case 2:
            self.levelLabel.text = @"黛色活动";
            break;
        case 3:
            self.levelLabel.text = @"金色活动";
            break;
        case 4:
            self.levelLabel.text = @"墨色活动";
            break;
            
        default:
            break;
    }
    [self.levelLabel sizeToFit];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(_titleLabel.frame) + 30*Proportion,
                                       self.levelLabel.frame.size.width + 20*Proportion,
                                       40*Proportion);
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@号开始",[NSString getProjectStartTime:self.beginTime]];
    [self.timeLabel sizeToFit];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.levelLabel.frame) + 20*Proportion,
                                      CGRectGetMaxY(_titleLabel.frame) + 30*Proportion,
                                      self.timeLabel.frame.size.width + 20*Proportion,
                                      40*Proportion);
    
    self.cityLabel.text = self.city;
    [self.cityLabel sizeToFit];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    self.cityLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame) + 20*Proportion,
                                       CGRectGetMaxY(_titleLabel.frame) + 30*Proportion,
                                       self.cityLabel.frame.size.width + 20*Proportion,
                                       40*Proportion);
    if (self.city.length == 0) {
        
        self.cityLabel.hidden = YES;
    }

    self.bottomView.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(self.levelLabel.frame) + 37*Proportion,
                                       WIDTH - 30*Proportion*2,
                                       1*Proportion);
    
    /*新增：浏览量*/
    if (self.hitNum) {
        self.hitLabel.text =  [NSString stringWithFormat:@"%@", self.hitNum];
    }else {
        self.hitLabel.text = @"0";
    }

    [self.hitLabel sizeToFit];
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) - self.hitLabel.frame.size.width,
                                     self.cityLabel.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(self.hitLabel.frame.origin.x - 10*Proportion - self.hitImageView.frame.size.width,
                                         self.hitLabel.center.y - self.hitImageView.frame.size.height/2.0,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    
    self.cellheight = CGRectGetMaxY(self.levelLabel.frame) + 40*Proportion;
    
    
}
@end
