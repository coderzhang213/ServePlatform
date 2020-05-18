//
//  ActivityTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//


#import "ActivityTVCell.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"

#define ActivityLeftMargin     20
#define ActivityHeightAndWidth 200
#define ActivityImageTopMargin 20
#define ActivityTitleTopMargin 20


@interface ActivityTVCell()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *memberLevelLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *contentLabel;


@end
@implementation ActivityTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ActivityLeftMargin*Proportion,
                                                                   ActivityImageTopMargin*Proportion,
                                                                   ActivityHeightAndWidth*Proportion,
                                                                   ActivityHeightAndWidth*Proportion)];
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.clipsToBounds = YES;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_mainImageView];
    
    
    _memberLevelLabel = [[UILabel alloc] init];
    _memberLevelLabel.textColor = [UIColor CMLtextInputGrayColor];
    _memberLevelLabel.backgroundColor = [UIColor whiteColor];
    _memberLevelLabel.font = KSystemFontSize12;
    _memberLevelLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_memberLevelLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor CMLtextInputGrayColor];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.font =  KSystemFontSize12;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    

}

- (void) refreshCurrentActivityCell{
    
    [NetWorkTask setImageView:_mainImageView WithURL:self.imageUrl placeholderImage:nil];

    [_titleLabel removeFromSuperview];
    [_contentLabel removeFromSuperview];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = KSystemBoldFontSize15;
    _titleLabel.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.text = self.title;
    [_titleLabel sizeToFit];
    if (_titleLabel.frame.size.width > (WIDTH - ActivityHeightAndWidth*Proportion - ActivityLeftMargin*Proportion*3)) {
        _titleLabel.numberOfLines = 2;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                       ActivityImageTopMargin*Proportion,
                                       WIDTH - ActivityHeightAndWidth*Proportion - ActivityLeftMargin*Proportion*3,
                                       2*_titleLabel.frame.size.height);
    }else{
        _titleLabel.numberOfLines = 1;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                       ActivityImageTopMargin*Proportion,
                                       _titleLabel.frame.size.width,
                                       _titleLabel.frame.size.height);
    }
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = KSystemFontSize12;
    _contentLabel.textColor = [UIColor CMLtextInputGrayColor];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.text = self.brief;
    
    [_contentLabel sizeToFit];
    if (_contentLabel.frame.size.width > (WIDTH - ActivityHeightAndWidth*Proportion - ActivityLeftMargin*Proportion*3)) {
        
        _contentLabel.numberOfLines = 2;
        _contentLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                         CGRectGetMaxY(_titleLabel.frame)+ 10*Proportion,
                                         WIDTH - ActivityHeightAndWidth*Proportion - ActivityLeftMargin*Proportion*3,
                                         2*_contentLabel.frame.size.height);
        
        if (CGRectGetMaxY(_mainImageView.frame) - CGRectGetMaxY(_contentLabel.frame) < 30*Proportion) {
            _contentLabel.numberOfLines = 1;
            _contentLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                             CGRectGetMaxY(_titleLabel.frame)+ 5*Proportion,
                                             WIDTH - ActivityHeightAndWidth*Proportion - ActivityLeftMargin*Proportion*3,
                                             _contentLabel.frame.size.height);
        }
    }else{
        
        _contentLabel.numberOfLines = 1;
        _contentLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                         CGRectGetMaxY(_titleLabel.frame)+ 10*Proportion,
                                         _contentLabel.frame.size.width,
                                         _contentLabel.frame.size.height);
        
    }
    switch ([self.memberLevelId intValue]) {
        case 1:
            _memberLevelLabel.text = @"粉色";
            break;
        case 2:
            _memberLevelLabel.text = @"黛色";
            break;
        case 3:
            _memberLevelLabel.text = @"金色";
            break;
        case 4:
            _memberLevelLabel.text = @"墨色";
            break;
            
        default:
            break;
    }
    [_memberLevelLabel sizeToFit];
    _memberLevelLabel.layer.cornerRadius = 4*Proportion;
    _memberLevelLabel.frame = CGRectMake(CGRectGetMaxX(_mainImageView.frame) + ActivityLeftMargin*Proportion,
                                         CGRectGetMaxY(_mainImageView.frame)- 30*Proportion,
                                         _memberLevelLabel.frame.size.width+ 20*Proportion,
                                         30*Proportion);
    _memberLevelLabel.layer.borderWidth = 0.5;
    _memberLevelLabel.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    _memberLevelLabel.layer.cornerRadius = 4*Proportion;
    
    _timeLabel.text = [NSString getProjectStartTime:self.begintime];
    [_timeLabel sizeToFit];
    _timeLabel.layer.cornerRadius = 4*Proportion;
    _timeLabel.frame =  CGRectMake(CGRectGetMaxX(_memberLevelLabel.frame) + ActivityLeftMargin*Proportion,
                                          CGRectGetMaxY(_mainImageView.frame)- 30*Proportion,
                                      _timeLabel.frame.size.width + 20*Proportion,
                                      30*Proportion);
    _timeLabel.layer.borderWidth = 0.5;
    _timeLabel.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    _timeLabel.layer.cornerRadius = 4*Proportion;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
