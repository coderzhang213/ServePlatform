//
//  CMLCityMesHeaderView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/10/11.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseResultObj.h"

@protocol CMLCityMesHeaderViewDelegate <NSObject>


- (void) selectIndex:(int)index andSecondIndex:(int) secondIndex andSecondTypeID:(NSNumber *) typeID;


@end



@interface CMLCityMesHeaderView : UIView


- (instancetype)initWith:(BaseResultObj *) obj andSecondTypeObj:(BaseResultObj *) secondTypeObj;

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,assign) int secondSelectIndex;

@property (nonatomic,weak) id<CMLCityMesHeaderViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refrshCurrentViewWithIndex:(int) index andSecondIndex:(int) secondIndex;

@end
