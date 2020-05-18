//
//  CMLStoreRecommendView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLStoreRecommendView.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "CMLStoreRecommendServeView.h"
#import "BaseResultObj.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLStoreServeTopScroolView.h"
#import "CMLStoreSpecialServeRecommdView.h"

@interface CMLStoreRecommendView ()<NetWorkProtocol,CMLStoreRecommendServeViewDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) CMLStoreServeTopScroolView *serveTopScroolView;

@property (nonatomic,strong) CMLStoreRecommendServeView *storeRecommendServeView;

@property (nonatomic,strong) CMLStoreRecommendServeView *storeRecommendServeView2;

@property (nonatomic,strong) CMLStoreSpecialServeRecommdView *specialServeRecommdView;


@property (nonatomic,strong) BaseResultObj *bannerScrollObj;

@property (nonatomic,strong) BaseResultObj *specialLeftObj;

@property (nonatomic,strong) BaseResultObj *specialRighrObj;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) NSArray *currentArray;

@property (nonatomic,assign) int  index;



@end

@implementation CMLStoreRecommendView

- (instancetype)initWithAttributeArray:(NSArray *)attributeArray{
    
    self = [super init];
    
    if (self) {
        self.currentArray = attributeArray;
        [self loadData];
    }
    
    return self;
}

- (void) loadData{
    
    [self setStoreModleRequest];
    
}

- (void) loadViews{
    

    self.serveTopScroolView = [[CMLStoreServeTopScroolView alloc] initWith:self.bannerScrollObj];
    self.serveTopScroolView.frame = CGRectMake(0,
                                               20*Proportion,
                                               WIDTH,
                                               self.serveTopScroolView.currentHeight);
    [self addSubview:self.serveTopScroolView];
    
    
    self.specialServeRecommdView = [[CMLStoreSpecialServeRecommdView alloc] initWith:self.specialLeftObj and:self.specialRighrObj];
    self.specialServeRecommdView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.serveTopScroolView.frame),
                                                    WIDTH,
                                                    self.specialServeRecommdView.currentHeight);
    [self addSubview:self.specialServeRecommdView];
    
    self.storeRecommendServeView = [[CMLStoreRecommendServeView alloc] initWithObj:self.obj andName:@"精选服务"];
    self.storeRecommendServeView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.specialServeRecommdView.frame),
                                                    WIDTH,
                                                    self.storeRecommendServeView.currentHeight);
    [self addSubview:self.storeRecommendServeView];
    
    self.storeRecommendServeView2 = [[CMLStoreRecommendServeView alloc] initWithObj:self.obj andName:@"最新上架"];
    self.storeRecommendServeView2.delegate = self;
    self.storeRecommendServeView2.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.storeRecommendServeView.frame),
                                                     WIDTH,
                                                     self.storeRecommendServeView2.currentHeight);
    [self addSubview:self.storeRecommendServeView2];
    
     
    self.currentheight = CGRectGetMaxY(self.storeRecommendServeView2.frame);

    
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
    [NetWorkTask getRequestWithApiName:StoreServeNewRecommed param:paraDic delegate:delegate];
    self.currentApiName = StoreServeNewRecommed;
}

- (void) setScrollBannerRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 0;
}

- (void) setSpecialRightRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:10] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 2;
}

- (void) setSpecialLeftRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:9] forKey:@"bannerAdType"];
    [NetWorkTask getRequestWithApiName:BannerIndex param:paraDic delegate:delegate];
    self.currentApiName = BannerIndex;
    
    self.index = 1;
}



#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:StoreServeNewRecommed]) {
       
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0) {
         
            [self setScrollBannerRequest];
        }
    }else if([self.currentApiName isEqualToString:BannerIndex]){
       
            BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
//            if ([obj.retCode intValue] == 0) {
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
//        }
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
}

- (void) priceVerbWithSign:(int) signTag{
    
    [self.delegate serveVerbSelect:signTag];
}
@end
