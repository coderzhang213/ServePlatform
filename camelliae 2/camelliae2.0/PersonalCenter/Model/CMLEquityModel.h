//
//  CMLEquityModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/2.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLEquityModel : BaseResultObj

@property (nonatomic, strong) NSNumber *currentID;          /*权益id*/

@property (nonatomic, strong) NSNumber *role_id;            /*角色id*/

@property (nonatomic, copy)   NSString *title;              /*标题*/

@property (nonatomic, copy)   NSString *desc;               /*简短描述*/

@property (nonatomic, copy)   NSString *detail;             /*详情*/

@property (nonatomic, copy)   NSString *logo;               /*图片*/

@property (nonatomic, strong) NSNumber *sort;               /*排序*/

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, copy)   NSString *created_at;

@property (nonatomic, copy)   NSString *updated_at;

@end

NS_ASSUME_NONNULL_END
