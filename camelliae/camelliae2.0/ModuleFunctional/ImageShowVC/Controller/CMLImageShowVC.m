//
//  CMLImageShowVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLImageShowVC.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NetConfig.h"
#import "NFPhotoViewCell.h"
#import "BaseResultObj.h"
#import "CMLImagleDetailObj.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "VCManger.h"
#import "CustomTransition.h"

#define PageSize                     10
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
//width of window when equipment vertical screen
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
static NSString *const idetifier = @"specialCell";

@interface CMLImageShowVC ()<UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol,NavigationBarProtocol,UIScrollViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) int currentTag;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *originImageUrlArray;

@property (nonatomic,strong) UICollectionView *photoCollectionview;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, copy) NSString *currentApiName;


@end

@implementation CMLImageShowVC

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)originImageUrlArray {
    
    if (!_originImageUrlArray) {
        _originImageUrlArray = [NSMutableArray array];
    }
    return _originImageUrlArray;
}

/*添加所有详情图Url到数组*/
- (void) addImageUrlToImageUrlArray {
    
    self.page = 1;
    self.pageSize = self.dataCount;
    [self startLoading];
    [self setImageDetailRequest];
    
}

- (instancetype)initWithTag:(int)currentTag dataArray:(NSMutableArray *) dataArray originImageUrlArray:(NSArray *)originImageUrlArray{

    self = [super init];
    if (self) {
        self.currentTag = currentTag;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor blackColor];
    [self addImageUrlToImageUrlArray];
    
}

- (void) loadViews{
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.photoCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 SCREEN_WIDTH +10,
                                                                                 SCREEN_HEIGHT )
                                                 collectionViewLayout:flowLayout];
    self.photoCollectionview.bounces = YES;
    self.photoCollectionview.delegate = self;
    self.photoCollectionview.dataSource = self;
    self.photoCollectionview.pagingEnabled = YES;
    self.photoCollectionview.showsHorizontalScrollIndicator = NO;
    self.photoCollectionview.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.photoCollectionview];
    
    //注册
    [self.photoCollectionview registerClass:[NFPhotoViewCell class]
                 forCellWithReuseIdentifier:@"NFPhotoViewCell"];
    
    if (self.currentTag) {
        [self.photoCollectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NFPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NFPhotoViewCell" forIndexPath:indexPath];
    CMLImagleDetailObj *obj = [CMLImagleDetailObj getBaseObjFrom:self.dataArray[indexPath.row]];
    cell.isLike = obj.isUserLike;
    cell.currentID = obj.picId;
    cell.hiddenLikeNum = YES;
    [cell loadNewBtn];
    [cell showViewInfo:self.originImageUrlArray indexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH,  self.photoCollectionview.bounds.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 0, 5, 10);
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    return [CustomTransition transitionWith:operation == UINavigationControllerOperationPush? PushCustomTransition:PopCustomTransition];
    
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
            
            self.dataCount = [obj.retData.dataCount intValue];
            
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            for (int i = 0; i < self.dataArray.count; i++) {
                CMLImagleDetailObj *obj = [CMLImagleDetailObj getBaseObjFrom:self.dataArray[i]];
                [self.originImageUrlArray addObject:obj.coverPic];
            }
            [self loadViews];
            [self stopLoading];
            
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

@end
