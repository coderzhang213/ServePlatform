//
//  NSObject+CMLKeyValue.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/18.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "NSObject+CMLKeyValue.h"
#import <objc/runtime.h>


@implementation NSObject (CMLKeyValue)

/*字典转换简单数据模型*/
+ (instancetype)objectWithModelDic:(NSDictionary *)modelDic hintDic:(NSDictionary *)hintDic {
    NSObject *instance = [[[self class] alloc] init];
    unsigned int numIvars; // 成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    NSString *key=nil;
    NSString *key_property = nil;  // 属性
    NSString *type = nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  // 获取成员变量的名字
        key = [key hasPrefix:@"_"]?[key substringFromIndex:1]:key;   // 如果是属性自动产生的成员变量，去掉头部下划线
        key_property = key;
        
        // 映射字典,转换key
        if (hintDic) {
            key = [hintDic objectForKey:key]?[hintDic objectForKey:key]:key;
        }
        
        id value = [modelDic objectForKey:key];
        
        if (value==nil) {
            type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
            // 列举了常用的基本数据类型，如果有其他的，需要添加
            if ([type isEqualToString:@"B"]||[type isEqualToString:@"d"]||[type isEqualToString:@"i"]|[type isEqualToString:@"I"]||[type isEqualToString:@"f"]||[type isEqualToString:@"q"]) {
                value = @(0);
            }
        }
        [instance setValue:value forKey:key_property];
    }
    free(vars);
    return instance;
}


@end
