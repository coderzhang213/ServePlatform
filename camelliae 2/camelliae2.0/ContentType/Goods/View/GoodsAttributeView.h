//
//  GoodsAttributeView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/7/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseResultObj;

@protocol GoodsAttributeViewDelegate <NSObject>

@optional

- (void) closeGoodsAttributeView;

- (void) showErrorMessage:(NSString *) str;

- (void) selectPackageID:(NSNumber *) packageID andBuyNum:(int) buyNum;

@end

@interface GoodsAttributeView : UIView

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,weak) id<GoodsAttributeViewDelegate>delegate;

@end
