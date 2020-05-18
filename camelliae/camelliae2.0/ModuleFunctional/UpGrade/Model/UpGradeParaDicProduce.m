//
//  UpGradeParaDicProduce.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "UpGradeParaDicProduce.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NSString+CMLExspand.h"

@implementation UpGradeParaDicProduce

+ (NSMutableDictionary *) getSpecialPrivilegeParaDicWithLvl:(NSNumber *) lvlID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:lvlID forKey:@"memberLevelId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    return paraDic;
}

+ (NSMutableDictionary *) getProjectInfoWithObjID:(NSNumber *) projectID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:projectID forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[projectID,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    return paraDic;
}

+ (NSMutableDictionary *) getCreateAppointmentWithObjID:(NSNumber *)projectID andContactUser:(NSString *)contactUser andContactPhone:(NSString *)contactPhone andSmsCode:(NSString *) smsCode andPrice:(NSNumber *) price andPackageInfoId:(NSNumber *) packageId{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:projectID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:4] forKey:@"objType"];
    [paraDic setObject:contactUser forKey:@"contactUser"];
    [paraDic setObject:contactPhone forKey:@"contactPhone"];
    [paraDic setObject:smsCode forKey:@"smsCode"];
    int payAmtE2 = [price intValue]*100;
    [paraDic setObject:[NSNumber numberWithInt:payAmtE2] forKey:@"payAmtE2"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:packageId forKey:@"packageId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"parentType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[projectID,
                                                           [NSNumber numberWithInt:1],
                                                           [NSNumber numberWithInt:payAmtE2],
                                                           contactUser,
                                                           contactPhone ,
                                                           reqTime,
                                                           skey,
                                                           packageId,
                                                           [NSNumber numberWithInt:3]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    
    

    return paraDic;
}

+ (NSMutableDictionary *) getWXMesWithOrderID:(NSString *) orderID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:orderID forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                           orderID,
                                                           reqTime,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    return paraDic;
}

+ (NSMutableDictionary *) getZFBMesWithOrderID:(NSString *) orderID{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:orderID forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                           orderID,
                                                           reqTime,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    return paraDic;
}

+ (NSMutableDictionary *) getCancelAppointmentWithOrderID:(NSString *) orderID andProjectID:(NSNumber *) projectID andPackageInfoId:(NSNumber *) packageId{

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:projectID forKey:@"objId"];
    [paraDic setObject:orderID forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:packageId forKey:@"packageId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"parentType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[projectID,
                                                           [NSNumber numberWithInt:1],
                                                           orderID,
                                                           reqTime,
                                                           skey,
                                                           [NSNumber numberWithInt:3]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    return paraDic;
}

+ (NSMutableDictionary *) getConfirmAppointmentWithOrderID:(NSString *) orderID {

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:orderID forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                           orderID,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];

    return paraDic;
}
@end
