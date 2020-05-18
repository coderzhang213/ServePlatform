//
//  CMLVIPNewsImageShowVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLVIPNewsImageShowVC.h"
#import "NFPhotoViewCell.h"
#import "VIPImageObj.h"
#import "VCManger.h"
#import "CustomTransition.h"

#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
//width of window when equipment vertical screen
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width


@interface CMLVIPNewsImageShowVC ()<UICollectionViewDelegate,UICollectionViewDataSource,NavigationBarProtocol,UIScrollViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UICollectionView *photoCollectionview;

@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic,assign) int currentTag;

@end

@implementation CMLVIPNewsImageShowVC

- (instancetype)initWithTag:(int) tag andImagesArray:(NSArray *) imagesArray{

    self = [super init];
    if (self) {
        self.imageArray = imagesArray;
        self.currentTag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self loadViews];
    
}

- (void) loadViews{
    
    //创建右边的collectionview
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
    
    return self.imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NFPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NFPhotoViewCell" forIndexPath:indexPath];
    [cell showViewInfo:self.imageArray indexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    cell.hiddenLikeNum = YES;
    [cell loadNewBtn];
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


@end
