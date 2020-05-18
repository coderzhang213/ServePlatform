//
//  CMLTeamInfoModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/17.
//  Copyright © 2019 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMLTeamInfoModel : BaseResultObj

@property (nonatomic, strong) NSNumber *detailID;
/*创建时间*/
@property (nonatomic, copy) NSString *created_at;
/*1-980（试用会员） 2-9800 3-38000（五年）4-38000（原来的分享成员）*/
@property (nonatomic, copy) NSString *distribution_level;

@property (nonatomic, copy) NSString *user_real_name;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *mobile;
/*时间*/
@property (nonatomic, copy) NSString *created_at_str;
/*头像*/
@property (nonatomic, copy) NSString *gravatar;
/*下级人数*/
@property (nonatomic, copy) NSString *count;
/*用户名称*/
@property (nonatomic, copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
