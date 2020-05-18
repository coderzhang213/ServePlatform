//
//  CMLFeedBackVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/8/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLFeedBackVC.h"
#import "VCManger.h"

@interface CMLFeedBackVC ()<NavigationBarProtocol,UITextViewDelegate,NetWorkProtocol>

@property (nonatomic,strong) UITextView *mainTextView;

@property (nonatomic,strong) UILabel *promptLabel;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"意见反馈";
    [self.navBar setLeftBarItem];
    [self.navBar setRightBarItemWith:@"提交"];
    self.contentView.backgroundColor = [UIColor CMLUserGrayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    /**********************************/
    
    [self loadViews];
    
}

- (void) loadViews{

    self.mainTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                     WIDTH,
                                                                     HEIGHT/3.0)];
    self.mainTextView.delegate = self;
    self.mainTextView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.mainTextView];
    
    /**提示字*/
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.text = @"说点什么吧";
    self.promptLabel.font = KSystemFontSize14;
    self.promptLabel.textColor = [UIColor CMLPromptGrayColor];
    [self.promptLabel sizeToFit];
    self.promptLabel.frame = CGRectMake(15*Proportion,
                                        15*Proportion,
                                        self.promptLabel.frame.size.width,
                                        self.promptLabel.frame.size.height);
    [self.mainTextView addSubview:self.promptLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.mainTextView.text.length > 0) {
        self.promptLabel.text = @"";
    }else{
        self.promptLabel.text = @"说点什么吧";
    }
}
#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) didSelectedRightBarItem{
    
    if (!self.mainTextView.isFirstResponder) {
        [self.mainTextView becomeFirstResponder];
    }else{
        if (self.mainTextView.text.length > 0) {
            
            [self setFeedbackRequest];
            
        }else{
            [self showFailTemporaryMes:@"请输入您的建议或意见"];
        }
    }
}

- (void) setFeedbackRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.mainTextView.text forKey:@"content"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    if ([[DataManager lightData] readPhone]) {
        [paraDic setObject:[[DataManager lightData] readPhone] forKey:@"contact"];
    }
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:FeedBack paraDic:paraDic delegate:delegate];
    self.currentApiName = FeedBack;
    [self startIndicatorLoading];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.mainTextView resignFirstResponder];
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0 && obj) {
        [self showSuccessTemporaryMes:@"我们将会仔细阅读您的宝贵意见"];
        self.mainTextView.text = @"";
        self.promptLabel.text = @"说点什么吧";
        [self.mainTextView resignFirstResponder];
    }else if ([obj.retCode intValue] == 100101){
        
        [self stopLoading];
        [self showReloadView];
        
    }else{
        [self showFailTemporaryMes:@"提交失败"];
    }
    
    [self stopIndicatorLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopIndicatorLoading];
    [self stopLoading];
}
@end
