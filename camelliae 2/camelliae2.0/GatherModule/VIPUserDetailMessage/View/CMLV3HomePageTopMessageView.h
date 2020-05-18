//
//  CMLV3HomePageTopMessageView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLV3HomePageTopMessageViewDelegate <NSObject>

@optional

- (void) refreshCurrentVC;

- (void) selectCurrentType:(int) index;

- (void) showCardView;

- (void) refreshBtn;

@end

@class BaseResultObj;

@interface CMLV3HomePageTopMessageView : UIView

- (instancetype)initWithObj:(BaseResultObj *) obj;

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,weak) id<CMLV3HomePageTopMessageViewDelegate> delegate;

- (void) refreshCurrentHomePageView;



@end
