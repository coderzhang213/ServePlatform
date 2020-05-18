//
//  CMLCodeViewController.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/10/18.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLCodeViewController.h"
#import "VCManger.h"
#import "QiCodePreviewView.h"
#import "QiCodeManager.h"
#import "CMLWalletCenterNavView.h"
#import "CMLCodeScanViewController.h"
#import "UpGradeVC.h"

@interface CMLCodeViewController ()<UIImagePickerControllerDelegate, CMLWalletCenterNavViewDelegate, NetWorkProtocol>

@property (nonatomic, strong) QiCodePreviewView *previewView;

@property (nonatomic, strong) QiCodeManager *codeManager;

@property (nonatomic, strong) CMLWalletCenterNavView *navView;

@property (nonatomic, strong) UIImageView *upgradeImageView;

@property (nonatomic, strong) UIImageView *upgradeResultImageView;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, copy) NSString *scanCodeString;

@property (nonatomic, copy) NSString *currentApiName;

@end

@implementation CMLCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_codeManager stopScanning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navView = [[CMLWalletCenterNavView alloc] init];
    self.navView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.navView.titleContent = @"";
    self.navView.delegate = self;
    [self.contentView addSubview:self.navView];
    _previewView = [[QiCodePreviewView alloc] initWithFrame:self.view.bounds];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_previewView];
    [self.contentView bringSubviewToFront:self.navView];
    
    __weak typeof(self) weakSelf = self;
    _codeManager = [[QiCodeManager alloc] initWithPreviewView:_previewView completion:^{
        [weakSelf startScanning];
    }];
}

#pragma mark - CMLWalletCenterNavViewDelegate
- (void)dissCurrentDetailVC {
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - Action functions
- (void)photo:(id)sender {
    __weak typeof(self) weakSelf = self;
    [_codeManager presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull code) {
        weakSelf.scanCodeString = code;
        [weakSelf popUpgradeImageView];
    }];
}

#pragma mark - Private functions
- (void)startScanning {
    __weak typeof(self) weakSelf = self;
    [_codeManager startScanningWithCallback:^(NSString * _Nonnull code) {
        NSLog(@"%@", code);
        weakSelf.scanCodeString = code;
        [weakSelf popUpgradeImageView];
    } autoStop:YES];
}

- (void)popUpgradeImageView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    self.shadowView.hidden = NO;
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.shadowView addSubview:self.upgradeImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您即将升级为粉金会员";
    titleLabel.textColor = [UIColor CMLBlack2D2D2DColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [titleLabel sizeToFit];
    [self.upgradeImageView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"升级成功后，此卡及条码将永久失效";
    contentLabel.textColor = [UIColor CMLGray515151Color];
    contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [contentLabel sizeToFit];
    [self.upgradeImageView addSubview:contentLabel];
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:CMLPersonalUpgradeConfirmButton] forState:UIControlStateNormal];
    confirmButton.frame = CGRectMake(CGRectGetWidth(self.upgradeImageView.frame) - 46 * Proportion - 190 * Proportion,
                                     CGRectGetHeight(self.upgradeImageView.frame) - 94 * Proportion - 62 * Proportion,
                                     190 * Proportion,
                                     62 * Proportion);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
    [confirmButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.upgradeImageView addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor CMLGrayD5D5D5Color];
    cancelButton.layer.cornerRadius = 16 * Proportion;
    cancelButton.clipsToBounds = YES;
    cancelButton.frame = CGRectMake(46 * Proportion,
                                    CGRectGetHeight(self.upgradeImageView.frame) - 94 * Proportion - 62 * Proportion,
                                    190 * Proportion,
                                    62 * Proportion);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [cancelButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.upgradeImageView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel.frame = CGRectMake(CGRectGetWidth(self.upgradeImageView.frame)/2 - CGRectGetWidth(titleLabel.frame)/2,
                                  74 * Proportion,
                                  CGRectGetWidth(titleLabel.frame),
                                  CGRectGetHeight(titleLabel.frame));
    contentLabel.frame = CGRectMake(CGRectGetWidth(self.upgradeImageView.frame)/2 - CGRectGetWidth(contentLabel.frame)/2,
                                    CGRectGetMaxY(titleLabel.frame) + 40 * Proportion,
                                    CGRectGetWidth(contentLabel.frame),
                                    CGRectGetHeight(contentLabel.frame));
    
}

/*验证成功弹窗*/
- (void)showCodeScanCheckResultViewWith:(NSString *)retMsg {
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    self.shadowView.hidden = NO;
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.shadowView addSubview:self.upgradeResultImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    if ([retMsg isEqualToString:@"升级成功"]) {
        titleLabel.text = @"恭喜您已经成为粉金会员";
    }else {
        titleLabel.text = retMsg;
    }
    titleLabel.textColor = [UIColor CMLBlack2D2D2DColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [titleLabel sizeToFit];
    [self.upgradeResultImageView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(CGRectGetWidth(self.upgradeResultImageView.frame)/2 -       CGRectGetWidth(titleLabel.frame)/2,
                                  116 * Proportion,
                                  CGRectGetWidth(titleLabel.frame),
                                  CGRectGetHeight(titleLabel.frame));
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:CMLPersonalUpgradeSucceedButton] forState:UIControlStateNormal];
    [confirmButton sizeToFit];
    confirmButton.frame = CGRectMake(CGRectGetWidth(self.upgradeResultImageView.frame)/2 - CGRectGetWidth(confirmButton.frame)/2,
                                     CGRectGetHeight(self.upgradeResultImageView.frame) - 77 * Proportion - CGRectGetHeight(confirmButton.frame),
                                     CGRectGetWidth(confirmButton.frame),
                                     CGRectGetHeight(confirmButton.frame));
    
    if ([retMsg isEqualToString:@"升级成功"]) {
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(successButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [confirmButton setTitle:@"关闭" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(failButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
    [confirmButton setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.upgradeResultImageView addSubview:confirmButton];
    
    
}

/*确定-通过条形码升级*/
- (void)confirmButtonClicked {
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self checkCodeScanRequest];
}

/*取消-通过条形码升级*/
- (void)cancelButtonClicked {
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.shadowView.hidden = YES;
    [self startScanning];
}

/*跳转到会员中心页面*/
- (void)successButtonClicked {
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.shadowView.hidden = YES;
    [self setMemberCardMessageRequest];
}

/*条形码升级失败*/
- (void)failButtonClicked {
    [self cancelButtonClicked];
}

/*验证升级粉金条形码*/
- (void)checkCodeScanRequest {
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.scanCodeString forKey:@"code"];
    [paraDic setObject:[[DataManager lightData] readUserID] forKey:@"userId"];
    
    [NetWorkTask postResquestWithApiName:PersonCenterCodeScanCheck paraDic:paraDic delegate:delegate];
    self.currentApiName = PersonCenterCodeScanCheck;
    [self startIndicatorLoading];
}

/*角色信息*/
- (void)setMemberCardMessageRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [NetWorkTask getRequestWithApiName:MemberRoleList param:paraDic delegate:delegate];
    self.currentApiName = MemberRoleList;
    [self startIndicatorLoading];
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    if ([self.currentApiName isEqualToString:PersonCenterCodeScanCheck]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {/*条形码正确*/
            [self showCodeScanCheckResultViewWith:@"升级成功"];
        }else {
            [self showCodeScanCheckResultViewWith:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:MemberRoleList]) {
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([resObj.retCode intValue] == 0) {
            UpGradeVC *vc = [[UpGradeVC alloc] init];
            vc.roleObj = resObj;
            [vc requestUserData];
            [[VCManger mainVC] pushVC:vc animate:NO];
        }else {
            [SVProgressHUD showErrorWithStatus:resObj.retMsg];
        }
    }
    [self stopIndicatorLoading];
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
}

#pragma mark
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (UIImageView *)upgradeImageView {
    if (!_upgradeImageView) {
        _upgradeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2 - 574 * Proportion/2,
                                                                          HEIGHT/2 - 435 * Proportion/2,
                                                                          574 * Proportion,
                                                                          435 * Proportion)];
        _upgradeImageView.backgroundColor = [UIColor CMLWhiteColor];
        _upgradeImageView.userInteractionEnabled = YES;
        _upgradeImageView.layer.cornerRadius = 16 * Proportion;
        _upgradeImageView.clipsToBounds = YES;
    }
    return _upgradeImageView;
}

- (UIImageView *)upgradeResultImageView {
    if (!_upgradeResultImageView) {
        _upgradeResultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2 - 574 * Proportion/2,
                                                                                HEIGHT/2 - 380 * Proportion/2,
                                                                                574 * Proportion,
                                                                                380 * Proportion)];
        _upgradeResultImageView.backgroundColor = [UIColor CMLWhiteColor];
        _upgradeResultImageView.userInteractionEnabled = YES;
        _upgradeResultImageView.layer.cornerRadius = 16 * Proportion;
        _upgradeResultImageView.clipsToBounds = YES;
    }
    return _upgradeResultImageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
