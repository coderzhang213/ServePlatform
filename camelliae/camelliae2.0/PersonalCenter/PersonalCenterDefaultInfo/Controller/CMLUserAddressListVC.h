//
//  CMLUserAddressListVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol   CMLUserAddressLisDelgate <NSObject>

- (void) refreshUserName:(NSString *) name userTele:(NSString *) tele userAddress:(NSString *) address addressID:(NSNumber *) addressID;

@end

@interface CMLUserAddressListVC : CMLBaseVC

@property (nonatomic,copy) NSString *currentTitle;

@property (nonatomic,weak) id<CMLUserAddressLisDelgate> delegate;

@property (nonatomic,strong) NSNumber *currentAddressID;



@end
