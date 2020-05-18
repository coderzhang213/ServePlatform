//
//  CMLStoreGoodsTopRecommendView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/28.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLStoreGoodsTopRecommendView.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "CMLStoreRecommendGoodsView.h"
#import "BaseResultObj.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLStoreGoodsTopScrollView.h"
#import "CMLStoreSpecialGoodsRecommendView.h"

@interface CMLStoreGoodsTopRecommendView ()<NetWorkProtocol,CMLStoreRecommendGoodsViewDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) CMLStoreGoodsTopScrollView *goodsTopScroolView;

@property (nonatomic,strong) CMLStoreRecommendGoodsView *storeRecommendGoodsView;

@property (nonatomic,strong) CMLStoreRecommendGoodsView *storeRecommendGoodsView2;

@property (nonatomic,strong) CMLStoreSpecialGoodsRecommendView *specialGoodsRecommdView;


@property (nonatomic,strong) BaseResultObj *bannerScrollObj;

@property (nonatomic,strong) BaseResultObj *specialLeftObj;

@property (nonatomic,strong) BaseResultObj *specialRighrObj;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,assign) int  index;



@end
@implementation CMLStoreGoodsTopRecommendView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        [self loadData];
    }
    return self;
}

- (void) loadData{
    [self setStoreModleRequest];
}

- (void)loadViews {
    
    /*刷新时先remove*/
    if (self.goodsTopScroolView) {
        [self.goodsTopScroolView removeFromSuperview];
    }
    if (self.specialGoodsRecommdView) {
        [self.specialGoodsRecommdView removeFromSuperview];
    }
    if (self.storeRecommendGoodsView) {
        [self.storeRecommendGoodsView removeFromSuperview];
    }
    if (self.storeRecommendGoodsView2) {
        [self.storeRecommendGoodsView2 removeFromSuperview];
    }
    
    self.goodsTopScroolView = [[CMLStoreGoodsTopScrollView alloc] initWith:self.bannerScrollObj];
    self.goodsTopScroolView.frame = CGRectMake(0,
                                               10*Proportion,
                                               WIDTH,
                                               self.goodsTopScroolView.currentHeight);
    [self addSubview:self.goodsTopScroolView];
    
    /*单品-推荐-特别推荐*/
    self.specialGoodsRecommdView = [[CMLStoreSpecialGoodsRecommendView alloc] initWith:self.specialLeftObj and:self.specialRighrObj];
    self.specialGoodsRecommdView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.goodsTopScroolView.frame),
                                                    WIDTH,
                                                    self.specialGoodsRecommdView.currentHeight);
    [self addSubview:self.specialGoodsRecommdView];
    
    self.storeRecommendGoodsView = [[CMLStoreRecommendGoodsView alloc] initWithObj:self.obj andName:@"精选单品"];
    self.storeRecommendGoodsView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.specialGoodsRecommdView.frame),
                                                    WIDTH,
                                                    self.storeRecommendGoodsView.currentHeight);
    [self addSubview:self.storeRecommendGoodsView];
    
    self.storeRecommendGoodsView2 = [[CMLStoreRecommendGoodsView alloc] initWithObj:self.obj andName:@"最新上架"];
    self.storeRecommendGoodsView2.delegate = self;
    self.storeRecommendGoodsView2.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.storeRecommendGoodsView.frame),
                                                     WIDTH,
                                                     self.storeRecommendGoodsView2.currentHeight);
    [self addSubview:self.storeRecommendGoodsView2];
    
    self.currentheight = CGRectGetMaxY(self.storeRecommendGoodsView2.frame);
    
}

- (void) setStoreModleRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:StoreGoodsRecommend param:paraDic delegate:delegate];
    self.currentApiName = StoreGoodsRecommend;
}

- (void) setScrollBannerRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:8] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 0;
}

- (void) setSpecialRightRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:12] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 2;
}

- (void) setSpecialLeftRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:11] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 1;
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:StoreGoodsRecommend]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        if ([obj.retCode intValue] == 0) {
            
            [self setScrollBannerRequest];
        }
    }else if([self.currentApiName isEqualToString:BannerIndex]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
//        if ([obj.retCode intValue] == 0) {
            if (self.index == 0) {
                self.bannerScrollObj = obj;
                
                [self setSpecialLeftRequest];
            }else if (self.index == 1){
            
                self.specialLeftObj = obj;
                
                [self setSpecialRightRequest];
            }else if (self.index == 2){
                
                self.specialRighrObj = obj;
    
                [self loadViews];
                [self.delegate refeshCurrentRecommendView];
            }
        }
//    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    [self.delegate netErrorOfStoreGoodsRecommendView];
    
}

- (void) goodsPriceVerbWithSign:(int) signTag{
    
    [self.delegate goodsVerbSelect:signTag];
}

/*collectionView上拉刷新时同步刷新*/
- (void)refreshDataOfPull {
    [self loadData];
}

@end
