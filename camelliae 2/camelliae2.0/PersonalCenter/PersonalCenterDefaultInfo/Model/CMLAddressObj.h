//
//  CMLAddressObj.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLAddressObj : BaseResultObj

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *consignee;

@property (nonatomic,strong) NSNumber *is_default;


@end
