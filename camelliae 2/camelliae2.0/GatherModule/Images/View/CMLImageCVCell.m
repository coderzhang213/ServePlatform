//
//  CMLImageCVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLImageCVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "CMLImageListObj.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"


#define CMLBGViewLeftMargin             10

#define CMLMainImageWidth               330
#define CMLImagesVCLeftMargin           10
#define CMLImagesVCRightMargin          10
#define ImageLeftAndRightMargin         20
#define ImageTopMargin                  20

#define CMLImagesVCLineWidth            8
#define CMLImagesVCNameTopMargin        20
#define CMLImagesVCNameBottomMargin     20
#define CMLImagesVCNameLeftMarginMargin 30
#define CMLImagesVCBtnAndBtnSpace       20
#define CMLImagesVCBtnImgAndTitleSpace  10

@interface CMLImageCVCell ()<NetWorkProtocol>{

    UIImageView *mainImage;
    UILabel *titleLabel;
    CMLLine *line;

}

@property (nonatomic,strong) CMLImageListObj *currentObj;

@end

@implementation CMLImageCVCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
    }
    return self;
}

- (void) createView{

    mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                              ImageTopMargin*Proportion,
                                                              CMLMainImageWidth*Proportion,
                                                              CMLMainImageWidth*Proportion/3*2)];
    mainImage.backgroundColor = [UIColor CMLPromptGrayColor];
    mainImage.layer.cornerRadius = 6*Proportion;
    mainImage.layer.shadowColor = [UIColor blackColor].CGColor;
    mainImage.layer.shadowOpacity = 0.8;
    mainImage.layer.shadowOffset = CGSizeMake(0, 0);
    mainImage.contentMode = UIViewContentModeScaleAspectFill;
    mainImage.clipsToBounds = YES;
    [self.contentView addSubview:mainImage];

    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"test";
    titleLabel.font = KSystemBoldFontSize14;
    titleLabel.textColor = [UIColor CMLUserBlackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel sizeToFit];
    [self.contentView addSubview:titleLabel];

    
}

- (void) refreshCurrentCell:(CMLImageListObj*)listObj{
    
    UIView *lineView = [self.contentView viewWithTag:1];
    [lineView removeFromSuperview];

    self.currentObj = listObj;
    self.contentView.backgroundColor = [UIColor CMLUserGrayColor];
    [NetWorkTask setImageView:mainImage WithURL:listObj.coverPicThumb placeholderImage:nil];
    
    titleLabel.text = listObj.title;
    
    if (self.currentTag%2 == 0) {
        
        mainImage.frame = CGRectMake(CMLImagesVCNameLeftMarginMargin*Proportion,
                                     0,
                                     CMLMainImageWidth*Proportion,
                                     CMLMainImageWidth*Proportion/3*2);
        
        titleLabel.frame = CGRectMake((CMLImagesVCLeftMargin + CMLImagesVCNameLeftMarginMargin + CMLImagesVCLineWidth )*Proportion,
                                      CGRectGetMaxY(mainImage.frame) + CMLImagesVCNameTopMargin*Proportion,
                                      mainImage.frame.size.width - (CMLImagesVCNameLeftMarginMargin + CMLImagesVCLineWidth)*Proportion,
                                      titleLabel.frame.size.height);
        

        
    }else{
        mainImage.frame = CGRectMake(0,
                                     0,
                                     CMLMainImageWidth*Proportion,
                                     CMLMainImageWidth*Proportion/3*2);
        
        titleLabel.frame = CGRectMake((CMLImagesVCLeftMargin + CMLImagesVCLineWidth)*Proportion,
                                      CGRectGetMaxY(mainImage.frame) + CMLImagesVCNameTopMargin*Proportion,
                                      mainImage.frame.size.width - (CMLImagesVCNameLeftMarginMargin + CMLImagesVCLineWidth)*Proportion,
                                      titleLabel.frame.size.height);
        
       
    }
        CMLLine  *leftLine = [[CMLLine alloc] init];
        leftLine.lineWidth = CMLImagesVCLineWidth*Proportion;
        leftLine.layer.cornerRadius = CMLImagesVCLineWidth*Proportion/2.0;
        leftLine.lineLength = titleLabel.frame.size.height;
        leftLine.LineColor = [UIColor CMLYellowColor];
        leftLine.directionOfLine = VerticalLine;
        leftLine.tag = 1;
        [self.contentView addSubview:leftLine];
        leftLine.startingPoint = CGPointMake(mainImage.frame.origin.x, titleLabel.frame.origin.y);
    
}

@end
