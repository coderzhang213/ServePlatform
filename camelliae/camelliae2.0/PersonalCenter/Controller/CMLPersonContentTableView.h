//
//  CMLPersonContentTableView.h
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/10/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLPersonContentTableView : CMLBaseTableView

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, copy) void (^scrollDragBlock)(void);

@end

NS_ASSUME_NONNULL_END
