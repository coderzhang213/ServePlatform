//
//  PrefectureInformationView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "PrefectureInformationView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "CMLPrefectureInformationVC.h"
#import "BaseResultObj.h"
#import "StarInfo.h"
#import "AuctionDetailInfoObj.h"
#import "NetWorkTask.h"
#import "InformationDefaultVC.h"
#import "VCManger.h"

#define LeftMargin       30
#define TopMargin        40
#define ImageHeight      180
#define ImageWidth       252

@interface PrefectureInformationView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation PrefectureInformationView

- (instancetype)initWithObj:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
    
        self.backgroundColor = [UIColor CMLWhiteColor];
        
        self.dataArray = obj.retData.newsInfoModule.dataList;
        
        self.obj = obj;
        [self loadViews];
        
        
    }
    return self;
}

- (void) loadViews{

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.newsInfoModule.dataInfo.ModuleName;
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
    [moreBtn addTarget:self action:@selector(enterInformationListVC) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.newsInfoModule.dataCount intValue] <= 3) {
        
        moreBtn.hidden = YES;
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];
    
    
    int count;
    
    if (self.dataArray.count > 3) {
        
        count = 3;
    }else{
    
        count = (int)self.dataArray.count;
    }
    
    for (int i = 0; i < count; i++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(nameLab.frame) + 21*Proportion + (TopMargin + ImageHeight)*Proportion*i,
                                                                  WIDTH,
                                                                  (TopMargin + ImageHeight)*Proportion)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UIImageView *informationImg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                                    TopMargin*Proportion,
                                                                                    ImageWidth*Proportion,
                                                                                    ImageHeight*Proportion)];
        informationImg.backgroundColor = [UIColor CMLPromptGrayColor];
        informationImg.contentMode = UIViewContentModeScaleAspectFill;
        informationImg.clipsToBounds = YES;
        informationImg.userInteractionEnabled = YES;
        [bgView addSubview:informationImg];
        
        AuctionDetailInfoObj *obj = [AuctionDetailInfoObj getBaseObjFrom:self.dataArray[i]];
        [NetWorkTask setImageView:informationImg WithURL:obj.coverPicThumb placeholderImage:nil];
        
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = KSystemBoldFontSize14;
        titleLab.textColor = [UIColor CMLBlackColor];
        titleLab.text = obj.title;
        titleLab.numberOfLines = 0;
        titleLab.textAlignment = NSTextAlignmentLeft;
        [titleLab sizeToFit];
        if (titleLab.frame.size.width > WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion) {
            
            titleLab.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                        TopMargin*Proportion,
                                        WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion,
                                        titleLab.frame.size.height*2);
        }else{
        
            titleLab.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                        TopMargin*Proportion,
                                        WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion,
                                        titleLab.frame.size.height);
        }
        [bgView addSubview:titleLab];
        
        UILabel *briefLab = [[UILabel alloc] init];
        briefLab.font = KSystemBoldFontSize12;
        briefLab.textColor = [UIColor CMLLineGrayColor];
        briefLab.text = obj.briefIntro;
        briefLab.numberOfLines = 0;
        briefLab.textAlignment = NSTextAlignmentLeft;
        [briefLab sizeToFit];
        if (briefLab.frame.size.width > WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion) {
            
            briefLab.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                        CGRectGetMaxY(titleLab.frame) + 5*Proportion,
                                        WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion,
                                        briefLab.frame.size.height*2);
        }else{
            
            briefLab.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                        CGRectGetMaxY(titleLab.frame) + 5*Proportion,
                                        WIDTH - 20*Proportion - LeftMargin*Proportion*2 - ImageWidth*Proportion,
                                        briefLab.frame.size.height);
        }
        [bgView addSubview:briefLab];
        
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.font = KSystemBoldFontSize12;
        timeLab.textColor = [UIColor CMLtextInputGrayColor];
        timeLab.text = obj.publishTimeStr;
        [timeLab sizeToFit];
        timeLab.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion, CGRectGetMaxY(informationImg.frame) - timeLab.frame.size.height, timeLab.frame.size.width, timeLab.frame.size.height);
        [bgView addSubview:timeLab];
        
        UIButton *hitNum = [[UIButton alloc] init];
        [hitNum setTitle:[NSString stringWithFormat:@"%@",obj.hitNum] forState:UIControlStateNormal];
        [hitNum setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
        hitNum.titleLabel.font = KSystemFontSize12;
        [hitNum setImage:[UIImage imageNamed:PrefectureHitNumImg] forState:UIControlStateNormal];
        [hitNum sizeToFit];
        hitNum.frame = CGRectMake(WIDTH - LeftMargin*Proportion - hitNum.frame.size.width,
                                  timeLab.center.y - hitNum.frame.size.height/2.0,
                                  hitNum.frame.size.width,
                                  hitNum.frame.size.height);
        [bgView addSubview:hitNum];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, informationImg.frame.origin.y, WIDTH, informationImg.frame.size.height)];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = i;
        [bgView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == count - 1) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(bgView.frame) + TopMargin*Proportion,
                                                                          WIDTH,
                                                                          20*Proportion)];
            bottomView.backgroundColor = [UIColor CMLNewGrayColor];
            [self addSubview:bottomView];
            self.viewHeight = CGRectGetMaxY(bottomView.frame);
        }
    }
    
    if (self.dataArray.count == 0 ) {
        
        self.hidden = YES;
        self.viewHeight = 0;
    }
}

- (void) enterInformationListVC{

    CMLPrefectureInformationVC *vc = [[CMLPrefectureInformationVC alloc] initWithID:self.obj.retData.newsInfoModule.dataInfo.parentZoneModuleId andTitle:self.obj.retData.newsInfoModule.dataInfo.ModuleName];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterDetailVC:(UIButton *) btn{

    AuctionDetailInfoObj *obj = [AuctionDetailInfoObj getBaseObjFrom:self.dataArray[btn.tag]];
    InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];

}
@end
