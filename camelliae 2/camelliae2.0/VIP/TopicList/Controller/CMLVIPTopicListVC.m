//
//  CMLVIPTopicVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/30.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLVIPTopicListVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"


#import "CMLVIPTopicTableView.h"

@interface CMLVIPTopicListVC ()<NavigationBarProtocol,CMLBaseTableViewDlegate>

@end

@implementation CMLVIPTopicListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    self.navBar.titleContent = @"话题";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    [self loadViews];
    [self startLoading];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) loadViews{
    
    CMLVIPTopicTableView *VIPTopicTableView = [[CMLVIPTopicTableView alloc] initWithFrame:CGRectMake(0,
                                                                                                    CGRectGetMaxY(self.navBar.frame),
                                                                                                    WIDTH,
                                                                                                    HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                                                    style:UITableViewStylePlain];
    VIPTopicTableView.baseTableViewDlegate = self;
    [self.contentView addSubview:VIPTopicTableView];
    
}

#pragma mark - CMLBaseTableViewDlegate

- (void) startRequesting{
    
    [self startLoading];
}

- (void) endRequesting{
    
    [self stopLoading];
}

- (void) showSuccessActionMessage:(NSString *) str{
    
    [self showSuccessActionMessage:str];
}

- (void) showFailActionMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) showAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];
    
}
@end

