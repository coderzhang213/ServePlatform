//
//  CMLMultipleTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLMultipleTableView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "MJRefresh.h"
#import "VCManger.h"
#import "ActivityDefaultVC.h"
#import "CMLActivityTVCell.h"
#import "WebViewLinkVC.h"
#import "BaseResultObj.h"
#import "ReplaceTVCell.h"
#import "CMLNewActivityAnInfoCell.h"
#import "CMLWorldFashionHeaderView.h"
#import "CMLCityMesHeaderView.h"
#import "CMLUserArticleVC.h"
#import "ObjInfo.h"
#import "CMLNewArticleTVCell.h"
#import "CMLUserPushActivityTVCell.h"
#import "CMLUserPushActivityDetailVC.h"

#define PageSize  10

@interface CMLMultipleTableView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CMLCityMesHeaderViewDelegate>

@property (nonatomic,strong) NSArray *tagIDsArr;

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableDictionary *dataSourceDic;

@property (nonatomic,strong) NSMutableDictionary  *dataCountDic;

@property (nonatomic,strong) NSMutableDictionary *dataPageDic;

@property (nonatomic,strong) NSMutableDictionary *isShowDic;

@property (nonatomic,strong) NSMutableDictionary *cityMesDic;

@property (nonatomic,strong) BaseResultObj *activityBannerObj;

@property (nonatomic,strong) BaseResultObj *activityMesBannerObj;

@property (nonatomic,strong) BaseResultObj *worldTopObj;

@property (nonatomic,assign) int currentSelectNum;

@property (nonatomic,assign) CGFloat activityHeight;

@property (nonatomic,assign) CGFloat articleHeight;

@property (nonatomic,assign) CGFloat replaceHeight;

@property (nonatomic,strong) CMLWorldFashionHeaderView *worldFashionHeaderView;

@property (nonatomic,strong) NSArray *worldTopMessageNarray;

@property (nonatomic,strong) NSArray *todayMessageNarray;

@property (nonatomic,strong) NSMutableDictionary *cityMesTypeSelectDic;

@property (nonatomic,strong) NSMutableArray *tableArray;

@property (nonatomic,assign) CGFloat activityCellHeight;

@property (nonatomic,assign) int type;

@property (nonatomic,strong) NSNumber *typeid;

@property (nonatomic,strong) NSMutableDictionary *typeDic;

@end

@implementation CMLMultipleTableView

- (NSMutableDictionary *)typeDic{
    
    if (!_typeDic) {
        _typeDic = [NSMutableDictionary dictionary];
    }
    
    return _typeDic;
}

- (NSMutableArray *)tableArray{
    
    if (!_tableArray) {
        _tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (NSMutableDictionary *)cityMesTypeSelectDic{
    
    
    if (!_cityMesTypeSelectDic) {
        
        _cityMesTypeSelectDic = [NSMutableDictionary dictionary];
    }
    
    return _cityMesTypeSelectDic;
}


- (NSArray *)worldTopMessageNarray{
    
    if (!_worldTopMessageNarray) {
        _worldTopMessageNarray = [NSMutableArray array];
    }
    return _worldTopMessageNarray;
}

-(NSArray *)todayMessageNarray{
    
    if (!_worldTopMessageNarray) {
        _worldTopMessageNarray = [NSMutableArray array];
    }
    
    return _worldTopMessageNarray;
}

- (NSMutableDictionary *)cityMesDic{
    
    if (!_cityMesDic) {
        
        _cityMesDic = [NSMutableDictionary dictionary];
    }
    
    return _cityMesDic;
}

- (NSMutableDictionary *)dataSourceDic{

    if (!_dataSourceDic) {
        _dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}

- (NSMutableDictionary *)dataCountDic{

    if (!_dataCountDic) {
        _dataCountDic = [NSMutableDictionary dictionary];
    }
    return _dataCountDic;
}

- (NSMutableDictionary *)dataPageDic{

    if (!_dataPageDic) {
        _dataPageDic = [NSMutableDictionary dictionary];
    }
    return _dataPageDic;
}

- (NSMutableDictionary *)isShowDic{

    if (!_isShowDic) {
        _isShowDic = [NSMutableDictionary dictionary];
    }
    return _isShowDic;
}

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray *)tagIDsArr{

    self = [super init];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"changeCity" object:nil];
        
        self.frame = frame;
        self.tagIDsArr = tagIDsArr;
        self.backgroundColor = [UIColor whiteColor];
        [self getActivityCellHeight];
        [self getReplaceCellHeight];
        [self getArticleCellHeight];
        [self getUserPushAcivityCellHeight];
        [self loadData];
        [self loadViews];
    }
    return self;
}

- (void) loadData{

    for (int i = 0; i < self.tagIDsArr.count; i++) {
        
        [self.dataPageDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[i]]];
    }
}

- (void) loadViews{

    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.frame.size.width,
                                                                       self.frame.size.height)];
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.tag = 100;
    self.bgScrollView.contentSize = CGSizeMake(self.frame.size.width*self.tagIDsArr.count, self.frame.size.height);
    [self addSubview:self.bgScrollView];
    

    [self loadTableViews];
}

- (void) loadTableViews{

    for (int i = 0 ; i < self.tagIDsArr.count; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width*i,
                                                                               0,
                                                                               self.frame.size.width,
                                                                               self.frame.size.height)
                                                              style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
//        tableView.tag = i + 1;
        if (@available(iOS 11.0, *)){
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
        }
        
        [self.bgScrollView addSubview:tableView];
        
        [self.tableArray addObject:tableView];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(pullRefreshOfHeader)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        tableView.mj_header = header;
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                   refreshingAction:@selector(loadMoreData)];
        
        if (i != 0) {
            tableView.tableHeaderView = [[UIView alloc] init];
        }
    }
    
    [self setInitNetwork];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSArray *currentArray = [self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]];
    if (currentArray) {
        
        return currentArray.count;
    }else{
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *currentArray = [self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]];
    if (currentArray) {
        if (self.currentSelectNum == 0) {
            
            return 242*Proportion + 20*Proportion*2;
        }else{
         CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:currentArray[indexPath.row]];
            
            if ([activityObj.isUserPublish intValue] == 0) {
                
                if ([activityObj.rootTypeId intValue] == 2) {
                    
                    return self.activityHeight;
                }else{
                    
                    return self.articleHeight;
                    
                }
                
            }else{
                
                return self.activityCellHeight - 162*Proportion;
            }
            
        }
    }else{
        
        return self.replaceHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *currentArray = [self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    if (!currentArray) {
        static NSString *identifier = @"myCell";
        ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell reloadCurrentCell];
        return cell;
    }else{
        
        if (self.currentSelectNum == 0) {
            
            CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:currentArray[indexPath.row]];
            static NSString *identifier = @"mycell4";
            /*活动：-全部-活动*/
            CMLNewActivityAnInfoCell *cell4 = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell4) {
                
                cell4 = [[CMLNewActivityAnInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell4 refrshActivityCellInActivityVC:activityObj];
            return cell4;

            
        }else{
            
            CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:currentArray[indexPath.row]];
            
            if ([activityObj.isUserPublish intValue] == 0) {
                
                if ([activityObj.rootTypeId intValue] == 2) {
                    
                    
                    static NSString *identifier = @"defaultCell";
                    CMLActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:identifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    if (currentArray.count > 0) {
                        if (indexPath.row < currentArray.count) {
                            
                            CMLActivityTVCell *currentCell = (CMLActivityTVCell*)cell;
                            [currentCell refrshActivityCellInActivityVC:activityObj];
                        }
                    }
                    return cell;

                }else{

                    static NSString *identifier = @"defaultCell2";
                    CMLNewArticleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[CMLNewArticleTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:identifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    if (currentArray.count > 0) {
                        if (indexPath.row < currentArray.count) {
                            CMLNewArticleTVCell *currentCell = (CMLNewArticleTVCell*)cell;
                            [currentCell refrshArcticleCellInActivityVC:activityObj];
                        }
                    }
                    return cell;
                }
                
            }else{
                
                static NSString *identifier = @"defaultCell3";
                CMLUserPushActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[CMLUserPushActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell refrshWorldTVCellOf:activityObj];
                
                return cell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *currentArray = [self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    if (currentArray.count > 0) {
        if (indexPath.row < currentArray.count) {
            CMLActivityObj *activityObj = [CMLActivityObj getBaseObjFrom:currentArray[indexPath.row]];
            if ([activityObj.isUserPublish intValue] == 0) {
                if ([activityObj.rootTypeId intValue] == 2) {
                    /*活动*/
                    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:activityObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }else{
                    /*资讯*/
                    CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:activityObj.objId];
                    [[VCManger mainVC] pushVC:vc animate:YES];
                }
            }else{
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:activityObj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];
            }
        }
    }
}

- (void) setInitNetwork{
    
    self.currentSelectNum = 0;
    UITableView *tableView = self.tableArray[0];
    if (@available(iOS 11.0, *)){
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    [tableView.mj_header beginRefreshing];
}

- (void) setWorldTopScrollRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:13] forKey:@"bannerTypeId"];
    [NetWorkTask getRequestWithApiName:Banner13 param:paraDic delegate:delegate];
    self.currentApiName = Banner13;
    
}

- (void) setTodayRecommendRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [NetWorkTask getRequestWithApiName:WorldTodayFocus param:paraDic delegate:delegate];
    self.currentApiName = WorldTodayFocus;
    
}

- (void) setWorldStateRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[self.dataPageDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] forKey:@"page"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:V4WorldStateList
                                 paraDic:paraDic
                                delegate:delegate];
    self.currentApiName = V4WorldStateList;
    
}

- (void) setActivityListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[self.dataPageDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] forKey:@"page"];
    [paraDic setObject:self.tagIDsArr[self.currentSelectNum] forKey:@"objId"];
    
    if ([[self.cityMesTypeSelectDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue] == 0) {
        
        [paraDic setObject:[NSNumber numberWithInt:98] forKey:@"objType"];
    }else{
        
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
    }
    
    if ([self.typeid intValue] > 0) {
        
        [paraDic setObject:self.typeid forKey:@"typeId"];
    }
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    [NetWorkTask postResquestWithApiName:cityDetailList
                                 paraDic:paraDic
                                delegate:delegate];
    self.currentApiName = cityDetailList;
    
}
/***/
- (void) setActivityPicRequestwithCity{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.tagIDsArr[self.currentSelectNum] forKey:@"objId"];
    [NetWorkTask getRequestWithApiName:WorldTopPic param:paraDic delegate:delegate];
    self.currentApiName = WorldTopPic;
}
/***/

- (void) getActivityTypeListRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]]
                forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"searchType"];
    [paraDic setObject:self.tagIDsArr[self.currentSelectNum]
                forKey:@"cityId"];
    [NetWorkTask getRequestWithApiName:GetActivityTypeList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = GetActivityTypeList;

}

- (void) pullRefreshOfHeader{


    if (self.currentSelectNum == 0) {
     
        [self.dataPageDic setObject:@"1"
                             forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
        
        if (self.worldTopMessageNarray.count > 0) {
            
            [self setWorldStateRequest];
        }else{
            
            [self setWorldTopScrollRequest];
        }
    }else{
        [self setActivityPicRequestwithCity];
    }
}
- (void) loadMoreData{
    
    UITableView *tempTableView = self.tableArray[self.currentSelectNum];
    
    NSArray *currentArray = [self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    
        if (currentArray.count%PageSize == 0) {
            if (currentArray.count != [[self.dataCountDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue]) {
                
                int currentPage = [[self.dataPageDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue];
                currentPage++;
                [self.dataPageDic setObject:[NSString stringWithFormat:@"%d",currentPage]
                                     forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                
                if (self.currentSelectNum == 0) {
                    
                    [self setWorldStateRequest];
                }else{
                    
                    [self setActivityListRequest];
                }
                
            }else{
                [tempTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [tempTableView.mj_footer endRefreshingWithNoMoreData];
        }

}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
   if ([self.currentApiName isEqualToString:cityDetailList]){
       
        [self.delegate multipleTableProgressSucess];
       NSLog(@"cityDetailList %@", responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
        if ([obj.retCode intValue] == 0) {
            
            if (obj.retData.dataList) {
            
                [self.dataCountDic setObject:[NSString stringWithFormat:@"%@",obj.retData.dataCount] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                
                if ([[self.dataPageDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue] == 1) {
                    
                    NSMutableArray *array = [NSMutableArray arrayWithArray:obj.retData.dataList];
                    [self.dataSourceDic setObject:array forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                }else{
                    
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]];
                    [array addObjectsFromArray:obj.retData.dataList];
                    [self.dataSourceDic setObject:array forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                }
              /****************/
                
                if ( [[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]] intValue] == [obj.retData.cityId intValue]) {
                
                    [self.isShowDic setObject:@"1"
                                       forKey:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]];
                    
                    UITableView *tableView = self.tableArray[self.currentSelectNum];
                    [tableView reloadData];
                    
                }
            }
            /*******************/
            
        }else{
            
            [self.delegate showMultipleTableErrorMessage:obj.retMsg];
        }
       
        UITableView *tempTableView = self.tableArray[self.currentSelectNum];
        [tempTableView.mj_header endRefreshing];
        [tempTableView.mj_footer endRefreshing];
   }else if([self.currentApiName isEqualToString:WorldTopPic]){
       
      
       BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
       if ([obj.retCode intValue] == 0) {
           
           self.worldTopObj = obj;
           
           [self.cityMesDic setObject:obj forKey:[NSString stringWithFormat:@"%d",self.currentSelectNum]];
           
          
           /******/
           [self.dataPageDic setObject:@"1"
                                forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
           
           
           if (![self.cityMesTypeSelectDic objectForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]) {
        
               if ([obj.retData.isAllExist intValue] == 1) {
                   
                   [self.cityMesTypeSelectDic setObject:@"0" forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                   
                   
               }else{
                   
                   if ([obj.retData.isOnlyArticle intValue] == 1) {
                       
                       [self.cityMesTypeSelectDic setObject:@"0" forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                   }else{
                       
                       [self.cityMesTypeSelectDic setObject:@"1" forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
                       
                   }
                   
               }
           }
           
            [self getActivityTypeListRequest];
        
       }
   }else if ([self.currentApiName isEqualToString:GetActivityTypeList]){
       
       
       BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
    
       if ([obj.retCode intValue] == 0) {
           
           UITableView *tempTableView = self.tableArray[self.currentSelectNum];
           
           
           CMLCityMesHeaderView *headerView = [[CMLCityMesHeaderView alloc] initWith:self.worldTopObj andSecondTypeObj:obj];
           [headerView refrshCurrentViewWithIndex:[[self.cityMesTypeSelectDic objectForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue]
                                    andSecondIndex:[[self.typeDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue]];
           headerView.frame = CGRectMake(0,
                                         0,
                                         WIDTH,
                                         headerView.currentHeight);

           
           
           headerView.delegate = self;
           tempTableView.tableHeaderView = headerView;
           
       }
       
       [self setActivityListRequest];
       
   }
   else if ([self.currentApiName isEqualToString:Banner13]){
       
       BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
       if ([obj.retCode intValue] == 0) {
           
           self.worldTopMessageNarray = [NSMutableArray arrayWithArray:obj.retData.dataList];
      
       }
       
       [self setTodayRecommendRequest];
       
       
   }else if ([self.currentApiName isEqualToString:WorldTodayFocus]){
       
       BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
       if ([obj.retCode intValue] == 0) {
           
           [self.todayMessageNarray arrayByAddingObjectsFromArray:obj.retData.dataList];
       }
       
       UITableView *tableView = self.tableArray[0];
       self.worldFashionHeaderView = [[CMLWorldFashionHeaderView alloc] initWithObj:nil];
       self.worldFashionHeaderView.topScrollNarray  = self.worldTopMessageNarray;
       self.worldFashionHeaderView.todayFocusNarray = obj.retData.dataList;
       [self.worldFashionHeaderView refreshCurrentView];
       
       tableView.tableHeaderView = self.worldFashionHeaderView;
       
       [self setWorldStateRequest];
       
   }else if ([self.currentApiName isEqualToString:V4WorldStateList]){
       NSLog(@"%@", responseResult);
       [self.delegate multipleTableProgressSucess];
       
   
       BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
       
       
       if ([obj.retCode intValue] == 0) {
           
           if (obj.retData.dataList) {
               
               [self.dataCountDic setObject:[NSString stringWithFormat:@"%@",obj.retData.dataCount] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
              
               
               
               if ([[self.dataPageDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue] == 1) {
                   
                   
                   [self.dataSourceDic setObject:obj.retData.dataList forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
               }else{
                   
                   NSMutableArray *array = [NSMutableArray arrayWithArray:[self.dataSourceDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]]];
                   [array addObjectsFromArray:obj.retData.dataList];
                   [self.dataSourceDic setObject:array forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
               }
               
                   [self.isShowDic setObject:@"1"
                                      forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
               
                    UITableView *tableView = self.tableArray[self.currentSelectNum];
                   [tableView reloadData];

           }
           
       }else{
           
           [self.delegate showMultipleTableErrorMessage:obj.retMsg];
       }
       
       UITableView *tempTableView = self.tableArray[self.currentSelectNum];
       [tempTableView.mj_header endRefreshing];
       [tempTableView.mj_footer endRefreshing];

   }

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.delegate multipleTableProgressError];
    [self.delegate showMultipleTableErrorMessage:@"网络连接失败"];//1
    
    UITableView *tempTableView = self.tableArray[self.currentSelectNum];
    [tempTableView.mj_header endRefreshing];
    [tempTableView.mj_footer endRefreshing];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

    if (scrollView.tag == 100) {
    
        UITableView *tempTableView = self.tableArray[self.currentSelectNum];
        [tempTableView.mj_footer endRefreshing];
        [tempTableView.mj_header endRefreshing];
        
        self.currentSelectNum = scrollView.contentOffset.x/WIDTH;
        
        [self.delegate scrollToTempLoation:self.currentSelectNum];

        UITableView *currentTableView = self.tableArray[self.currentSelectNum];
        if ([[self.isShowDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue] == 1) {
            
            [currentTableView reloadData];
            
        }else{
            
            [currentTableView.mj_header beginRefreshing];
         
        }
    }
}

- (void) getActivityCellHeight{
    
    CMLActivityTVCell *cell = [[CMLActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"cell2"];
    [cell refrshActivityCellInActivityVC:nil];
    self.activityHeight = cell.cellheight;
}

- (void) getArticleCellHeight{
    
    CMLNewArticleTVCell *cell = [[CMLNewArticleTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"cell3"];
    [cell refrshArcticleCellInActivityVC:nil];
    self.articleHeight = cell.cellheight;
}

- (void) getReplaceCellHeight{

    ReplaceTVCell *cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"cell0"];
    [cell reloadCurrentCell];
    self.replaceHeight = cell.cellheight;
}

- (void) scrollToIndex:(int) index{

    [self.bgScrollView setContentOffset:CGPointMake(index*WIDTH, 0)];
    
    self.currentSelectNum = index;

    UITableView *tableView = self.tableArray[self.currentSelectNum];
    
    if ([[self.isShowDic valueForKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]] intValue] == 1) {
        
        [tableView reloadData];
        
    }else{
        
        [tableView.mj_header beginRefreshing];
    }

}
- (void) scrollCurrentTableViewToTop{

    UITableView *tempTableView = self.tableArray[self.currentSelectNum];
    [tempTableView setContentOffset:CGPointMake(0, 0)];

}
#pragma mark - CMLCityMesHeaderViewDelegate

- (void) selectIndex:(int)index andSecondIndex:(int) secondIndex andSecondTypeID:(NSNumber *) typeID{
   
    self.type = secondIndex;
    self.typeid = typeID;
    
    [self.typeDic setObject:[NSNumber numberWithInt:secondIndex] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    
    [self.cityMesTypeSelectDic setObject:[NSString stringWithFormat:@"%d",index] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    
    [self.dataPageDic setObject:@"1"
                         forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
    
    UITableView *tableView = self.tableArray[self.currentSelectNum];
    [tableView.mj_header beginRefreshing];

    
}

//- (void) selectIndex:(int) index{
//
//    [self.cityMesTypeSelectDic setObject:[NSString stringWithFormat:@"%d",index] forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
//
//    [self.dataPageDic setObject:@"1"
//                         forKey:[NSString stringWithFormat:@"%@",self.tagIDsArr[self.currentSelectNum]]];
//
//    UITableView *tableView = self.tableArray[self.currentSelectNum];
//    [tableView.mj_header beginRefreshing];
//
//}


- (void) changeCity:(NSNotification *) noti{
    NSDictionary *tempDic = (NSDictionary *)noti;
    NSDictionary *processDic = [tempDic valueForKey:@"object"];
    /***********************/
    for (int i = 0; i < self.tagIDsArr.count; i++) {
        if ([self.tagIDsArr[i] intValue] == [[processDic objectForKey:@"objId"] intValue]) {
            self.currentSelectNum = i;
        }
    }
    [self scrollToIndex:self.currentSelectNum];
    /*******************/
}

- (void) getUserPushAcivityCellHeight{
    
    CMLUserPushActivityTVCell *cell = [[CMLUserPushActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test1"];
    self.activityCellHeight = [cell getCurrentHeigth];
    
}

@end
