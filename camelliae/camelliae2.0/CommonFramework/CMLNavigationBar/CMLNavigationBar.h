//
//  CMLNavigationBar.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLLine.h"
@protocol NavigationBarProtocol <NSObject>

@optional

- (void) didSelectedLeftBarItem;
- (void) didSelectedRightBarItem;
- (void) scrollViewScrollToTop;


@end

@interface CMLNavigationBar : UIView

@property (nonatomic,strong) UIView *bgView;
/**标题内容*/
@property (nonatomic,copy) NSString *titleContent;
/**标题颜色*/
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) CMLLine *bottomLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,weak) id<NavigationBarProtocol>delegate;

- (void) setLeftBarItem;

- (void) setWhiteLeftBarItem;

- (void) setYellowLeftBarItem;

- (void)setCancelBarItem;

- (void)setRightBarItem;

- (void) setShareBarItem;

- (void) setNewShareBarItem;

- (void) setBlackShareBarItem;

- (void) setCertainBarItem;

- (void) setCloseBarItem;

- (void) setBlackCloseBarItem;

- (void) setSettingBarItem;

- (void) setRightBarItemWith:(NSString *) title;

- (void)setCouponRightBarItemWith:(NSString *)title;

- (void)setRightShareBarItem;

- (void) hiddenLine;

@end
