//
//  CMLVIPTopicTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecommendTimeLineObj.h"

@interface CMLVIPTopicTVCell : UITableViewCell

- (void) refreshCurrentTVCellWith:(RecommendTimeLineObj *) obj;
@end
