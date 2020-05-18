//
//  RollView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/22.
//  Copyright © 2018 张越. All rights reserved.
//

#import "RollView.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
@interface RollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *rollDataArr;   // 图片数据

@property (nonatomic, assign) float halfGap;   // 图片间距的一半

@end


@implementation RollView
- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.halfGap = gap / 2;
        
        /** 设置 UIScrollView */
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(distance, 0, self.frame.size.width - 2 * distance, self.frame.size.height)];
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        self.scrollView.clipsToBounds = NO;
        
        /** 添加手势 */
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [self.scrollView addGestureRecognizer:tap];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        /** 数据初始化 */
        self.rollDataArr = [NSArray array];
        
    }
    
    
    return self;
}

-(void)rollView:(NSArray *)dataArr{
    
    self.rollDataArr = dataArr;
    
    
    //循环创建添加轮播图片, 前后各添加一张
    for (int i = 0; i < self.rollDataArr.count; i++) {
        
        for (UIView *underView in self.scrollView.subviews) {
            
            if (underView.tag == 400 + i) {
                [underView removeFromSuperview];
            }
        }
        
        UIImageView *picImageView = [[UIImageView alloc] init];
        picImageView.backgroundColor = [UIColor CMLWhiteColor];
        picImageView.userInteractionEnabled = YES;
        picImageView.layer.cornerRadius = self.radius;
        picImageView.clipsToBounds = YES;
        picImageView.tag = 400 + i ;
        
        picImageView.frame = CGRectMake((2 * i + 1) * self.halfGap + i * (self.scrollView.frame.size.width - 2 * self.halfGap), 0, (self.scrollView.frame.size.width - 2 * self.halfGap), self.frame.size.height);
        [NetWorkTask setImageView:picImageView WithURL:self.rollDataArr[i] placeholderImage:nil];
        
        [self.scrollView addSubview:picImageView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:picImageView.bounds];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [picImageView addSubview:btn];
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.rollDataArr.count, 0);
    
}


-(void)tap:(UIButton *)btn{
        
    [_delegate didSelectPicWithIndexPath:btn.tag];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.delegate  scrollX:scrollView.contentOffset.x];
    
}



@end
