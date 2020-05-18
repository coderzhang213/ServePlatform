//
//  ShowImageCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/8.
//  Copyright © 2016年 张越. All rights reserved.
//

//the status bar of the window after removing highly when equipment vertical screen
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
//width of window when equipment vertical screen
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width

#define BtnBottomMargin                 50
#define BtnAndBtnSpace                  80

#import "ShowImageCell.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "VCManger.h"

@implementation ShowImageCell
{
    
    BOOL firstShow;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self createView];
        
        [self adjustFrame];
        
        // 单击的 Recognizer
        UITapGestureRecognizer *singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
        // 双击的 Recognizer
        UITapGestureRecognizer *doubleRecognizer;
        doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
        doubleRecognizer.numberOfTapsRequired = 2; // 双击
        [self addGestureRecognizer:doubleRecognizer];
        
        // 关键在这一行，如果双击确定偵測失败才會触发单击
        [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
        
    }
    
    return self;
}

- (void)createView
{
    self.imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)];
    self.imgScrollView.delegate = self;
    self.imgScrollView.bounces = NO;
    //设置最大伸缩比例
    self.imgScrollView.maximumZoomScale = 5.0;
    //设置最小伸缩比例
    self.imgScrollView.minimumZoomScale = 1;
    [self addSubview:self.imgScrollView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgScrollView addSubview:_imageView];
    
    UIButton *imageDeleteBtn = [[UIButton alloc] init];
    [imageDeleteBtn setImage:[UIImage imageNamed:ImageDeleteImg] forState:UIControlStateNormal];
    [imageDeleteBtn sizeToFit];
    imageDeleteBtn.frame = CGRectMake((self.frame.size.width - imageDeleteBtn.frame.size.width)/2.0,
                                      self.frame.size.height - imageDeleteBtn.frame.size.height - 40*Proportion,
                                      imageDeleteBtn.frame.size.width,
                                      imageDeleteBtn.frame.size.height);
    [self addSubview:imageDeleteBtn];
    [imageDeleteBtn addTarget:self action:@selector(delegateImage) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showViewInfo:(NSArray *)info indexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [info objectAtIndex:indexPath.row];
    _imageView.image = image;
    [self adjustFrame];
    
    
}


//改变图片frame
#pragma mark 调整frame
- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 2.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        if (boundsHeight - imageFrame.size.height > 20)
        {
            imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0) - 20;
        }
        else
        {
            imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
        }
        
    } else {
        imageFrame.origin.y = 0;
    }
    
    if (firstShow) { // 第一次显示的图片
        firstShow = NO; // 已经显示过了
        
//        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
//        } completion:^(BOOL finished) {
//        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter)){
        self.imageView.frame = frameToCenter;
    }
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer *)tap
{

    _touchUpBlock();
#ifdef DEBUG
    NSLog(@"触发 单击事件了");
#endif
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)tap
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewController];
    [self photoViewZoomWithPoint:[tap locationInView:self.imageView]];
#ifdef DEBUG
    NSLog(@"触发 双击事件了");
#endif
}

- (void)photoViewZoomWithPoint:(CGPoint)touchPoint {
    if (self.imgScrollView.zoomScale != self.imgScrollView.minimumZoomScale) {
        [self.imgScrollView setZoomScale:self.imgScrollView.minimumZoomScale animated:YES];
    }
    else {
        CGFloat newZoomScale = ((self.imgScrollView.maximumZoomScale + self.imgScrollView.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self.imgScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (UIViewController*)viewController
{
    UIResponder *nextResponder = self;
    do{
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

- (void) delegateImage{

    _deleteImage();
}
@end
