//
//  CMLBaseTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/2.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseTableView.h"

@interface CMLBaseTableView()<UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat currentOffY;

@end

@implementation CMLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self.baseTableViewDlegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        
        [self.baseTableViewDlegate tableViewDidScroll:scrollView.contentOffset.y];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.currentOffY = self.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.contentOffset.y > 0) {
        
        if (self.currentOffY > self.contentOffset.y) {
            
            if ([self.baseTableViewDlegate respondsToSelector:@selector(tableScrollDown)]) {
                
                [self.baseTableViewDlegate tableScrollDown];
            }
            NSLog(@"tableScrollDown===self.currentOffY > self.contentOffset.y");
            
        }else{
            
            if ([self.baseTableViewDlegate respondsToSelector:@selector(tableScrollUp)]) {
                
                [self.baseTableViewDlegate tableScrollUp];
            }
            NSLog(@"tableScrollUp===self.currentOffY <= self.contentOffset.y");
            
            
        }
    }else if (self.contentOffset.y == 0){
        
        if ([self.baseTableViewDlegate respondsToSelector:@selector(tableScrollZero)]) {
            
            [self.baseTableViewDlegate tableScrollZero];
        }
        NSLog(@"tableScrollZero===self.currentOffY == 0");
    }else{
        
        if ([self.baseTableViewDlegate respondsToSelector:@selector(tableScrollDown)]) {
            
            [self.baseTableViewDlegate tableScrollDown];
        }
        NSLog(@"tableScrollDown===self.currentOffY < 0");
    }
}

@end
