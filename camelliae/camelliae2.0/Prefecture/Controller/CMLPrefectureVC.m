//
//  CMLPrefectureVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLPrefectureVC.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "BaseResultObj.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "PrefectureRecommendView.h"
#import "PrefectureInformationView.h"
#import "CMLCommodityView.h"
#import "CMLPrefectureVideoView.h"
#import "CMLPrefectureImagesView.h"
#import "CMLPrefectureActivityView.h"
#import "CMLExpressGratitudeView.h"
#import "BaseResultObj.h"
#import "ZoneInfoObj.h"
#import "CMLCutDownView.h"
#import "CMLChildPrefectureView.h"

#define LOGOImageWidth       120
#define LOGOImageBgViewWidth 132
#define LeftMargin            30

@interface CMLPrefectureVC ()<UIScrollViewDelegate,NetWorkProtocol>

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIImageView *topImage;

@property (nonatomic,strong) UIImageView *topLogo;

@property (nonatomic,strong) UIView *topLogoBgView;

@property (nonatomic,strong) UIImageView *suspendTopImage;

@property (nonatomic,strong) UIImageView *suspendTopLogoImage;

@property (nonatomic,strong) UIView *suspendTopLogoBgView;

@property (nonatomic,strong) UIView *briefBgView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) CMLCutDownView *timeCountView;

@end

@implementation CMLPrefectureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.backgroundColor = [UIColor CMLWhiteColor];
    self.view.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.hidden = YES;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   StatusBarHeight,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [backBtn setImage:[UIImage imageNamed:PrefectureInfoBackImg] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                    StatusBarHeight,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:PrefectureInfoShareImg] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMessageOfVC{

   [self setPrefectureRequest];
}

- (void) loadViews{

    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         HEIGHT)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT*4);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    [self.contentView addSubview:self.mainScrollView];
    
    
    self.topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  WIDTH/16*9)];
    self.topImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.topImage.contentMode = UIViewContentModeScaleAspectFill;
    self.topImage.clipsToBounds = YES;
    [self.mainScrollView addSubview:self.topImage];
    [NetWorkTask setImageView:self.topImage WithURL:self.obj.retData.zoneInfo.coverPic placeholderImage:nil];
    
    self.topLogoBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - LOGOImageBgViewWidth*Proportion/2.0,
                                                                 CGRectGetMaxY(self.topImage.frame) - LOGOImageBgViewWidth*Proportion/2.0,
                                                                 LOGOImageBgViewWidth*Proportion,
                                                                 LOGOImageBgViewWidth*Proportion)];
    self.topLogoBgView.backgroundColor = [UIColor CMLWhiteColor];
    self.topLogoBgView.layer.cornerRadius = LOGOImageBgViewWidth*Proportion/2.0;
    [self.mainScrollView addSubview:self.topLogoBgView];
    
    self.topLogo = [[UIImageView alloc] initWithFrame:CGRectMake(LOGOImageBgViewWidth*Proportion/2.0 - LOGOImageWidth*Proportion/2.0,
                                                                 LOGOImageBgViewWidth*Proportion/2.0 - LOGOImageWidth*Proportion/2.0,
                                                                 LOGOImageWidth*Proportion,
                                                                 LOGOImageWidth*Proportion)];
    self.topLogo.backgroundColor = [UIColor CMLPromptGrayColor];
    self.topLogo.layer.cornerRadius = LOGOImageWidth*Proportion/2.0;
    self.topLogo.contentMode = UIViewContentModeScaleAspectFill;
    self.topLogo.clipsToBounds = YES;
    [self.topLogoBgView addSubview:self.topLogo];
    [NetWorkTask setImageView:self.topLogo WithURL:self.obj.retData.zoneInfo.logoPic placeholderImage:nil];
    
    self.suspendTopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         WIDTH/16*9)];
    self.suspendTopImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.suspendTopImage.contentMode = UIViewContentModeScaleAspectFill;
    self.suspendTopImage.clipsToBounds = YES;
    self.suspendTopImage.hidden = YES;
    [self.contentView addSubview:self.suspendTopImage];
    [NetWorkTask setImageView:self.suspendTopImage WithURL:self.obj.retData.zoneInfo.coverPic placeholderImage:nil];
    
    
    self.suspendTopLogoBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - LOGOImageBgViewWidth*Proportion/2.0,
                                                                        CGRectGetMaxY(self.suspendTopImage.frame) - LOGOImageBgViewWidth*Proportion/2.0,
                                                                        LOGOImageBgViewWidth*Proportion,
                                                                        LOGOImageBgViewWidth*Proportion)];
    self.suspendTopLogoBgView.backgroundColor = [UIColor CMLWhiteColor];
    self.suspendTopLogoBgView.layer.cornerRadius = LOGOImageBgViewWidth*Proportion/2.0;
    [self.contentView addSubview:self.suspendTopLogoBgView];
    self.suspendTopLogoBgView.hidden = YES;
    
    
    self.suspendTopLogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(LOGOImageBgViewWidth*Proportion/2.0 - LOGOImageWidth*Proportion/2.0,
                                                                             LOGOImageBgViewWidth*Proportion/2.0 - LOGOImageWidth*Proportion/2.0,
                                                                             LOGOImageWidth*Proportion,
                                                                             LOGOImageWidth*Proportion)];
    self.suspendTopLogoImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.suspendTopLogoImage.layer.cornerRadius = LOGOImageWidth*Proportion/2.0;
    self.suspendTopLogoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.suspendTopLogoImage.clipsToBounds = YES;
    [self.suspendTopLogoBgView addSubview:self.suspendTopLogoImage];
    [NetWorkTask setImageView:self.suspendTopLogoImage WithURL:self.obj.retData.zoneInfo.logoPic placeholderImage:nil];
    
    [self setPrefectureBriefMessage];
    
    [self setMainMessageView];
    
    /*分享数据*/
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.zoneInfo.coverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    
    self.baseShareContent = self.obj.retData.zoneInfo.desc;
    self.baseShareTitle   = self.obj.retData.zoneInfo.title;
    self.baseShareImage   = image;
    self.baseShareLink    = self.obj.retData.shareUrl;
    __weak typeof(self) weakSelf = self;
    self.shareSuccessBlock = ^{
        [weakSelf hiddenCurrentVCShareView];
    };
}

- (void) setPrefectureBriefMessage{

    self.briefBgView = [[UIView alloc] init];
    self.briefBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:self.briefBgView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = KSystemBoldFontSize15;
    nameLab.textColor = [UIColor CMLBlackColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.obj.retData.zoneInfo.title;
    [nameLab sizeToFit];
    nameLab.numberOfLines = 0;
    if (nameLab.frame.size.width > WIDTH - LeftMargin*Proportion*2) {
        
        CGRect curentRect = [nameLab.text boundingRectWithSize:CGSizeMake(WIDTH - LeftMargin*Proportion*2, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:KSystemBoldFontSize15}
                                                       context:nil];
        nameLab.frame = CGRectMake(LeftMargin*Proportion,
                                   0,
                                   WIDTH - LeftMargin*Proportion*2,
                                   curentRect.size.height);
    }else{
    
        nameLab.frame = CGRectMake(WIDTH/2.0 - nameLab.frame.size.width/2.0,
                                   0,
                                   nameLab.frame.size.width,
                                   nameLab.frame.size.height);
        
    }
    [self.briefBgView addSubview:nameLab];
    
    UILabel *brief = [[UILabel alloc] init];
    brief.font = KSystemFontSize12;
    brief.textColor = [UIColor CMLUserBlackColor];
    brief.textAlignment = NSTextAlignmentCenter;
    brief.text = self.obj.retData.zoneInfo.desc;
    [brief sizeToFit];
    brief.numberOfLines = 0;
    if (brief.frame.size.width > WIDTH - LeftMargin*Proportion*2) {
        
        CGRect curentRect = [brief.text   boundingRectWithSize:CGSizeMake(WIDTH - LeftMargin*Proportion*2, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:KSystemBoldFontSize15}
                                                       context:nil];
        brief.frame = CGRectMake(LeftMargin*Proportion,
                                 CGRectGetMaxY(nameLab.frame),
                                 WIDTH - LeftMargin*Proportion*2,
                                 curentRect.size.height);
    }else{
        
        brief.frame = CGRectMake(WIDTH/2.0 - brief.frame.size.width/2.0,
                                 CGRectGetMaxY(nameLab.frame) + 20*Proportion,
                                 brief.frame.size.width,
                                 brief.frame.size.height);
        
    }
    [self.briefBgView addSubview:brief];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(brief.frame) + 20*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.briefBgView addSubview:bottomView];
    
    self.briefBgView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.topLogoBgView.frame) + 20*Proportion,
                                        WIDTH,
                                        CGRectGetMaxY(bottomView.frame));
    
}

- (void) setMainMessageView{

    /*倒计时部分*/
    self.timeCountView = [[CMLCutDownView alloc] initWithObj:self.obj];
    self.timeCountView.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.briefBgView.frame),
                                          WIDTH,
                                          self.timeCountView.viewHeight);
    [self.mainScrollView addSubview:self.timeCountView];
    
    /*倒计时下 与明星一起做慈善上*/
    PrefectureRecommendView *recommendView = [[PrefectureRecommendView alloc] initWithObj:self.obj];
    recommendView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.timeCountView.frame),
                                     WIDTH,
                                     recommendView.viewHeigth);
    [self.mainScrollView addSubview:recommendView];
    
    /*子专区模块*/
    CMLChildPrefectureView *childPrefectureView = [[CMLChildPrefectureView alloc] initWithObj:self.obj];
    childPrefectureView.frame = CGRectMake(0,
                                           CGRectGetMaxY(recommendView.frame),
                                           WIDTH,
                                           childPrefectureView.viewHeight);
    NSLog(@"%f", childPrefectureView.viewHeight);
    [self.mainScrollView addSubview:childPrefectureView];
    
    /*与明星一起做慈善*/
    PrefectureInformationView *informationView = [[PrefectureInformationView alloc] initWithObj:self.obj];
    informationView.frame = CGRectMake(0,
                                       CGRectGetMaxY(childPrefectureView.frame),
                                       WIDTH,
                                       informationView.viewHeight);
    [self.mainScrollView addSubview:informationView];
    
    /*在线默拍*/
    CMLCommodityView *commodityView = [[CMLCommodityView alloc] initWithObj:self.obj];
    commodityView.frame = CGRectMake(0,
                                     CGRectGetMaxY(informationView.frame),
                                     WIDTH,
                                     commodityView.viewHeight);
    [self.mainScrollView addSubview:commodityView];
    
    /*往期视频*/
    CMLPrefectureVideoView *prefectureVideoView = [[CMLPrefectureVideoView alloc] initWithObj:self.obj];
    prefectureVideoView.frame = CGRectMake(0,
                                           CGRectGetMaxY(commodityView.frame),
                                           WIDTH,
                                           prefectureVideoView.viewHeight);
    [self.mainScrollView addSubview:prefectureVideoView];
    
    /*精彩瞬间*/
    CMLPrefectureImagesView *imagesView = [[CMLPrefectureImagesView alloc] initWithObj:self.obj];
    imagesView.frame = CGRectMake(0,
                                  CGRectGetMaxY(prefectureVideoView.frame),
                                  WIDTH,
                                  imagesView.viewHeight);
    [self.mainScrollView addSubview:imagesView];
    
    /*相关活动*/
    CMLPrefectureActivityView *prefectureActivityView = [[CMLPrefectureActivityView alloc] initWithObj:self.obj];
    prefectureActivityView.frame = CGRectMake(0,
                                              CGRectGetMaxY(imagesView.frame),
                                              WIDTH,
                                              prefectureActivityView.viewHeight);
    [self.mainScrollView addSubview:prefectureActivityView];
    NSLog(@"%@", self.currentID);
    if ([self.currentID intValue] == 2) {/*zoneId != 2时 隐藏组织架构*/
        /*特别鸣谢/组织架构*/
        CMLExpressGratitudeView *expressGratitudeView = [[CMLExpressGratitudeView alloc] initWithObj:self.obj];
        expressGratitudeView.frame = CGRectMake(0,
                                                CGRectGetMaxY(prefectureActivityView.frame),
                                                WIDTH,
                                                expressGratitudeView.viewHeight);
        [self.mainScrollView addSubview:expressGratitudeView];
        self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(prefectureActivityView.frame) + CGRectGetHeight(expressGratitudeView.frame) + 40*Proportion);
    }else {
        self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(prefectureActivityView.frame) - 20*Proportion);
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.mainScrollView) {
        
        if (self.mainScrollView.contentOffset.y < 0) {
            
            self.suspendTopLogoBgView.hidden = NO;
            self.suspendTopImage.hidden = NO;
            
            self.suspendTopImage.frame = CGRectMake(self.mainScrollView.contentOffset.y,
                                                    0,
                                                    WIDTH - self.mainScrollView.contentOffset.y*2,
                                                    WIDTH/16*9 - self.mainScrollView.contentOffset.y);
            self.suspendTopLogoBgView.frame = CGRectMake(WIDTH/2.0 - LOGOImageBgViewWidth*Proportion/2.0,
                                                         CGRectGetMaxY(self.suspendTopImage.frame) - LOGOImageBgViewWidth*Proportion/2.0,
                                                         LOGOImageBgViewWidth*Proportion,
                                                         LOGOImageBgViewWidth*Proportion);
            
        }else{
            
            self.suspendTopLogoBgView.hidden = YES;
            self.suspendTopImage.hidden = YES;
            
            self.suspendTopImage.frame = CGRectMake(0,
                                                    0,
                                                    WIDTH,
                                                    WIDTH/16*9);
            self.suspendTopLogoBgView.frame = CGRectMake(WIDTH/2.0 - LOGOImageBgViewWidth*Proportion/2.0,
                                                         CGRectGetMaxY(self.suspendTopImage.frame) - LOGOImageBgViewWidth*Proportion/2.0,
                                                         LOGOImageBgViewWidth*Proportion,
                                                         LOGOImageBgViewWidth*Proportion);
        }
    }
}

- (void)back {
    [[VCManger mainVC]dismissCurrentVC];
}

- (void)shareBtnClicked {
    [self showCurrentVCShareView];
}

- (void)setPrefectureRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[AppGroup appVersion] forKey:@"version"];
    [paramDic setObject:self.currentID forKey:@"zoneId"];
    [NetWorkTask postResquestWithApiName:PrefectureZone paraDic:paramDic delegate:delegate];
    self.currentApiName = PrefectureZone;
    [self startLoading];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:PrefectureZone]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            self.obj = obj;
            [self loadViews];
        }else{
            [self showNetErrorTipOfNormalVC];
        }
    }
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.timeCountView removeTimer];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.timeCountView startTimer];
}

@end
