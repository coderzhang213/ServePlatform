//
//  CMLProjectVC.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/16.
//  Copyright © 2018 张越. All rights reserved.
//

#import "CMLProjectVC.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"

@interface CMLProjectVC ()<UIScrollViewDelegate,UIWebViewDelegate,NavigationBarProtocol,NetWorkProtocol,UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView *userBgView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) WKWebView *detailView;

@end

@implementation CMLProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    self.navBar.titleContent = @"项目详情";
    [self.navBar hiddenLine];
    [self.navBar setLeftBarItem];
    
    [self loadViews];
}

- (void) setNetWork{
    
    [self startLoading];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    [paraDic setObject:self.objId forKey:@"objId"];
//    NSString *skey = [[DataManager lightData] readSkey];
//    [paraDic setObject:skey forKey:@"skey"];
//    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
//    [paraDic setObject:reqTime forKey:@"reqTime"];
//    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
//    [paraDic setObject:hashToken forKey:@"hashToken"];
//    [NetWorkTask postResquestWithApiName:ActivityInfo paraDic:paraDic delegate:delegate];
//    self.currentApiName = ActivityInfo;
}


- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.mainScrollView];

    
}

- (void) loadUserMessage{
    
    self.userBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.navBar.frame),
                                                               WIDTH,
                                                               160*Proportion)];
    self.userBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.userBgView];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                           160*Proportion/2.0 - 80*Proportion/2.0,
                                                                           80*Proportion,
                                                                           80*Proportion)];
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = 80*Proportion/2.0;
    [self.userBgView addSubview:userImage];
    
    UILabel *userNickNameLab = [[UILabel alloc] init];
    userNickNameLab.font = KSystemBoldFontSize14;
    [userNickNameLab sizeToFit];
    [self.userBgView addSubview:userNickNameLab];
    
    UILabel *userSignature = [[UILabel alloc] init];
    userSignature.font = KSystemFontSize12;
    [userSignature sizeToFit];
    userSignature.textColor = [UIColor CMLLineGrayColor];
    [self.userBgView addSubview:userSignature];
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetHeight(self.userBgView.frame) - 1,
                                                               WIDTH,
                                                               1)];
    endLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.userBgView addSubview:endLine];
    
}

- (void) loadWebView{
    
    UILabel *articleTitleLab = [[UILabel alloc] init];
    articleTitleLab.font = KSystemBoldFontSize15;
    articleTitleLab.textColor = [UIColor CMLBlackColor];
    articleTitleLab.numberOfLines = 0;
    articleTitleLab.text = self.obj.retData.title;
    CGRect currentRect =  [articleTitleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, HEIGHT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:KSystemRealBoldFontSize16}
                                                             context:nil];
    articleTitleLab.frame = CGRectMake(30*Proportion,
                                       30*Proportion + CGRectGetMaxY(self.userBgView.frame),
                                       WIDTH - 30*Proportion*2,
                                       currentRect.size.height);
    [self.mainScrollView addSubview:articleTitleLab];
    
    UIImageView *addressImg = [[UIImageView alloc] init];
    addressImg.contentMode = UIViewContentModeScaleAspectFill;
    addressImg.image = [UIImage imageNamed:ListActivityAddressImg];
    addressImg.clipsToBounds = YES;
    [self.mainScrollView addSubview:addressImg];
    addressImg.frame = CGRectMake(30*Proportion,
                                  CGRectGetMaxY(articleTitleLab.frame) + 20*Proportion,
                                  addressImg.frame.size.width,
                                  addressImg.frame.size.height);
    [self.mainScrollView addSubview:addressImg];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = [UIColor CMLtextInputGrayColor];
    addressLab.font = KSystemFontSize11;
    addressLab.text = self.obj.retData.publishTimeStr;
    [addressLab sizeToFit];
    addressLab.frame = CGRectMake(CGRectGetMaxX(addressImg.frame) + 10*Proportion,
                                  addressImg.center.y - addressLab.frame.size.height/2.0,
                                  addressLab.frame.size.width,
                                  addressLab.frame.size.height);
    [self.mainScrollView addSubview:addressLab];

    self.detailView = [[WKWebView alloc] init];
    self.detailView.backgroundColor = [UIColor CMLWhiteColor];
//    self.detailView.delegate = self;
    self.detailView.frame = CGRectMake(0,
                                       CGRectGetMaxY(addressLab.frame) + 50*Proportion,
                                       WIDTH,
                                       400);
    self.detailView.scrollView.scrollEnabled = NO;
    [self.detailView loadHTMLString:self.obj.retData.content baseURL:nil];
    [self.mainScrollView addSubview:self.detailView];
    
    [self.detailView addObserver:self forKeyPath:@"self.detailView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"self.detailView"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.detailView.isLoading) {
        if ([keyPath isEqualToString:@"self.detailView.contentSize"]) {
            self.detailView.frame = CGRectMake(0,
                                               self.detailView.frame.origin.y,
                                               WIDTH,
                                               self.detailView.scrollView.contentSize.height);
        }
    }
    [self.detailView removeObserver:self forKeyPath:@"self.detailView.contentSize" context:@"self.detailView"];
}

/*
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",WIDTH - 20*Proportion*2];
    
    //添加JS
    [self.detailView stringByEvaluatingJavaScriptFromString:script];
    
    //添加调用JS执行的语句
    [self.detailView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.fontSize= '13px'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str];
    
    
    NSString *str2 = @"document.getElementsByTagName('body')[0].style.color='#333333'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str2];
    CGFloat height = [[self.detailView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.detailView.frame = CGRectMake(webView.frame.origin.x,
                                       webView.frame.origin.y,
                                       WIDTH,
                                       height);
    
    
}
*/

- (void) setLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}
@end
