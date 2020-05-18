//
//  SpecialParaDicProduce.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SpecialParaDicProduce.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "DataManager.h"

@implementation SpecialParaDicProduce

+ (NSMutableDictionary *) getTopicListParaDicWithPage:(int) page andPageSize:(int) pageSize{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];

    return paraDic;
}

+ (NSMutableDictionary *) getNewTopicDetailParaDicWithPage:(int) page andPageSize:(int) pageSize andCurrentID:(NSNumber *) currentID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:currentID forKey:@"topicIndexId"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];

    return paraDic;
}

+ (NSMutableDictionary *) getActivityShareParaDicWithObjID:(NSNumber *) objID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:objID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[objID,
                                                           [NSNumber numberWithInt:3],
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    return paraDic;
}
@end
