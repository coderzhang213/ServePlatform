//
//  CMLNewPersonalVIPVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLNewPersonalVIPVC.h"
#import "VCManger.h"
#import "CMLGradeAndPointShowView.h"
#import "CMLOwnVIPMessageShowView.h"
#import "SpecialPrivilegeView.h"
#import "BasicPrivilegeView.h"
#import "OtherPrivilegeView.h"
#import "DetailPrivilegeObj.h"
#import "Privilege.h"

@interface CMLNewPersonalVIPVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,strong) NSString *currentApiName;

@property (nonatomic,strong) NSArray *specialArray;

@property (nonatomic,strong) NSArray *basicArray;

@property (nonatomic,strong) NSArray *otherArray;

@property (nonatomic,copy) NSString *viewLink;

@end

@implementation CMLNewPersonalVIPVC

- (instancetype)init{

    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLDarkOrangeColor];
    self.navBar.delegate = self;
    self.navBar.titleContent = @"我的会员";
    self.navBar.titleColor = [UIColor CMLWhiteColor];
    [self.navBar setWhiteLeftBarItem];
 
    [self loadMessageOfVC];
    __weak typeof(self) weakSelf = self;
    
    self.refreshViewController = ^(){
    
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
}

- (void) loadMessageOfVC{

    /**请求的方式*/
    switch ([[[DataManager lightData] readGradeBuyState] intValue]) {
        case 0:
            [self getBasicPrivilege];
            self.specialArray = [NSArray array];
            break;
        case 1:
            [self getBasicPrivilege];
            self.specialArray = [NSArray array];
            break;
        case 2:
            [self getSpecialPrivilege];
            break;
        case 3:
            [self getSpecialPrivilege];
            break;
        case 4:
            [self getBasicPrivilege];
            self.specialArray = [NSArray array];
            break;
            
        default:
            break;
    }


}

- (void) loadViews{

    //信息展示 不同颜色的卡片
    CMLOwnVIPMessageShowView *ownMessageView = [[CMLOwnVIPMessageShowView alloc] init];
    ownMessageView.center = CGPointMake(WIDTH/2.0, CGRectGetMaxY(self.navBar.frame) + ownMessageView.frame.size.height/2.0);
    [self.contentView addSubview:ownMessageView];
    
    //积分级别展示（黑块）
    CMLGradeAndPointShowView *gradeAndPointsView = [[CMLGradeAndPointShowView alloc] initWithGrade:[[DataManager lightData] readUserLevel]
                                                                                         andPoints:[[DataManager lightData] readUserPoints]];
    gradeAndPointsView.center = CGPointMake(WIDTH/2.0,CGRectGetMaxY(ownMessageView.frame));
    [self.contentView addSubview:gradeAndPointsView];
    
    //特权滑动的底层
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(gradeAndPointsView.frame) + 30*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:bottomView];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomView.frame), WIDTH, HEIGHT - CGRectGetMaxY(bottomView.frame))];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainScrollView];
    
    //土豪特权包
    SpecialPrivilegeView *specialPrivilegeView = [[SpecialPrivilegeView alloc] initWithDataArray:self.specialArray];
    specialPrivilegeView.viewLink = self.viewLink;
    specialPrivilegeView.frame = CGRectMake(0,
                                            0,
                                            WIDTH,
                                            specialPrivilegeView.currentHeight);
    [mainScrollView addSubview:specialPrivilegeView];
    
    //基础特权
    BasicPrivilegeView *basicPrivilegeView = [[BasicPrivilegeView alloc] initWithDataArray:self.basicArray];
    basicPrivilegeView.frame = CGRectMake(0,
                                          CGRectGetMaxY(specialPrivilegeView.frame),
                                          WIDTH,
                                          basicPrivilegeView.currentHeight);
    [mainScrollView addSubview:basicPrivilegeView];
    
    //等级高于粉色之后的涵盖特权
    OtherPrivilegeView *otherPrivilegeView = [[OtherPrivilegeView alloc] initWithDataArray:self.otherArray];
    otherPrivilegeView.frame = CGRectMake(0,
                                          CGRectGetMaxY(basicPrivilegeView.frame),
                                          WIDTH,
                                          otherPrivilegeView.currentHeight);
    [mainScrollView addSubview:otherPrivilegeView];
    
    mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(otherPrivilegeView.frame));
    
}

 - (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - 平民特权
- (void) getBasicPrivilege{
    
    /**网络请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readUserLevel] forKey:@"memberLevelId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:BasicPrivilege param:paraDic delegate:delegate];
    self.currentApiName = BasicPrivilege;
    
    [self startLoading];
    
}

#pragma mark - 土豪特权包
- (void) getSpecialPrivilege{
    
    /**网络请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readGradeBuyState] forKey:@"memberLevelId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask getRequestWithApiName:SpecialPrivilege param:paraDic delegate:delegate];
    self.currentApiName = SpecialPrivilege;
    
    [self startLoading];
    
}


/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    if ([self.currentApiName isEqualToString:BasicPrivilege]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            //数据存储
            self.basicArray = obj.retData.basic.dataList;
            self.otherArray = obj.retData.other.dataList;
            [self loadViews];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:SpecialPrivilege]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
        
            //数据存储加更多详情
            self.viewLink = obj.retData.projectDetailLink;
            self.specialArray = obj.retData.basic.dataList;
            [self getBasicPrivilege];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
             [self stopLoading];
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfNormalVC];
    
}

@end
