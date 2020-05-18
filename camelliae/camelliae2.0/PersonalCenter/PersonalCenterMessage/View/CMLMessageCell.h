//
//  CMLMessageCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMLMessageObj;

NS_ASSUME_NONNULL_BEGIN

@interface CMLMessageCell : UITableViewCell

- (void)refreshCurrentCell:(CMLMessageObj *)obj;

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, assign) BOOL isPoint;

@end

NS_ASSUME_NONNULL_END
