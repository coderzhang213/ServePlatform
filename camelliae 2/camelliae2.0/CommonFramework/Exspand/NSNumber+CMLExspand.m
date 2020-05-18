//
//  NSNumber+CMLExspand.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/23.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NSNumber+CMLExspand.h"

@implementation NSNumber (CMLExspand)

+ (NSNumber *) getServeFormulateAddressIDFrom:(NSString *) address{
    
    NSNumber *targetID;
    
    if ([address isEqualToString:@"摩纳哥"]) {
        
        targetID = [NSNumber numberWithInt:79];
        
    }else if ([address isEqualToString:@"日本"]){
    
        targetID = [NSNumber numberWithInt:25];
        
    }else if ([address isEqualToString:@"新加坡"]){
    
        targetID = [NSNumber numberWithInt:33];
    
    }else if ([address isEqualToString:@"美国"]){
    
        targetID = [NSNumber numberWithInt:184];
        
    }else if ([address isEqualToString:@"法国"]){
    
        targetID = [NSNumber numberWithInt:60];
    
    }else if ([address isEqualToString:@"克罗地亚"]){
    
        targetID = [NSNumber numberWithInt:69];
        
    }else if ([address isEqualToString:@"柬埔寨"]){
    
        targetID = [NSNumber numberWithInt:13];
    
    }else if ([address isEqualToString:@"英国"]){
    
        targetID = [NSNumber numberWithInt:97];
        
    }else if ([address isEqualToString:@"意大利"]){
    
        targetID = [NSNumber numberWithInt:96];
    
    }else if ([address isEqualToString:@"巴西"]){
    
        targetID = [NSNumber numberWithInt:204];
        
    }else if ([address isEqualToString:@"肯尼亚"]){
    
        targetID = [NSNumber numberWithInt:125];
    
    }else if ([address isEqualToString:@"蒙古"]){
    
        targetID = [NSNumber numberWithInt:21];
    
    }else if ([address isEqualToString:@"葡萄牙"]){
    
        targetID = [NSNumber numberWithInt:81];
    
    }else if ([address isEqualToString:@"不丹"]){
    
        targetID = [NSNumber numberWithInt:7];
    
    }
    
    return targetID;

}

+ (NSNumber *) getServeFormulateTopicIDFrom:(NSString *) topic{

    NSNumber *targetID;
    if ([topic isEqualToString:@"时尚之旅"]) {
        
        targetID = [NSNumber numberWithInt:1];
        
    }else if ([topic isEqualToString:@"商务游"]){
    
        targetID = [NSNumber numberWithInt:2];
    
    }else if ([topic isEqualToString:@"观光游"]){
    
        targetID = [NSNumber numberWithInt:3];
    
    }else if ([topic isEqualToString:@"主题游"]){
    
        targetID = [NSNumber numberWithInt:4];
    
    }else if ([topic isEqualToString:@"蜜月行"]){
    
        targetID = [NSNumber numberWithInt:5];
        
    }else if ([topic isEqualToString:@"避暑避寒"]){
    
        targetID = [NSNumber numberWithInt:6];
        
    }else if ([topic isEqualToString:@"顶级奢华"]){
    
        targetID = [NSNumber numberWithInt:7];
    
    }else if ([topic isEqualToString:@"游轮度假"]){
    
        targetID = [NSNumber numberWithInt:8];
    
    }else if ([topic isEqualToString:@"浪漫海岛"]){
    
        targetID = [NSNumber numberWithInt:9];
    
    }
    
    return targetID;
}

+ (NSNumber *) getServeFormulateBudgetIDFrom:(NSString *) budget{

    NSNumber *targetID;
    
    
    if ([budget isEqualToString:@"0-1万元"]) {
        
        targetID = [NSNumber numberWithInt:1];
        
    }else if ([budget isEqualToString:@"1-3万元"]){
        
        targetID = [NSNumber numberWithInt:2];
        
    }else if ([budget isEqualToString:@"3-5万元"]){
        
        targetID = [NSNumber numberWithInt:3];
        
    }else if ([budget isEqualToString:@"5-10万元"]){
        
        targetID = [NSNumber numberWithInt:4];
        
    }else if ([budget isEqualToString:@"10-20万元"]){
        
        targetID = [NSNumber numberWithInt:5];
        
    }else if ([budget isEqualToString:@"20万元以上"]){
    
        targetID = [NSNumber numberWithInt:6];
    }
    
    return targetID;

}

+ (NSNumber *) getServeFormulateTimeIDFrom:(NSString *) time{

    NSNumber *targetID;
    
    if ([time isEqualToString:@"5天以内"]) {
       
        targetID = [NSNumber numberWithInt:1];
        
    }else if ([time isEqualToString:@"5-10天"]){
    
        targetID = [NSNumber numberWithInt:2];
    
    }else if ([time isEqualToString:@"10-15天"]){
    
        targetID = [NSNumber numberWithInt:3];
    
    }else if ([time isEqualToString:@"15-20天"]){
    
        targetID = [NSNumber numberWithInt:4];
    
    }else if ([time isEqualToString:@"一个月"]){
    
        targetID = [NSNumber numberWithInt:5];
    
    }else if ([time isEqualToString:@"两个月"]){
    
        targetID = [NSNumber numberWithInt:6];
    }
    
    return targetID;

}

@end
