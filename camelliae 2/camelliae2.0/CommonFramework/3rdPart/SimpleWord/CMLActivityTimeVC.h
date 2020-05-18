//
//  CMLActivityTimeVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/8.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ActivityTimeDelegate <NSObject>

- (void) outputActivityTime:(NSString *) start andEndTime:(NSString *) end;

@end


@interface CMLActivityTimeVC : CMLBaseVC

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic,weak) id<ActivityTimeDelegate>activityTimeDelegate;

@end

NS_ASSUME_NONNULL_END
