//
//  NewActivityHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "NewActivityHeaderView.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "CMLLine.h"

@interface NewActivityHeaderView ()<NetWorkProtocol>
 

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isChanged;


@end

@implementation NewActivityHeaderView

- (instancetype)initWith:(BaseResultObj *) obj HasCollectBtn:(BOOL) isHas{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        self.isChanged = NO;
        [self loadViews];
        
        if (isHas) {
            
            self.collectBtn.hidden = NO;
        }else{
            
            self.collectBtn.hidden = YES;
        }
    }
    return self;
}

- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        self.isChanged = NO;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight,
                                                              NavigationBarHeight,
                                                              NavigationBarHeight)];
    [self.backBtn setImage:[UIImage imageNamed:NewDetailMessageBackImg] forState:UIControlStateNormal];
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                               StatusBarHeight,
                                                               NavigationBarHeight,
                                                               NavigationBarHeight)];
    [self.shareBtn setImage:[UIImage imageNamed:NewDetailMessageShareImg] forState:UIControlStateNormal];
    self.shareBtn.backgroundColor = [UIColor clearColor];
    
    [self.shareBtn addTarget:self action:@selector(touchShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight*2,
                                                                 StatusBarHeight,
                                                                 NavigationBarHeight,
                                                                 NavigationBarHeight)];
    [self.collectBtn setImage:[UIImage imageNamed:NewDetailMessageFavImg] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:NewDEtailMessageFavedImg] forState:UIControlStateSelected];
    self.collectBtn.backgroundColor = [UIColor clearColor];
    
    if ([self.obj.retData.isCanShare intValue] == 1) {
        [self addSubview:self.shareBtn];
        [self addSubview:self.collectBtn];
    }
    
    [self.collectBtn addTarget:self action:@selector(changeFavStatus) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.isUserFav intValue] == 1) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }
    
}

- (void) touchBackBtn{
    
    [self.delegate dissCurrentDetailVC];
}

- (void) touchShareBtn{
    
    if (self.obj) {
        
        [self.delegate showDetailShareMessage];
    }
    
}

#pragma mark - changeFavStatus
- (void) changeFavStatus{
    
    if (self.obj) {
        
        self.collectBtn.selected = !self.collectBtn.selected;
        
        [self setCollectRequest];
    }
    
}

- (void) setCollectRequest{
    
    if (self.obj) {
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        [paraDic setObject:reqTime forKey:@"favTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
        if (!self.collectBtn.selected) {
            [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
            NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                                   [NSNumber numberWithInt:2],
                                                                   reqTime,
                                                                   [NSNumber numberWithInt:2],
                                                                   skey]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
        }else{
            [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
            NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                                   [NSNumber numberWithInt:2],
                                                                   reqTime,
                                                                   [NSNumber numberWithInt:1],
                                                                   skey]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
        }
        [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
        self.currentApiName = ActivityFav;
    }
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ActivityFav]){
        /**数据存储地址*/
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if (self.collectBtn.selected) {
            
            if ([obj.retCode intValue] == 0 && obj) {
                NSLog(@"收藏成功");
                [self.delegate collectProgressSuccess:@"收藏成功"];
                self.collectBtn.selected = YES;
                
            }else{
                NSLog(@"收藏失败%@",obj.retMsg);
                [self.delegate collectProgressError:@"收藏失败"];
                self.collectBtn.selected = NO;
            }
            
        }else{
            
            if ([obj.retCode intValue] == 0 && obj) {
                
                [self.delegate collectProgressSuccess:@"取消收藏"];
                self.collectBtn.selected = NO;
                
            }else{
                
                [self.delegate collectProgressError:@"取消失败"];
                self.collectBtn.selected = YES;
            }
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
}


- (void) changeDefaultView{

    if (self.isChanged) {
        
        [self.backBtn setImage:[UIImage imageNamed:NewDetailMessageBackImg] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:NewDetailMessageShareImg] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:NewDetailMessageFavImg] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:NewDEtailMessageFavedImg] forState:UIControlStateSelected];
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowOffset = CGSizeMake(0, 0);
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
        self.isChanged = NO;
    }


- (void) changeBlackView{

    if (!self.isChanged) {
     
        [self.backBtn setImage:[UIImage imageNamed:NewDetailMessageBlackBackImg] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:NewDetailMessageBlackShareImg] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:NewDetailMessageBlackFavImg] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:NewDetailMessageBlackFavedImg] forState:UIControlStateSelected];
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowOffset = CGSizeMake(0, 0);

//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.isChanged = YES;
    }

}



@end
