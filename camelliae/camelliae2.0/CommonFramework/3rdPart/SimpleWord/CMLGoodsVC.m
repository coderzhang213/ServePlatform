//
//  CMLGoodsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/10.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLGoodsVC.h"
#import "VCManger.h"
#import "CommonNumber.h"
#import "CommonFont.h"


@interface CMLGoodsVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *currentTableView;

@property (nonatomic,strong) UITextField *costNumTextField;

@property (nonatomic,strong) UITextField *costPriceTextField;

@property (nonatomic,strong) UITextField *costFreightTextField;

@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) UIView *costNumPromView;

@property (nonatomic,strong) UIView *costPricePromView;

@property (nonatomic,strong) UILabel *costFreightTitle;

@property (nonatomic,strong) UILabel *costNumTitle;

@property (nonatomic,strong) UILabel *costPriceTitle;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *freight;

@end


@implementation CMLGoodsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navBar setTitleContent:@"价格"];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                 StatusBarHeight,
                                                                 NavigationBarHeight,
                                                                 NavigationBarHeight)];
    [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = KSystemFontSize14;
    [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
    self.confirmBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:self.confirmBtn];
    [self.confirmBtn addTarget:self action:@selector(output) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(self.navBar.frame),
                                                                          WIDTH,
                                                                          HEIGHT - self.navBar.frame.size.height) style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    self.currentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.currentTableView.tableFooterView = [[UIView alloc] init];
    self.currentTableView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.currentTableView];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 110*Proportion;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0*Proportion;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"112"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.costPriceTitle = [[UILabel alloc] init];
        self.costPriceTitle.text = @"请输入价格";
        self.costPriceTitle.font = KSystemFontSize13;
        [self.costPriceTitle sizeToFit];
        self.costPriceTitle.frame = CGRectMake(30*Proportion,
                                               110*Proportion/2.0 - self.costPriceTitle.frame.size.height/2.0,
                                               self.costPriceTitle.frame.size.width,
                                               self.costPriceTitle.frame.size.height);
        self.costPriceTitle.textColor = [UIColor CMLGray2Color];
        [cell addSubview:self.costPriceTitle];
        
        self.costPricePromView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.costPriceTitle.frame) - 4*Proportion,
                                                                          self.costPriceTitle.frame.origin.y - 4*Proportion,
                                                                          8*Proportion,
                                                                          8*Proportion)];
        self.costPricePromView.layer.cornerRadius = 8*Proportion/2.0;
        [cell addSubview:self.costPricePromView];
        
        self.costPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH - 195*Proportion - 30*Proportion,
                                                                                110*Proportion/2.0 - 63*Proportion/2.0 ,
                                                                                195*Proportion,
                                                                                63*Proportion)];
        self.costPriceTextField.layer.borderWidth = 1*Proportion;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = KSystemFontSize13; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor CMLGray3Color]; // 设置颜色
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"0" attributes:attrs]; // 初始化富文本占位字符串
        self.costPriceTextField.attributedPlaceholder = attStr;
        self.costPriceTextField.delegate = self;
        self.costPriceTextField.font = KSystemFontSize13;
        self.costPriceTextField.textColor = [UIColor CMLBrownColor];
        self.costPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.costPriceTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
        self.costPriceTextField.textAlignment = NSTextAlignmentCenter;
        if (self.costPrice) {
            self.costPriceTextField.text = [NSString stringWithFormat:@"%d", [self.costPrice intValue]];
            [self costpriceInput];
        }
        [self.costPriceTextField addTarget:self action:@selector(costpriceInput) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:self.costPriceTextField];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"111"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.costFreightTitle = [[UILabel alloc] init];
        self.costFreightTitle.text = @"请输入运费";
        self.costFreightTitle.font = KSystemFontSize13;
        [self.costFreightTitle sizeToFit];
        self.costFreightTitle.frame = CGRectMake(30*Proportion,
                                               110*Proportion/2.0 - self.costFreightTitle.frame.size.height/2.0,
                                               self.costFreightTitle.frame.size.width,
                                               self.costFreightTitle.frame.size.height);
        self.costFreightTitle.textColor = [UIColor CMLGray2Color];
        [cell addSubview:self.costFreightTitle];
    
        
        self.costFreightTextField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH - 195*Proportion - 30*Proportion,
                                                                                110*Proportion/2.0 - 63*Proportion/2.0 ,
                                                                                195*Proportion,
                                                                                63*Proportion)];
        self.costFreightTextField.layer.borderWidth = 1*Proportion;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = KSystemFontSize13; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor CMLGray3Color]; // 设置颜色
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"0（非必填项）" attributes:attrs]; // 初始化富文本占位字符串
        self.costFreightTextField.attributedPlaceholder = attStr;
        self.costFreightTextField.delegate = self;
        self.costFreightTextField.font = KSystemFontSize13;
        self.costFreightTextField.textColor = [UIColor CMLBrownColor];
        self.costFreightTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.costFreightTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
        self.costFreightTextField.textAlignment = NSTextAlignmentCenter;
        if (self.costFreight) {
            self.costFreightTextField.text = [NSString stringWithFormat:@"%d", [self.costFreight intValue]];
        }
        [self.costFreightTextField addTarget:self action:@selector(costpriceInput) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:self.costFreightTextField];
        
        return cell;

        
    }else{
        
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"113"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.costNumTitle = [[UILabel alloc] init];
        self.costNumTitle.text = @"请输入数量";
        self.costNumTitle.font = KSystemFontSize13;
        [self.costNumTitle sizeToFit];
        self.costNumTitle.frame = CGRectMake(30*Proportion,
                                             110*Proportion/2.0 - self.costNumTitle.frame.size.height/2.0,
                                             self.costNumTitle.frame.size.width,
                                             self.costNumTitle.frame.size.height);
        self.costNumTitle.textColor = [UIColor CMLGray2Color];
        [cell addSubview:self.costNumTitle];
        
        self.costNumPromView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.costNumTitle.frame) - 4*Proportion,
                                                                        self.costNumTitle.frame.origin.y - 4*Proportion,
                                                                        8*Proportion,
                                                                        8*Proportion)];
        self.costNumPromView.layer.cornerRadius = 8*Proportion/2.0;
        [cell addSubview:self.costNumPromView];
        
        self.costNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH - 195*Proportion - 30*Proportion,
                                                                              110*Proportion/2.0 - 63*Proportion/2.0 ,
                                                                              195*Proportion,
                                                                              63*Proportion)];
        self.costNumTextField.layer.borderWidth = 1*Proportion;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = KSystemFontSize13; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor CMLGray3Color]; // 设置颜色
       
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"1-99" attributes:attrs]; // 初始化富文本占位字符串
        self.costNumTextField.attributedPlaceholder = attStr;
        self.costNumTextField.font = KSystemFontSize13;
        self.costNumTextField.delegate = self;
        self.costNumTextField.textColor = [UIColor CMLBrownColor];
        self.costNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.costNumTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
        self.costNumTextField.textAlignment = NSTextAlignmentCenter;
        if (self.costNumber) {
            self.costNumTextField.text = [NSString stringWithFormat:@"%d", [self.costNumber intValue]];
            [self costNumInput];
        }
        [self.costNumTextField addTarget:self action:@selector(costNumInput) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:self.costNumTextField];
        
        return cell;
    }
    
}



- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}


- (void) costpriceInput{
    
    
    if (self.costPriceTextField.text.length > 0) {
        
        
        self.costPricePromView.backgroundColor = [UIColor CMLBrownColor];
        self.costPriceTitle.textColor = [UIColor CMLBlackColor];
        self.costPriceTextField.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        
    }else{
        
        self.costPricePromView.backgroundColor = [UIColor CMLWhiteColor];
        self.costPriceTitle.textColor = [UIColor CMLGray2Color];
        self.costPriceTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
    }
    
    /*********/
    if (self.costPriceTextField.text.length > 0 && self.costNumTextField.text.length > 0) {
        
        self.confirmBtn.userInteractionEnabled = YES;
        [self.confirmBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        
    }else{
        
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
    }
    
}

- (void) costNumInput{
    
    if (self.costNumTextField.text.length > 0) {
        
        self.costNumPromView.backgroundColor = [UIColor CMLBrownColor];
        self.costNumTitle.textColor = [UIColor CMLBlackColor];
        self.costNumTextField.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    }else{
        
        self.costNumPromView.backgroundColor = [UIColor CMLWhiteColor];
        self.costNumTitle.textColor = [UIColor CMLGray2Color];
        self.costNumTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
    }
    
    if (self.costPriceTextField.text.length > 0 &&  self.costNumTextField.text.length > 0 ) {
        
        self.confirmBtn.userInteractionEnabled = YES;
        [self.confirmBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        
    }else{
        
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
    }
}

- (void) output{
    
    
    if (self.costNumTextField.text.length > 0 && self.costNumTextField.text.length < 3) {

        [self.goodsPriceDelegate outputgoodsPrice:[self.costPriceTextField.text intValue] andNum:[self.costNumTextField.text intValue] andFreight:[self.costFreightTextField.text intValue]];
        [[VCManger mainVC] dismissCurrentVC];
        
    }else{
        
        [self showFailTemporaryMes:@"请输入正确数量"];
    }
    
}


@end
