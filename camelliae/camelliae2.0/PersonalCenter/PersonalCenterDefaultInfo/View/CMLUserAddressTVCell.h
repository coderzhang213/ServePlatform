//
//  CMLUserAddressTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLAddressObj;

typedef void (^DelegateCurrentAddress)(NSNumber *addressID);

typedef void (^RefreshCurrentAddress)(NSString *userName ,NSString *tele ,NSString *address ,NSNumber *addressID);

typedef void (^SetDefaultAddressStart)(void);/*(void)*/

typedef void (^SetDefaultAddressEnd)(NSString *str);

@interface CMLUserAddressTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat currentCellHeight;

@property (nonatomic,copy) DelegateCurrentAddress delegateCurrentAddress;

@property (nonatomic,copy) RefreshCurrentAddress refreshCurrentAddress;

@property (nonatomic,copy) SetDefaultAddressEnd setDefaultAddressEnd;

@property (nonatomic,copy) SetDefaultAddressStart setDefaultAddressStart;

- (void) refreshCurrentAddressCell:(CMLAddressObj*) obj;

@end
