//
//  CMLRecommendTableView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

@interface CMLRecommendTableView : CMLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andBrandID:(NSNumber *) brandID andType:(NSNumber *) type;

- (void) stopVideo;
@end
