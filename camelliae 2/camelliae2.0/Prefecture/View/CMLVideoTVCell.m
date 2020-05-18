//
//  CMLVideoTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVideoTVCell.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VideoDetailInfoObj.h"
#import "CommonFont.h"

#define LeftMargin  30
#define TopMargin   20

@interface CMLVideoTVCell ()

@property (nonatomic,strong) UIImageView *playImage;

@property (nonatomic,strong) UILabel *playName;

@end

@implementation CMLVideoTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    self.playImage = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                   TopMargin*Proportion,
                                                                   WIDTH - LeftMargin*Proportion*2,
                                                                  (WIDTH - LeftMargin*Proportion*2)/16*9)];
    self.playImage.userInteractionEnabled = YES;
    self.playImage.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:self.playImage];
    
    UIImageView *playIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PrefectureImg]];
    playIconImg.userInteractionEnabled = YES;
    playIconImg.frame = CGRectMake((WIDTH - LeftMargin*Proportion*2)/2.0 - playIconImg.frame.size.width/2.0,
                                   ((WIDTH - LeftMargin*Proportion*2)/16*9)/2.0 - playIconImg.frame.size.height/2.0,
                                   playIconImg.frame.size.width,
                                   playIconImg.frame.size.height);
    [self.playImage addSubview:playIconImg];
    
    self.playName = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              (WIDTH - LeftMargin*Proportion*2)/16*9 - 60*Proportion,
                                                              WIDTH - LeftMargin*Proportion*2,
                                                              60*Proportion)];
    self.playName.textColor = [UIColor CMLWhiteColor];
    self.playName.font = KSystemBoldFontSize14;
    self.playName.textAlignment = NSTextAlignmentLeft;
    self.playName.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.7];
    [self.playImage addSubview:self.playName];
    
}

- (void) refeshCurrentCell:(VideoDetailInfoObj*) obj{

    [NetWorkTask setImageView:self.playImage WithURL:obj.coverPic placeholderImage:nil];
    self.playName.text = obj.title;
}
@end
