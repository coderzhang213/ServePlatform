//
//  SearchInformationView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchInformationView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "CMLSearchVC.h"
#import "SearchResultObj.h"
#import "CMLSearchListVC.h"
#import "InformationDefaultVC.h"
#import "CMLUserArticleVC.h"

#define SearchResultLeftMargin        30
#define SearchResultTopMargin         40
#define SearchResultTitleAndLineSpace 10
#define SearchResultBtnHeight         100
#define SearchResultMoreBtnTopMargin  60
#define SearchResultMoreBtnBottomMargin 40
#define SearchResultMoreBtnHeight     48
#define SearchResultImageWidthAndHeight 160

@interface SearchInformationView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *searchStr;

@end

@implementation SearchInformationView

- (instancetype) initWithDataArray:(NSArray *)array dataCount:(int) count andSearchStr:(NSString *) str{
    
    self = [super init];
    
    if (self) {
        
        self.dataArray = array;
        self.dataCount = count;
        self.searchStr = str;
        
        if (self.dataArray.count > 0) {
         
            [self loadViews];
            
        }else{
        
            self.hidden = YES;
            self.currentHeight = 0;
        }
    }
    
    return self;
}

- (void) loadViews{

    /**资讯*/
    UILabel *informationTile = [[UILabel alloc] init];
    informationTile.text = @"相关资讯";
    informationTile.font = KSystemFontSize12;
    informationTile.textColor = [UIColor CMLtextInputGrayColor];
    [informationTile sizeToFit];
    informationTile.frame = CGRectMake(SearchResultLeftMargin*Proportion,
                                       SearchResultTopMargin*Proportion,
                                       informationTile.frame.size.width,
                                       informationTile.frame.size.height);
    [self addSubview:informationTile];
    
    CMLLine *informationLine = [[CMLLine alloc] init];
    informationLine.directionOfLine = VerticalLine;
    informationLine.lineWidth = 4*Proportion;
    informationLine.LineColor = [UIColor CMLYellowColor];
    informationLine.lineLength = informationTile.frame.size.height;
    informationLine.startingPoint = CGPointMake(informationTile.frame.origin.x - 10*Proportion, informationTile.frame.origin.y);
    [self addSubview:informationLine];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
    spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
    spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(informationTile.frame) + 30*Proportion);
    [self addSubview:spaceLine];
    
    int informationNum = 0;
    if (self.dataArray.count > 3) {
        informationNum = 3;
    }else{
        informationNum = (int)self.dataArray.count;
    }

    CGFloat tempBtnHeight = CGRectGetMaxY(informationTile.frame) + 60*Proportion;
    
    for (int i = 0; i < informationNum; i++) {
        
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[i]];
        
        UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(SearchResultLeftMargin*Proportion,
                                                                               tempBtnHeight + (SearchResultImageWidthAndHeight*Proportion + 60*Proportion)*i,
                                                                               SearchResultImageWidthAndHeight*Proportion,
                                                                               SearchResultImageWidthAndHeight*Proportion)];
        infoImage.contentMode = UIViewContentModeScaleAspectFill;
        infoImage.clipsToBounds = YES;
        infoImage.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:infoImage];
        [NetWorkTask setImageView:infoImage WithURL:obj.coverPic placeholderImage:nil];
        
        CMLLine *spaceLine = [[CMLLine alloc] init];
        spaceLine.lineWidth = 1*Proportion;
        spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
        spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
        spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                              CGRectGetMaxY(infoImage.frame) + 30*Proportion);
        [self addSubview:spaceLine];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = obj.title;
        titleLab.textColor = [UIColor CMLBlackColor];
        titleLab.font = KSystemBoldFontSize15;
        titleLab.numberOfLines = 2;
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.backgroundColor = [UIColor whiteColor];
        [titleLab sizeToFit];
        
        UILabel *briefLab = [[UILabel alloc] init];
        briefLab.text = obj.desc;
        briefLab.font = KSystemFontSize13;
        briefLab.textColor = [UIColor CMLLineGrayColor];
        briefLab.textAlignment = NSTextAlignmentLeft;
        briefLab.backgroundColor = [UIColor whiteColor];
        [briefLab sizeToFit];
        [self addSubview:briefLab];
        
        if (titleLab.frame.size.width > (WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion)) {
            
            titleLab.frame = CGRectMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                        infoImage.frame.origin.y,
                                        WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion,
                                        titleLab.frame.size.height*2);
            
            briefLab.numberOfLines = 1;
            briefLab.frame = CGRectMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                        CGRectGetMaxY(titleLab.frame) + 10*Proportion,
                                        WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion,
                                        briefLab.frame.size.height);
        }else{
            
            titleLab.frame = CGRectMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                        infoImage.frame.origin.y,
                                        WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion,
                                        titleLab.frame.size.height);
            briefLab.numberOfLines = 2;
            if (briefLab.frame.size.width > (WIDTH - SearchResultLeftMargin*Proportion*3) - SearchResultImageWidthAndHeight*Proportion) {
                
                briefLab.frame = CGRectMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                            CGRectGetMaxY(titleLab.frame) + 10*Proportion,
                                            WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion,
                                            briefLab.frame.size.height*2);
            }else{
                
                briefLab.frame = CGRectMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(infoImage.frame),
                                            CGRectGetMaxY(titleLab.frame) + 10*Proportion,
                                            WIDTH - SearchResultLeftMargin*Proportion*3 - SearchResultImageWidthAndHeight*Proportion,
                                            briefLab.frame.size.height);
            }
            
        }
        
        [self addSubview:titleLab];
        
        UILabel *nickNameLab = [[UILabel alloc] init];
        nickNameLab.font = KSystemFontSize10;
        nickNameLab.textColor = [UIColor CMLtextInputGrayColor];
        nickNameLab.text = obj.nickName;
        nickNameLab.backgroundColor = [UIColor whiteColor];
        nickNameLab.layer.borderWidth = 1*Proportion;
        nickNameLab.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        nickNameLab.textAlignment = NSTextAlignmentCenter;
        [nickNameLab sizeToFit];
        nickNameLab.frame =CGRectMake(CGRectGetMaxX(infoImage.frame) + SearchResultLeftMargin*Proportion,
                                      CGRectGetMaxY(infoImage.frame) - nickNameLab.frame.size.height - 10*Proportion,
                                      nickNameLab.frame.size.width + 10*Proportion,
                                      nickNameLab.frame.size.height + 10*Proportion);
        [self addSubview:nickNameLab];
        

        
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.font = KSystemFontSize10;
        timeLab.textColor = [UIColor CMLtextInputGrayColor];
        timeLab.text = obj.publishTimeStr;
        timeLab.backgroundColor = [UIColor whiteColor];
        [timeLab sizeToFit];
        timeLab.frame =CGRectMake(WIDTH - SearchResultLeftMargin*Proportion - timeLab.frame.size.width,
                                  CGRectGetMaxY(infoImage.frame) - timeLab.frame.size.height,
                                  timeLab.frame.size.width,
                                  timeLab.frame.size.height);
        [self addSubview:timeLab];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SearchResultLeftMargin*Proportion,
                                                                      tempBtnHeight + (SearchResultImageWidthAndHeight + 40)*Proportion*i,
                                                                      WIDTH,
                                                                      SearchResultImageWidthAndHeight*Proportion)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(enterInformationDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        

        
        if (i == (informationNum - 1)) {
            
            if (self.dataCount > 3) {
               
                UIButton *informationMoreBtn = [[UIButton alloc] init];
                [informationMoreBtn setTitle:@"查看更多相关资讯" forState:UIControlStateNormal];
                [informationMoreBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                informationMoreBtn.titleLabel.font = KSystemFontSize12;
                [informationMoreBtn sizeToFit];
                [informationMoreBtn addTarget:self action:@selector(enterSearchListOfInformation) forControlEvents:UIControlEventTouchUpInside];
                informationMoreBtn.layer.cornerRadius = SearchResultMoreBtnHeight*Proportion/2.0;
                informationMoreBtn.backgroundColor = [UIColor CMLBrownColor];
                informationMoreBtn.frame = CGRectMake(WIDTH/2.0 - (informationMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2)/2.0,
                                                       CGRectGetMaxY(infoImage.frame) + 60*Proportion,
                                                      informationMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2,
                                                      SearchResultMoreBtnHeight*Proportion);
                
                [self addSubview:informationMoreBtn];
                
                UIView *bottomViewOne = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(informationMoreBtn.frame) + SearchResultMoreBtnBottomMargin*Proportion,
                                                                                 WIDTH,
                                                                                 20*Proportion)];
                bottomViewOne.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomViewOne];
                
                self.currentHeight = CGRectGetMaxY(bottomViewOne.frame);
                
            }else{
            
                UIView *bottomViewOne = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(button.frame) + 60*Proportion,
                                                                                 WIDTH,
                                                                                 20*Proportion)];
                bottomViewOne.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomViewOne];
                
                self.currentHeight = CGRectGetMaxY(bottomViewOne.frame);
            }
        }
    }
}

- (void) enterInformationDetailVC:(UIButton *) button{
    
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.searchStr,@"searchStr", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:dict];
    
    SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[button.tag]];
    
    CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterSearchListOfInformation{
    
    CMLSearchListVC *vc = [[CMLSearchListVC alloc] initWithSearchStr:self.searchStr name:@"文章"];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

@end
