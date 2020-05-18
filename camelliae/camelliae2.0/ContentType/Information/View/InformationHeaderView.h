//
//  InformationHeaderView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShareBlock)();

@class BaseResultObj;

@protocol InformationHeaderDelegate <NSObject>

- (void) informationFavSuccess:(NSString *) str;

- (void) informationFavError:(NSString *) str;

@end

@interface InformationHeaderView : UIView

- (instancetype)initWith:(BaseResultObj *) obj;

@property (nonatomic,copy) ShareBlock shareBlock;

@property (nonatomic,weak) id<InformationHeaderDelegate>delegate;


@end
