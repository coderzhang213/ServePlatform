//
//  UIImage+CMLExspand.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UIImage+CMLExspand.h"

@implementation UIImage (CMLExspand)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


+ (UIImage*)CropImage:(UIImage*)photoimage{
    
    
    CGImageRef imgRef =photoimage.CGImage;
    
    float width = CGImageGetWidth(imgRef);
    float height = CGImageGetHeight(imgRef);
    
    CGImageRef finalImgRef;
    if (width >= height) {
       finalImgRef=CGImageCreateWithImageInRect(imgRef,CGRectMake(width/2.0 - height/2.0,
                                                                  0,
                                                                  height,
                                                                  height));
    }else{
        finalImgRef=CGImageCreateWithImageInRect(imgRef,CGRectMake(0,
                                                                   height/2.0 - width/2.0,
                                                                   width,
                                                                   width));
    }
    
    return [UIImage imageWithCGImage:finalImgRef];
}


+ (UIImage *)scaleToRect:(UIImage *)img {

    size_t CGImageGetWidth(CGImageRef img);
    size_t CGImageGetHeight(CGImageRef img);

    CGImageRef cgRef = img.CGImage;
    float height = CGImageGetHeight(cgRef);
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0,0,height,height));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
    
}

+ (UIImage*) scaleToSizeOfHeight280:(UIImage *) img{

    CGSize size = CGSizeMake(img.size.width, img.size.height/304*280);
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,img.size.height/304*((304 - 280)/2.0), size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;

}

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)getImageFromView:(UIView *)view
{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*二分法压缩图片质量方法*/
- (UIImage *)compressToByte:(NSUInteger)maxLength {
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    
    return resultImage;
    
}

+ (UIImage*)createImageWithColor:(UIColor *)color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
