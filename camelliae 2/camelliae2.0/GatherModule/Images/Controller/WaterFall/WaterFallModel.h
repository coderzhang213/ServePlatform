//
//  WaterFallModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/1/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterFallModel :BaseResultObj

@property (nonatomic, assign) CGFloat waterImageWidth;

@property (nonatomic, assign) CGFloat waterImageHeight;

@property (nonatomic, strong) NSString *waterImageUrl;



@end

NS_ASSUME_NONNULL_END
