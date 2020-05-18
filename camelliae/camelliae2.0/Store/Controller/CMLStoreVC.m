//
//  CMLStoreVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLStoreVC.h"
#import "ActivityTypeObj.h"
#import "CMLStoreTableView.h"
#import "StoreTopView.h"
#import "CMLBrandTableView.h"
#import "CMLServeSelectView.h"
#import "CMLServeTypeTableView.h"
#import "CMLStoreGoodsCollectionView.h"
#import "StoreFirstTypeView.h"
#import "CMLALLBrandTableView.h"
#import "VCManger.h"


@interface CMLStoreVC ()<CMLBaseTableViewDlegate,StoreTopViewDelegate,CMLBrandTableViewDelegate,CMLServeSelectViewDelegate,CMLBaseCollectionViewDlegate,StoreFirstTypeViewDelegate, CMLStoreGoodsCollectionViewDelegate>

@property (nonatomic,strong) CMLStoreTableView *multipleTableView;

@property (nonatomic,strong) CMLBrandTableView *brandTableView;

@property (nonatomic,strong) StoreTopView *topView;

@property (nonatomic,strong) CMLServeSelectView *serveSelectView;

@property (nonatomic,strong) CMLServeTypeTableView *serveTypeTableView;

@property (nonatomic,strong) CMLStoreGoodsCollectionView *goodsRecommendCollectionView;

@property (nonatomic,strong) StoreFirstTypeView *goodsTypeView;

@property (nonatomic,strong) StoreFirstTypeView *brandTypeView;

@property (nonatomic,strong) CMLALLBrandTableView *allBrandView;

@property (nonatomic,assign) BOOL isJump;

@property (nonatomic,assign) int currentSeclectIndex;


@end

@implementation CMLStoreVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectGoods) name:@"selectStoreGoodss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectServe) name:@"selectStoreServe" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectStoreGoodss" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectStoreServe" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.hidden = YES;
    
    self.currentSeclectIndex = 0;
    
    self.topView = [[StoreTopView alloc] init];
    self.topView.backgroundColor = [UIColor CMLWhiteColor];
    self.topView.delegate = self;
//    self.topView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.topView.layer.shadowOpacity = 0.05;
//    self.topView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.contentView addSubview:self.topView];
    
    [self loadViews];
    
    [self.contentView bringSubviewToFront:self.topView];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
        [weakSelf startLoading];
        [weakSelf.goodsRecommendCollectionView pullRefreshOfHeader];
    };

}

- (void) loadViews{
    
    [self loadGoodsType];
    
}


/**服务推荐*/
- (void) loadServeView{
    
    if (self.multipleTableView) {
        
        self.multipleTableView.hidden = NO;
//        self.brandTableView.hidden = YES;
        self.serveTypeTableView.hidden = YES;
    }else{
        
        [self startLoading];
        
        self.multipleTableView = [[CMLStoreTableView alloc] initWithFrame:CGRectMake(0,
                                                                                     CGRectGetMaxY(self.serveSelectView.frame),
                                                                                     WIDTH,
                                                                                     HEIGHT - UITabBarHeight - StatusBarHeight - 80*Proportion - SafeAreaBottomHeight)
                                                                    style:UITableViewStylePlain];
        self.multipleTableView.baseTableViewDlegate = self;
        [self.contentView addSubview:self.multipleTableView];
        [self startLoading];
        
        /*****
        
        if (self.isJump) {
         
            [self selectIndex:1];
            [self.topView refreshSelectIndex:1];
        }
        *****/
    }
    
    [self.contentView bringSubviewToFront:self.topView];
}

/**单品分类*/
- (void) loadGoodsType{
    
    if (self.goodsTypeView) {
        
        self.goodsTypeView.hidden = NO;
        self.goodsRecommendCollectionView.hidden = NO;
        
    }else{
        
        [self startLoading];
        
        self.goodsTypeView = [[StoreFirstTypeView alloc] initWithType:[NSNumber numberWithInt:7]];
        self.goodsTypeView.delegate = self;
        self.goodsTypeView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.topView.frame),
                                              WIDTH,
                                              self.goodsTypeView.currentheight);
        [self.contentView addSubview:self.goodsTypeView];
        
        [self loadGoodsView];
        /*****/
        
//        if (self.isJump) {
//
//            [self selectIndex:1];
//            [self.topView refreshSelectIndex:1];
//        }
        /*****/

        
    }
    
     [self.contentView bringSubviewToFront:self.topView];
}

- (void) loadGoodsView{
        
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(360*Proportion ,[self getCellHeight]);
    layout.minimumLineSpacing = 50*Proportion;

    self.goodsRecommendCollectionView = [[CMLStoreGoodsCollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                                                CGRectGetMaxY(self.goodsTypeView.frame),
                                                                                                        WIDTH,
                                                                                                        HEIGHT - CGRectGetMaxY(self.goodsTypeView.frame)- SafeAreaBottomHeight - UITabBarHeight)
                                                                        collectionViewLayout:layout];


    self.goodsRecommendCollectionView.baseCollectionViewDlegate = self;
    self.goodsRecommendCollectionView.storeGoodsCollectionViewDelegate = self;
    [self.contentView addSubview:self.goodsRecommendCollectionView];

    [self.contentView bringSubviewToFront:self.topView];
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


- (void) loadBrandType{
    
    if (self.brandTypeView) {
        
        self.brandTypeView.hidden = NO;
        
        if ([self.brandTypeView.firstSelectIndexID integerValue] == 100) {
            
            [self loadBrandView];
        }else{
            
            [self loadAllBrandView];
        }
        
    }else{
        
        [self startLoading];
        
        self.brandTypeView = [[StoreFirstTypeView alloc] initWithType:[NSNumber numberWithInt:0]];
        self.brandTypeView.delegate = self;
        self.brandTypeView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.topView.frame),
                                              WIDTH,
                                              self.brandTypeView.currentheight);
        [self.contentView addSubview:self.brandTypeView];
        
        
        [self loadAllBrandView];
    }
    
}

- (void) loadBrandView{
    
    
    if (self.brandTableView) {
        
        self.brandTableView.hidden = NO;
        self.allBrandView.hidden = YES;
    }else{
     
        [self startLoading];
        
        /**选择框*/
        self.brandTableView = [[CMLBrandTableView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetMaxY(self.brandTypeView.frame),
                                                                                  WIDTH,
                                                                                  HEIGHT - CGRectGetMaxY(self.brandTypeView.frame) - SafeAreaBottomHeight - UITabBarHeight)
                                                                 style:UITableViewStyleGrouped];
        self.brandTableView.baseTableViewDlegate = self;
        self.brandTableView.brandTableViewDelegate = self;
        [self.contentView addSubview:self.brandTableView];
        [self.contentView bringSubviewToFront:self.topView];
        
    }
    
     [self.contentView bringSubviewToFront:self.topView];
}

- (void) loadAllBrandView{
    
    if (self.allBrandView) {
        
        self.brandTableView.hidden = YES;
        self.allBrandView.hidden = NO;
    }else{
        
        [self startLoading];
        self.allBrandView = [[CMLALLBrandTableView alloc] initWithFrame:CGRectMake(0,
                                                                                   CGRectGetMaxY(self.brandTypeView.frame),
                                                                                   WIDTH,
                                                                                   HEIGHT - CGRectGetMaxY(self.brandTypeView.frame) - SafeAreaBottomHeight - UITabBarHeight)
                                                                  style:UITableViewStylePlain];
        self.allBrandView.baseTableViewDlegate = self;
        self.allBrandView.backgroundColor = [UIColor CMLWhiteColor];
        [self.contentView addSubview:self.allBrandView];
    }

     [self.contentView bringSubviewToFront:self.topView];
}

/**服务分类*/
- (void) loadServeTypeView{
    
    
    if (self.serveSelectView) {
        
        self.serveSelectView.hidden = NO;
        
        if (self.serveSelectView.firstSelectIndex == 0) {
            
            self.serveTypeTableView.hidden = YES;
            self.multipleTableView.hidden = NO;
        }else{
            
            self.serveTypeTableView.hidden = NO;
            self.multipleTableView.hidden = YES;
        }

        
    }else{
        
        [self startLoading];
        
        self.serveSelectView = [[CMLServeSelectView alloc] init];
        self.serveSelectView.delegate = self;
        self.serveSelectView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.topView.frame),
                                                WIDTH,
                                                self.serveSelectView.frame.size.height);
        [self.contentView addSubview:self.serveSelectView];
        
        self.serveTypeTableView = [[CMLServeTypeTableView alloc] initWithFrame:CGRectMake(0,
                                                                                          CGRectGetMaxY(self.serveSelectView.frame),
                                                                                          WIDTH, HEIGHT - UITabBarHeight - StatusBarHeight - 80*Proportion -
                                                                                          self.serveSelectView.frame.size.height - SafeAreaBottomHeight - UITabBarHeight)
                                                                         style:UITableViewStylePlain];
        self.serveTypeTableView.baseTableViewDlegate = self;
        [self.contentView addSubview:self.serveTypeTableView];
        
        

    }
    
    [self.contentView bringSubviewToFront:self.topView];
    
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

- (void)tableViewDidScroll:(CGFloat)Y{
    
    if (Y < self.brandTableView.tagHeight) {
        
        self.brandTableView.sectionIndexColor = [UIColor clearColor];
        
    }else{
        self.brandTableView.sectionIndexColor = [UIColor CMLBlackColor];
    }
    
}

- (void) TableViewScrollToTop{
    
    [self.brandTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void) tableScrollUp{

    
    if (self.currentSeclectIndex == 1) {
        
        if (self.serveSelectView.currentHeight != 70*Proportion) {
            
            if (self.serveSelectView.frame.origin.y == CGRectGetMaxY(self.topView.frame)) {
                
                __weak typeof(self) weakSelf = self;
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    weakSelf.serveSelectView.frame = CGRectMake(0,
                                                                CGRectGetMaxY(self.topView.frame) - 70*Proportion,
                                                                WIDTH,
                                                                weakSelf.serveSelectView.currentHeight);
                    
                    weakSelf.serveTypeTableView.frame = CGRectMake(0,
                                                                   CGRectGetMaxY(weakSelf.serveSelectView.frame),
                                                                   WIDTH,
                                                                   HEIGHT - UITabBarHeight - CGRectGetMaxY(weakSelf.serveSelectView.frame) - SafeAreaBottomHeight);
                }];
            }
        }
    }
}

- (void) tableScrollDown{
    
    if (self.currentSeclectIndex == 1) {
        
         if (self.serveSelectView.currentHeight != 70*Proportion) {
             
             if (self.serveSelectView.frame.origin.y != CGRectGetMaxY(self.topView.frame)) {
                 
                 __weak typeof(self) weakSelf = self;
                 
                 [UIView animateWithDuration:0.2 animations:^{
                     
                     weakSelf.serveSelectView.frame = CGRectMake(0,
                                                                 CGRectGetMaxY(self.topView.frame),
                                                                 WIDTH,
                                                                 weakSelf.serveSelectView.currentHeight);
                     weakSelf.serveTypeTableView.frame = CGRectMake(0,
                                                                    CGRectGetMaxY(weakSelf.serveSelectView.frame),
                                                                    WIDTH,
                                                                    HEIGHT - UITabBarHeight - CGRectGetMaxY(weakSelf.serveSelectView.frame) - SafeAreaBottomHeight);
                 }];
             }
         }
    }
}
#pragma mark - StoreTopViewDelegate
- (void) selectIndex:(int) index{
    
    /*单品0*/
    if (index == 0 ) {

        self.currentSeclectIndex = 0;
        self.serveSelectView.hidden = YES;
        self.multipleTableView.hidden = YES;
        self.serveTypeTableView.hidden = YES;
        self.brandTableView.hidden = YES;
        self.brandTypeView.hidden = YES;
        self.allBrandView.hidden = YES;
        [self loadGoodsType];

        
    }else if(index == 2){/*品牌*/
        
        self.currentSeclectIndex = 2;
        self.multipleTableView.hidden = YES;
        self.serveSelectView.hidden = YES;
        self.serveTypeTableView.hidden = YES;
        self.goodsTypeView.hidden = YES;
        self.goodsRecommendCollectionView.hidden = YES;
        [self loadBrandType];
        
    }else if(index == 1){/*服务*/
        
        self.currentSeclectIndex = 1;
        self.brandTableView.hidden = YES;
        self.brandTypeView.hidden = YES;
        self.allBrandView.hidden = YES;
        self.goodsTypeView.hidden = YES;
        self.goodsRecommendCollectionView.hidden = YES;
        [self loadServeTypeView];
    }
}

#pragma mark - CMLServeSelectViewDelegate
- (void) selectParentTypeID:(NSNumber *) parentTypeID typeID:(NSNumber *) typeID{
    
    if ([parentTypeID intValue] == [typeID intValue] && [typeID intValue] == 0) {
        
        self.serveSelectView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.topView.frame),
                                                WIDTH,
                                                self.serveSelectView.currentHeight);
        self.serveTypeTableView.frame = CGRectMake(0,
                                                   CGRectGetMaxY(self.serveSelectView.frame),
                                                   WIDTH, HEIGHT - UITabBarHeight - StatusBarHeight - 80*Proportion -
                                                   self.serveSelectView.currentHeight - SafeAreaBottomHeight);
        [self loadServeView];
    }else{
        
        
        self.brandTableView.hidden = YES;
        self.allBrandView.hidden = YES;
        self.multipleTableView.hidden = YES;
        self.serveTypeTableView.hidden = NO;
        
        [self startLoading];
        
        
        if ([typeID intValue] == 0) {
           
            self.serveSelectView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(self.topView.frame),
                                                    WIDTH,
                                                    self.serveSelectView.currentHeight);
            self.serveTypeTableView.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.serveSelectView.frame),
                                                       WIDTH, HEIGHT - UITabBarHeight - StatusBarHeight - 80*Proportion -
                                                       self.serveSelectView.currentHeight - SafeAreaBottomHeight);
            
        }else{
            
            if (self.serveSelectView.frame.size.height != 210*Proportion) {
                
                self.serveSelectView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(self.topView.frame),
                                                        WIDTH,
                                                        self.serveSelectView.currentHeight);
                self.serveTypeTableView.frame = CGRectMake(0,
                                                           CGRectGetMaxY(self.serveSelectView.frame),
                                                           WIDTH, HEIGHT - UITabBarHeight - StatusBarHeight - 80*Proportion -
                                                           self.serveSelectView.currentHeight - SafeAreaBottomHeight);
            }

            
        }
        
        self.serveTypeTableView.contentOffset = CGPointMake(0, 0);
        [self.serveTypeTableView refreshTableWithParentServeTypeID:parentTypeID andTypeID:typeID];
        
    }

    
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

#pragma mark - CMLStoreGoodsCollectionViewDelegate
- (void)netErrorOfStoreGoodsCollectionView {
    [self showNetErrorTipOfMainVC];
}

- (void)stopLoadingViewOfRefresh {
    [self stopLoading];
}

- (void)hideNetErrorOfStoreGoodsCollectionView {
    [self hideNetErrorTipOfMainVC];
}


#pragma mark - StoreFirstTypeViewDelegate
- (void) refreshContentWith:(NSString *) nameID andID:(NSNumber *) typeID{
    
    if (self.currentSeclectIndex == 0) {
        
        [self.goodsRecommendCollectionView refreshTableViewWithTypeID:typeID];
    }else{
        
        if ([typeID intValue] == 100) {
            
            [self loadBrandView];
            
        }else{
            
            self.brandTableView.hidden = YES;
            self.allBrandView.hidden = NO;
            [self.allBrandView refreshTableViewWithTypeID:typeID];
        }
    }
}

- (void) selectGoods{
    
    if (self.goodsTypeView) {
        
        [self selectIndex:0];
        [self.topView refreshSelectIndex:0];
        
    }
}

- (void) selectServe{
    
    if (self.goodsTypeView) {
        
        [self selectIndex:1];
        [self.topView refreshSelectIndex:1];
    }else {
        self.isJump = YES;
    }
}
@end
