//
//  CMLCommenOrderObj.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommenOrderObj.h"

@implementation CMLCommenOrderObj

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}

@end
