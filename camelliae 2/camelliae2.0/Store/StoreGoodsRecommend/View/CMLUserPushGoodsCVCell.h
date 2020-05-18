//
//  CMLUserPushGoodsCVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/20.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultObj;


@interface CMLUserPushGoodsCVCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isMoveModule;

- (void) refreshCVCell:(SearchResultObj *) obj;

@end

NS_ASSUME_NONNULL_END
