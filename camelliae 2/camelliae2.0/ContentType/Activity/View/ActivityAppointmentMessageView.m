//
//  ActivityAppointmentMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityAppointmentMessageView.h"
#import "BaseResultObj.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "merchantInfo.h"
#import "CMLUpAndDownOfNumberView.h"


#define ActivityDefaultVCShowMesWidth               660
#define ActivityDefaultVCShowMesTopMargin           60
#define ActivityDefaultVCShowMesLeftMargin          40
#define ActivityDefaultVCShowMesBottomMargin        40
#define ActivityDefaultVCShowMesLineLeftMargin      30
#define ActivityDefaultVCShowMesBtnTopMargin        60
#define ActivityDefaultVCShowMesBtnSpace            80
#define ActivityDefaultVCDianHeightAndWidth         14
#define ActivityDefaultVCAttributeLabelSpace        20


@interface ActivityAppointmentMessageView ()<NetWorkProtocol, CMLUpAndDownOfNumberViewDelegate>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,strong) UITextField *userNameTextField;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic, assign) int number;

@property (nonatomic, assign) CGFloat numberCenter;

@end

@implementation ActivityAppointmentMessageView

- (instancetype)initWith:(BaseResultObj *) obj andType:(NSNumber *) type{

    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        self.type = type;
        self.number = 1;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UIView *appointmentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       ActivityDefaultVCShowMesWidth*Proportion,
                                                                       1000)];
    appointmentView.backgroundColor = [UIColor CMLWhiteColor];
    
    /**name*/
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = KSystemBoldFontSize16;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor CMLBlackColor];
    nameLabel.text = self.obj.retData.title;
    nameLabel.numberOfLines = 0;
    CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemBoldFontSize17}
                                                   context:nil];
    nameLabel.frame =CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                ActivityDefaultVCShowMesTopMargin*Proportion,
                                ActivityDefaultVCShowMesWidth*Proportion - 2*ActivityDefaultVCShowMesLeftMargin*Proportion,
                                nameRect.size.height);
    [appointmentView addSubview:nameLabel];
    
    
    /**attribute*/
    CGFloat currentHegiht = CGRectGetMaxY(nameLabel.frame) + 60*Proportion;
    
    NSString *officalStatus;
    if ([self.obj.retData.merchantInfoStatus intValue] == 1) {
        officalStatus = [NSString stringWithFormat:@"主办方-%@",self.obj.retData.merchantInfo.merchantsName];
    }else{
        officalStatus = [NSString stringWithFormat:@"主办方-%@",self.obj.retData.sponsor];
    }
    
    
    PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[[self.type intValue]]];
    NSString *str;
    if (self.obj.retData.telephoneArr.count == 1) {
        str = [NSString stringWithFormat:@"%@",[self.obj.retData.telephoneArr firstObject]];
    }else{
        
        NSMutableString *targetStr = [NSMutableString string];
        for (int i = 0; i < self.obj.retData.telephoneArr.count; i++) {
            
            [targetStr appendString:[NSString stringWithFormat:@"%@;",self.obj.retData.telephoneArr[i]]];
        }
        
        str = [targetStr substringToIndex:targetStr.length - 1];
    }
    
    NSArray *attributeArray;
    
    NSArray *attributeImgArray;
        
        if ([costObj.totalAmount intValue] == 0) {
            
            attributeArray = @[[NSString stringWithFormat:@"%@：免费", costObj.packageName],
                               self.obj.retData.actDateZone,
                               
                               str,
                               self.obj.retData.memberLevelId,
                               self.obj.retData.simpleAddress,
                               officalStatus];
        }else{
       
            attributeArray = @[[NSString stringWithFormat:@"%@：%@元／人",costObj.packageName,costObj.totalAmount],
                               self.obj.retData.actDateZone,
                               str,
                               self.obj.retData.memberLevelId,
                               self.obj.retData.simpleAddress,
                               officalStatus];
        }
     

        
        attributeImgArray = @[ShowActivityMessageCostImg,
                              DetailMessageTimeImg,
                              DetailMessageTeleImg,
                              DetailMessageLvlImg,
                              DetailMessageAddressImg,
                              DetailMessageSponsorImg];
    

    for (int i = 0; i < attributeArray.count; i++) {
        
        
        UIImageView *attributeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:attributeImgArray[i]]];
        [attributeImg sizeToFit];
        [appointmentView addSubview:attributeImg];
        if (i == 1) {
            
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = KSystemFontSize13;
            timeLabel.textColor = [UIColor CMLBlackColor];
            timeLabel.text = attributeArray[i];
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                         currentHegiht,
                                         timeLabel.frame.size.width,
                                         timeLabel.frame.size.height);
            [appointmentView addSubview:timeLabel];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            timeLabel.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            
            currentHegiht += timeLabel.frame.size.height + 30*Proportion;
        }else if (i == 2){
        
            UILabel *teleLabel = [[UILabel alloc] init];
            teleLabel.font = KSystemFontSize13;
            teleLabel.textColor = [UIColor CMLBlackColor];
            teleLabel.textAlignment = NSTextAlignmentLeft;
            teleLabel.numberOfLines = 0;
            teleLabel.text = attributeArray[i];
            CGRect teleRect =  [teleLabel.text boundingRectWithSize:CGSizeMake(ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2 - attributeImg.frame.size.width - 20*Proportion, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                            context:nil];
            teleLabel.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                         currentHegiht,
                                         ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2 - attributeImg.frame.size.width - 20*Proportion,
                                         teleRect.size.height);
            [appointmentView addSubview:teleLabel];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            teleLabel.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            
            currentHegiht += teleLabel.frame.size.height + 30*Proportion;
        
        }else if (i == 3){
        
            UILabel *memberLvlLab = [[UILabel alloc] init];
            memberLvlLab.font = KSystemFontSize13;
            memberLvlLab.textColor = [UIColor CMLBlackColor];
            
            if ([attributeArray[i] intValue] == 1) {
                
                memberLvlLab.text = @"粉色会员";
                
            }else if ([attributeArray[i] intValue] == 2){
                
                memberLvlLab.text = @"黛色会员";
                
            }else if ([attributeArray[i] intValue] == 3){
                
                memberLvlLab.text = @"金色会员";
            }else{
                
                memberLvlLab.text = @"墨色会员";
            }
            [memberLvlLab sizeToFit];
            memberLvlLab.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            currentHegiht,
                                            memberLvlLab.frame.size.width,
                                            memberLvlLab.frame.size.height);
            [appointmentView addSubview:memberLvlLab];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            memberLvlLab.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            
            currentHegiht += memberLvlLab.frame.size.height + 30*Proportion;
            
        }else if (i == 4){
        
            UILabel *addressLabel = [[UILabel alloc] init];
            addressLabel.font = KSystemFontSize13;
            addressLabel.textColor = [UIColor CMLBlackColor];
            addressLabel.textAlignment = NSTextAlignmentLeft;
            addressLabel.numberOfLines = 0;
            addressLabel.text = attributeArray[i];
            CGRect addressRect =  [addressLabel.text boundingRectWithSize:CGSizeMake(ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2 - attributeImg.frame.size.width - 20*Proportion, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                            context:nil];
            addressLabel.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                         currentHegiht,
                                         ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2 - attributeImg.frame.size.width - 20*Proportion,
                                         addressRect.size.height);
            [appointmentView addSubview:addressLabel];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            addressLabel.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            
            currentHegiht += addressLabel.frame.size.height + 30*Proportion;
            
        }else if (i == 5){
        
            UILabel *sponsorLabel = [[UILabel alloc] init];
            sponsorLabel.font = KSystemFontSize13;
            sponsorLabel.textColor = [UIColor CMLBlackColor];
            sponsorLabel.text = attributeArray[i];
            [sponsorLabel sizeToFit];
            sponsorLabel.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            currentHegiht,
                                            sponsorLabel.frame.size.width,
                                            sponsorLabel.frame.size.height);
            [appointmentView addSubview:sponsorLabel];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            sponsorLabel.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            
            
        }else{
        
        
            UILabel *costLabel = [[UILabel alloc] init];
            costLabel.font = KSystemFontSize13;
            costLabel.textColor = [UIColor CMLBlackColor];
            costLabel.text = attributeArray[i];
            [costLabel sizeToFit];
            costLabel.frame = CGRectMake(attributeImg.frame.size.width + 20*Proportion + ActivityDefaultVCShowMesLeftMargin*Proportion,
                                         currentHegiht,
                                         costLabel.frame.size.width,
                                         costLabel.frame.size.height);
            [appointmentView addSubview:costLabel];
            
            attributeImg.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                            costLabel.frame.origin.y,
                                            attributeImg.frame.size.width,
                                            attributeImg.frame.size.height);
            self.numberCenter = CGRectGetMidY(costLabel.frame);
            currentHegiht += costLabel.frame.size.height + 30*Proportion;
        }
        

        
        if (i == attributeArray.count - 1) {
            
            if (![[DataManager lightData] readUserName] || [[DataManager lightData] readUserName].length == 0) {
                
                CMLLine *bottomView = [[CMLLine alloc] init];
                bottomView.startingPoint = CGPointMake(ActivityDefaultVCShowMesLeftMargin*Proportion,CGRectGetMaxY(attributeImg.frame) + 20*Proportion + 100*Proportion);
                bottomView.lineWidth = 1;
                bottomView.lineLength = ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2;
                bottomView.LineColor = [UIColor CMLPromptGrayColor];
                bottomView.directionOfLine = HorizontalLine;
                [appointmentView addSubview:bottomView];
                
                UILabel *tempPromptLabel = [[UILabel alloc] init];
                tempPromptLabel.font = KSystemFontSize12;
                tempPromptLabel.text = @"姓名";
                tempPromptLabel.textColor = [UIColor CMLUserBlackColor];
                [tempPromptLabel sizeToFit];
                tempPromptLabel.frame = CGRectMake(ActivityDefaultVCShowMesLeftMargin*Proportion,
                                                   CGRectGetMaxY(attributeImg.frame) + 20*Proportion + 100*Proportion - 20*Proportion - tempPromptLabel.frame.size.height,
                                                   tempPromptLabel.frame.size.width,
                                                   tempPromptLabel.frame.size.height);
                [appointmentView addSubview:tempPromptLabel];
                
                self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempPromptLabel.frame) + 20*Proportion,
                                                                                       CGRectGetMaxY(attributeImg.frame) + 20*Proportion + 100*Proportion - (tempPromptLabel.frame.size.height + 20*Proportion*2),
                                                                                       ActivityDefaultVCShowMesWidth*Proportion - ActivityDefaultVCShowMesLeftMargin*Proportion*2 - 20*Proportion - tempPromptLabel.frame.size.width,
                                                                                       tempPromptLabel.frame.size.height + 20*Proportion*2)];
                self.userNameTextField.font = KSystemFontSize12;
                self.userNameTextField.placeholder = @"请输入姓名";
                [appointmentView addSubview:self.userNameTextField];
            }
            
            UIButton *confirmBtn = [[UIButton alloc] init];
            
            if (self.appointmentProm) {
                
                [confirmBtn setTitle:self.appointmentProm forState:UIControlStateNormal];
            }else{
            
                [confirmBtn setTitle:@"确认预订" forState:UIControlStateNormal];
            }
            
            confirmBtn.titleLabel.font = KSystemFontSize14;
            [confirmBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
            confirmBtn.backgroundColor = [UIColor CMLBrownColor];
            
            if (![[DataManager lightData] readUserName] || [[DataManager lightData] readUserName].length == 0 ) {
                
                confirmBtn.frame = CGRectMake(ActivityDefaultVCShowMesWidth*Proportion/2.0 - 210*Proportion/2.0,
                                              CGRectGetMaxY(self.userNameTextField.frame) + ActivityDefaultVCShowMesBtnTopMargin*Proportion,
                                              210*Proportion,
                                              60*Proportion);
            }else{
                
                confirmBtn.frame = CGRectMake(ActivityDefaultVCShowMesWidth*Proportion/2.0 - 210*Proportion/2.0,
                                              CGRectGetMaxY(attributeImg.frame) + ActivityDefaultVCShowMesBtnTopMargin*Proportion,
                                              210*Proportion,
                                              60*Proportion);
            }
            
            confirmBtn.layer.cornerRadius = 8*Proportion;
            [appointmentView addSubview:confirmBtn];
            [confirmBtn addTarget:self action:@selector(confirmAppointment) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (![[DataManager lightData] readUserName] || [[DataManager lightData] readUserName].length == 0) {
                
                appointmentView.frame = CGRectMake(0,
                                                   0,
                                                   ActivityDefaultVCShowMesWidth*Proportion,
                                                   CGRectGetMaxY(confirmBtn.frame) + 60*Proportion);
            }else{
                
                appointmentView.frame = CGRectMake(0,
                                                   0,
                                                   ActivityDefaultVCShowMesWidth*Proportion,
                                                   CGRectGetMaxY(confirmBtn.frame) + 60*Proportion);
            }
            appointmentView.layer.cornerRadius = 8;
            
        }
    }
    [self addSubview: appointmentView];
    self.currentHeight = appointmentView.frame.size.height;
    self.currentWidth = appointmentView.frame.size.width;
    
    /*数量增减*/
    /*免费时只能预定一个席位 // 粉色可以买*/
    if ([costObj.totalAmount intValue] != 0 && [self.obj.retData.memberLevelId intValue] == 1) {
        CMLUpAndDownOfNumberView *upAndDownOfNumberView = [[CMLUpAndDownOfNumberView alloc] initWithFrame:CGRectMake(CGRectGetWidth(appointmentView.frame) - ActivityDefaultVCShowMesLeftMargin*Proportion - 20 * 4,
                                                                                                                     self.numberCenter - 10,
                                                                                                                     20 * 4,
                                                                                                                     20) withObj:self.obj withType:self.type];
        upAndDownOfNumberView.delegate = self;
        [appointmentView addSubview:upAndDownOfNumberView];
    }

}

#pragma mark - confirmAppointment
- (void) confirmAppointment{
    
    
    if ([[DataManager lightData] readUserName] && [[DataManager lightData] readUserName].length > 0) {
        
        self.userInteractionEnabled = NO;
        [self.delegate activityStartAppoint];
        [self setAppointmentRequest];
    }else{
        
        if (self.userNameTextField.text.length > 0 ) {
            
            self.userInteractionEnabled = NO;
            [self.delegate activityStartAppoint];
            [self setperfectUserInfoRequest];
            
        }else{
            
            [self.delegate activityAppointmentError:@"请输入您的姓名"];
        }
    }
    
}

- (void) setperfectUserInfoRequest{
    
    /**在本页面进行信息更新*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:self.userNameTextField.text forKey:@"userRealName"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:UpdateUser paraDic:paraDic delegate:delegate];
    self.currentApiName = UpdateUser;
    
}

- (void) setAppointmentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[[DataManager lightData] readUserName] forKey:@"contactUser"];
    [paraDic setObject:[[DataManager lightData] readPhone] forKey:@"contactPhone"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"parentType"];
    
    int payAmtE2;
    NSNumber *currentID;
    PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[[self.type intValue]]];
    if ([costObj.totalAmount intValue] == 0) {
        [paraDic setObject:costObj.currentID forKey:@"packageId"];
        currentID = costObj.currentID;
        payAmtE2 = 0;
        self.number = 1;
    }else{
        [paraDic setObject:costObj.currentID forKey:@"packageId"];
        currentID = costObj.currentID;
        payAmtE2 = [costObj.totalAmount intValue]*100;
    }
    
    [paraDic setObject:[NSNumber numberWithInt:payAmtE2] forKey:@"payAmtE2"];
    [paraDic setObject:[NSNumber numberWithInt:self.number] forKey:@"activityNum"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                           [NSNumber numberWithInt:1],
                                                           [NSNumber numberWithInt:payAmtE2],
                                                           [[DataManager lightData] readUserName],
                                                           [[DataManager lightData] readPhone],
                                                           reqTime,
                                                           skey,
                                                           currentID,
                                                           [NSNumber numberWithInt:2]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    NSLog(@"CreateAppointmentparaDic%@", paraDic);
    [NetWorkTask postResquestWithApiName:CreateAppointment paraDic:paraDic delegate:delegate];
    self.currentApiName = CreateAppointment;
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    self.userInteractionEnabled = YES;
    if ([self.currentApiName isEqualToString:CreateAppointment]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        [self.delegate activityStopAppoint];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /*obj.retData.payStat 1:等待支付 2:平台确认支付 3:支付平台确认已支付（活动零元返回该字段）4：支付失败*/
            self.orderID = obj.retData.orderId;
            if ([obj.retData.payState intValue] == 3) {
                [self.delegate activityAppointmentSuccess:@"预订成功"];
            }else{
                [self.delegate activityAppointmentSuccess:@"生成订单"];
            }
            
        }else{
            
            [self.delegate activityAppointmentError:obj.retMsg];
            
        }
    }else if ([self.currentApiName isEqualToString:UpdateUser]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [[DataManager lightData] saveUserName:self.userNameTextField.text];
            
        }
        
        [self setAppointmentRequest];
    }

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    self.userInteractionEnabled = YES;
    [self.delegate activityStopAppoint];
    [self.delegate activityAppointmentError:@"网络连接失败"];
}

- (void) resignUserNameFirstResponder{

    [self.userNameTextField resignFirstResponder];
}

#pragma mark CMLUpAndDownOfNumberViewDelegate
- (void)confirmNumber:(int)number {
    
    self.number = number;
    NSLog(@"%ld", (long)self.number);
}

@end
