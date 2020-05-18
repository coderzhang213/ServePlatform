//
//  CMLNewIntegrationVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/15.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewIntegrationVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "IntegrationTopView.h"
#import "IntegrationGoodsListView.h"
#import "CMLMobClick.h"


@interface CMLNewIntegrationVC ()<NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIScrollView *mainScrollview;

@property (nonatomic,strong) IntegrationTopView *topView;

@end

@implementation CMLNewIntegrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    
    [self loadViews];
    
    [self setPointMessageNetworkRequest];
    
    [CMLMobClick Frontpage];
    
}



- (void) refreshCUrrentView{

    [self.mainScrollview removeFromSuperview];
    
    [self loadViews];
    
    [self setPointMessageNetworkRequest];
    
}

- (void) loadViews{

    
    self.mainScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT - SafeAreaBottomHeight)];
    self.mainScrollview.showsVerticalScrollIndicator = NO;
    self.mainScrollview.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.mainScrollview];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshUserPoints" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCUrrentView) name:@"refreshUserPoints" object:nil];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void) setPointMessageNetworkRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:IntegrationPersonalMessage paraDic:paraDic delegate:delegate];
    self.currentApiName = IntegrationPersonalMessage;
    [self startLoading];
    
    
}

- (void) setNetworkRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:IntegrationGoodsList paraDic:paraDic delegate:delegate];
    self.currentApiName = IntegrationGoodsList;
    
    
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:IntegrationGoodsList]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            IntegrationGoodsListView *listView = [[IntegrationGoodsListView alloc] initWith:obj andName:@"超值精美好礼"];
            listView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.topView.frame),
                                        WIDTH,
                                        listView.currentHeight);
            [self.mainScrollview addSubview:listView];
            
            self.mainScrollview.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(listView.frame));
            
        }
    }else if([self.currentApiName isEqualToString:IntegrationPersonalMessage]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
        if ([obj.retCode intValue] == 0) {
            
            self.topView = [[IntegrationTopView alloc] initWith:obj];
            self.topView.frame = CGRectMake(0,
                                            0,
                                            WIDTH,
                                            self.topView.currentHeight);
            [self.mainScrollview addSubview:self.topView];
            
            [self setNetworkRequest];
        }
    }
    
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
}

@end
