//
//  CMLGoodsOrderTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLOrderListObj;

@interface CMLGoodsOrderTVCell : UITableViewCell

- (void) refreshCurrentCell:(CMLOrderListObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
