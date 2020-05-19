//
//  NotificationService.m
//  CMLServiceExtension
//
//  Created by 卡枚连 on 2019/6/4.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, assign) int badgeNumber;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString *attachUrl = [request.content.userInfo objectForKey:@"url"];
    NSLog(@"%@",attachUrl);
    NSURL *imageUrl = [NSURL URLWithString:attachUrl];
    
    /*
    [[DataManager lightData] saveBadgeNumber:[NSNumber numberWithInt:self.badgeNumber + 1]];
    [JPUSHService setBadge:self.badgeNumber + 1];
    
    
    self.badgeNumber = self.badgeNumber + 1;
     */
    
    if (imageUrl) {
        [self downloadAndSave:imageUrl handler:^(NSString *locationPath) {
            if (locationPath) {
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"myAttachment" URL:[NSURL fileURLWithPath:locationPath] options:nil error:nil];
                if (attachment) {
                    self.bestAttemptContent.attachments = @[attachment];
                }
            }
            [self apnsDeliverWith:request];
        }];
        
    }else {
        [self apnsDeliverWith:request];
    }
}

- (void)downloadAndSave:(NSURL *)fileURL handler:(void (^)(NSString *))handler {
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:fileURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *localPath = nil;
        NSLog(@"error %@", error);
        if (!error) {
            NSString * localURL = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(),fileURL.lastPathComponent];
            if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:localURL error:nil]) {
                NSLog(@"%@", localURL);
                localPath = localURL;
            }
        }
        handler(localPath);
    }];
    [task resume];
    
}


- (void)apnsDeliverWith:(UNNotificationRequest *)request {
    
    
}

@end
