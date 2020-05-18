//
//  CMLWalletCenterModel.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/12.
//  Copyright © 2019 张越. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLWalletCenterModel : BaseResultObj

/*一级人数*/
@property (nonatomic, copy) NSString *oneCount;
/*二级人数*/
@property (nonatomic, copy) NSString *twoCount;
/*总金额-收益*/
@property (nonatomic, copy) NSString *earnings;
/*用户id*/
@property (nonatomic, copy) NSString *userId;
/*当type != 4时 cost=0的时候则为试用会员*/
@property (nonatomic, copy) NSString *cost;
/*1-9800 2-980 3-8820 4-提现*/
@property (nonatomic, copy) NSString *type;
/*当type = 4的时候 status=1则为提现完成 2-提现中 3-提现失败*/
@property (nonatomic, copy) NSString *status;
/*时间*/
@property (nonatomic, copy) NSString *created_at_str;
/*金额*/
@property (nonatomic, copy) NSString *costStr;
/*用户名称*/
@property (nonatomic, copy) NSString *userName;
/*头像*/
@property (nonatomic, copy) NSString *gravatar;
/*标题*/
@property (nonatomic, copy) NSString *title;
/*粉金人数*/
@property (nonatomic, copy) NSString *pinkGold;
/*粉钻人数*/
@property (nonatomic, copy) NSString *pinkDiamond;
/*普通粉色返利用户（黛色用户专享）*/
@property (nonatomic, copy) NSString *pink;
/*角色ID*/
@property (nonatomic, copy) NSString *roleId;

@end

NS_ASSUME_NONNULL_END
