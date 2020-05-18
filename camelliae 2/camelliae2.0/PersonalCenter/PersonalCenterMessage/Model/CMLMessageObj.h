//
//  CMLMessageObj.h
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/6/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "BaseResultObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLMessageObj : BaseResultObj

@property (nonatomic, strong) NSNumber *currentID;/*对象id*/

@property (nonatomic, copy) NSString *content;/*标题*/

@property (nonatomic, copy) NSString *url;/*图片地址*/

@property (nonatomic, strong) NSNumber *sendId;/*发送者id*/

/*接受者类型 10001-全部 20001-粉色 30001-黛色 40001-金色 50001-墨色*/
@property (nonatomic, strong) NSNumber *recType;

/*跳转对象类型 1-首页 2-活动首页 3-商城页 4-花伴页 5-活动详情页 6-单品详情页 7-服务详情页 8-花伴活动详情 9-花伴单品详情 10-专题详情页 11-资讯详情页 12-H5页面*/
@property (nonatomic, strong) NSNumber *objType;

@property (nonatomic, strong) NSNumber *objId;/*跳转对象id*/

@property (nonatomic, copy) NSString *objUrl;/*跳转H5页面的路径*/

@property (nonatomic, copy) NSString *created_at_str;/*发送时间*/

@property (nonatomic, strong) NSNumber *isRead;/*用户是否已读 1-已读 2-未读*/

@property (nonatomic, strong) NSNumber *status;/*状态 1-正常 2-删除*/

@end

NS_ASSUME_NONNULL_END
