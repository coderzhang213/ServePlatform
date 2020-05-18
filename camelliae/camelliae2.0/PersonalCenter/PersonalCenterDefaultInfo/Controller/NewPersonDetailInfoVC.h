//
//  NewPersonDetailInfoVC.h
//  camelliae2.0
//
//  Created by 张越 on 2016/11/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "CMLPersonalCenterVC.h"


@protocol NewRefreshPersonalCenterDelegate <NSObject>

- (void) refrshPersonalCenter;

@end

@interface NewPersonDetailInfoVC : CMLBaseVC

@property (nonatomic,strong) id<NewRefreshPersonalCenterDelegate>delegate;


@end
