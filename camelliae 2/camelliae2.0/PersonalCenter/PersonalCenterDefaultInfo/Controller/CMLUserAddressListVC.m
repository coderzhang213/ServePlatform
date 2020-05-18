//
//  CMLUserAddressListVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLUserAddressListVC.h"
#import "VCManger.h"
#import "CMLUserAddressTVCell.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NetConfig.h"
#import "UIColor+SDExspand.h"
#import "CMLAlterAddressMesaageVC.h"
#import "CMLAddressObj.h"
#import "MJRefresh.h"

#define PageSize  10

@interface CMLUserAddressListVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,AlterAddressMessageDeleagte>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) UIButton *addAddressNumBtn;

@property (nonatomic,assign) int page;


@end

@implementation CMLUserAddressListVC

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = self.currentTitle;
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    [self.navBar setLeftBarItem];

    
    [self loadData];
    
    [self loadViews];
}

- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame) - 80*Proportion - SafeAreaBottomHeight)];
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = self.cellHeight;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.addAddressNumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                       HEIGHT - 80*Proportion - SafeAreaBottomHeight,
                                                                       WIDTH,
                                                                       80*Proportion)];
    self.addAddressNumBtn.backgroundColor = [UIColor CMLBrownColor];
    [self.addAddressNumBtn setTitle:@"添加地址" forState:UIControlStateNormal];
    self.addAddressNumBtn.titleLabel.font = KSystemBoldFontSize15;
    [self.addAddressNumBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addAddressNumBtn];
    [self.addAddressNumBtn addTarget:self action:@selector(enterAlterAddressVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loadData{

    
    self.page = 1;
    
    [self setRequestOfAddressList];
    
    [self startLoading];
    
    [self getCellHeight];

}

- (void) setRequestOfAddressList{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hasToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hasToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:UserAddressList paraDic:paraDic delegate:delegate];
    self.currentApiName = UserAddressList;


}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.dataArray.count > 0) {
        
        return self.dataArray.count;
    }else{
    
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"mycell";

    CMLUserAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLUserAddressTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    if (self.dataArray.count > 0) {
        
        CMLAddressObj *obj = [CMLAddressObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentAddressCell:obj];
        
        __weak typeof(self) weakSelf= self;
        cell.delegateCurrentAddress =^(NSNumber * currentID){
        
            [weakSelf setDelegateRequestWith:currentID];
        };
        
        cell.refreshCurrentAddress = ^(NSString *userName ,NSString *tele ,NSString *address,NSNumber *addressID){
        
            if (weakSelf.currentAddressID) {
                
                if ([addressID intValue] == [weakSelf.currentAddressID intValue]) {
                    
                    [weakSelf.delegate refreshUserName:userName userTele:tele userAddress:address addressID:addressID];
                    
                }
            }
            
            weakSelf.page = 1;
            [weakSelf.dataArray removeAllObjects];
            [weakSelf setRequestOfAddressList];
            [weakSelf startLoading];
            
        };
        
        cell.setDefaultAddressStart = ^(){
        
            [weakSelf startIndicatorLoading];
        };
        
        cell.setDefaultAddressEnd = ^(NSString *str){
        
            [weakSelf showSuccessTemporaryMes:str];
            weakSelf.page = 1;
            [weakSelf.dataArray removeAllObjects];
            [weakSelf setRequestOfAddressList];
            
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.currentTitle isEqualToString:@"选择收货信息"]) {
        CMLAddressObj *obj = [CMLAddressObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        [self.delegate refreshUserName:obj.consignee userTele:obj.mobile userAddress:obj.address addressID:obj.currentID];
        
        [[VCManger mainVC] dismissCurrentVC];
    }

}
#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - NetWorkProtocol

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:UserAddressList]) {
        
        NSLog(@"**%@",responseResult);
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = obj.retData.dataCount;
            if (self.page == 1) {
                
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
            
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            
            if (self.dataArray.count == 0) {
                
                self.addAddressNumBtn.hidden = YES;
                [self setCUrrentTableViewFooterView];
                if (self.delegate) {
                    
                    [self.delegate refreshUserName:@"" userTele:@"" userAddress:@"" addressID:[NSNumber numberWithInt:0]];
                }
                
            }else{
            
                self.mainTableView.tableFooterView = [[UIView alloc] init];
                self.addAddressNumBtn.hidden = NO;
            }
            
            [self.mainTableView reloadData];
        }
    }else if ([self.currentApiName isEqualToString:DeleteAddress]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            [self setRequestOfAddressList];
        }
        
         [self showSuccessTemporaryMes:obj.retMsg];
    }
    
    [self stopLoading];
    [self stopIndicatorLoading];
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
    [self stopIndicatorLoading];
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
}

- (void) enterAlterAddressVC{

    CMLAlterAddressMesaageVC *vc = [[CMLAlterAddressMesaageVC alloc] init];
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) getCellHeight{

    CMLUserAddressTVCell *cell = [[CMLUserAddressTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    [cell refreshCurrentAddressCell:nil];
    
    self.cellHeight = cell.currentCellHeight;
}

- (void) setDelegateRequestWith:(NSNumber *) currentID{

    self.page = 1;
    [self.dataArray removeAllObjects];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"status"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hasToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey],[NSNumber numberWithInt:2],currentID]];
    [paraDic setObject:hasToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:DeleteAddress paraDic:paraDic delegate:delegate];
    self.currentApiName = DeleteAddress;
    
    [self startIndicatorLoading];
    
}

- (void) refreshCurrentAddressList{

    
}

#pragma mark - AlterAddressMessageDeleagte

- (void) refreshOrderMessageWithUserName:(NSString *) userName
                                userTele:(NSString *) userTele
                             userAddress:(NSString *) userAddress
                            andAddressID:(NSNumber *) addressID{

    if (self.currentAddressID) {
     
        if ([addressID intValue] == [self.currentAddressID intValue]) {
            
            [self.delegate refreshUserName:userName userTele:userTele userAddress:userAddress addressID:addressID];
            
        }
    }
    
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self setRequestOfAddressList];
    [self startLoading];
}

- (void) pullRefreshOfHeader{

    self.page = 1;
    [self.dataArray removeAllObjects];
    [self setRequestOfAddressList];
}

- (void) loadMoreData{

    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setRequestOfAddressList];
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void) setCUrrentTableViewFooterView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.mainTableView.frame.size.height)];
    
    UIImageView *currentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NoUserAddressImg]];
    [currentImage sizeToFit];
    currentImage.frame = CGRectMake(WIDTH/2.0 - currentImage.frame.size.width/2.0, view.frame.size.height/2.0 - currentImage.frame.size.height/2.0, currentImage.frame.size.width, currentImage.frame.size.height);
    [view addSubview:currentImage];
    
    UIButton *addNewAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 360*Proportion/2.0,
                                                                            CGRectGetMaxY(currentImage.frame) + 93*Proportion,
                                                                            360*Proportion,
                                                                            80*Proportion)];
    addNewAddressBtn.titleLabel.font = KSystemFontSize15;
    [addNewAddressBtn setTitle:@"添加收货信息" forState:UIControlStateNormal];
    addNewAddressBtn.backgroundColor = [UIColor CMLBrownColor];
    addNewAddressBtn.layer.cornerRadius = 8*Proportion;
    [view addSubview: addNewAddressBtn];
    [addNewAddressBtn addTarget:self action:@selector(enterAlterAddressVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainTableView.tableFooterView = view;
}
@end
