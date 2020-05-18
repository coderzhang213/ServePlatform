//
//  ChildPrefectureDetailModel.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/10/22.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "ChildPrefectureDetailModel.h"

@implementation ChildPrefectureDetailModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id",@"currentActivityInfo":@"newActivityInfo"};
    
}

@end
