//
//  CommonSelectView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/2/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonSelectView : UIView

@property (nonatomic,strong) UIImageView *selectImage;

- (void) setContent:(NSString *) title;

@end
