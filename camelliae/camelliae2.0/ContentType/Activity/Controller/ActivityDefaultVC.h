//
//  ActivityDefaultVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol ActivityDefaultVCDelegate <NSObject>

@optional

- (void)refreshFashionSalonEquity;

@end

@interface ActivityDefaultVC : CMLBaseVC

@property (nonatomic, strong) NSString *isJoin;

- (instancetype)initWithObjId:(NSNumber *)objId;

@property (nonatomic,weak) id<ActivityDefaultVCDelegate> delegate;

@end
