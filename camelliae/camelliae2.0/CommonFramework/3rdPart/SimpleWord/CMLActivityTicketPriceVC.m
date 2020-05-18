//
//  CMLActivityTicketPriceVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/8.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLActivityTicketPriceVC.h"
#import "VCManger.h"
#import "CommonNumber.h"
#import "CommonFont.h"


@interface CMLActivityTicketPriceVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic,strong) UIView *freebgView;

@property (nonatomic,strong) UIView *costbgView;

@property (nonatomic,strong) UIButton *freeActivityBtn;

@property (nonatomic,strong) UIButton *costActivityBtn;

@property (nonatomic,strong) UIView *freeView;

@property (nonatomic,strong) UIView *costView;

@property (nonatomic,strong) UITableView *currentTableView;

@property (nonatomic,strong) UITextField *freeNumTextField;

@property (nonatomic,strong) UITextField *costNumTextField;

@property (nonatomic,strong) UITextField *costPriceTextField;

@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) UIView *costNumPromView;

@property (nonatomic,strong) UIView *costPricePromView;

@property (nonatomic,strong) UILabel *freeNumTitle;

@property (nonatomic,strong) UILabel *costNumTitle;

@property (nonatomic,strong) UILabel *costPriceTitle;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *number;

@end

@implementation CMLActivityTicketPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navBar setTitleContent:@"票种价格"];
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
    
    UIView *endView = [[UIView alloc] init];
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.font = KSystemFontSize12;
    endLabel.text = @"请根据您的活动情况来选择票种，填好信息后，点击(确定）即可，同一个活动，免费和收费不可同时出现哦";
    endLabel.textColor = [UIColor CMLLineGrayColor];
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.numberOfLines = 2;
    [endLabel sizeToFit];
    endLabel.frame = CGRectMake(30*Proportion,
                                55*Proportion,
                                WIDTH - 30*Proportion*2,
                                endLabel.frame.size.height*2);
    [endView addSubview:endLabel];
    endView.frame = CGRectMake(0,
                               0,
                               WIDTH,
                               CGRectGetMaxY(endLabel.frame));
    self.currentTableView.tableFooterView = endView;
    self.currentTableView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.currentTableView];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else{
        
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.freeActivityBtn.selected) {
        if (indexPath.section == 0) {
            
            return 110*Proportion;
        }else{
            
            return 0;
        }
        
    }else{
        
        if (self.costActivityBtn.selected) {
            
            if (indexPath.section == 1) {
                
                return 110*Proportion;
            }else{
                
                return 0;
            }
        }else{
            
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.freebgView) {
            
            return self.freebgView;
            
        }else{
            
            return [self setSectionOneView];

        }
        
        
    }else{
    
        if (self.costbgView) {
            
            return  self.costbgView;
        }else{
            
             return [self setSectionTwoView];
        }

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 110*Proportion;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"111"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.freeActivityBtn.selected) {
            self.freeNumTitle = [[UILabel alloc] init];
            self.freeNumTitle.font = KSystemFontSize13;
            [self.freeNumTitle sizeToFit];
            self.freeNumTitle.frame = CGRectMake(30*Proportion,
                                                 110*Proportion/2.0 - self.freeNumTitle.frame.size.height/2.0,
                                                 self.freeNumTitle.frame.size.width,
                                                 self.freeNumTitle.frame.size.height);
            self.freeNumTitle.textColor = [UIColor CMLGray2Color];
            [cell addSubview:self.freeNumTitle];
            
            self.freeNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH - 195*Proportion - 30*Proportion,
                                                                                  110*Proportion/2.0 - 63*Proportion/2.0 ,
                                                                                  195*Proportion,
                                                                                  63*Proportion)];
            self.freeNumTextField.layer.borderWidth = 1*Proportion;
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
            attrs[NSFontAttributeName] = KSystemFontSize13; // 设置font
            attrs[NSForegroundColorAttributeName] = [UIColor CMLGray3Color]; // 设置颜色
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"1-99" attributes:attrs]; // 初始化富文本占位字符串
            self.freeNumTextField.attributedPlaceholder = attStr;
            self.freeNumTextField.delegate = self;
            self.freeNumTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.freeNumTextField.font = KSystemFontSize13;
            self.freeNumTextField.textColor = [UIColor CMLBrownColor];
            self.freeNumTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
            self.freeNumTextField.textAlignment = NSTextAlignmentCenter;
            if (self.costNumber) {
                self.freeNumTextField.text = [NSString stringWithFormat:@"%d", [self.costNumber intValue]];
                [self freeNumInput];
            }
            [self.freeNumTextField addTarget:self action:@selector(freeNumInput) forControlEvents:UIControlEventEditingChanged];
            [cell addSubview:self.freeNumTextField];
        }

        
        return cell;
    
    }else{
        
        
        if (indexPath.row == 0) {
            
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"112"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.costActivityBtn.selected) {
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
                    if ([self.costPrice intValue] != 0) {
                        self.costPriceTextField.text = [NSString stringWithFormat:@"%d", [self.costPrice intValue]];
                        [self costpriceInput];
                    }
                }
                [self.costPriceTextField addTarget:self action:@selector(costpriceInput) forControlEvents:UIControlEventEditingChanged];
                [cell addSubview:self.costPriceTextField];
            }

            return cell;
            
        }else{
            
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:@"113"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            if (self.costActivityBtn.selected) {
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
            }
            
            return cell;
        }
    }
}



- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (UIView *) setSectionOneView{
    
   self.freebgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            110*Proportion)];

    
    UILabel *moduleLab = [[UILabel alloc] init];
    moduleLab.text = @"免费活动";
    moduleLab.font = KSystemFontSize14;
    [moduleLab sizeToFit];
    moduleLab.frame = CGRectMake(30*Proportion,
                                 110*Proportion/2.0 - moduleLab.frame.size.height/2.0,
                                 moduleLab.frame.size.width,
                                 moduleLab.frame.size.height);
    [self.freebgView addSubview:moduleLab];
    
    self.freeView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 57*Proportion - 20*Proportion,
                                                             self.freebgView.frame.size.height/2.0 - 20*Proportion/2.0,
                                                             20*Proportion,
                                                             20*Proportion)];
    self.freeView.layer.cornerRadius = 20*Proportion/2.0;
    self.freeView.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.freeView.layer.borderWidth = 1*Proportion;
    [self.freebgView addSubview:self.freeView];

    
    self.freeActivityBtn = [[UIButton alloc] initWithFrame:self.freebgView.bounds];
    self.freeActivityBtn.backgroundColor = [UIColor clearColor];
    /*新增：判断价格和数量*/
    if (self.costPrice) {
        if ([self.costPrice intValue] == 0) {
            [self showFreeMes];
        }else {
            [self showCostMes];
        }
    }
    [self.freeActivityBtn addTarget:self action:@selector(showFreeMes) forControlEvents:UIControlEventTouchUpInside];
    [self.freebgView addSubview:self.freeActivityBtn];
    

    return self.freebgView;
}

- (UIView *) setSectionTwoView{
    

    
    self.costbgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            110*Proportion)];
    
    
    UILabel *moduleLab = [[UILabel alloc] init];
    moduleLab.text = @"收费活动";
    moduleLab.font = KSystemFontSize14;
    [moduleLab sizeToFit];
    moduleLab.frame = CGRectMake(30*Proportion,
                                 110*Proportion/2.0 - moduleLab.frame.size.height/2.0,
                                 moduleLab.frame.size.width,
                                 moduleLab.frame.size.height);
    [self.costbgView addSubview:moduleLab];
    
    self.costView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 57*Proportion - 20*Proportion,
                                                             self.costbgView.frame.size.height/2.0 - 20*Proportion/2.0,
                                                             20*Proportion,
                                                             20*Proportion)];
    self.costView.layer.cornerRadius = 20*Proportion/2.0;
    self.costView.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    self.costView.layer.borderWidth = 1*Proportion;
    [self.costbgView addSubview:self.costView];
    
    self.costActivityBtn = [[UIButton alloc] initWithFrame:self.costbgView.bounds];
    self.costActivityBtn.backgroundColor = [UIColor clearColor];
    /*新增：判断价格和数量*/
    if (self.costPrice) {
        if ([self.costPrice intValue] == 0) {
            [self showFreeMes];
        }else {
            [self showCostMes];
        }
    }
    [self.costActivityBtn addTarget:self action:@selector(showCostMes) forControlEvents:UIControlEventTouchUpInside];
    [self.costbgView addSubview:self.costActivityBtn];
    
    return self.costbgView;
}

- (void) showFreeMes{
    
    if (!self.freeActivityBtn.selected) {
        
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
        
        self.freeActivityBtn.selected = YES;
        self.costActivityBtn.selected = NO;
        [self.currentTableView reloadData];
        self.freeView.backgroundColor = [UIColor CMLBrownColor];
        self.costView.backgroundColor = [UIColor CMLWhiteColor];
    
    }

}


- (void) showCostMes{
    
    if (!self.costActivityBtn.selected) {
        
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
        
        self.freeActivityBtn.selected = NO;
        self.costActivityBtn.selected = YES;
        [self.currentTableView reloadData];
        self.costView.backgroundColor = [UIColor CMLBrownColor];
        self.freeView.backgroundColor = [UIColor CMLWhiteColor];
        
    }

}


-(void) freeNumInput{
    
    if (self.freeNumTextField.text.length > 0) {
        
        self.freeNumTitle.textColor = [UIColor CMLBlackColor];
        self.freeNumTextField.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    }else{
        
        self.freeNumTitle.textColor = [UIColor CMLGray2Color];
        self.freeNumTextField.layer.borderColor = [UIColor CMLGray3Color].CGColor;
    }
    
    
    if (self.freeNumTextField.text.length > 0) {
        
        self.confirmBtn.userInteractionEnabled = YES;
        
        [self.confirmBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    }else{
        
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setTitleColor:[UIColor CMLGray1Color] forState:UIControlStateNormal];
    }
 
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
    
    if (self.costPriceTextField.text.length > 0 && self.costNumTextField.text.length > 0 ) {
      
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
    
    if (self.freeActivityBtn.selected) {
        
        if (self.freeNumTextField.text.length > 0 && self.freeNumTextField.text.length < 3) {
            
            
            [self.activityTicketPriceDelegate outputTicketType:@"免费" number:[self.freeNumTextField.text intValue] price:0];
            [[VCManger mainVC] dismissCurrentVC];
            
        }else{
            
            [self showFailTemporaryMes:@"请输入正确数量"];
        }
        
    }else{
        
        if (self.costNumTextField.text.length > 0 && self.costNumTextField.text.length < 3) {
            
            [self.activityTicketPriceDelegate outputTicketType:@"收费" number:[self.costNumTextField.text intValue] price:[self.costPriceTextField.text intValue]];
                [[VCManger mainVC] dismissCurrentVC];
            
        }else{
            
            [self showFailTemporaryMes:@"请输入正确数量"];
        }
    }
}
@end
