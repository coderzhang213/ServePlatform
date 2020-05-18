//
//  CMLTopMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendTimeLineObj.h"

@interface CMLTopMessageView : UIView

- (instancetype)initWithObj:(RecommendTimeLineObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@end
