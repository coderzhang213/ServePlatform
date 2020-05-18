//
//  CMLPrefectureActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLPrefectureActivityTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLActivityObj.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"

#define LeftMargin         30
#define TopAndBottomMargin 20
#define ImageWidth         288
#define ImageHeight        162
#define Space              20
#define OtherSpace         10

@interface CMLPrefectureActivityTVCell ()

@property (nonatomic,strong) UIImageView *mainImage;

@property (nonatomic,strong) UILabel *tittleLab;

@property (nonatomic,strong) UILabel *lvlLab;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *smallLabelOne;

@property (nonatomic,strong) UILabel *smallLabelTwo;

@end

@implementation CMLPrefectureActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   TopAndBottomMargin*Proportion,
                                                                   ImageWidth*Proportion,
                                                                   ImageHeight*Proportion)];
    self.mainImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImage.clipsToBounds = YES;
    self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.mainImage];
    
    self.tittleLab = [[UILabel alloc] init];
    self.tittleLab.font = KSystemBoldFontSize14;
    self.tittleLab.numberOfLines = 2;
    self.tittleLab.textAlignment = NSTextAlignmentLeft;
    self.tittleLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.tittleLab];
    
    self.smallLabelOne = [[UILabel alloc] init];
    self.smallLabelOne.textColor = [UIColor CMLtextInputGrayColor];
    self.smallLabelOne.font = KSystemFontSize10;
    self.smallLabelOne.backgroundColor = [UIColor whiteColor];
    self.smallLabelOne.textAlignment = NSTextAlignmentCenter;
    self.smallLabelOne.layer.cornerRadius = 4*Proportion;
    self.smallLabelOne.layer.borderWidth = 0.5;
    self.smallLabelOne.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    [self.contentView addSubview:self.smallLabelOne];
    
    self.smallLabelTwo = [[UILabel alloc] init];
    self.smallLabelTwo.textColor = [UIColor CMLtextInputGrayColor];
    
    self.smallLabelTwo.font = KSystemFontSize10;
    self.smallLabelTwo.backgroundColor = [UIColor whiteColor];
    self.smallLabelTwo.textAlignment = NSTextAlignmentCenter;
    self.smallLabelTwo.layer.cornerRadius = 4*Proportion;
    self.smallLabelTwo.layer.borderWidth = 0.5;
    self.smallLabelTwo.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    [self.contentView addSubview:self.smallLabelTwo];
    
}

- (void) refreshCurrentCell:(CMLActivityObj *) obj{
    
    [NetWorkTask setImageView:self.mainImage WithURL:obj.coverPic placeholderImage:nil];
    self.tittleLab.frame = CGRectZero;
    self.tittleLab.text = obj.title;
    [self.tittleLab sizeToFit];
    if (self.tittleLab.frame.size.width > WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion) {
        self.tittleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                          TopAndBottomMargin*Proportion,
                                          WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                          self.tittleLab.frame.size.height*2);
    }else{
        
        self.tittleLab.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + Space*Proportion,
                                          TopAndBottomMargin*Proportion,
                                          WIDTH - CGRectGetMaxX(self.mainImage.frame) - Space*Proportion - LeftMargin*Proportion,
                                          self.tittleLab.frame.size.height);
    }
    

    self.smallLabelOne.frame = CGRectZero;
    
    switch ([obj.memberLevelId intValue]) {
        case 1:
            self.smallLabelOne.text = @"粉色";
            break;
        case 2:
            self.smallLabelOne.text = @"黛色";
            break;
        case 3:
            self.smallLabelOne.text = @"金色";
            break;
        case 4:
            self.smallLabelOne.text = @"墨色";
            break;
            
        default:
            break;
    }
    [self.smallLabelOne sizeToFit];
    self.smallLabelOne.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + 20*Proportion,
                                          CGRectGetMaxY(self.mainImage.frame) - 30*Proportion,
                                          self.smallLabelOne.frame.size.width + 20*Proportion,
                                          30*Proportion);

    self.smallLabelTwo.frame = CGRectZero;
    self.smallLabelTwo.text = [NSString getProjectStartTime:obj.actBeginTime];
    [self.smallLabelTwo sizeToFit];
    self.smallLabelTwo.frame = CGRectMake(CGRectGetMaxX(self.mainImage.frame) + 20*Proportion*2 + CGRectGetWidth(self.smallLabelOne.frame),
                                          CGRectGetMaxY(self.mainImage.frame) - 30*Proportion,
                                          self.smallLabelTwo.frame.size.width + 20*Proportion,
                                          30*Proportion);
}
@end
