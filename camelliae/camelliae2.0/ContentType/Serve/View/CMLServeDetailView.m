//
//  CMLServeDetailView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLServeDetailView.h"
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

@interface CMLServeDetailView()

@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) DetailMoreMessageWebView *otherMessageWebView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIView *moveLine;

@property (nonatomic,strong) CMLNewMoreMesView *moreMesView;

@property (nonatomic,strong) CMLBoutiqueView *boutiqueView;

@end

@implementation CMLServeDetailView

- (instancetype)initWith:(BaseResultObj *) obj{
    
    self = [super init];
    if (self) {
    
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    float ratio = 0;
    if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] == 0) {
        
        ratio = 2.0;
        
    }else{
        
        ratio = 3.0;
    }
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH/ratio,
                                                                     70*Proportion)];
    detailBtn.backgroundColor = [UIColor clearColor];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = KSystemFontSize14;
    [detailBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self addSubview:detailBtn];
    [detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *costBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/ratio,
                                                                   0,
                                                                   WIDTH/ratio,
                                                                   70*Proportion)];
    costBtn.backgroundColor = [UIColor clearColor];
    costBtn.titleLabel.font = KSystemFontSize14;
    [costBtn setTitle:@"费用" forState:UIControlStateNormal];
    [costBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [self addSubview:costBtn];
    [costBtn addTarget:self action:@selector(showCost:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] != 0) {
     
        UIButton *boutiqueBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/ratio*(ratio - 1.0),
                                                                           0,
                                                                           WIDTH/ratio,
                                                                           70*Proportion)];
        boutiqueBtn.backgroundColor = [UIColor clearColor];
        boutiqueBtn.titleLabel.font = KSystemFontSize14;
        [boutiqueBtn setTitle:@"精品" forState:UIControlStateNormal];
        [boutiqueBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [self addSubview:boutiqueBtn];
        [boutiqueBtn addTarget:self action:@selector(showBoutique:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.moveLine = [[UIView alloc] initWithFrame:CGRectMake(detailBtn.center.x - 50*Proportion/2.0,
                                                             CGRectGetMaxY(detailBtn.frame) - 2*Proportion
                                                             ,
                                                             50*Proportion,
                                                             2*Proportion)];
    self.moveLine.backgroundColor = [UIColor CMLBlackColor];
    [self addSubview:self.moveLine];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                 CGRectGetMaxY(self.moveLine.frame) - 1*Proportion,
                                                                 WIDTH - 30*Proportion*2,
                                                                 1*Proportion)];
    spaceLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:spaceLine];
    
    
    self.informationWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
    self.informationWkView.frame = CGRectMake(0,
                                              CGRectGetMaxY(detailBtn.frame) + 20*Proportion,
                                              WIDTH,
                                              1000);
    self.informationWkView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.informationWkView];
    
    __weak typeof(self) weakSelf = self;
    self.informationWkView.loadWebViewFinish = ^(CGFloat height){
        
        weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                                      weakSelf.informationWkView.frame.origin.y,
                                                      WIDTH,
                                                      height);
        
        weakSelf.moreMesView = [[CMLNewMoreMesView alloc] initWith:weakSelf.obj.retData.RelateRecomm.dataList];
        weakSelf.moreMesView.frame = CGRectMake(0,
                                                CGRectGetMaxY(weakSelf.informationWkView.frame),
                                                WIDTH,
                                                weakSelf.moreMesView.currentHeight);
        [weakSelf addSubview:weakSelf.moreMesView];
        weakSelf.currentHeight = CGRectGetMaxY(weakSelf.moreMesView.frame) ;
        
        [weakSelf.delegate finshLoadDetailView];
        
    };
    
    self.otherMessageWebView = [[DetailMoreMessageWebView alloc] initWith:self.obj];
    self.otherMessageWebView.frame = CGRectMake(0,
                                                CGRectGetMaxY(detailBtn.frame) + 20*Proportion,
                                                WIDTH,
                                                0);
    self.otherMessageWebView.hidden = YES;
    self.otherMessageWebView.loadWebViewFinish = ^(CGFloat currentHeight){
        
        weakSelf.otherMessageWebView.frame = CGRectMake(0,
                                                        CGRectGetMaxY(detailBtn.frame) + 20*Proportion,
                                                        WIDTH,
                                                        currentHeight);
        
    };
    
    [self addSubview:self.otherMessageWebView];
    
    
    if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] != 0) {
    
        self.boutiqueView = [[CMLBoutiqueView alloc] initWithObj:self.obj];
        self.boutiqueView.frame = CGRectMake(0,
                                             CGRectGetMaxY(detailBtn.frame) + 20*Proportion,
                                             WIDTH,
                                             self.boutiqueView.currentHeight);
        self.boutiqueView.hidden = YES;
        [self addSubview:self.boutiqueView];
    }
}

- (void) showDetail:(UIButton *) btn{
    
    if (self.informationWkView.hidden) {
        
        self.informationWkView.hidden = NO;
        self.otherMessageWebView.hidden = YES;
        self.boutiqueView.hidden = YES;
        self.moreMesView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.informationWkView.frame),
                                            WIDTH,
                                            self.moreMesView.currentHeight);
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

- (void) showCost:(UIButton *) btn{
    
    if (self.otherMessageWebView.hidden) {
        
        self.otherMessageWebView.hidden = NO;
        self.informationWkView.hidden = YES;
        self.boutiqueView.hidden = YES;
        self.moreMesView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.otherMessageWebView.frame),
                                            WIDTH,
                                            self.moreMesView.currentHeight);
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

- (void) showBoutique:(UIButton *) btn{
    
    [CMLMobClick Qulitycommoditysupplement];
    
    if (self.boutiqueView.hidden) {
        
        self.boutiqueView.hidden = NO;
        self.otherMessageWebView.hidden = YES;
        self.informationWkView.hidden = YES;
        self.moreMesView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.boutiqueView.frame),
                                            WIDTH,
                                            self.moreMesView.currentHeight
                                            );
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
