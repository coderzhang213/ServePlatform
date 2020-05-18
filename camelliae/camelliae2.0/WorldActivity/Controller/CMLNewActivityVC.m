//
//  CMLNewActivityVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/10/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLNewActivityVC.h"
#import "CMLSelectScrollView.h"
#import "ActivityTypeObj.h"
#import "CMLMultipleTableView.h"


#define SelectViewTopMragin         80
#define SelectViewHeight            80
#define SegmentedControlHeight      52
#define SegmentedControlWidth       320

@interface CMLNewActivityVC ()<SelectScrollViewDelegate,UIScrollViewDelegate,NetWorkProtocol,CMLMultipleTableViewDelegate>

@property (nonatomic,strong) CMLSelectScrollView *selectScrollView;

@property (nonatomic,strong) NSMutableArray *attributeArray;

@property (nonatomic,strong) NSMutableArray *attributeIdArray;

@property (nonatomic,strong) UIButton *activtyBtn;

@property (nonatomic,assign) int currentSelectNum;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isInit;


@property (nonatomic,strong) CMLMultipleTableView *multipleTableView;


@end

@implementation CMLNewActivityVC


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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCheckCity:) name:@"changeCity" object:nil];
    self.navBar.hidden = YES;
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf.attributeArray removeAllObjects];
        [weakSelf.attributeIdArray removeAllObjects];
        
        [weakSelf hideNetErrorTipOfMainVC];
        [weakSelf loadMessageOfVC];
    };
}

- (void) loadMessageOfVC{
    
    [self getActivityTypeListRequest];
    
    /**当前选择*/
    self.currentSelectNum = 0;
    
    self.isInit = NO;
    
    [self.attributeArray addObject:@"全部"];
    
    
    /***********/
    [self.attributeIdArray addObject:[NSNumber numberWithInt:0]];

}

- (void) loadViews{
    
    
    /**选择框*/
    self.selectScrollView = [[CMLSelectScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                  StatusBarHeight,
                                                                                  WIDTH,
                                                                                  SelectViewHeight*Proportion)];
    self.selectScrollView.delgate = self;
    self.selectScrollView.leftAndRightMargin = 20*Proportion;
    self.selectScrollView.itemNameSize = KSystemBoldFontSize16;
    self.selectScrollView.itemsSpace = 40*Proportion;
    self.selectScrollView.selectColor = [UIColor CMLNewYellowColor];
    self.selectScrollView.normalColor = [UIColor CMLBlackColor];
    self.selectScrollView.itemNamesArray = self.attributeArray;
//    self.selectScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.selectScrollView.layer.shadowOpacity = 0.05;
//    self.selectScrollView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.selectScrollView.layer.shadowRadius = 2;
    [self.selectScrollView loadSelectViewAndData];
    [self.contentView addSubview:self.selectScrollView];
    
    
    self.multipleTableView = [[CMLMultipleTableView alloc] initWithFrame:CGRectMake(0,
                                                                                   CGRectGetMaxY(_selectScrollView.frame),
                                                                                   WIDTH,
                                                                                   HEIGHT - UITabBarHeight - CGRectGetMaxY(_selectScrollView.frame) - SafeAreaBottomHeight)
                                                                 andTags:self.attributeIdArray];
    self.multipleTableView.delegate = self;
    self.multipleTableView.tagNamesArr = self.attributeArray;
    [self.contentView addSubview:self.multipleTableView];
    
    [self.contentView bringSubviewToFront:self.selectScrollView];
    
}

#pragma mark - SelectScrollViewDelegate

- (void) selectItemName:(NSString *)name index:(int) index{
    
    [self.multipleTableView scrollToIndex:index];
    
}

- (void) getActivityTypeListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [NetWorkTask getRequestWithApiName:WorldCityList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = WorldCityList;
    
    [self startLoading];
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

  if ([self.currentApiName isEqualToString:WorldCityList]){
    
     
      
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
         
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                ActivityTypeObj *activityObj = [ActivityTypeObj getBaseObjFrom:obj.retData.dataList[i]];
                [self.attributeArray addObject:activityObj.title];
                [self.attributeIdArray addObject:activityObj.currentID];
            }
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
        
            [self showFailTemporaryMes:obj.retMsg];
        }
      [self loadViews];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showNetErrorTipOfMainVC];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self stopLoading];

}

- (void) refrshCurrentVC{

    if (self.isInit) {
    
        self.currentSelectNum = 0;
        [self.selectScrollView refreshSelectScrollView:self.currentSelectNum];
        [self.multipleTableView scrollToIndex:self.currentSelectNum];
        [self.multipleTableView scrollCurrentTableViewToTop];
        
        self.selectScrollView.hidden = NO;
        self.multipleTableView.hidden = NO;

        
    }else{
    
        self.isInit = YES;
        
            self.selectScrollView.hidden = NO;
            self.multipleTableView.hidden = NO;

    }
    
}

#pragma mark - CMLMultipleTableViewDelegate

- (void) showMultipleTableSuccessMessage:(NSString *)srt{

    [self showSuccessTemporaryMes:srt];
}

- (void) showMultipleTableErrorMessage:(NSString *)srt{

    [self showFailTemporaryMes:srt];
}

- (void) multipleTableProgressError{
    
    [self showNetErrorTipOfNormalVC];
    
    [self stopLoading];
}

- (void) multipleTableProgressSucess{

    [self stopLoading];
}

- (void) scrollToTempLoation:(int) index{
    
     [self.selectScrollView refreshSelectScrollView:index];
}

- (void) changeCheckCity:(NSNotification *) noti{
    
    
    NSDictionary *tempDic = (NSDictionary *)noti;
    
    NSDictionary *processDic = [tempDic valueForKey:@"object"];
    
    
    /***************/
    
    int currentSelectNum = 0;
    
    for (int i = 0; i < self.attributeIdArray.count; i++) {
        
        if ([self.attributeIdArray[i] intValue] == [[processDic objectForKey:@"objId"] intValue]) {
            
            currentSelectNum = i;

        }
        
    }
    [self scrollToTempLoation:currentSelectNum];
    
    /*********/
}

@end
