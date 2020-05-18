//
//  SearchVIPMemberView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVIPMemberView : UIView

- (instancetype) initWithDataArray:(NSArray *)array dataCount:(int) count andSearchStr:(NSString *) str;

@property (nonatomic,assign) CGFloat currentHeight;

@end
