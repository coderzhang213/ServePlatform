//
//  CMLNewAssociatedProductsView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/7.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLNewAssociatedProductsView.h"
#import "BaseResultObj.h"
#import "WKWebView+CMLExspand.h"
#import <WebKit/WebKit.h>
#import "InformationWkView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "DetailMoreMessageWebView.h"
#import "CMLBoutiqueView.h"
#import "CMLNewMoreMesView.h"
#import "NewMoreMesObj.h"
#import "RelateQualityObj.h"
#import "CMLMobClick.h"

@interface CMLNewAssociatedProductsView()

@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) DetailMoreMessageWebView *otherMessageWebView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIView *moveLine;

@property (nonatomic,strong) CMLNewMoreMesView *moreMesView;

@property (nonatomic,strong) CMLBoutiqueView *boutiqueView;

@end

@implementation CMLNewAssociatedProductsView
- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
        
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    CGFloat ratio = 1;
    
    if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] + self.obj.retData.RelateRecomm.dataList.count == 0) {
        
        self.hidden = YES;
        self.currentHeight = 0;
    }else{
        
        
        if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] > 0 && self.obj.retData.RelateRecomm.dataList.count == 0) {
            
            
            UIButton *boutiqueBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               WIDTH,
                                                                               70*Proportion)];
            boutiqueBtn.backgroundColor = [UIColor clearColor];
            [boutiqueBtn setTitle:@"品牌推荐" forState:UIControlStateNormal];
            boutiqueBtn.titleLabel.font = KSystemRealBoldFontSize14;
            [boutiqueBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self addSubview:boutiqueBtn];
            
            self.boutiqueView = [[CMLBoutiqueView alloc] initWithObj:self.obj];
            self.boutiqueView.frame = CGRectMake(0,
                                                 70*Proportion + 20*Proportion,
                                                 WIDTH,
                                                 self.boutiqueView.currentHeight);
            [self addSubview:self.boutiqueView];
            
            self.currentHeight = CGRectGetMaxY(self.boutiqueView.frame) ;
            

        }else if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] == 0 && self.obj.retData.RelateRecomm.dataList.count > 0){
            
            
            UIButton *moreRecommendBrandBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                         0,
                                                                                         WIDTH,
                                                                                         70*Proportion)];
            moreRecommendBrandBtn.backgroundColor = [UIColor clearColor];
            [moreRecommendBrandBtn setTitle:@"相关推荐" forState:UIControlStateNormal];
            moreRecommendBrandBtn.titleLabel.font = KSystemRealBoldFontSize14;
            [moreRecommendBrandBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self addSubview:moreRecommendBrandBtn];
            
            self.moreMesView = [[CMLNewMoreMesView alloc] initWith:self.obj.retData.RelateRecomm.dataList];
            self.moreMesView.frame = CGRectMake(0,
                                                70*Proportion + 20*Proportion,
                                                WIDTH,
                                                self.moreMesView.currentHeight);
            [self addSubview:self.moreMesView];
            self.currentHeight = CGRectGetMaxY(self.moreMesView.frame) ;
            
            
        }else if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] > 0 && self.obj.retData.RelateRecomm.dataList.count > 0){
            
            
            ratio = 2;
            
            UIButton *boutiqueBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             WIDTH/2,
                                                                             70*Proportion)];
            boutiqueBtn.backgroundColor = [UIColor clearColor];
            [boutiqueBtn setTitle:@"品牌推荐" forState:UIControlStateNormal];
            boutiqueBtn.titleLabel.font = KSystemRealBoldFontSize14;
            [boutiqueBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self addSubview:boutiqueBtn];
            [boutiqueBtn addTarget:self action:@selector(showBoutique:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *moreRecommendBrandBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2,
                                                                           0,
                                                                           WIDTH/2,
                                                                           70*Proportion)];
            moreRecommendBrandBtn.backgroundColor = [UIColor clearColor];
            moreRecommendBrandBtn.titleLabel.font = KSystemRealBoldFontSize14;
            [moreRecommendBrandBtn setTitle:@"相关推荐" forState:UIControlStateNormal];
            [moreRecommendBrandBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
            [self addSubview:moreRecommendBrandBtn];
            [moreRecommendBrandBtn addTarget:self action:@selector(showRecommendBrand:) forControlEvents:UIControlEventTouchUpInside];
            
            
            self.boutiqueView = [[CMLBoutiqueView alloc] initWithObj:self.obj];
            self.boutiqueView.frame = CGRectMake(0,
                                                 70*Proportion + 20*Proportion,
                                                 WIDTH,
                                                 self.boutiqueView.currentHeight);
            [self addSubview:self.boutiqueView];
            
            self.moreMesView = [[CMLNewMoreMesView alloc] initWith:self.obj.retData.RelateRecomm.dataList];
            self.moreMesView.frame = CGRectMake(0,
                                                70*Proportion + 20*Proportion,
                                                WIDTH,
                                                self.moreMesView.currentHeight);
            self.moreMesView.hidden = YES;
            [self addSubview:self.moreMesView];
            self.currentHeight = CGRectGetMaxY(self.boutiqueView.frame) ;
        }
        
        
        /*****/
        self.moveLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/ratio/2.0 - 50*Proportion/2.0,
                                                                 70*Proportion - 2*Proportion
                                                                 ,
                                                                 50*Proportion,
                                                                 2*Proportion)];
        self.moveLine.backgroundColor = [UIColor CMLBlackColor];
        [self addSubview:self.moveLine];
        
    }
    

    
}


- (void) showBoutique:(UIButton *) btn{
    
    [CMLMobClick Qulitycommoditysupplement];
    
    if (self.boutiqueView.hidden) {
        
        self.boutiqueView.hidden = NO;
        self.moreMesView.hidden = YES;
        self.currentHeight = CGRectGetMaxY(self.boutiqueView.frame);
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            
            weakSelf.moveLine.frame = CGRectMake(btn.center.x - 50*Proportion/2.0,
                                                 CGRectGetMaxY(btn.frame) - 2*Proportion,
                                                 50*Proportion,
                                                 2*Proportion);
        }];
        
        [self.delegate changeShowView];
    }
    
}
- (void) showRecommendBrand:(UIButton *) btn{
    
    if (self.moreMesView.hidden) {
        
        self.moreMesView.hidden = NO;
        self.boutiqueView.hidden = YES;
        self.currentHeight = CGRectGetMaxY(self.moreMesView.frame);
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            
            weakSelf.moveLine.frame = CGRectMake(btn.center.x - 50*Proportion/2.0,
                                                 CGRectGetMaxY(btn.frame) - 2*Proportion,
                                                 50*Proportion,
                                                 2*Proportion);
        }];
        
        [self.delegate changeShowView];
    }
}

@end
