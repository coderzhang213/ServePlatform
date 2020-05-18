//
//  UploadImageTool.m
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import "UploadImageTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "QiniuUploadHelper.h"


#define QiNiuBaseUrl @"http://7xozpn.com2.z0.glb.qiniucdn.com/"
@implementation UploadImageTool




////上传单张图片
//+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
//    
//
//        
//        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
//                                                   progressHandler:progress
//                                                            params:nil
//                                                          checkCrc:NO
//                                                cancellationSignal:nil];
//        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
//        
//        [uploadManager putData:data
//                           key:fileName
//                         token:token
//                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                          
//                          if (info.statusCode == 200 && resp) {
//                              NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
//                              if (success) {
//                                  
//                                  success(url);
//                              }
//                          }
//                          else {
//                              if (failure) {
//                                  
//                                  failure();
//                              }
//                          }
//            
//        } option:opt];
//        
//    
//}
//
////上传多张图片
//+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure {
//    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    __block CGFloat totalProgress = 0.0f;
//    __block CGFloat partProgress = 1.0f / [imageArray count];
//    __block NSUInteger currentIndex = 0;
//    
//    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
//    __weak typeof(uploadHelper) weakHelper = uploadHelper;
//    
//    uploadHelper.singleFailureBlock = ^() {
//        failure();
//        return;
//    };
//    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
//        [array addObject:url];
//        totalProgress += partProgress;
//        progress(totalProgress);
//        currentIndex++;
//        if ([array count] == [imageArray count]) {
//            success([array copy]);
//            return;
//        }else {
//            NSLog(@"---%ld",(unsigned long)currentIndex);
//            
//            if (currentIndex<imageArray.count) {
//                
//                 [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
//            }
//           
//        }
//    };
//    
//    [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
//}
//
+ (void)uploadImage:(NSData *)data withKey:(NSString *) key token:(NSString *)token  progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure{

    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                               progressHandler:progress
                                                        params:nil
                                                      checkCrc:NO
                                            cancellationSignal:nil];
    QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    
    [uploadManager putData:data
                       key:key
                     token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (info.statusCode == 200 && resp) {
                          NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
                          if (success) {
                              
                              success(url);
                          }
                      }
                      else {
                          if (failure) {
                              
                              failure();
                          }
                      }
                      
                  } option:opt];
}

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray keys:(NSArray *) keyArray Tokens:(NSArray *) tokenArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }else {
            NSLog(@"---%ld",(unsigned long)currentIndex);
            if (currentIndex<imageArray.count) {
                    [UploadImageTool uploadImage:imageArray[currentIndex] withKey:keyArray[currentIndex] token:tokenArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
        }
    };
    
    [UploadImageTool uploadImage:imageArray[0] withKey:keyArray[0] token:tokenArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];

}


@end
