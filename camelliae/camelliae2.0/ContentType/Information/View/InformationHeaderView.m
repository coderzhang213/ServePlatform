//
//  InformationHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "InformationHeaderView.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CMLLine.h"
#import "VCManger.h"
#import "BaseResultObj.h"

@interface InformationHeaderView ()<NetWorkProtocol>

@property (nonatomic,strong) UIButton *favBtn;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation InformationHeaderView

- (instancetype)initWith:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
        
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UIView *vcHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    WIDTH,
                                                                    NavigationBarHeight)];
    vcHeaderView.backgroundColor = [UIColor whiteColor];
    vcHeaderView.userInteractionEnabled = YES;
    [self addSubview:vcHeaderView];
    
    /**back*/
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [backBtn setImage:[UIImage imageNamed:DetailMessageBackImg] forState:UIControlStateNormal];
    [vcHeaderView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(dismissCurrentCurrentVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**数据存储地址*/
    
    self.favBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight*2,
                                                             0,
                                                             NavigationBarHeight,
                                                             NavigationBarHeight)];
    [self.favBtn setImage:[UIImage imageNamed:DetailMessageCollectImg] forState:UIControlStateNormal];
    [self.favBtn setImage:[UIImage imageNamed:DetailMessageCollectedImg] forState:UIControlStateSelected];
    
    if ([self.obj.retData.isUserFav intValue] == 1) {
        self.favBtn.selected = YES;
    }else{
        self.favBtn.selected = NO;
    }
    
    [vcHeaderView addSubview:self.favBtn];
    [self.favBtn addTarget:self action:@selector(changeFavStatus) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**share*/
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                    0,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:DetailMessageShareImg] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [vcHeaderView addSubview:shareBtn];
    
    if (!self.obj) {
        self.favBtn.hidden = NO;
        shareBtn.hidden = NO;
    }else {
        self.favBtn.hidden = YES;
        shareBtn.hidden = YES;
    }
    
//    CMLLine *bottomLine = [[CMLLine alloc] init];
//    bottomLine.startingPoint = CGPointMake(0,vcHeaderView.frame.size.height - 0.5);
//    bottomLine.lineWidth = 0.5;
//    bottomLine.LineColor = [UIColor CMLPromptGrayColor];
//    bottomLine.lineLength = WIDTH;
//    [vcHeaderView addSubview:bottomLine];
}

#pragma mark - dismissCurrentVC
- (void) dismissCurrentCurrentVC{
    
    [[VCManger mainVC] dismissCurrentVC];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void) showShareView{

    self.shareBlock();
}

#pragma mark - changeFavStatus
- (void) changeFavStatus{
    self.favBtn.selected = !self.favBtn.selected;
    
    [self setCollectRequest];
}

- (void) setCollectRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"favTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"objTypeId"];
    if (!self.favBtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                               [NSNumber numberWithInt:1],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }else{
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                               [NSNumber numberWithInt:1],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
    }
    
    [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityFav;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    if ([self.currentApiName isEqualToString:ActivityFav]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if (self.favBtn.selected) {
            
            if ([obj.retCode intValue] == 0 && obj) {
                NSLog(@"收藏成功");
                [self.delegate informationFavSuccess:@"收藏成功"];
                self.favBtn.selected = YES;
                
                /**刷新列表*/
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"1%@fav",self.obj.retData.currentID] object:nil];
                
            }else{
                NSLog(@"收藏失败%@",obj.retMsg);
                [self.delegate  informationFavError:@"收藏失败"];
                self.favBtn.selected = NO;
            }
            
        }else{
            
            if ([obj.retCode intValue] == 0 && obj) {
                NSLog(@"取消收藏成功");
                [self.delegate informationFavSuccess:@"取消收藏"];
                self.favBtn.selected = NO;

                /**刷新列表*/
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"1%@disFav",self.obj.retData.currentID] object:nil];
            }else{
                NSLog(@"取消收藏失败");
                [self.delegate informationFavError:@"取消收藏失败"];
                self.favBtn.selected = YES;
            }
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

}

@end
