//
//  CMLMemberEquityCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/12.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLEquityModel;

NS_ASSUME_NONNULL_BEGIN

@interface CMLMemberEquityCell : UICollectionViewCell

- (void) refreshCurrentCellWith:(CMLEquityModel *)equityModel;

@end

NS_ASSUME_NONNULL_END
