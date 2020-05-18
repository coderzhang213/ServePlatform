//
//  CMLTeamDataModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/19.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLTeamDataModel : BaseResultObj

@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSArray *dataList;

@end

NS_ASSUME_NONNULL_END
