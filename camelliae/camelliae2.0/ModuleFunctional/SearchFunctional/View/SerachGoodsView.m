//
//  SerachGoodsView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/1.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SerachGoodsView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "VCManger.h"
#import "CMLSearchVC.h"
#import "SearchResultObj.h"
#import "CMLSearchListVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLSearchGoodsVC.h"

#define SearchResultLeftMargin        30
#define SearchResultTopMargin         40
#define SearchResultTitleAndLineSpace 10
#define SearchResultBtnHeight         100
#define SearchResultMoreBtnTopMargin  60
#define SearchResultMoreBtnBottomMargin 50
#define SearchResultMoreBtnHeight     48
#define SearchResultImageWidthAndHeight 330

@interface SerachGoodsView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *searchStr;

@end

@implementation SerachGoodsView
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
    serveTile.text = @"相关商品";
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
    
    int goodsNum = 0;
    if (self.dataArray.count > 4) {
        goodsNum = 4;
    }else{
        goodsNum = (int)self.dataArray.count;
    }
    
    UILabel *testLab = [[UILabel alloc] init];
    testLab.font = KSystemFontSize14;
    testLab.text = @"初始化";
    [testLab sizeToFit];
    

    
    for (int i = 0; i < goodsNum; i++) {
        
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[i]];
        
        UIView *btnbgView = [[UIView alloc] init];
        btnbgView.userInteractionEnabled = YES;
        btnbgView.backgroundColor = [UIColor whiteColor];
        btnbgView.layer.masksToBounds = YES;
        [self addSubview:btnbgView];
        
        
        UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                SearchResultImageWidthAndHeight*Proportion,
                                                                                SearchResultImageWidthAndHeight*Proportion)];
        serveImage.backgroundColor = [UIColor CMLPromptGrayColor];
        serveImage.contentMode = UIViewContentModeScaleAspectFill;
        serveImage.clipsToBounds = YES;
        serveImage.layer.borderWidth = 1*Proportion;
        serveImage.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
        [btnbgView addSubview:serveImage];
        [NetWorkTask setImageView:serveImage WithURL:obj.coverPic placeholderImage:nil];
        
        UILabel *preTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66*Proportion, 40*Proportion)];
        preTag.backgroundColor = [UIColor CMLBlackColor];
        preTag.textColor = [UIColor CMLBrownColor];
        preTag.font = KSystemFontSize11;
        preTag.text = @"预售";
        preTag.textAlignment = NSTextAlignmentCenter;
        [serveImage addSubview:preTag];
        
        if ([obj.is_pre intValue] == 1) {
            
            preTag.hidden = NO;
        }else{
            
            preTag.hidden = YES;
        }
        
        UILabel *tagLab = [[UILabel alloc] init];
        tagLab.font = KSystemFontSize11;
        tagLab.textColor = [UIColor CMLLineGrayColor];
        tagLab.layer.cornerRadius = 4*Proportion;
        tagLab.layer.borderWidth = 1*Proportion;
        tagLab.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
        tagLab.text = [NSString stringWithFormat:@"%@",obj.brandName];
        tagLab.textAlignment = NSTextAlignmentCenter;
        [tagLab sizeToFit];
        tagLab.frame = CGRectMake(0,
                                  CGRectGetMaxY(serveImage.frame) + 10*Proportion,
                                  tagLab.frame.size.width + 10*Proportion,
                                  34*Proportion);
        [btnbgView addSubview:tagLab];

        
        UILabel *goodsLabel =[[UILabel alloc] init];
        goodsLabel.font = KSystemBoldFontSize14;
        goodsLabel.text = obj.title;
        goodsLabel.textColor = [UIColor CMLBlackColor];
        goodsLabel.backgroundColor = [UIColor whiteColor];
        goodsLabel.numberOfLines = 1;
        [goodsLabel sizeToFit];
        goodsLabel.frame = CGRectMake(0,
                                      CGRectGetMaxY(tagLab.frame) + 10*Proportion,
                                      SearchResultImageWidthAndHeight*Proportion,
                                      testLab.frame.size.height*2);
        [btnbgView addSubview:goodsLabel];
        
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.font = KSystemBoldFontSize14;
        if ([obj.is_deposit intValue] == 1) {
            
            priceLab.text = [NSString stringWithFormat:@"￥%@",obj.deposit_money];
        }else{
            
           priceLab.text = [NSString stringWithFormat:@"￥%@",obj.totalAmountMin];
        }
        
        priceLab.textColor = [UIColor CMLBrownColor];
        priceLab.backgroundColor = [UIColor whiteColor];
        priceLab.numberOfLines = 2;
        [priceLab sizeToFit];
        priceLab.frame = CGRectMake(0,
                                    CGRectGetMaxY(goodsLabel.frame) + 30*Proportion,
                                    priceLab.frame.size.width,
                                    priceLab.frame.size.height);
        [btnbgView addSubview:priceLab];
        
        
        if ([obj.is_deposit intValue] == 1) {
            
            UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLab.frame) + 10*Proportion,
                                                                         priceLab.center.y - 30*Proportion/2.0,
                                                                         50*Proportion,
                                                                         30*Proportion)];
            promLab.font = KSystemFontSize10;
            promLab.backgroundColor = [UIColor CMLBrownColor];
            promLab.textColor = [UIColor CMLWhiteColor];
            promLab.textAlignment = NSTextAlignmentCenter;
            promLab.text = @"订金";
            [btnbgView addSubview:promLab];
        }

        
        
        CGFloat height = CGRectGetMaxY(priceLab.frame) + 5*Proportion;
        
            
        btnbgView.frame = CGRectMake(30*Proportion + (SearchResultImageWidthAndHeight + 30)*Proportion*(i%2),
                                     CGRectGetMaxY(serveTile.frame) + 60*Proportion + (height + 50*Proportion)*(i/2),
                                     SearchResultImageWidthAndHeight*Proportion,
                                     height);

        

        UIButton *button = [[UIButton alloc] initWithFrame:btnbgView.bounds];
        button.tag = i;
        [button addTarget:self action:@selector(enterServeDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [btnbgView addSubview:button];
        
        if (i == (goodsNum - 1)) {
            
            
            if (self.dataCount > 4) {
                
                UIButton *serveMoreBtn = [[UIButton alloc] init];
                [serveMoreBtn setTitle:@"查看更多相关商品" forState:UIControlStateNormal];
                [serveMoreBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
                serveMoreBtn.titleLabel.font = KSystemFontSize12;
                [serveMoreBtn sizeToFit];
                serveMoreBtn.backgroundColor = [UIColor CMLBrownColor];
                serveMoreBtn.layer.cornerRadius = SearchResultMoreBtnHeight*Proportion/2.0;
                serveMoreBtn.frame = CGRectMake(WIDTH/2.0 - (serveMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2)/2.0,
                                                40*Proportion + CGRectGetMaxY(btnbgView.frame),
                                                (serveMoreBtn.frame.size.width + SearchResultMoreBtnHeight*Proportion*2),
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
    
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}


- (void) enterSearchListOfServe{
    
    CMLSearchGoodsVC *vc = [[CMLSearchGoodsVC alloc] initWithSearchStr:self.searchStr];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
