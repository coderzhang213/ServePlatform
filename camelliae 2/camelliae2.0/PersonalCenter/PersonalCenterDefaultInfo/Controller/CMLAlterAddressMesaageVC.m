//
//  CMLAlterAddressMesaageVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLAlterAddressMesaageVC.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"

#define CellHeight 110

@interface CMLAlterAddressMesaageVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,strong) UITextField *nameTextField;

@property (nonatomic,strong) UITextField *contactTextField;

@property (nonatomic,strong) UITextView *addressTextField;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIButton *defaultbtn;

@property (nonatomic,strong) UIImageView *selectView;

@end

@implementation CMLAlterAddressMesaageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = @"编辑收货信息";
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];

    [self loadViews];
}

- (void) loadViews{

    
    UIView *firstCell = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.navBar.frame),
                                                                 WIDTH,
                                                                 CellHeight*Proportion)];
    firstCell.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:firstCell];
    
    
    UILabel *namePromLab = [[UILabel alloc] init];
    namePromLab.textColor = [UIColor CMLBlackColor];
    namePromLab.font = KSystemFontSize13;
    namePromLab.text = @"收货人：";
    [namePromLab sizeToFit];
    namePromLab.frame = CGRectMake(30*Proportion,
                                   firstCell.frame.size.height/2.0 - namePromLab.frame.size.height/2.0,
                                   namePromLab.frame.size.width,
                                   namePromLab.frame.size.height);
    [firstCell addSubview:namePromLab];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(namePromLab.frame),
                                                                       0,
                                                                       WIDTH - CGRectGetMaxX(namePromLab.frame) - 30*Proportion,
                                                                       firstCell.frame.size.height)];
    self.nameTextField.font = KSystemFontSize13;
    self.nameTextField.placeholder = @"请输入收货人";
    [firstCell addSubview:self.nameTextField];
    
    if (self.addressObj.consignee) {
        
        self.nameTextField.text = self.addressObj.consignee;
    }
    
    CMLLine *firstLine = [[CMLLine alloc] init];
    firstLine.startingPoint = CGPointMake(30*Proportion, firstCell.frame.size.height - 1*Proportion);
    firstLine.lineLength = WIDTH - 30*Proportion*2;
    firstLine.lineWidth = 1*Proportion;
    firstLine.LineColor = [UIColor CMLPromptGrayColor];
    [firstCell addSubview:firstLine];
    
    UIView *secondCell = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.navBar.frame) + CellHeight*Proportion,
                                                                  WIDTH,
                                                                  CellHeight*Proportion)];
    secondCell.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:secondCell];
    
    UILabel *contactPromLab = [[UILabel alloc] init];
    contactPromLab.textColor = [UIColor CMLBlackColor];
    contactPromLab.font = KSystemFontSize13;
    contactPromLab.text = @"收货电话：";
    [contactPromLab sizeToFit];
    contactPromLab.frame = CGRectMake(30*Proportion,
                                   secondCell.frame.size.height/2.0 - contactPromLab.frame.size.height/2.0,
                                   contactPromLab.frame.size.width,
                                   contactPromLab.frame.size.height);
    [secondCell addSubview:contactPromLab];
    
    self.contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contactPromLab.frame),
                                                                          0,
                                                                          WIDTH - CGRectGetMaxX(contactPromLab.frame) - 30*Proportion,
                                                                          secondCell.frame.size.height)];
    self.contactTextField.font = KSystemFontSize13;
    self.contactTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.contactTextField.placeholder = @"请输入收货电话";
    [secondCell addSubview:self.contactTextField];
    
    if (self.addressObj.mobile) {
        
        self.contactTextField.text = self.addressObj.mobile;
    }
    
    CMLLine *secondLine = [[CMLLine alloc] init];
    secondLine.startingPoint = CGPointMake(30*Proportion, secondCell.frame.size.height - 1*Proportion);
    secondLine.lineLength = WIDTH - 30*Proportion*2;
    secondLine.lineWidth = 1*Proportion;
    secondLine.LineColor = [UIColor CMLPromptGrayColor];
    [secondCell addSubview:secondLine];
    
    UIView *thirdCell = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.navBar.frame) + CellHeight*Proportion*2,
                                                                  WIDTH,
                                                                  CellHeight*Proportion)];
    thirdCell.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:thirdCell];
    
    UILabel *addressPromLab = [[UILabel alloc] init];
    addressPromLab.textColor = [UIColor CMLBlackColor];
    addressPromLab.font = KSystemFontSize13;
    addressPromLab.text = @"收货地址：";
    [addressPromLab sizeToFit];
    addressPromLab.frame = CGRectMake(30*Proportion,
                                      thirdCell.frame.size.height/2.0 - addressPromLab.frame.size.height/2.0,
                                      addressPromLab.frame.size.width,
                                      addressPromLab.frame.size.height);
    [thirdCell addSubview:addressPromLab];
    
    self.addressTextField = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressPromLab.frame),
                                                                         thirdCell.frame.size.height/2.0 - addressPromLab.frame.size.height*2/2.0,
                                                                         WIDTH - CGRectGetMaxX(addressPromLab.frame) - 30*Proportion,
                                                                         addressPromLab.frame.size.height*2)];
    self.addressTextField.font = KSystemFontSize13;
    [thirdCell addSubview:self.addressTextField];
    
    if (self.addressObj.address) {
        
        self.addressTextField.text = self.addressObj.address;
    }
    
    CMLLine *thirdLine = [[CMLLine alloc] init];
    thirdLine.startingPoint = CGPointMake(30*Proportion, thirdCell.frame.size.height - 1*Proportion);
    thirdLine.lineLength = WIDTH - 30*Proportion*2;
    thirdLine.lineWidth = 1*Proportion;
    thirdLine.LineColor = [UIColor CMLPromptGrayColor];
    [thirdCell addSubview:thirdLine];
    
    UIImageView *circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:AddressDefaultImg]];
    [circleView sizeToFit];
    circleView.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(thirdCell.frame) + 40*Proportion,
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
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemFontSize11;
    titleLab.textColor = [UIColor CMLGreeenColor];
    titleLab.userInteractionEnabled = YES;
    titleLab.text = @"设置默认地址";
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(CGRectGetMaxX(circleView.frame) + 10*Proportion,
                                circleView.center.y - titleLab.frame.size.height/2.0,
                                titleLab.frame.size.width,
                                titleLab.frame.size.height);
    [self.contentView addSubview:titleLab];
    
    self.defaultbtn = [[UIButton alloc] init];
    self.defaultbtn.backgroundColor = [UIColor clearColor];
    self.defaultbtn.frame = CGRectMake(circleView.frame.origin.x,
                                       circleView.center.y - (self.defaultbtn.frame.size.height + 10*Proportion*2)/2.0,
                                       titleLab.frame.size.width + circleView.frame.size.width + 10*Proportion,
                                       titleLab.frame.size.height + 10*Proportion*2 );
    [self.contentView addSubview:self.defaultbtn];
    [self.defaultbtn addTarget:self action:@selector(changeAddressStatus) forControlEvents:UIControlEventTouchUpInside];
   
    self.selectView.hidden = YES;
    if ([self.addressObj.is_default intValue] == 1) {
        
        self.defaultbtn.hidden = YES;
        circleView.hidden = YES;
        titleLab.hidden = YES;
    }
    
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                     CGRectGetMaxY(thirdCell.frame) + 130*Proportion,
                                                                     WIDTH - 30*Proportion*2,
                                                                     60*Proportion)];
    finishBtn.layer.cornerRadius = 6*Proportion;
    [finishBtn setTitle:@"保存" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = KSystemFontSize14;
    finishBtn.backgroundColor = [UIColor CMLBrownColor];
    [finishBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(preserveUserMessage) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark - NavigationBarProtocol

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.nameTextField resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
}

- (void) preserveUserMessage{

    [self setPreserveUserMessageRequest];
}

- (void) setPreserveUserMessageRequest{

    if ([self.contactTextField.text valiMobile]) {
        
        if (self.nameTextField.text.length > 0 && self.nameTextField.text.length < 12) {
            
            if (self.addressTextField.text.length > 0 ) {
               
                NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
                delegate.delegate = self;
                
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                
                NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
                [paraDic setObject:reqTime forKey:@"reqTime"];
                [paraDic setObject:self.nameTextField.text forKey:@"consignee"];
                [paraDic setObject:self.addressTextField.text forKey:@"address"];
                [paraDic setObject:self.contactTextField.text forKey:@"mobile"];
                [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"deliveryAddressId"];
                if (self.addressObj.currentID) {
                    [paraDic setObject:self.addressObj.currentID forKey:@"deliveryAddressId"];
                }
                
                if ([self.addressObj.is_default intValue] == 1) {
                    
                    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"isDefault"];
                }else{
                
                    if (self.selectView.hidden) {
                        
                        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"isDefault"];
                    }else{
                        
                        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"isDefault"];
                    }
                
                }
                
                [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
                NSString *infoHash = [[NSString stringWithFormat:@"%@%@%@",self.nameTextField.text,self.addressTextField.text,self.contactTextField.text] md5];
                [paraDic setObject:infoHash forKey:@"infoHash"];
                
                NSString *hasToken = [NSString getEncryptStringfrom:@[reqTime,[NSNumber numberWithInt:0],infoHash,[[DataManager lightData] readSkey]]];
                
                if (self.addressObj.currentID) {
                    
                    hasToken = [NSString getEncryptStringfrom:@[reqTime,self.addressObj.currentID,infoHash,[[DataManager lightData] readSkey]]];
                }
                [paraDic setObject:hasToken forKey:@"hashToken"];
                [NetWorkTask postResquestWithApiName:ManageAddress paraDic:paraDic delegate:delegate];
                self.currentApiName = ManageAddress;
                
                [self startIndicatorLoading];
                
            }else{
            
                [self showFailTemporaryMes:@"请输入地址"];
            }
            
        }else{
        
           [self showFailTemporaryMes:@"请输入正确姓名"];
        }
        
    }else{
        
        [self showFailTemporaryMes:@"请输入正确手机号"];
    }

}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:ManageAddress]) {
        
        [self stopIndicatorLoading];
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {

                [self.delegate refreshOrderMessageWithUserName:self.nameTextField.text
                                                      userTele:self.contactTextField.text
                                                   userAddress:self.addressTextField.text
                                                  andAddressID:obj.retData.deliveryAddressId];

            
            [self refrshPersonalCenter];
        }
    }else{
    
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([resObj.retCode intValue] == 0 && resObj) {
            
            LoginUserObj *userInfo = resObj.retData.user;
            
            [[DataManager lightData] saveSignStatus:userInfo.signStatus];
            [[DataManager lightData] saveUser:resObj];
            
            [[VCManger mainVC] dismissCurrentVC];

            
        }else if ([resObj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            NSLog(@"%@",resObj.retMsg);
        }

    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopIndicatorLoading];
}


- (void) changeAddressStatus{

    if (self.selectView.hidden) {
        
        self.selectView.hidden = NO;
    }else{
    
        self.selectView.hidden = YES;
    }
}

- (void) refrshPersonalCenter{
    
    /**网络请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSNumber *userId = [[DataManager lightData] readUserID];
    [paraDic setObject:userId forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[userId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:NewMemberUser paraDic:paraDic delegate:delegate];
    self.currentApiName = NewMemberUser;
    
}

@end
