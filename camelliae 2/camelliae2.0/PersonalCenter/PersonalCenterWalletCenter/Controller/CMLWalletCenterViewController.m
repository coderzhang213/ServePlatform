//
//  CMLWalletCenterViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/9.
//  Copyright © 2019 张越. All rights reserved.
//

#import "CMLWalletCenterViewController.h"
#import "VCManger.h"
#import "CMLMyWithdrawalViewController.h"
#import "CMLTeamAViewController.h"
#import "NSDate+CMLExspand.h"
#import "Network.h"
#import "CMLIncomeTableView.h"
#import "DataManager.h"
#import "UpGradeVC.h"
#import "CMLWalletCenterNavView.h"
#import "CMLTeamPinkViewController.h"
#import "ShowAgreementView.h"

@interface CMLWalletCenterViewController ()<NavigationBarProtocol, NetWorkProtocol,  UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, CMLMyWithdrawalViewControllerDelegate, CMLIncomeTableViewDelegate, CMLWalletCenterNavViewDelegate, CMLBaseTableViewDlegate, ShowAgreementViewDelegate>

@property (nonatomic,assign) CGFloat currentOffY;

@property (nonatomic, strong) CMLIncomeTableView *walletTableView;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic, strong) UIImageView *walletCenterTopImageView;

@property (nonatomic, strong) UIImageView *earningsCardImageView;

@property (nonatomic, strong) UIButton *withdrawalsButton;

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *linelabel;

@property (nonatomic, strong) UILabel *incomeSumLabel;

@property (nonatomic, strong) UILabel *getCashSumLabel;

@property (nonatomic, strong) UILabel *countALabel;

@property (nonatomic, strong) UILabel *countBLabel;

@property (nonatomic, strong) UIButton *teamDetailButton;

@property (nonatomic, strong) UIButton *teamDetailImageBtn;

@property (nonatomic, strong) UIButton *teamPinkDetailButton;

@property (nonatomic, strong) UIButton *teamPinkDetailImageBtn;

@property (nonatomic, strong) UIButton *teamRebateDetailButton;

@property (nonatomic, strong) UIButton *teamRebateDetailImageBtn;

@property (nonatomic, strong) UIView *timeSelectorView;

@property (nonatomic, strong) UILabel *timeSelectorLabel;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, copy)   NSString *yearString;

@property (nonatomic, copy)   NSString *monthString;

@property (nonatomic, copy)   NSString *timeString;

@property (nonatomic, assign) BOOL isChangeTime;

@property (nonatomic, copy)   NSString *income;

@property (nonatomic, copy)   NSString *getCash;

@property (nonatomic, strong) UIImageView *vImageView;

@property (nonatomic, strong) UILabel *myEarningsLabel;

@property (nonatomic, strong) UIView *tableHeader;

@property (nonatomic, strong) UILabel *earningsMoney;

@property (nonatomic, strong) UIImageView *teamImage;

@property (nonatomic, strong) UILabel *teamLabel;

@property (nonatomic, strong) UIImageView *teamAImage;

@property (nonatomic, strong) UILabel *labelA;

@property (nonatomic, strong) UILabel *labelAPeaple;

@property (nonatomic, strong) UIImageView *teamBImage;

@property (nonatomic, strong) UILabel *labelB;

@property (nonatomic, strong) UILabel *labelBPeaple;

@property (nonatomic, strong) UIView *headView;/*收益记录bgview*/

@property (nonatomic, strong) UILabel *earningsRecordLabel;/*收益记录label*/

@property (nonatomic, strong) UIButton *timeSelectorBtn;/*时间选择btn*/

@property (nonatomic, strong) UIImageView *triangleImage;/*时间选择角标*/

@property (nonatomic, strong) CMLWalletCenterNavView *navView;

/*邀请粉金粉钻*/
@property (nonatomic, strong) UIImageView *teamPinkGoldImage; /*icon*/

@property (nonatomic, strong) UILabel *pinkGoldLabel;         /*已邀请*/

@property (nonatomic, strong) UILabel *pinkGoldCountLabel;    /*邀请人数*/

@property (nonatomic, strong) UILabel *pinkGoldPeopleLabel;   /*人*/

/*粉钻*/
@property (nonatomic, strong) UIImageView *teamPinkDiamondImage;

@property (nonatomic, strong) UILabel *pinkDiamondLabel;

@property (nonatomic, strong) UILabel *pinkDiamondCountLabel;

@property (nonatomic, strong) UILabel *pinkDiamondPeopleLabel;

/*返利*/
@property (nonatomic, strong) UIImageView *teamRebateImage; /*icon*/

@property (nonatomic, strong) UILabel *rebateLabel;         /*已邀请*/

@property (nonatomic, strong) UILabel *rebateCountLabel;    /*邀请人数*/

@property (nonatomic, strong) UILabel *rebatePeopleLabel;   /*人*/

/*提现升级提示*/
@property (nonatomic, strong) UIView *upgradeAlertView;

@property (nonatomic, strong) BaseResultObj *roleObj;

@end

@implementation CMLWalletCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (NSMutableDictionary *)dataDict {
    
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (NSMutableArray *)yearArray {
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    self.navView = [[CMLWalletCenterNavView alloc] init];
    self.navView.titleContent = @"钱包中心";
    self.navView.delegate = self;
    [self.contentView addSubview:self.navView];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.isChangeTime = NO;
    
    /**阴影*/
    self.shadowView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:0.5];
    self.shadowView.hidden = YES;
    [self.contentView addSubview:self.shadowView];
    [self.contentView bringSubviewToFront:self.shadowView];
    
    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^{
        [weakSelf.dataDict removeAllObjects];
        [weakSelf.yearArray removeAllObjects];
        [weakSelf.monthArray removeAllObjects];
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
    
}

- (void)loadMessageOfVC {
    
    [self loadData];
    
}

- (void)loadData {
    
    for (int i = [[NSDate getCurrentYear] intValue]; i >= 1970; i--) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 1; i <= 12; i++) {
        if (i < 10) {
            [self.monthArray addObject:[NSString stringWithFormat:@"0%@", [NSNumber numberWithInt:i]]];
        }else {
            [self.monthArray addObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:i]]];
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    
    if (!self.timeString) {
        self.timeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[AppGroup getCurrentDate]]];
    }
    
    [self loadHeadView];
    [self getWalletCenterRequest];

}

- (void)loadHeadView {
    
    /*walletCenterTopImageView添加到头视图*/
    [self.tableHeader addSubview:self.walletCenterTopImageView];
    [self.walletCenterTopImageView addSubview:self.logoView];
    [self.walletCenterTopImageView addSubview:self.linelabel];
    [self.walletCenterTopImageView addSubview:self.earningsCardImageView];
    if ([[[DataManager lightData] readRoleId] intValue] < 5) {
        self.earningsCardImageView.image = [UIImage imageNamed:CMLWalletCenterEarningsPinkBgImage];
    }
    
    /*收益提现卡片*/
    [self.earningsCardImageView addSubview:self.withdrawalsButton];/*提现按钮*/
    [self.earningsCardImageView addSubview:self.earningsMoney];/*我的收益金额*/
    [self.earningsCardImageView addSubview:self.vImageView];/*我的收益图标*/
    [self.earningsCardImageView addSubview:self.myEarningsLabel];/*我的收益(元)*/
    
    /*MYTEAM 我的团队*/
    [self.walletCenterTopImageView addSubview:self.teamImage];/*我的团队icon*/
    [self.walletCenterTopImageView addSubview:self.teamLabel];/*我的团队文字*/
    /*A级人数*/
    [self.walletCenterTopImageView addSubview:self.teamAImage];/*A-icon*/
    [self.walletCenterTopImageView addSubview:self.labelA];/*已邀请A级*/
    [self.walletCenterTopImageView addSubview:self.labelAPeaple];/*人*/
    [self.walletCenterTopImageView addSubview:self.countALabel];/**A-人数**/
    /*B级人数*/
//    [self.walletCenterTopImageView addSubview:self.teamBImage];/*B-icon*/
//    [self.walletCenterTopImageView addSubview:self.labelB];/*已邀请B级*/
//    [self.walletCenterTopImageView addSubview:self.labelBPeaple];/*人*/
//    [self.walletCenterTopImageView addSubview:self.countBLabel];/**B-人数**/
    /*粉金*/
    [self.walletCenterTopImageView addSubview:self.teamPinkGoldImage];
    [self.walletCenterTopImageView addSubview:self.pinkGoldLabel];
    [self.walletCenterTopImageView addSubview:self.pinkGoldPeopleLabel];
    [self.walletCenterTopImageView addSubview:self.pinkGoldCountLabel];
    /*粉钻*
    [self.walletCenterTopImageView addSubview:self.teamPinkDiamondImage];
    [self.walletCenterTopImageView addSubview:self.pinkDiamondLabel];
    [self.walletCenterTopImageView addSubview:self.pinkDiamondPeopleLabel];
    [self.walletCenterTopImageView addSubview:self.pinkDiamondCountLabel];
     */
    /*返利*/
    [self.walletCenterTopImageView addSubview:self.teamRebateImage];
    [self.walletCenterTopImageView addSubview:self.rebateLabel];
    [self.walletCenterTopImageView addSubview:self.rebatePeopleLabel];
    [self.walletCenterTopImageView addSubview:self.rebateCountLabel];
    if ([[[DataManager lightData] readRoleId] intValue] > 4) {
        [self loadTeamDetailButton];/*团队详情btn*/
        [self loadPinkTeamDetailButton];
        [self loadRebateTeamDetailButton];
    }else if ([[[DataManager lightData] readRoleId] intValue] < 5) {
        self.earningsCardImageView.image = [UIImage imageNamed:CMLWalletCenterEarningsPinkBgImage];
        /*粉色会员-邀请返利人数*/
        self.teamAImage.hidden = YES;
        self.labelA.hidden = YES;
        self.labelAPeaple.hidden = YES;
        self.countALabel.hidden = YES;
        
        self.teamBImage.hidden = YES;
        self.labelB.hidden = YES;
        self.labelBPeaple.hidden = YES;
        self.countBLabel.hidden = YES;
        
        self.teamPinkGoldImage.hidden = YES;
        self.pinkGoldLabel.hidden = YES;
        self.pinkGoldCountLabel.hidden = YES;
        self.pinkGoldPeopleLabel.hidden = YES;
        
        self.teamPinkDiamondImage.hidden = YES;
        self.pinkDiamondLabel.hidden = YES;
        self.pinkDiamondCountLabel.hidden = YES;
        self.pinkDiamondPeopleLabel.hidden = YES;
        
        if ([[DataManager lightData] readPink].length > 0) {
            self.rebateCountLabel.text =  [[DataManager lightData] readPink];
            
        }
        self.teamRebateImage.frame = CGRectMake(CGRectGetMinX(self.teamImage.frame) - 4*Proportion,
                                                CGRectGetMaxY(self.teamLabel.frame) + 40*Proportion,
                                                CGRectGetWidth(self.teamRebateImage.frame),
                                                CGRectGetHeight(self.teamRebateImage.frame));
        self.rebateLabel.frame = CGRectMake(CGRectGetMaxX(self.teamRebateImage.frame) + 10*Proportion,
                                            CGRectGetMidY(self.teamRebateImage.frame) - CGRectGetHeight(self.rebateLabel.frame)/2,
                                            CGRectGetWidth(self.rebateLabel.frame),
                                            CGRectGetHeight(self.rebateLabel.frame));
        self.rebatePeopleLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame) + 48*Proportion,
                                                  CGRectGetMidY(self.teamRebateImage.frame) - CGRectGetHeight(self.rebateLabel.frame)/2,
                                                  CGRectGetWidth(self.rebatePeopleLabel.frame),
                                                  CGRectGetHeight(self.rebatePeopleLabel.frame));
        self.rebateCountLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame),
                                                 CGRectGetMaxY(self.rebateLabel.frame) - 31 * Proportion,
                                                 48 * Proportion,
                                                 30 * Proportion);
        
        if ([[[DataManager lightData] readRoleId] intValue] < 3) {
            self.teamRebateImage.hidden = YES;
            self.rebateLabel.hidden = YES;
            self.rebateCountLabel.hidden = YES;
            self.rebatePeopleLabel.hidden = YES;
            
            self.teamImage.hidden = YES;
            self.teamLabel.hidden = YES;
            
            self.headView.frame = CGRectMake(0,
                                             CGRectGetMaxY(self.earningsCardImageView.frame) + 120 * Proportion + StatusBarHeight + NavigationBarHeight,
                                             WIDTH,
                                             227 * Proportion + 100 * Proportion);
            
        }else {
            [self loadRebateTeamDetailButton];
        }
        
    }
    
    /*加载收益记录*/
    [self.tableHeader addSubview:self.headView];/*收益记录部分view*/
    [self.headView addSubview:self.earningsRecordLabel];/*收益记录*/
    
    [self.headView addSubview:self.incomeSumLabel];/*收入金额**/
    [self.headView addSubview:self.getCashSumLabel];/*提现金额**/

    /*时间选择器*/
    [self.headView addSubview:self.timeSelectorView];
    [self.timeSelectorView addSubview:self.timeSelectorLabel];
    [self.headView addSubview:self.timeSelectorBtn];
    [self.timeSelectorView addSubview:self.triangleImage];
    
    self.tableHeader.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.headView.frame) - 100 * Proportion);
    self.tableHeader.contentMode = UIViewContentModeScaleAspectFill;
    self.tableHeader.clipsToBounds = YES;
    NSLog(@"%f", CGRectGetMaxY(self.headView.frame));
    NSLog(@"%f", CGRectGetMaxY(self.walletCenterTopImageView.frame));
    
    self.walletTableView = [[CMLIncomeTableView alloc] initWithFrame:CGRectMake(0, -NavigationBarHeight - StatusBarHeight, WIDTH, HEIGHT + StatusBarHeight + NavigationBarHeight) style:UITableViewStylePlain withTimeString:self.timeString];
    self.walletTableView.backgroundColor = [UIColor whiteColor];
    self.walletTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaBottomHeight, WIDTH, SafeAreaBottomHeight)];
    self.walletTableView.incomeDelegate = self;
    self.walletTableView.baseTableViewDlegate = self;
        
    self.walletTableView.tableHeaderView = self.tableHeader;
    [self.contentView addSubview:self.walletTableView];
    [self.contentView bringSubviewToFront:self.navView];

}

/*刷新金额和邀请人数*/
- (void)refreshHeadView {
    
    /*总金额*/
    if ([[DataManager lightData] readAllEarnings].length > 0) {
        self.earningsMoney.text = [NSString stringWithFormat:@"%.2f", [[[DataManager lightData] readAllEarnings] floatValue]];
    }
    
    if ([[DataManager lightData] readOneCount].length > 0) {
        self.countALabel.frame = CGRectMake(CGRectGetMaxX(self.labelA.frame) + 4*Proportion,
                                            CGRectGetMaxY(self.labelA.frame) - 31*Proportion,
                                            40*Proportion,
                                            30*Proportion);
        self.countALabel.text = [[DataManager lightData] readOneCount];
    }
    
    if ([[DataManager lightData] readTwoCount].length > 0) {
        self.countBLabel.frame = CGRectMake(CGRectGetMaxX(self.labelB.frame) + 4*Proportion,
                                            CGRectGetMaxY(self.labelB.frame) - 31*Proportion,
                                            40*Proportion,
                                            30*Proportion);
        self.countBLabel.text = [[DataManager lightData] readTwoCount];
    }
    
    if ([[DataManager lightData] readPinkGoldCount].length > 0) {
        self.pinkGoldCountLabel.text = [[DataManager lightData] readPinkGoldCount];
        
        self.pinkGoldCountLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkGoldLabel.frame),
                                              CGRectGetMaxY(self.pinkGoldLabel.frame) - 31 * Proportion,
                                              48 * Proportion,
                                              30 * Proportion);
    }
    
    if ([[DataManager lightData] readPinkDiamondCount].length > 0) {
        self.pinkDiamondCountLabel.text = [[DataManager lightData] readPinkDiamondCount];
        self.pinkDiamondCountLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkDiamondLabel.frame),
                                                 CGRectGetMaxY(self.pinkDiamondLabel.frame) - 31 * Proportion,
                                                 48 * Proportion,
                                                 30 * Proportion);
    }else {/*粉金只有rebateLabel*/
        self.pinkDiamondLabel.hidden = YES;
        self.teamPinkDiamondImage.hidden = YES;
        self.pinkDiamondPeopleLabel.hidden = YES;
        self.pinkDiamondCountLabel.hidden = YES;
    }
    
    if ([[DataManager lightData] readPink].length > 0) {
        self.rebateCountLabel.text =  [[DataManager lightData] readPink];
        self.rebateCountLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame),
                                            CGRectGetMaxY(self.rebateLabel.frame) - 31 * Proportion,
                                            48 * Proportion,
                                            30 * Proportion);
    }
    
    if ([[[DataManager lightData] readRoleId] intValue] == 3) {
        if ([[DataManager lightData] readOneCount].length > 0) {
            self.rebateCountLabel.text =  [[DataManager lightData] readOneCount];
            self.rebateCountLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame),
                                                     CGRectGetMaxY(self.rebateLabel.frame) - 31 * Proportion,
                                                     48 * Proportion,
                                                     30 * Proportion);
        }
    }
}

- (void)refreshEarningsIntroView {
    
    if (self.income.length > 0) {
        self.incomeSumLabel.text = [NSString stringWithFormat:@"收入￥%@", self.income];
        NSLog(@"%@", self.income);
        [self.incomeSumLabel sizeToFit];
        self.incomeSumLabel.frame = CGRectMake(CGRectGetMinX(self.earningsRecordLabel.frame) + 1,
                                               CGRectGetMaxY(self.earningsRecordLabel.frame) + 10*Proportion,
                                               CGRectGetWidth(self.incomeSumLabel.frame),
                                               CGRectGetHeight(self.incomeSumLabel.frame));
        
    }
    
    if (self.getCash.length > 0) {
        self.getCashSumLabel.text = [NSString stringWithFormat:@"提现￥%@", self.getCash];
    }
    [self.getCashSumLabel sizeToFit];
    self.getCashSumLabel.frame =  CGRectMake(CGRectGetMinX(self.earningsRecordLabel.frame) + 20 * Proportion + CGRectGetWidth(self.incomeSumLabel.frame),
                                             CGRectGetMaxY(self.earningsRecordLabel.frame) + 10 * Proportion,
                                             CGRectGetWidth(self.getCashSumLabel.frame),
                                             CGRectGetHeight(self.getCashSumLabel.frame));
    
    self.timeSelectorLabel.text = self.timeString;
    
}

- (void)loadTeamDetailButton {
    
    /*团队详情*/
    self.teamDetailImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamDetailImageBtn.backgroundColor = [UIColor clearColor];
    [self.teamDetailImageBtn setImage:[UIImage imageNamed:CMLWalletCenterTeamDetailImage] forState:UIControlStateNormal];
    [self.teamDetailImageBtn addTarget:self action:@selector(teamDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.teamDetailImageBtn sizeToFit];
    self.teamDetailImageBtn.frame = CGRectMake(CGRectGetMaxX(self.earningsCardImageView.frame) - CGRectGetWidth(self.teamDetailImageBtn.frame) - 20 * Proportion,
                                               CGRectGetMidY(self.labelBPeaple.frame) - CGRectGetHeight(self.teamDetailImageBtn.frame)/2,
                                               CGRectGetWidth(self.teamDetailImageBtn.frame),
                                               CGRectGetHeight(self.teamDetailImageBtn.frame));
    [self.walletCenterTopImageView addSubview:self.teamDetailImageBtn];
    
    UILabel *teamDetailLabel = [[UILabel alloc] init];
    teamDetailLabel.text = @"详情";
    teamDetailLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    teamDetailLabel.backgroundColor = [UIColor clearColor];
    teamDetailLabel.textColor = [UIColor CMLA6A6A6Color];
    [teamDetailLabel sizeToFit];
    teamDetailLabel.userInteractionEnabled = YES;
    teamDetailLabel.frame = CGRectMake(CGRectGetMinX(self.teamDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetMidY(self.teamDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                       CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetHeight(teamDetailLabel.frame));
    [self.walletCenterTopImageView addSubview:teamDetailLabel];
    
    self.teamDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamDetailButton.backgroundColor = [UIColor clearColor];
    self.teamDetailButton.frame = CGRectMake(CGRectGetMinX(self.teamDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                             CGRectGetMidY(self.teamDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                             CGRectGetWidth(teamDetailLabel.frame) + CGRectGetWidth(self.teamDetailImageBtn.frame),
                                             CGRectGetHeight(teamDetailLabel.frame) +  4 * Proportion);
    [self.teamDetailButton addTarget:self action:@selector(teamDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.walletCenterTopImageView addSubview:self.teamDetailButton];
}
- (void)loadRebateTeamDetailButton {
    
    /*团队详情*/
    self.teamRebateDetailImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamRebateDetailImageBtn.backgroundColor = [UIColor clearColor];
    [self.teamRebateDetailImageBtn setImage:[UIImage imageNamed:CMLWalletCenterTeamDetailImage] forState:UIControlStateNormal];
    [self.teamRebateDetailImageBtn addTarget:self action:@selector(teamDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.teamRebateDetailImageBtn sizeToFit];
    self.teamRebateDetailImageBtn.frame = CGRectMake(CGRectGetMaxX(self.earningsCardImageView.frame) - CGRectGetWidth(self.teamDetailImageBtn.frame) - 20 * Proportion,
                                                     CGRectGetMidY(self.teamRebateImage.frame) - CGRectGetHeight(self.teamRebateDetailImageBtn.frame)/2,
                                                     CGRectGetWidth(self.teamRebateDetailImageBtn.frame),
                                                     CGRectGetHeight(self.teamRebateDetailImageBtn.frame));
    [self.walletCenterTopImageView addSubview:self.teamRebateDetailImageBtn];
    
    UILabel *teamDetailLabel = [[UILabel alloc] init];
    teamDetailLabel.text = @"详情";
    teamDetailLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    teamDetailLabel.backgroundColor = [UIColor clearColor];
    teamDetailLabel.textColor = [UIColor CMLA6A6A6Color];
    [teamDetailLabel sizeToFit];
    teamDetailLabel.userInteractionEnabled = YES;
    teamDetailLabel.frame = CGRectMake(CGRectGetMinX(self.teamRebateDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetMidY(self.teamRebateDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                       CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetHeight(teamDetailLabel.frame));
    [self.walletCenterTopImageView addSubview:teamDetailLabel];
    
    self.teamRebateDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamRebateDetailButton.backgroundColor = [UIColor clearColor];
    self.teamRebateDetailButton.frame = CGRectMake(CGRectGetMinX(self.teamRebateDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                                   CGRectGetMidY(self.teamRebateDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                                   CGRectGetWidth(teamDetailLabel.frame) + CGRectGetWidth(self.teamRebateDetailImageBtn.frame),
                                                   CGRectGetHeight(teamDetailLabel.frame) +  4 * Proportion);
    [self.teamRebateDetailButton addTarget:self action:@selector(teamRebateDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.walletCenterTopImageView addSubview:self.teamRebateDetailButton];
}

- (void)loadPinkTeamDetailButton {
    /*团队详情*/
    self.teamPinkDetailImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamPinkDetailImageBtn.backgroundColor = [UIColor clearColor];
    [self.teamPinkDetailImageBtn setImage:[UIImage imageNamed:CMLWalletCenterTeamDetailImage] forState:UIControlStateNormal];
    [self.teamPinkDetailImageBtn addTarget:self action:@selector(teamDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.teamPinkDetailImageBtn sizeToFit];
    self.teamPinkDetailImageBtn.frame = CGRectMake(CGRectGetMaxX(self.earningsCardImageView.frame) - CGRectGetWidth(self.teamPinkDetailImageBtn.frame) - 20 * Proportion,
                                                   CGRectGetMidY(self.teamPinkGoldImage.frame) - CGRectGetHeight(self.teamPinkDetailImageBtn.frame)/2,
                                                   CGRectGetWidth(self.teamPinkDetailImageBtn.frame),
                                                   CGRectGetHeight(self.teamPinkDetailImageBtn.frame));
    [self.walletCenterTopImageView addSubview:self.teamPinkDetailImageBtn];
    
    UILabel *teamDetailLabel = [[UILabel alloc] init];
    teamDetailLabel.text = @"详情";
    teamDetailLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    teamDetailLabel.backgroundColor = [UIColor clearColor];
    teamDetailLabel.textColor = [UIColor CMLA6A6A6Color];
    [teamDetailLabel sizeToFit];
    teamDetailLabel.userInteractionEnabled = YES;
    teamDetailLabel.frame = CGRectMake(CGRectGetMinX(self.teamPinkDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetMidY(self.teamPinkDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                       CGRectGetWidth(teamDetailLabel.frame),
                                       CGRectGetHeight(teamDetailLabel.frame));
    [self.walletCenterTopImageView addSubview:teamDetailLabel];
    
    self.teamPinkDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.teamPinkDetailButton.backgroundColor = [UIColor clearColor];
    self.teamPinkDetailButton.frame = CGRectMake(CGRectGetMinX(self.teamPinkDetailImageBtn.frame) - 10*Proportion - CGRectGetWidth(teamDetailLabel.frame),
                                                 CGRectGetMidY(self.teamPinkDetailImageBtn.frame) - CGRectGetHeight(teamDetailLabel.frame)/2,
                                                 CGRectGetWidth(teamDetailLabel.frame) + CGRectGetWidth(self.teamPinkDetailImageBtn.frame),
                                                 CGRectGetHeight(teamDetailLabel.frame) +  4 * Proportion);
    [self.teamPinkDetailButton addTarget:self action:@selector(teamPinkDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.walletCenterTopImageView addSubview:self.teamPinkDetailButton];
}

/******/
- (UIImageView *)logoView {
    
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterEarningsLogoImage]];
        _logoView.backgroundColor = [UIColor clearColor];
        [_logoView sizeToFit];
        _logoView.frame = CGRectMake(CGRectGetMinX(self.earningsCardImageView.frame) + 15 * Proportion,
                                     49 * Proportion + CGRectGetMaxY(self.navView.frame),
                                     CGRectGetWidth(_logoView.frame),
                                     CGRectGetHeight(_logoView.frame));
    }
    return _logoView;
}

- (UILabel *)linelabel {
    
    if (!_linelabel) {
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.logoView.frame) + 6 * Proportion,
                                                               CGRectGetMaxY(self.logoView.frame) + 14*Proportion,
                                                               CGRectGetWidth(self.logoView.frame) - 18 * Proportion,
                                                               1 * Proportion)];
        self.linelabel.backgroundColor = [UIColor CMLDCB167Color];
    }
    return _linelabel;
}

- (UIImageView *)walletCenterTopImageView {
    
    if (!_walletCenterTopImageView) {
        
        _walletCenterTopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterTopBackgroundImage]];
        _walletCenterTopImageView.contentMode = UIViewContentModeScaleAspectFill;
        _walletCenterTopImageView.clipsToBounds = YES;
        _walletCenterTopImageView.userInteractionEnabled = YES;
        _walletCenterTopImageView.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.navBar.frame),
                                                     WIDTH,
                                                     CGRectGetHeight(_walletCenterTopImageView.frame) - 100 * Proportion);
    }
    return _walletCenterTopImageView;
    
}

/*收益卡片*/
- (UIImageView *)earningsCardImageView {
    
    if (!_earningsCardImageView) {
        _earningsCardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterEarningsDarkBgImage]];
//        _earningsCardImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_earningsCardImageView sizeToFit];
        _earningsCardImageView.userInteractionEnabled = YES;
        _earningsCardImageView.frame = CGRectMake(CGRectGetWidth(self.walletCenterTopImageView.frame)/2 - CGRectGetWidth(_earningsCardImageView.frame)/2,
                                                  158 * Proportion + CGRectGetMaxY(self.navView.frame),
                                                  CGRectGetWidth(_earningsCardImageView.frame),
                                                  CGRectGetHeight(_earningsCardImageView.frame));
        
        
    }
    return _earningsCardImageView;
}

/*提现按钮*/
- (UIButton *)withdrawalsButton {
    
    if (!_withdrawalsButton) {
        _withdrawalsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawalsButton setTitle:@"提现" forState:UIControlStateNormal];
        _withdrawalsButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        [_withdrawalsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawalsButton.titleLabel.textColor = [UIColor CMLWhiteColor];
        _withdrawalsButton.backgroundColor = [UIColor CMLYellowE5C68DColor];
        _withdrawalsButton.layer.cornerRadius = 8 * Proportion;
        _withdrawalsButton.clipsToBounds = YES;
        [_withdrawalsButton addTarget:self action:@selector(withdrawalsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _withdrawalsButton.frame = CGRectMake(90 * Proportion,
                                              CGRectGetHeight(self.earningsCardImageView.frame) - 90 * Proportion,
                                              214 * Proportion,
                                              60 * Proportion);

    }
    return _withdrawalsButton;
}

- (UILabel *)earningsMoney {
    
    if (!_earningsMoney) {
        _earningsMoney = [[UILabel alloc] init];
        _earningsMoney.text = @"0";
        _earningsMoney.font = KSystemBoldFontSize21;
        _earningsMoney.textColor = [UIColor CMLWhiteColor];
        [_earningsMoney sizeToFit];
        _earningsMoney.frame = CGRectMake(CGRectGetMinX(self.withdrawalsButton.frame),
                                          CGRectGetMinY(self.withdrawalsButton.frame) - 45 * Proportion - CGRectGetHeight(_earningsMoney.frame),
                                          CGRectGetWidth(self.earningsCardImageView.frame) - CGRectGetMinX(self.withdrawalsButton.frame) * 2,
                                          CGRectGetHeight(_earningsMoney.frame));

    }
    return _earningsMoney;
}

- (UIImageView *)vImageView {
    
    if (!_vImageView) {
        _vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterEarningsIconImage]];
        [_vImageView sizeToFit];
        _vImageView.frame = CGRectMake(40 * Proportion, 40 * Proportion, CGRectGetWidth(_vImageView.frame), CGRectGetHeight(_vImageView.frame));
    }
    return _vImageView;
}

- (UILabel *)myEarningsLabel {
    
    if (!_myEarningsLabel) {
        _myEarningsLabel = [[UILabel alloc] init];
        _myEarningsLabel.text = @"我的收益（元）";
        _myEarningsLabel.font = KSystemFontSize14;
        _myEarningsLabel.textColor = [UIColor whiteColor];
        [_myEarningsLabel sizeToFit];
        _myEarningsLabel.frame = CGRectMake(CGRectGetMinX(self.withdrawalsButton.frame),
                                           CGRectGetMidY(self.vImageView.frame) - CGRectGetHeight(_myEarningsLabel.frame)/2 + 4*Proportion,
                                           CGRectGetWidth(_myEarningsLabel.frame),
                                           CGRectGetHeight(_myEarningsLabel.frame));
    }
    return _myEarningsLabel;
}

/*MYTEAM*/
- (UIImageView *)teamImage {
    
    if (!_teamImage) {
        _teamImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterMYTEAMImage]];
        _teamImage.backgroundColor = [UIColor clearColor];
        [_teamImage sizeToFit];
        _teamImage.frame = CGRectMake(100*Proportion,
                                      CGRectGetMaxY(self.earningsCardImageView.frame) + 60 * Proportion,
                                      CGRectGetWidth(_teamImage.frame),
                                      CGRectGetHeight(_teamImage.frame));
    }
    return _teamImage;
}

- (UILabel *)teamLabel {
    
    if (!_teamLabel) {
        _teamLabel = [[UILabel alloc] init];
        _teamLabel.text = @"我的团队";
        _teamLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _teamLabel.textColor = [UIColor CMLA6A6A6Color];
        [_teamLabel sizeToFit];
        _teamLabel.frame = CGRectMake(CGRectGetMinX(self.teamImage.frame),
                                     CGRectGetMaxY(self.teamImage.frame) + 20*Proportion,
                                     CGRectGetWidth(_teamLabel.frame),
                                     CGRectGetHeight(_teamLabel.frame));
    }
    return _teamLabel;
}

- (UIImageView *)teamAImage {
    
    if (!_teamAImage) {
        _teamAImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterABImage]];
        _teamAImage.backgroundColor = [UIColor clearColor];
        [_teamAImage sizeToFit];
        _teamAImage.frame = CGRectMake(CGRectGetMinX(self.teamImage.frame) - 4*Proportion,
                                      CGRectGetMaxY(self.teamLabel.frame) + 40*Proportion,
                                      CGRectGetWidth(_teamAImage.frame),
                                      CGRectGetHeight(_teamAImage.frame));
    }
    return _teamAImage;
}

- (UILabel *)labelA {
    
    if (!_labelA) {
        _labelA = [[UILabel alloc] init];
        _labelA.text = @"已邀请黛色会员";
        _labelA.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _labelA.textColor = [UIColor CMLA6A6A6Color];
        [_labelA sizeToFit];
        _labelA.frame = CGRectMake(CGRectGetMaxX(self.teamAImage.frame) + 10*Proportion,
                                   CGRectGetMidY(self.teamAImage.frame) - CGRectGetHeight(_labelA.frame)/2,
                                   CGRectGetWidth(_labelA.frame),
                                   CGRectGetHeight(_labelA.frame));
    }
    return _labelA;
}

- (UILabel *)labelAPeaple {
    
    if (!_labelAPeaple) {
        _labelAPeaple = [[UILabel alloc] init];
        _labelAPeaple.text = @"人";
        _labelAPeaple.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _labelAPeaple.textColor = [UIColor CMLA6A6A6Color];
        [_labelAPeaple sizeToFit];
        _labelAPeaple.frame = CGRectMake(CGRectGetMaxX(self.labelA.frame) + 48*Proportion,
                                        CGRectGetMidY(self.teamAImage.frame) - CGRectGetHeight(self.labelA.frame)/2,
                                        CGRectGetWidth(_labelAPeaple.frame),
                                        CGRectGetHeight(_labelAPeaple.frame));
    }
    return _labelAPeaple;
}

- (UIImageView *)teamBImage {
    
    if (!_teamBImage) {
        
        _teamBImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterABImage]];
        _teamBImage.backgroundColor = [UIColor clearColor];
        [_teamBImage sizeToFit];
        _teamBImage.frame = CGRectMake(CGRectGetMaxX(self.labelAPeaple.frame) + 40*Proportion,
                                       CGRectGetMinY(self.teamAImage.frame),
                                       CGRectGetWidth(_teamBImage.frame),
                                       CGRectGetHeight(_teamBImage.frame));
    }
    return _teamBImage;
}

- (UILabel *)labelB {
    
    if (!_labelB) {
        _labelB = [[UILabel alloc] init];
        _labelB.text = @"已邀请B级";
        _labelB.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _labelB.textColor = [UIColor CMLA6A6A6Color];
        [_labelB sizeToFit];
        _labelB.frame = CGRectMake(CGRectGetMaxX(self.teamBImage.frame) + 10*Proportion,
                                  CGRectGetMidY(self.teamBImage.frame) - CGRectGetHeight(_labelB.frame)/2,
                                  CGRectGetWidth(_labelB.frame),
                                  CGRectGetHeight(_labelB.frame));
    }
    return _labelB;
}

- (UILabel *)labelBPeaple {
    
    if (!_labelBPeaple) {
        _labelBPeaple = [[UILabel alloc] init];
        _labelBPeaple.text = @"人";
        _labelBPeaple.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _labelBPeaple.textColor = [UIColor CMLA6A6A6Color];
        [_labelBPeaple sizeToFit];
        _labelBPeaple.frame = CGRectMake(CGRectGetMaxX(self.labelB.frame) + 48*Proportion,
                                         CGRectGetMidY(self.teamBImage.frame) - CGRectGetHeight(self.labelB.frame)/2,
                                         CGRectGetWidth(_labelBPeaple.frame),
                                         CGRectGetHeight(_labelBPeaple.frame));
    }
    return _labelBPeaple;
}

/*邀请粉金*/
- (UIImageView *)teamPinkGoldImage {
    
    if (!_teamPinkGoldImage) {
        _teamPinkGoldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterABImage]];
        _teamPinkGoldImage.backgroundColor = [UIColor clearColor];
        [_teamPinkGoldImage sizeToFit];
        _teamPinkGoldImage.frame = CGRectMake(CGRectGetMinX(self.teamAImage.frame),
                                              CGRectGetMaxY(self.teamAImage.frame) + 30 * Proportion,
                                              CGRectGetWidth(_teamPinkGoldImage.frame),
                                              CGRectGetHeight(_teamPinkGoldImage.frame));
    }
    return _teamPinkGoldImage;
}

- (UILabel *)pinkGoldLabel {
    
    if (!_pinkGoldLabel) {
        _pinkGoldLabel = [[UILabel alloc] init];
        _pinkGoldLabel.text = @"已邀请粉金";
        _pinkGoldLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _pinkGoldLabel.textColor = [UIColor CMLA6A6A6Color];
        _pinkGoldLabel.backgroundColor= [UIColor clearColor];
        [_pinkGoldLabel sizeToFit];
        _pinkGoldLabel.frame = CGRectMake(CGRectGetMinX(self.labelA.frame),
                                          CGRectGetMidY(self.teamPinkGoldImage.frame) - CGRectGetHeight(_pinkGoldLabel.frame)/2,
                                          CGRectGetWidth(_pinkGoldLabel.frame),
                                          CGRectGetHeight(_pinkGoldLabel.frame));
    }
    return _pinkGoldLabel;
}

- (UILabel *)pinkGoldPeopleLabel {
    
    if (!_pinkGoldPeopleLabel) {
        _pinkGoldPeopleLabel = [[UILabel alloc] init];
        _pinkGoldPeopleLabel.backgroundColor = [UIColor clearColor];
        _pinkGoldPeopleLabel.text = @"人";
        _pinkGoldPeopleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _pinkGoldPeopleLabel.textColor = [UIColor CMLA6A6A6Color];
        [_pinkGoldPeopleLabel sizeToFit];
        _pinkGoldPeopleLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkGoldLabel.frame) + 48 * Proportion,
                                                CGRectGetMidY(self.teamPinkGoldImage.frame) - CGRectGetHeight(_pinkGoldPeopleLabel.frame)/2,
                                                CGRectGetWidth(_pinkGoldPeopleLabel.frame),
                                                CGRectGetHeight(_pinkGoldPeopleLabel.frame));
    }
    return _pinkGoldPeopleLabel;
}

- (UILabel *)pinkGoldCountLabel {
    
    if (!_pinkGoldCountLabel) {
        _pinkGoldCountLabel = [[UILabel alloc] init];
        _pinkGoldCountLabel.backgroundColor = [UIColor clearColor];
        _pinkGoldCountLabel.text = @"0";
        _pinkGoldCountLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _pinkGoldCountLabel.textColor = [UIColor CMLA6A6A6Color];
        _pinkGoldCountLabel.textAlignment = NSTextAlignmentCenter;
        _pinkGoldCountLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkGoldLabel.frame),
                                               CGRectGetMaxY(self.pinkGoldLabel.frame) - 31 * Proportion,
                                               48 * Proportion,
                                               30 * Proportion);
    }
    return _pinkGoldCountLabel;
}

/*粉钻*/
- (UIImageView *)teamPinkDiamondImage {
    if (!_teamPinkDiamondImage) {
        _teamPinkDiamondImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterABImage]];
        _teamPinkDiamondImage.backgroundColor = [UIColor clearColor];
        [_teamPinkDiamondImage sizeToFit];
        _teamPinkDiamondImage.frame = CGRectMake(CGRectGetMinX(self.teamBImage.frame),
                                                 CGRectGetMidY(self.teamPinkGoldImage.frame) - CGRectGetHeight(_teamPinkDiamondImage.frame)/2,
                                                 CGRectGetWidth(_teamPinkDiamondImage.frame),
                                                 CGRectGetHeight(_teamPinkDiamondImage.frame));
    }
    return _teamPinkDiamondImage;
}

- (UILabel *)pinkDiamondLabel {
    
    if (!_pinkDiamondLabel) {
        _pinkDiamondLabel = [[UILabel alloc] init];
        _pinkDiamondLabel.backgroundColor = [UIColor clearColor];
        _pinkDiamondLabel.text = @"已邀请粉钻";
        _pinkDiamondLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _pinkDiamondLabel.textColor = [UIColor CMLA6A6A6Color];
        [_pinkDiamondLabel sizeToFit];
        _pinkDiamondLabel.frame = CGRectMake(CGRectGetMinX(self.labelB.frame),
                                             CGRectGetMidY(self.teamPinkDiamondImage.frame) - CGRectGetHeight(_pinkDiamondLabel.frame)/2,
                                             CGRectGetWidth(_pinkDiamondLabel.frame),
                                             CGRectGetHeight(_pinkDiamondLabel.frame));
    }
    return _pinkDiamondLabel;
}

- (UILabel *)pinkDiamondPeopleLabel {
    if (!_pinkDiamondPeopleLabel) {
        _pinkDiamondPeopleLabel = [[UILabel alloc] init];
        _pinkDiamondPeopleLabel.backgroundColor = [UIColor clearColor];
        _pinkDiamondPeopleLabel.text = @"人";
        _pinkDiamondPeopleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _pinkDiamondPeopleLabel.textColor = [UIColor CMLA6A6A6Color];
        [_pinkDiamondPeopleLabel sizeToFit];
        _pinkDiamondPeopleLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkDiamondLabel.frame) + 48 * Proportion,
                                                   CGRectGetMinY(self.pinkDiamondLabel.frame),
                                                   CGRectGetWidth(_pinkDiamondPeopleLabel.frame),
                                                   CGRectGetHeight(_pinkDiamondPeopleLabel.frame));
    }
    return _pinkDiamondPeopleLabel;
}

- (UILabel *)pinkDiamondCountLabel {
    if (!_pinkDiamondCountLabel) {
        _pinkDiamondCountLabel = [[UILabel alloc] init];
        _pinkDiamondCountLabel.backgroundColor = [UIColor clearColor];
        _pinkDiamondCountLabel.text = @"0";
        _pinkDiamondCountLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _pinkDiamondCountLabel.textColor = [UIColor CMLA6A6A6Color];
        _pinkDiamondCountLabel.textAlignment = NSTextAlignmentCenter;
        _pinkDiamondCountLabel.frame = CGRectMake(CGRectGetMaxX(self.pinkDiamondLabel.frame), CGRectGetMaxY(self.pinkDiamondLabel.frame) - 31 * Proportion, 48 * Proportion, 30 * Proportion);
    }
    return _pinkDiamondCountLabel;
}

/*返利*/
- (UIImageView *)teamRebateImage {
    if (!_teamRebateImage) {
        _teamRebateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterABImage]];
        _teamRebateImage.backgroundColor = [UIColor clearColor];
        [_teamRebateImage sizeToFit];
        _teamRebateImage.frame = CGRectMake(CGRectGetMinX(self.teamAImage.frame),
                                            CGRectGetMaxY(self.teamPinkGoldImage.frame) + 30 * Proportion,
                                            CGRectGetWidth(_teamRebateImage.frame),
                                            CGRectGetHeight(_teamRebateImage.frame));
    }
    return _teamRebateImage;
}
- (UILabel *)rebateLabel {
    
    if (!_rebateLabel) {
        _rebateLabel = [[UILabel alloc] init];
        _rebateLabel.backgroundColor = [UIColor clearColor];
        _rebateLabel.text = @"已邀请返利";
        _rebateLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _rebateLabel.textColor = [UIColor CMLA6A6A6Color];
        [_rebateLabel sizeToFit];
        _rebateLabel.frame = CGRectMake(CGRectGetMinX(self.pinkGoldLabel.frame),
                                        CGRectGetMidY(self.teamRebateImage.frame) - CGRectGetHeight(_rebateLabel.frame)/2,
                                        CGRectGetWidth(_rebateLabel.frame),
                                        CGRectGetHeight(_rebateLabel.frame));
    }
    return _rebateLabel;
}

- (UILabel *)rebatePeopleLabel {
    if (!_rebatePeopleLabel) {
        _rebatePeopleLabel = [[UILabel alloc] init];
        _rebatePeopleLabel.backgroundColor = [UIColor clearColor];
        _rebatePeopleLabel.text = @"人";
        _rebatePeopleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _rebatePeopleLabel.textColor = [UIColor CMLA6A6A6Color];
        [_rebatePeopleLabel sizeToFit];
        _rebatePeopleLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame) + 48 * Proportion,
                                              CGRectGetMinY(self.rebateLabel.frame),
                                              CGRectGetWidth(_rebatePeopleLabel.frame),
                                              CGRectGetHeight(_rebatePeopleLabel.frame));
    }
    return _rebatePeopleLabel;
}

- (UILabel *)rebateCountLabel {
    if (!_rebateCountLabel) {
        _rebateCountLabel = [[UILabel alloc] init];
        _rebateCountLabel.backgroundColor = [UIColor clearColor];
        _rebateCountLabel.text = @"0";
        _rebateCountLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _rebateCountLabel.textColor = [UIColor CMLA6A6A6Color];
        _rebateCountLabel.textAlignment = NSTextAlignmentCenter;
        _rebateCountLabel.frame = CGRectMake(CGRectGetMaxX(self.rebateLabel.frame),
                                             CGRectGetMaxY(self.rebateLabel.frame) - 31 * Proportion,
                                             48 * Proportion,
                                             30 * Proportion);
    }
    return _rebateCountLabel;
}

/*团队人数*/
- (UILabel *)countALabel {
    
    if (!_countALabel) {
        _countALabel = [[UILabel alloc] init];
        _countALabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _countALabel.text = @"0";//
        _countALabel.textColor = [UIColor CMLA6A6A6Color];
        _countALabel.textAlignment = NSTextAlignmentCenter;
        _countALabel.frame = CGRectMake(CGRectGetMaxX(self.labelA.frame) + 4*Proportion, CGRectGetMaxY(self.labelA.frame) - 31*Proportion, 40*Proportion, 30*Proportion);
        
    }
    return _countALabel;
}

- (UILabel *)countBLabel {
    
    if (!_countBLabel) {
        _countBLabel = [[UILabel alloc] init];
        _countBLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _countBLabel.text = @"0";//
        _countBLabel.textColor = [UIColor CMLA6A6A6Color];
        _countBLabel.textAlignment = NSTextAlignmentCenter;
        _countBLabel.frame = CGRectMake(CGRectGetMaxX(self.labelB.frame) + 4*Proportion, CGRectGetMaxY(self.labelB.frame) - 31*Proportion, 40*Proportion, 30*Proportion);
    }
    return _countBLabel;
}

/*收益记录部分*/
- (UIView *)headView {
    
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(self.teamRebateImage.frame) + 60 * Proportion + StatusBarHeight + NavigationBarHeight,
                                                             WIDTH,
                                                             227 * Proportion + 100 * Proportion)];
        _headView.userInteractionEnabled = YES;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.cornerRadius = 28 * Proportion;
        _headView.clipsToBounds = YES;
        
    }
    return _headView;
}

- (UILabel *)earningsRecordLabel {
    
    if (!_earningsRecordLabel) {
        _earningsRecordLabel = [[UILabel alloc] init];
        _earningsRecordLabel.text = @"收益记录";
        _earningsRecordLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
        _earningsRecordLabel.textColor = [UIColor CMLUserBlackColor];
        [_earningsRecordLabel sizeToFit];
        _earningsRecordLabel.frame = CGRectMake(66 * Proportion,
                                               120 * Proportion,
                                               CGRectGetWidth(_earningsRecordLabel.frame),
                                               CGRectGetHeight(_earningsRecordLabel.frame));
    }
    return _earningsRecordLabel;
}

- (UILabel *)incomeSumLabel {
    
    if (!_incomeSumLabel) {
        _incomeSumLabel = [[UILabel alloc] init];
        _incomeSumLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _incomeSumLabel.text = @"收入￥0";
        [_incomeSumLabel sizeToFit];
        _incomeSumLabel.textColor = [UIColor CMLUserBlackColor];
        _incomeSumLabel.frame = CGRectMake(CGRectGetMinX(self.earningsRecordLabel.frame) + 1,
                                       CGRectGetMaxY(self.earningsRecordLabel.frame) + 10*Proportion,
                                       CGRectGetWidth(_incomeSumLabel.frame),
                                       CGRectGetHeight(_incomeSumLabel.frame));
    }
    
    return _incomeSumLabel;
}

- (UILabel *)getCashSumLabel {
    
    if (!_getCashSumLabel) {
        
        _getCashSumLabel = [[UILabel alloc] init];
        _getCashSumLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _getCashSumLabel.textColor = [UIColor CMLUserBlackColor];
        _getCashSumLabel.text = @"提现￥0";
        [_getCashSumLabel sizeToFit];

        _getCashSumLabel.frame = CGRectMake(CGRectGetMinX(self.earningsRecordLabel.frame) + 20 * Proportion + CGRectGetWidth(self.incomeSumLabel.frame),
                                            CGRectGetMaxY(self.earningsRecordLabel.frame) + 10 * Proportion,
                                            CGRectGetWidth(_getCashSumLabel.frame),
                                            CGRectGetHeight(_getCashSumLabel.frame));
 
    }
    return _getCashSumLabel;
}

- (UIView *)timeSelectorView {
    
    if (!_timeSelectorView) {
        _timeSelectorView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 198 * Proportion,
                                                                         CGRectGetMidY(self.earningsRecordLabel.frame) - 37*Proportion/2,
                                                                         164*Proportion,
                                                                         37*Proportion)];
        _timeSelectorView.backgroundColor = [UIColor whiteColor];
        _timeSelectorView.layer.borderColor = [UIColor CMLGray1Color].CGColor;
        _timeSelectorView.layer.borderWidth = 1.6 * Proportion;
        _timeSelectorView.layer.cornerRadius = 4 * Proportion;
        _timeSelectorView.clipsToBounds = YES;
        _timeSelectorView.userInteractionEnabled = YES;
    }
    return _timeSelectorView;
}

- (UILabel *)timeSelectorLabel {
    
    if (!_timeSelectorLabel) {
        
        _timeSelectorLabel = [[UILabel alloc] init];
        _timeSelectorLabel.text = self.timeString;
        _timeSelectorLabel.textColor = [UIColor CMLGray1Color];
        _timeSelectorLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _timeSelectorLabel.backgroundColor = [UIColor clearColor];
        _timeSelectorLabel.userInteractionEnabled = YES;
        [_timeSelectorLabel sizeToFit];
        _timeSelectorLabel.frame = CGRectMake(14 * Proportion,
                                                  CGRectGetHeight(self.timeSelectorView.frame)/2 - CGRectGetHeight(self.timeSelectorLabel.frame)/2,
                                                  CGRectGetWidth(self.timeSelectorLabel.frame) + 4*Proportion,
                                                  CGRectGetHeight(self.timeSelectorLabel.frame));
    }
    return _timeSelectorLabel;
}

- (UIImageView *)triangleImage {
    
    if (!_triangleImage) {
        
        _triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLWalletCenterTriangleImage]];
        _triangleImage.userInteractionEnabled = YES;
        _triangleImage.backgroundColor = [UIColor clearColor];
        [_triangleImage sizeToFit];
        _triangleImage.frame = CGRectMake(CGRectGetMaxX(self.timeSelectorLabel.frame) - 4*Proportion,
                                         CGRectGetMidY(self.timeSelectorLabel.frame) - CGRectGetHeight(_triangleImage.frame)/2,
                                         CGRectGetWidth(_triangleImage.frame),
                                         CGRectGetHeight(_triangleImage.frame));
    }
    return _triangleImage;
}

- (UIButton *)timeSelectorBtn {
    
    if (!_timeSelectorBtn) {
        _timeSelectorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeSelectorBtn.frame = CGRectMake(WIDTH - 198 * Proportion,
                                            CGRectGetMidY(self.earningsRecordLabel.frame) - 37*Proportion/2,
                                            163*Proportion,
                                            37*Proportion);
        _timeSelectorBtn.userInteractionEnabled = YES;
        _timeSelectorBtn.backgroundColor = [UIColor clearColor];
        
        [_timeSelectorBtn addTarget:self action:@selector(selectortimeSelectorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeSelectorBtn;
}

#pragma TableViewHeader
- (UIView *)tableHeader {
    
    if (!_tableHeader) {
        _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 930 * Proportion + 227 * Proportion + NavigationBarHeight + StatusBarHeight)];
        _tableHeader.backgroundColor = [UIColor whiteColor];
        _tableHeader.userInteractionEnabled = YES;

    }
    return _tableHeader;
}

- (UIView *)upgradeAlertView {
    if (!_upgradeAlertView) {
        _upgradeAlertView = [[UIView alloc] initWithFrame:CGRectMake(88 * Proportion,
                                                                     HEIGHT/2 - 435 * Proportion/2,
                                                                     WIDTH - 88 * Proportion * 2,
                                                                     435 * Proportion)];
        _upgradeAlertView.backgroundColor = [UIColor whiteColor];
        _upgradeAlertView.layer.cornerRadius = 16 * Proportion;
        _upgradeAlertView.clipsToBounds = YES;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"成为黛色会员即可享受提现特权";
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        titleLabel.textColor = [UIColor CMLBlack2D2D2DColor];
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(CGRectGetWidth(_upgradeAlertView.frame)/2 - CGRectGetWidth(titleLabel.frame)/2,
                                      74 * Proportion,
                                      CGRectGetWidth(titleLabel.frame),
                                      CGRectGetHeight(titleLabel.frame));
        [_upgradeAlertView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"黛色会员还享有更多返利优惠哦";
        contentLabel.textColor = [UIColor CMLGray515151Color];
        contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [contentLabel sizeToFit];
        contentLabel.frame = CGRectMake(CGRectGetWidth(_upgradeAlertView.frame)/2 - CGRectGetWidth(contentLabel.frame)/2,
                                        CGRectGetMaxY(titleLabel.frame) + 40 * Proportion,
                                        CGRectGetWidth(contentLabel.frame),
                                        CGRectGetHeight(contentLabel.frame));
        [_upgradeAlertView addSubview:contentLabel];
        
        UIButton *upgradeButton = [[UIButton alloc] init];
        [upgradeButton setBackgroundImage:[UIImage imageNamed:CMLNewPersonalMemberEnterButton] forState:UIControlStateNormal];
        [upgradeButton setTitle:@"立即升级" forState:UIControlStateNormal];
        [upgradeButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
        [upgradeButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        upgradeButton.tag = 5;
        [upgradeButton sizeToFit];
        upgradeButton.frame = CGRectMake(CGRectGetWidth(_upgradeAlertView.frame)/2 - CGRectGetWidth(upgradeButton.frame)/2,
                                         CGRectGetHeight(_upgradeAlertView.frame) - 78 * Proportion - CGRectGetHeight(upgradeButton.frame),
                                         CGRectGetWidth(upgradeButton.frame),
                                         CGRectGetHeight(upgradeButton.frame));
        [_upgradeAlertView addSubview:upgradeButton];
        [upgradeButton addTarget:self action:@selector(upgradeButtonClicked:) forControlEvents:UIControlEventTouchUpInside
         ];
    }
    return _upgradeAlertView;
}

/*收益记录*
- (CMLIncomeTableView *)walletTableView {
    
    if (!_walletTableView) {
        _walletTableView = [[CMLIncomeTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - SafeAreaBottomHeight) style:UITableViewStylePlain withTimeString:self.timeString];
        _walletTableView.backgroundColor = [UIColor whiteColor];
        _walletTableView.tableFooterView = [[UIView alloc] init];
        _walletTableView.incomeDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _walletTableView.estimatedRowHeight = 0;
            _walletTableView.estimatedSectionFooterHeight = 0;
            _walletTableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _walletTableView;
}
*/

/*提现*/
- (void)withdrawalsButtonClick {
    if ([[[DataManager lightData] readRoleId] intValue] < 5) {
        [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView bringSubviewToFront:self.shadowView];
        self.shadowView.hidden = NO;
        [self.shadowView addSubview:self.upgradeAlertView];
    }else {
        CMLMyWithdrawalViewController *myWithdrawalVC = [[CMLMyWithdrawalViewController alloc] init];
        myWithdrawalVC.delegate = self;
        [[VCManger mainVC] pushVC:myWithdrawalVC animate:YES];
    }
}

/*团队详情*/
- (void)teamDetailButtonClick {
    /*我的团队A级*/
    CMLTeamAViewController *vc = [[CMLTeamAViewController alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)teamPinkDetailButtonClick {
    CMLTeamPinkViewController *vc = [[CMLTeamPinkViewController alloc] init];
    vc.teamType = 2;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)teamRebateDetailButtonClick {
    CMLTeamPinkViewController *vc = [[CMLTeamPinkViewController alloc] init];
    vc.teamType = 4;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)upgradeButtonClicked:(UIButton *)button {
    [self setMemberCardMessageRequest];
}

/*日期选择*/
- (void)selectortimeSelectorBtnClick {
    self.isChangeTime = YES;
    [self.contentView bringSubviewToFront:self.shadowView];
    
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    CGSize strSize = [self.timeString sizeWithFontCompatible:KSystemFontSize15];
    UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 240*Proportion + strSize.height*3)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        pickView.frame = CGRectMake(0, HEIGHT - 240*Proportion - 15*3, WIDTH, 240*Proportion + strSize.height*3);
        
    }];
    
    
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.layer.cornerRadius = 4 * Proportion;
    pickView.showsSelectionIndicator = YES;
    pickView.dataSource = self;
    pickView.delegate = self;
    
    for (int i = 0; i < self.yearArray.count; i++) {
        
        if ([self.yearArray[i] isEqualToString:[self.timeString substringWithRange:NSMakeRange(0, 4)]]) {
            self.yearString = [self.timeString substringWithRange:NSMakeRange(0, 4)];
            [pickView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.monthArray.count; i++) {
        
        if ([self.monthArray[i] isEqualToString:[self.timeString substringWithRange:NSMakeRange(5, 2)]]) {
            self.monthString = [self.timeString substringWithRange:NSMakeRange(5, 2)];
            [pickView selectRow:i inComponent:1 animated:NO];
            break;
        }
    }
    self.shadowView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [weakSelf.shadowView addSubview:pickView];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArray.count;
    }else {
        return self.monthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@", self.yearArray[row]];
    }else {
        return [NSString stringWithFormat:@"%@", self.monthArray[row]];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return WIDTH/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60*Proportion;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickLabel = (UILabel *)view;
    if (!pickLabel) {
        pickLabel = [[UILabel alloc] init];
        pickLabel.adjustsFontSizeToFitWidth = YES;
        [pickLabel setTextAlignment:NSTextAlignmentCenter];
        [pickLabel setBackgroundColor:[UIColor clearColor]];
        [pickLabel setFont:KSystemFontSize15];
    }
    pickLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.yearString = [NSString stringWithFormat:@"%@", self.yearArray[row]];
    }else {
        self.monthString = [NSString stringWithFormat:@"%@", self.monthArray[row]];
    }
}

#pragma mark walletCenterNetwork
- (void)getWalletCenterRequest {
   
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:WalletCenterNewMyTeam paraDic:paraDic delegate:delegate];
    self.currentApiName = WalletCenterNewMyTeam;
    [self startLoading];
    
}

- (void)getWalletEarningsRecord {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.timeString forKey:@"time"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:WalletCenterNewMyTeamRecord paraDic:paraDic delegate:delegate];
    self.currentApiName = WalletCenterNewMyTeamRecord;
    [self startLoading];
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    if ([self.currentApiName isEqualToString:WalletCenterNewMyTeam]) {/*center*/
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([resObj.retCode intValue] == 0 && resObj) {
            [[DataManager lightData] saveOneCount:resObj.retData.oneCount];
            [[DataManager lightData] saveTwoCount:resObj.retData.twoCount];
            [[DataManager lightData] saveAllEarnings:resObj.retData.earnings];
            [[DataManager lightData] savePinkGoldCount:resObj.retData.pinkGoldCount];
            [[DataManager lightData] savePinkDiamondCount:resObj.retData.pinkDiamondCount];
            [[DataManager lightData] savePink:resObj.retData.pink];
//            [self loadWalletCenterView];
            [self refreshHeadView];
            
        }else if ([resObj.retCode intValue] == 100101) {
            
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }
        [self stopIndicatorLoading];
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:WalletCenterNewMyTeamRecord]) {/*B*/
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([resObj.retCode intValue] == 0 && resObj) {
            
            self.income = resObj.retData.income;
            self.getCash = resObj.retData.getCash;

//            [self loadWalletCenterView];
            [self refreshEarningsIntroView];
            
        }else if ([resObj.retCode intValue] == 100101) {
            
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }
        [self stopIndicatorLoading];
        [self stopLoading];
        
    }else if ([self.currentApiName isEqualToString:MemberRoleList]) {
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([resObj.retCode intValue] == 0) {
            UpGradeVC *vc = [[UpGradeVC alloc] init];
            vc.roleObj = resObj;
            vc.isUpgrade = YES;
            [[VCManger mainVC] pushVC:vc animate:NO];
        }else {
            [SVProgressHUD showErrorWithStatus:resObj.retMsg];
        }
    }
    [self stopIndicatorLoading];
    [self stopLoading];
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfNormalVC];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.shadowView.hidden = YES;
    if (self.isChangeTime) {
        self.isChangeTime = NO;
        
        NSString *year = [self.timeString substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [self.timeString substringWithRange:NSMakeRange(5, 2)];
        if ([year isEqualToString:self.yearString] && [month isEqualToString:self.monthString]) {
            
        }else {
            self.timeString = [NSString stringWithFormat:@"%@年%@月", self.yearString, self.monthString];

            [self loadHeadView];
            [self getWalletCenterRequest];
            
        }
    }
}

#pragma mark
- (void)refreshWalletCenterViewController {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    
    self.timeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[AppGroup getCurrentDate]]];
    
    [self loadHeadView];
    [self getWalletCenterRequest];
    
}

- (void)setBlackNavBar {
    
    [self.navView changeDefaultView];
    
}

- (void)setWhiteNavBar {

    [self.navView changeWhiteView];
    
}

- (void)dissCurrentDetailVC {
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void)refreshEarningsRecordViewWithIncomeTableViewWith:(NSString *)income withGetCash:(NSString *)getCash {
    
    self.income = income;
    self.getCash = getCash;
    
    [self refreshEarningsIntroView];
    
}

#pragma CMLBaseTableViewDlegate
- (void)startRequesting {
    [self startLoading];
}

- (void)endRequesting {
    [self stopLoading];
}

- (void)showSuccessActionMessage:(NSString *)str {
    [self showSuccessTemporaryMes:str];
}

- (void)showFailActionMessage:(NSString *)str {
    [self showFailTemporaryMes:str];
}

- (void)showAlterView:(NSString *)text {
    [self showAlterViewWithText:text];
}

/**/
- (void)setMemberCardMessageRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [NetWorkTask getRequestWithApiName:MemberRoleList param:paraDic delegate:delegate];
    self.currentApiName = MemberRoleList;
    [self startIndicatorLoading];
}

@end
