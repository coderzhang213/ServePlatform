//
//  CMLWalletCenterTableView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/13.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

typedef enum {
    TeamAType = 0,
    TeamBType,
    TeamPinkType,
    TeamRebateType
}MyTeamType;
NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterTableView : CMLBaseTableView

//@property (nonatomic, assign) BOOL isTeamB;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTeamType:(int)teamType;

@property (nonatomic, copy) NSString *titleName;

@end

NS_ASSUME_NONNULL_END
