//
//  CMLNewVIPTableView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

@protocol NewVIPTableViewDelegate<NSObject>

- (void) tableViewSelctIndex:(int) index;

- (void) showSelectView:(BOOL) isShow;

- (void)tableViewNetError;

@end

@interface CMLNewVIPTableView : CMLBaseTableView

@property (nonatomic,weak) id<NewVIPTableViewDelegate> VIPTableViewDelegate;

- (void) refreshNewVIPTableViewIndex:(int) index;

- (void)loadData;

@end
