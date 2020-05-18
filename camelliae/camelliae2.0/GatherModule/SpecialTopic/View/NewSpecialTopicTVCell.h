//
//  NewSpecialTopTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2016/11/4.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSpecialTopicTVCell : UITableViewCell



- (void) refreshCurrentCellWith:(NSString *)picUrl andTitle:(NSString *) title andShortTitle:(NSString *) shortTitle and:(NSNumber *) number andPassTag:(NSNumber *) tag;

@end
