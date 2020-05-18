//
//  BrandAndServeObj.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BrandAndServeObj.h"

@implementation BrandAndServeObj

@dynamic content;

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id"};
    
}

@end
