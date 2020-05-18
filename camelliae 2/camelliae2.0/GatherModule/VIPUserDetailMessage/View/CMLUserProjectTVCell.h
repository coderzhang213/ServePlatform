//
//  CMLUserProjectTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendTimeLineObj.h"

typedef void(^DeleteProjectBlock)(NSNumber *currentId);

@interface CMLUserProjectTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat currentCellHeight;

@property (nonatomic,copy) DeleteProjectBlock deleteProject;


- (void) refreshCurrentCellWith:(RecommendTimeLineObj *) obj atIndexPath:(NSIndexPath *)indexPath;

- (void) refreshCurrentCellLikebtnStatus:(NSNumber *) status andNum:(int) number;

@end
