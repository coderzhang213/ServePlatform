//
//  MemberSalonTableView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/14.
//  Copyright © 2019 张越. All rights reserved.
//

#import "MemberSalonTableView.h"
#import "VCManger.h"
#import "AppGroup.h"
#import "MemberSalonModel.h"
#import "MemberSalonCell.h"
#import "NetConfig.h"
#import "ActivityDefaultVC.h"
#import "CMLActivityObj.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>

#define CellAroundMargin     10
#define CellImageLeftMargin  48
#define TableViewCellHeight  146 * Proportion

@interface MemberSalonTableView ()<UITableViewDelegate, UITableViewDataSource, NetWorkProtocol, CMLBaseTableViewDlegate, ActivityDefaultVCDelegate>

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *heightDic;

@property (nonatomic, strong) NSString *canJoin;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation MemberSalonTableView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
        [self getCellHeight];
        
        [self pullRefreshOfHeader];
        
    }
    return self;
}

- (void)getCellHeight {
    
    self.cellHeight = 146 * Proportion;
    
}

#pragma mark Network
- (void)pullRefreshOfHeader {
    
    [self.dataArray removeAllObjects];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *userID = [[DataManager lightData] readUserID];/*user_id未存储*/
    [paraDic setObject:userID forKey:@"user_id"];
    
    [NetWorkTask postResquestWithApiName:SalonActivity paraDic:paraDic delegate:delegate];
    self.currentApiName = SalonActivity;
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:obj.retData.actList];
        self.canJoin = obj.retData.canJoin;
        [self reloadData];
        
    }else if ([obj.retCode intValue] == 100101) {
        
    }else {
        [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
    }
    [self.baseTableViewDlegate endRequesting];
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.baseTableViewDlegate endRequesting];
    
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"myCell";
    MemberSalonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MemberSalonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        
        MemberSalonModel *salonModel = [MemberSalonModel getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentCell:salonModel withCanJoin:self.canJoin];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberSalonModel *salonModel = [MemberSalonModel getBaseObjFrom:self.dataArray[indexPath.row]];
    
    if (salonModel.currentID) {
        
        if ([self.canJoin intValue] == 1 || [[[DataManager lightData] readUserLevel] intValue] == 3) {
            if ([salonModel.isJoin intValue] != 1) {
                
                ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:@([salonModel.currentID integerValue])];
                vc.delegate = (id)self;
                vc.isJoin = salonModel.isJoin;
                [[VCManger mainVC] pushVC:vc animate:YES];
                
            }
        }
    }
}

- (void)refreshFashionSalonEquity {
    
    [self.salonDelegate refreshFashionSalonEquityWithSalonTable];
    
}

@end
