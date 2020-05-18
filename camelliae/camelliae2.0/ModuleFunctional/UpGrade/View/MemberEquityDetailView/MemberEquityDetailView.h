//
//  MemberEquityDetailView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberEquityDetailViewDelegate <NSObject>

- (void)cancelMemberEquityDetailView;

- (void)chooseAppointment;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MemberEquityDetailView : UIView

@property (nonatomic, weak) id <MemberEquityDetailViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withLocation:(NSString *)location;

@end

NS_ASSUME_NONNULL_END
