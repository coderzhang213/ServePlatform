//
//  CMLMobClick.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/14.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMAnalytics/MobClick.h>
@interface CMLMobClick : NSObject

//资讯打点统计
+ (void) informationEventWithType:(NSString *) type;
//活动打点统计
+ (void) activityEventWithType:(NSString *) type memberLvl:(NSNumber *) memberLvl;

//服务打点统计
+ (void) serveEventWithType:(NSString *)type parentType:(NSString *) parentType;

//图集进入次数
+ (void) imageEventWithType:(NSString *) type;

//点赞
+ (void) likeEventWithRootType:(NSString *) rootType subType:(NSString *) subType;

//评论
+ (void) commentEventWithRootType:(NSString *)rootType;

//收藏
+ (void) collectEventWithRootType:(NSString *)rootType subType:(NSString *) subType;

//关注
+ (void) attentionEvent;
/**个人中心*/
+ (void) personalDetailInfoEvent;
+ (void) personalHomePageEvent;
+ (void) personalVIPEvent;
+ (void) personalOrderEvent;
+ (void) peraonalAppointmentEvent;
+ (void) personalCollectionEvent;
+ (void) personalMesEvent;
/*我的卡券*/
+ (void)personalDiscountCoupons;

/**会员展示*/
+ (void) VIPShowEvent;

/**订制*/
+ (void) formulateEvent;

/*************************/
/**预约*/
+ (void) bookingActivityEventwithType:(NSString *)type address:(NSString *)address memberLvl:(NSString *) memberLvl time:(NSString *) time;

/**预订*/
+ (void) serveReservedEventWithType:(NSString *)type subscription:(NSNumber *) subscription parentType:(NSString *) parentType time:(NSString *)time address:(NSString *) addrss;

/**活动日历*/
+ (void) activityCalendarEvent;

/**专区详情*/
+ (void) PrefecturesEnterEvent;

/**专题详情*/
+ (void) SubjectEnterFrequency;

/**单品详情*/
+ (void) GoodsMessage;

/**品牌详情页*/
+ (void) BrandDetailsPage;

/**商品立即购买*/
+ (void) PurchaseImmediately;

/**详情页加入购物车*/
+ (void) AddToCart;

/**购物车*/
+ (void) ShoppingCart;

/**发布推荐功能*/
+ (void) Recommending;

/**查看全部推荐*/
+ (void) SeeAllTheRecommendations;

/**分享*/
+ (void) Share;

/**购物车结算按钮*/
+ (void) ShoppingCartSettlement;

/**支付成功*/
+ (void) PaymentSuccess;

/**商城首页推荐*/
+ (void) StoreHeadPageRecommend;

/**商城品牌推荐*/
+ (void) StoreBrandPageRecommend;

/**客服电话*/
+ (void) Customerservice;

/**banner*/
+ (void) MainInterface:(NSNumber *) tag;

/**每日弹框*/
+ (void) Popup;

/**积分首页*/
+ (void) Frontpage;

/**积分详情页*/
+ (void) Integraldetailspage;

/**兑换按钮*/
+ (void) Exchangebutton;

/**相关推荐*/
+ (void) recommendServe;

+ (void) recommendGoods;

+ (void) Qulitycommoditysupplement;
@end
