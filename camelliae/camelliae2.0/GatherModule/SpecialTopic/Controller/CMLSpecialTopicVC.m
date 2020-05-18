//
//  CMLSpecialTopicVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSpecialTopicVC.h"
#import "VCManger.h"
#import "CMLSpecialInfoTVCell.h"
#import "CMLSpecialActivityTVCell.h"
#import "CMLSpecialServeTVCell.h"
#import "CMLTopicObj.h"
#import "CMLWebLinkTVCell.h"
#import "MJRefresh.h"
#import "WebViewLinkVC.h"
#import "InformationDefaultVC.h"
#import "ServeDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ReplaceTVCell.h"
#import "CMLUserArticleVC.h"
#import "CMLCommodityDetailMessageVC.h"
#import "CMLSpecialGoodsTVCell.h"
#import "PackDetailInfoObj.h"

#define PageSize                15
#define TopImageHeight          240

@interface CMLSpecialTopicVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *viewLink;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,copy) NSString *ratio;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat currentCellHeight;

@property (nonatomic,assign) CGFloat replaceCellHeight;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,assign) int page;

@end


@implementation CMLSpecialTopicVC

- (instancetype)initWithImageUrl:(NSString *) imageUrl name:(NSString *) name shortTitle:(NSString *) shortTitle desc:(NSString *) desc viewLink:(NSString *) viewLink currentId:(NSNumber *) currentID {

    self = [super init];
    
    if (self) {
        
        self.imageUrl = imageUrl;
        self.name = name;
        self.desc = desc;
        self.viewLink = viewLink;
        self.currentID = currentID;
        self.shortTitle = shortTitle;
    }
    return self;
}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void) loadData{

    [self startLoading];
    [self setTopicListRequest];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfSpecialTopic"];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageTwoOfSpecialTopic"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   StatusBarHeight,
                                                                   80*Proportion,
                                                                   80*Proportion)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:NewTopicBackImg] forState:UIControlStateNormal];
    [self.contentView addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - 80*Proportion,
                                                                    StatusBarHeight,
                                                                    80*Proportion,
                                                                    80*Proportion)];
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setImage:[UIImage imageNamed:NewTopicShareImg] forState:UIControlStateNormal];
    [self.contentView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
    
        [weakSelf.dataArray removeAllObjects];
        [weakSelf hideNetErrorTipOfMainVC];
        [weakSelf loadMessageOfVC];
    
    };
    
}

- (void) loadMessageOfVC{

    [self getCurrentCellHeight];
    [self getReplaceTVCellHeight];
    self.page = 1;
    
    /********shareblock********/
    __weak typeof(self) weakSelf = self;
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       80*Proportion + StatusBarHeight + 20*Proportion,
                                                                       WIDTH,
                                                                       HEIGHT - (80*Proportion + StatusBarHeight + 20*Proportion +SafeAreaBottomHeight))
                                                      style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *mainTitle = [[UILabel alloc] init];
    mainTitle.text = self.name;
    mainTitle.font = KSystemRealBoldFontSize15;
    [mainTitle sizeToFit];
    mainTitle.textColor = [UIColor CMLBlackColor];
    mainTitle.frame =CGRectMake(WIDTH/2.0 - mainTitle.frame.size.width/2.0,
                                0,
                                mainTitle.frame.size.width,
                                mainTitle.frame.size.height);
    [bgView addSubview:mainTitle];
    
    UILabel *shortTitle = [[UILabel alloc] init];
    shortTitle.text = self.shortTitle;
    shortTitle.font = KSystemBoldFontSize14;
    [shortTitle sizeToFit];
    shortTitle.textColor = [UIColor CMLBlackColor];
    shortTitle.frame =CGRectMake(WIDTH/2.0 - shortTitle.frame.size.width/2.0,
                                CGRectGetMaxY(mainTitle.frame) + 20*Proportion*2,
                                shortTitle.frame.size.width,
                                shortTitle.frame.size.height);
    [bgView addSubview:shortTitle];
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.text = self.desc;
    descLab.font = KSystemBoldFontSize14;
    descLab.textAlignment = NSTextAlignmentCenter;
    descLab.numberOfLines = 0;
    CGRect currentRect= [descLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize15} context:NULL];
    descLab.frame = CGRectMake(0,
                                  CGRectGetMaxY(shortTitle.frame) + 40*Proportion,
                                  WIDTH,
                                  currentRect.size.height);
    descLab.textColor = [UIColor CMLBlackColor];
    [bgView addSubview:descLab];
    
    bgView.frame = CGRectMake(0,
                              0,
                              WIDTH,
                              CGRectGetMaxY(descLab.frame) + 30*Proportion);
    
    self.mainTableView.tableHeaderView = bgView;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    /**网络请求*/
    [self loadData];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,
                                 0,
                                 WIDTH,
                                 HEIGHT);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor CMLPromptGrayColor];
    [NetWorkTask setImageView:imageView WithURL:self.imageUrl placeholderImage:nil];
    
    self.baseShareLink = self.viewLink;
    self.baseShareImage = imageView.image;
    self.baseShareContent = self.desc;
    self.baseShareTitle = self.name;
    self.shareSuccessBlock = ^(){
        
        [weakSelf sendShareAction];
    };
    
    self.sharesErrorBlock = ^(){
        
        
    };
    
    /*****************/
}
- (void) setTopicListRequest{

    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.currentID forKey:@"bannerIndexId"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask getRequestWithApiName:BannerTopicDeail param:paraDic delegate:delegate];
    self.currentApiName = BannerTopicDeail;
    
    
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.dataArray[indexPath.row]];
        if ([currentObj.dataType intValue] == 1) {
            return self.currentCellHeight;
        }else{
           return 260*Proportion;
        }
    }else{
      return self.replaceCellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.dataArray) {
        return self.dataArray.count;
    }else{
        return 10;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
    
        CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        if ([currentObj.dataType intValue] == 1) {
        
            
            if ([currentObj.rootTypeId intValue] == 98) {
                static NSString *identifier = @"myTopicCell1";
                CMLSpecialInfoTVCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell1) {
                    cell1 = [[CMLSpecialInfoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
                cell1.desc = currentObj.briefIntro;
                cell1.title = currentObj.title;
                cell1.imageUrl = currentObj.coverPic;
                cell1.beginTimeStr = currentObj.publishTimeStr;
                cell1.city = currentObj.cityName;
                [cell1 refreshCurrentInfoCell];
                return cell1;
            }else if ([currentObj.rootTypeId intValue] == 1){
                static NSString *identifier = @"myTopicCell2";
                CMLSpecialInfoTVCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell1) {
                    cell1 = [[CMLSpecialInfoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell1.desc = currentObj.briefIntro;
                cell1.title = currentObj.title;
                cell1.city = currentObj.cityName;
                cell1.beginTimeStr = currentObj.publishTimeStr;
                cell1.imageUrl = currentObj.coverPic;
                [cell1 refreshCurrentInfoCell];
                return cell1;
                
            }else if ([currentObj.rootTypeId intValue] == 2){
                static NSString *identifier = @"mycell3";
                CMLSpecialActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[CMLSpecialActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.type = currentObj.rootTypeName;
                cell.title = currentObj.title;
                cell.imageUrl = currentObj.coverPic;
                cell.currentLvl = currentObj.memberLevelId;
                cell.beginTime = currentObj.actBeginTime;
                [cell refreshCurrentActivityCell];
                return cell;
            }else if ([currentObj.rootTypeId intValue] == 7){
                
                static NSString *identifier = @"mycell5";
                CMLSpecialGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[CMLSpecialGoodsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.typeName = currentObj.rootTypeName;
                cell.brandName = currentObj.brandName;
                cell.title = currentObj.title;
                cell.imageUrl = currentObj.coverPic;
                cell.isVerb = currentObj.is_deposit;
                
                
                if ([currentObj.is_pre intValue] == 1) {
                    
                    cell.price = currentObj.pre_price;
                }else{
                    
                    cell.price = currentObj.totalAmountMin;
                    
                }
                if ([currentObj.is_deposit intValue] == 1) {
                    
                    cell.price = currentObj.deposit_money;
                }
                
                cell.isPre = currentObj.is_pre;
                [cell refreshCurrentServeCell];
                return cell;
                
                
            } else{
                static NSString *identifier = @"mycell4";
                CMLSpecialServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[CMLSpecialServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.typeName = currentObj.rootTypeName;
                cell.brandName = currentObj.brandInfo.name;
                cell.title = currentObj.title;
                cell.imageUrl = currentObj.coverPic;
                cell.isHasPriceInterval = currentObj.isHasPriceInterval;
                PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[currentObj.packageInfo.dataList firstObject]];
                
                if ([costObj.payMode intValue] == 1) {
                    
                    cell.price = costObj.subscription;
                }else{
                    
                    cell.price = costObj.pre_totalAmount;
                }
                
                cell.isPre = costObj.is_pre;
                cell.isVerb = costObj.payMode;
                
                [cell refreshCurrentServeCell];
                return cell;
            }

        }else{
            static NSString *identifier = @"mycell4";
            CMLWebLinkTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CMLWebLinkTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.isTopicWeb = YES;
            [cell refreshCurrentCellWithImageUrl:currentObj.coverPic];
            return cell;
        }
        
    }else{
        static NSString *identifier = @"mycell5";
        ReplaceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell reloadCurrentCell];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.dataArray[indexPath.row]];
    
     if ([currentObj.dataType intValue] == 1) {
         if ([currentObj.rootTypeId intValue] == 1) {
             InformationDefaultVC *vc = [[InformationDefaultVC alloc] initWithObjId:currentObj.currentID];
             [[VCManger mainVC] pushVC:vc animate:YES];
             
         }else if ([currentObj.rootTypeId intValue] == 2){
             ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:currentObj.currentID];
             [[VCManger mainVC] pushVC:vc animate:YES];
             
         }else if([currentObj.rootTypeId intValue] == 3){
             
             ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:currentObj.currentID];
             [[VCManger mainVC] pushVC:vc animate:YES];
             
         }else if ([currentObj.rootTypeId intValue] == 98){
             
             CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:currentObj.currentID];
             [[VCManger mainVC] pushVC:vc animate:YES];
             
         }else if ([currentObj.rootTypeId intValue] == 7){
             
             CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:currentObj.currentID];
             [[VCManger mainVC] pushVC:vc animate:YES];
         }
     }else{
     
         WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
         vc.url = currentObj.viewLink;
         [[VCManger mainVC] pushVC:vc animate:YES];
     }
}

#pragma mark - NavigationBarProtocol

- (void) backVC{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) shareMessage{
    
    [self showCurrentVCShareView];

}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:BannerTopicDeail]) {
 

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            self.mainTableView.hidden = NO;
            [self.mainTableView reloadData];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            if (self.page > 1) {
                self.page--;
            }
            self.mainTableView.hidden = YES;
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }
    }
    
    [self hideNetErrorTipOfNormalVC];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:BannerTopicDeail]) {
        if (self.page > 1) {
            self.page--;
        }
    }
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView.mj_header endRefreshing];
}
#pragma mark - 获得cell高度
- (void) getCurrentCellHeight{

    CMLSpecialInfoTVCell *cell = [[CMLSpecialInfoTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    [cell refreshCurrentInfoCell];
    self.currentCellHeight = cell.currentHeight;
    
}

- (void) getReplaceTVCellHeight{

    ReplaceTVCell *cell = [[ReplaceTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    [cell reloadCurrentCell];
    self.replaceCellHeight = cell.cellheight;
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    if ([self.currentApiName isEqualToString:BannerTopicDeail]) {
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self setTopicListRequest];
            }else{
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark - enterNewActivityList

- (void) scrollViewScrollToTop{
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self hiddenCurrentVCShareView];
}


- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,[NSNumber numberWithInt:3],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}


@end
