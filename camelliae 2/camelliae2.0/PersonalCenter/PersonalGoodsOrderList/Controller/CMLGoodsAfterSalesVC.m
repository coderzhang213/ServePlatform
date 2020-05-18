//
//  CMLGoodsAfterSalesVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/13.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGoodsAfterSalesVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NetConfig.h"
#import "VCManger.h"
#import "UITextView+Placeholder.h"
#import "CMLCommenOrderObj.h"
#import "CMLGoodsOrderObj.h"
#import "CMLServeOrderObj.h"
#import "NSString+CMLExspand.h"


@interface CMLGoodsAfterSalesVC ()<NavigationBarProtocol,UITextViewDelegate,UITextFieldDelegate,NetWorkProtocol>

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,assign) int currentSelectIndex;

@property (nonatomic,strong) UITextField *teleNumTextField;

@property (nonatomic,strong) UITextView *remarkTextView;

@property (nonatomic,strong)  UIView *promFourBottomLine;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLGoodsAfterSalesVC

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWith:(NSString *)str{
    
    self = [super init];
    
    if (self) {
        
        self.typeName = str;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navBar setLeftBarItem];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleContent = self.typeName;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - 90*Proportion - SafeAreaBottomHeight)];
    [self.contentView addSubview:self.mainScrollView];
    
    [self loadViews];
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      HEIGHT - 90*Proportion - SafeAreaBottomHeight,
                                                                      WIDTH,
                                                                      90*Proportion)];
    confirmBtn.backgroundColor = [UIColor CMLGreeenColor];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(setRequest) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) loadViews{
    
    
    
    UILabel *topTitlePromLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         60*Proportion)];
    topTitlePromLab.font = KSystemBoldFontSize12;
    topTitlePromLab.text = @"成功提交申请后，审核通过，客服小秘书将尽快与您联系。";
    topTitlePromLab.textColor = [UIColor CMLLineGrayColor];
    topTitlePromLab.backgroundColor = [UIColor CMLNewGrayColor];
    topTitlePromLab.textAlignment = NSTextAlignmentCenter;
    
    [self.mainScrollView addSubview:topTitlePromLab];
    
    UILabel  *promLab = [[UILabel alloc] init];
    
    if ([self.typeName isEqualToString:@"退款"]) {
        promLab.text = @"退款商品：";
    }else{
        promLab.text = @"售后商品：";
    }
    
    promLab.font = KSystemFontSize12;
    promLab.textColor = [UIColor CMLLineGrayColor];
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion,
                               CGRectGetMaxY(topTitlePromLab.frame) + 30*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self.mainScrollView addSubview:promLab];
    
    UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                           CGRectGetMaxY(promLab.frame) + 20*Proportion,
                                                                           140*Proportion,
                                                                           140*Proportion)];
    mainImage.contentMode = UIViewContentModeScaleAspectFill;
    mainImage.clipsToBounds = YES;
    mainImage.backgroundColor = [UIColor CMLNewGrayColor];
    mainImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
    mainImage.layer.borderWidth = 1*Proportion;
    [self.mainScrollView addSubview:mainImage];
    
    if (self.goodsOrderObj) {
        
        [NetWorkTask setImageView:mainImage WithURL:self.goodsOrderObj.coverPicThumb placeholderImage:nil];
    }else{
     
        [NetWorkTask setImageView:mainImage WithURL:self.serveOrderObj.coverPicThumb placeholderImage:nil];
    }
    
    
    UILabel *moduleTitleLab = [[UILabel alloc] init];
    moduleTitleLab.numberOfLines = 2;
    moduleTitleLab.font = KSystemFontSize11;
    if (self.goodsOrderObj) {
        
        moduleTitleLab.text = self.goodsOrderObj.brandName;
    }else{
        
        moduleTitleLab.text = self.serveOrderObj.title;
    }

    moduleTitleLab.textAlignment = NSTextAlignmentLeft;
    [moduleTitleLab sizeToFit];
    if (moduleTitleLab.frame.size.width > WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 140*Proportion) {
        
        moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(mainImage.frame) + 20*Proportion,
                                          mainImage.frame.origin.y,
                                          WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                          moduleTitleLab.frame.size.height*2);
    }else{
        
        moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(mainImage.frame) + 20*Proportion,
                                           mainImage.frame.origin.y,
                                          WIDTH - 50*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                          moduleTitleLab.frame.size.height);
        
    }
    [self.mainScrollView addSubview:moduleTitleLab];
    
    if (self.goodsOrderObj) {
     
        UILabel *packageNameLab = [[UILabel alloc] init];
        packageNameLab.text = [NSString stringWithFormat:@"已选：%@",self.goodsOrderObj.orderInfo.packageName];
        packageNameLab.font = KSystemFontSize10;
        packageNameLab.textColor = [UIColor CMLLineGrayColor];
        [packageNameLab sizeToFit];
        packageNameLab.frame = CGRectMake(CGRectGetMaxX(mainImage.frame) + 20*Proportion,
                                          CGRectGetMaxY(moduleTitleLab.frame) + 10*Proportion,
                                          packageNameLab.frame.size.width,
                                          packageNameLab.frame.size.height);
        [self.mainScrollView addSubview:packageNameLab];
    }
    
    UILabel *modulePriceLab = [[UILabel alloc] init];
    modulePriceLab.font = KSystemBoldFontSize13;
    modulePriceLab.textColor = [UIColor CMLBrownColor];
    
    if (self.goodsOrderObj) {
        
        modulePriceLab.text =  [NSString stringWithFormat:@"¥%d",[self.goodsOrderObj.orderInfo.payAmtE2 intValue]/100  /[self.goodsOrderObj.orderInfo.goodsNum intValue]];
    }else{
    
        modulePriceLab.text = [NSString stringWithFormat:@"¥%d",[self.serveOrderObj.orderInfo.payAmtE2 intValue]/100/[self.serveOrderObj.orderInfo.goodsNum intValue]];
        
    }

    [modulePriceLab sizeToFit];
    modulePriceLab.frame = CGRectMake(CGRectGetMaxX(mainImage.frame) + 20*Proportion,
                                      CGRectGetMaxY(mainImage.frame) - modulePriceLab.frame.size.height,
                                      modulePriceLab.frame.size.width,
                                      modulePriceLab.frame.size.height);
    
    [self.mainScrollView addSubview:modulePriceLab];
    if (self.serveOrderObj) {
        
        if ([self.serveOrderObj.orderInfo.payType intValue] == 1) {
            
            UILabel *promLab = [[UILabel alloc] init];
            promLab.font = KSystemBoldFontSize10;
            promLab.textColor = [UIColor CMLBrownColor];
            promLab.text = @"（订金）";
            [promLab sizeToFit];
            promLab.frame = CGRectMake(CGRectGetMaxX(modulePriceLab.frame) + 5*Proportion,
                                       modulePriceLab.center.y - promLab.frame.size.height/2.0,
                                       promLab.frame.size.width,
                                       promLab.frame.size.height);
            [self.mainScrollView addSubview:promLab];
        }

    }else{
        
    
        if ([self.goodsOrderObj.is_deposit intValue] == 1) {
            
            UILabel *promLab = [[UILabel alloc] init];
            promLab.font = KSystemBoldFontSize10;
            promLab.textColor = [UIColor CMLBrownColor];
            promLab.text = @"（订金）";
            [promLab sizeToFit];
            promLab.frame = CGRectMake(CGRectGetMaxX(modulePriceLab.frame) + 5*Proportion,
                                       modulePriceLab.center.y - promLab.frame.size.height/2.0,
                                       promLab.frame.size.width,
                                       promLab.frame.size.height);
            [self.mainScrollView addSubview:promLab];
        }
    }
    
    UILabel *promTwoLab = [[UILabel alloc] init];
    promTwoLab.text = @"售后商品：";
    promTwoLab.font = KSystemFontSize12;
    promTwoLab.textColor = [UIColor CMLLineGrayColor];
    [promTwoLab sizeToFit];
    promTwoLab.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(modulePriceLab.frame) + 67*Proportion,
                                  promTwoLab.frame.size.width,
                                  promTwoLab.frame.size.height);
    [self.mainScrollView addSubview:promTwoLab];
    
    if ([self.typeName isEqualToString:@"售后申请"]) {

        UIButton *afterSaleBtn = [[UIButton alloc] init];
        [afterSaleBtn setImage:[UIImage imageNamed:MailAfterSalesNormalImg] forState:UIControlStateNormal];
        [afterSaleBtn setImage:[UIImage imageNamed:MailAfterSalesSelectedImg] forState:UIControlStateSelected];
        [afterSaleBtn setTitle:@"退货退款" forState:UIControlStateNormal];
        [afterSaleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [afterSaleBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        afterSaleBtn.titleLabel.font = KSystemFontSize13;
        afterSaleBtn.tag = 0;
        afterSaleBtn.contentMode = UIViewContentModeLeft;
        [afterSaleBtn sizeToFit];
        afterSaleBtn.frame = CGRectMake(50*Proportion,
                                        CGRectGetMaxY(promTwoLab.frame) + 30*Proportion,
                                        afterSaleBtn.frame.size.width,
                                        afterSaleBtn.frame.size.height);
        [self.mainScrollView addSubview:afterSaleBtn];
        [afterSaleBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        afterSaleBtn.selected = YES;
        self.currentSelectIndex = 0;
        [self.btnArray addObject:afterSaleBtn];
        
        UIButton *changeGoodsBtn = [[UIButton alloc] init];
        [changeGoodsBtn setImage:[UIImage imageNamed:MailAfterSalesNormalImg] forState:UIControlStateNormal];
        [changeGoodsBtn setImage:[UIImage imageNamed:MailAfterSalesSelectedImg] forState:UIControlStateSelected];
        [changeGoodsBtn setTitle:@"换货" forState:UIControlStateNormal];
        [changeGoodsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [changeGoodsBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        changeGoodsBtn.tag = 1;
        changeGoodsBtn.titleLabel.font = KSystemFontSize13;
        changeGoodsBtn.contentMode = UIViewContentModeLeft;
        [changeGoodsBtn sizeToFit];
        changeGoodsBtn.frame = CGRectMake(CGRectGetMaxX(afterSaleBtn.frame) + 40*Proportion,
                                          CGRectGetMaxY(promTwoLab.frame) + 30*Proportion,
                                          changeGoodsBtn.frame.size.width,
                                          changeGoodsBtn.frame.size.height);
        [self.mainScrollView addSubview:changeGoodsBtn];
        [changeGoodsBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:changeGoodsBtn];
        
        UIButton *otherBtn = [[UIButton alloc] init];
        [otherBtn setImage:[UIImage imageNamed:MailAfterSalesNormalImg] forState:UIControlStateNormal];
        [otherBtn setImage:[UIImage imageNamed:MailAfterSalesSelectedImg] forState:UIControlStateSelected];
        [otherBtn setTitle:@"其他" forState:UIControlStateNormal];
        [otherBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        otherBtn.titleLabel.font = KSystemFontSize13;
        [otherBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        otherBtn.tag = 2;
        otherBtn.contentMode = UIViewContentModeLeft;
        [otherBtn sizeToFit];
        otherBtn.frame = CGRectMake(CGRectGetMaxX(changeGoodsBtn.frame) + 40*Proportion,
                                    CGRectGetMaxY(promTwoLab.frame) + 30*Proportion,
                                    otherBtn.frame.size.width,
                                    otherBtn.frame.size.height);
        [self.mainScrollView addSubview:otherBtn];
        [otherBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:otherBtn];

    }else{


        UIButton *afterSaleBtn = [[UIButton alloc] init];
        [afterSaleBtn setImage:[UIImage imageNamed:MailAfterSalesNormalImg] forState:UIControlStateNormal];
        [afterSaleBtn setImage:[UIImage imageNamed:MailAfterSalesSelectedImg] forState:UIControlStateSelected];
        [afterSaleBtn setTitle:@"退款" forState:UIControlStateNormal];
        [afterSaleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [afterSaleBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        afterSaleBtn.tag = 0;
        afterSaleBtn.contentMode = UIViewContentModeLeft;
        afterSaleBtn.titleLabel.font = KSystemFontSize13;
        [afterSaleBtn sizeToFit];
        afterSaleBtn.frame = CGRectMake(50*Proportion,
                                        CGRectGetMaxY(promTwoLab.frame) + 30*Proportion,
                                        afterSaleBtn.frame.size.width,
                                        afterSaleBtn.frame.size.height);
        [self.mainScrollView addSubview:afterSaleBtn];
        [afterSaleBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        afterSaleBtn.selected = YES;
        self.currentSelectIndex = 0;
        [self.btnArray addObject:afterSaleBtn];
    }
    
    UILabel *promThreeLab = [[UILabel alloc] init];
    promThreeLab.text = @"联系方式：";
    promThreeLab.font = KSystemFontSize12;
    promThreeLab.textColor = [UIColor CMLLineGrayColor];
    [promThreeLab sizeToFit];
    promThreeLab.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(promTwoLab.frame) + 153*Proportion,
                                  promThreeLab.frame.size.width,
                                  promThreeLab.frame.size.height);
    [self.mainScrollView addSubview:promThreeLab];
    
    self.teleNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(30*Proportion, CGRectGetMaxY(promThreeLab.frame), WIDTH - 30*Proportion*2, 80*Proportion)];
    self.teleNumTextField.placeholder = @"必填，请输入您的手机号码";
    self.teleNumTextField.font = KSystemFontSize13;
    self.teleNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.teleNumTextField.delegate = self;
    [self.mainScrollView addSubview:self.teleNumTextField];
    UIView *promThreeBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                           CGRectGetMaxY(self.teleNumTextField.frame),
                                                                           WIDTH - 30*Proportion*2,
                                                                           1*Proportion)];
    promThreeBottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.mainScrollView addSubview:promThreeBottomLine];
    
    UILabel *promFourLab = [[UILabel alloc] init];
    promFourLab.text = @"售后说明：";
    promFourLab.font = KSystemFontSize12;
    promFourLab.textColor = [UIColor CMLLineGrayColor];
    [promFourLab sizeToFit];
    promFourLab.frame = CGRectMake(30*Proportion,
                                    CGRectGetMaxY(promThreeLab.frame) + 160*Proportion,
                                    promFourLab.frame.size.width,
                                    promFourLab.frame.size.height);
    [self.mainScrollView addSubview:promFourLab];
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(promFourLab.frame),
                                                                       WIDTH - 30*Proportion*2,
                                                                       80*Proportion*3)];
    self.remarkTextView.placeholder = @"选填，请输入您的相关备注信息";
    self.remarkTextView.delegate = self;
    self.remarkTextView.font = KSystemFontSize13;
    [self.mainScrollView addSubview:self.remarkTextView];
    self.promFourBottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       CGRectGetMaxY(self.remarkTextView.frame),
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
    self.promFourBottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.mainScrollView addSubview:self.promFourBottomLine];
    
   
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) changeStatus:(UIButton *) btn{
    
    if (!btn.selected) {
        
        self.currentSelectIndex = (int)btn.tag;
        btn.selected = YES;
        
        for (int i = 0; i < self.btnArray.count; i++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (btn.tag != tempBtn.tag) {
                
                tempBtn.selected = NO;
            }
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.teleNumTextField resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification *) noti{
    
    
    NSDictionary *info = [noti userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    
    self.mainScrollView.contentOffset = CGPointMake(0,keyboardSize.height);
    
}

#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden:(NSNotification *) noti{
    
   self.mainScrollView.contentOffset = CGPointMake(0, 0);
   
}

- (void) setRequest{
    
    if ([self.teleNumTextField.text valiMobile]) {
            
            
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            
            NSNumber *type;
            if ([self.typeName isEqualToString:@"退款"]) {
                
                [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
                type = [NSNumber numberWithInt:1];
            }else{
                
                [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
                type = [NSNumber numberWithInt:2];
            }
            
            
            switch (self.currentSelectIndex) {
                case 0:
                    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"reasonId"];
                    break;
                case 1:
                    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"reasonId"];
                    break;
                case 2:
                    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"reasonId"];
                    break;
                    
                default:
                    break;
            }
            [paraDic setObject:self.brandType forKey:@"objType"];
            NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
            [paraDic setObject:reqTime forKey:@"reqTime"];
            NSString *skey = [[DataManager lightData] readSkey];
            [paraDic setObject:skey forKey:@"skey"];
            
            if (self.serveOrderObj) {
                [paraDic setObject:self.serveOrderObj.orderInfo.currentID forKey:@"objId"];
            }else{
                [paraDic setObject:self.goodsOrderObj.orderInfo.currentID forKey:@"objId"];
                
            }
            [paraDic setObject:self.teleNumTextField.text forKey:@"mobile"];
            [paraDic setObject:self.remarkTextView.text forKey:@"detail"];
            if (self.serveOrderObj) {
                
                NSString *hashToken = [NSString getEncryptStringfrom:@[self.remarkTextView.text,self.teleNumTextField.text,self.serveOrderObj.orderInfo.currentID,self.brandType,[NSNumber numberWithInt:self.currentSelectIndex + 1],reqTime,skey,type]];
                [paraDic setObject:hashToken forKey:@"hashToken"];
            }else{
                
                NSString *hashToken = [NSString getEncryptStringfrom:@[self.remarkTextView.text,self.teleNumTextField.text,self.goodsOrderObj.orderInfo.currentID,self.brandType,[NSNumber numberWithInt:self.currentSelectIndex + 1],reqTime,skey,type]];
                [paraDic setObject:hashToken forKey:@"hashToken"];
            }
            
            [NetWorkTask postResquestWithApiName:MailRefundsApply paraDic:paraDic delegate:delegate];
            self.currentApiName = MailRefundsApply;
         
            [self startLoading];
      

    }else{
        
        [self showFailTemporaryMes:@"请输入手机号"];
    }

}


/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MailRefundsApply]) {
        [self stopLoading];
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [[VCManger mainVC] dismissCurrentVC];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}
#pragma mark - NetWorkProtocol
@end
