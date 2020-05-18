//
//  CMLTelePhoneBindView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLTelePhoneBindViewDelegate <NSObject>

@optional

- (void) requestStartLoading;

- (void) requestFinshedLoading;

- (void) showErrorMessageOfBindPhone:(NSString *) str;

- (void) showSuccessMessageOfBindPhone:(NSString *) str;

@end

@interface CMLTelePhoneBindView : UIView

@property (nonatomic,weak) id<CMLTelePhoneBindViewDelegate> delegate;

@end
