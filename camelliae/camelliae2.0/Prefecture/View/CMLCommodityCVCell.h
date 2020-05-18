//
//  CMLCommodityCVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuctionDetailInfoObj;

@interface CMLCommodityCVCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isMoveModule;

- (void) refreshCVCell:(AuctionDetailInfoObj *) obj;

@end
