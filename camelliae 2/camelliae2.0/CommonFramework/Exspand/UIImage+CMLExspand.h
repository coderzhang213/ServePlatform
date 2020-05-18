//
//  UIImage+CMLExspand.h
//  camelliae1.0
//
//  Created by 张越 on 16/4/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CMLExspand)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage *)scaleToRect:(UIImage *)img;

+ (UIImage *)CropImage:(UIImage*)photoimage;

+ (UIImage *) scaleToSizeOfHeight280:(UIImage *) img;

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

+ (UIImage *)getImageFromView:(UIView *)view;

+ (UIImage *)createImageWithColor:(UIColor *)color;


/*二分法压缩图片质量方法*/
- (UIImage *)compressToByte:(NSUInteger)maxLength;

@end
