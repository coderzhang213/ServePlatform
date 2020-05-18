//
//  CMLScrollSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/9/12.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "CMLScrollSelectView.h"
#import "BaseResultObj.h"
#import "NewMoreMesObj.h"
#import "RelateQualityObj.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"

@interface CMLScrollSelectView()

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSMutableArray *btnArray;

@end

@implementation CMLScrollSelectView

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWith:(BaseResultObj *)obj{
    
    self = [super init];
    
    if (self) {
       
        self.obj = obj;
        [self loadCurrentViews];
        
        
    }
    return self;
}

- (void) loadCurrentViews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH,
                                                              207*Proportion - 20*Proportion - NavigationBarHeight)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    bgView.tag = 1;
    [self addSubview:bgView];
    
    self.currentHeight = CGRectGetHeight(bgView.frame);
    NSArray *dataArray;
    
    if ([self.obj.retData.RelateQuality.goods.dataCount intValue] + [self.obj.retData.RelateQuality.project.dataCount intValue] + self.obj.retData.RelateRecomm.dataList.count == 0) {
        
        dataArray = @[@"商品",@"详情",@"价格"];
    }else{
        
        dataArray = @[@"商品",@"详情",@"价格",@"推荐"];
    }
    
    
    UIView *btnBgView = [[UIView alloc] init];
    btnBgView.tag = 1;
    [bgView addSubview:btnBgView];
    
    CGFloat currentX = 0;
    for (int i = 0; i < dataArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KSystemBoldFontSize15;
        [btn sizeToFit];
        btn.frame = CGRectMake(currentX,
                               0,
                               btn.frame.size.width,
                               bgView.frame.size.height);
        [btnBgView addSubview:btn];
        [btn addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
        
        currentX  = currentX + btn.frame.size.width + 80*Proportion;
        
        if (i == 0) {
            
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     51*Proportion,
                                                                     5*Proportion)];
            self.lineView.backgroundColor = [UIColor CMLBrownColor];
            self.lineView.center = CGPointMake(btn.center.x, bgView.frame.size.height - 9*Proportion - 5*Proportion/2.0);
            [btnBgView addSubview:self.lineView];
        }else if (i == dataArray.count - 1){
            
            btnBgView.frame = CGRectMake(WIDTH/2.0 - (currentX - 80*Proportion)/2.0,
                                         0,
                                         currentX - 80*Proportion,
                                         bgView.frame.size.height);
        }
        
    }
}

- (void) selectIndex: (UIButton *) btn{
    
    if (btn.center.x != self.lineView.center.x) {
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            
            weakSelf.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
        }];
        
        [self.delegate scrollTag:(int)btn.tag];
    }
    
    
}

- (void) refreshScrollSelectViewWith:(int) tag{
    
    if (tag < self.btnArray.count) {
      
      
        UIButton *btn =  self.btnArray[tag];
        self.lineView.center = CGPointMake(btn.center.x, self.lineView.center.y);
    }
}
@end
