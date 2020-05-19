//
//  ActivityPayTypeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/4/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ActivityPayTypeView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "CMLRSAModule.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"

#define SelectBtnWidth       540
#define SelectBtnHeight      180
#define SelectImageWithAndHeight  140
#define TwoBtnSpace          40

@interface ActivityPayTypeView ()<NetWorkProtocol>

@property (nonatomic,strong) UIView *ZFBType;

@property (nonatomic,strong) UIView *WXType;

@property (nonatomic,strong) UIButton *ZFBBtn;

@property (nonatomic,strong) UIButton *WXBtn;

@property (nonatomic,strong) UIImageView *ZFBImage;

@property (nonatomic,strong) UIImageView *WXImage;

@property (nonatomic,strong) UIButton *cancelBtn;


@property (nonatomic,copy) NSString *currentApiName;

/**支付信息*/

@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *package;

@property (nonatomic,copy) NSString *partnerid;

@property (nonatomic,copy) NSString *prepayid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,assign) int timestamp;

@end

@implementation ActivityPayTypeView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.viewWidth = SelectBtnWidth*Proportion;
        self.viewHeight = SelectBtnHeight*Proportion*2 + TwoBtnSpace*Proportion + 40*Proportion + 60*Proportion;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    self.WXType = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           SelectBtnWidth*Proportion,
                                                           SelectBtnHeight*Proportion)];
    self.WXType.backgroundColor = [UIColor CMLWhiteColor];
    self.WXType.layer.cornerRadius = 8*Proportion;
    self.WXType.userInteractionEnabled = YES;
    [self addSubview:self.WXType];
    
    
    self.WXImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPayTypeWXImg]];
    self.WXImage.frame = CGRectMake(TwoBtnSpace*Proportion,
                                    SelectBtnHeight*Proportion/2.0 - SelectImageWithAndHeight*Proportion/2.0,
                                    SelectImageWithAndHeight*Proportion,
                                    SelectImageWithAndHeight*Proportion);
    self.WXImage.clipsToBounds = YES;
    self.WXImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.WXType addSubview:self.WXImage];
    
    
    UILabel *WXPromLab = [[UILabel alloc] init];
    WXPromLab.text = @"微信支付";
    WXPromLab.font = KSystemBoldFontSize14;
    WXPromLab.textColor = [UIColor CMLBlackColor];
    [WXPromLab sizeToFit];
    WXPromLab.frame = CGRectMake(CGRectGetMaxX(self.WXImage.frame) + 20*Proportion,
                                 SelectBtnHeight*Proportion/2.0 - 20*Proportion/2.0 - WXPromLab.frame.size.height,
                                 WXPromLab.frame.size.width,
                                 WXPromLab.frame.size.height);
    [self.WXType addSubview:WXPromLab];
    
    UILabel *WXPromELab = [[UILabel alloc] init];
    WXPromELab.font = KSystemFontSize12;
    WXPromELab.textColor = [UIColor CMLtextInputGrayColor];
    WXPromELab.text = @"WeChat pay";
    [WXPromELab sizeToFit];
    WXPromELab.frame = CGRectMake(CGRectGetMaxX(self.WXImage.frame) + 20*Proportion,
                                  CGRectGetMaxY(WXPromLab.frame) + 20*Proportion,
                                  WXPromELab.frame.size.width,
                                  WXPromELab.frame.size.height);
    [self.WXType addSubview:WXPromELab];
    
    UIImageView *WXEnterImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:PayTypeEnterImg]];
    WXEnterImage.frame = CGRectMake(SelectBtnWidth*Proportion - 60*Proportion - WXEnterImage.frame.size.width,
                                    SelectBtnHeight*Proportion/2.0 - WXEnterImage.frame.size.height/2.0,
                                    WXEnterImage.frame.size.width,
                                    WXEnterImage.frame.size.height);
    WXEnterImage.clipsToBounds = YES;
    [self.WXType addSubview:WXEnterImage];
    
    self.WXBtn = [[UIButton alloc] initWithFrame:self.WXType.bounds];
    self.WXBtn.backgroundColor = [UIColor clearColor];
    [self.WXType addSubview:self.WXBtn];
    [self.WXBtn addTarget:self action:@selector(startPayProcess) forControlEvents:UIControlEventTouchUpInside];
    
    self.ZFBType = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(self.WXType.frame) + TwoBtnSpace*Proportion,
                                                             SelectBtnWidth*Proportion,
                                                             SelectBtnHeight*Proportion)];
    self.ZFBType.backgroundColor = [UIColor CMLWhiteColor];
    self.ZFBType.layer.cornerRadius = 8*Proportion;
    self.ZFBType.userInteractionEnabled = YES;
    [self addSubview:self.ZFBType];
    
    
    self.ZFBImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPayTypeZFBImg]];
    self.ZFBImage.frame = CGRectMake(TwoBtnSpace*Proportion,
                                     SelectBtnHeight*Proportion/2.0 - SelectImageWithAndHeight*Proportion/2.0,
                                     SelectImageWithAndHeight*Proportion,
                                     SelectImageWithAndHeight*Proportion);
    self.ZFBImage.clipsToBounds = YES;
    self.ZFBImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.ZFBType addSubview:self.ZFBImage];
    
    
    UILabel *ZFBPromLab = [[UILabel alloc] init];
    ZFBPromLab.text = @"支付宝支付";
    ZFBPromLab.font = KSystemBoldFontSize14;
    ZFBPromLab.textColor = [UIColor CMLBlackColor];
    [ZFBPromLab sizeToFit];
    ZFBPromLab.frame = CGRectMake(CGRectGetMaxX(self.ZFBImage.frame) + 20*Proportion,
                                  SelectBtnHeight*Proportion/2.0 - 20*Proportion/2.0 - ZFBPromLab.frame.size.height,
                                  ZFBPromLab.frame.size.width,
                                  ZFBPromLab.frame.size.height);
    [self.ZFBType addSubview:ZFBPromLab];
    
    UILabel *ZFBEPromLab = [[UILabel alloc] init];
    ZFBEPromLab.font = KSystemFontSize12;
    ZFBEPromLab.textColor = [UIColor CMLtextInputGrayColor];
    ZFBEPromLab.text = @"Alipay to pay";
    [ZFBEPromLab sizeToFit];
    ZFBEPromLab.frame = CGRectMake(CGRectGetMaxX(self.ZFBImage.frame) + 20*Proportion,
                                   CGRectGetMaxY(ZFBPromLab.frame) + 20*Proportion,
                                   ZFBEPromLab.frame.size.width,
                                   ZFBEPromLab.frame.size.height);
    [self.ZFBType addSubview:ZFBEPromLab];
    
    self.ZFBBtn = [[UIButton alloc] initWithFrame:self.ZFBType.bounds];
    self.ZFBBtn.backgroundColor = [UIColor clearColor];
    [self.ZFBType addSubview:self.ZFBBtn];
    [self.ZFBBtn addTarget:self action:@selector(startzhifubaoPayProcess) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *ZFBEnterImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:PayTypeEnterImg]];
    ZFBEnterImage.frame = CGRectMake(SelectBtnWidth*Proportion - 60*Proportion - ZFBEnterImage.frame.size.width,
                                    SelectBtnHeight*Proportion/2.0 - ZFBEnterImage.frame.size.height/2.0,
                                    ZFBEnterImage.frame.size.width,
                                    ZFBEnterImage.frame.size.height);
    ZFBEnterImage.clipsToBounds = YES;
    [self.ZFBType addSubview:ZFBEnterImage];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SelectBtnWidth*Proportion/2.0 - 60*Proportion/2.0,
                                                                CGRectGetMaxY(self.ZFBType.frame) + 40*Proportion,
                                                                60*Proportion,
                                                                60*Proportion)];
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:AlterViewCloseBtnImg] forState:UIControlStateNormal];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelCurrentPayProgress) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 进入微信支付流程
- (void) startPayProcess{
    
    
    if ([WXApi isWXAppInstalled]) {
        
        [self.delegate startActivityPayType];
        [self getWeiXinMesRequest];
    }else{
        
        [self.delegate activityPayTypeError:@"没有检测到您的支付软件"];
    }
    
}

#pragma mark - 进入支付宝
- (void) startzhifubaoPayProcess{
    
    
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        
        [self.delegate activityPayTypeError:@"没有检测到您的支付软件"];
        
    }else{
        [self.delegate startActivityPayType];
        [self getZFBMesRequest];
    }
}

#pragma mark -调起支付
- (void) enterWXAPP{
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = self.partnerid;
    req.prepayId            = self.prepayid;
    req.nonceStr            = self.noncestr;
    req.timeStamp           = self.timestamp;
    req.package             = self.package;
    req.sign                = [CMLRSAModule decryptString:self.sign publicKey:PUBKEY];
    
    [WXApi sendReq:req];
    
}


#pragma mark - 获取微信支付信息
- (void) getWeiXinMesRequest{
    if (self.orderId) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.orderId forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.orderId,reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:GetWXMes paraDic:paraDic delegate:delegate];
        self.currentApiName = GetWXMes;
    }
}

#pragma mark - 获取支付宝支付信息
- (void) getZFBMesRequest{
    if (self.orderId) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.orderId forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.orderId,reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:GetZFBMes paraDic:paraDic delegate:delegate];
        self.currentApiName = GetZFBMes;
    }
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GetWXMes]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**微信支付所需信息*/
            self.appid = obj.retData.appid;
            self.noncestr = obj.retData.noncestr;
            self.package = obj.retData.package;
            self.partnerid = obj.retData.partnerid;
            self.prepayid = obj.retData.prepayid;
            self.sign = obj.retData.sign;
            self.timestamp = [obj.retData.timestamp intValue];
            /**************/
            /**进入微信进行支付*/
            [self enterWXAPP];
        }else{
            [self.delegate activityPayTypeError:obj.retMsg];
        }
        
        [self.delegate stopActivityPayType];
        
    }else if ([self.currentApiName isEqualToString:GetZFBMes]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            NSString *sign1 =[CMLRSAModule decryptString:obj.retData.alipaySignToken  publicKey:PUBKEY];
            if ([[obj.retData.alipaySign md5] isEqualToString:sign1]) {
                [[AlipaySDK defaultService] payOrder:obj.retData.alipaySign fromScheme:@"alipaySDKCML" callback:^(NSDictionary *resultDic) {
                    
                }];
            }
        }else{
            
            [self.delegate activityPayTypeError:obj.retMsg];
        }
        
        [self.delegate stopActivityPayType];
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.delegate stopActivityPayType];
    [self.delegate activityPayTypeError:@"网络连接失败"];
    
}

- (void) cancelCurrentPayProgress{
    
    [self.delegate cancelActivityPayProgress];
}
@end
