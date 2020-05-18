//
//  ActivityTypeObj.m
//  camelliae2.0
//
//  Created by 张越 on 2016/10/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityTypeObj.h"

@implementation ActivityTypeObj

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}


@end
