//
//  CMLChooseCouponsViewController.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLBaseVC.h"
@class CMLMyCouponsModel;
@protocol CMLChooseCouponsViewControllerDelegate <NSObject>

- (void)backChooseCouponsModelOFChooseVC:(CMLMyCouponsModel *_Nullable)chooseCouponsModel withRow:(NSNumber *_Nullable)row withIsSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMLChooseCouponsViewController : CMLBaseVC

@property (nonatomic, strong) BaseResultObj *detailObj;

@property (nonatomic, strong) NSNumber *objId;

@property (nonatomic, strong) NSNumber *goodsId;

@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, weak) id <CMLChooseCouponsViewControllerDelegate> chooseVCDelegate;

@end

NS_ASSUME_NONNULL_END
