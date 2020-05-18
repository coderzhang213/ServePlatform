//
//  CMLInvitationView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/4/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol InvitationViewDelegate <NSObject>

- (void) hiddenCurrentInvitationView;

- (void) saveCurrentInvitationView:(NSString *) str;

- (void) shareCurrentInvitationView:(NSString *)str;

@end

@interface CMLInvitationView : UIView

@property (nonatomic,weak) id<InvitationViewDelegate> delegate;

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *activityTitle;

@property (nonatomic,copy) NSString *timeZone;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *bgImageType;

@property (nonatomic,copy) NSString *QRImageUrl;

@property (nonatomic,strong) UIImageView *QRCurrentImage;

- (void) refershInvitationView;

@end
