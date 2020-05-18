//
//  NFPhotoViewCell.h
//  PhotoBrowser
//
//  Created by A_Dirt on 16/5/24.
//  Copyright © 2016年 程印. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MJPhotoLoadingView.h"
#import "SVProgressHUD.h"

@interface NFPhotoViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)UIScrollView *imgScrollView;

@property (nonatomic,strong) NSNumber *isLike;
@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,assign) BOOL hiddenLikeNum;

- (void)loadNewBtn;

- (void)showViewInfo:(NSArray *)info indexPath:(NSIndexPath *)indexPath;
@end
