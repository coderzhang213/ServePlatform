//
//  IntegrationGoodsListView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BaseResultObj;

@interface IntegrationGoodsListView : UIView

- (instancetype)initWith:(BaseResultObj *) obj andName:(NSString *) name;

@property (nonatomic,assign) CGFloat currentHeight;

@end
