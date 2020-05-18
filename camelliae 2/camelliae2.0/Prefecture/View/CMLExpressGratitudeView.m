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

@property (nonatomic, assign) CGFloat leftSpace;

@property (nonatomic, assign) CGFloat heightSpace;

@property (nonatomic, assign) CGFloat expressViewHeight;

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
    nameLab.text = @"组织架构";
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
    
    NSArray *nameArray = @[@"指导单位：",
                           @"上海市经济和信息化委员会",
                           @"联合国教科文组织“创意城市”（上海）推进办公室",
                           @"支持单位：",
                           @"上海市商务委员会",
                           @"主办单位：",
                           @"上海国际时尚联合会",
                           @"承办单位：",
                           @"上海高级定制周组委会",
                           @"协办单位：",
                           @"智富企业发展（集团）有限公司",
                           @"卡枚连高端女性平台",
                           @"上海国际时尚联合会高级定制专委会",
                           @"上海国际时尚联合会匠艺师专委会",
                           @"上海国际时尚联合会少儿时尚专委会"];/*15*/
    
    UIView *expressView = [[UIView alloc] init];
    expressView.backgroundColor = [UIColor CMLWhiteColor];
    
    [self addSubview:expressView];
    
    for (int i = 0; i < nameArray.count; i++) {
        UILabel *title0 = [[UILabel alloc] init];
        title0.text = nameArray[i];
        title0.font = KSystemFontSize13;
        title0.textColor = [UIColor CMLUserBlackColor];
        [title0 sizeToFit];
        if (i == 0) {
            self.leftSpace = title0.frame.size.width;
            self.heightSpace = CGRectGetMaxY(title0.frame) + 10 * Proportion;
        }
        switch (i) {
            case 0:
                title0.frame = CGRectMake(LeftMargin*Proportion,
                                          0,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 1:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          0,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 2:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace + 1*Proportion,
                                          self.heightSpace,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 3:
                title0.frame = CGRectMake(LeftMargin*Proportion,
                                          self.heightSpace * 2,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 4:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 2,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 5:
                title0.frame = CGRectMake(LeftMargin*Proportion,
                                          self.heightSpace * 3,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 6:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 3,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 7:
                title0.frame = CGRectMake(LeftMargin*Proportion,
                                          self.heightSpace * 4 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 8:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 4 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 9:
                title0.frame = CGRectMake(LeftMargin*Proportion,
                                          self.heightSpace * 5 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 10:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 5 + 30*Proportion + 1 * Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 11:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 6 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                break;
                
            case 12:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 7 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                self.expressViewHeight = CGRectGetMaxY(title0.frame);
                break;
                
            case 13:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 8 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                self.expressViewHeight = CGRectGetMaxY(title0.frame);
                break;
                
            case 14:
                title0.frame = CGRectMake(LeftMargin*Proportion + self.leftSpace,
                                          self.heightSpace * 9 + 30*Proportion,
                                          title0.frame.size.width,
                                          title0.frame.size.height);
                self.expressViewHeight = CGRectGetMaxY(title0.frame);
                break;
                
            default:
                break;
        }
        
        [expressView addSubview:title0];
    }
    expressView.frame = CGRectMake(0,
                                   currentHeigth,
                                   WIDTH,
                                   self.expressViewHeight);
    self.viewHeight = CGRectGetMaxY(expressView.frame);
    
    /*
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
    */
    if (self.dataArray.count == 0) {
        
        self.viewHeight = 0;
        self.hidden = YES;
    }
}
@end
