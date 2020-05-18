//
//  UpGradeVC.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/9.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol UpgGradeDelegate <NSObject>

- (void)refreshCurrentUserMessage;

- (void)showoriginImageView;

@end

@interface UpGradeVC : CMLBaseVC

@property (nonatomic,weak) id<UpgGradeDelegate> delegate;

@property (nonatomic, strong) BaseResultObj *roleObj;

@property (nonatomic, assign) BOOL isUpgrade;

- (void)secondClick:(UIButton *)button;

- (void)requestUserData;

//- (void) showMessage:(UIButton *) button;

///*预订8大类活动后*/
//- (void)showMemberEquityViewButtonClickedDelegateWith:(int)location;

@end
