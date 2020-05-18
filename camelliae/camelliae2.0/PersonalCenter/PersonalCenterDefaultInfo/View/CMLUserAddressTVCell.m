//
//  CMLUserAddressTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLUserAddressTVCell.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "CMLAddressObj.h"
#import "CMLAlterAddressMesaageVC.h"
#import "VCManger.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"

#define TopMargin   40
#define LeftMargin  30
#define Space       20


@interface CMLUserAddressTVCell ()<AlterAddressMessageDeleagte,NetWorkProtocol>

@property (nonatomic,strong) UILabel *userNameLab;

@property (nonatomic,strong) UILabel *userContactLab;

@property (nonatomic,strong) UILabel *userDetailAddressLab;

@property (nonatomic,strong) CMLLine *bottomLine;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *userDetailAddressPromLab;

@property (nonatomic,strong) UILabel *showDefaultPromLab;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) UIImageView *selectView;

@property (nonatomic,strong) CMLAddressObj *currentObj;

@property (nonatomic,strong) UIButton *setDefaultBtn;

@end

@implementation CMLUserAddressTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    UILabel *userNamePromLab = [[UILabel alloc] init];
    userNamePromLab.font = KSystemFontSize14;
    userNamePromLab.text = @"收货人：";
    userNamePromLab.textColor = [UIColor CMLBlackColor];
    [userNamePromLab sizeToFit];
    userNamePromLab.frame = CGRectMake(LeftMargin*Proportion,
                                       TopMargin*Proportion,
                                       userNamePromLab.frame.size.width,
                                       userNamePromLab.frame.size.height);
    [self.contentView addSubview:userNamePromLab];
    
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.textAlignment = NSTextAlignmentLeft;
    self.userNameLab.font = KSystemFontSize14;
    self.userNameLab.textColor = [UIColor CMLBlackColor];
    self.userNameLab.frame = CGRectMake(CGRectGetMaxX(userNamePromLab.frame),
                                        userNamePromLab.frame.origin.y,
                                        WIDTH - CGRectGetMaxX(userNamePromLab.frame) - LeftMargin*Proportion,
                                        userNamePromLab.frame.size.height);
    [self.contentView addSubview:self.userNameLab];
    
    UILabel *userContactPromLab = [[UILabel alloc] init];
    userContactPromLab.font = KSystemFontSize14;
    userContactPromLab.text = @"收货电话：";
    userContactPromLab.textColor = [UIColor CMLBlackColor];
    [userContactPromLab sizeToFit];
    userContactPromLab.frame = CGRectMake(LeftMargin*Proportion,
                                         Space*Proportion + CGRectGetMaxY(userNamePromLab.frame),
                                         userContactPromLab.frame.size.width,
                                         userContactPromLab.frame.size.height);
    [self.contentView addSubview:userContactPromLab];
    
    self.userContactLab = [[UILabel alloc] init];
    self.userContactLab.textAlignment = NSTextAlignmentLeft;
    self.userContactLab.font = KSystemFontSize14;
    self.userContactLab.textColor = [UIColor CMLBlackColor];
    self.userContactLab.frame = CGRectMake(CGRectGetMaxX(userContactPromLab.frame),
                                           userContactPromLab.frame.origin.y,
                                           WIDTH - CGRectGetMaxX(userContactPromLab.frame) - LeftMargin*Proportion,
                                           userContactPromLab.frame.size.height);
    [self.contentView addSubview:self.userContactLab];
    
    self.userDetailAddressPromLab = [[UILabel alloc] init];
    self.userDetailAddressPromLab.font = KSystemFontSize14;
    self.userDetailAddressPromLab.text = @"收货地址：";
    self.userDetailAddressPromLab.textColor = [UIColor CMLBlackColor];
    [self.userDetailAddressPromLab sizeToFit];
    self.userDetailAddressPromLab.frame = CGRectMake(LeftMargin*Proportion,
                                                     CGRectGetMaxY(userContactPromLab.frame) + Space*Proportion,
                                                     self.userDetailAddressPromLab.frame.size.width,
                                                     self.userDetailAddressPromLab.frame.size.height);
    [self.contentView addSubview:self.userDetailAddressPromLab];
    
    
    self.userDetailAddressLab = [[UILabel alloc] init];
    self.userDetailAddressLab.textAlignment = NSTextAlignmentLeft;
    self.userDetailAddressLab.font = KSystemFontSize14;
    self.userDetailAddressLab.numberOfLines = 2;
    self.userDetailAddressLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.userDetailAddressLab];
    
    self.bottomLine = [[CMLLine alloc] init];
    self.bottomLine.lineLength = WIDTH - LeftMargin*Proportion*2;
    self.bottomLine.lineWidth = 1*Proportion;
    self.bottomLine.LineColor = [UIColor CMLPromptGrayColor];
    self.bottomLine.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion);
    [self.contentView addSubview:self.bottomLine];
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:AddressDefaultImg]];
    [circleView sizeToFit];
    circleView.frame = CGRectMake(LeftMargin*Proportion,
                                  CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion + 80*Proportion/2.0 - circleView.frame.size.height/2.0,
                                  circleView.frame.size.width,
                                  circleView.frame.size.height);
    [self.contentView addSubview:circleView];
    
    
    self.selectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:AddressSelectedImg]];
    [self.selectView sizeToFit];
    self.selectView.clipsToBounds = YES;
    self.selectView.layer.cornerRadius = self.selectView.frame.size.width/2.0;
    self.selectView.frame = CGRectMake(circleView.center.x - self.selectView.frame.size.width/2.0,
                                       circleView.center.y - self.selectView.frame.size.height/2.0,
                                       self.selectView.frame.size.width,
                                       self.selectView.frame.size.height);
    self.selectView.backgroundColor = [UIColor CMLGreeenColor];
    [self.contentView addSubview:self.selectView];
    
    
    self.showDefaultPromLab = [[UILabel alloc] init];
    self.showDefaultPromLab.text = @"默认地址";
    self.showDefaultPromLab.font = KSystemFontSize11;
    self.showDefaultPromLab.textColor = [UIColor CMLGreeenColor];
    [self.showDefaultPromLab sizeToFit];
    self.showDefaultPromLab.frame = CGRectMake(CGRectGetMaxX(circleView.frame) +  10*Proportion,
                                               CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion + 80*Proportion/2.0 - self.showDefaultPromLab.frame.size.height/2.0,
                                               self.showDefaultPromLab.frame.size.width,
                                               self.showDefaultPromLab.frame.size.height);
    [self.contentView addSubview:self.showDefaultPromLab];
    
    self.setDefaultBtn = [[UIButton alloc] init];
    self.setDefaultBtn.frame = CGRectMake(circleView.frame.origin.x,
                                          CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion + 80*Proportion/2.0 - self.showDefaultPromLab.frame.size.height/2.0,
                                          self.showDefaultPromLab.frame.size.width + self.selectView.frame.size.width + 10*Proportion,
                                          self.showDefaultPromLab.frame.size.height);
    self.setDefaultBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.setDefaultBtn];
    [self.setDefaultBtn addTarget:self action:@selector(alterAddressStatus) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.titleLabel.font = KSystemFontSize11;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [deleteBtn sizeToFit];
    deleteBtn.frame = CGRectMake(WIDTH - LeftMargin*Proportion - deleteBtn.frame.size.width,
                                 CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion,
                                 deleteBtn.frame.size.width,
                                 80*Proportion);
    [self.contentView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteCurrentAddressMessage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *alterBtn = [[UIButton alloc] init];
    alterBtn.titleLabel.font = KSystemFontSize11;
    [alterBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [alterBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    alterBtn.backgroundColor = [UIColor clearColor];
    [alterBtn sizeToFit];
    alterBtn.frame = CGRectMake(WIDTH - LeftMargin*Proportion - alterBtn.frame.size.width - deleteBtn.frame.size.width - 20*Proportion,
                                 CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion,
                                 alterBtn.frame.size.width,
                                 80*Proportion);
    [self.contentView addSubview:alterBtn];
    [alterBtn addTarget:self action:@selector(enterAddressMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.userDetailAddressPromLab.frame) + self.userDetailAddressPromLab.frame.size.height + 13*Proportion + 80*Proportion,
                                       WIDTH,
                                       20*Proportion);
    [self.contentView addSubview:self.bottomView];
    
}

- (void) refreshCurrentAddressCell:(CMLAddressObj *) obj{

    
    self.currentObj = obj;
    
    self.currentID = obj.currentID;
    self.userNameLab.text = obj.consignee;
    self.userContactLab.text = obj.mobile;
    self.userDetailAddressLab.frame = CGRectZero;
    self.userDetailAddressLab.text = obj.address;
    [self.userDetailAddressLab sizeToFit];
    if (self.userDetailAddressLab.frame.size.width > WIDTH - CGRectGetMaxX(self.userDetailAddressPromLab.frame) - LeftMargin) {
        
        self.userDetailAddressLab.frame = CGRectMake(CGRectGetMaxX(self.userDetailAddressPromLab.frame),
                                                     self.userDetailAddressPromLab.frame.origin.y,
                                                     WIDTH - CGRectGetMaxX(self.userDetailAddressPromLab.frame) - LeftMargin,
                                                     self.userDetailAddressPromLab.frame.size.height*2);
    }else{
    
        self.userDetailAddressLab.frame = CGRectMake(CGRectGetMaxX(self.userDetailAddressPromLab.frame),
                                                     self.userDetailAddressPromLab.frame.origin.y,
                                                     WIDTH - CGRectGetMaxX(self.userDetailAddressPromLab.frame) - LeftMargin,
                                                     self.userDetailAddressPromLab.frame.size.height);
    }
    
    if ([obj.is_default intValue] == 1) {
        
        self.selectView.hidden = NO;
        self.setDefaultBtn.userInteractionEnabled = NO;
        
        [[DataManager lightData] saveDeliveryAddress:obj.address];
        [[DataManager lightData] saveDeliveryUser:obj.consignee];
        [[DataManager lightData] saveDeliveryPhone:obj.mobile];
        [[DataManager lightData] saveDeliveryAddressID:obj.currentID];
    }else{
    
        self.selectView.hidden = YES;
        self.setDefaultBtn.userInteractionEnabled = YES;
    }
    
    self.currentCellHeight = CGRectGetMaxY(self.bottomView.frame);
}

- (void) enterAddressMessage{

    CMLAlterAddressMesaageVC *vc = [[CMLAlterAddressMesaageVC alloc] init];
    vc.addressObj = self.currentObj;
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) deleteCurrentAddressMessage{

    self.delegateCurrentAddress(self.currentID);
}


- (void) refreshOrderMessageWithUserName:(NSString *) userName
                                userTele:(NSString *) userTele
                             userAddress:(NSString *) userAddress
                            andAddressID:(NSNumber *) addressID{

    self.refreshCurrentAddress(userName,userTele,userAddress,addressID);
}

- (void) alterAddressStatus{

    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.userNameLab.text  forKey:@"consignee"];
    [paraDic setObject:self.userDetailAddressLab.text forKey:@"address"];
    [paraDic setObject:self.userContactLab.text forKey:@"mobile"];
    [paraDic setObject:self.currentID  forKey:@"deliveryAddressId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"isDefault"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *infoHash = [[NSString stringWithFormat:@"%@%@%@",self.userNameLab.text,self.userDetailAddressLab.text,self.userContactLab.text] md5];
    [paraDic setObject:infoHash forKey:@"infoHash"];
    
    NSString *hasToken = [NSString getEncryptStringfrom:@[reqTime,[NSNumber numberWithInt:0],infoHash,[[DataManager lightData] readSkey]]];
    hasToken = [NSString getEncryptStringfrom:@[reqTime,self.currentID,infoHash,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hasToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ManageAddress paraDic:paraDic delegate:delegate];
    
    self.setDefaultAddressStart();
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.setDefaultAddressEnd(obj.retMsg);
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

}
@end
