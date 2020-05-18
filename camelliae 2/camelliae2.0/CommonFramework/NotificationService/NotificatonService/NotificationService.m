//
//  NotificationService.m
//  NotificatonService
//
//  Created by 石乐 on 16/9/14.
//  Copyright © 2016年 石乐. All rights reserved.
//

#import "NotificationService.h"
#import "JPushNotificationExtensionService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request
                   withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@", self.bestAttemptContent.title];
    self.bestAttemptContent.subtitle = [NSString stringWithFormat:@"%@", self.bestAttemptContent.subtitle];
    self.bestAttemptContent.body = [NSString stringWithFormat:@"%@", self.bestAttemptContent.body];
    
    NSDictionary *apsDic = [request.content.userInfo objectForKey:@"aps"];
    NSString *attachUrl = [apsDic objectForKey:@"image"];
    NSLog(@"%@",attachUrl);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:attachUrl];
    
    if (attachUrl && [attachUrl hasSuffix:@"jpg"]) {
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSString *localPath = [NSString stringWithFormat:@"%@/myAttachment.jpg", NSTemporaryDirectory()];
                if ([data writeToFile:localPath atomically:YES]) {
                    
                    UNNotificationAttachment *attchement = [UNNotificationAttachment attachmentWithIdentifier:@"CMLAttachment" URL:[NSURL URLWithString:localPath] options:nil error:nil];
                    if (attchement) {
                        self.bestAttemptContent.attachments = @[attchement];
                    }
                }
            }
            
        }];
        [task resume];
    }else {
        
    }
    /*
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url
                                                        completionHandler:^(NSURL * _Nullable location,
                                                                            NSURLResponse * _Nullable response,
                                                                            NSError * _Nullable error) {
                                                            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                                            NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
                                                            
                                                            // 将临时文件剪切或者复制Caches文件夹
                                                            NSFileManager *mgr = [NSFileManager defaultManager];
                                                            // AtPath : 剪切前的文件路径
                                                            // ToPath : 剪切后的文件路径
                                                            [mgr moveItemAtPath:location.path toPath:file error:nil];
                                                            
                                                            if (file && ![file  isEqualToString: @""])
                                                            {
                                                                UNNotificationAttachment *attch= [UNNotificationAttachment attachmentWithIdentifier:@"photo"
                                                                                                                                                URL:[NSURL URLWithString:[@"file://" stringByAppendingString:file]]
                                                                                                                                            options:nil
                                                                                                                                              error:nil];
                                                                if(attch)
                                                                {
                                                                    self.bestAttemptContent.attachments = @[attch];
                                                                }
                                                            }
                                                            self.contentHandler(self.bestAttemptContent);
                                                        }];
    [downloadTask resume];
    
    self.contentHandler = contentHandler;
    // copy发来的通知，开始做一些处理
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    
    // 重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"来自卡枚连";
    
    // 附件
//    NSDictionary *dict =  self.bestAttemptContent.userInfo;
//    NSDictionary *notiDict = dict[@"aps"];
//    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
//
//    NSString *url = [[NSBundle mainBundle] pathForResource:@"iOS_App_Store_1024" ofType:@"png"];
//    NSError *error = nil;
//    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment1" URL:[NSURL URLWithString:url] options:nil error:&error];
//    if (error) {
//        NSLog(@"attachment error%@", error);
//    }
//    self.bestAttemptContent.attachments = @[attachment];
//    self.bestAttemptContent.launchImageName = @"iOS_App_Store_1024.png";
    
    // 这里添加一些点击事件，可以在收到通知的时候，添加，也可以在拦截通知的这个扩展中添加
    self.bestAttemptContent.categoryIdentifier = @"category1";
    
    if (!imgUrl.length) {
        
        self.contentHandler(self.bestAttemptContent);
        
    }
    
    [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
        
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
        
    }];*/

    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

- (void)apnsDeliverWith:(UNNotificationRequest *)request {
    
    [JPushNotificationExtensionService jpushSetAppkey:@""];
    [JPushNotificationExtensionService jpushReceiveNotificationRequest:request with:^{
        NSLog(@"apns upload success");
        self.contentHandler(self.bestAttemptContent);
    }];
    
}

/*下载判断类型*/
- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    
                    completionHandler(attachment);
                    
                    
                }] resume];
    
    
    
}
- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}


@end

