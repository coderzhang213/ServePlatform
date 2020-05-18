//
//  CMLSBUserPushGoodsTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/14.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLUserPorjectObj.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CMLSBUserPushGoodsTVCellDelegate <NSObject>

@optional

- (void)deleteGoodsTVCellWithIndexPath:(NSIndexPath *)indexPath;

- (void)editGoodsTVCellWithIndexPath:(NSIndexPath *)indexPath;

@end



@interface CMLSBUserPushGoodsTVCell : UITableViewCell

- (void) refrshCurrentTVCellOf:(CMLUserPorjectObj *) obj;


- (CGFloat) getCurrentHeigth;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, weak) id <CMLSBUserPushGoodsTVCellDelegate> delegate;

@property (nonatomic, assign) NSIndexPath *cellIndexPath;

@end

NS_ASSUME_NONNULL_END
