//
//  CMLUserPushActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/11/13.
//  Copyright © 2018 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLUserPorjectObj.h"
#import "CMLActivityObj.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CMLUserPushActivityTVCellDelegate <NSObject>

@optional

- (void)deleteActivityWithIndexPath:(NSIndexPath *)indexPath;

- (void)editActivityWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CMLUserPushActivityTVCell : UITableViewCell

@property (nonatomic,copy) NSString *userNickName;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *userImageUrl;

@property (nonatomic,copy) NSString *bgImageUrl;

@property (nonatomic,copy) NSString *activityTitle;

@property (nonatomic, assign) BOOL isEdit;

- (void) refrshCurrentTVCellOf:(CMLUserPorjectObj *) obj;

- (void) refrshWorldTVCellOf:(CMLActivityObj *) obj;

- (CGFloat) getCurrentHeigth;

@property (nonatomic, weak) id <CMLUserPushActivityTVCellDelegate> delegate;

@property (nonatomic, assign) NSIndexPath *cellIndexPath;

@end

NS_ASSUME_NONNULL_END
