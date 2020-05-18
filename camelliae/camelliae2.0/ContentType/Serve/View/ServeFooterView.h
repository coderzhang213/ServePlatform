//
//  ServeFooterView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol ServeFooterDelegate <NSObject>

- (void) progressSuccessWith:(NSString *)str;

- (void) progressErrorWith:(NSString *)str;

- (void) showProjectMessage;

- (void) addSBCar;

@end

@interface ServeFooterView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

- (instancetype)initWith:(BaseResultObj *) obj andGoods:(BOOL) isGoods;

@property (nonatomic,weak) id<ServeFooterDelegate>delegate;

@property (nonatomic,strong) NSNumber *currentPackageID;

@property (nonatomic,assign) CGFloat currentHeight;

@end
