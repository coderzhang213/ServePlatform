//
//  CMLPrefectureImagesView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLPrefectureImagesView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "CMLModuleObj.h"
#import "CMLPicObjInfo.h"
#import "AuctionInfo.h"
#import "CMLAllImagesVC.h"
#import "CMLPhotoViewController.h"

#define LeftMargin       30
#define TopMargin        40
#define ImageHeight      240

@interface CMLPrefectureImagesView ()

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLPrefectureImagesView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {

        self.dataArray = obj.retData.picInfoModule.dataList;
        self.obj = obj;
        [self loadViews];
    }
    
    return  self;
}

- (void) loadViews{

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.picInfoModule.dataInfo.ModuleName;
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
    [moreBtn addTarget:self action:@selector(enterImageShowVC) forControlEvents:UIControlEventTouchUpInside];

    if ([self.obj.retData.picInfoModule.dataCount intValue] <= self.dataArray.count) {
        moreBtn.hidden = YES;
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];
    
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(nameLab.frame) + 20*Proportion + TopMargin*Proportion,
                                                                         WIDTH,
                                                                         ImageHeight*Proportion)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.mainScrollView];
    
    CGFloat currentLeftMargin = 30*Proportion;
    for (int i = 0; i < self.dataArray.count; i++) {
        
        CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.dataArray[i]];
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(currentLeftMargin,
                                                                                 0,
                                                                                 ImageHeight*Proportion*[obj.picObjInfo.ratio floatValue],
                                                                                 ImageHeight*Proportion)];
        moduleImage.backgroundColor = [UIColor CMLPromptGrayColor];
        moduleImage.userInteractionEnabled = YES;
        [self.mainScrollView addSubview:moduleImage];
        [NetWorkTask setImageView:moduleImage WithURL:obj.picObjInfo.coverPic placeholderImage:nil];
        currentLeftMargin += (20*Proportion +ImageHeight*Proportion*[obj.picObjInfo.ratio floatValue]);
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:moduleImage.bounds];
        enterBtn.backgroundColor = [UIColor clearColor];
        [moduleImage addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterImageShowVC) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.dataArray.count - 1) {
            
            self.mainScrollView.contentSize = CGSizeMake(currentLeftMargin, ImageHeight*Proportion);
        }
        
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.mainScrollView.frame) + TopMargin*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:bottomView];
    
    self.viewHeight = CGRectGetMaxY(bottomView.frame);
    
    if (self.dataArray.count == 0) {
        
        self.viewHeight = 0;
        self.hidden = YES;
    }
}

- (void) enterImageShowVC{

    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:[self.dataArray firstObject]];
    
    CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:obj.parentAlbumId ImageName:self.obj.retData.picInfoModule.dataInfo.ModuleName];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
