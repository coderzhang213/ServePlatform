//
//  CMLMobClick.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/14.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLMobClick.h"

@implementation CMLMobClick

//资讯打点统计
+ (void) informationEventWithType:(NSString *) type{
    
    [MobClick event:@"informationShowFrequency" attributes:@{@"type":type}];
    
}
//活动打点统计
+ (void) activityEventWithType:(NSString *) type memberLvl:(NSNumber *) memberLvl{
    
    [MobClick event:@"ActivityShowFrequency" attributes:@{@"type":type,@"memberLvl":[NSString stringWithFormat:@"%@",memberLvl]}];
    
}

//服务打点统计
+ (void) serveEventWithType:(NSString *)type parentType:(NSString *) parentType{
    
    [MobClick event:@"ServeShowFrequency" attributes:@{@"type":type,@"parentType":parentType}];
    
}

//图集进入次数
+ (void) imageEventWithType:(NSString *) type{
    
    if (type) {
        [MobClick event:@"AtlasShows" attributes:@{@"type":type}];
    }else{
        
        [MobClick event:@"AtlasShows"];
    }
    
}

//点赞
+ (void) likeEventWithRootType:(NSString *) rootType subType:(NSString *) subType{
    
    [MobClick event:@"Praise" attributes:@{@"rootType":rootType,@"subType":subType}];
    
}

//评论
+ (void) commentEventWithRootType:(NSString *)rootType{
    
    [MobClick event:@"Comment" attributes:@{@"rootType":rootType}];
    
}

//收藏
+ (void) collectEventWithRootType:(NSString *)rootType subType:(NSString *) subType{
    
    [MobClick event:@"Collection" attributes:@{@"rootType":rootType,@"subType":subType}];
}

//关注
+ (void) attentionEvent{
    
    [MobClick event:@"Attention"];
}

//个人中心
+ (void) personalDetailInfoEvent{
    
    [MobClick event:@"PersonalDetailInfo"];
}
+ (void) personalHomePageEvent{
    
    [MobClick event:@"PersonalHomePage"];
}
+ (void) personalVIPEvent{
    
    [MobClick event:@"PersonalVIP"];
}

/*我的订单*/
+ (void) personalOrderEvent{
    
    [MobClick event:@"PersonalOrder"];
    
}

/*我的预订*/
+ (void) peraonalAppointmentEvent{
    
    [MobClick event:@"PersonalAppointment"];
    
}

/*我的收藏*/
+ (void) personalCollectionEvent{
    
    [MobClick event:@"PersonalCollection"];
    
}

/*我的卡券*/
+ (void)personalDiscountCoupons {
    
    [MobClick event:@"DiscountCoupons"];

}

+ (void) personalMesEvent{
    
    [MobClick event:@"PersonalMes"];
    
}

+ (void) VIPShowEvent{
    
    [MobClick event:@"VIPShowFrequency"];
    
}


+ (void) formulateEvent{
    
    [MobClick event:@"ServeFormulate"];
    
}
/*************************/
/**预约*/
+ (void) bookingActivityEventwithType:(NSString *)type address:(NSString *)address memberLvl:(NSString *) memberLvl time:(NSString *) time{
    
    [MobClick event:@"ActivityAppointment" attributes:@{@"type":type, @"memberlvl":memberLvl,@"address":address,@"time":time} counter:0];
    
}

/**预订*/
+ (void) serveReservedEventWithType:(NSString *)type subscription:(NSNumber *) subscription parentType:(NSString *) parentType time:(NSString *)time address:(NSString *) address{
    
    [MobClick event:@"ServeReserved" attributes:@{@"type":type, @"parentType":parentType,@"address":address,@"time":time} counter:[subscription intValue]];
    
}

+ (void) activityCalendarEvent{
    
    [MobClick event:@"ActivityCalendar"];
}

+ (void) PrefecturesEnterEvent{
    
    [MobClick event:@"PrefecturesEnterfrequency"];
    
}

+ (void) SubjectEnterFrequency{
    
    [MobClick event:@"SubjectEnterFrequency"];
    
}

+ (void) GoodsMessage{
    [MobClick event:@"GoodsMessage"];
    
}
+ (void) BrandDetailsPage{
    
    [MobClick event:@"BrandDetailsPage"];
    
}

+ (void) PurchaseImmediately{
    
    [MobClick event:@"PurchaseImmediately"];
}

+ (void) AddToCart{
    
    [MobClick event:@"AddToCart"];
}

+ (void) ShoppingCart{
    
    [MobClick event:@"ShoppingCart"];
}

+ (void) Recommending{
    
    [MobClick event:@"Recommending"];
}

+ (void) SeeAllTheRecommendations{
    
    [MobClick event:@"SeeAllTheRecommendations"];
}

+ (void) Share{
    
    [MobClick event:@"Share"];
}

+ (void) ShoppingCartSettlement{
    
    [MobClick event:@"ShoppingCartSettlement"];
}

+ (void) PaymentSuccess{
    
    [MobClick event:@"PaymentSuccess"];
    
}

+ (void) StoreHeadPageRecommend{
 
    [MobClick event:@"RecommendationHome"];
    
}

+ (void) StoreBrandPageRecommend{
    
    [MobClick event:@"BrandRecommendation"];
}
+ (void) Customerservice{
    
    [MobClick event:@"customerservice"];
}

+ (void) MainInterface:(NSNumber *) tag{
    
    [MobClick event:@"Banner" attributes:@{@"tag":[NSString stringWithFormat:@"%@",tag]}];
}

+ (void) Popup{
    
    [MobClick event:@"Popup"];
}

+ (void) Frontpage{
    
    [MobClick event:@"Frontpage"];
}

+ (void) Integraldetailspage{
    
    [MobClick event:@"Integraldetailspage"];
}

+ (void) Exchangebutton{
    
    [MobClick event:@"Exchangebutton"];
}

+ (void) recommendServe{
 
    [MobClick event:@"servicerecommendation"];
    
}

+ (void) recommendGoods{
  
    [MobClick event:@"commodityrecommendation"];
    
}

+ (void) Qulitycommoditysupplement{
    
    [MobClick event:@"qulitycommoditysupplement"];
    
}


@end
