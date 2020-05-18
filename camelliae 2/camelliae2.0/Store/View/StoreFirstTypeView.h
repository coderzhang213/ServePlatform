//
//  StoreFirstTypeView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/5/24.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreFirstTypeViewDelegate <NSObject>

- (void) refreshContentWith:(NSString *) nameID andID:(NSNumber *) typeID;

@end


@interface StoreFirstTypeView : UIView

@property (nonatomic,weak) id<StoreFirstTypeViewDelegate>delegate;

- (instancetype) initWithType:(NSNumber *) typeID;

@property (nonatomic,assign) CGFloat currentheight;

@property (nonatomic,strong) NSNumber *firstSelectIndexID;

//- (void) refreshCurrentViewsWithTag:(int) index;

@end
