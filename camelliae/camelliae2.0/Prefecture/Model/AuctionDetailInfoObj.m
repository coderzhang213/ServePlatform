//
//  AuctionDetailInfoObj.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/9.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "AuctionDetailInfoObj.h"

@implementation AuctionDetailInfoObj
+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"currentID" : @"id"};
    
}

@end
