//
//  CMLBaseCollectionView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLBaseCollectionViewDlegate <NSObject>


- (void) collectionViewStartRequesting;

- (void) collectionViewEndRequesting;

- (void) collectionViewShowSuccessActionMessage:(NSString *) str;

- (void) collectionViewShowFailActionMessage:(NSString *) str;

- (void) collectionViewShowAlterView:(NSString *) text;



@end


@interface CMLBaseCollectionView : UICollectionView

@property (nonatomic,weak) id<CMLBaseCollectionViewDlegate> baseCollectionViewDlegate;

@end
