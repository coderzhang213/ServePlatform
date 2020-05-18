//
//  RecommendTimeLineObj.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "RecommendTimeLineObj.h"

@implementation RecommendTimeLineObj

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}
@end
