//
//  CMLImageCVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLImageListObj;

@interface CMLImageCVCell : UICollectionViewCell

@property (nonatomic,assign) int currentTag;

- (void) refreshCurrentCell:(CMLImageListObj*)listObj;
@end
