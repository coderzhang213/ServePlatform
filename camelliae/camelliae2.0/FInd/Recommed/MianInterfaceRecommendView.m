//
//  MianInterfaceRecommendView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/19.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "MianInterfaceRecommendView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"


#import "TopBannerScrollView.h"
#import "WorldFashionView.h"
#import "TopRecommendActivity.h"
#import "TopRecommendServe.h"
#import "TopRecommendTopic.h"
#import "TopRecommendGoods.h"

@interface MianInterfaceRecommendView ()<NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *topBannerScrollViewObj;

@property (nonatomic,strong) BaseResultObj *recommendObj;

@end

@implementation MianInterfaceRecommendView

- (instancetype)init{

    self = [super init];
    
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                2000);
        [self loadData];
    }
    return self;
}

- (void) loadData{

    [self setBanner1Request];
    
}

- (void) loadViews{

    //顶部轮播图
    TopBannerScrollView *topScrollView = [[TopBannerScrollView alloc] initWith:self.topBannerScrollViewObj];
    topScrollView.frame = CGRectMake(0,
                                     20*Proportion,
                                     WIDTH,
                                     topScrollView.currentHeight);
    [self addSubview:topScrollView];
    
    WorldFashionView *worldFashionView = [[WorldFashionView alloc] init];
    worldFashionView.frame = CGRectMake(0,
                                        CGRectGetMaxY(topScrollView.frame),
                                        WIDTH,
                                        worldFashionView.currentHeight);
    [self addSubview:worldFashionView];
    
    //推荐服务
    TopRecommendServe *recommendServe = [[TopRecommendServe alloc] initWith:self.recommendObj];
    recommendServe.frame = CGRectMake(0,
                                      CGRectGetMaxY(worldFashionView.frame),
                                      WIDTH,
                                      recommendServe.currentHeight);
    [self addSubview:recommendServe];
    
    TopRecommendGoods *recommendGoods = [[TopRecommendGoods alloc] initWith:self.recommendObj];
    recommendGoods.frame = CGRectMake(0,
                                         CGRectGetMaxY(recommendServe.frame),
                                         WIDTH,
                                         recommendGoods.currentHeight);
    [self addSubview:recommendGoods];

        
    //推荐专题
    TopRecommendTopic *recommendTopic = [[TopRecommendTopic alloc] initWith:self.recommendObj];
    recommendTopic.frame = CGRectMake(0,
                                      CGRectGetMaxY(recommendGoods.frame),
                                      WIDTH,
                                      recommendTopic.currentHeight);
    [self addSubview:recommendTopic];

    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            CGRectGetMaxY(recommendTopic.frame));
    
    [self.delegate loadViewSuccess];
    [self.delegate progressSuccess];
    
}

#pragma mark - 轮播数据请求
- (void) setBanner1Request{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"bannerTypeId"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:Banner1 param:paraDic delegate:delegate];
    self.currentApiName = Banner1;
}

#pragma mark - 推荐模块
- (void) setRecommModuleRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [NetWorkTask postResquestWithApiName:V3RecommModule paraDic:paraDic delegate:delegate];
    self.currentApiName = V3RecommModule;
    
}

#pragma mark -
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:Banner1]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            if (obj.retData.dataList.count > 0) {
                
                self.topBannerScrollViewObj = obj;
            }
        }else if ([obj.retCode intValue] == 100101){
            
            [self.delegate progressError:nil andCode:100101];
            
        } else{
            
            [self.delegate progressError:obj.retMsg andCode:[obj.retCode intValue]];
        }
        
        /**列表请求*/
        [self setRecommModuleRequest];
        
    }else if ([self.currentApiName isEqualToString:V3RecommModule]){
        
        BaseResultObj *recommenModuleObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([recommenModuleObj.retCode intValue] == 0) {

            self.recommendObj = recommenModuleObj;
            
            [self loadViews];
            
        }else if ([recommenModuleObj.retCode intValue] == 100101){
            
            [self.delegate progressError:nil andCode:100101];
            
        }else{
            
            [self.delegate progressError:recommenModuleObj.retMsg andCode:[recommenModuleObj.retCode intValue]];
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self.delegate progressError:@"网络连接失败" andCode:-1];//3
}
@end
