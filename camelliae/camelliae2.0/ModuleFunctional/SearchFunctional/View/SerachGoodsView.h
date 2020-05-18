//
//  SerachGoodsView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerachGoodsView : UIView

- (instancetype) initWithDataArray:(NSArray *)array dataCount:(int) count andSearchStr:(NSString *) str;

@property (nonatomic,assign) CGFloat currentHeight;

@end
