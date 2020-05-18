//
//  CMLWalletCenterMyTeamTopView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLTeamInfoModel;
typedef enum {
    TeamTopAType = 0,
    TeamTopBType,
    TeamTopPinkType,
    TeamTopRebateType,
    TeamTopPinkDiamondType
}MyTeamTopType;
//@protocol CMLWalletCenterMyTeamTopViewDelegate <NSObject>
//
//- (void) loadTopViewSuccess;
//
//- (void) progressSuccess;
//
//- (void) progressError:(NSString *) msg andCode:(int) code;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterMyTeamTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame withParentName:(NSString *)parentName withCount:(NSString *)count withTeamType:(int)teamType;

@end

NS_ASSUME_NONNULL_END
