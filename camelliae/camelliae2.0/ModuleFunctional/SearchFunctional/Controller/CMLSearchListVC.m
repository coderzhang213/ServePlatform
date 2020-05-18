//
//  CMLSearchListVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSearchListVC.h"
#import "VCManger.h"
#import "InformationTVCell.h"
#import "ActivityTVCell.h"
#import "ServeTVCell.h"
#import "SearchResultObj.h"
#import "InformationDefaultVC.h"
#import "ActivityDefaultVC.h"
#import "ServeDefaultVC.h"
#import "MJRefresh.h"
#import "SelectView.h"
#import "ActivityTypeObj.h"
#import "CMLUserArticleVC.h"
#import "PackDetailInfoObj.h"

#define PageSize 10

#define SearchListConditionViewHeight     60
#define BtnImgAndTextSpace                20

@interface CMLSearchListVC ()<NavigationBarProtocol,UITableViewDataSource,UITableViewDelegate,NetWorkProtocol,SelectDelegate>

@property (nonatomic,copy) NSString *searchStr;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) UIView *conditionView;

@property (nonatomic,strong) UIButton *memberLevelbtn;

@property (nonatomic,strong) UIButton *timeBtn;

@property (nonatomic,strong) UIButton *isOfficalBtn;

@property (nonatomic,strong) UIButton *serveClassBtn;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) SelectView *selectView;

@property (nonatomic,strong) NSMutableDictionary *selectConditionDic;

@property (nonatomic,copy) NSString *currentSearchCondition;

/**********/
@property (nonatomic,assign) int currentTypeId;

@property (nonatomic,assign) int currentOrderById;

@property (nonatomic,assign) int allowMemberLevelId;

@property (nonatomic,assign) int objTypeId;

/************/
@property (nonatomic,strong) NSMutableArray *attributeArray;

@property (nonatomic,strong) NSMutableArray *attributeIdArray;

@property (nonatomic,assign) int currentLvlId;

@end


@implementation CMLSearchListVC

- (NSMutableArray *)attributeArray{

    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

- (NSMutableArray *)attributeIdArray{

    if (!_attributeIdArray) {
        _attributeIdArray = [NSMutableArray array];
    }
    return _attributeIdArray;
}
- (instancetype)initWithSearchStr:(NSString *)searchStr name:(NSString *)name{

    self = [super init];
    if (self) {
        
        self.searchStr = searchStr;
        self.name = name;
    }
    return self;
}

-(NSMutableDictionary *)selectConditionDic{

    if (!_selectConditionDic) {
        _selectConditionDic = [NSMutableDictionary dictionary];
    }
    return _selectConditionDic;
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent =  [NSString stringWithFormat:@"“%@”%@",self.searchStr,self.name];
    self.navBar.delegate = self;
    self.navBar.titleColor = [UIColor CMLUserBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navBar.layer.shadowOpacity = 0.05;
    self.navBar.layer.shadowOffset = CGSizeMake(0, 2);
    [self.navBar setLeftBarItem];
    
    [self.attributeArray addObject:@"全部"];
    [self.attributeIdArray addObject:[NSNumber numberWithInt:0]];
    self.currentLvlId = 0;
    self.currentTypeId = 0;
    self.currentOrderById = 0;
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf.selectConditionDic removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };

}

- (void) loadMessageOfVC{

    self.page = 1;
    self.currentTypeId = 0;
    self.currentOrderById = 0;
    self.allowMemberLevelId = 0;
    self.objTypeId = 0;
    [self.selectConditionDic setObject:[NSNumber numberWithInt:0] forKey:@"等级"];
    [self.selectConditionDic setObject:[NSNumber numberWithInt:0] forKey:@"类型"];
    [self.selectConditionDic setObject:[NSNumber numberWithInt:0] forKey:@"排序"];
    /*************************/
    
    [self loadViews];
    
    [self loadData];
}

- (void) loadData{

    if ([self.name isEqualToString:@"文章"]) {

        [self setInformationSeachRequestWith:self.name];
        
    }else if ([self.name isEqualToString:@"活动"]){
        
        [self getActivityTypeListRequest];
        
    }else{
        
        [self setServeRequest];
        
    }
    [self startLoading];
}

- (void) loadViews{

    if ([self.name isEqualToString:@"文章"]) {
//
        self.conditionView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navBar.frame)+2 , 0, 1)];
        [self.contentView addSubview:self.conditionView];
//
//
    }else if ([self.name isEqualToString:@"活动"] ){


        self.conditionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.navBar.frame)+2,
                                                                      WIDTH,
                                                                      SearchListConditionViewHeight*Proportion)];
        self.conditionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.conditionView];

        self.memberLevelbtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH/3.0,
                                                                         SearchListConditionViewHeight*Proportion)];
        [self.memberLevelbtn setTitle:@"等级" forState:UIControlStateNormal];
        [self.memberLevelbtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [self.memberLevelbtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.memberLevelbtn setImage:[UIImage imageNamed:PersonalCenterUserOpenUpImg] forState:UIControlStateNormal];
        [self.memberLevelbtn setImage:[UIImage imageNamed:PersonalCenterUserPackingUpImg] forState:UIControlStateSelected];
        CGSize strSize = [self.memberLevelbtn.currentTitle sizeWithFontCompatible:KSystemFontSize13];
        [self.memberLevelbtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                                - self.memberLevelbtn.currentImage.size.width*2 - BtnImgAndTextSpace*Proportion,
                                                                0,
                                                                0)];
        [self.memberLevelbtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                                strSize.width + self.memberLevelbtn.currentImage.size.width*2 + BtnImgAndTextSpace*Proportion,
                                                                0,
                                                                0)];
        self.memberLevelbtn.titleLabel.font = KSystemFontSize13;
        self.memberLevelbtn.tag = 1;
        [self.conditionView addSubview:self.memberLevelbtn];
        [self.memberLevelbtn addTarget:self action:@selector(showSearchCondition:) forControlEvents:UIControlEventTouchUpInside];


        self.timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3.0,
                                                                  0,
                                                                  WIDTH/3.0,
                                                                  SearchListConditionViewHeight*Proportion)];
        [self.timeBtn setTitle:@"类型" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [self.timeBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.timeBtn setImage:[UIImage imageNamed:PersonalCenterUserOpenUpImg] forState:UIControlStateNormal];
        [self.timeBtn setImage:[UIImage imageNamed:PersonalCenterUserPackingUpImg] forState:UIControlStateSelected];
        CGSize strSize1 = [self.timeBtn.currentTitle sizeWithFontCompatible:KSystemFontSize13];
        [self.timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                          - self.timeBtn.currentImage.size.width*2 - BtnImgAndTextSpace*Proportion,
                                                          0,
                                                          0)];
        [self.timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                          strSize1.width + self.timeBtn.currentImage.size.width*2 + BtnImgAndTextSpace*Proportion,
                                                          0,
                                                          0)];

        self.timeBtn.titleLabel.font = KSystemFontSize13;
        self.timeBtn.tag = 2;
        [self.conditionView addSubview:self.timeBtn];
        [self.timeBtn addTarget:self action:@selector(showSearchCondition:) forControlEvents:UIControlEventTouchUpInside];


        self.isOfficalBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3.0*2.0,
                                                                       0,
                                                                       WIDTH/3.0,
                                                                       SearchListConditionViewHeight*Proportion)];
        [self.isOfficalBtn setTitle:@"排序" forState:UIControlStateNormal];
        [self.isOfficalBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
        [self.isOfficalBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.isOfficalBtn setImage:[UIImage imageNamed:PersonalCenterUserOpenUpImg] forState:UIControlStateNormal];
        [self.isOfficalBtn setImage:[UIImage imageNamed:PersonalCenterUserPackingUpImg] forState:UIControlStateSelected];
        CGSize strSize2 = [self.isOfficalBtn.currentTitle sizeWithFontCompatible:KSystemFontSize13];
        [self.isOfficalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                               - self.isOfficalBtn.currentImage.size.width*2 - BtnImgAndTextSpace*Proportion ,
                                                               0,
                                                               0)];
        [self.isOfficalBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                               strSize2.width + self.isOfficalBtn.currentImage.size.width*2 + BtnImgAndTextSpace*Proportion,
                                                               0,
                                                               0)];
        self.isOfficalBtn.titleLabel.font = KSystemFontSize13;
        self.isOfficalBtn.tag = 3;
        [self.conditionView addSubview:self.isOfficalBtn];
        [self.isOfficalBtn addTarget:self action:@selector(showSearchCondition:) forControlEvents:UIControlEventTouchUpInside];


        CMLLine *lineOne = [[CMLLine alloc] init];
        lineOne.lineWidth = 0.5;
        lineOne.LineColor = [UIColor CMLPromptGrayColor];
        lineOne.directionOfLine = VerticalLine;
        lineOne.startingPoint = CGPointMake(WIDTH/3.0, (SearchListConditionViewHeight*Proportion - strSize.height)/2.0);
        lineOne.lineLength = strSize.height;
        [self.conditionView addSubview:lineOne];

        CMLLine *lineTwo = [[CMLLine alloc] init];
        lineTwo.lineWidth = 0.5;
        lineTwo.LineColor = [UIColor CMLPromptGrayColor];
        lineTwo.directionOfLine = VerticalLine;
        lineTwo.startingPoint = CGPointMake(WIDTH/3.0*2, (SearchListConditionViewHeight*Proportion - strSize.height)/2.0);
        lineTwo.lineLength = strSize.height;
        [self.conditionView addSubview:lineTwo];


        CMLLine *lineThree = [[CMLLine alloc] init];
        lineThree.lineWidth = 0.5;
        lineThree.LineColor = [UIColor CMLPromptGrayColor];
        lineThree.startingPoint = CGPointMake(0, SearchListConditionViewHeight*Proportion - 0.5);
        lineThree.lineLength = WIDTH;
        [self.conditionView addSubview:lineThree];



    }else{
        
        self.conditionView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navBar.frame)+2 , 0, 1)];
        [self.contentView addSubview:self.conditionView];
//
//        self.conditionView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                      CGRectGetMaxY(self.navBar.frame)+2,
//                                                                      WIDTH,
//                                                                      SearchListConditionViewHeight*Proportion)];
//        self.conditionView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.conditionView];
//
//        self.currentSearchCondition = @"生活类别";
//
//        self.serveClassBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                        0,
//                                                                        WIDTH,
//                                                                        SearchListConditionViewHeight*Proportion)];
//        [self.serveClassBtn setTitle:@"生活类别" forState:UIControlStateNormal];
//        [self.serveClassBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateSelected];
//        [self.serveClassBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
//        [self.serveClassBtn setImage:[UIImage imageNamed:PersonalCenterUserOpenUpImg] forState:UIControlStateNormal];
//        [self.serveClassBtn setImage:[UIImage imageNamed:PersonalCenterUserPackingUpImg] forState:UIControlStateSelected];
//        CGSize strSize = [self.serveClassBtn.currentTitle sizeWithFontCompatible:KSystemFontSize13];
//
//        [self.serveClassBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
//                                                                - self.serveClassBtn.currentImage.size.width*2 - BtnImgAndTextSpace*Proportion*2 ,
//                                                                0,
//                                                                0)];
//        [self.serveClassBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
//                                                                strSize.width + self.serveClassBtn.currentImage.size.width*2 + BtnImgAndTextSpace*Proportion*2,
//                                                                0,
//                                                                0)];
//        self.serveClassBtn.titleLabel.font = KSystemFontSize13;
//        [self.conditionView addSubview:self.serveClassBtn];
//        [self.serveClassBtn addTarget:self action:@selector(showServeSearchCondition) forControlEvents:UIControlEventTouchUpInside];
//
//        CMLLine *lineThree = [[CMLLine alloc] init];
//        lineThree.lineWidth = 0.5;
//        lineThree.LineColor = [UIColor CMLPromptGrayColor];
//        lineThree.startingPoint = CGPointMake(0, SearchListConditionViewHeight*Proportion - 0.5);
//        lineThree.lineLength = WIDTH;
//        [self.conditionView addSubview:lineThree];
//
//
    }

    
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.conditionView.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.conditionView.frame) - 2 - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor whiteColor];
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
    
    /**阴影*/
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.conditionView.frame),
                                                               WIDTH,
                                                               HEIGHT - CGRectGetMaxY(self.conditionView.frame))];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.contentView addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.dataArray.count <= 0 ) {
        
        return 0;
    }else{
       
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 240*Proportion;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.name isEqualToString:@"文章"]) {
        if (self.dataArray.count > 0) {
           
            SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
            
            static NSString *identifier = @"myCell1";
            InformationTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[InformationTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.brief = obj.briefIntro;
            cell.subType = obj.subTypeName;
            cell.time = obj.publishTimeStr;
            [cell refreshCurrentInformationTVCell:obj.objCoverPic andTitle:obj.title];
            return cell;
            
        }else{
        
            static NSString *identifier = @"myCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
        
        }
    }else if ([self.name isEqualToString:@"活动"]){
    
        if (self.dataArray.count > 0) {
            
            SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
            
            static NSString *identifier = @"myCell3";
            ActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.imageUrl = obj.objCoverPic;
            cell.title = obj.title;
            cell.brief = obj.briefIntro;
            cell.memberLevelId = obj.memberLevelId;
            cell.begintime = obj.actBeginTime;
            [cell refreshCurrentActivityCell];
            return cell;
            
        }else{
            
            static NSString *identifier = @"myCell4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
            
        }
    
    }else{
    
        if (self.dataArray.count > 0) {
            
            SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
            
            static NSString *identifier = @"myCell5";
            ServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.imageUrl = obj.objCoverPic;
            cell.title = obj.title;
            cell.brief = obj.briefIntro;
            cell.subTypeName = obj.subTypeName;
            cell.parentTypeName = obj.parentTypeName;
            cell.totalAmount = obj.price;
            PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[obj.packageInfo.dataList firstObject]];
            cell.payMode = costObj.payMode;
            cell.is_pre = costObj.is_pre;
            [cell refreshCurrentServeCell];
            return cell;
            
        }else{
        
            
            static NSString *identifier = @"myCell6";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
            
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.name isEqualToString:@"文章"]) {
        
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        CMLUserArticleVC *vc = [[CMLUserArticleVC alloc] initWithObj:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if ([self.name isEqualToString:@"活动"]){
    
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
    
        SearchResultObj *obj = [SearchResultObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        ServeDefaultVC *vc = [[ServeDefaultVC alloc] initWithObjId:obj.currentID];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}


- (void) setInformationSeachRequestWith:(NSString *) name{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDic setObject:self.searchStr forKey:@"keyword"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask getRequestWithApiName:InformationSearch param:paraDic delegate:delegate];
    self.currentApiName = InformationSearch;
    
}

- (void) setActivityRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDic setObject:self.searchStr forKey:@"keyword"];
    [paraDic setObject:[NSNumber numberWithInt:self.currentTypeId] forKey:@"parentType"];
    
    if (self.currentOrderById == 0) {
        
        [paraDic setObject:[NSNumber numberWithInt:6] forKey:@"orderById"];
    }else if (self.currentOrderById == 1){
        
        [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"orderById"];
    
    }else if (self.currentOrderById == 2){
    
        [paraDic setObject:[NSNumber numberWithInt:4] forKey:@"orderById"];
    }
    
    [paraDic setObject:[NSNumber numberWithInt:self.allowMemberLevelId] forKey:@"memberLevelId"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask getRequestWithApiName:V3ActivitySearch param:paraDic delegate:delegate];
    self.currentApiName = V3ActivitySearch;
    
    
}

- (void) setServeRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [paraDic setObject:self.searchStr forKey:@"keyword"];
    if (self.objTypeId != 0) {
        [paraDic setObject:[NSNumber numberWithInt:self.objTypeId] forKey:@"objTypeId"];
    }
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [NetWorkTask getRequestWithApiName:ServeSearch param:paraDic delegate:delegate];
    self.currentApiName = ServeSearch;

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:InformationSearch]) {
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
             
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
            
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
    
            
            [self showTableViewFooterMessageWithData:self.dataArray andTitle:@"暂无该类文章"];
            
            [self.mainTableView reloadData];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        
    }else if ([self.currentApiName isEqualToString:V3ActivitySearch]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
           
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            [self showTableViewFooterMessageWithData:self.dataArray andTitle:@"暂无该类活动"];
            
            [self.mainTableView reloadData];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
    
    }  if ([self.currentApiName isEqualToString:GetActivityTypeList]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                ActivityTypeObj *activityObj = [ActivityTypeObj getBaseObjFrom:obj.retData.dataList[i]];
                [self.attributeArray addObject:activityObj.typeName];
                [self.attributeIdArray addObject:activityObj.typeId];
            }
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self setActivityRequest];
        
    }else if([self.currentApiName isEqualToString:ServeSearch]){
    
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            
            [self showTableViewFooterMessageWithData:self.dataArray andTitle:@"暂无该类商城服务"];
            
            [self.mainTableView reloadData];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }

    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    [self stopLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.mainTableView.mj_header endRefreshing];
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self showFailTemporaryMes:@"网络连接错误"];
    [self showNetErrorTipOfNormalVC];

}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    [self.dataArray removeAllObjects];
    self.page = 1;
    if ([self.currentApiName isEqualToString:InformationSearch]) {
    
        [self setInformationSeachRequestWith:self.searchStr];
        
    }else if ([self.currentApiName isEqualToString:V3ActivitySearch]){
        
        [self setActivityRequest];
        
    }else{
    
        [self setServeRequest];
    }
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if ([self.currentApiName isEqualToString:InformationSearch]) {
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                
                [self setSearchStr:self.searchStr];
                
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else if ([self.currentApiName isEqualToString:V3ActivitySearch]){
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self setActivityRequest];
                
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
    
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != self.dataCount) {
                self.page++;
                [self setServeRequest];
                
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    
    }
}

- (void) showSearchCondition:(UIButton *)button{

    button.selected = !button.selected;
    for (int i = 1; i <= 3; i++) {
        
        if (i != button.tag) {
            UIButton *button = [self.conditionView viewWithTag:i];
            button.selected = NO;
        }
    }
    
    switch (button.tag) {
        case 1:
            self.currentSearchCondition = @"等级";
            break;
        case 2:
            self.currentSearchCondition = @"类型";
            break;
        case 3:
            self.currentSearchCondition = @"排序";
            break;
        default:
            break;
    }
    
    if (button.selected) {
    
        self.shadowView.hidden = NO;
        
        [self.selectView removeFromSuperview];
        
        self.selectView = [[SelectView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       WIDTH,
                                                                       0)];
        self.selectView.contentLeftMargin = 20*Proportion;
        self.selectView.contentTopMargin = 40*Proportion;
        self.selectView.backgroundColor = [UIColor whiteColor];
        self.selectView.buttontitleColor = [UIColor CMLPromptGrayColor];
        self.selectView.delegate = self;
        switch (button.tag) {
            case 1:
                self.selectView.dataArray = @[@"所有级别",@"粉色",@"黛色",@"金色",@"墨色"];
                break;
            case 2:
                self.selectView.dataArray = self.attributeArray;
                break;
            case 3:
                self.selectView.dataArray = @[@"最近开始",@"人气最高",@"最新上传"];
                break;
                
            default:
                break;
        }
        self.selectView.isSelectedState = YES;
        
        NSString *searchCondition;
        switch (button.tag) {
            case 1:
                searchCondition = @"等级";
                break;
            case 2:
                searchCondition = @"类型";
                break;
            case 3:
                searchCondition = @"排序";
                break;
                
            default:
                break;
        }
        
        if ([self.selectConditionDic valueForKey:searchCondition]) {
            
            self.selectView.currentIndex = [[self.selectConditionDic valueForKey:searchCondition] intValue];
        }
        
         [self.selectView refreshSelectView];
        self.selectView.frame = CGRectMake(0,
                                           0,
                                           WIDTH,
                                           self.selectView.selectViewHeight);
        
        [self.shadowView addSubview:self.selectView];
        
    }else{

        self.shadowView.hidden = YES;
        [self.selectView removeFromSuperview];
    }
}

//- (void) showServeSearchCondition{
//
//    self.serveClassBtn.selected = !self.serveClassBtn.selected;
//
//    if (self.serveClassBtn.selected) {
//
//        self.shadowView.hidden = NO;
//
//        [self.selectView removeFromSuperview];
//
//        self.selectView = [[SelectView alloc] initWithFrame:CGRectMake(0,
//                                                                       0,
//                                                                       WIDTH,
//                                                                       0)];
//        self.selectView.contentLeftMargin = 20*Proportion;
//        self.selectView.contentTopMargin = 40*Proportion;
//        self.selectView.backgroundColor = [UIColor whiteColor];
//        self.selectView.delegate = self;
//        self.selectView.dataArray = @[@"所有类别",@"成长",@"旅游",@"生活"];
//        self.selectView.isSelectedState = YES;
//
//        if ([self.selectConditionDic valueForKey:self.currentSearchCondition]) {
//
//            self.selectView.currentIndex = [[self.selectConditionDic valueForKey:self.currentSearchCondition] intValue];
//        }
//
//        [self.selectView refreshSelectView];
//        self.selectView.frame = CGRectMake(0,
//                                           0,
//                                           WIDTH,
//                                           self.selectView.selectViewHeight);
//
//        [self.shadowView addSubview:self.selectView];
//
//    }else{
//
//        self.shadowView.hidden = YES;
//        [self.selectView removeFromSuperview];
//    }
//
//
//}
#pragma mark - SelectDelegate
- (void) selectIndex:(NSInteger) index title:(NSString *)title{
 
    self.shadowView.hidden = YES;
    self.memberLevelbtn.selected = NO;
    self.timeBtn.selected = NO;
    self.isOfficalBtn.selected = NO;
    self.serveClassBtn.selected = NO;
    [self.selectView removeFromSuperview];
    

    [self.selectConditionDic setObject:[NSNumber numberWithInteger:index] forKey:self.currentSearchCondition];
    
    if ([self.name isEqualToString:@"活动"]) {
        
        if ([self.currentSearchCondition isEqualToString:@"等级"]) {
            
            self.allowMemberLevelId = [[self.selectConditionDic valueForKey:@"等级"] intValue];
        }
        if ([self.currentSearchCondition isEqualToString:@"类型"]){

            self.currentTypeId = [[self.selectConditionDic valueForKey:@"类型"] intValue];
            self.currentTypeId = [self.attributeIdArray[index] intValue];
        }
        if ([self.currentSearchCondition isEqualToString:@"排序"]){
            

            self.currentOrderById = [[self.selectConditionDic valueForKey:@"排序"] intValue];
    
        }
        
        [self.mainTableView.mj_header beginRefreshing];
    }else{
    
        if ([self.selectConditionDic valueForKey:self.currentSearchCondition]) {
         
             self.objTypeId = [[self.selectConditionDic valueForKey:self.currentSearchCondition] intValue];
            
            [self.mainTableView.mj_header beginRefreshing];
        }
    }
}

- (void) showTableViewFooterMessageWithData:(NSArray *)dataArray andTitle:(NSString *) title{

    if (dataArray.count == 0) {
        UIView *MessageView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.mainTableView.frame.size.width,
                                                                       self.mainTableView.frame.size.height)];
        MessageView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = KSystemFontSize13;
        label.textColor = [UIColor CMLtextInputGrayColor];
        [label sizeToFit];
        label.frame = CGRectMake(0,
                                 0,
                                 label.frame.size.width,
                                 label.frame.size.height);
        label.center = MessageView.center;
        [MessageView addSubview:label];
        
        self.mainTableView.tableFooterView = MessageView;
    }else{
        
        self.mainTableView.tableFooterView = [[UIView alloc] init];
    }
}

- (void) getActivityTypeListRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]]
                forKey:@"reqTime"];
    [paraDic setObject:self.searchStr
                forKey:@"Keyword"];
    [NetWorkTask getRequestWithApiName:GetActivityTypeList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = GetActivityTypeList;
    
    [self startLoading];
}

@end
