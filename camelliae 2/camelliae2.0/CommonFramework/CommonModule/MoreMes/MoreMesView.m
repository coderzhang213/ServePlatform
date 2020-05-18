//
//  MoreMesView.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "MoreMesView.h"
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

@interface MoreMesView ()

@property (nonatomic,strong) UIView *bgView;

@end


@implementation MoreMesView

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

    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.text = @"· 相 关 推 荐 ·";
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
            
        }else if ([self.currentClass intValue] == 7){
        
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.font = KSystemBoldFontSize16;
            numLabel.textColor = [UIColor CMLBrownColor];
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[obj.packageInfo.dataList firstObject]];
            numLabel.text = [NSString stringWithFormat:@"¥%@",costObj.totalAmountStr];
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


@end
