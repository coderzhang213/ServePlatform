//
//  CMLStoreGoodsCollectionView.h
//  camelliae2.0
//
//  Created by 张越 on 2018/5/28.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLBaseCollectionView.h"

@protocol CMLStoreGoodsCollectionViewDelegate <NSObject>

- (void)netErrorOfStoreGoodsCollectionView;

- (void)stopLoadingViewOfRefresh;

- (void)hideNetErrorOfStoreGoodsCollectionView;

@end

@interface CMLStoreGoodsCollectionView : CMLBaseCollectionView

- (void) refreshTableViewWithTypeID:(NSNumber *) typeID;

- (void)pullRefreshOfHeader;

@property (nonatomic, weak) id <CMLStoreGoodsCollectionViewDelegate> storeGoodsCollectionViewDelegate;

@end
