//
//  CMLPrefectureActivityView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLPrefectureActivityView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "AuctionInfo.h"
#import "CMLActivityObj.h"
#import "ActivityDefaultVC.h"
#import "CMLPrefectureActivityListVC.h"

#define LeftMargin       30
#define TopMargin        40
#define ImageHeight      162
#define ImageWidth       288

@interface CMLPrefectureActivityView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) BaseResultObj *obj;

@end
@implementation CMLPrefectureActivityView

- (instancetype)initWithObj:(BaseResultObj *) obj{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.dataArray = obj.retData.activityInfoModule.dataList;
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.activityInfoModule.dataInfo.ModuleName;
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
    
    [moreBtn addTarget:self action:@selector(enterPrefectureActivityListVC) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.activityInfoModule.dataCount intValue] <= 3) {
        
        moreBtn.hidden = YES;
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];
    
    int num = 0;
    if (self.dataArray.count > 3) {
        
        num = 3;
        
    }else{
    
        num = (int)self.dataArray.count;
    }
    
    for (int i = 0; i < num; i++) {
        
        CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[i]];
        
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
        [bgView addSubview:informationImg];
        
        [NetWorkTask setImageView:informationImg WithURL:activityObj.coverPic placeholderImage:nil];
        
        
        UILabel *activityLabel =[[UILabel alloc] init];
        activityLabel.font = KSystemBoldFontSize16;
        activityLabel.text = activityObj.title;
        activityLabel.textColor = [UIColor CMLBlackColor];
        activityLabel.backgroundColor = [UIColor whiteColor];
        activityLabel.textAlignment = NSTextAlignmentLeft;
        [activityLabel sizeToFit];
        [bgView addSubview:activityLabel];
        
        if (activityLabel.frame.size.width > (WIDTH - informationImg.frame.size.width - 30*Proportion*2 - 20*Proportion)) {
            
            activityLabel.numberOfLines = 2;
            activityLabel.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                             TopMargin*Proportion,
                                             (WIDTH - informationImg.frame.size.width - 30*Proportion*2 - 20*Proportion),
                                             activityLabel.frame.size.height*2);
            
        }else{
            
            activityLabel.numberOfLines = 1;
            activityLabel.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                             TopMargin*Proportion,
                                             (WIDTH - informationImg.frame.size.width - 30*Proportion*2 - 20*Proportion),
                                             activityLabel.frame.size.height);
            
        }
        
        UILabel *smallLabelOne = [[UILabel alloc] init];
        smallLabelOne.textColor = [UIColor CMLtextInputGrayColor];
        switch ([activityObj.memberLevelId intValue]) {
            case 1:
                smallLabelOne.text = @"粉色";
                break;
            case 2:
                smallLabelOne.text = @"黛色";
                break;
            case 3:
                smallLabelOne.text = @"金色";
                break;
            case 4:
                smallLabelOne.text = @"墨色";
                break;
                
            default:
                break;
        }
        smallLabelOne.font = KSystemFontSize10;
        smallLabelOne.backgroundColor = [UIColor whiteColor];
        [smallLabelOne sizeToFit];
        smallLabelOne.frame = CGRectMake(CGRectGetMaxX(informationImg.frame) + 20*Proportion,
                                         CGRectGetMaxY(informationImg.frame) - 30*Proportion,
                                         smallLabelOne.frame.size.width + 20*Proportion,
                                         30*Proportion);
        smallLabelOne.textAlignment = NSTextAlignmentCenter;
        smallLabelOne.layer.cornerRadius = 4*Proportion;
        smallLabelOne.layer.borderWidth = 0.5;
        smallLabelOne.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [bgView addSubview:smallLabelOne];
        
        
        UILabel *smallLabelTwo = [[UILabel alloc] init];
        smallLabelTwo.textColor = [UIColor CMLtextInputGrayColor];
        smallLabelTwo.text = [NSString getProjectStartTime:activityObj.actBeginTime];
        smallLabelTwo.font = KSystemFontSize10;
        smallLabelTwo.backgroundColor = [UIColor whiteColor];
        [smallLabelTwo sizeToFit];
        smallLabelTwo.frame = CGRectMake(CGRectGetMaxX(smallLabelOne.frame) + 20*Proportion,
                                         CGRectGetMaxY(informationImg.frame)- 30*Proportion,
                                         smallLabelTwo.frame.size.width + 20*Proportion,
                                         30*Proportion);
        smallLabelTwo.textAlignment = NSTextAlignmentCenter;
        smallLabelTwo.layer.cornerRadius = 4*Proportion;
        smallLabelTwo.layer.borderWidth = 0.5;
        smallLabelTwo.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [bgView addSubview:smallLabelTwo];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, informationImg.frame.origin.y, WIDTH, informationImg.frame.size.height)];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = i;
        [bgView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];

        
        
        if (i == num -1) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(bgView.frame) + TopMargin*Proportion,
                                                                          WIDTH,
                                                                          20*Proportion)];
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

- (void) enterDetailVC:(UIButton *) btn{

    CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:self.dataArray[btn.tag]];
    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:activityObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterPrefectureActivityListVC{

    CMLPrefectureActivityListVC *vc = [[CMLPrefectureActivityListVC alloc] initWithID:self.obj.retData.activityInfoModule.dataInfo.parentZoneModuleId andTitle:self.obj.retData.activityInfoModule.dataInfo.ModuleName];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
