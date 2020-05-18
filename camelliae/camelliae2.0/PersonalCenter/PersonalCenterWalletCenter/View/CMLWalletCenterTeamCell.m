//
//  CMLWalletCenterTeamCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/12.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterTeamCell.h"
#import "CMLWalletCenterModel.h"

@interface CMLWalletCenterTeamCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@end

@implementation CMLWalletCenterTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)refreshWalletCenterTeamCell:(CMLWalletCenterModel *)obj {
    
    [NetWorkTask setImageView:self.headImage WithURL:obj.gravatar placeholderImage:nil];
    self.nameLabel.text = obj.userName;
    self.timeLabel.text = obj.created_at_str;
    self.sumLabel.text = obj.costStr;
    if ([obj.type intValue] == 4) {/*提现*/
        
        if ([obj.status intValue] == 1) {
            self.stateButton.titleLabel.text = @"提现";
        }else if ([obj.status intValue] == 2) {
            self.stateButton.titleLabel.text = @"提现中";
        }else {
            self.stateButton.titleLabel.text = @"提现失败";
            self.sumLabel.textColor = [UIColor CMLEA3F3FColor];
        }
        
    }else {
        /*试用会员*/
        if ([obj.cost intValue] == 0) {
            [self.stateButton setImage:[UIImage imageNamed:CMLWalletCenterProbationImage] forState:UIControlStateNormal];
        }else {
            self.stateButton.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
