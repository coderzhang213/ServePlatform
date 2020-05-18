//
//  CMLTimeLineRelevantActivitySerachVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/20.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLTimeLineRelevantActivitySerachVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "SelectView.h"
//#import "NewSelectView.h"
#import "SearchResultsView.h"
#import "CMLActivityObj.h"
#import "MJRefresh.h"
#import "CMLRelevanceActivityTVCell.h"

#define TopViewHeight           100
#define SearchVCLeftMargin      20
#define SearchBarHeight         52

#define PageSize                20


@interface CMLTimeLineRelevantActivitySerachVC ()<NavigationBarProtocol,UITextFieldDelegate,NetWorkProtocol,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *searchBar;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,assign) BOOL isLoadMore;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;


@property (nonatomic,strong) NSMutableArray *ownActivityAciivityArray;

@property (nonatomic,strong) NSMutableArray *recommendActivityArray;

@property (nonatomic,strong) NSMutableArray *searchDataArray;

@property (nonatomic,copy) NSString *currentApiName;

@end

@implementation CMLTimeLineRelevantActivitySerachVC

- (NSMutableArray *)ownActivityAciivityArray{

    if (!_ownActivityAciivityArray) {
        _ownActivityAciivityArray = [NSMutableArray array];
    }
    
    return _ownActivityAciivityArray;
}

- (NSMutableArray *)recommendActivityArray{

    if (!_recommendActivityArray) {
        _recommendActivityArray = [NSMutableArray array];
    }
    
    return _recommendActivityArray;
}

- (NSMutableArray *)searchDataArray{

    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    
    return _searchDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    self.page = 1;
    [self loadTopSearchViews];
    
    [self loadViews];
    
    [self setSearchListRequest];
    
}

- (void) loadViews{

    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame),
                                                                         WIDTH,
                                                                         HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.mainScrollView];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - CGRectGetMaxY(self.navBar.frame) - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.hidden = YES;
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    
    
}

- (void) setSearchListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:NewMemberActivity paraDic:paraDic delegate:delegate];
    self.currentApiName = NewMemberActivity;
    
    [self startLoading];

}

- (UIView *) loadSearchDataWith:(NSArray *) dataArray andIsOwn:(BOOL) isOwn{

    UIView *currentView = [[UIView alloc] init];
    
    UIView *promView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                WIDTH,
                                                                75*Proportion)];
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                75*Proportion/2.0 - 26*Proportion/2.0,
                                                                1,
                                                                26*Proportion)];
    leftLine.backgroundColor = [UIColor CMLBrownColor];
    [promView addSubview:leftLine];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize13;
    promLab.textColor = [UIColor CMLBrownColor];
    if (isOwn) {
        
        promLab.text = @"我的活动";
    }else{
    
        promLab.text = @"最新活动";
    }
    [promLab sizeToFit];
    promLab.frame = CGRectMake(45*Proportion,
                               75*Proportion/2.0 - promLab.frame.size.height/2.0,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [promView addSubview:promLab];
    
    CMLLine *endLine = [[CMLLine alloc] init];
    endLine.lineWidth = 1*Proportion;
    endLine.lineLength = WIDTH;
    endLine.startingPoint = CGPointMake(0, promView.frame.size.height - 1*Proportion);
    endLine.LineColor = [UIColor CMLPromptGrayColor];
    [promView addSubview:endLine];
    
    if (dataArray.count == 0) {
        
        currentView.frame = CGRectMake(0,
                                       0,
                                       WIDTH,
                                       0);
        currentView.backgroundColor = [UIColor CMLWhiteColor];
        return currentView;
    }else{
    
        [currentView addSubview:promView];
        
        currentView.frame = CGRectMake(0,
                                       0,
                                       WIDTH,
                                       160*Proportion*dataArray.count + 75*Proportion);
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        
        CMLActivityObj *obj = [CMLActivityObj getBaseObjFrom:dataArray[i]];
        
        UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      160*Proportion*i + 75*Proportion,
                                                                      WIDTH,
                                                                      160*Proportion)];
        moduleView.backgroundColor = [UIColor CMLWhiteColor];
        [currentView addSubview:moduleView];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      160*Proportion - 1*Proportion,
                                                                      WIDTH - 30*Proportion*2,
                                                                      1*Proportion)];
        bottomLine.backgroundColor = [UIColor CMLPromptGrayColor];
        [moduleView addSubview:bottomLine];
        
        
        UIImageView *activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                   160*Proportion/2.0 - 90*Proportion/2.0,
                                                                                   160*Proportion,
                                                                                   90*Proportion)];
        activityImage.clipsToBounds = YES;
        activityImage.contentMode = UIViewContentModeScaleAspectFill;
        activityImage.userInteractionEnabled = YES;
        [moduleView addSubview:activityImage];
        [NetWorkTask setImageView:activityImage WithURL:obj.coverPicThumb placeholderImage:nil];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = KSystemFontSize14;
        titleLabel.numberOfLines = 0;
        titleLabel.text = obj.title;
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) +20*Proportion,
                                      160*Proportion/2.0 - titleLabel.frame.size.height*2/2,
                                      WIDTH - CGRectGetMaxX(activityImage.frame) - 20*Proportion*2,
                                      titleLabel.frame.size.height*2);
        [moduleView addSubview:titleLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:moduleView.bounds];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        
        if (isOwn) {
            
            [button addTarget:self action:@selector(selectOwnActivity:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
             [button addTarget:self action:@selector(selectRecommendActivity:) forControlEvents:UIControlEventTouchUpInside];
        }
        [moduleView addSubview:button];

    }
    
    return currentView;

}

- (void) selectOwnActivity:(UIButton *) btn{

    CMLActivityObj *obj = [CMLActivityObj getBaseObjFrom:self.ownActivityAciivityArray[btn.tag]];
    [self.delegate refreshRelevantActivityWith:obj.coverPicThumb activityID:obj.currentID activityTitle:obj.title];
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) selectRecommendActivity:(UIButton *) btn{

    CMLActivityObj *obj = [CMLActivityObj getBaseObjFrom:self.recommendActivityArray[btn.tag]];
    [self.delegate refreshRelevantActivityWith:obj.coverPicThumb activityID:obj.currentID activityTitle:obj.title];
    [[VCManger mainVC] dismissCurrentVC];
}


- (void) loadTopSearchViews{
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = KSystemFontSize15;
    [btn sizeToFit];
    [btn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.navBar.frame.size.width - btn.frame.size.width - SearchVCLeftMargin*Proportion*2,
                           TopViewHeight*Proportion/2.0 - btn.frame.size.height/2.0 + StatusBarHeight,
                           btn.frame.size.width + 40*Proportion,
                           btn.frame.size.height);
    btn.backgroundColor = [UIColor whiteColor];
    [self.navBar addSubview:btn];
    [btn addTarget:self action:@selector(dismissSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchBarBgView = [[UIView alloc] initWithFrame:CGRectMake(SearchVCLeftMargin*Proportion,
                                                                       (TopViewHeight*Proportion - SearchBarHeight*Proportion)/2.0 + StatusBarHeight,
                                                                       WIDTH - SearchVCLeftMargin*Proportion - btn.frame.size.width,
                                                                       SearchBarHeight*Proportion)];
    searchBarBgView.layer.cornerRadius = 4*Proportion;
    searchBarBgView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.navBar addSubview:searchBarBgView];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SearchBarImg]];
    image.frame = CGRectMake(SearchBarHeight*Proportion/3*0.5,
                             SearchBarHeight*Proportion/3*0.5,
                             SearchBarHeight*Proportion/3*2,
                             SearchBarHeight*Proportion/3*2);
    image.layer.cornerRadius = 4*Proportion;
    [searchBarBgView addSubview:image];
    
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(SearchBarHeight*Proportion,
                                                               0,
                                                               searchBarBgView.frame.size.width - CGRectGetMaxX(image.frame),
                                                               SearchBarHeight*Proportion)];
    _searchBar.placeholder = @"搜索关键字";
    _searchBar.font = KSystemFontSize12;
    _searchBar.layer.cornerRadius = 4*Proportion;
    _searchBar.tintColor = [UIColor CMLYellowColor];
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.delegate = self;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar addTarget:self action:@selector(monitoringTextfiled:) forControlEvents:UIControlEventEditingChanged];
    [searchBarBgView addSubview:_searchBar];
    /*********标签***************/
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) monitoringTextfiled:(UITextField *) textField{
    
    if (textField.text.length == 0) {
        self.mainTableView.hidden = YES;
        self.page = 1;
        [self.searchDataArray removeAllObjects];
        [self hiddenLoading];
    }else{
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setSearchRequest) withObject:nil afterDelay:0.5];
        
    }
}

- (void) setSearchRequest{
    
    [self searchMesage];
}

#pragma mark - UISearchBarDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    if (textField.text > 0 ) {
        [self.searchBar resignFirstResponder];
        [self searchMesage];
        return YES;
    }else{
        [self showFailTemporaryMes:@"输入搜索内容"];
        return NO;
    }
}

#pragma mark - search
- (void) searchMesage{
    
        if (self.isLoadMore) {
            
            [self startLoading];
        }else{
            
            [self showLoading];
        }
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
        [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
        [paraDic setObject:self.searchBar.text forKey:@"keyword"];
        [NetWorkTask getRequestWithApiName:V3ActivitySearch param:paraDic delegate:delegate];
        self.currentApiName = V3ActivitySearch;
}

#pragma mark - NavigationBarProtocol
- (void) dismissSearchVC{
    
    if (self.searchBar.text.length > 0) {
        
        self.searchBar.text = @"";
        
    }else{
        
        [[VCManger mainVC] dismissCurrentVC];
    }
}

#pragma mark - NetWorkProtocol

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewMemberActivity]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
    
            [self.ownActivityAciivityArray addObjectsFromArray:[obj.retData.userActivityInfo valueForKey:@"dataList"]];
            [self.recommendActivityArray addObjectsFromArray:[obj.retData.currentActivityInfo valueForKey:@"dataList"]];
            
            UIView *owenView = [self loadSearchDataWith:[obj.retData.userActivityInfo valueForKey:@"dataList"] andIsOwn:YES];
            [self.mainScrollView addSubview:owenView];
            
            UIView *newView = [self loadSearchDataWith:[obj.retData.currentActivityInfo valueForKey:@"dataList"] andIsOwn:NO];
            if (owenView.frame.size.height > 0) {
                
                UIView *spaeeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(owenView.frame), WIDTH, 20*Proportion)];
                spaeeView.backgroundColor = [UIColor CMLNewGrayColor];
                [self.mainScrollView addSubview:spaeeView];
            
                newView.frame = CGRectMake(0,
                                           CGRectGetMaxY(spaeeView.frame),
                                           newView.frame.size.width,
                                           newView.frame.size.height);
            }else{
                newView.frame = CGRectMake(0,
                                           0,
                                           newView.frame.size.width,
                                           newView.frame.size.height);
            
            }
            
            [self.mainScrollView addSubview:newView];
    
            
            self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(newView.frame));
            
        }else{
            
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:V3ActivitySearch]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
            
                self.searchDataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
                
            }else{
            
                [self.searchDataArray addObjectsFromArray:obj.retData.dataList];
            }
            self.mainTableView.hidden = NO;
            [self.mainTableView reloadData];
            
        }else if ([obj.retCode intValue] == 100101){
            

            [self showReloadView];
            
        }else{
            
           
            [self showFailTemporaryMes:obj.retMsg];
        }
        self.isLoadMore = NO;
        [self stopLoading];
        [self hiddenLoading];
        [self.mainTableView.mj_footer endRefreshing];
        
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    self.isLoadMore = NO;
    [self stopLoading];
    [self hiddenLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self.mainTableView.mj_footer endRefreshing];
    
  
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.searchBar resignFirstResponder];
}

- (void) loadMoreData{

    if (self.searchDataArray.count%PageSize == 0) {
        if (self.searchDataArray.count != self.dataCount) {
            self.page++;
            self.isLoadMore = YES;
            [self searchMesage];
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.searchDataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.searchDataArray.count > 0) {
      
        return 160*Proportion;
        
    }else{
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifer = @"cell";
    
    CMLRelevanceActivityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        cell = [[CMLRelevanceActivityTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (self.searchDataArray.count > 0) {
        
        CMLActivityObj *obj = [CMLActivityObj getBaseObjFrom:self.searchDataArray[indexPath.row]];
        cell.imageUrl = obj.coverPicThumb;
        cell.titile = obj.title;
    }
    [cell refreshTVCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CMLActivityObj *obj = [CMLActivityObj getBaseObjFrom:self.searchDataArray[indexPath.row]];
    [self.delegate refreshRelevantActivityWith:obj.coverPicThumb activityID:obj.currentID activityTitle:obj.title];
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) showLoading{
    
    if (self.loadingView) {
        
        self.loadingView.hidden = NO;
    }else{
        
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    TopViewHeight*Proportion + 2 + StatusBarHeight,
                                                                    WIDTH,
                                                                    HEIGHT - (TopViewHeight*Proportion + 2 + StatusBarHeight + SafeAreaBottomHeight))];
        self.loadingView.backgroundColor = [UIColor CMLWhiteColor];
        [self.contentView addSubview:self.loadingView];
        
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"]];
        UIImageView *LoadingImageView = [[UIImageView alloc] initWithImage:[UIImage sd_imageWithData:gif]];
        
        LoadingImageView.frame = CGRectMake(WIDTH/2.0 - 40*Proportion/2.0,
                                            20*Proportion,
                                            50*Proportion,
                                            50*Proportion);
        [self.loadingView addSubview:LoadingImageView];
        [self.contentView addSubview:self.loadingView];
    
    }
    [self.contentView bringSubviewToFront:self.loadingView];
}

- (void) hiddenLoading{
    
    self.loadingView.hidden = YES;
}

@end
