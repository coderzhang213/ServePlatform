//
//  NewActivityTypeView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/7/28.
//  Copyright © 2017年 张越. All rights reserved.
//  票种信息View

#import "NewActivityTypeView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "PackageInfoObj.h"
#import "PackDetailInfoObj.h"

#define SelectBtnWidth       460
#define SelectBtnHeight      160
#define SelectBtnWhiteSpace  140
#define TwoBtnSpace          40


@interface NewActivityTypeView ()

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@end

@implementation NewActivityTypeView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
     
        self.backgroundColor = [UIColor clearColor];
        self.obj = obj;
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    
    CGFloat messageHeight = SelectBtnHeight*Proportion*[self.obj.retData.packageInfo.dataCount intValue] + ([self.obj.retData.packageInfo.dataCount intValue] + 1)*TwoBtnSpace*Proportion + 60*Proportion + 80*Proportion;
    
    
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.mainScrollView];
    
    if (messageHeight > HEIGHT) {
        
        self.mainScrollView.frame = CGRectMake(0,
                                               0,
                                               WIDTH,
                                               HEIGHT);
        self.mainScrollView.contentSize = CGSizeMake(WIDTH, messageHeight);
        
    }else{
    
        self.mainScrollView.frame = CGRectMake(0,
                                               HEIGHT/2.0 - messageHeight/2.0,
                                               WIDTH,
                                               messageHeight);
        self.mainScrollView.scrollEnabled = NO;
    }
    
    
    for (int i = 0 ; i < [self.obj.retData.packageInfo.dataCount intValue]; i++) {
        
        PackDetailInfoObj *detailObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[[self.obj.retData.packageInfo.dataCount intValue] - 1 - i]];
        
        UIView *moduleBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - SelectBtnWidth*Proportion/2.0,
                                                                        TwoBtnSpace*Proportion*(i+1) + SelectBtnHeight*Proportion*i,
                                                                        SelectBtnWidth*Proportion,
                                                                        SelectBtnHeight*Proportion)];
        
        /*是否有库存*/
        if ([detailObj.surplusStock intValue] == 0) {
            moduleBgView.backgroundColor = [UIColor lightGrayColor];
            moduleBgView.userInteractionEnabled = NO;
        }else {
            /*是否免费*/
            if ([detailObj.totalAmount intValue] == 0) {
                
                /*是否购买*/
                if ([detailObj.isBuy intValue] == 1) {
                    moduleBgView.backgroundColor = [UIColor lightGrayColor];
                    moduleBgView.userInteractionEnabled = NO;
                }else {
                    moduleBgView.backgroundColor = [UIColor CMLBrownColor];
                    moduleBgView.userInteractionEnabled = YES;
                }
                
            }else{
                
                moduleBgView.backgroundColor = [UIColor CMLGreeenColor];
                moduleBgView.userInteractionEnabled = YES;
            }
            
        }
        
        [self.mainScrollView addSubview:moduleBgView];
        
        UIImageView *expenseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SelectTypeWhiteImg]];
        expenseImage.frame = CGRectMake(SelectBtnWidth*Proportion - SelectBtnWhiteSpace*Proportion,
                                        0,
                                        SelectBtnWhiteSpace*Proportion,
                                        SelectBtnHeight*Proportion);
        expenseImage.clipsToBounds = YES;
        expenseImage.contentMode = UIViewContentModeScaleAspectFill;
        expenseImage.userInteractionEnabled = YES;
        [moduleBgView addSubview:expenseImage];
        
        UILabel *freeLab1 = [[UILabel alloc] init];
        freeLab1.font = KSystemFontSize12;
        freeLab1.textColor = [UIColor CMLBlackColor];
        freeLab1.text = detailObj.packageName;
        freeLab1.textAlignment = NSTextAlignmentCenter;
        [freeLab1 sizeToFit];
        freeLab1.frame = CGRectMake(0,
                                    expenseImage.frame.size.height/2.0 - freeLab1.frame.size.height/2.0,
                                    expenseImage.frame.size.width,
                                    freeLab1.frame.size.height);
        [expenseImage addSubview:freeLab1];
        
        UILabel *expensePromLab = [[UILabel alloc] init];
        if ([detailObj.totalAmount intValue] > 0) {
            
           expensePromLab.text = [NSString stringWithFormat:@"付费%@元／人",detailObj.totalAmount];
        }else{
           expensePromLab.text = @"免费名额优先抢";
        }
        
        expensePromLab.font = KSystemBoldFontSize14;
        expensePromLab.textColor = [UIColor CMLWhiteColor];
        [expensePromLab sizeToFit];
        expensePromLab.frame = CGRectMake((SelectBtnWidth - SelectBtnWhiteSpace)*Proportion/2.0 - expensePromLab.frame.size.width/2.0,
                                          SelectBtnHeight*Proportion/2.0 - 20*Proportion/2.0 - expensePromLab.frame.size.height,
                                          expensePromLab.frame.size.width,
                                          expensePromLab.frame.size.height);
        [moduleBgView addSubview:expensePromLab];
        
        UILabel *expenseSurplusNumLab = [[UILabel alloc] init];
        expenseSurplusNumLab.font = KSystemFontSize12;
        expenseSurplusNumLab.textColor = [UIColor CMLWhiteColor];
        expenseSurplusNumLab.text = [NSString stringWithFormat:@"仅剩%@个席位",detailObj.surplusStock];
        [expenseSurplusNumLab sizeToFit];
        expenseSurplusNumLab.frame = CGRectMake(expensePromLab.center.x - expenseSurplusNumLab.frame.size.width/2.0,
                                                CGRectGetMaxY(expensePromLab.frame) + 20*Proportion,
                                                expenseSurplusNumLab.frame.size.width,
                                                expenseSurplusNumLab.frame.size.height);
        [moduleBgView addSubview:expenseSurplusNumLab];
        
        UIButton *scheduleBtn = [[UIButton alloc] initWithFrame:moduleBgView.bounds];
        scheduleBtn.backgroundColor = [UIColor clearColor];
        scheduleBtn.tag = [self.obj.retData.packageInfo.dataCount intValue] - 1 - i;
        [moduleBgView addSubview:scheduleBtn];
        [scheduleBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([detailObj.surplusStock intValue] == 0) {
            
            scheduleBtn.userInteractionEnabled = NO;
        }
        
        if (i == [self.obj.retData.packageInfo.dataCount intValue] - 1) {
            
            self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 60*Proportion/2.0,
                                                                        CGRectGetMaxY(moduleBgView.frame) + 80*Proportion,
                                                                        60*Proportion,
                                                                        60*Proportion)];
            self.cancelBtn.backgroundColor = [UIColor clearColor];
            [self.cancelBtn setBackgroundImage:[UIImage imageNamed:AlterViewCloseBtnImg] forState:UIControlStateNormal];
            [self.mainScrollView addSubview:self.cancelBtn];
            [self.cancelBtn addTarget:self action:@selector(cancelSeletMessage) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
}

- (void) cancelSeletMessage{

    [self.delegate cancelSelectActivity];
    [self removeFromSuperview];
}

- (void)selectBtn:(UIButton *) btn{

    [self.delegate selectedActivityType:(int)btn.tag];
}
@end
