//
//  WaterCollectionViewCell.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/1/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import "WaterCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CMLExspand.h"

@interface WaterCollectionViewCell ()

@end

@implementation WaterCollectionViewCell

- (void)setObj:(CMLImagleDetailObj *)obj {
    
    _obj = obj;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.obj.coverPicThumb] placeholderImage:nil];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
