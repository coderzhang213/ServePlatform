//
//  HomeVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLMainInterfaceVC.h"
#import "CMLPersonalCenterVC.h"
#import "CMLNewActivityVC.h"
#import "CMLNewVipVC.h"
#import "CMLStoreVC.h"

typedef enum {
    
    homeMainInterfaceTag = 0,
    homeActivityTag,
    homeVIPTag,
    homePersoncenterTag,
    homeStoreTag
    
} HomeTag;

@interface HomeVC : UITabBarController

@property (nonatomic,strong) UIView *tabBarView;
@property (nonatomic,assign) BOOL tabBarHidden;

@property (nonatomic,strong) CMLNewVipVC *vipVC;
@property (nonatomic,strong) CMLMainInterfaceVC *mainInterfaceVC;
@property (nonatomic,strong) CMLPersonalCenterVC *personalCenterVC;
@property (nonatomic,strong) CMLNewActivityVC *ActivityVC;
@property (nonatomic,strong) CMLStoreVC *storeVC;

- (void) showCurrentViewController:(HomeTag) tag;

- (void) hiddenTabBarView;

- (void) showTabBarView;

/*检查更新*/
- (void)checkUpdate;

@end
