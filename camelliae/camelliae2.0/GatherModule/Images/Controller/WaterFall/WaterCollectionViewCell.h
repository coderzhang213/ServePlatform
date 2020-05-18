//
//  WaterCollectionViewCell.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/1/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLImagleDetailObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CMLImagleDetailObj *obj;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
