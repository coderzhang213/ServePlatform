//
//  CMLAlterAddressMesaageVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "CMLAddressObj.h"

@protocol AlterAddressMessageDeleagte <NSObject>

@optional

- (void) refreshOrderMessageWithUserName:(NSString *) userName
                                userTele:(NSString *) userTele
                             userAddress:(NSString *) userAddress
                            andAddressID:(NSNumber *) addressID;

@end

@interface CMLAlterAddressMesaageVC : CMLBaseVC

@property (nonatomic,weak) id<AlterAddressMessageDeleagte>delegate;

@property (nonatomic,strong) CMLAddressObj *addressObj;

@end
