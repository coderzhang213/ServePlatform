//
//  CMLNewVipUseTimeLineTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendTimeLineObj.h"
@class ProjectInfoObj;

typedef void(^DeleteTimeLineBlock)(NSNumber *currentId);

@interface CMLNewVipUseTimeLineTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat currentCellHeight;

@property (nonatomic,copy) DeleteTimeLineBlock deleteTimeLine;

@property (nonatomic,assign) BOOL isHasTopicBtn;

@property (nonatomic,assign) BOOL isAllReport;

- (void) clear;

- (void) refreshCurrentCellWith:(RecommendTimeLineObj *) obj atIndexPath:(NSIndexPath *)indexPath;

- (void) refreshCurrentCellLikebtnStatus:(NSNumber *) status andNum:(int) number;


@end
