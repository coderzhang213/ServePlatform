//
//  CMLRelevanceActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRelevanceActivityTVCell.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"


@interface CMLRelevanceActivityTVCell ()

@property (nonatomic,strong) UIImageView *currentImage;

@property (nonatomic,strong) UILabel *currnetLab;

@end

@implementation CMLRelevanceActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      160*Proportion/2.0 - 90*Proportion/2.0,
                                                                      160*Proportion,
                                                                      90*Proportion)];
    self.currentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.currentImage.clipsToBounds  = YES;
    self.currentImage.backgroundColor = [UIColor CMLPromptGrayColor];
    [self addSubview:self.currentImage];
    
    self.currnetLab = [[UILabel alloc] init];
    self.currnetLab.textAlignment = NSTextAlignmentLeft;
    self.currnetLab.font = KSystemFontSize14;
    self.currnetLab.text = @"test";
    self.currnetLab.numberOfLines = 2;
    [self.currnetLab sizeToFit];
    self.currnetLab.frame = CGRectMake(CGRectGetMaxX(self.currentImage.frame) +20*Proportion,
                                       160*Proportion/2.0 - self.currnetLab.frame.size.height*2/2.0,
                                       WIDTH - CGRectGetMaxX(self.currentImage.frame) - 20*Proportion - 30*Proportion,
                                       self.currnetLab.frame.size.height*2);
    [self addSubview:self.currnetLab];

}

- (void) refreshTVCell{

    [NetWorkTask setImageView:self.currentImage WithURL:self.imageUrl placeholderImage:nil];
    self.currnetLab.text = self.titile;
}
@end
