//
//  CMLPhotoViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/1/28.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLPhotoViewController.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "VCManger.h"
#import "WaterFallModel.h"
#import "WaterCollectionViewCell.h"
#import "CMLEncryptNumView.h"
#import "BaseResultObj.h"
#import "CMLImagleDetailObj.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImgSize.h"
#import "CMLImageShowVC.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CustomTransition.h"
#import "DefaultTransition.h"

static NSString *const waterFallCellId = @"WaterCollectionViewCell";

@interface CMLPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, NavigationBarProtocol, NetWorkProtocol, CMLEncryptNumViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataListArray;

@property (nonatomic, strong) NSMutableArray  * imagesArray;

@property (nonatomic, strong) UICollectionView * collectionView;

/** 列数 */
@property (nonatomic, assign) NSUInteger columnCount;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) BOOL isFirstRequest;

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic,strong) CMLEncryptNumView *encrptNumView;

@property (nonatomic, strong) NSNumber *albumId;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) NSNumber *dataCount;

@property (nonatomic, strong) CMLEncryptNumView *encrotNumView;

@property (nonatomic, assign) BOOL boardShow;

@end

@implementation CMLPhotoViewController

- (instancetype)initWithAlbumId:(NSNumber *) albumId ImageName:(NSString *) imageName {
    
    self = [super init];
    if (self) {
        self.albumId = albumId;
        self.imageName = imageName;
    }
    return self;
    
}

- (NSMutableArray *)dataListArray {
    
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
    
}

- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.titleContent = self.imageName;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    [self.navBar setNewShareBarItem];
    self.isFirstRequest = NO;
    [self loadMessageOfVC];
}

- (void)didSelectedLeftBarItem {
    [[VCManger mainVC] dismissCurrentVC];
}

- (void)didSelectedRightBarItem {
    [self showCurrentVCShareView];
}

- (void)setShareData {
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImageUrl]];
    UIImage *image = [UIImage imageWithData:imageNata];
    
    CMLImagleDetailObj *obj = [CMLImagleDetailObj getBaseObjFrom:[self.dataListArray firstObject]];

    self.baseShareContent = obj.briefIntro;
    self.baseShareTitle   = self.imageName;
    self.baseShareImage   = image;
    self.baseShareLink    = self.obj.retData.shareUrl;
    __weak typeof(self) weakSelf = self;
    self.shareSuccessBlock = ^{
        [weakSelf hiddenCurrentVCShareView];
    };
    
}

- (void) loadMessageOfVC{
    [self loadData];
    [self setupLayoutAndCollectionView];
}

- (void)loadData {
    self.page = 1;
    self.pageSize = 30;
    [self startLoading];
    [self setRequest];
}

- (void)setupLayoutAndCollectionView {
    
    CHTCollectionViewWaterfallLayout *flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    flowLayout.columnCount = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(10 * Proportion, 10 * Proportion, 10 * Proportion, 10 * Proportion);
    flowLayout.minimumColumnSpacing = 10 * Proportion;
    flowLayout.minimumInteritemSpacing = 10 * Proportion;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.navBar.frame),
                                                                             WIDTH,
                                                                             HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)
                                             collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor CMLUserGrayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:waterFallCellId];
    
    self.collectionView.backgroundColor = [UIColor CMLWhiteColor];
    
    [self.contentView addSubview:self.collectionView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    /**上拉加载*/
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreImage)];
    
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WaterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:waterFallCellId forIndexPath:indexPath];
    
    cell.obj = [CMLImagleDetailObj getBaseObjFrom:self.dataListArray[indexPath.item]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLImageShowVC *vc = [[CMLImageShowVC alloc] initWithTag:(int)indexPath.row dataArray:self.dataListArray originImageUrlArray:self.imagesArray];
    
    vc.albumId = self.albumId;
    vc.dataCount = [self.dataCount intValue];

    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLImagleDetailObj *obj = [CMLImagleDetailObj getBaseObjFrom:self.dataListArray[indexPath.item]];
    
    if (obj.picObjInfo.picHeight == 0 || obj.picObjInfo.picWidth == 0) {
        CGSize imageSize = [UIImage getImageSizeWithURL:obj.coverPicThumb];
        return CGSizeMake(imageSize.width, imageSize.height);
    } else {
        return CGSizeMake([obj.picObjInfo.picWidth floatValue], [obj.picObjInfo.picHeight floatValue]);
    }
    
}

- (void)setRequest {
    
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

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0 && obj) {
        
        if (!self.isFirstRequest) {
            
            self.isFirstRequest = YES;
            self.obj = obj;
            [self loadEncryView];
            
        }
        
        self.dataCount = obj.retData.dataCount;
        
        if (self.page == 1) {
            
            [self.dataListArray removeAllObjects];
            [self.dataListArray addObjectsFromArray:obj.retData.dataList];
            
        }else{
            
            [self.dataListArray addObjectsFromArray:obj.retData.dataList];
        }
        [NSThread detachNewThreadSelector:@selector(setShareData) toTarget:self withObject:nil];
        [self.collectionView reloadData];
        
    }else{
        
        [self showNetErrorTipOfNormalVC];
    }
    
    [self stopLoading];
    [self hideNetErrorTipOfNormalVC];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self showNetErrorTipOfNormalVC];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    
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
        [self.view endEditing:YES];
        [self performSelector:@selector(showImages) withObject:nil afterDelay:0];
        
    }else{
        
        [self showFailTemporaryMes:@"密码错误"];
    }
}

- (void)showImages{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.effectView.alpha = 0;
        weakSelf.encrptNumView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        weakSelf.effectView.hidden = YES;
        weakSelf.encrptNumView.hidden = YES;
        
    }];
    
}

- (void)enterNewImages {
    
    CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:self.obj.retData.childId ImageName:self.imageName];
    vc.shareImageUrl = self.shareImageUrl;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    self.pageSize = 30;
    [self.dataListArray removeAllObjects];
    [self.imagesArray removeAllObjects];
    [self setRequest];
    
}

- (void) loadMoreImage{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    if (self.dataListArray.count % self.pageSize == 0) {
        if (self.dataListArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setRequest];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else{
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
