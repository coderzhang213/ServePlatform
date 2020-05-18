//
//  LMWordViewOfGoodsController.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/7.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLBaseVC.h"
#import "BaseResultObj.h"

@protocol PushProjectOfGoodsDelegate <NSObject>

- (void) refreshVC;

@end

@interface LMWordViewOfGoodsController : CMLBaseVC

@property (nonatomic,weak) id<PushProjectOfGoodsDelegate> delegate;

@property (nonatomic,assign) BOOL isUserVC;

@property (nonatomic,assign) int currentType;

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) NSNumber *objId;

@property (nonatomic, assign) BOOL isEdit;

@end
