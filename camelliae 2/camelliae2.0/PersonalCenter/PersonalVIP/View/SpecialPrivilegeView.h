//
//  SpecialPrivilegeView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/16.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialPrivilegeView : UIView

- (instancetype) initWithDataArray:(NSArray *) dataArray;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,assign) CGFloat currentHeight;
@end
