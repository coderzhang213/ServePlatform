//
//  CMLShoppingCarTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLShoppingCarTVCellDelegate<NSObject>

- (void)changeBrandStatus:(BOOL) isSelect currentBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType;

- (void)addBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType;

- (void)reduceBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType;




@end


@class CMLShoppingCarBrandObj;

@interface CMLShoppingCarTVCell : UITableViewCell

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,assign) BOOL NoSelect;


@property (nonatomic,weak) id<CMLShoppingCarTVCellDelegate>delegate;

- (void)refreshCurrentCellWith:(CMLShoppingCarBrandObj *)obj withBaseObj:(BaseResultObj *)baseObj;


@end
