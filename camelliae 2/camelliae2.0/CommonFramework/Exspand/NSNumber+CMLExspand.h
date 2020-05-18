//
//  NSNumber+CMLExspand.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/23.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CMLExspand)

+ (NSNumber *) getServeFormulateAddressIDFrom:(NSString *) address;

+ (NSNumber *) getServeFormulateTopicIDFrom:(NSString *) topic;

+ (NSNumber *) getServeFormulateBudgetIDFrom:(NSString *) budget;

+ (NSNumber *) getServeFormulateTimeIDFrom:(NSString *) time;


@end
