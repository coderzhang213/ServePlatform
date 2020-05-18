//
//  CMLPlayerView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/9/23.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CMLPlayerView

/*使playerView的layer为AVPlayerLayer类型*/
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (void)dealloc {
    self.player = nil;
}

@end
