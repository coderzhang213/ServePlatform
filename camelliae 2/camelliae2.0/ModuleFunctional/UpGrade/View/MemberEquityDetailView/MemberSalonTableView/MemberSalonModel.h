//
//  MemberSalonModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberSalonModel : BaseResultObj

@property (nonatomic,copy) NSString *canJoin;

@property (nonatomic,copy) NSString *actList;

@property (nonatomic,copy) NSString *currentID;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *parent_type;

@property (nonatomic,copy) NSString *objCoverPic;

@property (nonatomic,copy) NSString *isJoin;

@end

NS_ASSUME_NONNULL_END
