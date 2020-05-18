//
//  ShoppingCarVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "ShoppingCarVC.h"
#import "CMLShoppingCarTableView.h"
#import "VCManger.h"

@interface ShoppingCarVC ()<CMLBaseTableViewDlegate,NavigationBarProtocol>

@property (nonatomic,strong) CMLShoppingCarTableView *tableView;

@end

@implementation ShoppingCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = @"购物车";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    
    [self loadViews];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.tableView) {
        
        [self.tableView removeFromSuperview];
        
        [self loadViews];
    }
}

- (void) loadViews{
    
    [self startLoading];
    
    [CMLMobClick ShoppingCart];
    
    self.tableView = [[CMLShoppingCarTableView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(self.navBar.frame),
                                                                               WIDTH,
                                                                               HEIGHT - CGRectGetMaxY(self.navBar.frame) - 100 * Proportion -  SafeAreaBottomHeight)
                                                              style:UITableViewStyleGrouped];
    self.tableView.baseTableViewDlegate = self;
    [self.contentView addSubview:self.tableView];
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

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}
@end
