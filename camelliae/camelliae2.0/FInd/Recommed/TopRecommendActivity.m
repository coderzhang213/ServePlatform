//
//  TopRecommendActivity.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "TopRecommendActivity.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "ActivityDefaultVC.h"
#import "VCManger.h"
#import "CMLLine.h"


#define MainInterfaceLeftMargin              30
#define MainInterfaceTopMargin               40
#define MainInterfaceShortTitleTopMargin     10
#define MainInterfaceSpace                   20
#define MainInterfaceOtherSpace              60
#define MainInterfaceModelImageHeight        180


@interface TopRecommendActivity ()

@property (nonatomic,strong) BaseResultObj *recommenModuleObj;

@end

@implementation TopRecommendActivity

- (instancetype)initWith:(BaseResultObj *)obj{

    self = [super init];
    if (self) {

        self.recommenModuleObj = obj;
        self.backgroundColor = [UIColor whiteColor];
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    if (self.recommenModuleObj.retData.moduleActivity) {
        
        UILabel *promName = [[UILabel alloc] init];
        promName.text = @"最 新 活 动";
        promName.font = KSystemRealBoldFontSize17;
        [promName sizeToFit];
        promName.backgroundColor = [UIColor whiteColor];
        promName.layer.masksToBounds = YES;
        promName.textColor = [UIColor CMLUserBlackColor];
        promName.frame = CGRectMake(MainInterfaceLeftMargin*Proportion,
                                    MainInterfaceTopMargin*Proportion,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [bgView addSubview:promName];
        
        UILabel *shortTitle = [[UILabel alloc] init];
        shortTitle.text = @"马上就要开始了，还不快来参加";
        shortTitle.textColor = [UIColor CMLtextInputGrayColor];
        shortTitle.font = KSystemFontSize10;
        [shortTitle sizeToFit];
        shortTitle.frame = CGRectMake(MainInterfaceLeftMargin*Proportion,
                                      CGRectGetMaxY(promName.frame) + MainInterfaceShortTitleTopMargin*Proportion,
                                      shortTitle.frame.size.width,
                                      shortTitle.frame.size.height);
        [bgView addSubview:shortTitle];
        
        
        UIScrollView *bgScrollView = [[UIScrollView alloc] init];
        bgScrollView.showsVerticalScrollIndicator = NO;
        bgScrollView.showsHorizontalScrollIndicator = NO;
        bgScrollView.backgroundColor = [UIColor CMLWhiteColor];
        [bgView addSubview:bgScrollView];
        
        for (int i = 0 ; i < self.recommenModuleObj.retData.moduleActivity.dataList.count; i++) {
            
            CMLModuleObj *currentObj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleActivity.dataList[i]];
            
            UIView *modelView = [[UIView alloc] init];
            modelView.backgroundColor = [UIColor whiteColor];
            [bgScrollView addSubview:modelView];
            
            /**添加小模块的详细内容*/
            UIImageView *modelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    MainInterfaceModelImageHeight*Proportion/9*16,
                                                                                    MainInterfaceModelImageHeight*Proportion)];
            modelImage.clipsToBounds = YES;
            modelImage.userInteractionEnabled = YES;
            modelImage.layer.cornerRadius = 6*Proportion;
            modelImage.contentMode = UIViewContentModeScaleAspectFill;
            modelImage.backgroundColor = [UIColor CMLPromptGrayColor];
            [modelView addSubview:modelImage];
            [NetWorkTask setImageView:modelImage WithURL:currentObj.coverPicThumb placeholderImage:nil];
            
            UIButton *currentButton = [[UIButton alloc] initWithFrame:modelImage.bounds];
            currentButton.tag = i + 1;
            currentButton.backgroundColor = [UIColor clearColor];
            [modelImage addSubview:currentButton];
            [currentButton addTarget:self action:@selector(enterModuleActivityVC:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *modelTag = [[UILabel alloc] init];
            modelTag.textColor = [UIColor CMLBrownColor];
            modelTag.layer.borderWidth = 1*Proportion;
            modelTag.layer.borderColor = [UIColor CMLBrownColor].CGColor;
            modelTag.backgroundColor = [UIColor CMLWhiteColor];
            modelTag.text = currentObj.subTypeName;
            modelTag.textAlignment = NSTextAlignmentCenter;
            modelTag.font = KSystemFontSize9;
            [modelTag sizeToFit];
            modelTag.frame = CGRectMake(0,
                                        20*Proportion + CGRectGetMaxY(modelImage.frame),
                                        modelTag.frame.size.width,
                                        modelTag.frame.size.height);
            [modelView addSubview:modelTag];
            
            
            UILabel *modelLabel = [[UILabel alloc] init];
            modelLabel.text = currentObj.title;
            modelLabel.font = KSystemFontSize12;
            modelLabel.numberOfLines = 0;
            modelLabel.textColor = [UIColor CMLBlackColor];
            modelLabel.backgroundColor = [UIColor whiteColor];
            modelLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            modelLabel.layer.borderWidth = 1;
            modelLabel.layer.masksToBounds = YES;
            [modelLabel sizeToFit];
            modelLabel.textAlignment = NSTextAlignmentLeft;
            [modelView addSubview:modelLabel];
            
            /**第一个属性*/
            UILabel *modelAttributeOneLabel = [[UILabel alloc] init];
            modelAttributeOneLabel.text = currentObj.memberLevelStr;
            modelAttributeOneLabel.backgroundColor = [UIColor whiteColor];
            modelAttributeOneLabel.font = KSystemFontSize10;
            modelAttributeOneLabel.layer.cornerRadius = 4*Proportion;
            modelAttributeOneLabel.layer.borderWidth = 1*Proportion;
            modelAttributeOneLabel.clipsToBounds = YES;
            modelAttributeOneLabel.textAlignment = NSTextAlignmentCenter;
            [modelAttributeOneLabel sizeToFit];
            
            if (modelLabel.frame.size.width > 320*Proportion){
                
                modelLabel.frame = CGRectMake(0,
                                              CGRectGetMaxY(modelTag.frame) + 10*Proportion,
                                              320*Proportion,
                                              modelLabel.frame.size.height*2);
                
                modelAttributeOneLabel.frame = CGRectMake(0,
                                                          CGRectGetMaxY(modelLabel.frame) + 30*Proportion,
                                                          modelAttributeOneLabel.frame.size.width + 10*Proportion,
                                                          32*Proportion);
            }else{
                
                modelLabel.frame = CGRectMake(0,
                                              CGRectGetMaxY(modelTag.frame) + 10*Proportion,
                                              320*Proportion,
                                              modelLabel.frame.size.height);
                
                modelAttributeOneLabel.frame = CGRectMake(0,
                                                          CGRectGetMaxY(modelLabel.frame) + 30*Proportion + modelLabel.frame.size.height,
                                                          modelAttributeOneLabel.frame.size.width + 10*Proportion,
                                                          32*Proportion);
            }
            
            [modelView addSubview:modelAttributeOneLabel];
            
            switch ([currentObj.memberLevelId intValue]) {
                case 1:
                    modelAttributeOneLabel.layer.borderColor = [UIColor CMLPinkColor].CGColor;
                    modelAttributeOneLabel.textColor = [UIColor CMLPinkColor];
                    break;
                    
                case 2:
                    modelAttributeOneLabel.layer.borderColor = [UIColor CMLBlackPigmentColor].CGColor;
                    modelAttributeOneLabel.textColor = [UIColor CMLBlackPigmentColor];
                    break;
                    
                case 3:
                    modelAttributeOneLabel.layer.borderColor = [UIColor CMLGoldColor].CGColor;
                    modelAttributeOneLabel.textColor = [UIColor CMLGoldColor];
                    break;
                    
                case 4:
                    modelAttributeOneLabel.layer.borderColor = [UIColor CMLGrayColor].CGColor;
                    modelAttributeOneLabel.textColor = [UIColor CMLGrayColor];
                    break;
                    
                default:
                    break;
            }
            
            /**第二个属性*/
            
            UILabel *modelAttributeTwoLabel = [[UILabel alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSString *string=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[currentObj.actBeginTime intValue]]];
            
            modelAttributeTwoLabel.text = string;
            modelAttributeTwoLabel.backgroundColor = [UIColor whiteColor];
            modelAttributeTwoLabel.font = KSystemFontSize10;
            modelAttributeTwoLabel.layer.cornerRadius = 4*Proportion;
            modelAttributeTwoLabel.layer.borderWidth = 1*Proportion;
            modelAttributeTwoLabel.textColor = [UIColor CMLLineGrayColor];
            modelAttributeTwoLabel.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
            modelAttributeTwoLabel.clipsToBounds = YES;
            modelAttributeTwoLabel.textAlignment = NSTextAlignmentCenter;
            [modelAttributeTwoLabel sizeToFit];
            modelAttributeTwoLabel.frame = CGRectMake(CGRectGetMaxX(modelAttributeOneLabel.frame) + 10*Proportion,
                                                      modelAttributeOneLabel.frame.origin.y,
                                                      modelAttributeTwoLabel.frame.size.width + 10*Proportion,
                                                      32*Proportion);
            [modelView addSubview:modelAttributeTwoLabel];
            
            
            CGFloat currentHeight  = CGRectGetMaxY(modelAttributeOneLabel.frame);
            
            modelView.frame = CGRectMake(MainInterfaceLeftMargin*Proportion + (MainInterfaceSpace + MainInterfaceModelImageHeight/9*16)*Proportion*i,
                                         0,
                                         MainInterfaceModelImageHeight*Proportion/9*16,
                                         currentHeight);
            if (i ==  self.recommenModuleObj.retData.moduleActivity.dataList.count - 1) {
               
                bgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(modelView.frame) + MainInterfaceLeftMargin*Proportion, currentHeight);
                bgScrollView.frame = CGRectMake(0,
                                                CGRectGetMaxY(shortTitle.frame) + MainInterfaceSpace*Proportion,
                                                WIDTH,
                                                currentHeight);
                
                bgView.frame = CGRectMake(0,
                                          0,
                                          WIDTH,
                                          CGRectGetMaxY(bgScrollView.frame) + MainInterfaceOtherSpace*Proportion);
                
                CMLLine *bottomLine = [[CMLLine alloc] init];
                bottomLine.startingPoint = CGPointMake(MainInterfaceLeftMargin*Proportion, CGRectGetMaxY(bgScrollView.frame) + MainInterfaceOtherSpace*Proportion - 10*Proportion);
                bottomLine.lineWidth = 1*Proportion;
                bottomLine.LineColor = [UIColor CMLtextInputGrayColor];
                bottomLine.lineLength = WIDTH - 2*MainInterfaceLeftMargin*Proportion;
                [bgView addSubview:bottomLine];
                
                self.currentHeight = bgView.frame.size.height;
                
            }
        }
        
    }else{
        
        bgView.hidden = YES;
        self.currentHeight = bgView.frame.size.height;
    }
    
}

- (void) enterModuleActivityVC:(UIButton *) button{
    
    CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.recommenModuleObj.retData.moduleActivity.dataList[button.tag - 1]];
    
    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
