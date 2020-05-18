//
//  NSString+CMLExspand.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CMLExspand)

- (NSString *)md5;

- (NSString *)md5WithString:(NSString *)inputString;

/**获取字符串font下的CGsize*/
- (CGSize) sizeWithFontCompatible:(UIFont *) font;

/**rsa加密(顺序填写)*/
+ (NSString *)getEncryptStringfrom:(NSArray*)objects;

/**根据id获得城市*/
+ (NSString *) getCityNameWithCityID:(NSNumber *) cityID;

/**数据本地化*/
+ (NSString *) getDataPathWithKey:(NSString *) key;

/**获取活动开始时间*/
+ (NSString *) getProjectStartTime:(NSNumber *) beginTime;

/**正则判断手机号*/
- (BOOL) valiMobile;

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

+ (NSString *)typeForImageData:(NSData *)data;

- (NSUInteger) compareTo: (NSString*) comp;
- (NSUInteger) compareToIgnoreCase: (NSString*) comp;
- (bool) contains: (NSString*) substring;
- (bool) endsWith: (NSString*) substring;
- (bool) startsWith: (NSString*) substring;
- (NSUInteger) indexOf: (NSString*) substring;
- (NSUInteger) indexOf:(NSString *)substring startingFrom: (NSUInteger) index;
- (NSUInteger) lastIndexOf: (NSString*) substring;
- (NSUInteger) lastIndexOf:(NSString *)substring startingFrom: (NSUInteger) index;
- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to;
- (NSString*) trim;
- (NSArray*) split: (NSString*) token;
- (NSString*) replace: (NSString*) target withString: (NSString*) replacement;
- (NSArray*) split: (NSString*) token limit: (NSUInteger) maxResults;

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height;

+ (BOOL)isSwitchAppNotification;

/*获得本地版本号*/
+ (NSString *)getLocalAppVersion;

@end
