//
//  CMLContentModuleView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/6.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLContentModuleView.h"
#import "BaseResultObj.h"
#import "WKWebView+CMLExspand.h"
#import <WebKit/WebKit.h>
#import "InformationWkView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "DetailMoreMessageWebView.h"
#import "NewMoreMesObj.h"
#import "RelateQualityObj.h"
#import "CMLMobClick.h"
#import "CommonImg.h"
#import "CMLPicObjInfo.h"
#import "NetWorkTask.h"

@interface CMLContentModuleView()<UIScrollViewDelegate>


@property (nonatomic,strong) InformationWkView *informationWkView;

@property (nonatomic,strong) DetailMoreMessageWebView *otherMessageWebView;

@property (nonatomic,strong) InformationWkView *BrandStoryWKView;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,assign) ContentType currentType;

@property (nonatomic,strong) UILabel *pageLab;

@end

@implementation CMLContentModuleView

- (instancetype)initWith:(BaseResultObj *) obj andType:(ContentType) currentType{
    
    self = [super init];
    
    if (self) {
     
        self.obj = obj;
        NSLog(@"%d", currentType);
        self.currentType = currentType;
        [self loadViews];
    }
    
    return self;
}

- (void) loadContentViews{
    
    
}

- (void) loadViews{
    
    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ProductDetailImg]];
    if (self.currentType == productDetail) {
        
        topImage.image = [UIImage imageNamed:ProductDetailImg];
    }else if(self.currentType == costDetail){
        
        topImage.image = [UIImage imageNamed:ProductPriceImg];
    }else if (self.currentType == brandStory){
        
        topImage.image = [UIImage imageNamed:BrandStoryImg];
        
    }
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.clipsToBounds = YES;
    [topImage sizeToFit];
    topImage.frame = CGRectMake(WIDTH/2.0 - topImage.frame.size.width/2.0,
                                30*Proportion,
                                topImage.frame.size.width,
                                topImage.frame.size.height);
    [self addSubview:topImage];
    
    

    if (self.currentType == productDetail) {
        
        CGFloat tempHeight = CGRectGetMaxY(topImage.frame) + 40*Proportion;
        
        if (self.obj.retData.detailPicArr.count > 0) {
            
            UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                          tempHeight,
                                                                                          WIDTH,
                                                                                          WIDTH/17*20)];
            mainScrollView.pagingEnabled = YES;
            mainScrollView.delegate = self;
            [self addSubview:mainScrollView];
            mainScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.detailPicArr.count,
                                                    mainScrollView.frame.size.height);
            
            tempHeight = CGRectGetMaxY(mainScrollView.frame);
            
            for (int i = 0; i < self.obj.retData.detailPicArr.count; i++) {
             
                UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                         0,
                                                                                         WIDTH,
                                                                                         mainScrollView.frame.size.height)];
                moduleImage.contentMode = UIViewContentModeScaleAspectFill;
                moduleImage.clipsToBounds = YES;
                [mainScrollView addSubview:moduleImage];
                
                CMLPicObjInfo *picObj = [CMLPicObjInfo getBaseObjFrom:self.obj.retData.detailPicArr[i]];
                [NetWorkTask setImageView:moduleImage WithURL:picObj.coverPic placeholderImage:nil];
            }
            
            self.pageLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 32*Proportion - 79*Proportion,
                                                                     CGRectGetMaxY(mainScrollView.frame) - 35*Proportion - 35*Proportion,
                                                                     79*Proportion,
                                                                     35*Proportion)];
            self.pageLab.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.obj.retData.detailPicArr.count];
            NSLog(@"===============%@", self.pageLab.text);
            self.pageLab.textAlignment = NSTextAlignmentCenter;
            self.pageLab.font = KSystemFontSize13;
            self.pageLab.textColor = [UIColor CMLWhiteColor];
            self.pageLab.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
            [self addSubview:self.pageLab];
            
        }
        
        
        self.informationWkView = [[InformationWkView alloc] initWith:self.obj.retData.detailUrl];
        self.informationWkView.frame = CGRectMake(0,
                                                  tempHeight,
                                                  WIDTH,
                                                  1000);
        NSLog(@"self.informationWkView.frame.size.height = %f", self.informationWkView.frame.size.height);
        self.informationWkView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.informationWkView];
        
        __weak typeof(self) weakSelf = self;
        self.informationWkView.loadWebViewFinish = ^(CGFloat height){
            
            weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                                          weakSelf.informationWkView.frame.origin.y,
                                                          WIDTH,
                                                          height);
            NSLog(@"weakSelf.informationWkView.frame.size.height = %f", weakSelf.informationWkView.frame.size.height);
            NSLog(@"weakSelf.informationWkView.y = %f", CGRectGetMaxY(weakSelf.informationWkView.frame));
            
            weakSelf.informationWkView.frame = CGRectMake(weakSelf.informationWkView.frame.origin.x,
                                                          weakSelf.informationWkView.frame.origin.y,
                                                          WIDTH,
                                                          CGRectGetMaxY(weakSelf.informationWkView.frame));
            
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(weakSelf.informationWkView.frame) + 40*Proportion,
                                                                           WIDTH,
                                                                           20*Proportion)];
            NSLog(@"topLineView.frame.origin.y = %f", topLineView.frame.origin.y);
            topLineView.backgroundColor = [UIColor CMLNewActivityGrayColor];
            [weakSelf addSubview:topLineView];
            
            weakSelf.currentHeight = CGRectGetMaxY(topLineView.frame) ;
            
            [weakSelf.delegate finshLoadDetailView:productDetail];
            
        };
        
    }else if(self.currentType == costDetail){
        
     
        self.otherMessageWebView = [[DetailMoreMessageWebView alloc] initWith:self.obj];
        self.otherMessageWebView.frame = CGRectMake(0,
                                                    CGRectGetMaxY(topImage.frame) + 42*Proportion,
                                                    WIDTH,
                                                    0);
        [self addSubview:self.otherMessageWebView];
        __weak typeof(self) weakSelf = self;
        self.otherMessageWebView.loadWebViewFinish = ^(CGFloat currentHeight){
            
            weakSelf.otherMessageWebView.frame = CGRectMake(0,
                                                            CGRectGetMaxY(topImage.frame) + 42*Proportion,
                                                            WIDTH,
                                                            currentHeight);
            
//            weakSelf.currentHeight = CGRectGetMaxY(weakSelf.otherMessageWebView.frame);
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.otherMessageWebView.frame) + 40*Proportion, WIDTH, 20*Proportion)];
            topLineView.backgroundColor = [UIColor CMLNewActivityGrayColor];
            [weakSelf addSubview:topLineView];
            
            weakSelf.currentHeight = CGRectGetMaxY(topLineView.frame) ;
            
            [weakSelf.delegate finshLoadDetailView:costDetail];
            
        };
        
        
        
    }else if (self.currentType == brandStory){
        
        
        CGFloat tempHeight = CGRectGetMaxY(topImage.frame) + 40*Proportion;
        
        if (self.obj.retData.detailPicArr.count > 0) {
            
            UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                          tempHeight,
                                                                                          WIDTH,
                                                                                          WIDTH/5*3)];
            mainScrollView.pagingEnabled = YES;
            mainScrollView.delegate = self;
            [self addSubview:mainScrollView];
            mainScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.detailPicArr.count,
                                                    mainScrollView.frame.size.height);
            
            tempHeight = CGRectGetMaxY(mainScrollView.frame);
            
            for (int i = 0; i < self.obj.retData.brandStoryPicArr.count; i++) {
                
                UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                         0,
                                                                                         WIDTH,
                                                                                         mainScrollView.frame.size.height)];
                moduleImage.contentMode = UIViewContentModeScaleAspectFill;
                moduleImage.clipsToBounds = YES;
                [mainScrollView addSubview:moduleImage];
                
                CMLPicObjInfo *picObj = [CMLPicObjInfo getBaseObjFrom:self.obj.retData.brandStoryPicArr[i]];
                [NetWorkTask setImageView:moduleImage WithURL:picObj.coverPic placeholderImage:nil];
            }
            
            self.pageLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 32*Proportion - 79*Proportion,
                                                                     CGRectGetMaxY(mainScrollView.frame) - 35*Proportion - 35*Proportion,
                                                                     79*Proportion,
                                                                     35*Proportion)];
            self.pageLab.text = [NSString stringWithFormat:@"1/%ld",self.obj.retData.detailPicArr.count];
            self.pageLab.textAlignment = NSTextAlignmentCenter;
            self.pageLab.font = KSystemFontSize13;
            self.pageLab.textColor = [UIColor CMLWhiteColor];
            self.pageLab.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
            [self addSubview:self.pageLab];
            
        }

        if (self.obj.retData.brandStoryUrl.length > 0) {
          
            self.BrandStoryWKView = [[InformationWkView alloc] initWith:self.obj.retData.brandStoryUrl];
            self.BrandStoryWKView.frame = CGRectMake(0,
                                                     tempHeight,
                                                     WIDTH,
                                                     1000);
            self.BrandStoryWKView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.BrandStoryWKView];
            
            __weak typeof(self) weakSelf = self;
            self.BrandStoryWKView.loadWebViewFinish = ^(CGFloat height){
                
                weakSelf.BrandStoryWKView.frame = CGRectMake(weakSelf.BrandStoryWKView.frame.origin.x,
                                                             weakSelf.BrandStoryWKView.frame.origin.y,
                                                             WIDTH,
                                                             height);
//                weakSelf.currentHeight = CGRectGetMaxY(weakSelf.BrandStoryWKView.frame) ;
                
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.BrandStoryWKView.frame) + 40*Proportion, WIDTH, 20*Proportion)];
                topLineView.backgroundColor = [UIColor CMLNewActivityGrayColor];
                [weakSelf addSubview:topLineView];
                
                weakSelf.currentHeight = CGRectGetMaxY(topLineView.frame) ;
                
                [weakSelf.delegate finshLoadDetailView:brandStory];
                
            };
            
        }else{
            
            self.currentHeight = tempHeight;
            [self.delegate finshLoadDetailView:brandStory];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.pageLab.text = [NSString stringWithFormat:@"%d/%lu",(int)(scrollView.contentOffset.x/WIDTH) + 1,(unsigned long)self.obj.retData.detailPicArr.count];
}

@end
