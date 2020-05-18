//
//  CMLVIPTopicTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVIPTopicTVCell.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"

@interface CMLVIPTopicTVCell()

@property (nonatomic,strong) UIImageView *topicImage;

@property (nonatomic,strong) UILabel *topicTitleLab;

@property (nonatomic,strong) UILabel *topicContentLab;

@property (nonatomic,strong) UILabel *numberLab;


@end


@implementation CMLVIPTopicTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.topicImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                    30*Proportion,
                                                                    160*Proportion,
                                                                    160*Proportion)];
    self.topicImage.contentMode = UIViewContentModeScaleAspectFill;
    self.topicImage.clipsToBounds = YES;
    self.topicImage.backgroundColor = [UIColor CMLtextInputGrayColor];
    [self addSubview:self.topicImage];
    
    
    self.topicTitleLab = [[UILabel alloc] init];
    self.topicTitleLab.font = KSystemBoldFontSize15;
    self.topicTitleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.topicTitleLab];
    
    self.topicContentLab = [[UILabel alloc] init];
    self.topicContentLab.font = KSystemFontSize12;
    self.topicContentLab.numberOfLines = 2;
    [self addSubview:self.topicContentLab];
    
    self.numberLab = [[UILabel alloc] init];
    self.numberLab.font = KSystemFontSize11;
    self.numberLab.textColor = [UIColor CMLtextInputGrayColor];
    self.numberLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.numberLab];
    
}

- (void) refreshCurrentTVCellWith:(RecommendTimeLineObj *) obj{
    
    [NetWorkTask setImageView:self.topicImage WithURL:obj.coverPic placeholderImage:nil];
    
    self.topicTitleLab.text = obj.title;
    [self.topicTitleLab sizeToFit];
    self.topicTitleLab.frame = CGRectMake(CGRectGetMaxX(self.topicImage.frame) + 20*Proportion,
                                          30*Proportion,
                                          WIDTH - 20*Proportion*3 - self.topicImage.frame.size.width,
                                          self.topicTitleLab.frame.size.height);
    
    self.topicContentLab.text = obj.desc;
    CGRect currentRect = [self.topicContentLab.text boundingRectWithSize:CGSizeMake(WIDTH - 20*Proportion*3 - self.topicImage.frame.size.width, HEIGHT)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                 context:nil];
    self.topicContentLab.frame = CGRectMake(CGRectGetMaxX(self.topicImage.frame) + 20*Proportion,
                                            CGRectGetMaxY(self.topicTitleLab.frame) + 10*Proportion,
                                            WIDTH - 20*Proportion*3 - self.topicImage.frame.size.width,
                                            currentRect.size.height);
    
    self.numberLab.text = [NSString stringWithFormat:@"%@ 人查看   %@ 人参与",obj.hitNum,obj.themeTimeLineCount];
    [self.numberLab sizeToFit];
    self.numberLab.frame = CGRectMake(CGRectGetMaxX(self.topicImage.frame) + 20*Proportion,
                                      CGRectGetMaxY(self.topicImage.frame) - self.numberLab.frame.size.height,
                                      WIDTH - 20*Proportion*3 - self.topicImage.frame.size.width,
                                      self.numberLab.frame.size.height);
    
}
@end
