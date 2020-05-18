//
//  ServeHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/3/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ServeHeaderView.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "CMLLine.h"
#import "CMLMobClick.h"
#import "CommonFont.h"

@interface ServeHeaderView ()<NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic,strong) UIButton *customerServicebtn;

@property (nonatomic,copy) NSString *currentApiName;

@end
@implementation ServeHeaderView
- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight,
                                                              NavigationBarHeight,
                                                              NavigationBarHeight)];
    [self.backBtn setImage:[UIImage imageNamed:GoodsBackImg] forState:UIControlStateNormal];
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                               StatusBarHeight,
                                                               NavigationBarHeight,
                                                               NavigationBarHeight)];
    [self.shareBtn setImage:[UIImage imageNamed:GoodsShareImg] forState:UIControlStateNormal];
    self.shareBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(touchShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.customerServicebtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight*2,
                                                                 StatusBarHeight,
                                                                 NavigationBarHeight,
                                                                 NavigationBarHeight)];
    [self.customerServicebtn setImage:[UIImage imageNamed:GoodsCustomerServiceImg] forState:UIControlStateNormal];
    [self addSubview:self.customerServicebtn];
    [self.customerServicebtn addTarget:self action:@selector(callCurrentTele) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - self.customerServicebtn.frame.origin.x,
                                                              StatusBarHeight,
                                                              WIDTH - 2*(WIDTH - self.customerServicebtn.frame.origin.x),
                                                              NavigationBarHeight)];
    self.titleLab.text = self.obj.retData.title;
    self.titleLab.alpha = 0;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = KSystemBoldFontSize16;
    [self addSubview:self.titleLab];
    

}

- (void) touchBackBtn{
    
    [self.delegate dissCurrentDetailVC];
}

- (void) touchShareBtn{
    
    if (self.obj) {
         [self.delegate showDetailShareMessage];
    }
}

- (void) changeBtnStyleOfLight{
    
    if (self.backgroundColor != [UIColor CMLWhiteColor]) {
      
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.layer.shadowColor = [UIColor CMLBlackColor].CGColor;
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        [self.backBtn setImage:[UIImage imageNamed:GoodsScrollBackImg] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:GoodsScrollShareImg] forState:UIControlStateNormal];
        [self.customerServicebtn setImage:[UIImage imageNamed:GoodsCustomerServiceScrollImg] forState:UIControlStateNormal];
    }
}

- (void) changeBtnStyleOfDefault{
    
    if (self.backgroundColor != [UIColor clearColor]) {
        
        self.backgroundColor = [UIColor clearColor];
       self.layer.shadowColor = [UIColor clearColor].CGColor;
        [self.backBtn setImage:[UIImage imageNamed:GoodsBackImg] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:GoodsShareImg] forState:UIControlStateNormal];
        [self.customerServicebtn setImage:[UIImage imageNamed:GoodsCustomerServiceImg] forState:UIControlStateNormal];
    }

    
}

/*呼叫电话*/
- (void) callCurrentTele{
    
    [CMLMobClick Customerservice];
    
    if (self.isGoods) {
      
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.obj.retData.officialMobile];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.superview addSubview:callWebview];
    }else{
     
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.obj.retData.projectContact];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.superview addSubview:callWebview];
        
    }
    
}
@end
