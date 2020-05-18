//
//  CMLIncomeTableView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/18.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLIncomeTableView.h"
#import "ReplaceTVCell.h"
#import "NSDate+CMLExspand.h"
#import "AppGroup.h"
#import "Network.h"
#import "NetConfig.h"
#import "VCManger.h"
#import "CMLWalletCenterModel.h"
#import "CMLIncomeCell.h"
#import "CMLWalletCenterViewController.h"


@interface CMLIncomeTableView ()<NetWorkProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat replaceHeight;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, copy) NSString *timeString;

@end

@implementation CMLIncomeTableView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (NSMutableArray *)yearArray {
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTimeString:(NSString *)timeString {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        self.bounces = NO;
        /**下拉刷新*/
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfHeader)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        self.mj_header.frame = CGRectMake(0, CGRectGetHeight(self.mj_header.frame), CGRectGetWidth(self.mj_header.frame), CGRectGetHeight(self.mj_header.frame));
        
        self.timeString = timeString;
        
        [self getCellHeight];
        
        [self pullRefreshOfHeader];
    
    }
    
    return self;
}

- (void)getCellHeight {
    
    self.cellHeight = 178 * Proportion + 1 * Proportion;
    
}

- (void)pullRefreshOfHeader {
    
    [self.dataArray removeAllObjects];
    
    [self setWalletCenterRecordRequest];
    
}

- (void)setWalletCenterRecordRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.timeString forKey:@"time"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:WalletCenterNewMyTeamRecord paraDic:paraDic delegate:delegate];
    self.currentApiName = WalletCenterNewMyTeamRecord;
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([resObj.retCode intValue] == 0 && resObj) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:resObj.retData.list];
        
        [self.incomeDelegate refreshEarningsRecordViewWithIncomeTableViewWith:resObj.retData.income withGetCash:resObj.retData.getCash];

        [self reloadData];
        
    }else if ([resObj.retCode intValue] == 100101) {
        [SVProgressHUD showErrorWithStatus:resObj.retMsg];
    }
    [self.mj_header endRefreshing];
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
    
}

#pragma  mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLWalletCenterModel *recordModel = [CMLWalletCenterModel getBaseObjFrom:self.dataArray[indexPath.row]];
    static NSString *identifier = @"myTeamcell";
    CMLIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CMLIncomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataArray.count > 0) {
        if (recordModel.title.length > 0) {
            [cell refreshRebateCurrentCell:recordModel];
        }else {
            [cell refreshCurrentCell:recordModel];
        }
        
        
    }
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.contentOffset.y > 0) {
        [self.incomeDelegate setWhiteNavBar];
    }else{
        [self.incomeDelegate setBlackNavBar];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
