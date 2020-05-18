//
//  NewActivityHeaderView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseResultObj;

@protocol NewActivityHeaderDelegate <NSObject>

@optional

- (void) collectProgressSuccess:(NSString *) str;

- (void) collectProgressError:(NSString *) str;

- (void) showDetailShareMessage;

- (void) dissCurrentDetailVC;


@end


@interface NewActivityHeaderView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

- (instancetype)initWith:(BaseResultObj *) obj HasCollectBtn:(BOOL) isHas;


@property (nonatomic,weak) id<NewActivityHeaderDelegate> delegate;

- (void) changeDefaultView;

- (void) changeBlackView;


@end
