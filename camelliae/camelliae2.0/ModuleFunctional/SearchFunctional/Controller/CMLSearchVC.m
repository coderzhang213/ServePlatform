//
//  CMLSearchVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSearchVC.h"
#import "VCManger.h"
#import "SelectView.h"
#import "NewSelectView.h"
#import "OldSearchView.h"
#import "SearchResultsView.h"

#define TopViewHeight           100
#define SearchVCLeftMargin      20
#define SearchBarHeight         52

@interface CMLSearchVC ()<NavigationBarProtocol,UITextFieldDelegate,NetWorkProtocol,NewSelectDelegate,OldSelectDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UITextField *searchBar;

@property (nonatomic,strong) NSArray *dataArray;

//@property (nonatomic,strong) NSArray *historyArray;

@property (nonatomic,strong) SearchResultsView *searchResultView;

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NewSelectView *selectView;

@property (nonatomic,strong) OldSearchView *oldSearchView;

@property (nonatomic,strong) NSMutableArray *newSearchContent;

@property (nonatomic,strong) NSMutableArray *allSearchContent;


@end

@implementation CMLSearchVC

- (NSMutableArray *)newSearchContent{
    
    if (!_newSearchContent) {
        _newSearchContent = [NSMutableArray array];
    }
    
    return _newSearchContent;
}

- (NSMutableArray *)allSearchContent{
    
    if (!_allSearchContent) {
        _allSearchContent = [NSMutableArray array];
    }
    
    return _allSearchContent;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(addSearchStr:)
     
                                                 name:@"search" object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"search" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBar.hidden = YES;
    /*****************************************************/
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    
    };
}


- (void) loadMessageOfVC{

    [self loadData];
}

- (void) loadData{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    [NetWorkTask getRequestWithApiName:SearchHot param:paraDic delegate:delegate];
    self.currentApiName = SearchHot;

}

- (void) setOldSearchRequest{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:SearchHistory param:paraDic delegate:delegate];
    self.currentApiName = SearchHistory;
}

- (void) setDeleteSearch{
    
   
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:SearchDelete param:paraDic delegate:delegate];
    self.currentApiName = SearchDelete;
}

- (void) setAddSearchRequest{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    
    NSMutableString *targetStr = [[NSMutableString alloc] initWithString:@"["];

    for (int i = 0; i < self.newSearchContent.count; i++) {

        if (i == self.newSearchContent.count - 1) {

            [targetStr appendString:[NSString stringWithFormat:@"\"%@\"",self.newSearchContent[i]]];

        }else{

            [targetStr appendString:[NSString stringWithFormat:@"\"%@\",",self.newSearchContent[i]]];
        }

    }
    [targetStr appendString:@"]"];
    

    [paraDic setObject:targetStr forKey:@"keyWordArr"];

    [NetWorkTask getRequestWithApiName:SearchAdd param:paraDic delegate:delegate];
    self.currentApiName = SearchAdd;

}

- (void) loadViews{

    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               TopViewHeight*Proportion + StatusBarHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOpacity = 0.05;
    topView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.contentView addSubview:topView];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = KSystemFontSize15;
    [btn sizeToFit];
    [btn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(topView.frame.size.width - btn.frame.size.width - SearchVCLeftMargin*Proportion*2,
                           TopViewHeight*Proportion/2.0 - btn.frame.size.height/2.0 + StatusBarHeight,
                           btn.frame.size.width + 40*Proportion,
                           btn.frame.size.height);
    btn.backgroundColor = [UIColor whiteColor];
    [topView addSubview:btn];
    [btn addTarget:self action:@selector(dismissSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchBarBgView = [[UIView alloc] initWithFrame:CGRectMake(SearchVCLeftMargin*Proportion,
                                                                      (TopViewHeight*Proportion - SearchBarHeight*Proportion)/2.0 + StatusBarHeight,
                                                                      WIDTH - SearchVCLeftMargin*Proportion - btn.frame.size.width,
                                                                       SearchBarHeight*Proportion)];
    searchBarBgView.layer.cornerRadius = 4*Proportion;
    searchBarBgView.backgroundColor = [UIColor CMLNewGrayColor];
    [topView addSubview:searchBarBgView];
    
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
    _searchBar.placeholder = @"搜索精彩内容";
    _searchBar.font = KSystemFontSize12;
    _searchBar.layer.cornerRadius = 4*Proportion;
    _searchBar.tintColor = [UIColor CMLYellowColor];
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.delegate = self;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBar addTarget:self action:@selector(monitoringTextfiled:) forControlEvents:UIControlEventEditingChanged];
    [searchBarBgView addSubview:_searchBar];
    [self performSelector:@selector(showSearchKeyBoard) withObject:nil afterDelay:0.2];
    /*********标签***************/
    
    self.oldSearchView = [[OldSearchView alloc] init];
    self.oldSearchView.contentLeftMargin = 20*Proportion;
    self.oldSearchView.contentTopMargin = 40*Proportion;
    self.oldSearchView.dataArray = self.allSearchContent;
    self.oldSearchView.delegate = self;
    [self.oldSearchView refreshOldSelectView];
    self.oldSearchView.frame = CGRectMake(0,
                                          CGRectGetMaxY(topView.frame) + 2,
                                          WIDTH,
                                          self.oldSearchView.selectViewHeight);
    [self.contentView addSubview:self.oldSearchView];
    
    self.selectView = [[NewSelectView alloc] init];
    self.selectView.contentLeftMargin = 20*Proportion;
    self.selectView.contentTopMargin = 40*Proportion;
    self.selectView.dataArray = self.dataArray;
    self.selectView.delegate = self;
    [self.selectView refreshSelectView];
    self.selectView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.oldSearchView.frame),
                                       WIDTH,
                                       HEIGHT - CGRectGetMaxY(self.oldSearchView.frame));
    [self.contentView addSubview:self.selectView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {

    if (textField.text > 0 ) {
        [self.searchBar resignFirstResponder];
        
        if (![self.allSearchContent containsObject:textField.text]) {
         
            [self.allSearchContent insertObject:textField.text atIndex:0];
            [self.newSearchContent addObject:textField.text];
            self.oldSearchView.dataArray = self.allSearchContent;
            [self.oldSearchView refreshOldSelectView];
            self.oldSearchView.frame = CGRectMake(0,
                                                  self.oldSearchView.frame.origin.y,
                                                  WIDTH,
                                                  self.oldSearchView.selectViewHeight);
            self.selectView.frame = CGRectMake(0,
                                               CGRectGetMaxY(self.oldSearchView.frame),
                                               WIDTH,
                                               HEIGHT - CGRectGetMaxY(self.oldSearchView.frame));
        }
        return YES;
    }else{
        return NO;
    }
}

- (void) monitoringTextfiled:(UITextField *) textField{
    
    if (textField.text.length == 0) {
        
        [self.searchResultView removeFromSuperview];
        [self hiddenLoading];
    }else{
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setSearchRequest) withObject:nil afterDelay:0.5];
        
    }
}


#pragma mark - search

- (void) setSearchRequest{
    
    [self searchMesage:self.searchBar.text];
}

- (void) searchMesage:(NSString *)keyword{

    if (keyword.length > 0) {
     
         [self showLoading];
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
        [paraDic setObject:keyword forKey:@"keyword"];
            [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"getMember"];
        [NetWorkTask getRequestWithApiName:Search param:paraDic delegate:delegate];
        self.currentApiName = Search;
    }
   
}

#pragma mark - NavigationBarProtocol
- (void) dismissSearchVC{

    if (self.searchBar.text.length > 0) {
        
        self.searchBar.text = @"";
         [self.searchResultView removeFromSuperview];
        
    }else{
    
        if (self.newSearchContent.count > 0) {
          
             [self setAddSearchRequest];
        }else{
            
            [[VCManger mainVC] dismissCurrentVC];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

#pragma mark - NetWorkProtocol

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:SearchHot]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
           self.dataArray = obj.retData.dataList;
            
            [self setOldSearchRequest];
          
        }else if ([obj.retCode intValue] == 100101){
            

            [self showReloadView];
            
        }else{
        
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:Search]){

        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
        if ([obj.retCode intValue] == 0 && obj) {
        
            if (self.searchBar.text.length != 0) {
             
                if ([obj.retData.keyword isEqualToString:self.searchBar.text]) {
                 
                    [self.searchResultView removeFromSuperview];
                    self.searchResultView = [[SearchResultsView alloc] initWithFrame:CGRectMake(0,
                                                                                                TopViewHeight*Proportion + 2 + StatusBarHeight,
                                                                                                WIDTH,
                                                                                                HEIGHT - (TopViewHeight*Proportion + 2) - SafeAreaBottomHeight - StatusBarHeight)];
                    self.searchResultView.backgroundColor = [UIColor whiteColor];
                    self.searchResultView.searchStr = self.searchBar.text;
                    self.searchResultView.dataArray = obj.retData.dataList;
                    [self.contentView addSubview:self.searchResultView];
                }
            }
            
        }else if ([obj.retCode intValue] == 100101){
            

            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
    
        [self hiddenLoading];
    }else if ([self.currentApiName isEqualToString:SearchHistory]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
 
            [self.allSearchContent removeAllObjects];
            
            for (int i = 0; i < obj.retData.historyArr.count; i++) {
                
                NSDictionary *tempDic = obj.retData.historyArr[i];
                [self.allSearchContent addObject:[tempDic valueForKey:@"content"]];
            }
            [self loadViews];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:SearchAdd]){
        
        [[VCManger mainVC] dismissCurrentVC];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }else{
        
        [self stopLoading];
        [self.allSearchContent removeAllObjects];
        [self.newSearchContent removeAllObjects];
        self.oldSearchView.dataArray = self.allSearchContent;
        [self.oldSearchView refreshOldSelectView];
        self.oldSearchView.frame = CGRectMake(0,
                                              self.oldSearchView.frame.origin.y,
                                              WIDTH,
                                              self.oldSearchView.selectViewHeight);
        self.selectView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.oldSearchView.frame),
                                           WIDTH,
                                           HEIGHT - CGRectGetMaxY(self.oldSearchView.frame));
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
   
    [self hiddenLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfMainVC];
}

- (void) showSearchKeyBoard{

    [self.searchBar becomeFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.searchBar resignFirstResponder];
}

- (void) selectIndex:(NSInteger) index title:(NSString *)title{
    
    self.searchBar.text = title;
    [self.searchBar resignFirstResponder];
    [self searchMesage:title];
}

- (void) selectOldSearchIndex:(NSInteger) index title:(NSString *)title{
    
    self.searchBar.text = title;
    [self.searchBar resignFirstResponder];
    [self searchMesage:title];
}

- (void)deleteAllSearch{
    
    [self startLoading];
    [self setDeleteSearch];
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

- (void) addSearchStr:(NSNotification *) noti{
    
    NSDictionary *info = [noti object];
    
    
    if (![self.allSearchContent containsObject:[info objectForKey:@"searchStr"]]) {

        [self.allSearchContent insertObject:[info objectForKey:@"searchStr"] atIndex:0];
        [self.newSearchContent addObject:[info objectForKey:@"searchStr"]];
        self.oldSearchView.dataArray = self.allSearchContent;
        [self.oldSearchView refreshOldSelectView];
        self.oldSearchView.frame = CGRectMake(0,
                                              self.oldSearchView.frame.origin.y,
                                              WIDTH,
                                              self.oldSearchView.selectViewHeight);
        self.selectView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.oldSearchView.frame),
                                           WIDTH,
                                           HEIGHT - CGRectGetMaxY(self.oldSearchView.frame));
    }
}
@end
