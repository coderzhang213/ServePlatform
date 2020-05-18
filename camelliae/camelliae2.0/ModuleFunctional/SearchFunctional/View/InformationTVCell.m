//
//  InformationTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "InformationTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"

#define InformationLeftMargin     30
#define InformationHeightAndWidth 200
#define InformationImageTopMargin 20
#define InformationTitleTopMargin 20

@interface InformationTVCell ()

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *subTypeLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *mainImageView;


@end

@implementation InformationTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(InformationLeftMargin*Proportion,
                                                                   InformationImageTopMargin*Proportion,
                                                                   InformationHeightAndWidth*Proportion,
                                                                   InformationHeightAndWidth*Proportion)];
    _mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    _mainImageView.clipsToBounds = YES;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_mainImageView];
    
    _subTypeLabel = [[UILabel alloc] init];
    _subTypeLabel.textColor = [UIColor CMLtextInputGrayColor];
    _subTypeLabel.backgroundColor = [UIColor whiteColor];
    _subTypeLabel.font = KSystemFontSize10;
    _subTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_subTypeLabel];
    
    _title = [[UILabel alloc] init];
    _title.font = KSystemBoldFontSize15;
    _title.textColor = [UIColor CMLBlackColor];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_title];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = KSystemFontSize12;
    _contentLabel.textColor = [UIColor CMLtextInputGrayColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = KSystemFontSize10;
    _timeLabel.textColor = [UIColor CMLtextInputGrayColor];
    [self.contentView addSubview:_timeLabel];

}

- (void) refreshCurrentInformationTVCell:(NSString *) imagrUrl andTitle:(NSString *)title{
    
    
    [NetWorkTask setImageView:_mainImageView WithURL:imagrUrl placeholderImage:nil];
    
    _title.frame = CGRectMake(0,
                              0,
                              0,
                              0);
    _contentLabel.frame = CGRectMake(0,
                                     0,
                                     0,
                                     0);
    
    _title.text = title;
    [_title sizeToFit];
    if (_title.frame.size.width > (WIDTH - InformationLeftMargin*Proportion*3 - InformationHeightAndWidth*Proportion)) {
        
        _title.numberOfLines = 2;
        _title.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + InformationLeftMargin*Proportion,
                                   InformationImageTopMargin*Proportion,
                                  WIDTH - InformationLeftMargin*Proportion*3 - InformationHeightAndWidth*Proportion,
                                  2*_title.frame.size.height);
    }else{
    
        _title.numberOfLines = 1;
        _title.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + InformationLeftMargin*Proportion,
                                  InformationImageTopMargin*Proportion,
                                  _title.frame.size.width,
                                  _title.frame.size.height);
    }
    
    _contentLabel.text = self.brief;
    [_contentLabel sizeToFit];
    if (_contentLabel.frame.size.width > (WIDTH - InformationLeftMargin*Proportion*3 - InformationHeightAndWidth*Proportion)) {
        
        _contentLabel.numberOfLines = 2;
        _contentLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + InformationLeftMargin*Proportion,
                                         CGRectGetMaxY(_title.frame)+ 20*Proportion,
                                         WIDTH - InformationLeftMargin*Proportion*2 - InformationHeightAndWidth*Proportion,
                                         2*_contentLabel.frame.size.height);
        
        if ((InformationImageTopMargin + InformationHeightAndWidth)*Proportion - CGRectGetMaxY(_contentLabel.frame) < 30*Proportion) {
            _contentLabel.numberOfLines = 1;
            _contentLabel.frame = CGRectMake(InformationLeftMargin*Proportion,
                                             CGRectGetMaxY(_title.frame)+ 20*Proportion,
                                             WIDTH - InformationLeftMargin*Proportion*3 - InformationHeightAndWidth*Proportion,
                                             _contentLabel.frame.size.height/2.0);
        }
    }else{
        
        _contentLabel.numberOfLines = 1;
        _contentLabel.frame = CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + InformationLeftMargin*Proportion,
                                         CGRectGetMaxY(_title.frame)+ 10*Proportion,
                                         _contentLabel.frame.size.width,
                                         _contentLabel.frame.size.height);
        
    }
    
    _subTypeLabel.text = self.subType;
    [_subTypeLabel sizeToFit];
    _subTypeLabel.layer.cornerRadius = 4*Proportion;
    _subTypeLabel.frame =  CGRectMake(CGRectGetMaxX(self.mainImageView.frame) + InformationLeftMargin*Proportion,
                                      (InformationImageTopMargin + InformationHeightAndWidth)*Proportion- 30*Proportion,
                                      _subTypeLabel.frame.size.width  + 20*Proportion,
                                      30*Proportion);
    _subTypeLabel.layer.borderWidth = 0.5;
    _subTypeLabel.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    _subTypeLabel.layer.cornerRadius = 4*Proportion;
    
    _timeLabel.text = self.time;
    [_timeLabel sizeToFit];
    _timeLabel.frame =CGRectMake(WIDTH - InformationLeftMargin*Proportion - _timeLabel.frame.size.width,
                                 _subTypeLabel.center.y - _timeLabel.frame.size.height/2.0,
                                 _timeLabel.frame.size.width,
                                 _timeLabel.frame.size.height);

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
