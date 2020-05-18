//
//  CMLTimeLineRelevantActivitySerachVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/20.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol TimeLineRelevantActivitySerachDelegate <NSObject>

- (void) refreshRelevantActivityWith:(NSString *) imageUrl activityID:(NSNumber *) currentID activityTitle:(NSString*) titile;

@end

@interface CMLTimeLineRelevantActivitySerachVC : CMLBaseVC

@property (nonatomic,weak) id<TimeLineRelevantActivitySerachDelegate> delegate;

@end
