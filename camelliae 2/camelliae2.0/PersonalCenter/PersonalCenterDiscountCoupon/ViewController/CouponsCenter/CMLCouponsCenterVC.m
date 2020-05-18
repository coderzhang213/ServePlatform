//
//  CMLCouponsCenterVC.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/8/7.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCouponsCenterVC.h"
#import "CMLMyCouponsTableView.h"
#import "VCManger.h"
#import "MJRefresh.h"
#import "SpecialTopicTableView.h"

@interface CMLCouponsCenterVC ()<NavigationBarProtocol, NetWorkProtocol, CMLBaseTableViewDlegate>

@property (nonatomic,strong) CMLMyCouponsTableView *mainTableView;

@property (nonatomic,strong) SpecialTopicTableView *mainTableView1;

//@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *datacount;

@property (nonatomic,assign) int page;

@end

@implementation CMLCouponsCenterVC

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDic {
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    return _heightDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"领券中心";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    [self loadCouponsCenterViews];
}

- (void)loadCouponsCenterViews {
    
    if (!self.mainTableView) {
        
        self.mainTableView = [[CMLMyCouponsTableView alloc] initWithFrame:CGRectMake(0,
                                                                                     CGRectGetMaxY(self.navBar.frame),
                                                                                     WIDTH,
                                                                                     HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)
                                                                    style:UITableViewStylePlain
                                                                withIsUse:nil
                                                              withProcess:nil
                                                                  withObj:nil
                                                          withCouponsType:CanGetCouponsTableType
                                                                withPrice:nil];
        self.mainTableView.baseTableViewDlegate = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 48*Proportion)];
        self.mainTableView.tableHeaderView = view;
        if (@available(iOS 11.0, *)){
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
        [self.contentView addSubview:self.mainTableView];
    }else {
        self.mainTableView.hidden = NO;
    }
}

- (void)didSelectedLeftBarItem {
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

#pragma mark - CMLBaseTableViewDlegate
- (void) startRequesting{
    
    [self startLoading];
}

- (void) endRequesting{
    
    [self stopLoading];
}

- (void) showSuccessActionMessage:(NSString *) str{
    
    [self showSuccessTemporaryMes:str];
}

- (void) showFailActionMessage:(NSString *) str{
    
    [self showFailTemporaryMes:str];
}

- (void) showAlterView:(NSString *) text{
    
    [self showAlterViewWithText:text];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
