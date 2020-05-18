//
//  ThemeObj.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ThemeObj.h"

@implementation ThemeObj

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}
@end
