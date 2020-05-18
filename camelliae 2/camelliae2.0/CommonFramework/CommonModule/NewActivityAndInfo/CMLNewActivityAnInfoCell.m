//
//  CMLNewActivityAnInfoCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/14.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLNewActivityAnInfoCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"
#import "UIImage+CMLExspand.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"

@interface CMLNewActivityAnInfoCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *mainImg;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *lvlLab;

@property (nonatomic,strong) UIImageView *timeImg;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UIImageView *addressImg;

@property (nonatomic,strong) UIImageView *tagImg;

@property (nonatomic,strong) UILabel *addressLab;

/***************/

@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,copy) NSString *infoTitle;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *beginTime;

@property (nonatomic,copy) NSString *beginTimeStr;

@property (nonatomic,strong) NSNumber *TypeId;

@property (nonatomic,strong) NSNumber *currentTypeID;

@property (nonatomic,copy) NSString *hitNum;

/*新增：浏览量*/
@property (nonatomic, strong) UIImageView *hitImageView;

@property (nonatomic, strong) UILabel *hitLabel;

@end

@implementation CMLNewActivityAnInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                           20*Proportion,
                                                           WIDTH - 30*Proportion*2,
                                                           242*Proportion)];
    self.bgView.backgroundColor = [UIColor CMLWhiteColor];
    self.bgView.layer.cornerRadius = 6*Proportion;
    self.bgView.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    self.bgView.layer.borderWidth = 1*Proportion;
    [self.contentView addSubview:self.bgView];
    
    
    
    self.mainImg = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                 20*Proportion,
                                                                 202*Proportion/9*16,
                                                                 202*Proportion)];
    self.mainImg.clipsToBounds = YES;
    self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgView addSubview:self.mainImg];
    
    self.tagImg = [[UIImageView alloc] init];
    self.tagImg.backgroundColor = [UIColor clearColor];
    [self.mainImg addSubview:self.tagImg];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = KSystemBoldFontSize15;
    [self.bgView addSubview:self.titleLab];
    
    self.lvlLab = [[UILabel alloc] init];
    self.lvlLab.font = KSystemFontSize10;
    self.lvlLab.layer.cornerRadius = 5*Proportion;
    self.lvlLab.clipsToBounds = YES;
    self.lvlLab.textColor = [UIColor CMLWhiteColor];
    self.lvlLab.backgroundColor = [UIColor CMLBrownColor];
    [self.bgView addSubview:self.lvlLab];
    
    self.timeImg = [[UIImageView alloc] init];
    self.timeImg.contentMode = UIViewContentModeScaleAspectFill;
    self.timeImg.image = [UIImage imageNamed:ListActivityTimeImg];
    self.timeImg.clipsToBounds = YES;
    [self.bgView addSubview:self.timeImg];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize12;
    self.timeLab.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.bgView addSubview:self.timeLab];
    
    self.addressImg = [[UIImageView alloc] init];
    self.addressImg.contentMode = UIViewContentModeScaleAspectFill;
    self.addressImg.image = [UIImage imageNamed:ListActivityAddressImg];
    self.addressImg.clipsToBounds = YES;
    [self.bgView addSubview:self.addressImg];
    
    self.addressLab = [[UILabel alloc] init];
    self.addressLab.font = KSystemFontSize12;
    self.addressLab.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.bgView addSubview:self.addressLab];
    
    /*新增L：浏览量*/
    self.hitImageView = [[UIImageView alloc] init];
    self.hitImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hitImageView.image = [UIImage imageNamed:CMLHitImage];
    self.hitImageView.clipsToBounds = YES;
    [self.bgView addSubview:self.hitImageView];
    
    self.hitLabel = [[UILabel alloc] init];
    self.hitLabel.font = KSystemFontSize12;
    self.hitLabel.textColor = [UIColor CMLBtnTitleNewGrayColor];
    [self.bgView addSubview:self.hitLabel];
    
}

/*未使用*/
- (void) refrshActivityCellInMainInterfaceVC:(CMLCommIndexObj *) obj{
    
    if (obj) {
        self.city          = obj.provinceName;
        self.imgUrl        = obj.objCoverPic;
        self.infoTitle     = obj.title;
        self.currentID     = obj.currentID;
        self.memberLevelId = obj.memberLevelId;
        self.beginTime     = obj.actBeginTime;
        
    }else{
        
        self.city          = @"test";
        self.imgUrl        = @"";
        self.infoTitle     = @"test";
        self.currentID     = [NSNumber numberWithInt:1];
        self.memberLevelId = [NSNumber numberWithInt:1];
        self.beginTime     = [NSNumber numberWithInt:1];
        
        
    }
    
    [self reloadCurrentCell];
}

- (void) refrshActivityCellInActivityVC:(CMLActivityObj *) obj{
    
    if (obj) {
        if (obj.objInfo.coverPic) {
            self.imgUrl        = obj.objInfo.coverPic;
        }
        if (obj.objInfo.title) {
            self.infoTitle     = obj.objInfo.title;
        }
        if (obj.objInfo.currentID) {
            self.currentID     = obj.objInfo.currentID;
        }
        if (obj.objInfo.cityName) {
            self.city          = obj.objInfo.cityName;
        }
        if (obj.objInfo.rootTypeId) {
            self.TypeId        = obj.objInfo.rootTypeId;
            self.currentTypeID     = obj.objInfo.rootTypeId;
        }
        
        if (obj.objInfo.hitNum) {
            self.hitNum = obj.objInfo.hitNum;
        }
        
        if ([obj.objInfo.rootTypeId intValue] == 98) {
            
            
            self.memberLevelId = [NSNumber numberWithInt:0];
            if (obj.objInfo.publishTimeStamp) {
                self.beginTime = obj.objInfo.publishTimeStamp;
            }

        }else{
            
            if (obj.objInfo.actBeginTime) {
                self.beginTime = obj.objInfo.actBeginTime;
            }
            if (obj.objInfo.memberLevelId) {
                self.memberLevelId = obj.objInfo.memberLevelId;
            }
        }
        
    }else{
        self.imgUrl        = @"";
        self.infoTitle     = @"test";
        self.currentID     = [NSNumber numberWithInt:1];
        self.city          = @"test";
        self.memberLevelId = obj.memberLevelId;
        
    }
    
    [self reloadCurrentCell];
}


- (void) reloadCurrentCell{
    
    /*********/
    /**图片请求*/
    if (self.imgUrl) {
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 202*Proportion/9*16, 202*Proportion)];
//        view.backgroundColor = [UIColor CML9E9E9EColor];
//        UIImage *image = [UIImage getImageFromView:view];
//
//        [self.mainImg setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholder:image options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//
//        }];
        [NetWorkTask setImageView:self.mainImg WithURL:self.imgUrl placeholderImage:nil];
        
    }
    
    if (self.TypeId) {
        if ([self.TypeId intValue] == 98) {
            
            self.tagImg.image = [UIImage imageNamed:ListArcticleTagImg];
            
        }else{
            self.tagImg.image = [UIImage imageNamed:ListActivityTagImg];
            
        }
        [self.tagImg sizeToFit];
        self.tagImg.frame = CGRectMake(0,
                                       20*Proportion,
                                       self.tagImg.frame.size.width,
                                       self.tagImg.frame.size.height);
    }
    

    /**名字*/
    if (self.infoTitle) {
        self.titleLab.frame = CGRectZero;
        self.titleLab.text = self.infoTitle;
        self.titleLab.numberOfLines = 2;
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self.titleLab sizeToFit];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.infoTitle];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10 * Proportion];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.infoTitle length])];
        self.titleLab.attributedText = attributedString;
        self.titleLab.lineBreakMode = NSLineBreakByCharWrapping;
        
        if (self.titleLab.frame.size.width > self.bgView.frame.size.width - 20*Proportion*3 - self.mainImg.frame.size.width) {
            
            self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImg.frame) + 20*Proportion,
                                             20*Proportion,
                                             self.bgView.frame.size.width - 20*Proportion*3 - self.mainImg.frame.size.width,
                                             self.titleLab.frame.size.height*2);
        }else{
            
            self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImg.frame) + 20*Proportion,
                                             20*Proportion,
                                             self.bgView.frame.size.width - 20*Proportion*3 - self.mainImg.frame.size.width,
                                             self.titleLab.frame.size.height);
        }
    }
  
    
    if (self.memberLevelId) {
        switch ([self.memberLevelId intValue]) {
                
            case 0:
                self.lvlLab.hidden = YES;
                break;
            case 1:
                self.lvlLab.hidden = NO;
                self.lvlLab.text = @"粉色";
                break;
            case 2:
                self.lvlLab.hidden = NO;
                self.lvlLab.text = @"黛色";
                break;
            case 3:
                self.lvlLab.hidden = NO;
                self.lvlLab.text = @"金色";
                break;
            case 4:
                self.lvlLab.hidden = NO;
                self.lvlLab.text = @"墨色";
                break;
                
            default:
                break;
        }
    }
 
    self.lvlLab.textAlignment = NSTextAlignmentCenter;
    self.lvlLab.frame = CGRectMake(CGRectGetMaxX(self.mainImg.frame) - 20*Proportion - 60*Proportion,
                                   CGRectGetMaxY(self.mainImg.frame) - 20*Proportion - 34*Proportion,
                                   60*Proportion,
                                   34*Proportion);
    
    /*新增：浏览量*/
    [self.hitImageView sizeToFit];
    self.hitImageView.frame = CGRectMake(self.titleLab.frame.origin.x,
                                         CGRectGetMaxY(self.mainImg.frame) - self.hitImageView.frame.size.height,
                                         self.hitImageView.frame.size.width,
                                         self.hitImageView.frame.size.height);
    
    if (self.hitNum) {
        if ([self.hitNum rangeOfString:@"."].location != NSNotFound) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.hitNum];
            NSRange range = [self.hitNum rangeOfString:@"."];
            NSString *afterString = [self.hitNum substringFromIndex:range.location];
            [string addAttribute:NSFontAttributeName value:KSystemFontSize9 range:NSMakeRange(range.location + 1, afterString.length - 1)];
            self.hitLabel.attributedText = string;
        }else {
            self.hitLabel.text =  [NSString stringWithFormat:@"%@", self.hitNum];
        }
        
    }else {
        self.hitLabel.text = @"0";
    }
    
    [self.hitLabel sizeToFit];// - 4*Proportion - self.hitImageView.frame.size.width
    self.hitLabel.frame = CGRectMake(CGRectGetMaxX(self.hitImageView.frame) + 10 * Proportion,
                                     self.hitImageView.center.y - self.hitLabel.frame.size.height/2.0,
                                     self.hitLabel.frame.size.width,
                                     self.hitLabel.frame.size.height);
    
    //////
    self.addressLab.text = self.city;
    [self.addressLab sizeToFit];
    
    if ([self.TypeId intValue] == 2) {
         
         self.addressLab.frame = CGRectMake(self.bgView.frame.size.width - 20 * Proportion - self.addressLab.frame.size.width,
                                            self.hitImageView.center.y - self.addressLab.frame.size.height/2.0,
                                            self.addressLab.frame.size.width,
                                            self.addressLab.frame.size.height);
    }else{
         
         self.addressLab.frame = CGRectMake(self.bgView.frame.size.width - 20 * Proportion - self.addressLab.frame.size.width,
                                            self.hitImageView.center.y - self.addressLab.frame.size.height/2.0,
                                            self.addressLab.frame.size.width,
                                            self.addressLab.frame.size.height);
    }
    
    [self.addressImg sizeToFit];
    self.addressImg.frame = CGRectMake(CGRectGetMinX(self.addressLab.frame) - self.addressImg.frame.size.width,// - 10 * Proportion,
                                       self.hitImageView.center.y - self.addressImg.frame.size.height/2.0,//- (self.addressImg.frame.size.height - 2*Proportion)/2.0 - 1*Proportion,
                                       self.addressImg.frame.size.width - 2*Proportion,
                                       self.addressImg.frame.size.height - 2*Proportion);


    /*时间*/
    if (self.currentTypeID) {

        if (self.beginTime) {
            self.timeLab.text = [NSString getProjectStartTime:self.beginTime];
        }
        
        [self.timeLab sizeToFit];
        [self.timeImg sizeToFit];
        CGFloat middleSpace = CGRectGetMinX(self.addressImg.frame) - CGRectGetMaxX(self.hitLabel.frame);/*中间间隔*/
        CGFloat middleWidth = CGRectGetWidth(self.timeImg.frame) + CGRectGetWidth(self.timeLab.frame) + 10 * Proportion;/*时间部分总宽度*/
        
        
        self.timeImg.frame = CGRectMake(CGRectGetMaxX(self.hitLabel.frame) + (middleSpace - middleWidth)/2,
                                        self.hitImageView.center.y - self.timeImg.frame.size.height/2.0,
                                        self.timeImg.frame.size.width,
                                        self.timeImg.frame.size.height);
    }

    if (self.TypeId) {
        if ([self.TypeId intValue] == 2) {
            
            self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.timeImg.frame) + 10 * Proportion,
                                            self.hitImageView.center.y - self.timeLab.frame.size.height/2.0,
                                            self.timeLab.frame.size.width,
                                            self.timeLab.frame.size.height);
        }else{
            
            self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.timeImg.frame) + 10 * Proportion,
                                            self.hitImageView.center.y - self.timeLab.frame.size.height/2.0,
                                            self.timeLab.frame.size.width,
                                            self.timeLab.frame.size.height);
        }
    }

    /************城市字数超过3*/
    if (self.city.length > 3) {
        self.addressImg.frame = CGRectMake(self.titleLab.frame.origin.x - 4*Proportion,
                                           self.hitImageView.frame.origin.y - self.addressLab.frame.size.height - 20 * Proportion,
                                           self.addressImg.frame.size.width - 2*Proportion,
                                           self.addressImg.frame.size.height - 2*Proportion);
        self.addressLab.frame = CGRectMake(CGRectGetMaxX(self.addressImg.frame) + 10 * Proportion + 4 * Proportion,
                                           self.addressImg.center.y - self.addressLab.frame.size.height/2.0,
                                           self.addressLab.frame.size.width,
                                           self.addressLab.frame.size.height);

        self.timeImg.frame = CGRectMake(CGRectGetMaxX(self.hitLabel.frame) + 20 * Proportion,
                                        self.hitImageView.center.y - self.timeImg.frame.size.height/2.0,
                                        self.timeImg.frame.size.width,
                                        self.timeImg.frame.size.height);
        self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.timeImg.frame) + 10 * Proportion,
                                        self.hitImageView.center.y - self.timeLab.frame.size.height/2.0,
                                        self.timeLab.frame.size.width,
                                        self.timeLab.frame.size.height);
    }
    //**********/
    
    self.cellheight = CGRectGetMaxY(self.bgView.frame) + 40*Proportion;
    
}

@end
