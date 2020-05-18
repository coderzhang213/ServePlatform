//
//  ServeHeaderView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/3/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol ServeHeaderDelegate <NSObject>

- (void) showDetailShareMessage;

- (void) dissCurrentDetailVC;


@end

@interface ServeHeaderView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,weak) id<ServeHeaderDelegate> delegate;

@property (nonatomic,assign) BOOL isGoods;

@property (nonatomic,strong) UILabel *titleLab;

- (void) changeBtnStyleOfLight;

- (void) changeBtnStyleOfDefault;

@end
