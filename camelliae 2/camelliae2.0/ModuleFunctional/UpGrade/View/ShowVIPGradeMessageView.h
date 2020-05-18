//
//  ShowVIPGradeMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowVIPGradeMessageDelegate <NSObject>

- (void) cancelBuyState;

- (void) entreBuyState:(int)tag;

@end

@interface ShowVIPGradeMessageView : UIView

- (instancetype)initWithLvl:(int)tag andPrice:(NSNumber *)price andPoints:(NSNumber *)points andBgView:(UIView *)view roleName:(NSString *)roleName;

@property (nonatomic,weak) id<ShowVIPGradeMessageDelegate> delegate;
@end
