//
//  CMLWebLinkTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLWebLinkTVCell.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"

#define CMLWebLinkTVCellBottomViewHeight   20
#define CMLWebLinkTCCellImageHeight        200

@interface CMLWebLinkTVCell ()

@property (nonatomic,strong) UIImageView *mainImage;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation CMLWebLinkTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   [UIScreen mainScreen].bounds.size.width,
                                                                   [UIScreen mainScreen].bounds.size.width/16*9)];
    self.mainImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImage.clipsToBounds = YES;
    self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.mainImage];
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self addSubview:self.bottomView];
    
}

- (void) refreshCurrentCellWithImageUrl:(NSString *) imageurl{
    if (self.isTopicWeb) {
        self.mainImage.frame = CGRectMake(CMLWebLinkTVCellBottomViewHeight*Proportion,
                                          CMLWebLinkTVCellBottomViewHeight*Proportion,
                                          [UIScreen mainScreen].bounds.size.width - CMLWebLinkTVCellBottomViewHeight*Proportion*2,
                                          CMLWebLinkTCCellImageHeight*Proportion);
    }
    
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.mainImage.frame),
                                       [UIScreen mainScreen].bounds.size.width,
                                       CMLWebLinkTVCellBottomViewHeight*Proportion);
    
    [NetWorkTask setImageView:self.mainImage WithURL:imageurl placeholderImage:nil];
    
    self.cellHeight = CGRectGetMaxY(self.bottomView.frame);
    
}
@end
