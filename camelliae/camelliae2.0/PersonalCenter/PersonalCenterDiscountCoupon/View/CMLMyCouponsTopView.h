//
//  CMLMyCouponsTopView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/16.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CMLMyCouponsTopViewDelegate <NSObject>

- (void)selectOfMyCouponsTypeIndex:(int)index;

@end

@interface CMLMyCouponsTopView : UIView

@property (nonatomic, weak) id <CMLMyCouponsTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
