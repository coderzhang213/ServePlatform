//
//  CMLSubscribeDefaultVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/4/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol  CMLSubscribeDefaultVCDelegate <NSObject>

- (void) refreshCurrentVC;

@end

@interface CMLSubscribeDefaultVC : CMLBaseVC

- (instancetype)initWithOrderId:(NSString *) orderId isDeleted:(NSNumber *) state;

@property (nonatomic,weak) id<CMLSubscribeDefaultVCDelegate>delegate;

@property (nonatomic, strong) NSNumber *orderSuccess;

@end
