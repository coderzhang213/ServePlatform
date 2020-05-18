//
//  CMLMessageObj.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLMessageObj.h"

@implementation CMLMessageObj
@dynamic content;
+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{@"currentID" : @"id"};
    
}

@end
