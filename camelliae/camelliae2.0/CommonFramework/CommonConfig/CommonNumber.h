//
//  CommonNumber.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#ifndef CommonNumber_h
#define CommonNumber_h

/**比例设置*/
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define WIDTH  [UIScreen mainScreen].bounds.size.width

#define Proportion [UIScreen mainScreen].bounds.size.width/750


#define NavigationBarHeight  44
#define UITabBarHeight       49
#define StatusBarHeight     (HEIGHT == 812.0 ? 44 : 20)
#define SafeAreaBottomHeight (HEIGHT == 812.0 ? 34 : 0)


#endif /* CommonNumber_h */
