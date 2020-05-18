//
//  CMLPhotoViewController.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/1/28.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLPhotoViewController : CMLBaseVC

@property (nonatomic, copy) NSString *shareImageUrl;

- (instancetype)initWithAlbumId:(NSNumber *) albumId ImageName:(NSString *) imageName;

@end

NS_ASSUME_NONNULL_END
