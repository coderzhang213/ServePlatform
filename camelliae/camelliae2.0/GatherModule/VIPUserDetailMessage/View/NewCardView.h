//
//  NewCardView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewCardViewDelegate <NSObject>

- (void) startNewCardLoading;

- (void) endNewCardLoading;

- (void) saveCurrentNewCardView:(NSString *) msg;

@end

@interface NewCardView : UIView

- (instancetype)init;

@property (nonatomic,strong) NSNumber *memeberLvl;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *userID;

@property (nonatomic,copy) NSString *userImageUrl;

@property (nonatomic,weak) id<NewCardViewDelegate> delegate;

- (void) setCardView;

@end
