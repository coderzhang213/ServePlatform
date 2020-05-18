//
//  NewSpecialTopTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2016/11/4.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NewSpecialTopicTVCell.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"

#define NewSpecialTopicAroundMargin   15
#define NewSpecialTopicLeftMargin     30


@interface NewSpecialTopicTVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *shortTitleLab;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UIImageView *enterImage;

@property (nonatomic,strong) UIImageView *tagImg;

@end

@implementation NewSpecialTopicTVCell

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
    [self.contentView addSubview:self.mainImageView];
    
    UIView *view = [[UIView alloc] initWithFrame:self.mainImageView.bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.mainImageView addSubview:view];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize21;
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.numberOfLines = 0;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.backgroundColor = [UIColor clearColor];
    [view addSubview:self.titleLab];
    
    self.shortTitleLab = [[UILabel alloc] init];
    self.shortTitleLab.font = KSystemFontSize14;
    self.shortTitleLab.textColor = [UIColor whiteColor];
    self.shortTitleLab.backgroundColor = [UIColor clearColor];
    self.shortTitleLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.shortTitleLab];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemFontSize10;
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.backgroundColor = [UIColor clearColor];
    self.numLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.numLab];
    
    self.enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MainterfaceTopicEnterImg]];
    [self.enterImage sizeToFit];
    [view addSubview:self.enterImage];
    
    self.tagImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TopicTagImg]];
    self.tagImg.backgroundColor = [UIColor clearColor];
    self.tagImg.frame = CGRectMake(self.mainImageView.frame.size.width - self.tagImg.frame.size.width,
                                   0,
                                   self.tagImg.frame.size.width,
                                   self.tagImg.frame.size.height);
    [self.tagImg sizeToFit];
    [self.mainImageView addSubview:self.tagImg];
    self.tagImg.hidden = YES;
    

}
- (void) refreshCurrentCellWith:(NSString *)picUrl andTitle:(NSString *) title andShortTitle:(NSString *) shortTitle and:(NSNumber *) number andPassTag:(NSNumber *) tag;{
    
    if ([tag intValue] == 0) {
        
        self.tagImg.hidden = YES;
    }else{
        
        self.tagImg.hidden = NO;
    }

    [NetWorkTask setImageView:self.mainImageView WithURL:picUrl placeholderImage:nil];
    
    
    self.titleLab.text =  title;
    
    CGRect currentRect = [self.titleLab.text boundingRectWithSize:CGSizeMake(self.mainImageView.frame.size.width - 40*Proportion, 1000)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:KSystemBoldFontSize21}
                                                          context:nil];
    if (shortTitle.length == 0) {
        
        self.titleLab.frame = CGRectMake((WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/2.0 - (self.mainImageView.frame.size.width - 40*Proportion)/2.0,
                                         ((WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/16*9)/2.0 - currentRect.size.height/2.0,
                                         self.mainImageView.frame.size.width - 40*Proportion,
                                         currentRect.size.height);
        
    }else{
      
        self.titleLab.frame = CGRectMake((WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/2.0 - (self.mainImageView.frame.size.width - 40*Proportion)/2.0,
                                         ((WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/16*9)/2.0 - currentRect.size.height,
                                         self.mainImageView.frame.size.width - 40*Proportion,
                                         currentRect.size.height);
    }

    
    self.shortTitleLab.text = shortTitle;
    [self.shortTitleLab sizeToFit];
    self.shortTitleLab.frame = CGRectMake((WIDTH - 2*NewSpecialTopicLeftMargin*Proportion)/2.0 - (self.mainImageView.frame.size.width - 40*Proportion)/2.0,
                                          CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                          self.mainImageView.frame.size.width - 40*Proportion,
                                          self.shortTitleLab.frame.size.height);
    
    if (number) {
        self.numLab.hidden = NO;
        self.enterImage.hidden = NO;
        self.numLab.text = [NSString stringWithFormat:@"%@条推荐",number];
        [self.numLab sizeToFit];
        self.numLab.frame = CGRectMake(self.mainImageView.frame.size.width/2.0 - self.numLab.frame.size.width/2.0,
                                       CGRectGetMaxY(self.shortTitleLab.frame) + (self.mainImageView.frame.size.height - CGRectGetMaxY(self.shortTitleLab.frame) - self.numLab.frame.size.height)/2.0,
                                       self.numLab.frame.size.width,
                                       self.numLab.frame.size.height);
        
        self.enterImage.frame = CGRectMake(CGRectGetMaxX(self.numLab.frame) + 5*Proportion,
                                           self.numLab.center.y - self.enterImage.frame.size.height/2.0,
                                           self.enterImage.frame.size.width,
                                           self.enterImage.frame.size.height);
    }else {
        self.numLab.hidden = YES;
        self.enterImage.hidden = YES;
    }
    
}
@end
