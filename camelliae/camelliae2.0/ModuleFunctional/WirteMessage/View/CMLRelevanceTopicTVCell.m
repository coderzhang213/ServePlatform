//
//  CMLRelevanceTopicTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRelevanceTopicTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"

@interface CMLRelevanceTopicTVCell ()

@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation CMLRelevanceTopicTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
     
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize14;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLab];
}

- (void) refreshTVCellWith:(NSString *) currentTitle andSerach:(NSString *) str{
    
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:currentTitle];
    
    if ([currentTitle rangeOfString:str].location != NSNotFound) {
    
        [newStr addAttributes:@{NSForegroundColorAttributeName:[UIColor CMLBrownColor]} range:[currentTitle rangeOfString:str]];
        
    }
    
    self.titleLab.attributedText = newStr;

    [self.titleLab sizeToFit];
    self.titleLab.frame = CGRectMake(30*Proportion,
                                     100*Proportion/2.0 - self.titleLab.frame.size.height/2.0,
                                     WIDTH - 30*Proportion*2,
                                     self.titleLab.frame.size.height);
}
@end
