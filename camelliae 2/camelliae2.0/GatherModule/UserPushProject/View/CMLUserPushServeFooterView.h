//
//  CMLUserPushServeFooterView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/17.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseResultObj;

@protocol ServeFooterDelegate <NSObject>

- (void) progressSuccessWith:(NSString *)str;

- (void) progressErrorWith:(NSString *)str;

- (void) showProjectMessage;


@end


@interface CMLUserPushServeFooterView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

- (instancetype)initWith:(BaseResultObj *) obj andGoods:(BOOL) isGoods;

@property (nonatomic,weak) id<ServeFooterDelegate>delegate;

@property (nonatomic,strong) NSNumber *currentPackageID;

@property (nonatomic,assign) CGFloat currentHeight;


@end

NS_ASSUME_NONNULL_END
