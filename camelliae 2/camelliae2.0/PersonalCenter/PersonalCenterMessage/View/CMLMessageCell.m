//
//  CMLMessageCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMessageCell.h"
#import "CMLMessageObj.h"
#import "NetWorkTask.h"
#import "NSString+CMLExspand.h"
#import "NSDate+CMLExspand.h"

@interface CMLMessageCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *pushImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *detailTimeLabel;

@property (nonatomic, strong) UIImageView *redPoint;

@property (nonatomic, strong) CMLMessageObj *obj;

@property (nonatomic, assign) NSInteger lineNumbers;

@end

@implementation CMLMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isPoint = YES;
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    self.bgView = [[UIView alloc] init];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.bgView addSubview:self.pushImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.redPoint];
    
}

- (void)refreshCurrentCell:(CMLMessageObj *)obj {
    self.obj = obj;
    
    NSString *str = obj.content;
    /*图片*/
    if (obj.url.length > 0) {
        self.pushImageView.hidden = NO;
        [NetWorkTask setImageView:self.pushImageView WithURL:obj.url placeholderImage:nil];
        self.pushImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.pushImageView.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.topView.frame) + 24 * Proportion, WIDTH - 30 * Proportion * 2, (WIDTH - 30 * Proportion * 2) * 120/346);
        
        /*文字*/
        if (obj.content) {
            
            self.titleLabel.text = str;//obj.content;
    
            CGRect currentRect =  [self.titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 30 * 2 * Proportion, 1000)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]} context:nil];
            if (currentRect.size.height < 2 * self.titleLabel.font.lineHeight) {
                [self.titleLabel sizeToFit];
                self.titleLabel.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.pushImageView.frame) + 24 * Proportion, WIDTH - 30 * 2 * Proportion, self.titleLabel.frame.size.height);
                self.lineNumbers = 1;
            }else {
                self.lineNumbers = currentRect.size.height/self.titleLabel.font.lineHeight;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:10 * Proportion];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
                self.titleLabel.attributedText = attributedString;
                self.titleLabel.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.pushImageView.frame) + 24 * Proportion, WIDTH - 30 * 2 * Proportion, currentRect.size.height + (self.lineNumbers - 1) * 10 * Proportion);
                self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            }
            
        }
    }else {
        self.pushImageView.hidden = YES;
        /*文字*/
        if (obj.content) {
            
            self.titleLabel.text = str;//obj.content;
            
            CGRect currentRect =  [self.titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 30 * 2 * Proportion, 1000)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]} context:nil];
            if (currentRect.size.height < 2 * self.titleLabel.font.lineHeight) {
                [self.titleLabel sizeToFit];
                self.titleLabel.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.topView.frame) + 24 * Proportion, WIDTH - 30 * 2 * Proportion, self.titleLabel.frame.size.height);
                self.lineNumbers = 1;
            }else {
                self.lineNumbers = currentRect.size.height/self.titleLabel.font.lineHeight;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:10 * Proportion];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
                self.titleLabel.attributedText = attributedString;
                self.titleLabel.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.topView.frame) + 24 * Proportion, WIDTH - 30 * 2 * Proportion, currentRect.size.height + (self.lineNumbers - 1) * 10 * Proportion);
                self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            }
        }
    }
    
    
    
    /*时间*/
    if (obj.created_at_str) {
        self.timeLabel.text = obj.created_at_str;
        [self.timeLabel sizeToFit];
        self.timeLabel.frame = CGRectMake(30 * Proportion, CGRectGetMaxY(self.titleLabel.frame) + 12*Proportion, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    }
    
    /*红点*/
    [self.redPoint sizeToFit];
    self.redPoint.frame = CGRectMake(WIDTH - 50*Proportion, CGRectGetMidY(self.timeLabel.frame) - 3, 6, 6);
    if ([obj.isRead intValue] == 2) {
        self.redPoint.hidden = NO;
    }else {
        self.redPoint.hidden = YES;
    }
    
    self.currentHeight = CGRectGetMaxY(self.timeLabel.frame) + 23 * Proportion;
    
    self.bgView.frame = CGRectMake(0, 0, WIDTH, self.currentHeight);
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20 * Proportion)];
        _topView.backgroundColor = [UIColor CMLF6F6F6Color];
        
    }
    return _topView;
}

- (UIImageView *)pushImageView {
    
    if (!_pushImageView) {
        _pushImageView = [[UIImageView alloc] init];
        _pushImageView.backgroundColor = [UIColor whiteColor];
        _pushImageView.layer.cornerRadius = 10 * Proportion;
        _pushImageView.clipsToBounds = YES;
        [self addSubview:_pushImageView];
    }
    return _pushImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor CML25211EColor];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _timeLabel.textColor = [UIColor CMLA2A2A2Color];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)detailTimeLabel {
    
    if (!_detailTimeLabel) {
        _detailTimeLabel = [[UILabel alloc] init];
        _detailTimeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _detailTimeLabel.textColor = [UIColor CMLA2A2A2Color];
        [self addSubview:_detailTimeLabel];
    }
    return _detailTimeLabel;
}

- (UIImageView *)redPoint {
    
    if (!_redPoint) {
        _redPoint = [[UIImageView alloc] init];
        _redPoint.backgroundColor = [UIColor redColor];
        _redPoint.clipsToBounds = YES;
        _redPoint.layer.cornerRadius = 12 * Proportion/2;
        [self addSubview:_redPoint];
    }
    return _redPoint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
