//
//  CMLOwnVIPMessageShowView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLOwnVIPMessageShowView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "DataManager.h"
#import "CMLLine.h"

@implementation CMLOwnVIPMessageShowView

- (instancetype)init{

    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, WIDTH, 390*Proportion);
        self.backgroundColor = [UIColor CMLDarkOrangeColor];
        
        [self loadUserVIPMessage];
    }
    return self;
}

- (void) loadUserVIPMessage{

    UIImageView *bgImage = [[UIImageView alloc] init];
    switch ([[[DataManager lightData] readUserLevel] intValue]) {
        case 1:
            bgImage.image = [UIImage imageNamed:OwnVIPPinkBgImg];
            break;
        case 2:
            bgImage.image = [UIImage imageNamed:OwnVIPPigmentBgImg];
            break;
        case 3:
            bgImage.image = [UIImage imageNamed:OwnVIPGoldBgImg];
            break;
        case 4:
            bgImage.image = [UIImage imageNamed:OwnVIPDarkBgImg];
            break;
            
        default:
            break;
    }
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds = YES;
    bgImage.layer.cornerRadius = 10*Proportion;
    bgImage.frame = CGRectMake(WIDTH/2.0 - 640*Proportion/2.0,
                               40*Proportion,
                               640*Proportion,
                               self.frame.size.height - 40*Proportion);
    [self addSubview:bgImage];
    
    
    UIImageView *userImage = [[UIImageView alloc] init];
    userImage.clipsToBounds = YES;
    userImage.backgroundColor = [UIColor CMLPromptGrayColor];
    userImage.layer.cornerRadius = 6*Proportion;
    userImage.frame = CGRectMake(50*Proportion,
                                 40*Proportion,
                                 80*Proportion,
                                 80*Proportion);
    [bgImage addSubview:userImage];
    [NetWorkTask setImageView:userImage WithURL:[[DataManager lightData] readUserHeadImgUrl] placeholderImage:nil];
    
    UILabel *userNickName = [[UILabel alloc] init];
    userNickName.text = [[DataManager lightData] readNickName];
    userNickName.font = KSystemFontSize16;
    userNickName.textColor = [UIColor CMLWhiteColor];
    [userNickName sizeToFit];
    userNickName.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                    userImage.frame.origin.y,
                                    userNickName.frame.size.width,
                                    userNickName.frame.size.height);
    [bgImage addSubview:userNickName];
    
    
    UIImageView *lvl = [[UIImageView alloc] init];
    
    switch ([[[DataManager lightData] readUserLevel] intValue]) {
        case 1:
            lvl.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
        case 2:
            lvl.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
        case 3:
            lvl.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
        case 4:
            lvl.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    [lvl sizeToFit];
    lvl.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                           CGRectGetMaxY(userNickName.frame) + 10*Proportion,
                           lvl.frame.size.width,
                           lvl.frame.size.height);
    [bgImage addSubview:lvl];
    
    
    UILabel *promGrade = [[UILabel alloc] init];
    promGrade.font = KSystemBoldFontSize10;
    switch ([[[DataManager lightData] readGradeBuyState] intValue]) {
        case 0:
            promGrade.hidden = YES;
            break;
        case 1:
            promGrade.hidden = YES;
            break;
        case 2:
            promGrade.text = @"黛色特权";
            break;
        case 3:
            promGrade.text = @"金色特权";
            break;
        case 4:
            promGrade.hidden = YES;
            break;
            
        default:
            break;
    }
    promGrade.textColor = [UIColor CMLWhiteColor];
    promGrade.textAlignment = NSTextAlignmentCenter;
    promGrade.layer.cornerRadius =4*Proportion;
    promGrade.layer.borderColor = [UIColor CMLWhiteColor].CGColor;
    promGrade.layer.borderWidth = 1*Proportion;
    [promGrade sizeToFit];
    promGrade.frame = CGRectMake(CGRectGetMaxX(lvl.frame) + 10*Proportion,
                                 CGRectGetMaxY(userImage.frame) - 28*Proportion,
                                 promGrade.frame.size.width + 8*Proportion,
                                 28*Proportion);
    [bgImage addSubview:promGrade];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"有效期至 %@",[[DataManager lightData] readPrivilegeExpiryDate]];
    timeLabel.font = KSystemFontSize10;
    timeLabel.textColor = [UIColor CMLWhiteColor];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(bgImage.frame.size.width - 20*Proportion - timeLabel.frame.size.width,
                                 promGrade.center.y - timeLabel.frame.size.height/2.0,
                                 timeLabel.frame.size.width,
                                 timeLabel.frame.size.height);
    [bgImage addSubview:timeLabel];
    if ([[DataManager lightData] readPrivilegeExpiryDate].length == 0) {
        timeLabel.hidden = YES;
    }else{
        timeLabel.hidden = NO;
    }
    
    
    NSArray *promArray = @[@"粉",@"黛",@"金",@"墨"];

    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.font = KSystemBoldFontSize10;
    testLabel.text = @"粉";
    [testLabel sizeToFit];
    CGFloat space = (bgImage.frame.size.width - 30*Proportion*2 -testLabel.frame.size.width*4)/3.0;
    CGFloat dianLength = (bgImage.frame.size.width - 30*Proportion*2 -20*Proportion*4)/3.0;
    for (int i = 0; i < 4; i++) {
        
        UILabel *promLabel = [[UILabel alloc] init];
        promLabel.text = promArray[i];
        promLabel.font = KSystemBoldFontSize10;
        promLabel.textColor = [UIColor CMLWhiteColor];
        [promLabel sizeToFit];
        promLabel.frame = CGRectMake(30*Proportion + (testLabel.frame.size.width + space)*i,
                                     bgImage.frame.size.height - 67*Proportion - 30*Proportion - promLabel.frame.size.height,
                                     promLabel.frame.size.width,
                                     promLabel.frame.size.height);

        [bgImage addSubview:promLabel];
        
        UIView *dian = [[UIView alloc] initWithFrame:CGRectMake(promLabel.center.x - 20*Proportion/2.0,
                                                                promLabel.frame.origin.y - 10*Proportion - 20*Proportion,
                                                                20*Proportion,
                                                                20*Proportion)];
        dian.layer.cornerRadius = 20*Proportion/2.0;
        dian.backgroundColor = [UIColor CMLWhiteColor];;
        if ([[[DataManager lightData] readUserLevel] intValue] >= (i + 1)) {
            
            dian.alpha = 1;
        }else{
            dian.alpha = 0.5;
        }
        [bgImage addSubview:dian];
        
        if (i == 0) {
        
            CMLLine *line = [[CMLLine alloc] init];
            line.startingPoint = CGPointMake(CGRectGetMaxX(dian.frame), dian.center.y - 5*Proportion/2.0);
            line.lineWidth = 5*Proportion;
            line.lineLength = dianLength;
            line.LineColor = [UIColor CMLWhiteColor];
            if ([[[DataManager lightData] readUserLevel] intValue]> 1 ) {
                line.alpha = 1;
            }else{
                line.alpha = 0.5;
            }
            [bgImage addSubview:line];
        }else if (i == 1){
        
            CMLLine *line = [[CMLLine alloc] init];
            line.startingPoint = CGPointMake(CGRectGetMaxX(dian.frame), dian.center.y - 5*Proportion/2.0);
            line.lineWidth = 5*Proportion;
            line.lineLength =  dianLength;
            line.LineColor = [UIColor CMLWhiteColor];
            if ([[[DataManager lightData] readUserLevel] intValue]> 2 ) {
                line.alpha = 1;
            }else{
                line.alpha = 0.5;
            }
            [bgImage addSubview:line];
        }else if (i == 2){
        
            CMLLine *line = [[CMLLine alloc] init];
            line.startingPoint = CGPointMake(CGRectGetMaxX(dian.frame), dian.center.y - 5*Proportion/2.0);
            line.lineWidth = 5*Proportion;
            line.lineLength =  dianLength;
            line.LineColor = [UIColor CMLWhiteColor];
            if ([[[DataManager lightData] readUserLevel] intValue]> 3 ) {
                line.alpha = 1;
            }else{
                line.alpha = 0.5;
            }
            [bgImage addSubview:line];
        }
    }
    
}

@end
