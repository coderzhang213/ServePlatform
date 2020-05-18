//
//  MemberSalonCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberSalonModel;

NS_ASSUME_NONNULL_BEGIN

@interface MemberSalonCell : UITableViewCell

@property (nonatomic, assign) CGFloat currentHeight;

- (void)refreshCurrentCell:(MemberSalonModel *)obj withCanJoin:(NSString *)canJoin;

@end

NS_ASSUME_NONNULL_END
