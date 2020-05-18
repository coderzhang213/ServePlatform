//
//  CMLSBUserPushServeTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/14.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLUserPorjectObj.h"
#import "CMLServeObj.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CMLSBUserPushServeTVCellDelegate <NSObject>

@optional

- (void)deleteServelCellWithIndexPath:(NSIndexPath *)indexPath;

- (void)editServelCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CMLSBUserPushServeTVCell : UITableViewCell

- (void) refrshCurrentTVCellOf:(CMLUserPorjectObj *) obj;

- (void) refrshShoppingTVCellOf:(CMLServeObj *) obj;

@property (nonatomic,assign) CGFloat cellHeight;

- (void) hiddienAddress;

@property (nonatomic,assign) CGFloat noAddressHeight;

- (CGFloat) getCurrentHeigth;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) NSIndexPath *cellIndexPath;

@property (nonatomic, weak) id <CMLSBUserPushServeTVCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
