//
//  CMLTimeLineRelevantTopicSerachVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol TimeLineRelevantTopicSerachDelegate <NSObject>

- (void) refreshRelevantTopicID:(NSNumber *) currentID topicTitle:(NSString*) titile;

@end

@interface CMLTimeLineRelevantTopicSerachVC : CMLBaseVC

@property (nonatomic,weak) id<TimeLineRelevantTopicSerachDelegate> delegate;

@end
