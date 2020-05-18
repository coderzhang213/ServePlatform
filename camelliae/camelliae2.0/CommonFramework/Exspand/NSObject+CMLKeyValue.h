//
//  NSObject+CMLKeyValue.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/18.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CMLKeyValue)

+ (instancetype)objectWithModelDic:(NSDictionary *)modelDic hintDic:(NSDictionary *)hintDic;

@end

NS_ASSUME_NONNULL_END
