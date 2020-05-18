//
//  CMLWalletCenterMyTeamCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLTeamInfoModel;
typedef enum {
    TeamCellAType = 0,
    TeamCellBType,
    TeamCellPinkType,
    TeamCellRebateType
}MyTeamCellType;
NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterMyTeamCell : UITableViewCell

- (void)refreshCurrentCell:(CMLTeamInfoModel *)obj withTeamType:(int)teamType;

@end

NS_ASSUME_NONNULL_END
