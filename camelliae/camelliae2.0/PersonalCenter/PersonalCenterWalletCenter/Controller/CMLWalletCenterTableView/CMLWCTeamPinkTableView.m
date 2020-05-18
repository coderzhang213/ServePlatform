//
//  CMLWCTeamPinkTableView.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/8/14.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLWCTeamPinkTableView.h"
#import "CMLWalletCenterMyTeamTopView.h"
#import "NetConfig.h"
#import "Network.h"
#import "VCManger.h"
#import "CMLWalletCenterTeamCell.h"
#import "ReplaceTVCell.h"
#import "CMLWalletCenterModel.h"
#import "CMLTeamInfoModel.h"
#import "CMLWalletCenterMyTeamCell.h"

@interface CMLWCTeamPinkTableView ()<NetWorkProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataGoldArray;

@property (nonatomic, strong) NSMutableArray *dataDiamondArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat replaceHeight;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, strong) CMLWalletCenterMyTeamTopView *tablViewHeader;

@property (nonatomic, strong) CMLWalletCenterMyTeamTopView *diamondHeader;

@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, assign) int myTeamType;


@end

@implementation CMLWCTeamPinkTableView

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataDiamondArray {
    if (!_dataDiamondArray) {
        _dataDiamondArray = [NSMutableArray array];
    }
    return _dataDiamondArray;
}

- (NSMutableArray *)dataGoldArray {
    if (!_dataGoldArray) {
        _dataGoldArray = [NSMutableArray array];
    }
    return _dataGoldArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        NSArray *gold = @[@"粉金用户"];
        NSArray *diamond = @[@"粉钻用户"];
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
    }
    return self;
        
}

- (void)getCellHeight {
    
    self.cellHeight = 178 * Proportion + 1 * Proportion;
    
}

- (void)pullRefreshOfHeader {
    
    [self.dataArray removeAllObjects];
    //    [self setWalletCenterRecordRequest];
    [self setWalletCenterInfoRequest];
    
}

#pragma mark - Network

- (void)setWalletCenterInfoRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"userId"];
    
    [NetWorkTask postResquestWithApiName:WalletCenterDarkTeamIntro paraDic:paraDic delegate:delegate];
    self.currentApiName = WalletCenterDarkTeamIntro;
    [self.baseTableViewDlegate startRequesting];
}


- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.currentApiName isEqualToString:WalletCenterDarkTeamIntro]) {
        if ([obj.retCode intValue] == 0 && obj) {
            NSDictionary *dict = (NSDictionary *)obj.retData;
            NSArray *goldArray = [dict objectForKey:@"pinkGold"];
            NSArray *diamondArray = [dict objectForKey:@"pinkDiamond"];
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.list];
            NSLog(@"%@", self.dataArray);
            [self reloadData];//
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }else{
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }else {
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.list];
            NSLog(@"%@", self.dataArray);
            
            [self reloadData];
        }else if ([obj.retCode intValue] == 100101){
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }
    [self.baseTableViewDlegate endRequesting];
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.baseTableViewDlegate endRequesting];
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.myTeamType == 2) {
//        if (section == 0) {
//            self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
//            return self.tablViewHeader;
//        }else {
//            self.diamondHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:3];
//            return self.diamondHeader;
//        }
//    }else if (self.myTeamType == 4) {
//        return [[UIView alloc] init];
//    }else {
//        self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
//        return self.tablViewHeader;
//    }
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLTeamInfoModel *teamInfoModel = [CMLTeamInfoModel getBaseObjFrom:self.dataArray[indexPath.row]];
    static NSString *identifier = @"myTeamcell";
    CMLWalletCenterMyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLWalletCenterMyTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        [cell refreshCurrentCell:teamInfoModel withTeamType:self.myTeamType];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.myTeamType == TeamAType) {
//        CMLTeamInfoModel *teamInfoModel = [CMLTeamInfoModel getBaseObjFrom:self.dataArray[indexPath.row]];
//        [[DataManager lightData] saveADetailID:teamInfoModel.detailID];
//        CMLTeamBViewController *vc = [[CMLTeamBViewController alloc] init];
//        vc.titleName = teamInfoModel.userName;
//        vc.detailID = teamInfoModel.detailID;
//        vc.isTeamB = YES;
//        [[VCManger mainVC] pushVC:vc animate:YES];
//    }else{
//        return;
//    }
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
