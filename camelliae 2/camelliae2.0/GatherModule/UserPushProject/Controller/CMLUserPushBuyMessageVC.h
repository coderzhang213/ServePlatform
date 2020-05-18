//
//  CMLUserPushBuyMessageVC.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/19.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "BaseResultObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface CMLUserPushBuyMessageVC : CMLBaseVC

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) NSNumber *packageID;

@property (nonatomic,strong) NSNumber *parentType;

@property (nonatomic,assign) int buyNum;

@end

NS_ASSUME_NONNULL_END
