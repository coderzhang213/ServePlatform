
//
//  CMLCityMesHeaderView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/10/11.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLCityMesHeaderView.h"
#import "CommonImg.h"
#import "NetWorkTask.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "WebViewLinkVC.h"
#import "ActivityDefaultVC.h"
#import "CMLUserArticleVC.h"
#import "VCManger.h"
#import "ActivityTypeObj.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"

@interface CMLCityMesHeaderView ()

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) BaseResultObj *secondTypeObj;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) UIScrollView *typeScrollView;

@property (nonatomic,strong) NSMutableArray *secondBtnArray;

@property (nonatomic,assign) CGFloat height1;

@property (nonatomic,assign) CGFloat height2;
@end

@implementation CMLCityMesHeaderView

- (NSMutableArray *)secondBtnArray{
    
    if (!_secondBtnArray) {
        _secondBtnArray = [NSMutableArray array];
    }
    
    return _secondBtnArray;
}

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (instancetype)initWith:(BaseResultObj *) obj andSecondTypeObj:(BaseResultObj *) secondTypeObj{
    
    
    self = [super init];
    
    if (self) {
        
        self.obj = obj;
        self.secondTypeObj = secondTypeObj;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    self.secondSelectIndex = 0;
    
    UIImageView *cityImg = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                         WIDTH/16*9/2.0 - (WIDTH - 30*Proportion*2)/16*9/2.0 + 20*Proportion,
                                                                         (WIDTH - 30*Proportion*2),
                                                                         (WIDTH - 30*Proportion*2)/16*9)];
    cityImg.contentMode = UIViewContentModeScaleAspectFill;
    cityImg.backgroundColor = [UIColor CMLNewUserGrayColor];
    cityImg.userInteractionEnabled = YES;
    cityImg.layer.cornerRadius = 8*Proportion;
    cityImg.clipsToBounds = YES;
    [self addSubview:cityImg];
    [NetWorkTask setImageView:cityImg WithURL:self.obj.retData.coverPic placeholderImage:nil];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:cityImg.frame];
    btn.backgroundColor = [UIColor clearColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(enterVC) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(cityImg.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
    [self addSubview:bottomView];
    
    self.typeScrollView = [[UIScrollView alloc] init];
    [self addSubview:self.typeScrollView];
    
    
    if ([self.obj.retData.isAllExist intValue] == 1) {
        
        self.selectIndex = 0;
        
        UIButton *articleBtn = [[UIButton alloc] initWithFrame:CGRectMake(40*Proportion + (WIDTH - 40*Proportion)/4.0,
                                                                          CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                                                          (WIDTH - 40*Proportion*2)/4.0,
                                                                          50*Proportion)];
        [articleBtn setTitle:@"资讯" forState:UIControlStateNormal];
        articleBtn.titleLabel.font = KSystemBoldFontSize17;
        articleBtn.backgroundColor = [UIColor CMLWhiteColor];
        [articleBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [articleBtn setTitleColor:[UIColor CMLNewYellowColor] forState:UIControlStateSelected];
        articleBtn.tag = 1;
        [self addSubview:articleBtn];
        [articleBtn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
         [self.btnArray addObject:articleBtn];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(articleBtn.center.x - 47*Proportion/2.0,
                                                                 CGRectGetMaxY(articleBtn.frame),
                                                                 47*Proportion,
                                                                 4*Proportion)];
        self.lineView.backgroundColor = [UIColor CMLNewYellowColor];
        [self addSubview:self.lineView];
        
        UIButton *activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(articleBtn.frame),
                                                                          CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                                                          (WIDTH - 40*Proportion*2)/4.0,
                                                                          50*Proportion)];
        [activityBtn setTitle:@"活动" forState:UIControlStateNormal];
        activityBtn.titleLabel.font = KSystemFontSize17;
        activityBtn.backgroundColor = [UIColor CMLWhiteColor];
        activityBtn.tag = 2;
        [activityBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        [activityBtn setTitleColor:[UIColor CMLNewYellowColor] forState:UIControlStateSelected];
        [self addSubview:activityBtn];
        [activityBtn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArray addObject:activityBtn];
        
        self.typeScrollView.hidden = YES;
        
        
        self.currentHeight = CGRectGetMaxY(activityBtn.frame);
        
        self.height1 = self.currentHeight;
        
        
        
        if (self.secondTypeObj.retData.dataList.count > 0) {
            self.height2 = self.height1 + 100*Proportion;
        
        }
        
    }else{
        
        if ([self.obj.retData.isOnlyArticle intValue] == 1) {
            
            self.selectIndex = 0;
            
            UILabel *articleLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2.0 - WIDTH/4.0,
                                                                              CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                                                              WIDTH/4.0,
                                                                              50*Proportion)];
            articleLab.text =@"资讯";
            articleLab.font = KSystemBoldFontSize17;
            articleLab.textColor = [UIColor CMLNewYellowColor];
            articleLab.backgroundColor = [UIColor CMLWhiteColor];
            articleLab.frame = CGRectMake(WIDTH/2.0 - (WIDTH/4.0)/2.0,
                                          CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                          WIDTH/4.0,
                                          50*Proportion);
            articleLab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:articleLab];
            
            self.typeScrollView.hidden = YES;
            
            self.currentHeight = CGRectGetMaxY(articleLab.frame);
            
            
        }else{
            
            self.selectIndex = 1;
            UILabel *activityLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2.0 - WIDTH/4.0,
                                                                            CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                                                            WIDTH/4.0,
                                                                            50*Proportion)];
            activityLab.text = @"活动";
            activityLab.textColor = [UIColor CMLNewYellowColor];
            activityLab.font = KSystemBoldFontSize17;
            activityLab.backgroundColor = [UIColor CMLWhiteColor];
            activityLab.frame = CGRectMake(WIDTH/2.0 - (WIDTH/4.0)/2.0,
                                          CGRectGetMaxY(bottomView.frame) + 20*Proportion,
                                          WIDTH/4.0,
                                          50*Proportion);
            activityLab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:activityLab];
            
            if ([self.obj.retData.currentID intValue] == 9) {
             
                self.currentHeight = CGRectGetMaxY(activityLab.frame) + 40*Proportion;
                
            }else{
                
                self.currentHeight = CGRectGetMaxY(activityLab.frame);
            }
            
            self.height1 = self.currentHeight;
            self.height2 = self.height1;
            
            if (self.secondTypeObj.retData.dataList.count > 0) {

                self.currentHeight = CGRectGetMaxY(activityLab.frame) + 100*Proportion;
                
                self.height2 = self.currentHeight;
                
            
            }
        }
        
    }
    
}

- (void) loadScrollTypeBtnWithTopY:(CGFloat) y{
    
    self.typeScrollView.hidden = NO;
    CGFloat spaceWidth = WIDTH/7.0;
    

    self.typeScrollView.frame = CGRectMake(0, y, WIDTH, 60*Proportion);
    
    if (self.typeScrollView) {
        
        for (int i = 0; i < self.secondTypeObj.retData.dataList.count; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth*i,
                                                                       0,
                                                                       spaceWidth,
                                                                       60*Proportion)];
            btn.backgroundColor = [UIColor clearColor];
            btn.titleLabel.font = KSystemFontSize15;
            ActivityTypeObj *obj = [ActivityTypeObj getBaseObjFrom:self.secondTypeObj.retData.dataList[i]];
            [btn setTitle:obj.typeName forState:UIControlStateNormal];
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            [btn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
            btn.tag = i;
            [btn addTarget:self action:@selector(selectSecondType:) forControlEvents:UIControlEventTouchUpInside];
            [self.typeScrollView addSubview:btn];
            [self.secondBtnArray addObject:btn];
            
            if (i == self.secondSelectIndex ) {
                btn.selected = YES;
                btn.titleLabel.font = KSystemRealBoldFontSize15;
            }else{
                btn.titleLabel.font = KSystemFontSize15;
            }
            
            if (i == self.secondTypeObj.retData.dataList.count - 1) {
                
                self.typeScrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), self.typeScrollView.frame.size.height);
            }
        }
    }
}

- (void) enterVC {
    
    if ([self.obj.retData.dataType intValue] == 3) {
        
            WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
            vc.url = self.obj.retData.viewLink;
            vc.name = self.obj.retData.title;

            [[VCManger mainVC] pushVC:vc animate:YES];
    }else if([self.obj.retData.dataType intValue] == 1) {
        
        if ([self.obj.retData.isUserPublish intValue] == 1) {
            
            if ([self.obj.retData.objType intValue] == 2) {
                
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:self.obj.retData.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else if ([self.obj.retData.objType intValue] == 3){
                
                CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:self.obj.retData.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }else{
                
                CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:self.obj.retData.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }

            
        }else{
            
            if ([self.obj.retData.objType intValue] == 2) {
                
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:self.obj.retData.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }else{
                
                CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:self.obj.retData.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
            
        }

    }else{
        
  
    }
}

- (void) selectType:(UIButton *) btn{
    
    
    if ((self.selectIndex + 1) != (int)btn.tag) {
        
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
        }];
        
        if (btn.tag == 1) {
            
            self.selectIndex = 0;
            
            [self.delegate selectIndex:0 andSecondIndex:0 andSecondTypeID:[NSNumber numberWithInt:0]];
            
            UIButton *tempBtn = self.btnArray[1];
            tempBtn.titleLabel.font = KSystemFontSize17;
            btn.titleLabel.font  = KSystemBoldFontSize17;
            btn.selected = YES;
            tempBtn.selected = NO;
            
            
        }else{
            
            self.selectIndex = 1;
            ActivityTypeObj *obj = [ActivityTypeObj getBaseObjFrom:self.secondTypeObj.retData.dataList[0]];
            [self.delegate selectIndex:1 andSecondIndex:0 andSecondTypeID:obj.typeId];
            
            
            UIButton *tempBtn = self.btnArray[0];
            tempBtn.titleLabel.font = KSystemFontSize17;
            btn.titleLabel.font  = KSystemBoldFontSize17;
            btn.selected = YES;
            tempBtn.selected = NO;
        }
        
        
    }else{
        
        
    }
}


- (void) selectSecondType: (UIButton *) btn{
    
    
    for (int i = 0; i < self.secondBtnArray.count; i++) {
        
        UIButton *tempBtn = self.secondBtnArray[i];
        if (btn.tag == i) {
            
            self.secondSelectIndex = i;
            tempBtn.titleLabel.font = KSystemFontSize15;
            ActivityTypeObj *obj = [ActivityTypeObj getBaseObjFrom:self.secondTypeObj.retData.dataList[self.secondSelectIndex]];
            [self.delegate selectIndex:1 andSecondIndex:i andSecondTypeID:obj.typeId];
            
        }else{
            
            tempBtn.titleLabel.font = KSystemRealBoldFontSize15;
        }
    }
}

- (void) refrshCurrentViewWithIndex:(int) index andSecondIndex:(int) secondIndex{
    
    self.selectIndex  = index;
    
    UIButton *currentBtn = (UIButton *)[self viewWithTag:index + 1];
    currentBtn.selected = YES;
    
    self.lineView.center = CGPointMake(currentBtn.center.x, self.lineView.center.y);
    
    self.secondSelectIndex = secondIndex;

    
    if (self.selectIndex == 1 && self.secondTypeObj.retData.dataList.count > 0) {
    
        self.currentHeight = self.height2;

        [self loadScrollTypeBtnWithTopY:self.height2 - 60*Proportion - 20*Proportion];

        
        for (int i = 0; i < self.secondBtnArray.count; i++) {
            
            UIButton *tempBtn = self.secondBtnArray[i];
            if (self.secondSelectIndex == i) {
                tempBtn.selected = YES;
                tempBtn.titleLabel.font = KSystemRealBoldFontSize15;
            }else{
                tempBtn.selected = NO;
                tempBtn.titleLabel.font = KSystemFontSize15;
            }
        }
    }
}
@end
