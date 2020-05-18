//
//  CommonFont.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#ifndef CommonFont_h
#define CommonFont_h


//
#define KSystemFontSize5     ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:5 weight: UIFontWeightThin] :[UIFont systemFontOfSize:4.5 weight:UIFontWeightThin]
#define KSystemFontSize8     ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:8 weight: UIFontWeightThin]  :[UIFont systemFontOfSize:7.3 weight: UIFontWeightThin]
#define KSystemFontSize9     ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:9 weight: UIFontWeightThin]  :[UIFont systemFontOfSize:8.2 weight: UIFontWeightThin]
#define KSystemFontSize10    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:10 weight: UIFontWeightThin] :[UIFont systemFontOfSize:9.1 weight: UIFontWeightThin]
#define KSystemFontSize11    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:11 weight: UIFontWeightThin] :[UIFont systemFontOfSize:10.0 weight:UIFontWeightThin]
#define KSystemFontSize12    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:12 weight: UIFontWeightThin] :[UIFont systemFontOfSize:10.9 weight:UIFontWeightThin]
#define KSystemFontSize13    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:13 weight: UIFontWeightThin] :[UIFont systemFontOfSize:11.8 weight:UIFontWeightThin]
#define KSystemFontSize14    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:14 weight: UIFontWeightThin] :[UIFont systemFontOfSize:12.7 weight:UIFontWeightThin]
#define KSystemFontSize15    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:15 weight: UIFontWeightThin] :[UIFont systemFontOfSize:13.6 weight:UIFontWeightThin]
#define KSystemFontSize16    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:16 weight: UIFontWeightThin] :[UIFont systemFontOfSize:14.5 weight:UIFontWeightThin]
#define KSystemFontSize17    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:17 weight: UIFontWeightThin] :[UIFont systemFontOfSize:15.4 weight: UIFontWeightThin]
#define KSystemFontSize20    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:20 weight: UIFontWeightThin] :[UIFont systemFontOfSize:18.1 weight: UIFontWeightThin]
#define KSystemFontSize30    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:30 weight: UIFontWeightThin] :[UIFont systemFontOfSize:27.2 weight:UIFontWeightThin]

#define KSystemBoldFontSize10   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:10 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:9.1 weight:UIFontWeightRegular]
#define KSystemBoldFontSize11    ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:11 weight: UIFontWeightRegular] :[UIFont systemFontOfSize:10.0 weight:UIFontWeightRegular]
#define KSystemBoldFontSize12   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:12 weight: UIFontWeightRegular] :[UIFont systemFontOfSize:10.9 weight:UIFontWeightRegular]
#define KSystemBoldFontSize13   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:13 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:11.8 weight:UIFontWeightRegular]
#define KSystemBoldFontSize14   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:14 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:12.7 weight:UIFontWeightRegular]
#define KSystemBoldFontSize15   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:15 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:13.6 weight:UIFontWeightRegular]
#define KSystemBoldFontSize16   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:16 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:14.5 weight:UIFontWeightRegular]
#define KSystemBoldFontSize17   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:17 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:15.4 weight:UIFontWeightRegular]
#define KSystemBoldFontSize18   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:18 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:16.3 weight:UIFontWeightRegular]
#define KSystemBoldFontSize21   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:21 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:19.0 weight:UIFontWeightRegular]
#define KSystemBoldFontSize30   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:30 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:27.2 weight:UIFontWeightRegular]
#define KSystemBoldFontSize40   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:40 weight:UIFontWeightRegular] :[UIFont systemFontOfSize:36.4 weight:UIFontWeightRegular]

#define KSystemRealBoldFontSize10   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:9.1 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize12   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:12 weight: UIFontWeightSemibold] :[UIFont systemFontOfSize:10.9 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize13   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:11.8 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize14   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:12.7 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize15   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:13.6 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize16   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:14.5 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize17   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:15.4 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize18   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:16.3 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize20   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:18.1 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize21   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:19.0 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize30   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:27.2 weight:UIFontWeightSemibold]
#define KSystemRealBoldFontSize30   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:27.2 weight:UIFontWeightSemibold]

#define KSystemRealMediumFontSize13   ([UIScreen mainScreen].bounds.size.width*2) > 750 ? [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold] :[UIFont systemFontOfSize:11.8 weight:UIFontWeightMedium]

/**specialFont*/
#define KSpecialOneSystemFontSize20       [UIFont fontWithName:@"RTWSYueGoG0v1-Regular" size:20]
#define KSpecialTwoSystemFontSize16       [UIFont fontWithName:@"RTWSYueGoG0v1-Light" size:16]

#endif /* CommonFont_h */
