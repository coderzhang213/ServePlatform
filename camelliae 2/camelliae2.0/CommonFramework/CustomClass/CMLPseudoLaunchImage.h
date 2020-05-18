//
//  CMLPseudoLaunchImage.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLPseudoLaunchImageDelegate <NSObject>

- (void) startApp;

@end

@interface CMLPseudoLaunchImage : UIView

@property (nonatomic,weak) id<CMLPseudoLaunchImageDelegate>delegate;


- (instancetype)initWithImage:(UIImage *)image;

- (void) showLeadView;

- (void) showHypotheticalView;

- (void) imageRemoveFromKeyWindow;

@end
