//
//  SearchServeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchServeView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "CMLSearchVC.h"
#import "SearchResultObj.h"
#import "CMLSearchListVC.h"
#import "ServeDefaultVC.h"
#import "PackDetailInfoObj.h"

#define SearchResultLeftMargin        30
#define SearchResultTopMargin         30
#define SearchResultTitleAndLineSpace 10
#define SearchResultBtnHeight         100
#define SearchResultMoreBtnTopMargin  60
#define SearchResultMoreBtnBottomMargin 40
#define SearchResultMoreBtnHeight     48
#define SearchResultImageWidthAndHeight 160

@interface SearchServeView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *searchStr;

@end
@implementation SearchServeView

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
    
    UILabel *serveTile = [[UILabel alloc] init];
    serveTile.text = @"相关商城服务";
    serveTile.font = KSystemFontSize12;
    serveTile.textColor = [UIColor CMLtextInputGrayColor];
    [serveTile sizeToFit];
    serveTile.frame = CGRectMake(SearchResultLeftMargin*Proportion,
                                 SearchResultTopMargin*Proportion,
                                 serveTile.frame.size.width,
                                 serveTile.frame.size.height);
    [self addSubview:serveTile];
    
    CMLLine *serveLine = [[CMLLine alloc] init];
    serveLine.directionOfLine = VerticalLine;
    serveLine.LineColor = [UIColor CMLYellowColor];
    serveLine.lineWidth = 4*Proportion;
    serveLine.lineLength = serveTile.frame.size.height;
    serveLine.startingPoint = CGPointMake(serveTile.frame.origin.x - 10*Proportion, serveTile.frame.origin.y);
    [self addSubview:serveLine];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
    spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
    spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(serveTile.frame) + 30*Proportion);
    [self addSubview:spaceLine];
    
    int serveNum = 0;
    if (self.dataArray.count > 3) {
        serveNum = 3;
    }else{
        serveNum = (int)self.dataArray.count;
    }
    
 
    for (int i = 0; i < serveNum; i++) {
        
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[i]];
        
        UIView *btnbgView = [[UIView alloc] initWithFrame:CGRectMake(SearchResultLeftMargin*Proportion,
                                                                     CGRectGetMaxY(serveTile.frame) + 60*Proportion + (SearchResultTopMargin*2 + SearchResultImageWidthAndHeight)*Proportion*i,
                                                                     WIDTH - SearchResultLeftMargin*Proportion*2,
                                                                     SearchResultImageWidthAndHeight*Proportion + SearchResultTopMargin*Proportion)];
        btnbgView.userInteractionEnabled = YES;
        btnbgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:btnbgView];
        
        UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                SearchResultImageWidthAndHeight*Proportion,
                                                                                SearchResultImageWidthAndHeight*Proportion)];
        serveImage.backgroundColor = [UIColor CMLPromptGrayColor];
        serveImage.contentMode = UIViewContentModeScaleAspectFill;
        serveImage.clipsToBounds = YES;
        [btnbgView addSubview:serveImage];
        [NetWorkTask setImageView:serveImage WithURL:obj.objCoverPic placeholderImage:nil];
        
        UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    66*Proportion,
                                                                    40*Proportion)];
        preTag.backgroundColor = [UIColor CMLBlackColor];
        preTag.textColor = [UIColor CMLBrownColor];
        preTag.font = KSystemFontSize11;
        preTag.text = @"预售";
        preTag.textAlignment = NSTextAlignmentCenter;
        [serveImage addSubview:preTag];
        
        CMLLine *spaceLine = [[CMLLine alloc] init];
        spaceLine.lineWidth = 1*Proportion;
        spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
        spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
        spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                              CGRectGetMaxY(serveImage.frame) + 30*Proportion);
        [btnbgView addSubview:spaceLine];
        
        UILabel *smallLabelOne = [[UILabel alloc] init];
        smallLabelOne.textColor = [UIColor CMLLightBrownColor];
        smallLabelOne.text = obj.subTypeName;
        smallLabelOne.font = KSystemFontSize10;
        smallLabelOne.textAlignment = NSTextAlignmentCenter;
        smallLabelOne.backgroundColor = [UIColor CMLWhiteColor];
        smallLabelOne.layer.cornerRadius = 4*Proportion;
        smallLabelOne.layer.borderWidth = 0.5;
        smallLabelOne.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [smallLabelOne sizeToFit];
        smallLabelOne.frame = CGRectMake(CGRectGetMaxX(serveImage.frame) + SearchResultLeftMargin*Proportion,
                                         serveImage.frame.origin.y,
                                         smallLabelOne.frame.size.width + 20*Proportion,
                                         30*Proportion);
        [btnbgView addSubview:smallLabelOne];
        
        UILabel *smallLabelTwo = [[UILabel alloc] init];
        smallLabelTwo.textColor = [UIColor CMLLightBrownColor];
        smallLabelTwo.text = obj.parentTypeName;
        smallLabelTwo.font = KSystemFontSize10;
        smallLabelTwo.textAlignment = NSTextAlignmentCenter;
        smallLabelTwo.backgroundColor = [UIColor whiteColor];
        smallLabelTwo.layer.cornerRadius = 4*Proportion;
        smallLabelTwo.layer.borderWidth = 0.5;
        smallLabelTwo.layer.borderColor = [UIColor CMLLightBrownColor].CGColor;
        [smallLabelTwo sizeToFit];
        smallLabelTwo.frame = CGRectMake(CGRectGetMaxX(smallLabelOne.frame) + 10*Proportion,
                                         serveImage.frame.origin.y,
                                         smallLabelTwo.frame.size.width + 20*Proportion,
                                         30*Proportion);
        [btnbgView addSubview:smallLabelTwo];

        
        UILabel *serveLabel =[[UILabel alloc] init];
        serveLabel.font = KSystemBoldFontSize15;
        serveLabel.text = obj.title;
        serveLabel.textColor = [UIColor CMLBlackColor];
        serveLabel.backgroundColor = [UIColor clearColor];
        [btnbgView addSubview:serveLabel];
        
        CGSize serveTitleSize = [obj.title sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize15}];
        
        
        
        if (serveTitleSize.width > (WIDTH - serveImage.frame.size.width - SearchResultLeftMargin*Proportion*3)) {
            
            serveLabel.numberOfLines = 2;
            serveLabel.frame = CGRectMake(CGRectGetMaxX(serveImage.frame) + SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(smallLabelOne.frame) + 10*Proportion,
                                          WIDTH - serveImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                          serveTitleSize.height*2);

        
            
        }else{
            
            serveLabel.numberOfLines = 1;
            serveLabel.frame = CGRectMake(CGRectGetMaxX(serveImage.frame) + SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(smallLabelOne.frame) + 10*Proportion,
                                          WIDTH - serveImage.frame.size.width - SearchResultLeftMargin*Proportion*3,
                                          serveTitleSize.height);
            
        }
        
        
        UILabel *totalAmountLabel = [[UILabel alloc] init];
        totalAmountLabel.font = KSystemBoldFontSize17;
        totalAmountLabel.textColor = [UIColor CMLBrownColor];
        totalAmountLabel.text = [NSString stringWithFormat:@"￥%@",obj.price];
        totalAmountLabel.backgroundColor = [UIColor whiteColor];
        [totalAmountLabel sizeToFit];
        totalAmountLabel.textAlignment = NSTextAlignmentLeft;
        totalAmountLabel.frame =CGRectMake(CGRectGetMaxX(serveImage.frame) + SearchResultLeftMargin*Proportion,
                                           CGRectGetMaxY(serveImage.frame) - totalAmountLabel.frame.size.height,
                                           totalAmountLabel.frame.size.width,
                                           totalAmountLabel.frame.size.height);
        [btnbgView addSubview:totalAmountLabel];
        
        
        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[obj.packageInfo.dataList firstObject]];
        
        if ([costObj.payMode intValue] == 1) {
            
            UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalAmountLabel.frame) + 10*Proportion,
                                                                         totalAmountLabel.center.y - 30*Proportion/2.0,
                                                                         50*Proportion,
                                                                         30*Proportion)];
            promLab.font = KSystemFontSize10;
            promLab.backgroundColor = [UIColor CMLBrownColor];
            promLab.textColor = [UIColor CMLWhiteColor];
            promLab.textAlignment = NSTextAlignmentCenter;
            promLab.text = @"订金";
            [btnbgView addSubview:promLab];
            
        }
        
        if ([costObj.is_pre intValue] == 1) {
            
            preTag.hidden = NO;
        }else{
            
            preTag.hidden = YES;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:btnbgView.bounds];
        button.tag = i;
        [button addTarget:self action:@selector(enterServeDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [btnbgView addSubview:button];
        
        if (i == (serveNum - 1)) {
            
            
            if (self.dataCount > 3) {
             
                UIButton *serveMoreBtn = [[UIButton alloc] init];
                [serveMoreBtn setTitle:@"查看更多相关商城服务" forState:UIControlStateNormal];
                [serveMoreBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                serveMoreBtn.titleLabel.font = KSystemFontSize12;
                [serveMoreBtn sizeToFit];
                serveMoreBtn.backgroundColor = [UIColor CMLBrownColor];
                serveMoreBtn.layer.cornerRadius = SearchResultMoreBtnHeight*Proportion/2.0;
                serveMoreBtn.frame = CGRectMake(WIDTH/2.0 - (serveMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2)/2.0,
                                                40*Proportion + CGRectGetMaxY(btnbgView.frame),
                                                serveMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2,
                                                SearchResultMoreBtnHeight*Proportion);
                [serveMoreBtn addTarget:self action:@selector(enterSearchListOfServe) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:serveMoreBtn];
                
                UIView *bottomViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetMaxY(serveMoreBtn.frame) + SearchResultMoreBtnBottomMargin*Proportion,
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

- (void) enterServeDetailVC:(UIButton *) button{
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.searchStr,@"searchStr", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:dict];
    
    
    SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[button.tag]];
    
    ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}


- (void) enterSearchListOfServe{
    
    CMLSearchListVC *vc = [[CMLSearchListVC alloc] initWithSearchStr:self.searchStr name:@"商城服务"];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
