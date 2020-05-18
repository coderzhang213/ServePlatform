//
//  ShowImageCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTouchUp)();

typedef void(^DeleteImage)();

@interface ShowImageCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)UIScrollView *imgScrollView;

@property (nonatomic, copy) SingleTouchUp touchUpBlock;
@property (nonatomic, copy) DeleteImage deleteImage;

- (void)showViewInfo:(NSArray *)info indexPath:(NSIndexPath *)indexPath;

@end
