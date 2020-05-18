//
//  MainInterfaceImageTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "MainInterfaceImageTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NSDate+CMLExspand.h"
#import "CommonNumber.h"
#import "CMLImageListObj.h"

@interface MainInterfaceImageTVCell()

@property (nonatomic,strong) UIImageView *bigImage;

@property (nonatomic,strong) UIImageView *smallImage;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UIImageView *enterImage;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIImageView *lockImage;

@end

@implementation MainInterfaceImageTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.bigImage = [[UIImageView alloc] init];
    self.bigImage.backgroundColor = [UIColor CMLNewGrayColor];
    self.bigImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImage.userInteractionEnabled = YES;
    self.bigImage.clipsToBounds = YES;
    self.bigImage.frame = CGRectMake(30*Proportion,
                                     0,
                                     468*Proportion,
                                     312*Proportion);
    [self addSubview:self.bigImage];
    
    self.smallImage = [[UIImageView alloc] init];
    self.smallImage.backgroundColor = [UIColor CMLNewGrayColor];
    self.smallImage.contentMode = UIViewContentModeScaleAspectFill;
    self.smallImage.userInteractionEnabled = YES;
    self.smallImage.clipsToBounds = YES;
    self.smallImage.frame = CGRectMake(WIDTH - 30*Proportion - 208*Proportion,
                                       0,
                                       208*Proportion,
                                       312*Proportion);
    [self addSubview:self.smallImage];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:self.smallImage.bounds];
    shadowView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
    [self.smallImage addSubview:shadowView];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemBoldFontSize18;
    self.numLab.textColor = [UIColor CMLWhiteColor];
    [self.smallImage addSubview:self.numLab];
    
    self.enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MainterfaceImageEnterImg]];
    self.enterImage.backgroundColor = [UIColor clearColor];
    [self.smallImage addSubview:self.enterImage];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor CMLBlackColor];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = KSystemBoldFontSize16;
    self.titleLab.numberOfLines = 0;
    [self addSubview:self.titleLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = [UIColor CMLtextInputGrayColor];
    self.timeLab.font = [UIFont fontWithName:@"SnellRoundhand" size:12];
    [self addSubview:self.timeLab];
    
    self.lockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TableListImageEncryptImg]];
    [self.lockImage sizeToFit];
    self.lockImage.frame = CGRectMake(self.smallImage.frame.size.width - self.lockImage.frame.size.width - 10.6*Proportion,
                                      self.smallImage.frame.size.height - self.lockImage.frame.size.height - 10.6*Proportion,
                                      self.lockImage.frame.size.width,
                                      self.lockImage.frame.size.width);
    [self.smallImage addSubview:self.lockImage];
    self.lockImage.hidden = YES;
    
    
    
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.bottomLine];
    
}

- (void) refreshCurrentCell:(CMLImageListObj *) obj{
    
    
    
    [NetWorkTask setImageView:self.bigImage WithURL:obj.coverPicThumb placeholderImage:nil];
    [NetWorkTask setImageView:self.smallImage WithURL:obj.detailCoverPicThumb placeholderImage:nil];
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text = obj.title;
    CGRect currentRect = [self.timeLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2,HEIGHT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:KSystemBoldFontSize16}
                                                          context:nil];
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     CGRectGetMaxY(self.bigImage.frame) + 10*Proportion,
                                     WIDTH - 30*Proportion*2,
                                     currentRect.size.height);
    
    self.timeLab.frame = CGRectZero;
    self.timeLab.text = [[NSDate getStringDependOnFormatterCFromDate:[NSDate dateWithTimeIntervalSince1970:[obj.publishDate integerValue]]] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(30*Proportion,
                                    CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);
    
    
    self.numLab.text = [NSString stringWithFormat:@"%@",obj.detailPicCount];
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(self.smallImage.frame.size.width/2.0 - self.numLab.frame.size.width/2.0 - 10*Proportion/2.0,
                                   self.smallImage.frame.size.height/2.0 - self.numLab.frame.size.height/2.0,
                                   self.numLab.frame.size.width,
                                   self.numLab.frame.size.height);
    
    [self.enterImage sizeToFit];
    self.enterImage.frame = CGRectMake(CGRectGetMaxX(self.numLab.frame) + 10*Proportion,
                                       self.smallImage.frame.size.height/2.0 - self.enterImage.frame.size.height/2.0,
                                       self.enterImage.frame.size.width,
                                       self.enterImage.frame.size.height);
    
    self.bottomLine.frame = CGRectMake(30*Proportion,
                                       CGRectGetMaxY(self.timeLab.frame) + 40*Proportion,
                                       WIDTH - 30*Proportion*2,
                                       1);
    
    if ([obj.isEncrypt intValue] == 1) {
        
        self.lockImage.hidden = NO;
        
    }else{
        
        self.lockImage.hidden = YES;
    }
    
    
    self.currentHeight = CGRectGetMaxY(self.bottomLine.frame) + 40*Proportion;
    
    
}
@end
