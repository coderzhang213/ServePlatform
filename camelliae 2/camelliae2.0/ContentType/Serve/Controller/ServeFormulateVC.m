//
//  ServeFormulateVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ServeFormulateVC.h"
#import "VCManger.h"


#define ServeFormulateAttributeTopMargin           30
#define ServeFormulateAttributeBottomMargin        20
#define ServeFormulateMarkLineLength               100
#define ServeFormulateMarkLineWidth                4
#define ServeFormulateAttributeContentTopMargin    30
#define ServeFormulateAttributeContentBottomMargin 30
#define ServeFormulateAttributeContentSpace        30
#define ServeFormulateAttributeContentLeftMargin   30
#define ServeFormulateAttributeContentHeight       52
#define ServeFormulateAttributeContentLeftAndRight 30

#define ServeFormulateAttributeLastContentBottomMargin 100
@interface ServeFormulateVC ()<NavigationBarProtocol,UITextViewDelegate,NetWorkProtocol>

@property (nonatomic,strong) UIView *markLine;

@property (nonatomic,strong) NSArray *attributeNameArray;

@property (nonatomic,strong) UIView *attributeBgView;

@property (nonatomic,strong) NSArray *attributeContentArray;

@property (nonatomic,assign) int currentTag;

@property (nonatomic,strong) UITextView *otherAsking;

@property (nonatomic,strong) UIView *otherView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UILabel *promptLabel;

@property (nonatomic,strong) NSMutableDictionary *formulateDic;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation ServeFormulateVC

- (NSMutableDictionary *)formulateDic{

    if (!_formulateDic) {
        _formulateDic = [NSMutableDictionary dictionary];
    }
    return _formulateDic;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [MobClick endLogPageView:@"PageThreeOfServeFormulateVC"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [MobClick beginLogPageView:@"PageThreeOfServeFormulateVC"];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"定制你的专属旅程";
    [self.navBar setLeftBarItem];

    [self loadMessageOfVC];
    
    __weak typeof(self) weakSlef = self;
    self.refreshViewController = ^(){
    
        [weakSlef hideNetErrorTipOfNormalVC];
        [weakSlef loadMessageOfVC];
        
    
    };

}

- (void) loadMessageOfVC{

    self.currentTag = 0;
    [self loadViews];

}

- (void) loadViews{

    /**属性按键*/
    _attributeNameArray = @[@"地点",@"主题",@"预算",@"时间"];
    _attributeContentArray = @[@"摩纳哥",@"日本",@"新加坡",@"美国",@"法国",@"克罗地亚",@"柬埔寨",@"英国",@"意大利",@"巴西",@"肯尼亚",@"蒙古",@"葡萄牙",@"不丹",@"备注其他"];
    
    self.mainScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(self.navBar.frame),
                                                                          WIDTH,
                                                                          HEIGHT - CGRectGetMaxY(self.navBar.frame))];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mainScrollView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"初始化";
    label.font = KSystemFontSize12;
    [label sizeToFit];
    
    for (int i = 0; i < _attributeNameArray.count; i++) {
        UIButton *attributeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/_attributeNameArray.count*i,
                                                                            0,
                                                                            WIDTH/_attributeNameArray.count,
                                                                            label.frame.size.height + (ServeFormulateAttributeTopMargin + ServeFormulateAttributeBottomMargin)*Proportion)];
        attributeBtn.tag = i;
        [attributeBtn setTitle:_attributeNameArray[i] forState:UIControlStateNormal];
        attributeBtn.titleLabel.font = KSystemFontSize12;
        [attributeBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
        [attributeBtn addTarget:self action:@selector(changeServeAttribute:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:attributeBtn];
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(0,label.frame.size.height + (ServeFormulateAttributeTopMargin + ServeFormulateAttributeBottomMargin)*Proportion);
    line.lineWidth = 0.5;
    line.lineLength = WIDTH;
    line.LineColor = [UIColor CMLPromptGrayColor];
    [self.mainScrollView addSubview:line];
    
    self.markLine = [[UIView alloc] init];
    self.markLine.backgroundColor = [UIColor CMLYellowColor];
    self.markLine.frame = CGRectMake(WIDTH/_attributeNameArray.count/2.0 - ServeFormulateMarkLineLength*Proportion/2.0,
                                     label.frame.size.height + (ServeFormulateAttributeTopMargin + ServeFormulateAttributeBottomMargin)*Proportion - ServeFormulateMarkLineWidth*Proportion + 0.5,
                                     ServeFormulateMarkLineLength*Proportion,
                                     ServeFormulateMarkLineWidth*Proportion);
    [self.mainScrollView addSubview:self.markLine];
    
    [self setCurrentAttributeBgView];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.startingPoint = CGPointMake(0,CGRectGetMaxY(self.attributeBgView.frame));
    bottomLine.lineWidth = 1;
    bottomLine.lineLength = WIDTH;
    bottomLine.LineColor = [UIColor CMLPromptGrayColor];
    [self.mainScrollView addSubview:bottomLine];
    
    self.otherView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(self.attributeBgView.frame),
                                                              WIDTH,
                                                              HEIGHT - CGRectGetMaxY(self.attributeBgView.frame))];
    self.otherView.userInteractionEnabled = YES;
    [self.mainScrollView addSubview:self.otherView];
    
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 双击
    [self.otherView addGestureRecognizer:singleRecognizer];
    
    UILabel *other = [[UILabel alloc] init];
    other.text = @"备注：";
    other.font = KSystemFontSize12;
    other.textColor = [UIColor CMLUserBlackColor];
    [other sizeToFit];
    other.frame = CGRectMake(ServeFormulateAttributeContentLeftMargin*Proportion,
                             ServeFormulateAttributeLastContentBottomMargin*Proportion,
                             other.frame.size.width,
                             other.frame.size.height);
    [self.otherView addSubview:other];
    
    _otherAsking = [[UITextView alloc] initWithFrame:CGRectMake(ServeFormulateAttributeContentLeftMargin*Proportion,
                                                                CGRectGetMaxY(other.frame) + 20*Proportion,
                                                                WIDTH - ServeFormulateAttributeContentLeftMargin*Proportion*2,
                                                                280*Proportion)];
    _otherAsking.layer.borderWidth = 1;
    _otherAsking.delegate = self;
    _otherAsking.font = KSystemFontSize12;
    _otherAsking.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    [self.otherView addSubview:_otherAsking];
    
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.text = @"如果还有其他要求请在这里详细填写吧";
    self.promptLabel.font = KSystemFontSize12;
    self.promptLabel.textColor = [UIColor CMLPromptGrayColor];
    [self.promptLabel sizeToFit];
    self.promptLabel.frame = CGRectMake(ServeFormulateAttributeContentLeftMargin*Proportion + 20*Proportion,
                                        CGRectGetMaxY(other.frame) + 40*Proportion,
                                        self.promptLabel.frame.size.width,
                                        self.promptLabel.frame.size.height);
    [self.otherView addSubview:self.promptLabel];
    
    
    UIButton *confirmAskingBtn = [[UIButton alloc] init];
    [confirmAskingBtn setTitle:@"提交" forState:UIControlStateNormal];
    confirmAskingBtn.titleLabel.font = KSystemFontSize17;
    confirmAskingBtn.backgroundColor = [UIColor CMLYellowColor];
    [confirmAskingBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [confirmAskingBtn sizeToFit];
    confirmAskingBtn.frame = CGRectMake(WIDTH/2.0 - (confirmAskingBtn.frame.size.width + 60*Proportion*2)/2.0,
                                        CGRectGetMaxY(_otherAsking.frame) + 78*Proportion,
                                        confirmAskingBtn.frame.size.width + 60*Proportion*2 ,
                                        60*Proportion);
    confirmAskingBtn.layer.cornerRadius = 60*Proportion/2.0;
    [self.otherView addSubview:confirmAskingBtn];
    [confirmAskingBtn addTarget:self action:@selector(confirmServeFormulate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) setCurrentAttributeBgView{
    
    [self.attributeBgView removeFromSuperview];
    
    self.attributeBgView = [[UIView alloc] init];
    [self.mainScrollView addSubview:self.attributeBgView];
    
    int currentLeftMargin = ServeFormulateAttributeContentLeftMargin*Proportion;
    int lineNum = 0;
    int queueNum = 0;
    
    for (int i = 0 ; i < self.attributeContentArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.attributeContentArray[i] forState:UIControlStateNormal];
        if ([self.attributeContentArray[i] isEqualToString:@"备注其他"]) {
            button.userInteractionEnabled = NO;
        }
        button.titleLabel.font = KSystemFontSize12;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
        button.layer.cornerRadius = ServeFormulateAttributeContentHeight*Proportion/2.0;
        [button setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateSelected];
        [button sizeToFit];
        button.tag = 100*self.currentTag+i;
        /***formulateContent**/
        if ([button.titleLabel.text isEqualToString:[self.formulateDic valueForKey:self.attributeNameArray[self.currentTag]]]) {
            
            button.selected = YES;
            button.backgroundColor = [UIColor CMLYellowColor];
            button.layer.borderColor = [UIColor clearColor].CGColor;
        }
        /****/
        [button addTarget:self action:@selector(selectedFormulateStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        if ((currentLeftMargin + (button.frame.size.width + ServeFormulateAttributeContentLeftAndRight*Proportion*2 + ServeFormulateAttributeContentSpace*Proportion)) < (WIDTH - ServeFormulateAttributeContentLeftMargin*Proportion)) {
            button.frame = CGRectMake(currentLeftMargin,
                                      ServeFormulateAttributeContentTopMargin*Proportion + (ServeFormulateAttributeContentHeight + ServeFormulateAttributeContentBottomMargin)*Proportion*lineNum,
                                      button.frame.size.width + ServeFormulateAttributeContentLeftAndRight*Proportion*2,
                                      ServeFormulateAttributeContentHeight*Proportion);
            queueNum++;
            
        }else{
            currentLeftMargin = ServeFormulateAttributeContentLeftMargin*Proportion;
            lineNum ++;
            queueNum = 0;
            button.frame = CGRectMake(currentLeftMargin,
                                      ServeFormulateAttributeContentTopMargin*Proportion + (ServeFormulateAttributeContentHeight + ServeFormulateAttributeContentBottomMargin)*Proportion*lineNum,
                                      button.frame.size.width + ServeFormulateAttributeContentLeftAndRight*Proportion*2,
                                      ServeFormulateAttributeContentHeight*Proportion);
        }
        [self.attributeBgView addSubview:button];
        currentLeftMargin =  currentLeftMargin + button.frame.size.width + ServeFormulateAttributeContentSpace*Proportion;
        
        if (i == self.attributeContentArray.count - 1) {
            self.attributeBgView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.markLine.frame),
                                                    WIDTH,
                                                    CGRectGetMaxY(button.frame) + ServeFormulateAttributeLastContentBottomMargin*Proportion);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - changeServeAttribute
- (void) changeServeAttribute:(UIButton *) button{

    self.currentTag = (int)button.tag;
    [UIView animateWithDuration:0.2 animations:^{
        self.markLine.frame = CGRectMake(WIDTH/_attributeNameArray.count/2.0 - ServeFormulateMarkLineLength*Proportion/2.0 + WIDTH/_attributeNameArray.count*button.tag,
                                         self.markLine.frame.origin.y,
                                         ServeFormulateMarkLineLength*Proportion,
                                         ServeFormulateMarkLineWidth*Proportion);
    } completion:^(BOOL finished) {
        
        if (self.currentTag == 0) {
            _attributeContentArray = @[@"摩纳哥",@"日本",@"新加坡",@"美国",@"法国",@"克罗地亚",@"柬埔寨",@"英国",@"意大利",@"巴西",@"肯尼亚",@"蒙古",@"葡萄牙",@"不丹",@"备注其他"];
        }else if (self.currentTag == 1){
            _attributeContentArray = @[@"时尚之旅",@"商务游",@"观光游",@"主题游",@"蜜月行",@"避暑避寒",@"顶级奢华",@"游轮度假",@"浪漫海岛",@"备注其他"];
        }else if (self.currentTag == 2){
            _attributeContentArray = @[@"0-1万元",@"1-3万元",@"3-5万元",@"5-10万元",@"10-20万元",@"20万元以上",@"备注其他"];
        }else if (self.currentTag == 3){
            _attributeContentArray = @[@"5天以内",@"5-10天",@"10-15天",@"15-20天",@"一个月",@"两个月",@"备注其他"];
        }
         [self setCurrentAttributeBgView];
    }];
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) keyboardWasShown:(NSNotification*)noti{

    NSDictionary *info = [noti userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    self.mainScrollView.contentOffset = CGPointMake(0, keyboardSize.height);
    
}

- (void) keyboardWillBeHidden{

    self.mainScrollView.contentOffset = CGPointMake(0,0);
}

- (void) handleDoubleTapFrom{

    [self.otherAsking resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length > 0) {
        self.promptLabel.text = @"";
    }else{
        self.promptLabel.text = @"如果还有其他要求请在这里详细填写吧";
    }
}

- (void) selectedFormulateStyle:(UIButton *) button{

    button.selected = !button.selected;
    
    if (button.selected) {
        button.backgroundColor = [UIColor CMLYellowColor];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [self.formulateDic setObject:button.titleLabel.text forKey:self.attributeNameArray[self.currentTag]];
    }else{
        button.backgroundColor = [UIColor CMLWhiteColor];
        button.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
        [self.formulateDic removeObjectForKey:self.attributeNameArray[self.currentTag]];
    }
    
    [self setCurrentAttributeBgView];
    
}

- (void) confirmServeFormulate{

    if (self.otherAsking.text.length > 0 || [self.formulateDic allValues].count > 0) {
        
        [self setServeFormulateRequest];
        
    }else{
        [self showFailTemporaryMes:@"您未填写任何订制内容"];
    }
}

- (void) setServeFormulateRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    if ([self.formulateDic valueForKey:@"地点"]) {
        [paraDic setObject:[NSNumber getServeFormulateAddressIDFrom:[self.formulateDic valueForKey:@"地点"]] forKey:@"addressId"];
    }
    
    if ([self.formulateDic valueForKey:@"主题"]) {
        
        [paraDic setObject:[NSNumber getServeFormulateTopicIDFrom:[self.formulateDic valueForKey:@"主题"]] forKey:@"themeId"];
    }
    
    if ([self.formulateDic valueForKey:@"预算"]) {
        [paraDic setObject:[NSNumber getServeFormulateBudgetIDFrom:[self.formulateDic valueForKey:@"预算"]] forKey:@"budgetId"];
    }
    
    if ([self.formulateDic valueForKey:@"时间"]) {
        [paraDic setObject:[NSNumber getServeFormulateTimeIDFrom:[self.formulateDic valueForKey:@"时间"]] forKey:@"periodId"];
    }
    
    if (self.otherAsking.text.length > 0 ) {
        [paraDic setObject:self.otherAsking.text forKey:@"userNote"];
    }
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ServeFormulate paraDic:paraDic delegate:delegate];
    self.currentApiName = ServeFormulate;
    [self startIndicatorLoading];
    
    /**放弃第一响应者*/
    [self.otherAsking resignFirstResponder];
    
    [CMLMobClick formulateEvent];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ServeFormulate]) {
       
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self showSuccessTemporaryMes:@"订制成功"];
            [self.formulateDic removeAllObjects];
            self.otherAsking.text = @"";
            [self.otherAsking resignFirstResponder];
            [self setCurrentAttributeBgView];
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{


    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopIndicatorLoading];
    [self showNetErrorTipOfNormalVC];

}

@end
