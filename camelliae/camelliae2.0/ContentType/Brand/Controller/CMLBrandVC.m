//
//  CMLBrandVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBrandVC.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "CMLBrandBigImgView.h"
#import "CMLServeOfBrandTableView.h"
#import "CMLGoodsOfBrandCollectionView.h"
 
@interface CMLBrandVC ()<NavigationBarProtocol,CMLBrandBigImgViewDelegate,CMLBaseTableViewDlegate,CMLBaseCollectionViewDlegate,NetWorkProtocol>

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *detail;

@property (nonatomic,copy) NSString *logoUrl;

@property (nonatomic,strong) NSNumber *brandID;

@property (nonatomic,strong) CMLBrandBigImgView *tempImage;

@property (nonatomic,strong) UIView *mainView;

@property (nonatomic,strong) CMLServeOfBrandTableView *serveOfBrandTableView;

@property (nonatomic,strong) CMLGoodsOfBrandCollectionView *goodsOfBrandCollectionView;

@property (nonatomic,assign) int currentSelctIndex;

@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong) UIButton *goodsBtn;

@property (nonatomic,strong) UIView *moveLine;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLBrandVC

- (instancetype)initWithImageUrl:(NSString *)url andDetailMes:(NSString *)mes LogoImageUrl:(NSString *) logoUrl brandID:(NSNumber *) brandID{
    
    self = [super init];
    
    if (self) {
     
        self.brandID = brandID;
        self.currentSelctIndex = 0;
        
        [self setRequest];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CMLMobClick BrandDetailsPage];
    // Do any additional setup after loading the view.
    self.navBar.alpha = 0;
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setTitleContent:@"品牌主页"];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    [self.navBar setLeftBarItem];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                               StatusBarHeight,
                                                               NavigationBarHeight,
                                                               NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:NewDetailMessageShareImg] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:shareBtn];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.serveOfBrandTableView.videoController dismiss];
}

- (void) refrshViews{
    

    
    if ([self.serveNum intValue] > 0 && [self.goodsNum intValue] > 0) {
        
        self.serveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH/2.0,
                                                                   80*Proportion)];
        self.serveBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.serveBtn.titleLabel.font = KSystemFontSize13;
        [self.serveBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [self.serveBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.serveBtn setTitle:@"服务" forState:UIControlStateNormal];
        [self.serveBtn setTitle:@"服务" forState:UIControlStateSelected];
        self.serveBtn.selected = YES;
        [self.contentView addSubview:self.serveBtn];
        [self.serveBtn addTarget:self action:@selector(selectServe) forControlEvents:UIControlEventTouchUpInside];
        
        self.goodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH/2.0,
                                                                   80*Proportion)];
        self.goodsBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.goodsBtn.titleLabel.font = KSystemFontSize13;
        [self.goodsBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [self.goodsBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.goodsBtn setTitle:@"单品" forState:UIControlStateNormal];
        [self.goodsBtn setTitle:@"单品" forState:UIControlStateSelected];
        [self.goodsBtn addTarget:self action:@selector(selectGoods) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.goodsBtn];
    }else if ([self.serveNum intValue] > 0 && [self.goodsNum intValue] == 0){
        
        self.serveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH,
                                                                   80*Proportion)];
        self.serveBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.serveBtn.titleLabel.font = KSystemFontSize13;
        [self.serveBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        [self.serveBtn setTitle:@"服务" forState:UIControlStateNormal];
        [self.contentView addSubview:self.serveBtn];
        [self.serveBtn addTarget:self action:@selector(selectServe) forControlEvents:UIControlEventTouchUpInside];
        
        self.currentSelctIndex = 0;
        
    }else if ([self.serveNum intValue] == 0 && [self.goodsNum intValue] > 0){
        
        self.goodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.navBar.frame),
                                                                   WIDTH,
                                                                   80*Proportion)];
        self.goodsBtn.backgroundColor = [UIColor CMLWhiteColor];
        self.goodsBtn.titleLabel.font = KSystemFontSize13;
        [self.goodsBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        [self.goodsBtn setTitle:@"单品" forState:UIControlStateNormal];
        [self.goodsBtn addTarget:self action:@selector(selectGoods) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.goodsBtn];
        
        self.currentSelctIndex = 1;
    }
    
    UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.navBar.frame) + 80*Proportion - 1*Proportion,
                                                               WIDTH,
                                                               1*Proportion)];
    endLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self.contentView addSubview:endLine];
    
    if ([self.serveNum intValue] > 0 && [self.goodsNum intValue] > 0) {
        self.moveLine = [[UIView alloc] initWithFrame:CGRectMake(self.serveBtn.center.x - 52*Proportion/2.0,
                                                                 CGRectGetMaxY(self.goodsBtn.frame) - 3*Proportion,
                                                                 52*Proportion,
                                                                 3*Proportion)];
        self.moveLine.backgroundColor = [UIColor CMLBrownColor];
        [self.contentView addSubview:self.moveLine];
    }
    
    
    
    self.tempImage = [[CMLBrandBigImgView alloc] initWithImageUrl:self.imageUrl
                                                     andDetailMes:self.detail
                                                     LogoImageUrl:self.logoUrl];
    self.tempImage.delegate = self;
    [self.contentView addSubview:self.tempImage];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             HEIGHT,
                                                             WIDTH,
                                                             HEIGHT - CGRectGetMaxY(self.navBar.frame) - 80*Proportion - SafeAreaBottomHeight)];
    self.mainView.backgroundColor = [UIColor CMLWhiteColor];
    
    [self.contentView addSubview:self.mainView];
    [self.mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.tempImage addGestureRecognizer:recognizer];

    
}

- (void) LoadDetailMessage{
    
    if (self.currentSelctIndex == 0) {
        
        self.goodsOfBrandCollectionView.hidden = YES;
        if (self.serveOfBrandTableView) {
            
            self.serveOfBrandTableView.hidden = NO;
            [self.mainView bringSubviewToFront:self.serveOfBrandTableView];
        }else{
            
            [self startLoading];
            
            self.serveOfBrandTableView  = [[CMLServeOfBrandTableView alloc] initWithFrame:self.mainView.bounds
                                                                                    style:UITableViewStylePlain
                                                                                  brandID:self.brandID];
            self.serveOfBrandTableView.baseTableViewDlegate = self;
            [self.mainView addSubview:self.serveOfBrandTableView];
        }
    }else{
        
        self.serveOfBrandTableView.hidden = YES;
        
        if (self.goodsOfBrandCollectionView) {
           
            self.goodsOfBrandCollectionView.hidden = NO;
            [self.mainView bringSubviewToFront:self.goodsOfBrandCollectionView];
            
        }else{
         
            [self startLoading];
            
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            layout.itemSize = CGSizeMake(360*Proportion ,[self getCellHeight]);
            layout.minimumLineSpacing = 50*Proportion;
            
            self.goodsOfBrandCollectionView = [[CMLGoodsOfBrandCollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                                              20*Proportion,
                                                                                                              WIDTH,
                                                                                                              self.mainView.frame.size.height - 20*Proportion)
                                                                              collectionViewLayout:layout
                                                                                           brandID:self.brandID];
            self.goodsOfBrandCollectionView.baseCollectionViewDlegate = self;
            [self.mainView addSubview:self.goodsOfBrandCollectionView];
            
        }
        
    }
    
}

- (CGFloat) getCellHeight{
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = KSystemBoldFontSize14;
    label1.text = @"测试";
    [label1 sizeToFit];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"¥100";
    label2.font = KSystemRealBoldFontSize17;
    [label2 sizeToFit];
    
    return label1.frame.size.height*2 + label2.frame.size.height + 10*Proportion + 30*Proportion + 330*Proportion + 34*Proportion + 10*Proportion + 15*Proportion;
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"frame"]) {
        
        if (self.mainView.frame.origin.y < (CGRectGetMaxY(self.navBar.frame) + 80*Proportion)) {
            
            self.mainView.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame) + 80*Proportion, WIDTH, self.mainView.frame.size.height);
        }
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{

    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.7 animations:^{
            
            weakSelf.navBar.alpha = 1;
            weakSelf.tempImage.frame = CGRectMake(0,
                                                  -HEIGHT,
                                                  WIDTH,
                                                  HEIGHT);
            self.mainView.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.navBar.frame),
                                             WIDTH,
                                             self.mainView.frame.size.height);
        }completion:^(BOOL finished) {
            
            [weakSelf.tempImage removeFromSuperview];
            [weakSelf LoadDetailMessage];
        }];
    }

}
#pragma mark - NavigationBarProtocol

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - CMLBrandBigImgViewDelegate
- (void) clearBrandBigImgView{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        
        weakSelf.navBar.alpha = 1;
        weakSelf.tempImage.frame = CGRectMake(0,
                                              -HEIGHT,
                                              WIDTH,
                                              HEIGHT);
        self.mainView.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.navBar.frame),
                                         WIDTH,
                                         self.mainView.frame.size.height);
    }completion:^(BOOL finished) {
        
        [weakSelf.tempImage removeFromSuperview];
        [weakSelf LoadDetailMessage];
    }];
    
    
}

#pragma mark - CMLBaseTableViewDlegate

- (void) startRequesting{
    
    [self startLoading];
}

- (void) endRequesting{
    
    [self stopLoading];
}

- (void) showSuccessActionMessage:(NSString *) str{
    
    [self showSuccessActionMessage:str];
}

- (void) showFailActionMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) showAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];
    
}

#pragma mark - CMLBaseCollectionViewDlegate

- (void) collectionViewStartRequesting{
    
    [self startLoading];
}

- (void) collectionViewEndRequesting{
    
    [self endRequesting];
}

- (void) collectionViewShowSuccessActionMessage:(NSString *) str{
    
    [self showSuccessActionMessage:str];
}

- (void) collectionViewShowFailActionMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) collectionViewShowAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];
    
}


#pragma mark - selectServe
- (void) selectServe{
    
    self.currentSelctIndex = 0;
    if (!self.serveBtn.selected) {
        
        self.goodsBtn.selected = NO;
        self.serveBtn.selected = YES;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.serveBtn.center.x, self.moveLine.center.y);
        }];
    }
    
    [self LoadDetailMessage];
}

- (void) selectGoods{
    
    self.currentSelctIndex = 1;
    if (!self.goodsBtn.selected) {
        
        self.serveBtn.selected = NO;
        self.goodsBtn.selected = YES;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.moveLine.center = CGPointMake(self.goodsBtn.center.x, self.moveLine.center.y);
        }];
    }
    
    [self LoadDetailMessage];
    
}


/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
 
    if ([obj.retCode intValue] == 0) {
        
            self.obj = obj;
            self.imageUrl = obj.retData.coverPic;
            self.detail = obj.retData.desc;
            self.logoUrl = obj.retData.logoPic;
        
            [self refrshViews];
        
        /************shareMes**************/
        [NSThread detachNewThreadSelector:@selector(setShareMes) toTarget:self withObject:nil];
        /************************/
        
        
    }
    
    [self stopLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];

}


- (void) setRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.brandID,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:self.brandID forKey:@"objId"];
    [NetWorkTask getRequestWithApiName:BrandDetail param:paraDic delegate:delegate];
    [self startLoading];
}

- (void) setShareMes{
    
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.objCoverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    /********shareblock********/
    __weak typeof(self) weakSelf = self;
    
    self.baseShareTitle = self.obj.retData.title;
    self.baseShareContent = self.obj.retData.briefIntro;
    self.baseShareImage = image;
    self.baseShareLink = self.obj.retData.shareLink;
    self.shareSuccessBlock = ^(){
        
        [weakSelf hiddenCurrentVCShareView];
     
    };
    
    self.sharesErrorBlock = ^(){
        
    };
}


#pragma mark - showShareView
- (void) showShareView{
    
    [self showCurrentVCShareView];
}
@end
