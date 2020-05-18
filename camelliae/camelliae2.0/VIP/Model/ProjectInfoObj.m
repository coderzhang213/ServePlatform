//
//  ProjectInfoObj.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ProjectInfoObj.h"

@implementation ProjectInfoObj

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}

@end
