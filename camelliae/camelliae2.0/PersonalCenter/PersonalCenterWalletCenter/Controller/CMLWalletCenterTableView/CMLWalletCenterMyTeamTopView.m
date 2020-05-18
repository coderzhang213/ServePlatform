//
//  CMLWalletCenterMyTeamTopView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterMyTeamTopView.h"
#import "CMLTeamInfoModel.h"

@interface CMLWalletCenterMyTeamTopView ()

@property (nonatomic, strong) UILabel *peopleNameLabel;

@property (nonatomic, strong) UILabel *peopleCountLabel;

@end

@implementation CMLWalletCenterMyTeamTopView

- (instancetype)initWithFrame:(CGRect)frame withParentName:(NSString *)parentName withCount:(NSString *)count withTeamType:(int)teamType {
    
    self = [super init];
    if (self) {
        
        self.frame = frame;
        
        [self loadViewWithParentName:parentName withCount:count withTeamType:teamType];
    }
    return self;
}

- (void)loadViewWithParentName:(NSString *)parentName withCount:(NSString *)count withTeamType:(int)teamType {
    
    if (teamType == 1) {
        self.peopleNameLabel.text = parentName;
    }else if(teamType == 0) {
        self.peopleNameLabel.text = @"黛色用户";
    }else if(teamType == 2) {
        self.peopleNameLabel.text = @"粉金用户";
    }else if (teamType == 3) {
        self.peopleNameLabel.text = @"粉钻用户";
    }
    
    [self.peopleNameLabel sizeToFit];
    self.peopleNameLabel.frame = CGRectMake(42 * Proportion,
                                            58 * Proportion,
                                            CGRectGetWidth(self.peopleNameLabel.frame),
                                            CGRectGetHeight(self.peopleNameLabel.frame));
    [self addSubview:self.peopleNameLabel];
    if (count.length == 0) {
        count = @"0";
    }
    NSString *string = [NSString stringWithFormat:@"共 %@ 人", count];
    self.peopleCountLabel.text = string;
    [self.peopleCountLabel sizeToFit];
    self.peopleCountLabel.frame = CGRectMake(42 * Proportion,
                                             CGRectGetMaxY(self.peopleNameLabel.frame) + 18 * Proportion,
                                             CGRectGetWidth(self.peopleCountLabel.frame),
                                             CGRectGetHeight(self.peopleCountLabel.frame));
    [self addSubview:self.peopleCountLabel];
    
    
}

- (UILabel *)peopleNameLabel {
    
    if (!_peopleNameLabel) {
        _peopleNameLabel = [[UILabel alloc] init];
        _peopleNameLabel.backgroundColor = [UIColor clearColor];
        _peopleNameLabel.text = @"A级团队";
        _peopleNameLabel.textColor = [UIColor CMLUserBlackColor];
        _peopleNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    }
    return _peopleNameLabel;
}

- (UILabel *)peopleCountLabel {
    
    if (!_peopleCountLabel) {
        _peopleCountLabel = [[UILabel alloc] init];
        _peopleCountLabel.backgroundColor = [UIColor clearColor];
        _peopleCountLabel.text = @"共 0 人";
        _peopleCountLabel.textColor = [UIColor CMLUserBlackColor];
        _peopleCountLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _peopleCountLabel;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
