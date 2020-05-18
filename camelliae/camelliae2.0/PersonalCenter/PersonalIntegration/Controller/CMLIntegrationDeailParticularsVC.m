//
//  CMLIntegrationDeailParticularsVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLIntegrationDeailParticularsVC.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "CMLIntegrationDetailTVCell.h"
#import "CMLIntegrationDetailObj.h"
#import "MJRefresh.h"

#define PageSize  10

@interface CMLIntegrationDeailParticularsVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *dataAray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;



@end

@implementation CMLIntegrationDeailParticularsVC

- (NSMutableArray *)dataAray{

    if (!_dataAray) {
        _dataAray = [NSMutableArray array];
    }
    
    return _dataAray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = @"积分明细";
    [self.navBar setLeftBarItem];
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    
    self.page = 1;
    
    [self loadViews];
    
    [self setNetworkRequest];
    
    [self startLoading];
}

- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    
    /**下拉刷新*/
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.dataAray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataAray.count > 0) {
    
         return 120*Proportion;
        
    }else{
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (self.dataAray.count > 0) {
     
        static NSString *identifier = @"mycell";
        
        CMLIntegrationDetailObj *obj = [CMLIntegrationDetailObj getBaseObjFrom:self.dataAray[indexPath.row]];
        CMLIntegrationDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[CMLIntegrationDetailTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.createTime = obj.createTime;
        cell.logTypeName = obj.logTypeName;
        cell.status = obj.status;
        cell.point = obj.point;
        [cell refreshCurrentTVCell];
        return cell;
        
    }else{
    
        static NSString *identifier = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
    }

}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) setNetworkRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    [NetWorkTask postResquestWithApiName:INtegrationList paraDic:paraDic delegate:delegate];
    self.currentApiName = INtegrationList;
    
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:INtegrationList]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = obj.retData.dataCount;
            if (self.page == 1) {
                self.dataAray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.dataAray addObjectsFromArray:obj.retData.dataList];
            }

            [self.mainTableView reloadData];
        }
    }
    
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
    
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    [self.dataAray removeAllObjects];
    self.page = 1;
    [self setNetworkRequest];
    
}



#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:INtegrationList]) {
        
        if (self.dataAray.count%PageSize == 0) {
            if (self.dataAray.count != [self.dataCount intValue]) {
                self.page++;
                [self setNetworkRequest];
                
            }else{
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

@end
