//
//  CMLAllBrandTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/29.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLAllBrandTVCell.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"

#define NewSpecialTopicAroundMargin   15
#define NewSpecialTopicLeftMargin     30


@interface CMLAllBrandTVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@end

@implementation CMLAllBrandTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(NewSpecialTopicLeftMargin*Proportion,
                                                                       NewSpecialTopicAroundMargin*Proportion,
                                                                       WIDTH - 2*NewSpecialTopicLeftMargin*Proportion,
                                                                       (WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/16*9)];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.layer.cornerRadius = 10*Proportion;
    [self.contentView addSubview:self.mainImageView];
    
}

- (void) refreshCurrentCellWith:(NSString *)picUrl {
    
    [NetWorkTask setImageView:self.mainImageView WithURL:picUrl placeholderImage:nil];
    
}
@end
