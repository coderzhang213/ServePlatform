//
//  LMWordViewController.h
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLBaseVC.h"


@protocol PushProjectDelegate <NSObject>

- (void) refreshVC;

@end

@interface LMWordViewController : CMLBaseVC

@property (nonatomic,weak) id<PushProjectDelegate> delegate;

@property (nonatomic,assign) BOOL isUserVC;

@end
