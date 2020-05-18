//
//  CMLUserProjectDetailVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLUserProjectDetailVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "CMLImageObj.h"
#import "CMLVIPNewsImageShowVC.h"
#import "ProjectInfoObj.h"
#import "ActivityDefaultVC.h"
#import "UITextView+Placeholder.h"
#import "LikeTimeLineView.h"
#import "DetailMessageCommentListView.h"
#import "WKWebView+CMLExspand.h"
#import "NewCardView.h"
#import "NSString+CMLExspand.h"
#import "CMLVIPNewDetailVC.h"

#define CommemtListVCTextInputTopMargin    40
#define CommemtListVCTextInputLeftMargin   30
#define CommemtListVCTextInputBtnTopMargin 26

@interface CMLUserProjectDetailVC ()<NavigationBarProtocol,NetWorkProtocol,UITextViewDelegate,NewCardViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>


@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *likebtn;

@property (nonatomic,strong) UIView *commentInputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIButton *pushBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) LikeTimeLineView *likeTimeLineView;

@property (nonatomic,strong) DetailMessageCommentListView *detailMessageCommentListView;

@property (nonatomic,strong) UIWebView *detailView;

@property (nonatomic,assign) BOOL firstRequest;

@property (nonatomic,assign) BOOL isLikeRefresh;

@property (nonatomic,assign) BOOL isCommentRefresh;




@end

@implementation CMLUserProjectDetailVC


- (instancetype)initWithObj:(NSNumber *) objID{
    
    self = [super init];
    
    if (self) {
        
        self.currentID = objID;
        
        
    }
    
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.delegate = self;
    self.navBar.titleContent = @"项目详情";
    [self.navBar setLeftBarItem];
    [self.navBar setNewShareBarItem];
    
    [self loadViews];
    
    [self setDetailMessageRequest];
}

- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - 80*Proportion - 10*Proportion - SafeAreaBottomHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.delegate = self;
    [self.contentView addSubview:self.mainScrollView];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.shadowView.alpha = 0;
    [self.contentView addSubview:self.shadowView];
    
    
    /**输入底板*/
    self.commentInputView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     HEIGHT,
                                                                     WIDTH,
                                                                     HEIGHT/4)];
    self.commentInputView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.commentInputView];
    
}

- (void) loadBottomBtnView{
    
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  HEIGHT - 80*Proportion - SafeAreaBottomHeight,
                                                                  WIDTH,
                                                                  80*Proportion)];
        [self.contentView addSubview:bgView];
        bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        bgView.layer.shadowOpacity = 0.05;
        bgView.layer.shadowOffset = CGSizeMake(0, 0);
        
        self.likebtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH/2.0,
                                                                  80*Proportion)];
        self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
        [self.likebtn setTitle:[NSString stringWithFormat:@"%@",self.obj.retData.likeNum] forState:UIControlStateNormal];
        [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        self.likebtn.titleLabel.font = KSystemFontSize12;
        [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
        [bgView addSubview:self.likebtn];
        
        if ([self.obj.retData.isUserLike intValue] == 1) {
            
            self.likebtn.selected = YES;
        }
        [self.likebtn addTarget:self action:@selector(changeLikeState:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *commentbtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0,
                                                                          0,
                                                                          WIDTH/2.0,
                                                                          80*Proportion)];
        commentbtn.backgroundColor = [UIColor CMLWhiteColor];
        [commentbtn setImage:[UIImage imageNamed:DetailMessageCommentImg] forState:UIControlStateNormal];
        [commentbtn setTitle:[NSString stringWithFormat:@"%@",self.obj.retData.commentCount] forState:UIControlStateNormal];
        [commentbtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        commentbtn.titleLabel.font = KSystemFontSize12;
        [commentbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [commentbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
        [bgView addSubview:commentbtn];
        [commentbtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 1/2.0,
                                                                      80*Proportion/2.0 - 40*Proportion/2.0,
                                                                      1,
                                                                      40*Proportion)];
        centerLine.backgroundColor = [UIColor CMLNewGrayColor];
        [bgView addSubview:centerLine];
        
}

- (void)loadDetailMessage{
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = KSystemBoldFontSize15;
    titleLab.numberOfLines = 0;
    titleLab.text = self.obj.retData.timelineProjectTitle;
    CGRect currentRect = [titleLab.text boundingRectWithSize:CGSizeMake(WIDTH - 20*Proportion*2, HEIGHT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:KSystemBoldFontSize15}
                                                     context:nil];
    titleLab.frame = CGRectMake(20*Proportion,
                                160*Proportion,
                                WIDTH - 20*Proportion*2,
                                currentRect.size.height);
    [self.mainScrollView addSubview:titleLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = KSystemFontSize12;
    timeLab.textColor = [UIColor CMLtextInputGrayColor];
    timeLab.text = self.obj.retData.publishTimeStr;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(20*Proportion,
                               CGRectGetMaxY(titleLab.frame) + 20*Proportion,
                               timeLab.frame.size.width,
                               timeLab.frame.size.height);
    [self.mainScrollView addSubview:timeLab];
    
    self.detailView = [[UIWebView alloc] init];

    self.detailView.delegate = self;
    self.detailView.frame = CGRectMake(0,
                                    CGRectGetMaxY(timeLab.frame) + 40*Proportion,
                                    WIDTH,
                                    400);
    self.detailView.scrollView.scrollEnabled = NO;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self.obj.retData.content options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    [self.detailView loadHTMLString:decodedString baseURL:nil];
    
    
    [self.mainScrollView addSubview:self.detailView];
    


}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.fontSize= '13px'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str];
    

    NSString *str2 = @"document.getElementsByTagName('body')[0].style.color='#333333'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str2];
    CGFloat height = [[self.detailView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.detailView.frame = CGRectMake(webView.frame.origin.x,
                                       webView.frame.origin.y,
                                       WIDTH,
                                       height);
    
    [self loadOtherViews];
    
}

- (void) loadOtherViews{

    self.likeTimeLineView = [[LikeTimeLineView alloc] initWithObj:self.obj];
    self.likeTimeLineView.frame = CGRectMake(0,
                                                 CGRectGetMaxY(self.detailView.frame),
                                                 WIDTH,
                                                 self.likeTimeLineView.currentHeight);
    [self.mainScrollView addSubview:self.likeTimeLineView];
    
    self.detailMessageCommentListView = [[DetailMessageCommentListView alloc] initWithObj:self.obj];
    self.detailMessageCommentListView.frame = CGRectMake(0,
                                                         CGRectGetMaxY(self.likeTimeLineView.frame),
                                                         WIDTH,
                                                         self.detailMessageCommentListView.currentHeight);
    [self.mainScrollView addSubview:self.detailMessageCommentListView];
    
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailMessageCommentListView.frame));
    
    [self stopLoading];
}


- (CGFloat) loadPusherView{
    
    UIView *pusherBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    WIDTH,
                                                                    140*Proportion)];
    pusherBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:pusherBgView];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                           140*Proportion/2.0 - 80*Proportion/2.0,
                                                                           80*Proportion,
                                                                           80*Proportion)];
    userImage.backgroundColor = [UIColor CMLPromptGrayColor];
    userImage.layer.cornerRadius = 80*Proportion/2.0;
    userImage.clipsToBounds = YES;
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.userInteractionEnabled = YES;
    [pusherBgView addSubview:userImage];
    
    [NetWorkTask setImageView:userImage WithURL:self.obj.retData.gravatar placeholderImage:nil];
    
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.font = KSystemFontSize14;
    userNameLab.text = self.obj.retData.nickName;
    [userNameLab sizeToFit];
    userNameLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                   userImage.center.y - 10*Proportion/2.0 - userNameLab.frame.size.height,
                                   userNameLab.frame.size.width,
                                   userNameLab.frame.size.height);
    [pusherBgView addSubview:userNameLab];
    
    UIButton *enterBtn  =[[UIButton alloc] initWithFrame:userImage.bounds];
    enterBtn.backgroundColor = [UIColor clearColor];
    [userImage addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(enterDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *sig = [[UILabel alloc] init];
    sig.font = KSystemFontSize12;
    sig.textColor =[UIColor CMLLineGrayColor];
    sig.textAlignment = NSTextAlignmentLeft;
    sig.text = self.obj.retData.signature;
    [sig sizeToFit];
    [pusherBgView addSubview:sig];
    
    if (self.obj.retData.signature.length == 0) {
        
        userNameLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                       userImage.center.y  - userNameLab.frame.size.height/2.0,
                                       userNameLab.frame.size.width,
                                       userNameLab.frame.size.height);
    }
    
    UIImageView *lvlImg = [[UIImageView alloc] init];
    [pusherBgView addSubview:lvlImg];
    switch ([self.obj.retData.memberLevel intValue]) {
        case 1:
            lvlImg.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
        case 2:
            lvlImg.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
        case 3:
            lvlImg.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
        case 4:
            lvlImg.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    [lvlImg sizeToFit];
    lvlImg.frame = CGRectMake(CGRectGetMaxX(userNameLab.frame) + 10*Proportion,
                              userNameLab.center.y - lvlImg.frame.size.height/2.0,
                              lvlImg.frame.size.width,
                              lvlImg.frame.size.height);
    
    if ([self.obj.retData.userId intValue] == [[[DataManager lightData] readUserID] intValue] ) {
        
        sig.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                               CGRectGetMaxY(userNameLab.frame) + 10*Proportion,
                               WIDTH - CGRectGetMaxX(userImage.frame) - 20*Proportion*2,
                               sig.frame.size.height);
        
    }else{
        
        UIButton *getCardBtn = [[UIButton alloc] init];
        [getCardBtn setBackgroundImage:[UIImage imageNamed:GetCardBtnImg] forState:UIControlStateNormal];
        [getCardBtn sizeToFit];
        getCardBtn.frame = CGRectMake(WIDTH - 20*Proportion - getCardBtn.frame.size.width,
                                      140*Proportion/2.0 - getCardBtn.frame.size.height/2.0,
                                      getCardBtn.frame.size.width,
                                      getCardBtn.frame.size.height);
        [pusherBgView addSubview:getCardBtn];
        [getCardBtn addTarget:self action:@selector(showCardView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *attentionBtn = [[UIButton alloc] init];
        [attentionBtn setBackgroundImage:[UIImage imageNamed:NewAttentionDefaultImg] forState:UIControlStateNormal];
        [attentionBtn setBackgroundImage:[UIImage imageNamed:NewAttentionedImg] forState:UIControlStateSelected];
        [attentionBtn sizeToFit];
        attentionBtn.frame = CGRectMake(WIDTH - 20*Proportion*2 - attentionBtn.frame.size.width - getCardBtn.frame.size.width,
                                        140*Proportion/2.0 - attentionBtn.frame.size.height/2.0,
                                        attentionBtn.frame.size.width,
                                        attentionBtn.frame.size.height);
        [pusherBgView addSubview:attentionBtn];
        
        if ([self.obj.retData.isFollow intValue] == 1) {
            
            attentionBtn.selected = YES;
        }else{
            
            attentionBtn.selected = NO;
        }
        
        [attentionBtn addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
        
        sig.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                               CGRectGetMaxY(userNameLab.frame) + 10*Proportion,
                               WIDTH - CGRectGetMaxX(userImage.frame) - 20*Proportion*4 - getCardBtn.frame.size.width - attentionBtn.frame.size.width,
                               sig.frame.size.height);
    }

    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                 CGRectGetMaxY(pusherBgView.frame) - 1,
                                                                 WIDTH - 20*Proportion*2,
                                                                 1)];
    spaceLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.mainScrollView addSubview:spaceLine];


    
    return CGRectGetMaxY(pusherBgView.frame);
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) setDetailMessageRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.currentID forKey:@"recordId"];
    [NetWorkTask postResquestWithApiName:NewDynamicDetailMessage paraDic:paraDic delegate:delegate];
    self.currentApiName = NewDynamicDetailMessage;
    
    [self startLoading];
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewDynamicDetailMessage]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            
            self.obj = obj;
            
            if (!self.firstRequest) {
                
                 [NSThread detachNewThreadSelector:@selector(setActivityShareMes) toTarget:self withObject:nil];
              
                CGFloat currentHeight = [self loadPusherView];
                
                UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                             currentHeight,
                                                                             WIDTH,
                                                                             1*Proportion)];
                spaceView.backgroundColor = [UIColor CMLNewActivityGrayColor];
                [self.mainScrollView addSubview:spaceView];
                
                [self loadDetailMessage];
                
                [self loadBottomBtnView];
                
                self.firstRequest = YES;
            }

            
            if (self.isLikeRefresh) {
                
                [self.likebtn setTitle:[NSString stringWithFormat:@"%@",self.obj.retData.likeNum] forState:UIControlStateNormal];
                [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
                [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
                
                [self.likeTimeLineView removeFromSuperview];
                
                self.likeTimeLineView = [[LikeTimeLineView alloc] initWithObj:self.obj];
                self.likeTimeLineView.frame = CGRectMake(0,
                                                         CGRectGetMaxY(self.detailView.frame),
                                                         WIDTH,
                                                         self.likeTimeLineView.currentHeight);
                
                self.detailMessageCommentListView.frame = CGRectMake(0,
                                                                     CGRectGetMaxY(self.likeTimeLineView.frame),
                                                                     WIDTH,
                                                                     self.detailMessageCommentListView.currentHeight);
                [self.mainScrollView addSubview:self.likeTimeLineView];
                
                self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailMessageCommentListView.frame));
                
                self.isLikeRefresh = NO;
                [self stopLoading];
            }
            
            
            if (self.isCommentRefresh) {
                
                [self.detailMessageCommentListView removeFromSuperview];
                
                self.detailMessageCommentListView = [[DetailMessageCommentListView alloc] initWithObj:self.obj];
                self.detailMessageCommentListView.frame = CGRectMake(0,
                                                                     CGRectGetMaxY(self.likeTimeLineView.frame),
                                                                     WIDTH,
                                                                     self.detailMessageCommentListView.currentHeight);
                [self.mainScrollView addSubview:self.detailMessageCommentListView];
                
                self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.detailMessageCommentListView.frame));
                
                [self.mainScrollView setContentOffset:CGPointMake(0, self.mainScrollView.contentSize.height - self.mainScrollView.frame.size.height)];
                
                [self cancelComment];
                
                self.isLikeRefresh = NO;
                [self stopLoading];
            }

            
        }else{
            
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:LikeCurrent]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.isLikeRefresh = YES;
            
            [self setDetailMessageRequest];
            
            if (self.likebtn.selected) {
                
                [self.cell refreshCurrentCellLikebtnStatus:[NSNumber numberWithInt:1] andNum:[self.likebtn.currentTitle intValue]];
            }else{
                
                [self.cell refreshCurrentCellLikebtnStatus:[NSNumber numberWithInt:2] andNum:[self.likebtn.currentTitle intValue]];
                
            }
    
            
        }else{
            
            self.likebtn.selected = !self.likebtn.selected;
            
            if (self.likebtn.selected) {
                
                int num = [self.likebtn.currentTitle intValue];
                self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
                [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
                [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
                [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
                [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
                self.likebtn.titleLabel.font = KSystemFontSize12;
                [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
                [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
            }else{
                
                int num = [self.likebtn.currentTitle intValue];
                self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
                [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
                [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
                [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
                [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
                self.likebtn.titleLabel.font = KSystemFontSize12;
                [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
                [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
            }
            
            [self showFailTemporaryMes:obj.retMsg];
            
        }
    }else if ([self.currentApiName isEqualToString:CommentPost]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.isCommentRefresh = YES;
            
            [self setDetailMessageRequest];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            
        }
    }
    
    [self stopIndicatorLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:LikeCurrent]) {
        

        [self showFailTemporaryMes:@"网络连接失败"];
        self.likebtn.selected = !self.likebtn.selected;
        
        if (self.likebtn.selected) {
            
            int num = [self.likebtn.currentTitle intValue];
            self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
            [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
            [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
            [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
            [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
            self.likebtn.titleLabel.font = KSystemFontSize12;
            [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
            [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
        }else{
            
            int num = [self.likebtn.currentTitle intValue];
            self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
            [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
            [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
            [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
            [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
            self.likebtn.titleLabel.font = KSystemFontSize12;
            [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
            [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
        }
    }
    
    [self stopIndicatorLoading];
    [self stopLoading];
}

- (void) showImage:(UIButton *) button{
    
    CMLVIPNewsImageShowVC *vc;
    
    NSMutableArray *newImageArray = [NSMutableArray array];
    
    for (int i = 0; i < self.obj.retData.coverPicArr.count; i++) {
        NSDictionary *targetDic = self.obj.retData.coverPicArr[i];
        [newImageArray addObject:[targetDic valueForKey:@"originPic"]];
    }
    vc = [[CMLVIPNewsImageShowVC alloc] initWithTag:(int) button.tag andImagesArray:newImageArray];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) setCommentTextView{
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                                                 CommemtListVCTextInputTopMargin*Proportion,
                                                                 WIDTH - CommemtListVCTextInputLeftMargin*Proportion*2,
                                                                 200*Proportion)];
    self.textView.font = KSystemFontSize12;
    self.textView.textColor = [UIColor CMLBlackColor];
    self.textView.backgroundColor = [UIColor CMLWhiteColor];
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    [self.commentInputView addSubview:self.textView];
    
    self.pushBtn = [[UIButton alloc] init];
    [self.pushBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [self.pushBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.pushBtn.titleLabel.font = KSystemFontSize14;
    [self.pushBtn addTarget:self action:@selector(pushComment) forControlEvents:UIControlEventTouchUpInside];
    [self.pushBtn sizeToFit];
    self.pushBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) - self.pushBtn.frame.size.width,
                                    CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                    self.pushBtn.frame.size.width,
                                    self.pushBtn.frame.size.height);
    [self.commentInputView addSubview:self.pushBtn];
    
    
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = KSystemFontSize14;
    [self.cancelBtn addTarget:self action:@selector(cancelComment) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn sizeToFit];
    self.cancelBtn.frame = CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                      CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                      self.cancelBtn.frame.size.width,
                                      self.cancelBtn.frame.size.height);
    [self.commentInputView addSubview:self.cancelBtn];
    
    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             self.commentInputView.frame.origin.y,
                                             self.commentInputView.frame.size.width,
                                             CGRectGetMaxY(self.cancelBtn.frame) + CommemtListVCTextInputBtnTopMargin*Proportion);
    [self.textView becomeFirstResponder];
    
    
}

#pragma mark - showCommentView
- (void) showCommentView{
    
    [self setCommentTextView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

- (void) removeCommentTextView{
    
    [self.textView removeFromSuperview];
    [self.pushBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification *) noti{
    
    
    NSDictionary *info = [noti userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             HEIGHT -  (self.commentInputView.frame.size.height + keyboardSize.height),
                                             self.commentInputView.frame.size.width,
                                             self.commentInputView.frame.size.height);
    
}

#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden:(NSNotification *) noti{
    
    self.commentInputView.frame = CGRectMake(0,
                                             HEIGHT,
                                             self.commentInputView.frame.size.width,
                                             self.commentInputView.frame.size.height);
    [self removeCommentTextView];
}

#pragma mark - pushComment
- (void) pushComment{
    
    if (self.textView.text.length > 0) {
        
        [self setPostCommentRequest];
    }else{
        [self showFailTemporaryMes:@"请输入评论内容"];
    }
}

- (void) cancelComment{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

#pragma mark - changeLikeState
- (void) changeLikeState:(UIButton *) btn{
    
    self.likebtn.selected = !self.likebtn.selected;
    
    if (self.likebtn.selected) {
        
        int num = [self.likebtn.currentTitle intValue];
        self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
        [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
        [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        self.likebtn.titleLabel.font = KSystemFontSize12;
        [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
        
    }else{
        
        int num = [self.likebtn.currentTitle intValue];
        self.likebtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikeImg] forState:UIControlStateNormal];
        [self.likebtn setImage:[UIImage imageNamed:DetailMessageLikedImg] forState:UIControlStateSelected];
        [self.likebtn setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
        [self.likebtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        self.likebtn.titleLabel.font = KSystemFontSize12;
        [self.likebtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20*Proportion, 0, 0)];
        [self.likebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20*Proportion)];
    }
    
    [self likeCurrent];
    
}
- (void) likeCurrent{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:98] forKey:@"objTypeId"];
    if (!self.likebtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }else{
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }
    
    [NetWorkTask postResquestWithApiName:LikeCurrent paraDic:paraDic delegate:delegate];
    
    self.currentApiName = LikeCurrent;
}

- (void) showCardView{
    
    NewCardView *cardView = [[NewCardView alloc] init];
    cardView.userID = self.obj.retData.userId;
    cardView.userImageUrl = self.obj.retData.gravatar;
    cardView.nickName = self.obj.retData.nickName;
    cardView.memeberLvl = self.obj.retData.memberLevel;
    cardView.delegate = self;
    [cardView setCardView];
    
    [self.contentView addSubview:cardView];
    
}

#pragma mark - NewCardViewDelegate

- (void) startNewCardLoading{
    
    [self startLoading];
}

- (void) endNewCardLoading{
    
    [self stopLoading];
}

- (void) saveCurrentNewCardView:(NSString *) msg{
    
    if ([msg isEqualToString:@"存图片失败"]) {
        
        [self showFailTemporaryMes:@"保存失败"];
    }else{
        
        [self showSuccessTemporaryMes:@"保存成功"];
        
    }
    
}

- (void) setAttentionVIPMemberRequest:(NSNumber *) actType andUserId:(NSNumber *) userId{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:userId forKey:@"userId"];
    [paraDic setObject:actType forKey:@"actType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],userId,actType,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:AttentionVIPMember paraDic:paraDic delegate:delegate];
    
    self.currentApiName = AttentionVIPMember;
    
}

#pragma mark - 发送评论的请求设置
- (void) setPostCommentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:98] forKey:@"objType"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.textView.text forKey:@"comment"];
    NSString *commentHash = [[NSString stringWithFormat:@"%@%@%@",self.textView.text,skey,reqTime] md5];
    [paraDic setObject:commentHash forKey:@"commentHash"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:98],reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:CommentPost paraDic:paraDic delegate:delegate];
    self.currentApiName = CommentPost;
    
    [self startIndicatorLoading];
    
}

- (void) setActivityShareMes{
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.objCoverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.baseShareLink = self.obj.retData.shareUrl;
    self.baseShareImage = image;
    self.baseShareContent = self.obj.retData.desc;
    self.baseShareTitle = self.obj.retData.timelineProjectTitle;
    
    self.shareSuccessBlock = ^(){
        
        
    };
    
    self.sharesErrorBlock = ^(){
        
    };
    
}

#pragma mark - showShareView

- (void) didSelectedRightBarItem{
    
    [self showCurrentVCShareView];
    
}

- (void) addUser:(UIButton *) btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:1] andUserId:self.obj.retData.userId];
    }else{
        
        [self setAttentionVIPMemberRequest:[NSNumber numberWithInt:2] andUserId:self.obj.retData.userId];
    }
    
}

- (void) enterDetailVC{
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.retData.nickName currnetUserId:self.obj.retData.userId isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
