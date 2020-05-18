//
//  SpecialParaDicProduce.h
//  camelliae2.0
//
//  Created by 张越 on 2017/1/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialParaDicProduce : NSObject

+ (NSMutableDictionary *) getTopicListParaDicWithPage:(int) page andPageSize:(int) pageSize;

+ (NSMutableDictionary *) getNewTopicDetailParaDicWithPage:(int) page andPageSize:(int) pageSize andCurrentID:(NSNumber *) currentID;

+ (NSMutableDictionary *) getActivityShareParaDicWithObjID:(NSNumber *) objID;

@end
