//
//  CMLMainInterfaceTopView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLMainInterfaceTopViewDelegate<NSObject>

- (void) selectTypeIndex:(int) index;

@end

@interface CMLMainInterfaceTopView : UIView

@property (nonatomic,assign) BOOL isUp;

@property (nonatomic,weak) id<CMLMainInterfaceTopViewDelegate> delegate;

- (void) moveUp;

- (void) moveDown;


@end
