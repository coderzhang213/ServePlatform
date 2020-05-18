//
//  CMLCommodityView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommodityView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "CMLCommodityVC.h"
#import "BaseResultObj.h"
#import "AuctionInfo.h"
#import "AuctionDetailInfoObj.h"
#import "InformationDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLPackageInfoModel.h"
#import "PackageInfoObj.h"

#define LeftMargin       30
#define TopMargin        40
#define ImageHeight      220
#define ImageWidth       330

@interface CMLCommodityView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSArray *packageInfpDataArray;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic, assign) int dataCount;

@end

@implementation CMLCommodityView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
        self.dataArray = obj.retData.goodsInfoModule.dataList;
        self.obj = obj;
        self.dataCount = [obj.retData.goodsInfoModule.dataCount intValue];
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.goodsInfoModule.dataInfo.ModuleName;
    nameLab.font = KSystemBoldFontSize14;
    nameLab.textColor = [UIColor CMLBlackColor];
    [nameLab sizeToFit];
    nameLab.frame = CGRectMake(LeftMargin*Proportion,
                               TopMargin*Proportion,
                               nameLab.frame.size.width,
                               nameLab.frame.size.height);
    [self addSubview:nameLab];
    
    UIImageView *decorateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PreffectureDecorateImg]];
    [decorateImage sizeToFit];
    decorateImage.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + 10*Proportion,
                                     nameLab.center.y - decorateImage.frame.size.height/2.0,
                                     decorateImage.frame.size.width,
                                     decorateImage.frame.size.height);
    [self addSubview:decorateImage];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:PrefectureMoreMessageImg] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = KSystemFontSize12;
    [moreBtn sizeToFit];
    CGSize strSize1 = [moreBtn.currentTitle sizeWithFontCompatible:KSystemFontSize12];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                 - moreBtn.currentImage.size.width - 5*Proportion,
                                                 0,
                                                 0)];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                 strSize1.width + moreBtn.currentImage.size.width + 5*Proportion,
                                                 0,
                                                 0)];
    moreBtn.frame = CGRectMake(WIDTH - moreBtn.frame.size.width - 20*Proportion*2 - LeftMargin*Proportion,
                               nameLab.center.y - moreBtn.frame.size.height/2.0,
                               moreBtn.frame.size.width + 20*Proportion*2,
                               moreBtn.frame.size.height);
    [self addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(enterCommodityVC) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.goodsInfoModule.dataCount intValue] <= self.dataArray.count) {
        moreBtn.hidden = YES;
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];
    /*
    int count;
    
    if (self.dataArray.count > 4) {
        
        count = 4;
    }else{
    
        count = (int)self.dataArray.count;
    }*/
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        AuctionDetailInfoObj *detailObj = [AuctionDetailInfoObj getBaseObjFrom:self.obj.retData.goodsInfoModule.dataList[i]];
        
        UIView *module = [[UIView alloc] init];
        module.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:module];
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 ImageWidth*Proportion,
                                                                                 ImageHeight*Proportion)];
        moduleImage.backgroundColor = [UIColor CMLPromptGrayColor];
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        moduleImage.clipsToBounds = YES;
        moduleImage.layer.cornerRadius = 8*Proportion;
        [module addSubview:moduleImage];
        [NetWorkTask setImageView:moduleImage WithURL:detailObj.coverPicThumb placeholderImage:nil];
        
        UILabel *moduleNameLab = [[UILabel alloc] init];
        moduleNameLab.numberOfLines = 2;
        moduleNameLab.font = KSystemBoldFontSize12;
        moduleNameLab.textColor = [UIColor CMLBlackColor];
        moduleNameLab.text = detailObj.title;
        [moduleNameLab sizeToFit];
        moduleNameLab.frame = CGRectMake(0,
                                         CGRectGetMaxY(moduleImage.frame) + 20*Proportion,
                                         moduleImage.frame.size.width,
                                         moduleNameLab.frame.size.height*2);
        [module addSubview:moduleNameLab];
        
        UILabel *modulePriceLab = [[UILabel alloc] init];
        modulePriceLab.font = KSystemRealBoldFontSize16;
        modulePriceLab.textColor = [UIColor CMLBrownColor];

        CMLPackageInfoModel *packageInfoModel = [CMLPackageInfoModel getBaseObjFrom:detailObj.packageInfo.dataList[0]];
        
        NSLog(@"packageInfoModel %@", packageInfoModel);
        NSLog(@"detailObj.packageInfo.dataList %@", detailObj.packageInfo.dataList);
        NSLog(@"totalAmountStr %@", packageInfoModel.totalAmountStr);
        
        if (packageInfoModel.totalAmountStr.length > 0) {
            modulePriceLab.text = packageInfoModel.totalAmountStr;
        }
        
        [modulePriceLab sizeToFit];
        modulePriceLab.frame = CGRectMake(0,
                                          CGRectGetMaxY(moduleNameLab.frame) + 20*Proportion,
                                          moduleImage.frame.size.width,
                                          modulePriceLab.frame.size.height);
        [module addSubview:modulePriceLab];
        
        module.frame = CGRectMake(LeftMargin*Proportion + i%2*(moduleImage.frame.size.width + LeftMargin*Proportion),
                                  CGRectGetMaxY(nameLab.frame) + 20*Proportion + TopMargin*Proportion + (i/2)* (CGRectGetMaxY(modulePriceLab.frame) + 40*Proportion),
                                  moduleImage.frame.size.width,
                                  (CGRectGetMaxY(modulePriceLab.frame) + 40*Proportion));
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame: module.bounds];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = i;
        [module addSubview:enterBtn];
        
        [enterBtn addTarget:self action:@selector(enterGoodsVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.dataArray.count - 1) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(module.frame), WIDTH, 20*Proportion)];
            bottomView.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:bottomView];
            
            self.viewHeight = CGRectGetMaxY(bottomView.frame);
        }
        
    }

    if (self.dataArray.count == 0) {

        self.viewHeight = 0;
        self.hidden = YES;
    }

}

- (void) enterCommodityVC{

    CMLCommodityVC *vc = [[CMLCommodityVC alloc] initWithID:self.obj.retData.goodsInfoModule.dataInfo.parentZoneModuleId
                                                   andTitle:self.obj.retData.goodsInfoModule.dataInfo.ModuleName];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterGoodsVC:(UIButton *) btn{
    
    AuctionDetailInfoObj *detailObj = [AuctionDetailInfoObj getBaseObjFrom:self.dataArray[btn.tag]];
    
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:detailObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
