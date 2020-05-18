//
//  UpGradeParaDicProduce.h
//  camelliae2.0
//
//  Created by 张越 on 2017/1/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpGradeParaDicProduce : NSObject


+ (NSMutableDictionary *) getSpecialPrivilegeParaDicWithLvl:(NSNumber *) lvlID;

+ (NSMutableDictionary *) getProjectInfoWithObjID:(NSNumber *) projectID;

+ (NSMutableDictionary *) getCreateAppointmentWithObjID:(NSNumber *)projectID
                                  andContactUser:(NSString *)contactUser
                                 andContactPhone:(NSString *)contactPhone
                                      andSmsCode:(NSString *) smsCode
                                        andPrice:(NSNumber *) price
                                andPackageInfoId:(NSNumber *) packageId;

+ (NSMutableDictionary *) getWXMesWithOrderID:(NSString *) orderID;
+ (NSMutableDictionary *) getZFBMesWithOrderID:(NSString *) orderID;

+ (NSMutableDictionary *) getCancelAppointmentWithOrderID:(NSString *) orderID
                                      andProjectID:(NSNumber *) projectID
                                  andPackageInfoId:(NSNumber *) packageId;
+ (NSMutableDictionary *) getConfirmAppointmentWithOrderID:(NSString *) orderID;



@end
