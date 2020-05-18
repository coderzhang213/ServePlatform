//
//  MemberEquityDetailView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import "MemberEquityDetailView.h"
#import "MemberSalonTableView.h"
#import "NetConfig.h"
#import "AppGroup.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>
#import "ActivityAppointmentMessageView.h"

#define TableViewCellHeight  146 * Proportion

@interface MemberEquityDetailView ()<NetWorkProtocol, MemberSalonTableViewDelegate>

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) MemberSalonTableView *salonTableView;

@property (nonatomic, strong) UIView *appointmentView;

@property (nonatomic, strong) UIView *appointmentHalfView;

@property (nonatomic, strong) UIButton *appointmentButton;

@property (nonatomic, strong) UILabel *appointmentLabel;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *contentUrl;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation MemberEquityDetailView

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withLocation:(NSString *)location {
    
    self = [super init];
    if (self) {
        self.location = location;
        self.frame = frame;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8 * Proportion;
        self.userInteractionEnabled = YES;
        self.delegate = (id)self;
        [self loadData];
    }
    return self;
}

- (void)loadEquityDetailView {
    
    [self addSubview:self.deleteButton];
    [self addSubview:self.topImageView];
    
    /*banner + 权益说明*/
    if ([self.location intValue] == 1) {
        
        self.topImageView.image = [UIImage imageNamed:CMLMemberEquityExclusiveImage];
        [self customGiftEquityContent];
        
    }else if ([self.location intValue] == 2) {
        
        self.topImageView.image = [UIImage imageNamed:CMLMemberEquityShareMallImage];
        [self customGiftEquityContent];
        
    }else if ([self.location intValue] == 3) {
        
        self.topImageView.image = [UIImage imageNamed:CMLMemberEquityDiscountCardImage];
        [self customGiftEquityContent];
        
    }else if ([self.location intValue] == 4) {
        
        self.topImageView.image = [UIImage imageNamed:CMLMemberEquitySalonImage];
        [self fashionSalonEquityContent];
        
    }else if ([self.location intValue] == 5){
        
        self.topImageView.image = [UIImage imageNamed:CMLMemberEquityHousekeeperImage];
        [self loadMemberNumAppointmentData];
        
    }else {
        [self.delegate cancelMemberEquityDetailView];
    }
    
    /*权益内容*/
    UIImageView *equityContentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberEquityContentImage]];
    equityContentIcon.backgroundColor = [UIColor clearColor];
    [equityContentIcon sizeToFit];
    equityContentIcon.frame = CGRectMake(48 * Proportion,
                                         CGRectGetMaxY(self.topImageView.frame) + 58 * Proportion,
                                         CGRectGetWidth(equityContentIcon.frame),
                                         CGRectGetHeight(equityContentIcon.frame));
    [self addSubview:equityContentIcon];
    
    UILabel *equityContentLabel = [[UILabel alloc] init];
    equityContentLabel.text = @"权益内容";
    equityContentLabel.textColor = [UIColor blackColor];
    equityContentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [equityContentLabel sizeToFit];
    equityContentLabel.frame = CGRectMake(CGRectGetMaxX(equityContentIcon.frame) + 20*Proportion,
                                          CGRectGetMidY(equityContentIcon.frame) - CGRectGetHeight(equityContentLabel.frame)/2,
                                          CGRectGetWidth(equityContentLabel.frame),
                                          CGRectGetHeight(equityContentLabel.frame));
    [self addSubview:equityContentLabel];
    
}


- (void)customGiftEquityContent {
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.backgroundColor = [UIColor clearColor];
    NSLog(@"%@", self.location);
    
    webView.frame = CGRectMake(48 * Proportion,
                               CGRectGetMaxY(self.topImageView.frame) + 121 * Proportion,
                               CGRectGetWidth(self.frame) - 2 * 48 * Proportion,
                               CGRectGetHeight(self.frame) - CGRectGetMaxY(self.topImageView.frame) - 121 * Proportion - 127 * Proportion);

    webView.scrollView.bounces = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    NSURL *url = [NSURL URLWithString:self.contentUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self addSubview:webView];

}

- (void)refreshFashionSalonEquityContent {
    
    [self fashionSalonEquityContent];
    
}

- (void)fashionSalonEquityContent {

    self.salonTableView = [[MemberSalonTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame) + 115 * Proportion, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.topImageView.frame) - 115 * Proportion - 127 * Proportion)];
    
    self.salonTableView.tableHeaderView = [[UIView alloc] init];
    self.salonTableView.salonDelegate = (id)self;
    if (@available(iOS 11.0, *)){
        self.salonTableView.estimatedRowHeight = 0;
        self.salonTableView.estimatedSectionHeaderHeight = 0;
        self.salonTableView.estimatedSectionFooterHeight = 0;
    }
    
    self.salonTableView.showsVerticalScrollIndicator = NO;
    self.salonTableView.showsHorizontalScrollIndicator = NO;

    [self creatWebView];

    [self addSubview:self.salonTableView];
}

- (void)housekeeperEquityContent {
    
    [self addSubview:self.appointmentView];
    [self.appointmentView addSubview:self.appointmentHalfView];
    self.appointmentLabel.text = [NSString stringWithFormat:@"剩余 %@ 次", self.num];//@"剩余  次";/*appointmentLabel剩余次数*/
    [self.appointmentView addSubview:self.appointmentLabel];
    
    UILabel *appointTitleLabel = [[UILabel alloc] init];
    appointTitleLabel.backgroundColor = [UIColor clearColor];
    appointTitleLabel.text = @"私人管家预约服务";
    appointTitleLabel.textColor = [UIColor CMLIntroGrayColor];
    appointTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [appointTitleLabel sizeToFit];
    appointTitleLabel.frame = CGRectMake(20 * Proportion,
                                         CGRectGetHeight(self.appointmentHalfView.frame)/2 - CGRectGetHeight(appointTitleLabel.frame)/2,
                                         CGRectGetWidth(appointTitleLabel.frame),
                                         CGRectGetHeight(appointTitleLabel.frame));
    [self.appointmentHalfView addSubview:appointTitleLabel];
    
    [self.appointmentHalfView addSubview:self.appointmentButton];
    
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.backgroundColor = [UIColor clearColor];

    webView.frame = CGRectMake(48 * Proportion,
                               CGRectGetMaxY(self.appointmentView.frame) + 53 * Proportion,
                               CGRectGetWidth(self.frame) - 2 * 48 * Proportion,
                               CGRectGetHeight(self.frame) - CGRectGetMaxY(self.appointmentView.frame) - 53 * Proportion - 127 * Proportion);
    NSLog(@"%f\n%f", CGRectGetWidth(self.frame) - 2 * 48 * Proportion, webView.frame.size.width);
    webView.scrollView.bounces = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    NSURL *url = [NSURL URLWithString:self.contentUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self addSubview:webView];
    
}

- (void)deleteButtonClick {
    
    [self.delegate cancelMemberEquityDetailView];
    
}

/*预约按钮*/
- (void)appointmentButtonClicked {
    
    if ([self.num intValue] != 0) {
        [self.delegate chooseAppointment];
    }
    
}

- (void)creatWebView {
    
    self.webView = [[WKWebView alloc] init];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.alwaysBounceHorizontal = NO;
    [self.webView setOpaque:NO];/*设置不透明*/
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrl]]];

    self.webView.frame = CGRectMake(0 * Proportion, 20 * Proportion, CGRectGetWidth(self.frame) - 2 * 48 * Proportion, 610);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(48 * Proportion,
                                                            0,
                                                            CGRectGetWidth(self.frame) - 2 * 48 * Proportion,
                                                            610)];
    [view addSubview:self.webView];

    self.salonTableView.tableFooterView = view;
    
    /*监听self.webView的属性变化*/
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"MemberEquityWebView"];
    
}

/*监听到属性变化*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if (!self.webView.isLoading) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {

            if ([self.location intValue] == 4) {
                
                self.webView.frame = CGRectMake(48 * Proportion, 20 * Proportion, CGRectGetWidth(self.frame) - 2 * 48 * Proportion, self.webView.scrollView.contentSize.height);
                NSLog(@"%f", self.webView.frame.size.height);
                self.salonTableView.tableFooterView = self.webView;
                /*先更新webView的高，重新赋值给tableFooterView，最后需要再重新约束webview的宽*/
                self.webView.frame = CGRectMake(48 * Proportion, CGRectGetMinY(self.salonTableView.tableFooterView.frame) + 20 * Proportion, CGRectGetWidth(self.frame) - 2 * 48 * Proportion, self.webView.scrollView.contentSize.height);
            }
        }
    }
    /*移除监听*/
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize" context:@"MemberEquityWebView"];
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLMemberEquityExclusiveImage]];
        _topImageView.clipsToBounds = YES;
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.backgroundColor = [UIColor clearColor];
        [_topImageView sizeToFit];
        _topImageView.frame = CGRectMake(0, 0, 602 * Proportion, 164 * Proportion);//CGRectGetWidth(_topImageView.frame), CGRectGetHeight(_topImageView.frame));
    }
    return _topImageView;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor clearColor];
        _deleteButton.userInteractionEnabled = YES;
        [_deleteButton setImage:[UIImage imageNamed:CMLMemberEquityDelleteImage] forState:UIControlStateNormal];
        [_deleteButton sizeToFit];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(_deleteButton.frame)/2,
                                         CGRectGetHeight(self.frame) - CGRectGetHeight(_deleteButton.frame) - 42 * Proportion,
                                         CGRectGetWidth(_deleteButton.frame),
                                         CGRectGetHeight(_deleteButton.frame));
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIView *)appointmentView {
    
    if (!_appointmentView) {
        _appointmentView = [[UIView alloc] initWithFrame:CGRectMake(48 * Proportion,
                                                                    CGRectGetHeight(self.topImageView.frame) + 126 * Proportion,
                                                                    CGRectGetWidth(self.frame) - 48 * Proportion * 2,
                                                                    126 * Proportion)];
        _appointmentView.backgroundColor = [UIColor whiteColor];
        _appointmentView.userInteractionEnabled = YES;
        _appointmentView.clipsToBounds = YES;
        _appointmentView.layer.cornerRadius = 8 * Proportion;
        _appointmentView.layer.borderColor = [UIColor CMLFBE3AFColor].CGColor;
        _appointmentView.layer.borderWidth = 1 * Proportion;

    }
    return _appointmentView;
}

- (UIView *)appointmentHalfView {
    
    if (!_appointmentHalfView) {
        _appointmentHalfView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        CGRectGetWidth(self.appointmentView.frame),
                                                                        CGRectGetHeight(self.appointmentView.frame)/2 + 10 * Proportion)];
        _appointmentHalfView.backgroundColor = [UIColor CMLF3E9D3Color];
        _appointmentHalfView.userInteractionEnabled = YES;
    }
    return _appointmentHalfView;
}

- (UILabel *)appointmentLabel {
    
    if (!_appointmentLabel) {
        _appointmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(21 * Proportion,
                                                                      84 * Proportion,
                                                                      100 * Proportion,
                                                                      30 * Proportion)];
        _appointmentLabel.backgroundColor = [UIColor clearColor];
        _appointmentLabel.textColor = [UIColor CML909090Color];
        _appointmentLabel.textAlignment = NSTextAlignmentLeft;
        _appointmentLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _appointmentLabel;
    
}

- (UIButton *)appointmentButton {
    
    if (!_appointmentButton) {
        
        _appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _appointmentButton.backgroundColor = [UIColor blackColor];
        _appointmentButton.clipsToBounds = YES;
        _appointmentButton.layer.cornerRadius = 8 * Proportion;
        [_appointmentButton setTitle:@"立即预约" forState:UIControlStateNormal];
        _appointmentButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        _appointmentButton.frame = CGRectMake(CGRectGetWidth(self.appointmentHalfView.frame) - 20 * Proportion - 129 * Proportion,
                                              CGRectGetHeight(self.appointmentHalfView.frame)/2 - 43 * Proportion/2,
                                              129 * Proportion,
                                              43 * Proportion);
        [_appointmentButton addTarget:self action:@selector(appointmentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentButton;
}

#pragma mark Network

- (void)loadData {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"1" forKey:@"type"];
    [paraDic setObject:self.location forKey:@"location"];
    NSLog(@"%@", self.location);
    [NetWorkTask postResquestWithApiName:MemberCenterEquity paraDic:paraDic delegate:delegate];
    self.currentApiName = MemberCenterEquity;
    
}

- (void)loadMemberNumAppointmentData {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:userID forKey:@"user_id"];
    [NetWorkTask postResquestWithApiName:MemberNumAppointment paraDic:paraDic delegate:delegate];
    self.currentApiName = MemberNumAppointment;
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.currentApiName isEqualToString:MemberNumAppointment]) {
        if ([obj.retCode intValue] == 0) {
            
            self.num = obj.retData.num;
            [self housekeeperEquityContent];
            
        }else {
            
            self.num = @"0";
            
        }
    }else {/*if ([self.currentApiName isEqualToString:MemberCenterEquity])*/
        
        if ([obj.retCode intValue] == 0) {
            
            self.contentUrl = obj.retData.contentUrl;
            [self loadEquityDetailView];
            
        }else {
            
            
        }
    }
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    
}

#pragma mark MemberSalonTableViewDelegate

- (void)refreshFashionSalonEquityWithSalonTable {
    
    [self loadData];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
