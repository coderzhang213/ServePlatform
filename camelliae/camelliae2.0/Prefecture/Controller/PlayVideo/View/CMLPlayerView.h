//
//  CMLPlayerView.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/9/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;

//NS_ASSUME_NONNULL_BEGIN

@interface CMLPlayerView : UIView

@property (nonatomic, strong) AVPlayer *player;

@end

//NS_ASSUME_NONNULL_END
