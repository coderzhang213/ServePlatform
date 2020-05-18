//
//  MainInterfaceImageTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "MainInterfaceImageTableView.h"
#import "VCManger.h"
#import "MainInterfaceImageTVCell.h"
#import "MJRefresh.h"
#import "SpecialParaDicProduce.h"
#import "CMLAllImagesVC.h"
#import "CMLImageListObj.h"
#import "CMLPhotoViewController.h"

#define PageSize             15

#define CellAroundMargin     15
#define CellImageLeftMargin  30

@interface MainInterfaceImageTableView()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) int page;
@end

@implementation MainInterfaceImageTableView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        
        _heightDic = [NSMutableDictionary dictionary];
    }
    return _heightDic;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.rowHeight = (WIDTH - CellImageLeftMargin*Proportion*2)/16*9 + CellAroundMargin*Proportion*2;
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        /**下拉刷新*/
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfHeader)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        
        [self loadData];
        
        
        [self pullRefreshOfHeader];
    }
    
    return self;
}



- (void) loadData{
    
    self.page = 1;
    [self.baseTableViewDlegate startRequesting];
    [self pullRefreshOfHeader];
}

- (void) pullRefreshOfHeader{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask postResquestWithApiName:ImageList paraDic:paraDic delegate:delegate];
    self.currentApiName = ImageList;
    
}

- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:ImageList]) {
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self pullRefreshOfHeader];
            }else{
                
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];

    if ([obj.retCode intValue] == 0) {
        
        self.dataCount = [obj.retData.dataCount intValue];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:obj.retData.dataList];
        
        [self reloadData];
        
    }else if ([obj.retCode intValue] == 100101){
        
        
        
    }else{
        
        [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
    }
    
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];//2
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self.baseTableViewDlegate endRequesting];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.heightDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        
        return [[self.heightDic valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
    }else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"myCell";
    
    MainInterfaceImageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MainInterfaceImageTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataArray.count > 0) {
        
        CMLImageListObj *obj = [CMLImageListObj getBaseObjFrom:self.dataArray[indexPath.row]];
        [cell refreshCurrentCell:obj];
        [self.heightDic setValue:[NSString stringWithFormat:@"%f",cell.currentHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLImageListObj *obj = [CMLImageListObj getBaseObjFrom:self.dataArray[indexPath.row]];

    CMLPhotoViewController *vc = [[CMLPhotoViewController alloc] initWithAlbumId:obj.albumId ImageName:obj.shortTitle];
//    CMLAllImagesVC *vc = [[CMLAllImagesVC alloc] initWithAlbumId:obj.albumId ImageName:obj.shortTitle];
    vc.shareImageUrl = obj.coverPicThumb;
    [[VCManger mainVC] pushVC:vc animate:YES];

}


@end
