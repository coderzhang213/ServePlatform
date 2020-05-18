//
//  StoreTopView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreTopViewDelegate<NSObject>

- (void) selectIndex:(int) index;

@end

@interface StoreTopView : UIView

@property (nonatomic,weak) id<StoreTopViewDelegate> delegate;

- (void) refreshSelectIndex:(int) index;

@end
