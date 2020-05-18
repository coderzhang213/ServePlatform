//
//  CommenClickBottomView.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CommenClickBottomView.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import <UMAnalytics/MobClick.h>
#import "BaseResultObj.h"
#import "NSString+CMLExspand.h"

#define LeftMargin  20
#define TopAndBottomMargin  30
#define TagImageAndTitleSpace  10


@interface CommenClickBottomView ()<NetWorkProtocol>


@property (nonatomic,assign) int numberTag;

@property (nonatomic,strong) UIImageView *classImage;

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIButton *readBtn;

@end

@implementation CommenClickBottomView

- (instancetype)initWithTag:(int) tag{

    self = [super init];
    
    if (self) {
       
        self.backgroundColor = [UIColor whiteColor];
        
        
        switch (tag) {
            case 1:
                self.numberTag = 1;
                break;
            case 2:
                self.numberTag = 2;
                break;
            case 3:
                self.numberTag = 3;
                break;
                
            default:
                break;
        }
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    self.classImage = [[UIImageView alloc] init];
    self.classImage.layer.masksToBounds = YES;
    switch (self.numberTag) {
        case 1:
            self.classImage.image = [UIImage imageNamed:InformationModuleImg];
            break;
        case 2:
            self.classImage.image = [UIImage imageNamed:ActivitySymbolImg];
            break;
        case 3:
            self.classImage.image = [UIImage imageNamed:ServeModuleImg];
            break;
            
        default:
            break;
    }
    [self.classImage sizeToFit];
    self.classImage.frame = CGRectMake(LeftMargin*Proportion,
                                       TopAndBottomMargin*Proportion,
                                       self.classImage.frame.size.width,
                                       self.classImage.frame.size.height);
    [self addSubview:self.classImage];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = KSystemFontSize12;
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.backgroundColor = [UIColor whiteColor];
    self.typeLabel.textColor = [UIColor CMLLineGrayColor];
    [self addSubview:self.typeLabel];
    
    
    self.readBtn = [[UIButton alloc] init];
    self.readBtn.titleLabel.backgroundColor = [UIColor whiteColor];
    self.readBtn.titleLabel.layer.masksToBounds = YES;
    [self.readBtn setImage:[UIImage imageNamed:PersonalCenterUserBrowsedImg] forState:UIControlStateNormal];
    [self.readBtn setTitleColor:[UIColor CMLPromptGrayColor] forState:UIControlStateNormal];
    [self.readBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                      20*Proportion,
                                                      0,
                                                      0)];
    self.readBtn.titleLabel.font = KSystemFontSize12;
    self.readBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.readBtn];

    self.collectBtn = [[UIButton alloc] init];
    self.collectBtn.titleLabel.backgroundColor = [UIColor whiteColor];
    self.collectBtn.titleLabel.layer.masksToBounds = YES;
    [self.collectBtn setImage:[UIImage imageNamed:PersonalCenterUserDisCollectedImg] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:PersonalCenterUserCollectedImg] forState:UIControlStateSelected];
    [self.collectBtn setTitleColor:[UIColor CMLPromptGrayColor] forState:UIControlStateNormal];
    [self.collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                         20*Proportion,
                                                         0,
                                                         0)];
    self.collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.collectBtn.titleLabel.font = KSystemFontSize12;
    [self.collectBtn addTarget:self action:@selector(changeCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.collectBtn];
    
    self.currentHeight = self.classImage.frame.size.height + TopAndBottomMargin*Proportion*2;
    
}

- (void) refreshCommenClickBottomSelectState:(NSNumber *) state{

    if ([state intValue] == 1) {
        
        self.collectBtn.selected = YES;
    }else{
    
        self.collectBtn.selected = NO;
    }
}


- (void) refreshCommenClickBottomView{

    self.typeLabel.text = [NSString stringWithFormat:@"%@ · %@",self.rootTypeName,self.currentTypeName];
    [self.typeLabel sizeToFit];
    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.classImage.frame) + TagImageAndTitleSpace*Proportion,
                                      self.classImage.center.y - self.typeLabel.frame.size.height/2.0,
                                      self.typeLabel.frame.size.width,
                                      self.typeLabel.frame.size.height);
    
    [self.readBtn setTitle:[NSString stringWithFormat:@"%@",self.hitNum] forState:UIControlStateNormal];
    [self.readBtn sizeToFit];
    self.readBtn.frame = CGRectMake(WIDTH - self.readBtn.frame.size.width - 20*Proportion - 20*Proportion,
                                    0,
                                    self.readBtn.frame.size.width + 20*Proportion,
                                    self.currentHeight);
    
    [self.collectBtn setTitle:[NSString stringWithFormat:@"%@",self.collectNum] forState:UIControlStateNormal];
    [self.collectBtn sizeToFit];
    self.collectBtn.frame = CGRectMake(self.readBtn.frame.origin.x - 60*Proportion - self.collectBtn.frame.size.width - 20*Proportion,
                                       0,
                                       self.collectBtn.frame.size.width + 20*Proportion,
                                       self.currentHeight);
    
    if ([self.selectState intValue] == 1) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }

}

#pragma mark - changeCollectBtn
- (void) changeCollectBtn:(UIButton *) button{
    
    self.collectBtn.selected = !self.collectBtn.selected;
    if (self.collectBtn.selected) {
        [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]+1] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]-1] forState:UIControlStateNormal];
    }
    
    [self.collectBtn sizeToFit];
    self.collectBtn.frame = CGRectMake(self.readBtn.frame.origin.x - 60*Proportion - self.collectBtn.frame.size.width - 20*Proportion,
                                       0,
                                       self.collectBtn.frame.size.width + 20*Proportion,
                                       self.currentHeight);
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
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:self.numberTag] forKey:@"objTypeId"];
    if (self.collectBtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:self.numberTag],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        /**打点*/
        [MobClick event:@"Collection" attributes:@{@"rootType":self.rootTypeName,@"subType":self.currentTypeName}];
        
    }else{
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:self.numberTag],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }
    
    [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if (self.collectBtn.selected) {
        
        if ([obj.retCode intValue] == 0 && obj) {
            NSLog(@"收藏成功");
            self.collectBtn.selected = YES;
            
            
        }else{
            NSLog(@"收藏失败%@",obj.retMsg);
            self.collectBtn.selected = NO;
            [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]-1] forState:UIControlStateNormal];
        }
        
    }else{
        
        if ([obj.retCode intValue] == 0 && obj) {
            NSLog(@"取消收藏成功");
            self.collectBtn.selected = NO;
            
        }else{
            NSLog(@"取消收藏失败");
            self.collectBtn.selected = YES;
            [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]+1] forState:UIControlStateNormal];
            
        }
        [self.collectBtn sizeToFit];
        self.collectBtn.frame = CGRectMake(self.readBtn.frame.origin.x - 60*Proportion - self.collectBtn.frame.size.width - 20*Proportion,
                                           0,
                                           self.collectBtn.frame.size.width + 20*Proportion,
                                           self.currentHeight);
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    NSLog(@"失败");
        if (self.collectBtn.selected) {
            
            self.collectBtn.selected = NO;
            [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]-1] forState:UIControlStateNormal];
            
        }else{
            
            self.collectBtn.selected = YES;
            [self.collectBtn setTitle:[NSString stringWithFormat:@"%d",[self.collectBtn.titleLabel.text intValue]+1] forState:UIControlStateNormal];
        }
    [self.collectBtn sizeToFit];
    self.collectBtn.frame = CGRectMake(self.readBtn.frame.origin.x - 60*Proportion - self.collectBtn.frame.size.width - 20*Proportion,
                                       0,
                                       self.collectBtn.frame.size.width + 20*Proportion,
                                       self.currentHeight);
}

@end
