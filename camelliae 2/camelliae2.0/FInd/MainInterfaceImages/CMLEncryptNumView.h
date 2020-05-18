//
//  CMLEncryptNumView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/6/19.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLEncryptNumViewDelegate<NSObject>

- (void) confirmEncryptNum;

@end

@interface CMLEncryptNumView : UIView

@property (nonatomic,weak) id<CMLEncryptNumViewDelegate>delegate;

@property (nonatomic,strong) UITextField *inputEncrptNumField;


@end
