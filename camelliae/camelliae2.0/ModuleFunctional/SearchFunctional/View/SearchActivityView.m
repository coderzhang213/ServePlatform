//
//  SearchActivityView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchActivityView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "CMLSearchVC.h"
#import "SearchResultObj.h"
#import "CMLSearchListVC.h"
#import "ActivityDefaultVC.h"

#define SearchResultLeftMargin        30
#define SearchResultTopMargin         30
#define SearchResultTitleAndLineSpace 10
#define SearchResultBtnHeight         100
#define SearchResultMoreBtnTopMargin  60
#define SearchResultMoreBtnBottomMargin 40
#define SearchResultMoreBtnHeight     48
#define SearchResultImageWidthAndHeight 160

@interface SearchActivityView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *searchStr;

@end
@implementation SearchActivityView

- (instancetype) initWithDataArray:(NSArray *)array dataCount:(int) count andSearchStr:(NSString *) str{
    
    self = [super init];
    
    if (self) {
        
        self.dataArray = array;
        self.dataCount = count;
        self.searchStr = str;
        
        if (self.dataArray.count > 0) {
            
            [self loadViews];
            
        }else{
            
            self.currentHeight = 0;
        }
    }
    
    return self;
}

- (void) loadViews{
    
    UILabel *activityTile = [[UILabel alloc] init];
    activityTile.text = @"相关活动";
    activityTile.font = KSystemFontSize12;
    activityTile.textColor = [UIColor CMLtextInputGrayColor];
    [activityTile sizeToFit];
    activityTile.frame = CGRectMake(SearchResultLeftMargin*Proportion,
                                    SearchResultTopMargin*Proportion,
                                    activityTile.frame.size.width,
                                    activityTile.frame.size.height);
    [self addSubview:activityTile];
    
    CMLLine *activityLine = [[CMLLine alloc] init];
    activityLine.directionOfLine = VerticalLine;
    activityLine.lineWidth = 4*Proportion;
    activityLine.LineColor = [UIColor CMLYellowColor];
    activityLine.lineLength = activityTile.frame.size.height;
    activityLine.startingPoint = CGPointMake(activityTile.frame.origin.x - 10*Proportion, activityTile.frame.origin.y);
    [self addSubview:activityLine];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
    spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
    spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(activityTile.frame) + 30*Proportion);
    [self addSubview:spaceLine];
    
    int activityNum = 0;
    if (self.dataArray.count > 3) {
        activityNum = 3;
    }else{
        activityNum = (int)self.dataArray.count;
    }
    
    for (int i = 0; i < activityNum; i++) {
        
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[i]];
        
        UIView *btnbgView = [[UIView alloc] initWithFrame:CGRectMake(SearchResultLeftMargin*Proportion,
                                                                     CGRectGetMaxY(activityTile.frame) + 60*Proportion + (SearchResultTopMargin*2 + SearchResultImageWidthAndHeight)*Proportion*i,
                                                                     WIDTH - SearchResultLeftMargin*Proportion*2,
                                                                     SearchResultImageWidthAndHeight*Proportion + SearchResultTopMargin*Proportion)];
        btnbgView.userInteractionEnabled = YES;
        btnbgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:btnbgView];
        
        UIImageView *activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   0,
                                                                                   SearchResultImageWidthAndHeight*Proportion,
                                                                                   SearchResultImageWidthAndHeight*Proportion)];
        activityImage.backgroundColor = [UIColor CMLPromptGrayColor];
        activityImage.contentMode = UIViewContentModeScaleAspectFill;
        activityImage.clipsToBounds = YES;
        [btnbgView addSubview:activityImage];
        [NetWorkTask setImageView:activityImage WithURL:obj.objCoverPic placeholderImage:nil];
        
        CMLLine *spaceLine = [[CMLLine alloc] init];
        spaceLine.lineWidth = 1*Proportion;
        spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
        spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
        spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(activityImage.frame),
                                              CGRectGetMaxY(activityImage.frame) + 30*Proportion);
        [btnbgView addSubview:spaceLine];
        
        UILabel *activityLabel =[[UILabel alloc] init];
        activityLabel.font = KSystemBoldFontSize15;
        activityLabel.text = obj.title;
        activityLabel.textColor = [UIColor CMLBlackColor];
        activityLabel.backgroundColor = [UIColor whiteColor];
        [btnbgView addSubview:activityLabel];
        
        CGSize activityTitleSize = [obj.title sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize15}];
        if (activityTitleSize.width > (WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3)) {
            
            activityLabel.numberOfLines = 2;
            activityLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + SearchResultLeftMargin*Proportion,
                                             activityImage.frame.origin.y,
                                             WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                             activityTitleSize.height*2);
            
        }else{
            
            activityLabel.numberOfLines = 1;
            activityLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + SearchResultLeftMargin*Proportion,
                                             activityImage.frame.origin.y,
                                             WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                             activityTitleSize.height);
            
        }
        
        UILabel *activityContentLabel = [[UILabel alloc] init];
        activityContentLabel.font = KSystemFontSize13;
        activityContentLabel.text = obj.briefIntro;
        activityContentLabel.textColor = [UIColor CMLtextInputGrayColor];
        activityContentLabel.backgroundColor = [UIColor whiteColor];
        [btnbgView addSubview:activityContentLabel];
        CGSize activityContentSize = [obj.briefIntro sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize12}];
        if (activityContentSize.width > (WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3)) {
            
            activityContentLabel.numberOfLines = 2;
            activityContentLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame)+ SearchResultLeftMargin*Proportion,
                                                    CGRectGetMaxY(activityLabel.frame) + 10*Proportion,
                                                    WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                                    activityContentSize.height*2);
            
            if ((activityContentLabel.frame.size.height + activityLabel.frame.size.height) > (activityImage.frame.size.height - 40*Proportion)) {
                activityContentLabel.numberOfLines = 1;
                activityContentLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame)+ SearchResultLeftMargin*Proportion,
                                                        CGRectGetMaxY(activityLabel.frame) + 10*Proportion,
                                                        WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                                        activityContentSize.height/2.0);
            }
            
            
            
        }else{
            
            activityContentLabel.numberOfLines = 1;
            activityContentLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame)+ SearchResultLeftMargin*Proportion,
                                                    CGRectGetMaxY(activityLabel.frame) + 10*Proportion,
                                                    WIDTH - activityImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                                    activityContentSize.height);
            
        }
        
        UILabel *smallLabelOne = [[UILabel alloc] init];
        smallLabelOne.textColor = [UIColor CMLtextInputGrayColor];
        switch ([obj.memberLevelId intValue]) {
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
        smallLabelOne.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + SearchResultLeftMargin*Proportion,
                                         CGRectGetMaxY(activityImage.frame)- 30*Proportion,
                                         smallLabelOne.frame.size.width + 20*Proportion,
                                         30*Proportion);
        smallLabelOne.textAlignment = NSTextAlignmentCenter;
        smallLabelOne.layer.cornerRadius = 4*Proportion;
        smallLabelOne.layer.borderWidth = 0.5;
        smallLabelOne.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [btnbgView addSubview:smallLabelOne];
        
        
        UILabel *smallLabelTwo = [[UILabel alloc] init];
        smallLabelTwo.textColor = [UIColor CMLtextInputGrayColor];
        smallLabelTwo.text = [NSString getProjectStartTime:obj.actBeginTime];
        smallLabelTwo.font = KSystemFontSize10;
        smallLabelTwo.backgroundColor = [UIColor whiteColor];
        [smallLabelTwo sizeToFit];
        smallLabelTwo.frame = CGRectMake(CGRectGetMaxX(smallLabelOne.frame) + SearchResultLeftMargin*Proportion,
                                         CGRectGetMaxY(activityImage.frame)- 30*Proportion,
                                         smallLabelTwo.frame.size.width + 20*Proportion,
                                         30*Proportion);
        smallLabelTwo.textAlignment = NSTextAlignmentCenter;
        smallLabelTwo.layer.cornerRadius = 4*Proportion;
        smallLabelTwo.layer.borderWidth = 0.5;
        smallLabelTwo.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [btnbgView addSubview:smallLabelTwo];
        
        UIButton *button = [[UIButton alloc] initWithFrame:btnbgView.bounds];
        button.tag = i;
        [button addTarget:self action:@selector(enterActivityDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [btnbgView addSubview:button];
        
        
        if (i == (activityNum - 1)) {
            
            if (self.dataCount > 3) {
             
                UIButton *activityMoreBtn = [[UIButton alloc] init];
                [activityMoreBtn setTitle:@"查看更多相关活动" forState:UIControlStateNormal];
                [activityMoreBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                activityMoreBtn.titleLabel.font = KSystemFontSize12;
                [activityMoreBtn sizeToFit];
                activityMoreBtn.layer.cornerRadius = SearchResultMoreBtnHeight*Proportion/2.0;
                activityMoreBtn.backgroundColor = [UIColor CMLBrownColor];
                activityMoreBtn.frame = CGRectMake(WIDTH/2.0 - (SearchResultMoreBtnHeight*Proportion*2 + activityMoreBtn.frame.size.width)/2.0,
                                                   40*Proportion + CGRectGetMaxY(btnbgView.frame),
                                                   (SearchResultMoreBtnHeight*Proportion*2 + activityMoreBtn.frame.size.width),
                                                   SearchResultMoreBtnHeight*Proportion);
                [activityMoreBtn addTarget:self action:@selector(enterSearchListOfActivity) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:activityMoreBtn];
                
                UIView *bottomViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(activityMoreBtn.frame) + SearchResultMoreBtnBottomMargin*Proportion,
                                                                                 WIDTH,
                                                                                 20*Proportion)];
                bottomViewTwo.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomViewTwo];
                
                self.currentHeight = CGRectGetMaxY(bottomViewTwo.frame);
                
            }else{
            
                UIView *bottomViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(btnbgView.frame) + 40*Proportion,
                                                                                 WIDTH,
                                                                                 20*Proportion)];
                bottomViewTwo.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomViewTwo];
                
                self.currentHeight = CGRectGetMaxY(bottomViewTwo.frame);
            }
            
        }
        
    }
}

- (void) enterActivityDetailVC:(UIButton *) button{
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.searchStr,@"searchStr", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:dict];
    
    SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[button.tag]];
    
    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterSearchListOfActivity{
    
    CMLSearchListVC *vc = [[CMLSearchListVC alloc] initWithSearchStr:self.searchStr name:@"活动"];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
