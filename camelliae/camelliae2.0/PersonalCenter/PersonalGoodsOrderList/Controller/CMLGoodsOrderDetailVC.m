//
//  CMLGoodsOrderDetailVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLGoodsOrderDetailVC.h"
#import "VCManger.h"
#import "CMLServeObj.h"
#import "CMLOrderObj.h"
#import "LoginUserObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "GoodsModuleDetailMesObj.h"
#import "CMLOrderListObj.h"
#import "CMLOrderDetailMesOfBrandView.h"
#import "CMLExpressListVC.h"
#import "CMLNewInvoiceObj.h"
#import "CMLOrderInfoObj.h"

#define OrderDefaultVCLeftMargin            20
#define OrderDefaultVCBottomMargin          20
#define OrderDefaultVCImageViewHeight       160
#define OrderDefaultVCBtnHeight             44
#define AlterViewHeight                     300
#define AlterViewWidth                      620
#define CancelBtnLeftMargin                 60
#define CancelBtnHeight                     52
#define CancelBtnWidth                      160

@interface CMLGoodsOrderDetailVC ()<NavigationBarProtocol,NetWorkProtocol>

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,assign) BOOL isShowAll;

@property (nonatomic,assign) BOOL isExpress;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,strong) NSNumber *deducMoney;

@end

@implementation CMLGoodsOrderDetailVC



- (instancetype)initWithOrderId:(NSString *) orderId;{
    
    
    self = [super init];
    if (self) {
        
        self.orderId = orderId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (self.obj) {
        
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"订单详情";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    /*************************************************/
    
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
    
    [self setOrderDefaultMesRequest];
}

- (void) loadViews{
    
    [self.mainScrollView removeFromSuperview];
    
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - 20*Proportion - SafeAreaBottomHeight)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainScrollView.hidden = YES;
    [self.contentView addSubview:self.mainScrollView];
    
    /**用户信息*/
    UILabel *serveUserMesLab = [[UILabel alloc] init];
    serveUserMesLab.font = KSystemFontSize12;
    serveUserMesLab.textColor = [UIColor CMLLineGrayColor];
    serveUserMesLab.text = @"收货信息";
    [serveUserMesLab sizeToFit];
    serveUserMesLab.frame = CGRectMake(30*Proportion,
                                       10*Proportion,
                                       serveUserMesLab.frame.size.width,
                                       serveUserMesLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserMesLab];
    
    CMLLine *line1 = [[CMLLine alloc] init];
    line1.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(serveUserMesLab.frame) + 20*Proportion);
    line1.lineWidth = 1;
    line1.lineLength = WIDTH - 30*Proportion*2;
    line1.LineColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:line1];
    
    UILabel *serveUserNameLab = [[UILabel alloc] init];
    serveUserNameLab.font = KSystemFontSize14;
    serveUserNameLab.textColor = [UIColor CMLBlackColor];
    serveUserNameLab.text = [NSString stringWithFormat:@"姓名：%@",self.obj.retData.orderInfo.consigneeName];
    [serveUserNameLab sizeToFit];
    serveUserNameLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(serveUserMesLab.frame) + 20*Proportion*2,
                                        serveUserNameLab.frame.size.width,
                                        serveUserNameLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserNameLab];
    
    UILabel *serveUserTeleLab = [[UILabel alloc] init];
    serveUserTeleLab.font = KSystemFontSize14;
    serveUserTeleLab.textColor = [UIColor CMLBlackColor];
    serveUserTeleLab.text = [NSString stringWithFormat:@"电话：%@",self.obj.retData.orderInfo.consigneePhone];
    [serveUserTeleLab sizeToFit];
    serveUserTeleLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(serveUserNameLab.frame) + 20*Proportion,
                                        serveUserTeleLab.frame.size.width,
                                        serveUserTeleLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserTeleLab];
    
    UILabel *serveUserAddressPromLab = [[UILabel alloc] init];
    serveUserAddressPromLab.font = KSystemFontSize14;
    serveUserAddressPromLab.textColor = [UIColor CMLBlackColor];
    serveUserAddressPromLab.text = @"地址：";
    [serveUserAddressPromLab sizeToFit];
    serveUserAddressPromLab.frame = CGRectMake(30*Proportion,
                                               CGRectGetMaxY(serveUserTeleLab.frame) + 20*Proportion,
                                               serveUserAddressPromLab.frame.size.width,
                                               serveUserAddressPromLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserAddressPromLab];
    
    UILabel *serveUserAddressLab = [[UILabel alloc] init];
    serveUserAddressLab.font = KSystemFontSize14;
    serveUserAddressLab.textColor = [UIColor CMLBlackColor];
    serveUserAddressLab.text = self.obj.retData.orderInfo.consigneeAddress;
    serveUserAddressLab.textAlignment = NSTextAlignmentLeft;
    [serveUserAddressLab sizeToFit];
    if (serveUserAddressLab.frame.size.width > WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion ) {
        serveUserAddressLab.numberOfLines = 0;
        CGRect currentRect =  [serveUserAddressLab.text boundingRectWithSize:CGSizeMake(WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion, HEIGHT)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                                     context:nil];
        serveUserAddressLab.frame = CGRectMake(CGRectGetMaxX(serveUserAddressPromLab.frame),
                                               CGRectGetMaxY(serveUserTeleLab.frame) + 20*Proportion,
                                               WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion,
                                               currentRect.size.height);
    }else{
        serveUserAddressLab.numberOfLines = 1;
        serveUserAddressLab.frame = CGRectMake(CGRectGetMaxX(serveUserAddressPromLab.frame),
                                               CGRectGetMaxY(serveUserTeleLab.frame) + 20*Proportion,
                                               serveUserAddressLab.frame.size.width,
                                               serveUserAddressLab.frame.size.height);
        
        
    }
    [self.mainScrollView addSubview:serveUserAddressLab];
    
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(serveUserAddressLab.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    spaceView1.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:spaceView1];
    
    CMLOrderListObj *obj = [CMLOrderListObj getBaseObjFrom:self.obj.retData];
    CMLOrderDetailMesOfBrandView *detailMessageView = [[CMLOrderDetailMesOfBrandView alloc] initWith:obj andDeducMoney:self.deducMoney];
    detailMessageView.frame = CGRectMake(0,
                                         CGRectGetMaxY(spaceView1.frame),
                                         WIDTH,
                                         detailMessageView.curentHeight);
    [self.mainScrollView addSubview:detailMessageView];
    self.isExpress = detailMessageView.isHasExpress;

    
    UIView *buyerMessageBgView = [[UIView alloc] init];
    buyerMessageBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:buyerMessageBgView];
    if (self.obj.retData.orderInfo.remark.length > 0 ) {
        
        UILabel *buyermessageLab = [[UILabel alloc] init];
        buyermessageLab.text = [NSString stringWithFormat:@"买家留言：%@",self.obj.retData.orderInfo.remark];
        buyermessageLab.font = KSystemFontSize13;
        buyermessageLab.numberOfLines = 0;
        buyermessageLab.textColor = [UIColor CMLBlackColor];
        [buyermessageLab sizeToFit];
        
        if (buyermessageLab.frame.size.width > WIDTH - 30*Proportion*2) {
            
            CGRect currentRect = [buyermessageLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, 1000)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                                    context:nil];
            buyermessageLab.frame = CGRectMake(30*Proportion,
                                               20*Proportion,
                                               WIDTH - 30*Proportion*2,
                                               currentRect.size.height);
        }else{
        
            buyermessageLab.frame = CGRectMake(30*Proportion,
                                               20*Proportion,
                                               WIDTH - 30*Proportion*2,
                                               buyermessageLab.frame.size.height);
        }

        [buyerMessageBgView addSubview:buyermessageLab];
        
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(buyermessageLab.frame) + 20*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
        newView.backgroundColor = [UIColor CMLUserGrayColor];
        [buyerMessageBgView addSubview:newView];
        buyerMessageBgView.frame = CGRectMake(0,
                                              CGRectGetMaxY(detailMessageView.frame),
                                              WIDTH,
                                              CGRectGetMaxY(newView.frame));
        
        
        
    }else{
        
        buyerMessageBgView.frame = CGRectMake(0,
                                              CGRectGetMaxY(detailMessageView.frame),
                                              WIDTH,
                                              0);
    }
    
    self.currentHeight = CGRectGetMaxY(buyerMessageBgView.frame);
    [self loadInvoiceMesAndPayMes:CGRectGetMaxY(buyerMessageBgView.frame)];

    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.alpha = 0;
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.shadowView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.shadowView.frame.size.width/2.0 - AlterViewWidth*Proportion/2.0 ,
                                                              self.shadowView.frame.size.height/2.0 - AlterViewHeight*Proportion/2.0,
                                                              AlterViewWidth*Proportion,
                                                              AlterViewHeight*Proportion)];
    bgView.backgroundColor = [UIColor CMLWhiteColor];
    bgView.layer.cornerRadius = 4;
    [self.shadowView addSubview:bgView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor CMLUserBlackColor];
    nameLabel.text = @"联系卡枚连";
    nameLabel.font = KSystemFontSize14;
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(AlterViewWidth*Proportion/2.0 - nameLabel.frame.size.width/2.0,
                                 AlterViewHeight*Proportion/4.0 - 5*Proportion - nameLabel.frame.size.height,
                                 nameLabel.frame.size.width,
                                 nameLabel.frame.size.height);
    [bgView addSubview:nameLabel];
    
    UILabel *phoneNum = [[UILabel alloc] init];
    phoneNum.textColor = [UIColor CMLUserBlackColor];
    phoneNum.text = [NSString stringWithFormat:@"%@",self.obj.retData.orderInfo.customerPhone];
    phoneNum.font = KSystemFontSize14;
    [phoneNum sizeToFit];
    phoneNum.frame = CGRectMake(AlterViewWidth*Proportion/2.0 - phoneNum.frame.size.width/2.0,
                                AlterViewHeight*Proportion/4.0 + 5*Proportion ,
                                phoneNum.frame.size.width,
                                phoneNum.frame.size.height);
    [bgView addSubview:phoneNum];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.LineColor = [UIColor CMLPromptGrayColor];
    line.lineWidth = 0.5;
    line.lineLength = AlterViewWidth*Proportion - OrderDefaultVCLeftMargin*Proportion*2;
    line.startingPoint = CGPointMake(OrderDefaultVCLeftMargin*Proportion, AlterViewHeight*Proportion/2.0);
    [bgView addSubview:line];
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CancelBtnLeftMargin*Proportion,
                                                                      AlterViewHeight*Proportion/4.0*3.0 - CancelBtnHeight*Proportion/2.0,
                                                                      CancelBtnWidth*Proportion,
                                                                      CancelBtnHeight*Proportion)];
    cancelBtn.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = CancelBtnHeight*Proportion/2.0;
    cancelBtn.titleLabel.font = KSystemFontSize14;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor CMLPromptGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelCall) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton * confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(AlterViewWidth*Proportion -CancelBtnLeftMargin*Proportion - CancelBtnWidth*Proportion,
                                                                       AlterViewHeight*Proportion/4.0*3.0 - CancelBtnHeight*Proportion/2.0,
                                                                       CancelBtnWidth*Proportion,
                                                                       CancelBtnHeight*Proportion)];
    confirmBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.cornerRadius = CancelBtnHeight*Proportion/2.0;
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmCall) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    
}

- (void) loadInvoiceMesAndPayMes:(CGFloat) currentY{
    
    
    [[self.mainScrollView viewWithTag:1] removeFromSuperview];
    UIView *invoiceMessageBgView = [[UIView alloc] init];
    invoiceMessageBgView.backgroundColor = [UIColor CMLWhiteColor];
    invoiceMessageBgView.tag = 1;
    [self.mainScrollView addSubview:invoiceMessageBgView];
    
    if ([self.obj.retData.orderInfo.invoiceStatus intValue] == 1) {
        
        UILabel *serveInvoiceMesLab = [[UILabel alloc] init];
        serveInvoiceMesLab.font = KSystemFontSize12;
        serveInvoiceMesLab.textColor = [UIColor CMLLineGrayColor];
        serveInvoiceMesLab.text = @"发票信息";
        [serveInvoiceMesLab sizeToFit];
        serveInvoiceMesLab.frame = CGRectMake(30*Proportion,
                                              74*Proportion/2.0 - serveInvoiceMesLab.frame.size.height/2.0,
                                              serveInvoiceMesLab.frame.size.width,
                                              serveInvoiceMesLab.frame.size.height);
        [invoiceMessageBgView addSubview:serveInvoiceMesLab];
        
        UILabel *serveInvoiceTypeMesLab = [[UILabel alloc] init];
        serveInvoiceTypeMesLab.font = KSystemFontSize12;
        serveInvoiceTypeMesLab.textColor = [UIColor CMLBlackColor];
        [invoiceMessageBgView addSubview:serveInvoiceTypeMesLab];
        
        UIView *spaceLine3 = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                      74*Proportion,
                                                                      WIDTH - 30*Proportion*2,
                                                                      1*Proportion)];
        spaceLine3.backgroundColor = [UIColor CMLSerachLineGrayColor];
        [invoiceMessageBgView addSubview:spaceLine3];
        
        
        if ([self.obj.retData.orderInfo.invoiceInfo.invoiceTop intValue] == 1) {
            
            serveInvoiceTypeMesLab.text = @"发票抬头：个人     发票类型：普通发票";
            [serveInvoiceTypeMesLab sizeToFit];
            serveInvoiceTypeMesLab.frame = CGRectMake(58*Proportion,
                                                      74*Proportion + 84*Proportion/2.0 - serveInvoiceTypeMesLab.frame.size.height/2.0,
                                                      serveInvoiceTypeMesLab.frame.size.width,
                                                      serveInvoiceTypeMesLab.frame.size.height);
            
            UIButton *showAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              74*Proportion,
                                                                              WIDTH,
                                                                              84*Proportion)];
            showAllBtn.backgroundColor = [UIColor clearColor];
            [invoiceMessageBgView addSubview:showAllBtn];
            [showAllBtn addTarget:self action:@selector(showAllInvoice) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.isShowAll) {
                UILabel *lab1 = [[UILabel alloc] init];
                lab1.font = KSystemFontSize12;
                lab1.textColor = [UIColor CMLUserBlackColor];
                if (self.obj.retData.orderInfo.invoiceInfo.personalName.length > 0) {
                    
                    lab1.text = [NSString stringWithFormat:@"个人姓名：%@",self.obj.retData.orderInfo.invoiceInfo.personalName];
                }else{
                    
                    lab1.text = @"";
                }
                [lab1 sizeToFit];
                lab1.frame = CGRectMake(58*Proportion,
                                        74*Proportion + 84*Proportion,
                                        WIDTH - 58*Proportion - 30*Proportion,
                                        lab1.frame.size.height);
                [invoiceMessageBgView addSubview:lab1];
                
                UILabel *lab2 = [[UILabel alloc] init];
                lab2.font = KSystemFontSize12;
                lab2.textColor = [UIColor CMLUserBlackColor];
                if (self.obj.retData.orderInfo.invoiceInfo.idCard.length > 0) {
                    
                    lab2.text = [NSString stringWithFormat:@"身份号码：%@",self.obj.retData.orderInfo.invoiceInfo.idCard];
                }else{
                    
                    lab2.text = @"";
                }
                [lab2 sizeToFit];
                lab2.frame = CGRectMake(58*Proportion,
                                        CGRectGetMaxY(lab1.frame) + 20*Proportion,
                                        WIDTH - 58*Proportion - 30*Proportion,
                                        lab2.frame.size.height);
                [invoiceMessageBgView addSubview:lab2];
                
                UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(lab2.frame) + 40*Proportion,
                                                                           WIDTH,
                                                                           20*Proportion)];
                endView.backgroundColor = [UIColor CMLUserGrayColor];
                [invoiceMessageBgView addSubview:endView];
                
                invoiceMessageBgView.frame = CGRectMake(0,
                                                        currentY,
                                                        WIDTH,
                                                        CGRectGetMaxY(endView.frame));
            }else{
                
                UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           74*Proportion + 84*Proportion,
                                                                           WIDTH,
                                                                           20*Proportion)];
                endView.backgroundColor = [UIColor CMLUserGrayColor];
                [invoiceMessageBgView addSubview:endView];
                
                invoiceMessageBgView.frame = CGRectMake(0,
                                                        currentY,
                                                        WIDTH,
                                                        CGRectGetMaxY(endView.frame));
                
            }
            
            
        }else{
            
            if ([self.obj.retData.orderInfo.invoiceInfo.type intValue] == 1) {
                
                serveInvoiceTypeMesLab.text = @"发票抬头：企业     发票类型：普通发票";
                [serveInvoiceTypeMesLab sizeToFit];
                serveInvoiceTypeMesLab.frame = CGRectMake(58*Proportion,
                                                          74*Proportion + 84*Proportion/2.0 - serveInvoiceTypeMesLab.frame.size.height/2.0,
                                                          serveInvoiceTypeMesLab.frame.size.width,
                                                          serveInvoiceTypeMesLab.frame.size.height);
                UIButton *showAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                  74*Proportion,
                                                                                  WIDTH,
                                                                                  84*Proportion)];
                showAllBtn.backgroundColor = [UIColor clearColor];
                [invoiceMessageBgView addSubview:showAllBtn];
                [showAllBtn addTarget:self action:@selector(showAllInvoice) forControlEvents:UIControlEventTouchUpInside];
                
                if (self.isShowAll) {
                    
                    UILabel *lab1 = [[UILabel alloc] init];
                    lab1.font = KSystemFontSize12;
                    lab1.textColor = [UIColor CMLUserBlackColor];
                    lab1.text = [NSString stringWithFormat:@"纳税人税号：%@",self.obj.retData.orderInfo.invoiceInfo.taxpayerCode];
                    [lab1 sizeToFit];
                    lab1.frame = CGRectMake(58*Proportion,
                                            74*Proportion + 84*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            lab1.frame.size.height);
                    [invoiceMessageBgView addSubview:lab1];
                    
                    UILabel *lab2 = [[UILabel alloc] init];
                    lab2.font = KSystemFontSize12;
                    lab2.textColor = [UIColor CMLUserBlackColor];
                    lab2.text = [NSString stringWithFormat:@"单位名称：%@",self.obj.retData.orderInfo.invoiceInfo.companyName];
                    lab2.numberOfLines = 0;
                    CGRect currentRect = [lab2.text boundingRectWithSize:CGSizeMake(WIDTH - 58*Proportion - 30*Proportion, HEIGHT)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                 context:nil];
                    lab2.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab1.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            currentRect.size.height);
                    [invoiceMessageBgView addSubview:lab2];
                    
                    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(lab2.frame) + 40*Proportion,
                                                                               WIDTH,
                                                                               20*Proportion)];
                    endView.backgroundColor = [UIColor CMLUserGrayColor];
                    [invoiceMessageBgView addSubview:endView];
                    
                    invoiceMessageBgView.frame = CGRectMake(0,
                                                            currentY,
                                                            WIDTH,
                                                            CGRectGetMaxY(endView.frame));
                    
                }else{
                    
                    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               74*Proportion + 84*Proportion,
                                                                               WIDTH,
                                                                               20*Proportion)];
                    endView.backgroundColor = [UIColor CMLUserGrayColor];
                    [invoiceMessageBgView addSubview:endView];
                    
                    invoiceMessageBgView.frame = CGRectMake(0,
                                                            currentY,
                                                            WIDTH,
                                                            CGRectGetMaxY(endView.frame));
                    
                }
                
                
                
            }else if ([self.obj.retData.orderInfo.invoiceInfo.invoiceTop intValue] == 2){
                
                serveInvoiceTypeMesLab.text = @"发票抬头：企业     发票类型：专用发票";
                [serveInvoiceTypeMesLab sizeToFit];
                serveInvoiceTypeMesLab.frame = CGRectMake(58*Proportion,
                                                          74*Proportion + 84*Proportion/2.0 - serveInvoiceTypeMesLab.frame.size.height/2.0,
                                                          serveInvoiceTypeMesLab.frame.size.width,
                                                          serveInvoiceTypeMesLab.frame.size.height);
                UIButton *showAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                  74*Proportion,
                                                                                  WIDTH,
                                                                                  84*Proportion)];
                showAllBtn.backgroundColor = [UIColor clearColor];
                [invoiceMessageBgView addSubview:showAllBtn];
                [showAllBtn addTarget:self action:@selector(showAllInvoice) forControlEvents:UIControlEventTouchUpInside];
                
                if (self.isShowAll) {
                    
                    UILabel *lab1 = [[UILabel alloc] init];
                    lab1.font = KSystemFontSize12;
                    lab1.textColor = [UIColor CMLUserBlackColor];
                    lab1.text = [NSString stringWithFormat:@"纳税人税号：%@",self.obj.retData.orderInfo.invoiceInfo.taxpayerCode];
                    [lab1 sizeToFit];
                    lab1.frame = CGRectMake(58*Proportion,
                                            74*Proportion + 84*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            lab1.frame.size.height);
                    [invoiceMessageBgView addSubview:lab1];
                    
                    UILabel *lab2 = [[UILabel alloc] init];
                    lab2.font = KSystemFontSize12;
                    lab2.textColor = [UIColor CMLUserBlackColor];
                    lab2.text = [NSString stringWithFormat:@"单位名称：%@",self.obj.retData.orderInfo.invoiceInfo.companyName];
                    lab2.numberOfLines = 0;
                    CGRect currentRect = [lab2.text boundingRectWithSize:CGSizeMake(WIDTH - 58*Proportion - 30*Proportion, HEIGHT)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                 context:nil];
                    lab2.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab1.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            currentRect.size.height);
                    [invoiceMessageBgView addSubview:lab2];
                    
                    UILabel *lab3 = [[UILabel alloc] init];
                    lab3.font = KSystemFontSize12;
                    lab3.textColor = [UIColor CMLUserBlackColor];
                    lab3.text = [NSString stringWithFormat:@"公司地址：%@",self.obj.retData.orderInfo.invoiceInfo.companyAddress];
                    lab3.numberOfLines = 0;
                    CGRect currentRect3 = [lab2.text boundingRectWithSize:CGSizeMake(WIDTH - 58*Proportion - 30*Proportion, HEIGHT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                  context:nil];
                    lab3.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab2.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            currentRect3.size.height);
                    [invoiceMessageBgView addSubview:lab3];
                    
                    
                    UILabel *lab4 = [[UILabel alloc] init];
                    lab4.font = KSystemFontSize12;
                    lab4.textColor = [UIColor CMLUserBlackColor];
                    lab4.text = [NSString stringWithFormat:@"公司电话：%@",self.obj.retData.orderInfo.invoiceInfo.companyPhone];
                    [lab4 sizeToFit];
                    lab4.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab3.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            lab4.frame.size.height);
                    [invoiceMessageBgView addSubview:lab4];
                    
                    UILabel *lab5 = [[UILabel alloc] init];
                    lab5.font = KSystemFontSize12;
                    lab5.textColor = [UIColor CMLUserBlackColor];
                    lab5.text = [NSString stringWithFormat:@"开户银行：%@",self.obj.retData.orderInfo.invoiceInfo.bankName];
                    [lab5 sizeToFit];
                    lab5.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab4.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            lab4.frame.size.height);
                    [invoiceMessageBgView addSubview:lab5];
                    
                    UILabel *lab6 = [[UILabel alloc] init];
                    lab6.font = KSystemFontSize12;
                    lab6.textColor = [UIColor CMLUserBlackColor];
                    lab6.text = [NSString stringWithFormat:@"银行账号：%@",self.obj.retData.orderInfo.invoiceInfo.bankAccount];
                    [lab6 sizeToFit];
                    lab6.frame = CGRectMake(58*Proportion,
                                            CGRectGetMaxY(lab5.frame) + 20*Proportion,
                                            WIDTH - 58*Proportion - 30*Proportion,
                                            lab6.frame.size.height);
                    [invoiceMessageBgView addSubview:lab6];
                    
                    
                    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(lab6.frame) + 40*Proportion,
                                                                               WIDTH,
                                                                               20*Proportion)];
                    endView.backgroundColor = [UIColor CMLUserGrayColor];
                    [invoiceMessageBgView addSubview:endView];
                    
                    invoiceMessageBgView.frame = CGRectMake(0,
                                                            currentY,
                                                            WIDTH,
                                                            CGRectGetMaxY(endView.frame));
                    
                }else{
                    
                    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               74*Proportion + 84*Proportion,
                                                                               WIDTH,
                                                                               20*Proportion)];
                    endView.backgroundColor = [UIColor CMLUserGrayColor];
                    [invoiceMessageBgView addSubview:endView];
                    
                    invoiceMessageBgView.frame = CGRectMake(0,
                                                            currentY,
                                                            WIDTH,
                                                            CGRectGetMaxY(endView.frame));
                    
                }
            }
        }
        
    }else{
        
        invoiceMessageBgView.frame = CGRectMake(0,
                                                currentY,
                                                WIDTH,
                                                0);
    }
    
    /**支付信息*/
    [[self.mainScrollView viewWithTag:2] removeFromSuperview];
    UILabel *payMes = [[UILabel alloc] init];
    payMes.text = @"支付信息";
    payMes.textColor = [UIColor CMLtextInputGrayColor];
    payMes.font = KSystemFontSize12;
    [payMes sizeToFit];
    payMes.tag = 2;
    payMes.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(invoiceMessageBgView.frame) + 30*Proportion,
                              payMes.frame.size.width,
                              payMes.frame.size.height);
    [self.mainScrollView addSubview:payMes];
    
    
    [[self.mainScrollView viewWithTag:3] removeFromSuperview];
    CMLLine *lineFive = [[CMLLine alloc] init];
    lineFive.startingPoint = CGPointMake(OrderDefaultVCLeftMargin*Proportion, CGRectGetMaxY(payMes.frame) + OrderDefaultVCBottomMargin*Proportion);
    lineFive.lineWidth = 1;
    lineFive.lineLength = WIDTH- OrderDefaultVCLeftMargin*Proportion*2;
    lineFive.LineColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:lineFive];
    lineFive.tag = 3;
    
    
    [[self.mainScrollView viewWithTag:4] removeFromSuperview];
    UILabel *orderNum = [[UILabel alloc] init];
    orderNum.font = KSystemFontSize12;
    orderNum.textColor = [UIColor CMLUserBlackColor];
    orderNum.text = [NSString stringWithFormat:@"订单编号：%@",self.obj.retData.orderInfo.orderId];
    [orderNum sizeToFit];
    orderNum.frame = CGRectMake(payMes.frame.origin.x,
                                lineFive.startingPoint.y + OrderDefaultVCBottomMargin*Proportion,
                                orderNum.frame.size.width,
                                orderNum.frame.size.height);
    [self.mainScrollView addSubview:orderNum];
    orderNum.tag = 4;
    
    
    [[self.mainScrollView viewWithTag:5] removeFromSuperview];
    UILabel *payStyle = [[UILabel alloc] init];
    payStyle.font = KSystemFontSize12;
    payStyle.textColor = [UIColor CMLUserBlackColor];
    payStyle.text = [NSString stringWithFormat:@"支付方式：%@",self.obj.retData.orderInfo.payClientTypeName];
    [payStyle sizeToFit];
    payStyle.frame = CGRectMake(payMes.frame.origin.x,
                                CGRectGetMaxY(orderNum.frame) + OrderDefaultVCBottomMargin*Proportion,
                                payStyle.frame.size.width,
                                payStyle.frame.size.height);
    [self.mainScrollView addSubview:payStyle];
    payStyle.tag = 5;
    
    
    [[self.mainScrollView viewWithTag:6] removeFromSuperview];
    UILabel *payTime = [[UILabel alloc] init];
    payTime.font = KSystemFontSize12;
    payTime.textColor = [UIColor CMLUserBlackColor];
    payTime.text = [NSString stringWithFormat:@"支付时间：%@",self.obj.retData.orderInfo.payEndTime];
    [payTime sizeToFit];
    payTime.frame = CGRectMake(payMes.frame.origin.x,
                               CGRectGetMaxY(payStyle.frame) +  OrderDefaultVCBottomMargin*Proportion,
                               payTime.frame.size.width,
                               payTime.frame.size.height);
    [self.mainScrollView addSubview:payTime];
    payTime.tag = 6;
    
    
    [[self.mainScrollView viewWithTag:7] removeFromSuperview];
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(payTime.frame) + 30*Proportion,
                                                                 WIDTH,
                                                                 20*Proportion)];
    spaceView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.mainScrollView addSubview:spaceView];
    spaceView.tag = 7;
    
    
    [[self.mainScrollView viewWithTag:8] removeFromSuperview];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(spaceView.frame),
                                                                  WIDTH, 100*Proportion)];
    bottomView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:bottomView];
    bottomView.tag = 8;
    
    
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(bottomView.frame));
    
    UIButton *contactBtn = [[UIButton alloc] init];
    contactBtn.titleLabel.font = KSystemFontSize12;
    [contactBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [contactBtn sizeToFit];
    
    contactBtn.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    contactBtn.layer.borderWidth = 1;
    contactBtn.layer.cornerRadius = 6*Proportion;
    [bottomView addSubview:contactBtn];
    [contactBtn addTarget:self action:@selector(contactus) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isExpress) {
        UIButton *expressBtn = [[UIButton alloc] init];
        expressBtn.titleLabel.font = KSystemFontSize12;
        [expressBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [expressBtn setTitleColor:[UIColor CMLGreeenColor] forState:UIControlStateNormal];
        [expressBtn sizeToFit];
        expressBtn.frame = CGRectMake(WIDTH - (expressBtn.frame.size.width + 20*Proportion*2) - 30*Proportion,
                                      100*Proportion/2.0 - OrderDefaultVCBtnHeight*Proportion/2.0,
                                      expressBtn.frame.size.width + 20*Proportion*2,
                                      OrderDefaultVCBtnHeight*Proportion);
        expressBtn.layer.borderColor = [UIColor CMLGreeenColor].CGColor;
        expressBtn.layer.borderWidth = 1;
        expressBtn.layer.cornerRadius = 6*Proportion;
        [bottomView addSubview:expressBtn];
        [expressBtn addTarget:self action:@selector(enterCMLExpressListVC) forControlEvents:UIControlEventTouchUpInside];
        
        contactBtn.frame = CGRectMake(expressBtn.frame.origin.x - (contactBtn.frame.size.width + 20*Proportion*2) - 30*Proportion,
                                      100*Proportion/2.0 - OrderDefaultVCBtnHeight*Proportion/2.0,
                                      contactBtn.frame.size.width + 20*Proportion*2,
                                      OrderDefaultVCBtnHeight*Proportion);
    }else{
        
        contactBtn.frame = CGRectMake(WIDTH - (contactBtn.frame.size.width + 20*Proportion*2) - 30*Proportion,
                                      100*Proportion/2.0 - OrderDefaultVCBtnHeight*Proportion/2.0,
                                      contactBtn.frame.size.width + 20*Proportion*2,
                                      OrderDefaultVCBtnHeight*Proportion);
    }
    
    
}

- (void) cancelCall{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.alpha = 0;
    }];
}

- (void) confirmCall{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.obj.retData.orderInfo.customerPhone]]];
}

- (void) setOrderDefaultMesRequest{
    
    [self startLoading];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.orderId forKey:@"orderId"];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,self.orderId,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:GoodsOrderDetailMessage param:paraDic delegate:delegate];
    self.currentApiName = GoodsOrderDetailMessage;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GoodsOrderDetailMessage]) {
        [self stopLoading];
        NSLog(@"***%@",responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
//            self.deducMoney = [[[(NSDictionary *)responseResult valueForKey:@"retData"] valueForKey:@"orderInfo"] valueForKey:@"deduc_money"];//获取不到数据null报错
            
            self.obj = obj;
            
            CMLOrderInfoObj *orderInfo = [CMLOrderInfoObj getBaseObjFrom:obj.retData.orderInfo];
            
            self.deducMoney = orderInfo.deduc_money;
            
            [self loadViews];
            
            self.mainScrollView.hidden = NO;
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - contactus
- (void) contactus{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.alpha = 1;
    }];
}

#pragma mark - enterServeDetailVC
- (void) enterServeDetailVC{
    
    CMLCommodityDetailMessageVC *vc = [[CMLCommodityDetailMessageVC alloc] initWithObjId:self.obj.retData.goodsInfo.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterCMLExpressListVC{
    
    CMLOrderListObj *obj = [CMLOrderListObj getBaseObjFrom:self.obj.retData];
    CMLExpressListVC *vc = [[CMLExpressListVC alloc] initWith:obj];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) showAllInvoice{
    
    self.isShowAll = !self.isShowAll;
    [self loadInvoiceMesAndPayMes:self.currentHeight];
    self.mainScrollView.hidden = NO;
}
@end
