//
//  CMLAllImagesVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/9/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAllImagesVC.h"
#import "VCManger.h"
#import "CMLImagleDetailObj.h"
#import "CMLImageShowVC.h"
#import "CustomTransition.h"
#import "DefaultTransition.h"
#import "CMLEncryptNumView.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "MJRefresh.h"

@interface CMLAllImagesVC ()<UIScrollViewDelegate,NavigationBarProtocol,NetWorkProtocol,UINavigationControllerDelegate,CMLEncryptNumViewDelegate>

@property (nonatomic,strong) NSNumber *albumId;

@property (nonatomic,strong) NSString *imageName;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *detailDataArray;

@property (nonatomic,strong) NSMutableArray *imageUrlArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int bigPage;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int requestNum;

@property (nonatomic,assign) int pageSize;

@property (nonatomic,assign) int smallPageSize;

@property (nonatomic,assign) BOOL  isFirstRequest;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIVisualEffectView *effectView;

@property (nonatomic,strong) CMLEncryptNumView *encrptNumView;

@property (nonatomic,assign) BOOL boardShow;

@property (nonatomic, assign) NSInteger refreshTag;

@property (nonatomic, assign) NSInteger buttonTag;

@property (nonatomic, strong) NSMutableDictionary *imgTagDic;

@property (nonatomic, strong) NSMutableArray *coverPicThumbArray;

@property (nonatomic, strong) NSMutableDictionary *thumImageDic;

@end

@implementation CMLAllImagesVC

- (instancetype)initWithAlbumId:(NSNumber *) albumId ImageName:(NSString *) imageName{

    self = [super init];
    
    if (self) {
        
        self.albumId = albumId;
        self.imageName = imageName;
    }
    return self;
}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)detailDataArray {
    
    if (!_detailDataArray) {
        _detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
    
}

- (NSMutableArray *)imageUrlArray{

    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (NSMutableDictionary *)imgTagDic {
    
    if (!_imgTagDic) {
        _imgTagDic = [[NSMutableDictionary alloc] init];
    }
    return _imgTagDic;
    
}

- (NSMutableArray *)coverPicThumbArray {
    
    if (!_coverPicThumbArray) {
        _coverPicThumbArray = [[NSMutableArray alloc] init];
    }
    return _coverPicThumbArray;
    
}

- (NSMutableDictionary *)thumImageDic {
    
    if (!_thumImageDic) {
        _thumImageDic = [[NSMutableDictionary alloc] init];
    }
    return _thumImageDic;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.titleContent = self.imageName;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
    self.isFirstRequest = NO;
    
    [self loadData];
    
    [self loadViewViews];
    
}

- (void) loadData{
    
    self.page = 1;
    self.bigPage = 2;
    self.pageSize = 30;
    self.requestNum = 0;
    self.buttonTag = 0;
    [self.dataArray removeAllObjects];
    [self.imageUrlArray removeAllObjects];
    [self setImageDetailRequest];
    [self startLoading];
    
}


- (void) loadViewViews{

    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame),
                                                                     WIDTH,
                                                                     HEIGHT - (CGRectGetMaxY(self.navBar.frame)) - SafeAreaBottomHeight)];
    _mainScrollView.backgroundColor = [UIColor CMLUserGrayColor];
    _mainScrollView.delegate = self;
    _mainScrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _mainScrollView.mj_header = header;
    /**上拉加载*/
    _mainScrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreImages)];
    
    
    [self.contentView addSubview:_mainScrollView];

}

- (void)pullRefreshOfHeader {
    
    self.page = 1;
    self.bigPage = 2;
    self.pageSize = 30;
    self.buttonTag = 0;
    [self.dataArray removeAllObjects];
    [self.imageUrlArray removeAllObjects];
    [_mainScrollView removeFromSuperview];
    [self startLoading];
    [self loadViewViews];
    [self setImageDetailRequest];
    
}

- (void) loadImages{
    
    CGFloat currentHeightOne = 10*Proportion;
    CGFloat currentHeightTwo = 10*Proportion;
    CGFloat imageWidth = (WIDTH - 10*Proportion*3)/2.0;
    if (self.dataCount > 10000 && self.page > 1) {
        self.pageSize = 100;
        self.smallPageSize = 30;
    }else {
        self.pageSize = self.smallPageSize = 30;
    }
    
    for (int i = self.smallPageSize + (self.page - self.bigPage)*self.pageSize; i < self.dataArray.count; i++) {
        
        CMLImagleDetailObj *obj = [CMLImagleDetailObj getBaseObjFrom:self.dataArray[i]];
        
        UIImageView *currentImage = [[UIImageView alloc] init];
        currentImage.backgroundColor = [UIColor CMLPromptGrayColor];
        currentImage.tag = self.buttonTag;
        currentImage.userInteractionEnabled = YES;
        
        if (self.page == 1 || self.page == 26) {
            if (currentHeightOne <= currentHeightTwo) {
                currentImage.frame = CGRectMake(10*Proportion,currentHeightOne,imageWidth, imageWidth/[obj.picObjInfo.ratio floatValue]);
                currentHeightOne += (currentImage.frame.size.height + 10*Proportion);
            }else{
                currentImage.frame = CGRectMake(20*Proportion + imageWidth, currentHeightTwo, imageWidth, imageWidth/[obj.picObjInfo.ratio floatValue]);
                currentHeightTwo += (currentImage.frame.size.height + 10*Proportion);
            }
        }else {
            
            currentHeightOne = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentHeightOne"] floatValue];
            currentHeightTwo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentHeightTwo"] floatValue];
            if (currentHeightOne <= currentHeightTwo) {
                currentImage.frame = CGRectMake(10*Proportion,currentHeightOne,imageWidth, imageWidth/[obj.picObjInfo.ratio floatValue]);
                currentHeightOne += (currentImage.frame.size.height + 10*Proportion);
            }else{
                currentImage.frame = CGRectMake(20*Proportion + imageWidth, currentHeightTwo, imageWidth, imageWidth/[obj.picObjInfo.ratio floatValue]);
                currentHeightTwo += (currentImage.frame.size.height + 10*Proportion);
            }   
        }
        
        [_mainScrollView addSubview:currentImage];
        
        /*每次请求1页每页30个数据*/
         //= (int)self.dataArray.count/30 + 1;
        [NetWorkTask setImageView:currentImage WithURL:obj.coverPicThumb placeholderImage:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(currentHeightOne) forKey:@"currentHeightOne"];
        [[NSUserDefaults standardUserDefaults] setObject:@(currentHeightTwo) forKey:@"currentHeightTwo"];
        
        UIButton *button = [[UIButton alloc] initWithFrame:currentImage.bounds];
        button.tag = self.buttonTag;
        self.buttonTag++;
        
        [currentImage addSubview:button];
        [button addTarget:self action:@selector(enterImageVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == (self.dataArray.count - 1 )) {
            
            if (currentHeightOne <= currentHeightTwo) {
                
                _mainScrollView.contentSize = CGSizeMake(WIDTH, currentHeightTwo);
            }else{
                _mainScrollView.contentSize = CGSizeMake(WIDTH, currentHeightOne);
            }
        }
    }
}
- (void) setImageDetailRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDiac = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDiac setObject:skey forKey:@"skey"];
    [paraDiac setObject:reqTime forKey:@"reqTime"];
    [paraDiac setObject:self.albumId forKey:@"albumId"];
    [paraDiac setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDiac setObject:[NSNumber numberWithInt:self.pageSize] forKey:@"pageSize"];
    [NetWorkTask postResquestWithApiName:ImageDetail paraDic:paraDiac delegate:delegate];
    self.currentApiName = ImageDetail;
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    if ([self.currentApiName isEqualToString:ImageDetail]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            if (!self.isFirstRequest) {
                self.isFirstRequest = YES;
                self.obj = obj;
                [self loadEncryView];
            }
            
            self.dataCount = [obj.retData.dataCount intValue];
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
 
            [self loadImages];
            [self stopLoading];
            [_mainScrollView.mj_footer endRefreshing];
            [_mainScrollView.mj_header endRefreshing];
            
        }else{
            [self stopLoading];
        }
    }

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

/*图片详情*/
- (void) enterImageVC:(UIButton *) button{

    CMLImageShowVC *vc = [[CMLImageShowVC alloc] initWithTag:(int)button.tag dataArray:self.detailDataArray originImageUrlArray:self.imageUrlArray];
    vc.albumId = self.albumId;
    vc.dataCount = self.dataCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return [CustomTransition transitionWith:PushCustomTransition];
    }else{
        return [DefaultTransition transitionWith:PopDefaultTransition];
    }
    
}

- (void) loadEncryView{
    
    if ([self.obj.retData.isChild intValue] == 1) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 24*Proportion - 78*Proportion,
                                                                   HEIGHT - 144*Proportion - 78*Proportion,
                                                                   78*Proportion,
                                                                   78*Proportion)];
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:[UIImage imageNamed:ChildImageEncryptImg] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(enterNewImages) forControlEvents:UIControlEventTouchUpInside];
    }

    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _effectView.frame = CGRectMake(0,
                                   0,
                                   WIDTH,
                                   HEIGHT);
    [self.view addSubview:_effectView];
    
    self.encrptNumView = [[CMLEncryptNumView alloc] init];
    self.encrptNumView.center = CGPointMake(WIDTH/2.0, HEIGHT/2.0);
    self.encrptNumView.delegate = self;
    [self.view addSubview:self.encrptNumView];
    
    if ([self.obj.retData.isEncrypt intValue] == 1) {
        _effectView.hidden = NO;
        _encrptNumView.hidden = NO;
    }else{
        _effectView.hidden = YES;
        _encrptNumView.hidden = YES;
    }

}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.boardShow) {
    
        [self.view endEditing:YES];

    }else{

        [[VCManger mainVC] dismissCurrentVC];
        _effectView.hidden = YES;
        self.encrptNumView.hidden = YES;
    }

}

- (void) keyboardShow{
    
    self.boardShow = YES;
    
}

- (void) keyboardHidden{
    
    self.boardShow = NO;
}


#pragma mark - CMLEncryptNumViewDelegate
- (void) confirmEncryptNum{
    
    if ([self.encrptNumView.inputEncrptNumField.text isEqualToString:[NSString stringWithFormat:@"%@",self.obj.retData.encryptNum]]) {
        
        [self showSuccessTemporaryMes:@"密码正确"];
        [self performSelector:@selector(showImages) withObject:nil afterDelay:0];
        
    }else{
        
        [self showFailTemporaryMes:@"密码错误"];
    }
}

- (void) showImages{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.effectView.alpha = 0;
        weakSelf.encrptNumView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        weakSelf.effectView.hidden = YES;
        weakSelf.encrptNumView.hidden = YES;
        
    }];

}

- (void) enterNewImages{
    
    NSLog(@"***self.obj.retData.childId = %@",self.obj.retData.childId);
    CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:self.obj.retData.childId ImageName:self.imageName];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.boardShow = YES;
}
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}
*/
- (void)loadMoreImages {
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    if (self.dataArray.count % self.pageSize == 0) {
        if (self.dataArray.count != self.dataCount) {
            
            if (self.page == 25) {
                
                self.page++;
                self.bigPage = self.page + 1;
                [self.dataArray removeAllObjects];
                [_mainScrollView removeFromSuperview];
                [self loadViewViews];
                [self setImageDetailRequest];
            }else {

                self.page++;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[SDImageCache sharedImageCache] cleanDisk];
                });
                
                [self setImageDetailRequest];
            }
            
        }else {
            [_mainScrollView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else {
        [_mainScrollView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

@end
