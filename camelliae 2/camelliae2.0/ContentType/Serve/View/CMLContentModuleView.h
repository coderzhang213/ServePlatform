//
//  CMLContentModuleView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/6.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    productDetail,
    brandStory,
    costDetail
    
    
}ContentType;


@class BaseResultObj;

@protocol CMLContentModuleViewDelegate<NSObject>

- (void) finshLoadDetailView:(ContentType) currentType;

@end


@interface CMLContentModuleView : UIView

- (instancetype)initWith:(BaseResultObj *) obj andType:(ContentType) currentType;

@property (nonatomic,weak) id<CMLContentModuleViewDelegate>delegate;

@property (nonatomic,assign) CGFloat currentHeight;

@end
