//
//  DataManager.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

/**静态*/
static DataManager *manager = nil;
static LightDataController *lightVC= nil;

- (instancetype) shareDataManager{

    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[DataManager alloc] init];
        });
    }
    return manager;
}

+ (LightDataController *) lightData{

    if (lightVC == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            lightVC = [[LightDataController alloc] init];
        });
    }
    return lightVC;
}

+ (void) saveSkey:(NSString *)skey{

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SKey.plist"];
    
    NSMutableDictionary *targetDic = [NSMutableDictionary dictionary];
    [targetDic setValue:skey forKey:@"skey"];
    
    [targetDic writeToFile:plistPath atomically:YES];
    
}


+ (NSString *) readSkey{

    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SKey.plist"];
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    return [data2 valueForKey:@"skey"];

}

+ (void) removeSkey{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SKey.plist"];
    
    NSMutableDictionary *targetDic = [NSMutableDictionary dictionary];
    [targetDic setValue:@"" forKey:@"skey"];
    
    [targetDic writeToFile:plistPath atomically:YES];
    
}
@end
