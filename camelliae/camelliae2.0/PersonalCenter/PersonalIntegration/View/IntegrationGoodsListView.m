//
//  IntegrationGoodsListView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/16.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "IntegrationGoodsListView.h"
#import "CMLLine.h"
#import "CommonImg.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLIntegrationGiftObj.h"
#import "BaseResultObj.h"
#import "VCManger.h"
#import "CMLIntegrationGiftListVC.h"
#import "CMLGiftVC.h"

#define GoodsImageWIdthAndHeight   240

@interface IntegrationGoodsListView ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentName;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation IntegrationGoodsListView


-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (instancetype)initWith:(BaseResultObj *) obj andName:(NSString *) name{
    
    self = [super init];
    
    if (self) {

        self.obj = obj;
        self.currentName = name;
        [self loadViews];
        
    }
    
    return self;
}

- (void) loadViews{

   
    CMLLine *leftLine = [[CMLLine alloc] init];
    leftLine.startingPoint = CGPointMake(30*Proportion, 30*Proportion);
    leftLine.lineLength = 28*Proportion;
    leftLine.directionOfLine = VerticalLine;
    leftLine.lineWidth = 6*Proportion;
    leftLine.LineColor = [UIColor CMLGreeenColor];
    [self addSubview:leftLine];
    
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.text = self.currentName;
    promLab.font = KSystemFontSize14;
    promLab.textColor = [UIColor CMLBlackColor];
    [promLab sizeToFit];
    promLab.frame = CGRectMake(30*Proportion + 10*Proportion + 6*Proportion,
                               30*Proportion + 28*Proportion/2.0 - promLab.frame.size.height/2.0,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self addSubview:promLab];
    
    NSArray *testArray = self.obj.retData.dataList;
    
    [self.dataArray addObjectsFromArray:testArray];
    
    
    if (self.dataArray.count == 0) {
        
        self.hidden = YES;
        self.currentHeight = 0;
    }

    if (self.dataArray.count > 8) {
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"查看更多好礼" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:PrefectureMoreMessageImg] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = KSystemFontSize12;
    button.backgroundColor = [UIColor clearColor];
    [button sizeToFit];
    CGSize strSize = [button.currentTitle sizeWithFontCompatible:KSystemFontSize12];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                - button.currentImage.size.width - 10*Proportion,
                                                0,
                                                0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                strSize.width + button.currentImage.size.width + 10*Proportion,
                                                0,
                                                0)];
    button.frame = CGRectMake(WIDTH - 30*Proportion - button.frame.size.width - 20*Proportion*2,
                             promLab.center.y - button.frame.size.height/2.0,
                             button.frame.size.width + 20*Proportion*2,
                             button.frame.size.height);
    [self addSubview:button];

        
    
    [button addTarget:self action:@selector(enterGiftList) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
    int num;
    
    if (self.dataArray.count > 8) {
        
        num = 8;
        
    }else{
    
        num = (int)self.dataArray.count;
    }
    

    for (int i = 0; i < num; i++) {
        
        CMLIntegrationGiftObj *obj = [CMLIntegrationGiftObj getBaseObjFrom:self.dataArray[i]];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0*(i%2),
                                                                  0,
                                                                  WIDTH/2.0,
                                                                  0)];
        bgView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:bgView];
        
        UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2.0 - GoodsImageWIdthAndHeight*Proportion/2.0,
                                                                              0,
                                                                              GoodsImageWIdthAndHeight*Proportion,
                                                                              GoodsImageWIdthAndHeight*Proportion)];
        goodsImg.backgroundColor = [UIColor CMLNewGrayColor];
        goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        goodsImg.clipsToBounds = YES;
        [bgView addSubview:goodsImg];
        [NetWorkTask setImageView:goodsImg WithURL:obj.coverPicThumb placeholderImage:nil];
        
        UILabel *goodsNameLab = [[UILabel alloc] init];
        goodsNameLab.font = KSystemFontSize14;
        goodsNameLab.textColor = [UIColor CMLBlackColor];
        goodsNameLab.text = obj.title;
        goodsNameLab.textAlignment = NSTextAlignmentCenter;
        [goodsNameLab sizeToFit];
        goodsNameLab.frame = CGRectMake(20*Proportion,
                                        CGRectGetMaxY(goodsImg.frame) + 20*Proportion,
                                        WIDTH/2.0 - 20*Proportion*2,
                                        goodsNameLab.frame.size.height);
        [bgView addSubview:goodsNameLab];
        
        UILabel *goodsPriceLab = [[UILabel alloc] init];
        goodsPriceLab.font = KSystemFontSize13;
        goodsPriceLab.textColor = [UIColor CMLBlackColor];
        goodsPriceLab.text = obj.marketPriceStr;
        goodsPriceLab.textAlignment = NSTextAlignmentCenter;
        [goodsPriceLab sizeToFit];
        goodsPriceLab.frame = CGRectMake(20*Proportion,
                                         CGRectGetMaxY(goodsNameLab.frame) + 52*Proportion,
                                         WIDTH/2.0 - 20*Proportion*2,
                                         goodsPriceLab.frame.size.height);
        [bgView addSubview:goodsPriceLab];
        
        UIButton *goodsPointsBtn = [[UIButton alloc] init];
        goodsPointsBtn.layer.borderWidth = 1;
        goodsPointsBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        goodsPointsBtn.titleLabel.font = KSystemFontSize16;
        [goodsPointsBtn setTitle:[NSString stringWithFormat:@"%@",obj.point] forState:UIControlStateNormal];
        [goodsPointsBtn setImage:[UIImage imageNamed:IntegrationIconImg] forState:UIControlStateNormal];
        [goodsPointsBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        goodsPointsBtn.frame = CGRectMake(bgView.frame.size.width/2.0 - 240*Proportion/2.0,
                                          CGRectGetMaxY(goodsPriceLab.frame) + 30*Proportion,
                                          240*Proportion,
                                          60*Proportion);
        [goodsPointsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                            10*Proportion,
                                                            0,
                                                            0)];
        [goodsPointsBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                            -10*Proportion,
                                                            0,
                                                            0)];

        [bgView addSubview:goodsPointsBtn];
        
        
//        if (i < 2) {
        
            bgView.frame = CGRectMake(WIDTH/2.0*(i%2),
                                      CGRectGetMaxY(promLab.frame) + 30*Proportion + (100*Proportion + CGRectGetMaxY(goodsPointsBtn.frame)) *(i/2),
                                      WIDTH/2.0,
                                      CGRectGetMaxY(goodsPointsBtn.frame));
//        }else{
//        
//            bgView.frame = CGRectMake(WIDTH/2.0*(i%2),
//                                      CGRectGetMaxY(promLab.frame) + 30*Proportion +  CGRectGetMaxY(goodsPointsBtn.frame) + 100*Proportion,
//                                      WIDTH/2.0,
//                                      CGRectGetMaxY(goodsPointsBtn.frame));
//        }
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:bgView.bounds];
        buyBtn.backgroundColor = [UIColor clearColor];
        [bgView addSubview:buyBtn];
        buyBtn.tag = i + 1;
        [buyBtn addTarget:self action:@selector(enterGiftVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i%2 == 0) {
            
            CMLLine *spaceline = [[CMLLine alloc] init];
            spaceline.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(bgView.frame) + 50*Proportion);
            spaceline.lineWidth = 1*Proportion;
            spaceline.lineLength = WIDTH - 30*Proportion*2;
            spaceline.LineColor = [UIColor CMLNewGrayColor];
            [self addSubview:spaceline];
        }
        
        if (i == num - 1) {
            
            self.currentHeight = CGRectGetMaxY(bgView.frame) + 51*Proportion;
        }
        
    }
    
}

- (void) enterGiftList{

    CMLIntegrationGiftListVC *vc = [[CMLIntegrationGiftListVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterGiftVC:(UIButton *) btn{

    CMLIntegrationGiftObj *obj = [CMLIntegrationGiftObj getBaseObjFrom:self.dataArray[btn.tag - 1]];
    CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:obj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
