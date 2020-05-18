//
//  CMLSelectScrollView.m
//  transitionOfViewController
//
//  Created by 张越 on 2016/10/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSelectScrollView.h"
#import "CommonNumber.h"
#import "CommonFont.h"

@interface CMLSelectScrollView ()

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,assign) CGFloat lineWidth;

@end

@implementation CMLSelectScrollView

- (instancetype)initWithFrame:(CGRect)frame{


    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void) loadViews{

    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.frame.size.width,
                                                                       self.frame.size.height)];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
//    self.bgScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self addSubview:self.bgScrollView];
    
}

- (void) loadSelectViewAndData{

    [self.bgScrollView removeFromSuperview];
    
    [self loadViews];
    
    CGFloat length = 0;
    
    /**累加字体控件长度*/
    for (NSString *str in self.itemNamesArray) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = self.itemNameSize;
        label.text = str;
        [label sizeToFit];
        length += label.frame.size.width;
    }
    
    
    CGFloat currentLeftMargin = self.leftAndRightMargin;
    for (int i = 0 ; i < self.itemNamesArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.itemNamesArray[i] forState:UIControlStateNormal];
        
        if (i == 0 ) {
            
            button.titleLabel.font = KSystemRealBoldFontSize15;
        }else{
            
            button.titleLabel.font = KSystemFontSize15;
        }
//        button.titleLabel.font = self.itemNameSize;
        [button sizeToFit];
        self.lineWidth = button.frame.size.width;
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        button.tag = i + 1;
        button.frame = CGRectMake(currentLeftMargin,
                                  0,
                                  button.frame.size.width,
                                  self.bgScrollView.frame.size.height);
      
        currentLeftMargin += (button.frame.size.width + self.itemsSpace);
        [self.bgScrollView addSubview:button];
        [button addTarget:self action:@selector(changeSelectName:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0 ) {
            
            button.selected = YES;
            self.lineView = [[UIView alloc] init];
            self.lineView.layer.cornerRadius = 2/2.0;
            self.lineView.backgroundColor = self.selectColor;
            [self.bgScrollView addSubview:self.lineView];
            self.lineView.frame = CGRectMake(button.center.x - 40*Proportion/2.0,
                                             self.bgScrollView.frame.size.height - 2,
                                             40*Proportion,
                                             2);
        }
        
        
        if (i == (self.itemNamesArray.count - 1)) {
            self.bgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + self.leftAndRightMargin , self.frame.size.height - 2 );
        }
    }

}

- (void) loadNewStyleSelectView{
    
    [self.bgScrollView removeFromSuperview];
    
    [self loadViews];
    
    for (int i = 0 ; i < self.itemNamesArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.itemNamesArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = self.itemNameSize;
        [button sizeToFit];
        self.lineWidth = button.frame.size.width;
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        button.tag = i + 1;
        button.frame = CGRectMake(self.frame.size.width/self.itemNamesArray.count*i,
                                  0,
                                  self.frame.size.width/self.itemNamesArray.count,
                                  self.bgScrollView.frame.size.height);
        

        [self.bgScrollView addSubview:button];
        [button addTarget:self action:@selector(changeSelectName:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0 ) {
            
            button.selected = YES;
            self.lineView = [[UIView alloc] init];
            self.lineView.backgroundColor = self.selectColor;
            [self.bgScrollView addSubview:self.lineView];
            self.lineView.frame = CGRectMake(button.center.x - 40*Proportion/2.0,
                                             self.bgScrollView.frame.size.height - 2,
                                             40*Proportion,
                                             2);
        }
        
        
        if (i == (self.itemNamesArray.count - 1)) {
            self.bgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + self.leftAndRightMargin , self.frame.size.height - 2 );
        }
    }
}

- (void) changeSelectName:(UIButton *) button{

    button.selected = YES;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{


        weakSelf.lineView.frame = CGRectMake(button.center.x - 40*Proportion/2.0,
                                             self.bgScrollView.frame.size.height - 2,
                                             40*Proportion,
                                             2);
        
    }];

    [self.delgate selectItemName:self.itemNamesArray[button.tag - 1] index:(int)button.tag - 1];
    for (int i = 0 ; i < self.itemNamesArray.count; i++) {
        
        if ((i+1) != button.tag) {
            UIButton *button = [self.bgScrollView viewWithTag:i+1];
            button.selected = NO;
            button.titleLabel.font = KSystemFontSize15;
        }else{
            
            button.titleLabel.font = KSystemRealBoldFontSize15;
        }
    }
}

- (void) refreshSelectScrollView:(int) index{

    for (int i = 0 ; i < self.itemNamesArray.count; i++) {
        
        UIButton *button = [self.bgScrollView viewWithTag:i+1];
        if (i != index) {
            
            button.selected = NO;
            button.titleLabel.font = KSystemFontSize15;
            
        }else{
        
            button.selected = YES;
            button.titleLabel.font = KSystemRealBoldFontSize15;
        
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                
                weakSelf.lineView.frame = CGRectMake(button.center.x - 40*Proportion/2.0,
                                                     self.bgScrollView.frame.size.height - 2,
                                                     40*Proportion,
                                                     2);
            }];
        }
    }
}
@end
