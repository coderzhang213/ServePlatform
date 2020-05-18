//
//  CMLWalletCenterTableView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/13.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterTableView.h"
#import "NetConfig.h"
#import "Network.h"
#import "VCManger.h"
#import "CMLWalletCenterTeamCell.h"
#import "ReplaceTVCell.h"
#import "CMLWalletCenterModel.h"
#import "CMLWalletCenterMyTeamTopView.h"
#import "CMLWalletCenterMyTeamCell.h"
#import "DataManager.h"
#import "CMLTeamInfoModel.h"
#import "CMLTeamBViewController.h"
#import "CMLTeamDataModel.h"

@interface CMLWalletCenterTableView ()<NetWorkProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataDArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat replaceHeight;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, strong) CMLWalletCenterMyTeamTopView *tablViewHeader;

@property (nonatomic, strong) CMLWalletCenterMyTeamTopView *diamondHeader;

@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, assign) int myTeamType;

@property (nonatomic, assign) MyTeamTopType myTeamTopType;

@property (nonatomic, assign) MyTeamCellType myTeamCellType;

@end

@implementation CMLWalletCenterTableView

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataDArray {
    if (!_dataDArray) {
        _dataDArray = [NSMutableArray array];
    }
    return _dataDArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTeamType:(int)teamType {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.myTeamType = teamType;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
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
    
    if (self.myTeamType == 1) {
        [paraDic setObject:[[DataManager lightData] readADetailID] forKey:@"userId"];
    }else {
        [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"userId"];
    }
    
    if (self.myTeamType == 0 || self.myTeamType == 1) {/*黛色原来分享黛色*/
        [NetWorkTask postResquestWithApiName:WalletCenterNewMyTeamIntro paraDic:paraDic delegate:delegate];
        self.currentApiName = WalletCenterNewMyTeamIntro;
    }else if (self.myTeamType == 2 || self.myTeamType == 3) {/*黛色分享粉金*/
        [NetWorkTask postResquestWithApiName:WalletCenterDarkPinkIntro paraDic:paraDic delegate:delegate];
        self.currentApiName = WalletCenterDarkPinkIntro;
    }else if (self.myTeamType == 4) {
        if ([[[DataManager lightData] readRoleId] intValue] == 3) {/*粉金粉钻团队详情*/
            [NetWorkTask postResquestWithApiName:WalletCenterPinkTeamIntro paraDic:paraDic delegate:delegate];
            self.currentApiName = WalletCenterPinkTeamIntro;
        }else {
            [NetWorkTask postResquestWithApiName:WalletCenterDarkCommonTeamIntro paraDic:paraDic delegate:delegate];
            self.currentApiName = WalletCenterDarkCommonTeamIntro;
        }
    }
    NSLog(@"setWalletCenterInfoRequest %@", paraDic);
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"setWalletCenterInfoRequest %@", responseResult);
    if ([self.currentApiName isEqualToString:WalletCenterNewMyTeamIntro]) {
        if ([obj.retCode intValue] == 0 && obj) {

            self.count = obj.retData.count;
            self.parentName = obj.retData.parentName;
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.list];
            NSLog(@"%@", self.dataArray);
            [self reloadData];//
            
        }else if ([obj.retCode intValue] == 100101) {
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:@"0" withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
        }else{
            
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:@"0" withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:WalletCenterDarkCommonTeamIntro]) {/*黛色普通返利*/
        if ([obj.retCode intValue] == 0 && obj) {
    
            CMLTeamDataModel *teamDataModel = [CMLTeamDataModel getBaseObjFrom:obj.retData.team];
            self.count = teamDataModel.count;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:teamDataModel.dataList];
            NSLog(@"%@", self.dataArray);
            
            [self reloadData];
        }else if ([obj.retCode intValue] == 100101) {
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:WalletCenterPinkTeamIntro]) {/*粉金邀请粉金团队详情*/
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj.retData.list];
            NSLog(@"%@", self.dataArray);
            
            [self reloadData];
        }else if ([obj.retCode intValue] == 100101) {
            
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:WalletCenterDarkPinkIntro]) {/*黛色邀请粉金团队详情*/
        if ([obj.retCode intValue] == 0 && obj) {
            CMLTeamDataModel *teamDataModel = [CMLTeamDataModel getBaseObjFrom:obj.retData.pinkGold];
            self.count = teamDataModel.count;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:teamDataModel.dataList];
//            self.count = obj.retData.count;
            self.parentName = @"粉金用户";
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
            
            NSLog(@"%@", self.dataArray);
            [self reloadData];//
            
        }else if ([obj.retCode intValue] == 100101) {
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:@"0" withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
        }else{
            
            if (self.myTeamType < 4) {
                self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:@"0" withTeamType:self.myTeamType];
                self.tableHeaderView = self.tablViewHeader;
            }else {
                self.tableHeaderView = [[UIView alloc] init];
            }
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    
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
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.myTeamType == 2) {
        if (section == 0) {
            self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
            return self.tablViewHeader;
        }else {
            self.diamondHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:3];
            return self.diamondHeader;
        }
    }else if (self.myTeamType == 4) {
        return [[UIView alloc] init];
    }else {
        self.tablViewHeader = [[CMLWalletCenterMyTeamTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 148 * Proportion)withParentName:self.parentName withCount:self.count withTeamType:self.myTeamType];
        return self.tablViewHeader;
    }
    
}
*/

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

    /*
     //进入黛色B级团队-B级已取消
    if (self.myTeamType == 0) {
        CMLTeamInfoModel *teamInfoModel = [CMLTeamInfoModel getBaseObjFrom:self.dataArray[indexPath.row]];
        [[DataManager lightData] saveADetailID:teamInfoModel.detailID];
        CMLTeamBViewController *vc = [[CMLTeamBViewController alloc] init];
        vc.titleName = teamInfoModel.userName;
        vc.detailID = teamInfoModel.detailID;
        vc.isTeamB = YES;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        return;
    }
     */
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
