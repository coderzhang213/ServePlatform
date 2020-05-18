//
//  NetWorkTask.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18 --optimize on 19/1/13.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NetWorkTask.h"
#import "NetConfig.h"
#import "UIImageView+WebCache.h"
#import "NSString+CMLExspand.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@implementation NetWorkTask

/**获得当前网络状态*/
//+ (NSString *) getCurrentNetType{
//
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    NSString *state = [[NSString alloc] init];
//    int netType = 0;
//    for (id view in subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            //获取到状态栏
//            netType = [[view valueForKeyPath:@"dataNetworkType"] intValue];
//            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    break;
//                case 1:
//                    state = @"2G";
//                    break;
//                case 2:
//                    state = @"3G";
//                    break;
//                case 3:
//                    state = @"4G";
//                    break;
//                case 5:
//                    state = @"WIFI";
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    return state;
//    
//    return nil;
//}

+ (BOOL)getRequestWithApiName:(NSString*)apiName
                        param:(NSMutableDictionary*)paramDictionary
                     delegate:(NetWorkDelegate*)netWorkDelegate
{
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",NetWorkApiDomain,apiName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10.0f;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:YES];
    [manager setSecurityPolicy:securityPolicy];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"text/javascript",
                                                        @"text/html",
                                                        @"text/plain",
                                                        nil];
    
    [manager GET:requestString parameters:paramDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestSucceedBack:withApiName:)]) {
            [netWorkDelegate.delegate requestSucceedBack:responseObject withApiName:apiName];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestFailBack:withApiName:)]) {
            [netWorkDelegate.delegate requestFailBack:error withApiName:apiName];
        }
    }];
    
//    [manager GET:requestString parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestSucceedBack:withApiName:)]) {
//            [netWorkDelegate.delegate requestSucceedBack:responseObject withApiName:apiName];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestFailBack:withApiName:)]) {
//            [netWorkDelegate.delegate requestFailBack:error withApiName:apiName];
//        }
//
//    }];

    return YES;
}

+ (BOOL) postResquestWithApiName:(NSString *)apiName
                         paraDic:(NSDictionary *)paraDic
                        delegate:(NetWorkDelegate *)netWorkDelegate{
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",NetWorkApiDomain,apiName];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10.0f;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:YES];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"text/javascript",
                                                        @"text/html",
                                                        @"text/plain",
                                                        nil];
    
    /**发送post请求*/
//    NSString *netType = [self getCurrentNetType];
    /**当有网时才能请求*/
//    if (![netType isEqualToString:@"无网络"]) {
    
    [manager POST:requestString parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestSucceedBack:withApiName:)]) {
            [netWorkDelegate.delegate requestSucceedBack:responseObject withApiName:apiName];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([netWorkDelegate.delegate respondsToSelector:@selector(requestFailBack:withApiName:)]) {
            NSLog(@"===error===%@", error);
            [netWorkDelegate.delegate requestFailBack:error withApiName:apiName];
        }
    }];
//        [manager POST:requestString parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            if ([netWorkDelegate.delegate respondsToSelector:@selector(requestSucceedBack:withApiName:)]) {
//                [netWorkDelegate.delegate requestSucceedBack:responseObject withApiName:apiName];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//            if ([netWorkDelegate.delegate respondsToSelector:@selector(requestFailBack:withApiName:)]) {
//                [netWorkDelegate.delegate requestFailBack:error withApiName:apiName];
//            }
//        }];
//    }else{
//        /**无网络提示*/
//
//    }
    return YES;
}


+ (void)setImageView:(UIImageView *)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    [imageView setImageWithURL:url placeholder:placeholder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
//    [imageView sd_setImageWithURL:url placeholderImage:placeholder];
    
}


+ (void)setGifImageView:(YYAnimatedImageView *)gifImageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    
    [gifImageView setImageWithURL:url placeholder:placeholder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
}

@end
