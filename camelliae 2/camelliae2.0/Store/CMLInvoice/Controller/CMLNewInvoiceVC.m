//
//  CMLNewInvoiceVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewInvoiceVC.h"
#import "VCManger.h"
#import "CMLNewInvoiceSelectView.h"
#import "CMLNewInvoiceDetailMesView.h"

@interface CMLNewInvoiceVC ()<NavigationBarProtocol,CMLNewInvoiceSelectViewDelegate,CMLNewInvoiceDetailMesViewDelegate>

@property (nonatomic,strong) CMLNewInvoiceSelectView *selectView;

@property (nonatomic,strong) CMLNewInvoiceDetailMesView *detailMesView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIButton *pushBtn;

@property (nonatomic,strong) NSMutableDictionary *tempDic;

@property (nonatomic,assign) int currentType;

@end

@implementation CMLNewInvoiceVC

- (NSMutableDictionary *)tempDic{
    
    if (!_tempDic) {
        _tempDic = [NSMutableDictionary dictionary];
    }
    return _tempDic;
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

- (instancetype)initWith:(NSDictionary *) dic{
    
    self = [super init];
    
    if (self) {
        self.tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    [self.navBar setTitleContent:@"发票"];
    [self.navBar setTitleColor:[UIColor CMLBlackColor]];
    [self.navBar setLeftBarItem];

    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - CGRectGetMaxY(self.navBar.frame) - 90*Proportion)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    [self.contentView addSubview:self.mainScrollView];
    [self.contentView bringSubviewToFront:self.navBar];
    
    [self loadViews];
    
    self.pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              HEIGHT - 90*Proportion,
                                                              WIDTH,
                                                              90*Proportion)];
    self.pushBtn.backgroundColor = [UIColor CMLGreeenColor];
    [self.pushBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.pushBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    self.pushBtn.titleLabel.font = KSystemBoldFontSize15;
    [self.contentView addSubview:self.pushBtn];
    [self.pushBtn addTarget:self action:@selector(pushInvoiceMes) forControlEvents:UIControlEventTouchUpInside];

    self.currentType = 1;
}

- (void) loadViews{
    
    self.selectView = [[CMLNewInvoiceSelectView alloc] init];
    
    
    if ([[self.tempDic objectForKey:@"invoiceTop"] intValue] == 0) {
        
        self.selectView.userType = [NSNumber numberWithInt:1];
        

    }else{
        
        self.selectView.userType = [self.tempDic objectForKey:@"invoiceTop"];
    }
    
    
    if ([[self.tempDic objectForKey:@"type"] intValue] == 0) {
        
        self.selectView.invoiceType = [NSNumber numberWithInt:1];
        
    }else{
        
        self.selectView.invoiceType = [self.tempDic objectForKey:@"type"];
    }
    

    
    self.selectView.delegate = self;
    [self.selectView loadViews];
    self.selectView.frame = CGRectMake(0,
                                       0,
                                       WIDTH,
                                       self.selectView.frame.size.height);
    [self.mainScrollView addSubview:self.selectView];
    
    self.detailMesView = [[CMLNewInvoiceDetailMesView alloc] init];
    self.detailMesView.delegate = self;
    self.detailMesView.targetDic = self.tempDic;
    [self.detailMesView refrshViews];
    self.detailMesView.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.selectView.frame) + 62*Proportion,
                                          WIDTH,
                                          self.detailMesView.frame.size.height);
    [self.mainScrollView addSubview:self.detailMesView];
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC]dismissCurrentVC];
}

#pragma mark - CMLNewInvoiceSelectViewDelegate
- (void) selectType:(NSNumber *) type{

    self.tempDic = [NSMutableDictionary dictionary];
    
    if ([type intValue] == 1) {
        
        [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"invoiceTop"];
        
    }else if ([type intValue] == 2){
        
        [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"invoiceTop"];
        
    }else if ([type intValue] == 3){
        
        [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
        [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"invoiceTop"];
        
    }
    self.detailMesView.targetDic = self.tempDic;
    self.currentType  = [type intValue];
    [self.detailMesView refreshInvoiceType:type];

}

#pragma mark - CMLNewInvoiceDetailMesViewDelegate

- (void) refreshCurrentHeight:(CGFloat) currentHeight{
    
    self.detailMesView.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.selectView.frame) + 62*Proportion,
                                          WIDTH,
                                          self.detailMesView.frame.size.height);
    
    if (CGRectGetMaxY(self.detailMesView.frame) + 200*Proportion > HEIGHT) {
     
        self.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                     CGRectGetMaxY(self.detailMesView.frame) + 200*Proportion);
    }
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification *) noti{
    
    if (self.currentType == 3) {
        self.mainScrollView.contentOffset = CGPointMake(0,
                                                        self.mainScrollView.contentOffset.y + 200*Proportion);
    }

}

#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden:(NSNotification *) noti{
    
    if (self.currentType == 3) {
    
        if (self.mainScrollView.contentOffset.y > 200*Proportion) {
            
            self.mainScrollView.contentOffset = CGPointMake(0,
                                                            self.mainScrollView.contentOffset.y - 200*Proportion);
        }
    }
    
}

- (void) pushInvoiceMes{
    
    if (self.currentType == 1) {

        self.tempDic = [NSMutableDictionary dictionaryWithDictionary:self.detailMesView.targetDic];
        
        [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"invoiceTop"];
        [self.delegate outPutInvoiceMes:self.tempDic];
        
        [[VCManger mainVC] dismissCurrentVC];
        


    }else if (self.currentType == 2){


        NSString *str1 = [self.detailMesView.targetDic objectForKey:@"taxpayerCode"];
        NSString *str2 = [self.detailMesView.targetDic objectForKey:@"companyName"];
        if (str1.length > 0 && str2.length > 0) {

             self.tempDic = [NSMutableDictionary dictionaryWithDictionary:self.detailMesView.targetDic];
            
            [self.tempDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"invoiceTop"];
            
            [self.delegate outPutInvoiceMes:self.tempDic];
            [[VCManger mainVC] dismissCurrentVC];
        }else{

            [self showFailTemporaryMes:@"请完善信息"];
        }


    }else if (self.currentType == 3){

        NSString *str1 = [self.detailMesView.targetDic objectForKey:@"taxpayerCode"];
        NSString *str2 = [self.detailMesView.targetDic objectForKey:@"companyName"];
        NSString *str3 = [self.detailMesView.targetDic objectForKey:@"companyPhone"];
        NSString *str4 = [self.detailMesView.targetDic objectForKey:@"companyAddress"];
        NSString *str5 = [self.detailMesView.targetDic objectForKey:@"bankAccount"];
        NSString *str6 = [self.detailMesView.targetDic objectForKey:@"bankName"];
        

        if (str1.length > 0 && str2.length > 0 && str3.length > 0 && str4.length > 0 && str5.length > 0 && str6.length > 0) {


            self.tempDic = [NSMutableDictionary dictionaryWithDictionary:self.detailMesView.targetDic];
            
            [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
            [self.tempDic setObject:[NSNumber numberWithInt:2] forKey:@"invoiceTop"];
            
            [self.delegate outPutInvoiceMes:self.tempDic];
            [[VCManger mainVC] dismissCurrentVC];
            
        }else{

            [self showFailTemporaryMes:@"请完善信息"];
        }
    }

}
@end
