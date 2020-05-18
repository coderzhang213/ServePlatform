//
//  CMLTeamReplaceCell.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/8/14.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLTeamReplaceCell.h"

@implementation CMLTeamReplaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
    
}

- (void)loadViews {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20 * Proportion)];
    view.backgroundColor = [UIColor orangeColor];
    [self addSubview:view];
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
