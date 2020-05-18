//
//  NSString+CMLExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+CMLExspand.h"
#import "NSDate+CMLExspand.h"
#import "CMLRSAModule.h"
#import "NetConfig.h"
#import <CoreText/CoreText.h>
#import <UserNotifications/UserNotifications.h>
#import "AppGroup.h"


@implementation NSString (CMLExspand)

- (NSString *)md5WithString:(NSString *)inputString {
    
    const char *cString = [inputString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02X",digest[i]];
    }
    
    return outputString;
    
}

- (NSString *)md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, [NSNumber numberWithInteger:data.length].intValue, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

/**获取字符串font下的CGsize*/
- (CGSize) sizeWithFontCompatible:(UIFont *) font{
    
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES)
    {   
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

/**rsa加密*/
+ (NSString *)getEncryptStringfrom:(NSArray*)objects;{

    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i<objects.count; i++) {
        [string appendFormat:@"%@",objects[i]];
    }
    
    NSString *targetString = [CMLRSAModule encryptString:string publicKey:PUBKEY];
    return targetString;

}

+ (NSString *) getCityNameWithCityID:(NSNumber *) cityID{

    NSString *cityNAme;
    switch ([cityID intValue]) {
        case 1:
            cityNAme = @"北京";
            break;
        case 2:
            cityNAme = @"天津";
            break;
        case 3:
            cityNAme = @"河北";
            break;
        case 4:
            cityNAme = @"山西";
            break;
        case 5:
            cityNAme = @"内蒙古";
            break;
        case 6:
            cityNAme = @"辽宁";
            break;
        case 7:
            cityNAme = @"吉林";
            break;
        case 8:
            cityNAme = @"黑龙江";
            break;
        case 9:
            cityNAme = @"上海";
            break;
        case 10:
            cityNAme = @"江苏";
            break;
        case 11:
            cityNAme = @"浙江";
            break;
        case 12:
            cityNAme = @"安徽";
            break;
        case 13:
            cityNAme = @"福建";
            break;
        case 14:
            cityNAme = @"江西";
            break;
        case 15:
            cityNAme = @"山东";
            break;
        case 16:
            cityNAme = @"河南";
            break;
        case 17:
            cityNAme = @"湖北";
            break;
        case 18:
            cityNAme = @"湖南";
            break;
        case 19:
            cityNAme = @"广东";
            break;
        case 20:
            cityNAme = @"广西";
            break;
        case 21:
            cityNAme = @"海南";
            break;
        case 22:
            cityNAme = @"重庆";
            break;
            
        case 23:
            cityNAme = @"四川";
            break;
        case 24:
            cityNAme = @"贵州";
            break;
        case 25:
            cityNAme = @"云南";
            break;
        case 26:
            cityNAme = @"西藏";
            break;
        case 27:
            cityNAme = @"陕西";
            break;
        case 28:
            cityNAme = @"甘肃";
            break;
        case 29:
            cityNAme = @"青海";
            break;
        case 30:
            cityNAme = @"宁夏";
            break;
        case 31:
            cityNAme = @"新疆";
            break;
        case 32:
            cityNAme = @"台湾";
            break;
        case 33:
            cityNAme = @"香港";
            break;
        case 34:
            cityNAme = @"澳门";
            break;
            
        default:
            break;
    }

    return cityNAme;
}

+ (NSString *) getDataPathWithKey:(NSString *) key{

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *realPath = [docPath stringByAppendingPathComponent:key];
    
    return realPath;

}

+ (NSString *) getProjectStartTime:(NSNumber *) beginTime{

    NSString *outputStr;
    NSString *currentDate = [NSDate getStringFromDate:[NSDate dateWithTimeIntervalSince1970:[beginTime intValue]]];
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",currentDate];
    NSString *newStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    if ([newStr hasPrefix:@"0"]) {
        
        if ([[newStr substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"0"]) {
            
            outputStr = [newStr stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }else{
            
            outputStr = [newStr substringFromIndex:1];
        }
    }else{
        
        if ([[newStr substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"0"]) {
            
            outputStr = [newStr stringByReplacingOccurrencesOfString:@"0"
                                                          withString:@""
                                                             options:NSCaseInsensitiveSearch
                                                               range:NSMakeRange(2, newStr.length - 2)];
        }else{
            
            outputStr = newStr;
        }
    }
    
    return outputStr;
}

- (BOOL)valiMobile {
    
    
//    NSString *newStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//
////    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
//    NSString *regex = @"^[1]([3-9])[0-9]{9}$";
//
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//
//    BOOL isMatch = [pred evaluateWithObject:newStr];
//
//    if (newStr.length != 11) {
//        return NO;
//    }else {
//        if (!isMatch) {
//            return NO;
//        }else {
//            return YES;
//        }
//    }
    return YES;
//    if (newStr.length != 11)
//    {
//        return NO;
//    }else{
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:newStr];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:newStr];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:newStr];
//        
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}

- (NSUInteger) compareTo: (NSString*) comp {
    NSComparisonResult result = [self compare:comp];
    if (result == NSOrderedSame) {
        return 0;
    }
    return result == NSOrderedAscending ? -1 : 1;
}

- (NSUInteger) compareToIgnoreCase: (NSString*) comp {
    return [[self lowercaseString] compareTo:[comp lowercaseString]];
}

- (bool) contains: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (bool) endsWith: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == [self length] - [substring length];
}

- (bool) startsWith: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == 0;
}

- (NSUInteger) indexOf: (NSString*) substring {
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    return range.location == NSNotFound ? -1 : range.location;
}

- (NSUInteger) indexOf:(NSString *)substring startingFrom: (NSUInteger) index {
    NSString* test = [self substringFromIndex:index];
    return index+[test indexOf:substring];
}

- (NSUInteger) lastIndexOf: (NSString*) substring {
    NSRange range = [self rangeOfString:substring options:NSBackwardsSearch];
    return range.location == NSNotFound ? -1 : range.location;
}

- (NSUInteger) lastIndexOf:(NSString *)substring startingFrom: (NSUInteger) index {
    NSString* test = [self substringFromIndex:index];
    return [test lastIndexOf:substring];
}

- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to {
    NSRange range;
    range.location = from;
    range.length = to - from;
    return [self substringWithRange: range];
}

- (NSString*) trim {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray*) split: (NSString*) token {
    return [self split:token limit:0];
}

- (NSArray*) split: (NSString*) token limit: (NSUInteger) maxResults {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: 8];
    NSString* buffer = self;
    while ([buffer contains:token]) {
        if (maxResults > 0 && [result count] == maxResults - 1) {
            break;
        }
        NSUInteger matchIndex = [buffer indexOf:token];
        NSString* nextPart = [buffer substringFromIndex:0 toIndex:matchIndex];
        buffer = [buffer substringFromIndex:matchIndex + [token length]];
        [result addObject:nextPart];
    }
    if ([buffer length] > 0) {
        [result addObject:buffer];
    }
    
    return result;
}

- (NSString*) replace: (NSString*) target withString: (NSString*) replacement {
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
}

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    return [self sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) fromFont:font1 lineSpace:lineSpace];
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    CGFloat minimumLineHeight = font1.pointSize,maximumLineHeight = minimumLineHeight, linespace = lineSpace;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)font1.fontName,font1.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    //Apply paragraph settings
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(NSString*)kCTFontAttributeName,(__bridge id)style,(NSString*)kCTParagraphStyleAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    //    [self clearEmoji:string start:0 font:font1];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    CFRelease(font);
    CFRelease(style);
    string = nil;
    attributes = nil;
    return result;
}

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width{
    CGSize size = CGSizeMake(width, font.pointSize+10);
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    //Determine default text color
    UIColor* textColor = color;
    //Set line height, font, color and break mode
    CTFontRef font1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    //Apply paragraph settings
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight+10, linespace = 5;
    CTLineBreakMode lineBreakMode = kCTLineBreakByTruncatingTail;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font1,(NSString*)kCTFontAttributeName,
                                textColor.CGColor,kCTForegroundColorAttributeName,
                                style,kCTParagraphStyleAttributeName,
                                nil];
    //Create path to work with a frame with applied margins
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,CGRectMake(p.x, height-p.y-size.height,(size.width),(size.height)));
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attributedStr;
    
    //Draw the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(ctframe,context);
    CGPathRelease(path);
    CFRelease(font1);
    CFRelease(framesetter);
    CFRelease(ctframe);
    [[attributedStr mutableString] setString:@""];
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0, height);
    CGContextScaleCTM(context,1.0,-1.0);
}

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height{
    [self drawInContext:context withPosition:p andFont:font andTextColor:color andHeight:height andWidth:CGFLOAT_MAX];
}

#pragma mark - 是否开启APP推送
/**是否开启推送*/
+ (BOOL)isSwitchAppNotification {
    if (@available(iOS 10.0, *)) {
        __block BOOL result = NO;
        //异步线程中操作是否完成
        __block BOOL inThreadOperationComplete = NO;
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                result = NO;
            }else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                result = NO;
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                result = YES;
            }else {
                result = NO;
            }
            inThreadOperationComplete = YES;
        }];
        
        while (!inThreadOperationComplete) {
            [NSThread sleepForTimeInterval:0];
        }
        return result;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (@available(iOS 8.0, *))
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }else {
            return NO;
        }
        
    }else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        }else {
            return NO;
        }
    }
#pragma clang diagnostic pop
}

+ (NSString *)getLocalAppVersion {
    
    NSString *version = [NSString stringWithFormat:@"%@", [AppGroup appVersion]];
    
    NSString *versionString = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return versionString;
    
}

@end
