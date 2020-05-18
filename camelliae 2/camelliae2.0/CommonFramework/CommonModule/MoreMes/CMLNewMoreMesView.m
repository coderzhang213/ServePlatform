//
//  CMLNewMoreMesView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/4/18.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLNewMoreMesView.h"
#import "CommonImg.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLTopicObj.h"
#import "NetWorkTask.h"
#import "PackDetailInfoObj.h"
#import "VCManger.h"
#import "ServeDefaultVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLMobClick.h"

#define MoreMesNametopMargin               50


@interface CMLNewMoreMesView ()

@property (nonatomic,strong) NSMutableArray *currentArray;

@end

@implementation CMLNewMoreMesView


- (NSMutableArray *)currentArray{
    
    if (!_currentArray) {
        _currentArray = [NSMutableArray array];
    }
    
    return _currentArray;
}

- (instancetype)initWith:(NSArray *)list{
    
    self = [super init];
    
    if (self) {
        
        self.currentArray = [NSMutableArray arrayWithArray:list];
        [self loadViews];
        
    }
    
    return self;
}

- (void) loadViews{
    
    self.currentHeight = 260*Proportion*self.currentArray.count + 20*Proportion;
    
    
    if (self.currentArray.count == 0) {
        self.currentHeight = 0;
        self.hidden = YES;
    }
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.text = @"· 相 关 推 荐 ·";
    moreLabel.textColor = [UIColor CMLUserBlackColor];
    moreLabel.font = KSystemFontSize15;
    [moreLabel sizeToFit];
    moreLabel.frame = CGRectMake(WIDTH/2.0 - moreLabel.frame.size.width/2.0,
                                 MoreMesNametopMargin*Proportion,
                                 moreLabel.frame.size.width,
                                 moreLabel.frame.size.height);
    [self addSubview:moreLabel];
    self.currentHeight = 260*Proportion*self.currentArray.count + 20*Proportion + CGRectGetHeight(moreLabel.frame);
    for (int i = 0; i < self.currentArray.count; i++) {
        
            CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.currentArray[i]];
        
            UIView *moduleBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                            260*Proportion*i + 20*Proportion + CGRectGetMaxY(moreLabel.frame),
                                                                            WIDTH,
                                                                            260*Proportion)];
            moduleBgView.backgroundColor = [UIColor CMLWhiteColor];
            [self addSubview:moduleBgView];
        
        
        
        
                UIImageView *mainImageView = [[UIImageView alloc] init];
                mainImageView.frame = CGRectMake(30*Proportion,
                                                  30*Proportion,
                                                  162*Proportion/9*16,
                                                  162*Proportion);
                mainImageView.layer.cornerRadius = 4*Proportion;
                mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
                mainImageView.contentMode = UIViewContentModeScaleAspectFill;
                mainImageView.clipsToBounds = YES;
                [moduleBgView addSubview:mainImageView];
                [NetWorkTask setImageView:mainImageView WithURL:currentObj.coverPic placeholderImage:nil];
        
                UILabel *tagOne = [[UILabel alloc] init];
                tagOne.font = KSystemFontSize10;
                tagOne.layer.borderColor = [UIColor CMLNewbgBrownColor].CGColor;
                tagOne.textColor = [UIColor CMLNewbgBrownColor];
                tagOne.layer.borderWidth = 1*Proportion;
                tagOne.textAlignment = NSTextAlignmentCenter;
                [moduleBgView  addSubview: tagOne];
        
                if ([currentObj.rootTypeId intValue] == 7){
                    tagOne.text = @"单品";
                }else{
                    
                    tagOne.text = currentObj.parentTypeName;
                }
                [tagOne sizeToFit];
                tagOne.frame = CGRectMake(CGRectGetMaxX(mainImageView.frame) + 20*Proportion,
                                          mainImageView.frame.origin.y,
                                          tagOne.frame.size.width + 10*Proportion,
                                          tagOne.frame.size.height + 5*Proportion);
        
                UILabel *tagTwo = [[UILabel alloc] init];
                tagTwo.font = KSystemFontSize10;
                tagTwo.layer.borderColor = [UIColor CMLNewbgBrownColor].CGColor;
                tagTwo.textColor = [UIColor CMLNewbgBrownColor];
                tagTwo.layer.borderWidth = 1*Proportion;
                tagTwo.textAlignment = NSTextAlignmentCenter;
                [moduleBgView addSubview:tagTwo];
        
        
                if ([currentObj.rootTypeId intValue] == 7){
                    tagTwo.text = currentObj.brandName;
                }else{
                    tagTwo.text = currentObj.brandInfo.name;
                    
                }
        
                [tagTwo sizeToFit];
                tagTwo.frame = CGRectMake(CGRectGetMaxX(tagOne.frame) + 20*Proportion,
                                          mainImageView.frame.origin.y,
                                          tagTwo.frame.size.width + 10*Proportion,
                                          tagTwo.frame.size.height + 5*Proportion);
        
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.font = KSystemFontSize14;
                titleLabel.textColor = [UIColor CMLUserBlackColor];
                [moduleBgView addSubview:titleLabel];
                titleLabel.text = currentObj.title;
                [titleLabel sizeToFit];
                if (titleLabel.frame.size.width < WIDTH - 162*Proportion/9*16 - 20*Proportion - 30*Proportion*2) {
                    titleLabel.numberOfLines = 1;
                    titleLabel.frame = CGRectMake(CGRectGetMaxX(mainImageView.frame) + 20*Proportion,
                                                       CGRectGetMaxY(tagOne.frame) + 10*Proportion,
                                                       WIDTH - 162*Proportion/9*16 - 20*Proportion - 30*Proportion*2,
                                                       titleLabel.frame.size.height);
                    
                }else{
                    titleLabel.numberOfLines = 2;
                    titleLabel.frame = CGRectMake(CGRectGetMaxX(mainImageView.frame) + 20*Proportion,
                                                       CGRectGetMaxY(tagOne.frame) + 10*Proportion,
                                                       WIDTH - 162*Proportion/9*16 - 20*Proportion - 30*Proportion*2,
                                                       titleLabel.frame.size.height*2);
                    
                }
        
                [moduleBgView addSubview:titleLabel];
        
                 UILabel *preLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             66*Proportion,
                                                                             40*Proportion)];
                preLab.text = @"预售";
                preLab.textAlignment = NSTextAlignmentCenter;
                preLab.font = KSystemFontSize11;
                preLab.textColor = [UIColor CMLBrownColor];
                preLab.backgroundColor = [UIColor CMLBlackColor];
                [mainImageView addSubview:preLab];
        
                if ([currentObj.rootTypeId intValue] == 7){
                        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
                        if ([costObj.is_pre intValue] == 1) {
                            
                            preLab.hidden = NO;
                        }else{
                            
                            preLab.hidden = YES;
                        }
                }else{
                    
                    if ([currentObj.is_pre intValue] == 1) {
                        
                        preLab.hidden = NO;
                    }else{
                        
                        preLab.hidden = YES;
                    }
                }
        
                UILabel *pricelLabel = [[UILabel alloc] init];
                pricelLabel.font = KSystemBoldFontSize16;
                pricelLabel.textColor = [UIColor CMLBrownColor];
                [moduleBgView addSubview:pricelLabel];
                NSNumber *tempPrice;
                if ([currentObj.rootTypeId intValue] == 7){
                    
                    
                    if ([currentObj.is_pre intValue] == 1) {
                        
                        tempPrice = currentObj.pre_price;
                    }else{
                        
                        tempPrice = currentObj.totalAmountMin;
                        
                    }
                    
                    pricelLabel.text = [NSString stringWithFormat:@"¥%@",tempPrice];
                    
                } else{
                        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
                        if ([costObj.payMode intValue] == 1) {

                            tempPrice = costObj.subscription;
                        }else{

                            tempPrice = costObj.pre_totalAmount;
                        }
                
                        if ([currentObj.isHasPriceInterval intValue] == 1) {
                            
                            pricelLabel.text = [NSString stringWithFormat:@"¥%@起",tempPrice];
                            
                        }else{
                            
                            pricelLabel.text = [NSString stringWithFormat:@"¥%@",tempPrice];
                            
                        }
                }
                [pricelLabel sizeToFit];
                pricelLabel.textAlignment = NSTextAlignmentCenter;
                pricelLabel.frame = CGRectMake(CGRectGetMaxX(mainImageView.frame) + 20*Proportion,
                                               CGRectGetMaxY(titleLabel.frame) + 10*Proportion,
                                               pricelLabel.frame.size.width,
                                               pricelLabel.frame.size.height);
        
        
            if ([currentObj.rootTypeId intValue] == 7){
                
                if ([currentObj.is_deposit intValue] == 1) {
                    
                    pricelLabel.text = [NSString stringWithFormat:@"¥%@",currentObj.deposit_money];
                    [pricelLabel sizeToFit];
                    pricelLabel.textAlignment = NSTextAlignmentCenter;
                    pricelLabel.frame = CGRectMake(CGRectGetMaxX(mainImageView.frame) + 20*Proportion,
                                                   CGRectGetMaxY(titleLabel.frame) + 10*Proportion,
                                                   pricelLabel.frame.size.width,
                                                   pricelLabel.frame.size.height);
                    
                    UILabel *verbLab = [[UILabel alloc] init];
                    verbLab.text = @"订金";
                    verbLab.font = KSystemFontSize10;
                    verbLab.textColor = [UIColor CMLWhiteColor];
                    verbLab.textAlignment = NSTextAlignmentCenter;
                    verbLab.backgroundColor = [UIColor CMLBrownColor];
                    [moduleBgView addSubview:verbLab];
                    [verbLab sizeToFit];
                    verbLab.frame = CGRectMake(CGRectGetMaxX(pricelLabel.frame) + 10*Proportion,
                                               pricelLabel.center.y - 30*Proportion/2.0,
                                               50*Proportion,
                                               30*Proportion);
                }


                
            } else{
                
                UILabel *verbLab = [[UILabel alloc] init];
                verbLab.text = @"订金";
                verbLab.font = KSystemFontSize10;
                verbLab.textColor = [UIColor CMLWhiteColor];
                verbLab.textAlignment = NSTextAlignmentCenter;
                verbLab.backgroundColor = [UIColor CMLBrownColor];
                [moduleBgView addSubview:verbLab];
                PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
                if ([costObj.payMode intValue] == 1) {
                    
                    verbLab.hidden = NO;
                    [verbLab sizeToFit];
                    verbLab.frame = CGRectMake(CGRectGetMaxX(pricelLabel.frame) + 10*Proportion,
                                               pricelLabel.center.y - 30*Proportion/2.0,
                                               50*Proportion,
                                               30*Proportion);
                }else{
                    
                    verbLab.hidden = YES;
                }

            }
        
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:moduleBgView.bounds];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = i + 1;
        [moduleBgView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterVC:) forControlEvents:UIControlEventTouchUpInside];
        }

}


- (void) enterVC:(UIButton *) btn{
    
    CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.currentArray[btn.tag - 1]];
    
        if ([currentObj.rootTypeId intValue] == 3){
            
            [CMLMobClick recommendServe];
            ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([currentObj.rootTypeId intValue] == 7){
            
            [CMLMobClick recommendGoods];
            CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:currentObj.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }

    
}

@end
