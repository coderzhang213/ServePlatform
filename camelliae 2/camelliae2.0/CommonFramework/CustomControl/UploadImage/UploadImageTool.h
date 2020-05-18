//
//  UploadImageTool.h
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import <UIKit/UIKit.h>
@interface UploadImageTool : NSObject



//+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;
//
//// 上传多张图片,按队列依次上传
//+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;

+ (void)uploadImage:(NSData *)data withKey:(NSString *) key token:(NSString *)token  progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray keys:(NSArray *) keyArray Tokens:(NSArray *) tokenArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;
@end
