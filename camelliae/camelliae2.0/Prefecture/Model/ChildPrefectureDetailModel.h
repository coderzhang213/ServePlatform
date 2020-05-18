//
//  ChildPrefectureDetailModel.h
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/10/22.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChildPrefectureDetailModel : BaseResultObj

@property (nonatomic, strong) NSNumber *currentID;

@property (nonatomic, copy) NSString *coverPic;

@property (nonatomic, copy) NSString *title;/*标题*/

@property (nonatomic, copy) NSString *shortTitle;/*描述*/

@end

NS_ASSUME_NONNULL_END
