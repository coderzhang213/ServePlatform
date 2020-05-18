//
//  CMLServeMoreMesView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/4/16.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLServeMoreMesView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "MoreMesObj.h"
#import "VCManger.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "CMLLine.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "NSString+CMLExspand.h"

#define TopLineY                           10
#define MoreMesLeftMargin                  20
#define MoreMesNametopMargin               50
#define ModerMesImageSpace                 20
#define MoreMesImageTopMargin              20
#define MoreMesImageHeight                 135
#define MoreMesImageWidth                  240
#define MoreMesOfInfoImageHeight           200
#define MoreMesOfInfoImageWidth            280
#define MoreMesImageAndNameSpace           20
#define MoreMesNameAndNumSpace             10


@interface CMLServeMoreMesView ()

@property (nonatomic,strong) UIView *bgView;

@end

@implementation CMLServeMoreMesView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) createViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                           0,
                                                           WIDTH - 20*Proportion*2,
                                                           0)];
    self.bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.bgView];
    
    if ([self.currentClass intValue] == 7) {
        
        UILabel *moreLabel = [[UILabel alloc] init];
        moreLabel.text = @"· 相 关 推 荐 ·";
        moreLabel.textColor = [UIColor CMLUserBlackColor];
        moreLabel.font = KSystemFontSize14;
        [moreLabel sizeToFit];
        moreLabel.frame = CGRectMake(self.bgView.frame.size.width/2.0 - moreLabel.frame.size.width/2.0,
                                     MoreMesNametopMargin*Proportion,
                                     moreLabel.frame.size.width,
                                     moreLabel.frame.size.height);
        [self.bgView addSubview:moreLabel];
        
        for (int i = 0; i < self.List.count; i++) {
            MoreMesObj *obj = [MoreMesObj getBaseObjFrom:self.List[i]];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(MoreMesLeftMargin*Proportion,
                                         CGRectGetMaxY(moreLabel.frame) + 26*Proportion + (160 + 40)*Proportion*i,
                                         240*Proportion,
                                         160*Proportion);
            imageView.backgroundColor = [UIColor CMLPromptGrayColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.bgView addSubview:imageView];
            [NetWorkTask setImageView:imageView WithURL:obj.coverPic placeholderImage:nil];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.font = KSystemBoldFontSize14;
            nameLabel.text = obj.title;
            nameLabel.textColor = [UIColor CMLUserBlackColor];
            [nameLabel sizeToFit];
            
            
            if (nameLabel.frame.size.width < self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - 240*Proportion) {
                nameLabel.numberOfLines = 1;
                nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                             imageView.frame.origin.y,
                                             self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - 240*Proportion,
                                             nameLabel.frame.size.height);
            }else{
                nameLabel.numberOfLines = 2;
                nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                             imageView.frame.origin.y,
                                             self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - 240*Proportion,
                                             nameLabel.frame.size.height*2);
            }
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [self.bgView addSubview:nameLabel];
            
            UILabel *tagLab = [[UILabel alloc] init];
            tagLab.font = KSystemFontSize11;
            tagLab.textColor = [UIColor CMLLineGrayColor];
            tagLab.layer.cornerRadius = 4*Proportion;
            tagLab.layer.borderWidth = 1*Proportion;
            tagLab.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
            tagLab.text = [NSString stringWithFormat:@"%@",obj.brandName];
            tagLab.textAlignment = NSTextAlignmentCenter;
            [tagLab sizeToFit];
            tagLab.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                      CGRectGetMaxY(nameLabel.frame) + 5*Proportion,
                                      tagLab.frame.size.width + 10*Proportion,
                                      30*Proportion);
            [self.bgView addSubview:tagLab];
            
            if (obj.brandName.length == 0) {
                
                tagLab.hidden = YES;
            }
            
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[obj.packageInfo.dataList lastObject]];
            UILabel *priceLab = [[UILabel alloc] init];
            priceLab.textColor = [UIColor CMLGreeenColor];
            priceLab.text= [NSString stringWithFormat:@"￥%@",costObj.totalAmountStr];
            priceLab.font = KSystemBoldFontSize17;
            [priceLab sizeToFit];
            priceLab.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                        CGRectGetMaxY(imageView.frame) - priceLab.frame.size.height,
                                        priceLab.frame.size.width,
                                        priceLab.frame.size.height);
            [self.bgView addSubview:priceLab];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          imageView.frame.origin.y,
                                                                          WIDTH,
                                                                          imageView.frame.size.height)];
            button.tag = i;
            [self.bgView addSubview:button];
            [button addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *buyBtn = [[UIButton alloc] init];
            buyBtn.backgroundColor = [UIColor CMLBrownColor];
            buyBtn.layer.cornerRadius = 4*Proportion;
            [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            buyBtn.titleLabel.font = KSystemFontSize12;
            [buyBtn sizeToFit];
            buyBtn.frame = CGRectMake(self.bgView.frame.size.width - MoreMesLeftMargin*Proportion - 20*Proportion - buyBtn.frame.size.width,
                                      CGRectGetMaxY(imageView.frame) - 40*Proportion,
                                      buyBtn.frame.size.width + 20*Proportion,
                                      40*Proportion);
            [self.bgView addSubview:buyBtn];
            buyBtn.tag = i;
            [buyBtn addTarget:self action:@selector(createOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == self.List.count - 1) {
                self.currentHeight = CGRectGetMaxY(button.frame) + 50*Proportion;
                self.bgView.frame = CGRectMake(20*Proportion,
                                               0,
                                               WIDTH - 20*Proportion*2,
                                               self.currentHeight);
            }
        }
        
    }else{
        
        UILabel *moreLabel = [[UILabel alloc] init];
        moreLabel.text = @"· 更多热门 ·";
        moreLabel.textColor = [UIColor CMLUserBlackColor];
        moreLabel.font = KSystemFontSize12;
        [moreLabel sizeToFit];
        moreLabel.frame = CGRectMake(self.bgView.frame.size.width/2.0 - moreLabel.frame.size.width/2.0,
                                     MoreMesNametopMargin*Proportion,
                                     moreLabel.frame.size.width,
                                     moreLabel.frame.size.height);
        [self.bgView addSubview:moreLabel];
        
        for (int i = 0; i < self.List.count; i++) {
            MoreMesObj *obj = [MoreMesObj getBaseObjFrom:self.List[i]];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            if (self.isInfo) {
                imageView.frame = CGRectMake(MoreMesLeftMargin*Proportion,
                                             CGRectGetMaxY(moreLabel.frame) + 26*Proportion + (MoreMesOfInfoImageHeight + ModerMesImageSpace)*Proportion*i,
                                             MoreMesOfInfoImageWidth*Proportion,
                                             MoreMesOfInfoImageHeight*Proportion);
            }else{
                imageView.frame = CGRectMake(MoreMesLeftMargin*Proportion,
                                             CGRectGetMaxY(moreLabel.frame) + 26*Proportion + (MoreMesImageHeight + ModerMesImageSpace)*Proportion*i,
                                             MoreMesImageWidth*Proportion,
                                             MoreMesImageHeight*Proportion);
            }
            imageView.backgroundColor = [UIColor CMLPromptGrayColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.bgView addSubview:imageView];
            [NetWorkTask setImageView:imageView WithURL:obj.coverPic placeholderImage:nil];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.font = KSystemBoldFontSize14;
            nameLabel.text = obj.title;
            nameLabel.textColor = [UIColor CMLUserBlackColor];
            [nameLabel sizeToFit];
            
            if (self.isInfo) {
                
                if (nameLabel.frame.size.width < self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesOfInfoImageWidth*Proportion) {
                    nameLabel.numberOfLines = 1;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                                 imageView.frame.origin.y,
                                                 self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesOfInfoImageWidth*Proportion,
                                                 nameLabel.frame.size.height);
                }else{
                    nameLabel.numberOfLines = 2;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                                 imageView.frame.origin.y,
                                                 self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesOfInfoImageWidth*Proportion,
                                                 nameLabel.frame.size.height*2);
                }
                
            }else{
                
                if (nameLabel.frame.size.width < self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesImageWidth*Proportion) {
                    nameLabel.numberOfLines = 1;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                                 imageView.frame.origin.y,
                                                 self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesImageWidth*Proportion,
                                                 nameLabel.frame.size.height);
                }else{
                    nameLabel.numberOfLines = 2;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion,
                                                 imageView.frame.origin.y,
                                                 self.bgView.frame.size.width - MoreMesLeftMargin*Proportion*3 - MoreMesImageWidth*Proportion,
                                                 nameLabel.frame.size.height*2);
                }
                
            }
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [self.bgView addSubview:nameLabel];
            
            if ([self.currentClass intValue] == 2) {
                
                UILabel *lvlLab = [[UILabel alloc] init];
                lvlLab.textColor = [UIColor CMLtextInputGrayColor];
                switch ([obj.memberLevelId intValue]) {
                    case 1:
                        lvlLab.text = @"粉色";
                        break;
                    case 2:
                        lvlLab.text = @"黛色";
                        break;
                    case 3:
                        lvlLab.text = @"金色";
                        break;
                    case 4:
                        lvlLab.text = @"墨色";
                        break;
                        
                    default:
                        break;
                }
                lvlLab.font = KSystemFontSize10;
                lvlLab.layer.cornerRadius = 4*Proportion;
                lvlLab.layer.borderWidth = 1*Proportion;
                lvlLab.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
                lvlLab.textAlignment = NSTextAlignmentCenter;
                [lvlLab sizeToFit];
                lvlLab.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MoreMesImageAndNameSpace*Proportion ,
                                          CGRectGetMaxY(imageView.frame) - 34*Proportion,
                                          lvlLab.frame.size.width + 10*Proportion,
                                          34*Proportion);
                [self.bgView addSubview:lvlLab];
                
                UILabel *begiinTime = [[UILabel alloc] init];
                begiinTime.textColor = [UIColor CMLtextInputGrayColor];
                begiinTime.text = [NSString getProjectStartTime:obj.actBeginTime];
                begiinTime.font = KSystemFontSize10;
                begiinTime.layer.cornerRadius = 4*Proportion;
                begiinTime.layer.borderWidth = 1*Proportion;
                begiinTime.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
                begiinTime.textAlignment = NSTextAlignmentCenter;
                [begiinTime sizeToFit];
                begiinTime.frame = CGRectMake(CGRectGetMaxX(lvlLab.frame) + MoreMesImageAndNameSpace*Proportion ,
                                              CGRectGetMaxY(imageView.frame) - 34*Proportion,
                                              begiinTime.frame.size.width + 10*Proportion,
                                              34*Proportion);
                [self.bgView addSubview:begiinTime];
                
            }else{
                
                UILabel *numLabel = [[UILabel alloc] init];
                numLabel.font = KSystemFontSize12;
                numLabel.textColor = [UIColor CMLtextInputGrayColor];
                numLabel.text = [NSString stringWithFormat:@"喜欢 %@ · 收藏 %@",obj.likeNum,obj.favNum];
                [numLabel sizeToFit];
                numLabel.frame =CGRectMake(nameLabel.frame.origin.x,
                                           CGRectGetMaxY(nameLabel.frame) + 10*Proportion,
                                           numLabel.frame.size.width,
                                           numLabel.frame.size.height);
                [self.bgView addSubview:numLabel];
                
            }
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          imageView.frame.origin.y,
                                                                          [UIScreen mainScreen].bounds.size.width,
                                                                          imageView.frame.size.height)];
            button.tag = i;
            [self.bgView addSubview:button];
            [button addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == self.List.count - 1) {
                self.currentHeight = CGRectGetMaxY(button.frame) + 50*Proportion;
                self.bgView.frame = CGRectMake(20*Proportion,
                                               0,
                                               WIDTH - 20*Proportion*2,
                                               self.currentHeight);
            }
        }
        
    }
    
}



- (void) enterDetailVC:(UIButton*) button{
    
    MoreMesObj *obj = [MoreMesObj getBaseObjFrom:self.List[button.tag]];
    if ([self.currentClass intValue] == 1) {
        InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([self.currentClass intValue] == 2){
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([self.currentClass intValue] == 7){
        
        CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    } else{
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}

- (void) createOrder:(UIButton *) btn{
    
    MoreMesObj *obj = [MoreMesObj getBaseObjFrom:self.List[btn.tag]];
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
