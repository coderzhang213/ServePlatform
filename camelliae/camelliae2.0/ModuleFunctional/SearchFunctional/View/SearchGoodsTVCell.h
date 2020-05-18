//
//  SearchGoodsTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SearchResultObj;

@interface SearchGoodsTVCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isMoveModule;

- (void) refreshCVCell:(SearchResultObj *) obj;

@end

