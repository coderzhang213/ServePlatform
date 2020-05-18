//
//  TimingInfoObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface TimingInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *countDown;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,copy) NSString *title;

@end
