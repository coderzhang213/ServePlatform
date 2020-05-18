//
//  NFPhotoViewCell.m
//  PhotoBrowser
//
//  Created by A_Dirt on 16/5/24.
//  Copyright © 2016年 程印. All rights reserved.
//

//the status bar of the window after removing highly when equipment vertical screen
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
//width of window when equipment vertical screen
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width

#define BtnBottomMargin                 50
#define BtnAndBtnSpace                  80


#import "NFPhotoViewCell.h"
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
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

@interface NFPhotoViewCell ()<NetWorkProtocol>

@end

@implementation NFPhotoViewCell
{
    MJPhotoLoadingView *_photoLoadingView;
    
    UIButton *likeBtn;
    
    BOOL firstShow;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self createView];
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
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

}

- (void)loadNewBtn{
    if (self.hiddenLikeNum) {
        UIButton *downLoad = [[UIButton alloc] init];
        [downLoad setImage:[UIImage imageNamed:DownLoadImg] forState:UIControlStateNormal];
        [downLoad sizeToFit];
        downLoad.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - downLoad.frame.size.width/2.0,
                                    self.frame.size.height - BtnBottomMargin*Proportion - downLoad.frame.size.height,
                                    downLoad.frame.size.width,
                                    downLoad.frame.size.height);
        [downLoad addTarget:self action:@selector(downLoadImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downLoad];
    }else{
        likeBtn = [[UIButton alloc] init];
        [likeBtn setImage:[UIImage imageNamed:DisLikeImg] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:DefaultLikeImg] forState:UIControlStateSelected];
        [likeBtn sizeToFit];
        likeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - likeBtn.frame.size.width - BtnAndBtnSpace*Proportion/2.0,
                                   self.frame.size.height - BtnBottomMargin*Proportion - likeBtn.frame.size.height,
                                   likeBtn.frame.size.width,
                                   likeBtn.frame.size.height);
        [likeBtn addTarget:self action:@selector(likeCurrent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBtn];
        
        UIButton *downLoad = [[UIButton alloc] init];
        [downLoad setImage:[UIImage imageNamed:DownLoadImg] forState:UIControlStateNormal];
        [downLoad sizeToFit];
        downLoad.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 + BtnAndBtnSpace*Proportion/2.0,
                                    self.frame.size.height - BtnBottomMargin*Proportion - downLoad.frame.size.height,
                                    downLoad.frame.size.width,
                                    downLoad.frame.size.height);
        [downLoad addTarget:self action:@selector(downLoadImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downLoad];
    }
    
}
- (void)showViewInfo:(NSArray *)info indexPath:(NSIndexPath *)indexPath
{
    NSString *Url = [info objectAtIndex:indexPath.row];
    
    SDWebImageManager *webImageManager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:Url];
    //先选择本地缓存，没有再下载
    UIImage *headImage;
    [_imageView setImage:headImage];
    if ([webImageManager diskImageExistsForURL:url])
    {
        firstShow = YES;
        headImage = [webImageManager.imageCache imageFromDiskCacheForKey:[webImageManager cacheKeyForURL:url]];
        [_imageView setImage:headImage];
    }
    else
    {
        firstShow= NO;
         [_photoLoadingView showLoading];
         [self addSubview:_photoLoadingView];
        
         __unsafe_unretained MJPhotoLoadingView *loading = _photoLoadingView;
         __unsafe_unretained NFPhotoViewCell *photoView = self;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > kMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

            [photoView photoDidFinishLoadWithImage:image];
        }];
    
    }
   [self adjustFrame];
    
    /*****/
    if ([self.isLike intValue] == 1) {
        likeBtn.selected = YES;
    }else{
        likeBtn.selected = NO;
    }

}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        _imageView.image = image;
        [_photoLoadingView removeFromSuperview];
        [self adjustFrame];

    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例

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
        
        _imageView.center = self.center;
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
//    MHPhotoBrowserController *con = (MHPhotoBrowserController*)self.viewController;
//    if ([con isKindOfClass:[MHPhotoBrowserController class]]) {
//        [con performSelector:@selector(singleTapDetected) withObject:nil afterDelay:0.2];
//    }
    [[VCManger mainVC] dismissCurrentVC];
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


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    else{
        [SVProgressHUD showSuccessWithStatus:@"保存失败！请稍后再试！"];
    }
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

- (void) downLoadImage{

    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        
        //无权限 引导去开启
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else{
        
         UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
  
}

#pragma mark - likeCurrent
- (void) likeCurrent{
    
    likeBtn.selected = !likeBtn.selected;
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:5] forKey:@"objTypeId"];
    if (!likeBtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:5],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }else{
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:5],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }
    
    [NetWorkTask postResquestWithApiName:LikeCurrent paraDic:paraDic delegate:delegate];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0 && obj) {
        NSLog(@"操作成功");
    }else{
        if ([self.isLike intValue] == 1) {
            likeBtn.selected = YES;
        }else{
            likeBtn.selected = NO;
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    if ([self.isLike intValue] == 1) {
        likeBtn.selected = YES;
    }else{
        likeBtn.selected = NO;
    }

}
@end
