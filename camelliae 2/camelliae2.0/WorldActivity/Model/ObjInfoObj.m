//
//  ObjInfoObj.m
//  camelliae2.0
//
//  Created by 张越 on 2018/10/15.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "ObjInfoObj.h"

@implementation ObjInfoObj

@dynamic content;

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id"};
    
}


@end
