//
//  CMLExpressGratitudeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLExpressGratitudeView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "FriendMessageObj.h"
#import "FriendImageMessageObj.h"

#define LeftMargin       30
#define TopMargin        40
#define ImageWidth       160
#define ImageHeight      100

@interface CMLExpressGratitudeView ()

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation CMLExpressGratitudeView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
       
        self.dataArray = obj.retData.friendsInfoModule;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"特别鸣谢";
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
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];
    
    CGFloat currentHeigth = CGRectGetMaxY(nameLab.frame) + 20*Proportion + TopMargin*Proportion;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        FriendMessageObj *obj = [FriendMessageObj getBaseObjFrom:self.dataArray[i]];
        
        UIView *expressView = [[UIView alloc] init];
        expressView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:expressView];
        
        UILabel *time1 = [[UILabel alloc] init];
        time1.text = [NSString stringWithFormat:@"%@",obj.year];
        time1.font = KSystemFontSize14;
        time1.textColor = [UIColor CMLBlackColor];
        [time1 sizeToFit];
        time1.frame =CGRectMake(LeftMargin*Proportion,
                                0,
                                time1.frame.size.width,
                                time1.frame.size.height);
        [expressView addSubview:time1];
        
        CGFloat space = (WIDTH - LeftMargin*Proportion*2 - ImageWidth*Proportion*4)/3.0;
        for (int i = 0; i < obj.dataList.count; i++) {
            
            FriendImageMessageObj *detailObj = [FriendImageMessageObj getBaseObjFrom:obj.dataList[i]];
            UIImageView *imageViewOne = [[UIImageView alloc] init];
            imageViewOne.layer.cornerRadius = 6*Proportion;
            imageViewOne.backgroundColor = [UIColor CMLPromptGrayColor];
            imageViewOne.clipsToBounds = YES;
            imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
    
            [NetWorkTask setImageView:imageViewOne WithURL:detailObj.imgUrl placeholderImage:nil];
            imageViewOne.frame = CGRectMake(LeftMargin*Proportion + (space + ImageWidth*Proportion)* (i%4),
                                         (ImageHeight + 20)*Proportion*(i/4) + CGRectGetMaxY(time1.frame) + 20*Proportion,
                                         ImageWidth*Proportion ,
                                         ImageHeight*Proportion);
            [expressView addSubview:imageViewOne];
            
            if (i == obj.dataList.count - 1) {
                
                expressView.frame = CGRectMake(0,
                                               currentHeigth,
                                               WIDTH,
                                               CGRectGetMaxY(imageViewOne.frame));
                currentHeigth += (TopMargin*Proportion + expressView.frame.size.height);
            }
        }
        
        
        if (i == self.dataArray.count - 1) {
            
            self.viewHeight = CGRectGetMaxY(expressView.frame);
        }
    }
    
    if (self.dataArray.count == 0) {
        
        self.viewHeight = 0;
        self.hidden = YES;
    }
}
@end
