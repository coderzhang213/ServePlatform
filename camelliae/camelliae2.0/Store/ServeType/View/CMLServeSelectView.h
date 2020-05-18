//
//  CMLServeSelectView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLServeSelectViewDelegate <NSObject>

- (void) selectParentTypeID:(NSNumber *) parentTypeID typeID:(NSNumber *) typeID;

@end

@interface CMLServeSelectView : UIView

@property (nonatomic,weak) id<CMLServeSelectViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,assign) int firstSelectIndex;

@end
