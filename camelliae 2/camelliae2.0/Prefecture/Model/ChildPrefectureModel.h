//
//  ChildPrefectureModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/10/22.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"
#import "ModuleDetailInfoObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChildPrefectureModel : BaseResultObj

@property (nonatomic, strong) NSNumber *dataCount;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) ModuleDetailInfoObj *dataInfo;

@end

NS_ASSUME_NONNULL_END
