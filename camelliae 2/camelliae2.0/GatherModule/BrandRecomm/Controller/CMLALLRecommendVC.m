//
//  CMLALLRecommendVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLALLRecommendVC.h"
#import "CMLRecommendTableView.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"

@interface CMLALLRecommendVC ()<CMLBaseTableViewDlegate,NavigationBarProtocol>

@property (nonatomic,strong) NSNumber *brandID;

@property (nonatomic,strong) NSNumber *type;

@property (nonatomic,strong) CMLRecommendTableView *tableView;

@end

@implementation CMLALLRecommendVC

- (instancetype)initWIthBrandID:(NSNumber *) brandID andType:(NSNumber *) type{
    
    self = [super init];
    
    if (self) {
        
        self.brandID = brandID;
        self.type = type;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CMLMobClick SeeAllTheRecommendations];
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.titleContent = @"推荐人";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.delegate = self;
    [self loadViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.tableView stopVideo];
}

- (void) loadViews{
    
    [self startLoading];
    self.tableView = [[CMLRecommendTableView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(self.navBar.frame),
                                                                              WIDTH,
                                                                              HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                             style:UITableViewStylePlain
                                                        andBrandID:self.brandID
                                                           andType:self.type];
    self.tableView.backgroundColor = [UIColor CMLNewGrayColor];
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
