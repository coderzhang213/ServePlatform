//
//  MemberSalonTableView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

@protocol MemberSalonTableViewDelegate <NSObject>

- (void)refreshFashionSalonEquityWithSalonTable;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MemberSalonTableView : CMLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@property (nonatomic,weak) id<MemberSalonTableViewDelegate> salonDelegate;

@end

NS_ASSUME_NONNULL_END
