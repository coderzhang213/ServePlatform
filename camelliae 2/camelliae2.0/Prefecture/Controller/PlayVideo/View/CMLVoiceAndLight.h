//
//  CMLVoiceAndLight.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/9/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"

@protocol  CMLVoiceAndLightFastForwardDelegate<NSObject>

- (void)fastFront;

- (void)fastBack;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLVoiceAndLight : UIView

@property (nonatomic, strong) UIPanGestureRecognizer *leftPanGestureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer *rightPanGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *centerSwipeGestureRecognizerLeft;

@property (nonatomic, strong) UISwipeGestureRecognizer *centerSwipeGestureRecognizerRight;

@property (nonatomic, strong) MPMusicPlayerController *mpMusicPlayerController;

@property (nonatomic, weak) id <CMLVoiceAndLightFastForwardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
