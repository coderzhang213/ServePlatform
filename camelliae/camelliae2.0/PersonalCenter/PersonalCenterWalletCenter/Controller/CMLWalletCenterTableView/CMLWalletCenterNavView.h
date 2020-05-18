//
//  CMLWalletCenterNavView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/25.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLWalletCenterNavViewDelegate <NSObject>

@optional

- (void) dissCurrentDetailVC;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterNavView : UIView

@property (nonatomic, strong) NSString *titleContent;

@property (nonatomic, weak) id<CMLWalletCenterNavViewDelegate> delegate;

- (void) changeDefaultView;

- (void) changeWhiteView;

@end

NS_ASSUME_NONNULL_END
