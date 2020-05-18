//
//  CMLPersonContentTableView.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/10/25.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLPersonContentTableView.h"

@interface CMLPersonContentTableView () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) CGFloat currOffsetY;

@end

@implementation CMLPersonContentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idetifer = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.currOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y == 0 ? 0 : self.currOffsetY);
    }
    self.currOffsetY = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y < 0 ) {
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        if (self.scrollDragBlock) {
            self.scrollDragBlock();
        }
    }
    scrollView.showsVerticalScrollIndicator = self.canScroll ? YES : NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
