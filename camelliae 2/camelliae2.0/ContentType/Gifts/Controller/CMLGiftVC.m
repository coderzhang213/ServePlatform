//
//  CMLGiftVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGiftVC.h"
#import "VCManger.h"
//#import "MoreMesView.h"
#import "DefaultTransition.h"
#import "CustomTransition.h"
#import "WKWebView+CMLExspand.h"
#import "InformationWkView.h"
#import "CMLPicObjInfo.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "PhysicalGiftExchangeVC.h"
#import "CMLMobClick.h"
#import "ServeHeaderView.h"


#define CommodityDetailVCLeftMargin            20
#define CommodityDetailVCNumLabelBottomMargin  40


@interface CMLGiftVC ()<NetWorkProtocol,UINavigationBarDelegate,UIScrollViewDelegate,ServeHeaderDelegate>

@property (nonatomic,strong) NSNumber *objId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *contentHeaderView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UILabel *currentBuyNum;


@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) ServeHeaderView *detailHeaderView;

@property (nonatomic,strong) NSMutableArray *packageInfoArray;




@end

@implementation CMLGiftVC

- (NSMutableArray *)packageInfoArray{
    
    if (!_packageInfoArray) {
        
        _packageInfoArray = [NSMutableArray array];
    }
    
    return _packageInfoArray;
}

- (instancetype)initWithObjId:(NSNumber *)objId{
    
    self = [super init];
    
    if (self) {
        
        self.objId = objId;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [CMLMobClick GoodsMessage];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCurrentShareView)
                                                 name:@"closeShareView"
                                               object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShareView" object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.hidden = YES;
    
    [CMLMobClick Integraldetailspage];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
}

- (void) loadMessageOfVC{
    
    /***loadView*/
    [self loadViews];
    /**loadData*/
    [self loadData];
}

- (void) loadData{
    
    [self setNetWork];
    
}

- (void) setNetWork{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey],self.objId]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:GiftDetail paraDic:paraDic delegate:delegate];
    self.currentApiName = GiftDetail;
    
    [self startLoading];
    
}
- (void) loadViews{
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         NavigationBarHeight + StatusBarHeight,
                                                                         WIDTH,
                                                                         HEIGHT - 90*Proportion - SafeAreaBottomHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.contentView addSubview:self.mainScrollView];
    
    
}


- (void) setCurrentVCHeaderView{
    
    self.detailHeaderView = [[ServeHeaderView alloc] initWith:self.obj];
    self.detailHeaderView.isGoods = YES;
    self.detailHeaderView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             NavigationBarHeight + StatusBarHeight);
    self.detailHeaderView.delegate = self;
    [self.contentView addSubview:self.detailHeaderView];
    
    
    
}

- (void) setContentHeaderView{
    
    /**设置头部内容*/
    self.contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      WIDTH,
                                                                      1000)];
    self.contentHeaderView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.contentHeaderView];
    
    
    UIImageView *topImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         WIDTH)];
    topImage.backgroundColor = [UIColor CMLtextInputGrayColor];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.clipsToBounds = YES;
    [self.contentHeaderView addSubview:topImage];
    [NetWorkTask setImageView:topImage WithURL:self.obj.retData.objCoverPic placeholderImage:nil];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = KSystemFontSize16;
    nameLabel.textColor = [UIColor CMLUserBlackColor];
    nameLabel.text = self.obj.retData.title;
    nameLabel .numberOfLines = 0;
    
    CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 2*CommodityDetailVCLeftMargin*Proportion ,1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemBoldFontSize18}
                                                   context:nil];
    nameLabel.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                                 20*Proportion + CGRectGetMaxY(topImage.frame),
                                 WIDTH - 2*CommodityDetailVCLeftMargin*Proportion,
                                 nameRect.size.height);
    [self.contentHeaderView addSubview:nameLabel];
    
    
    UILabel *tagLab = [[UILabel alloc] init];
    tagLab.font = KSystemFontSize10;
    tagLab.textColor = [UIColor CMLBlackColor];
    tagLab.text = self.obj.retData.giftLevelStr;
    tagLab.textAlignment = NSTextAlignmentCenter;
    tagLab.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    tagLab.layer.borderWidth = 1*Proportion;
    [tagLab sizeToFit];
    tagLab.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                              CGRectGetMaxY(nameLabel.frame) + 20*Proportion,
                              tagLab.frame.size.width + 10*Proportion,
                              30*Proportion);
    [self.contentHeaderView addSubview:tagLab];
    
    if (self.obj.retData.giftLevelStr.length == 0) {
        
        tagLab.frame = CGRectMake(CommodityDetailVCLeftMargin*Proportion,
                                  CGRectGetMaxY(nameLabel.frame) + 20*Proportion,
                                  tagLab.frame.size.width + 10*Proportion,
                                  0);
        tagLab.hidden = YES;
    }
    
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationIconImg]];
    [iconImg sizeToFit];
    iconImg.frame = CGRectMake(30*Proportion,
                               CGRectGetMaxY(tagLab.frame) + 30*Proportion,
                               iconImg.frame.size.width,
                               iconImg.frame.size.height);
    [self.contentHeaderView addSubview:iconImg];
    
    UILabel *pointsLab = [[UILabel alloc] init];
    pointsLab.textColor = [UIColor CMLBrownColor];
    pointsLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
    [pointsLab sizeToFit];
    pointsLab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame) +10*Proportion,
                                 iconImg.center.y - pointsLab.frame.size.height/2.0,
                                 pointsLab.frame.size.width,
                                 pointsLab.frame.size.height);
    [self.contentHeaderView addSubview:pointsLab];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(iconImg.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentHeaderView addSubview:bottomView];
    
    self.contentHeaderView.frame = CGRectMake(0,
                                              0,
                                              WIDTH,
                                              CGRectGetMaxY(bottomView.frame) + 20*Proportion);
    
    
    
}

- (void) setMainContentView{
    
    self.informationWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
    self.informationWkView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.contentHeaderView.frame) + 20*Proportion,
                                              WIDTH,
                                              1000);
    self.informationWkView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.informationWkView];
    
    __weak typeof(self) weakSelf = self;
    self.informationWkView.loadWebViewFinish = ^(CGFloat height){
        
        weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                                      weakSelf.informationWkView.frame.origin.y,
                                                      WIDTH,
                                                      height);
        
        [weakSelf stopLoading];
        
        weakSelf.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                         self.contentHeaderView.frame.size.height  + height + 90*Proportion + 20*Proportion);
        
    };
    
}

- (void) setContentFooterView{
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  HEIGHT - 90*Proportion - SafeAreaBottomHeight,
                                                                  WIDTH,
                                                                  90*Proportion)];
    footerView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:footerView];
    
    UILabel *pointsLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH - 450*Proportion,
                                                                   90*Proportion)];
    pointsLab.textColor = [UIColor CMLBrownColor];
    pointsLab.font = KSystemRealBoldFontSize15;
    pointsLab.text = [NSString stringWithFormat:@"积分：%@",self.obj.retData.point];
    pointsLab.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:pointsLab];
    

    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 450*Proportion,
                                                                  0,
                                                                  450*Proportion,
                                                                  90*Proportion)];
    [buyBtn setTitle:self.obj.retData.sysApplyStatusName forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor CMLGreeenColor];
    buyBtn.titleLabel.font = KSystemRealBoldFontSize16;
    [footerView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(enterGoodsBuyMessageVC) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.sysApplyStatus intValue] == 2) {
        
        buyBtn.userInteractionEnabled = NO;
        buyBtn.backgroundColor = [UIColor CMLtextInputGrayColor];
    }

    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GiftDetail]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        self.obj = obj;
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            
            for (int i = 0; i < self.obj.retData.packageInfo.dataList.count; i++) {
                
                
                PackDetailInfoObj *detailObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[i]];
                
                
                if ([detailObj.surplusStock intValue] > 0) {
                    
                    [self.packageInfoArray addObject:detailObj];
                    
                }
            }
            
            
            
            self.currentID = obj.retData.currentID;
            
            
            self.mainScrollView.frame = CGRectMake(0,
                                                   0,
                                                   WIDTH,
                                                   HEIGHT - 90*Proportion - SafeAreaBottomHeight);
            
            [self setCurrentVCHeaderView];
            
            /**设置标头*/
            [self setContentHeaderView];
            
            /**主要内容*/
            [self setMainContentView];
            
            [self setContentFooterView];
            
            /**分享内容处理*/
            [NSThread detachNewThreadSelector:@selector(setShareMes) toTarget:self withObject:nil];
        
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            [self setCurrentVCHeaderView];
            [self stopLoading];
            [self showAlterViewWithText:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self hiddenCurrentVCShareView];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GiftDetail]) {
        
        [self showNetErrorTipOfNormalVC];
        
        [self setCurrentVCHeaderView];
    }
    
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
}


- (void) handleDoubleTapFrom{
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - closeCurrentShareView
- (void) closeCurrentShareView{
    
    [self hiddenCurrentVCShareView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenCurrentVCShareView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.mainScrollView){
        
        if (self.mainScrollView.contentOffset.y > WIDTH/3*2) {
            
            [self.detailHeaderView changeBtnStyleOfLight];
            
        }else{
            
            [self.detailHeaderView changeBtnStyleOfDefault];
        }
        
    }
}

#pragma mark - InformationHeaderDelegate
- (void) informationFavSuccess:(NSString *) str{
    
    [self showSuccessTemporaryMes:str];
    
}

- (void) informationFavError:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) enterGoodsBuyMessageVC{
    
    [CMLMobClick Exchangebutton];
    
    PhysicalGiftExchangeVC *vc = [[PhysicalGiftExchangeVC alloc] init];
    vc.obj = self.obj;
    if ([self.obj.retData.isPhysicalObject intValue] == 1) {
        
        vc.isVirtual = NO;
    }else{

        vc.isVirtual = YES;
    }
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    
}


- (void) showErrorMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

#pragma mark - ServeHeaderDelegate

- (void) showDetailShareMessage{
    
    [self showShareView];
}

- (void) showShareView{
    
    [self showCurrentVCShareView];
}


- (void) dissCurrentDetailVC{
    
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - setShareMes
- (void) setShareMes{
    
    /************shareMes**************/
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPicThumb]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.baseShareLink = self.obj.retData.shareLink;
    self.baseShareImage = image;
    self.baseShareContent = self.obj.retData.desc;
    self.baseShareTitle = self.obj.retData.title;
    
    __weak typeof(self) weakSelf = self;
    self.shareSuccessBlock = ^(){
        
        [weakSelf sendShareAction];
    };
    
    self.sharesErrorBlock = ^(){
        
    };
}

- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}


@end
