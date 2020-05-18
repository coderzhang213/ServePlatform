//
//  CMLSubscribeDefaultVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/4/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLSubscribeDefaultVC.h"
#import "VCManger.h"
#import "CMLServeObj.h"
#import "CMLOrderObj.h"
#import "LoginUserObj.h"
#import "ServeDefaultVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "ActivityDefaultVC.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLInvitationView.h"
#import "BrandAndServeObj.h"
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

@interface CMLSubscribeDefaultVC ()<NetWorkProtocol,NavigationBarProtocol, InvitationViewDelegate>

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic, strong) BrandAndServeObj *projectInfo;

@property (nonatomic, strong) CMLInvitationView *invitationView;

@property (nonatomic,strong) UIImageView *QRImageView;

@end

@implementation CMLSubscribeDefaultVC

- (instancetype)initWithOrderId:(NSString *) orderId isDeleted:(NSNumber *) state{

    self = [super init];
    if (self) {
        
        self.orderId = orderId;
        self.isDeleted = state;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"PageThreeOfPersonalOrder"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageThreeOfPersonalOrder"];
    
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
    serveUserMesLab.text = @"用户信息";
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
    serveUserNameLab.text = [NSString stringWithFormat:@"姓名：%@",self.obj.retData.orderInfo.contactName];
    [serveUserNameLab sizeToFit];
    serveUserNameLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(serveUserMesLab.frame) + 20*Proportion*2,
                                        serveUserNameLab.frame.size.width,
                                        serveUserNameLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserNameLab];
    
    UILabel *serveUserTeleLab = [[UILabel alloc] init];
    serveUserTeleLab.font = KSystemFontSize14;
    serveUserTeleLab.textColor = [UIColor CMLBlackColor];
    serveUserTeleLab.text = [NSString stringWithFormat:@"电话：%@",self.obj.retData.orderInfo.contactPhone];
    [serveUserTeleLab sizeToFit];
    serveUserTeleLab.frame = CGRectMake(30*Proportion,
                                        CGRectGetMaxY(serveUserNameLab.frame) + 20*Proportion,
                                        serveUserTeleLab.frame.size.width,
                                        serveUserTeleLab.frame.size.height);
    [self.mainScrollView addSubview:serveUserTeleLab];
    
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(serveUserTeleLab.frame) + 40*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    spaceView1.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:spaceView1];
    
    
    /**服务信息*/
    UILabel *serveMesLabel = [[UILabel alloc] init];
    serveMesLabel.text = @"活动信息";
    serveMesLabel.textColor = [UIColor CMLtextInputGrayColor];
    serveMesLabel.font = KSystemFontSize12;
    [serveMesLabel sizeToFit];
    serveMesLabel.frame = CGRectMake(30*Proportion,
                                     40*Proportion + CGRectGetMaxY(spaceView1.frame),
                                     serveMesLabel.frame.size.width,
                                     serveMesLabel.frame.size.height);
    [self.mainScrollView addSubview:serveMesLabel];
    
    
    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectMake(10*Proportion,
                                                                   CGRectGetMaxY(serveMesLabel.frame) + 20*Proportion,
                                                                   WIDTH - 10*Proportion*2,
                                                                   OrderDefaultVCImageViewHeight*Proportion + 20*Proportion*2)];
    imageBgView.backgroundColor = [UIColor CMLOrderCellBgGrayColor];
    [self.mainScrollView addSubview:imageBgView];
    
    UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                            CGRectGetMaxY(serveMesLabel.frame) + 20*Proportion*2,
                                                                            OrderDefaultVCImageViewHeight*Proportion,
                                                                            OrderDefaultVCImageViewHeight*Proportion)];
    serveImage.backgroundColor = [UIColor CMLPromptGrayColor];
    serveImage.layer.cornerRadius = 2;
    serveImage.contentMode = UIViewContentModeScaleAspectFill;
    serveImage.clipsToBounds = YES;
    [self.mainScrollView addSubview:serveImage];
    [NetWorkTask setImageView:serveImage WithURL:self.obj.retData.projectInfo.coverPic placeholderImage:nil];
    
    UILabel *serveName = [[UILabel alloc] init];
    serveName.font = KSystemFontSize14;
    serveName.textColor = [UIColor CMLUserBlackColor];
    serveName.text = self.obj.retData.projectInfo.title;;
    [serveName sizeToFit];
    serveName.frame = CGRectMake(OrderDefaultVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                 serveImage.frame.origin.y,
                                 WIDTH - CGRectGetMaxX(serveImage.frame) - OrderDefaultVCLeftMargin*Proportion*2,
                                 serveName.frame.size.height);
    serveName.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:serveName];
    
    
    UILabel *serveTime = [[UILabel alloc] init];
    serveTime.font = KSystemFontSize10;
    serveTime.textColor = [UIColor CMLtextInputGrayColor];
    serveTime.text = [NSString stringWithFormat:@"时间：%@",self.obj.retData.projectInfo.actDateZone];
    [serveTime sizeToFit];
    serveTime.frame = CGRectMake(serveName.frame.origin.x,
                                 CGRectGetMaxY(serveName.frame) + 10*Proportion,
                                 serveTime.frame.size.width,
                                 serveTime.frame.size.height);
    [self.mainScrollView addSubview:serveTime];
    
    UILabel *servePrice = [[UILabel alloc] init];
    servePrice.font = KSystemFontSize14;
    servePrice.textColor = [UIColor CMLBrownColor];
    
    if ([self.obj.retData.orderInfo.payAmtE2 intValue] == 0) {
        
        servePrice.text = @"费用：免费";
    }else{
        
        servePrice.text = [NSString stringWithFormat:@"费用：¥%0.2f",[self.obj.retData.orderInfo.payAmtE2 floatValue]/100];
    }
    
    [servePrice sizeToFit];
    servePrice.frame = CGRectMake(serveName.frame.origin.x,
                                  CGRectGetMaxY(serveImage.frame) - servePrice.frame.size.height,
                                  servePrice.frame.size.width,
                                  servePrice.frame.size.height);
    [self.mainScrollView addSubview:servePrice];
    
    if ([self.obj.retData.projectInfo.isHasTimeZone intValue] == 2) {
        
        serveTime.hidden = YES;
    }
    
    
    UIButton *detailOfProjectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              imageBgView.frame.origin.y,
                                                                              WIDTH,
                                                                              imageBgView.frame.size.height)];
    detailOfProjectBtn.backgroundColor = [UIColor clearColor];
    [self.mainScrollView addSubview:detailOfProjectBtn];
    [detailOfProjectBtn addTarget:self action:@selector(enterServeDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *points =[[UILabel alloc] init];
    points.textColor = [UIColor CMLUserBlackColor];
    points.font = KSystemFontSize12;
    points.text = @"票种";
    [points sizeToFit];
    points.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(imageBgView.frame) + 20*Proportion,
                              points.frame.size.width,
                              points.frame.size.height);
    [self.mainScrollView addSubview:points];
    
    UILabel *pointsNum =[[UILabel alloc] init];
    pointsNum.textColor = [UIColor CMLUserBlackColor];
    pointsNum.font = KSystemFontSize12;
    if ([self.obj.retData.orderInfo.payAmtE2 intValue] > 0) {
        
        pointsNum.text = @"收费";
    }else{
        
        pointsNum.text  = @"免费";
    }
    
    [pointsNum sizeToFit];
    pointsNum.frame = CGRectMake(WIDTH - 30*Proportion - pointsNum.frame.size.width,
                                 CGRectGetMaxY(imageBgView.frame) + 20*Proportion,
                                 pointsNum.frame.size.width,
                                 pointsNum.frame.size.height);
    [self.mainScrollView addSubview:pointsNum];
    
    UILabel *finalPay =[[UILabel alloc] init];
    finalPay.textColor = [UIColor CMLUserBlackColor];
    finalPay.font = KSystemFontSize12;
    
    finalPay.text = @"数量";
    [finalPay sizeToFit];
    finalPay.frame = CGRectMake(serveImage.frame.origin.x,
                                CGRectGetMaxY(points.frame) + 20*Proportion,
                                finalPay.frame.size.width,
                                finalPay.frame.size.height);
    [self.mainScrollView addSubview:finalPay];
    
    UILabel *finalPayNum =[[UILabel alloc] init];
    finalPayNum.textColor = [UIColor CMLUserBlackColor];
    finalPayNum.font = KSystemFontSize12;
    finalPayNum.text = [NSString stringWithFormat:@"x %@", self.obj.retData.orderInfo.activity_num];
    [finalPayNum sizeToFit];
    finalPayNum.frame = CGRectMake(WIDTH - 30*Proportion - finalPayNum.frame.size.width,
                                   CGRectGetMaxY(points.frame) + 20*Proportion,
                                   finalPayNum.frame.size.width,
                                   finalPayNum.frame.size.height);
    [self.mainScrollView addSubview:finalPayNum];
    
    UILabel *payTotalAmountLab = [[UILabel alloc] init];
    payTotalAmountLab.text = @"支付金额：";
    payTotalAmountLab.textColor = [UIColor CMLBlackColor];
    payTotalAmountLab.font = KSystemBoldFontSize14;
    [payTotalAmountLab sizeToFit];
    payTotalAmountLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(finalPay.frame) + 20*Proportion,
                                         payTotalAmountLab.frame.size.width,
                                         payTotalAmountLab.frame.size.height);
    [self.mainScrollView addSubview:payTotalAmountLab];
    
    UILabel *payTotalAmountNumLab = [[UILabel alloc] init];
    payTotalAmountNumLab.text = [NSString stringWithFormat:@"价格：¥%0.2f",[self.obj.retData.orderInfo.payAmtE2 floatValue]/100];
    payTotalAmountNumLab.textColor = [UIColor CMLBlackColor];
    payTotalAmountNumLab.font = KSystemBoldFontSize14;
    [payTotalAmountNumLab sizeToFit];
    payTotalAmountNumLab.frame = CGRectMake(WIDTH - payTotalAmountNumLab.frame.size.width - 30*Proportion,
                                            CGRectGetMaxY(finalPay.frame) + 20*Proportion,
                                            payTotalAmountNumLab.frame.size.width,
                                            payTotalAmountNumLab.frame.size.height);
    [self.mainScrollView addSubview:payTotalAmountNumLab];
    
    
    CMLLine *lineFour = [[CMLLine alloc] init];
    lineFour.startingPoint = CGPointMake(OrderDefaultVCLeftMargin*Proportion, CGRectGetMaxY(payTotalAmountNumLab.frame) + 20*Proportion);
    lineFour.lineWidth = 1;
    lineFour.lineLength = WIDTH - OrderDefaultVCLeftMargin*Proportion*2;
    lineFour.LineColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:lineFour];
    
    
    UIButton *sucessBtn = [[UIButton alloc] init];
    sucessBtn.titleLabel.font = KSystemFontSize12;
    [sucessBtn setTitle:@"预订成功" forState:UIControlStateNormal];
    [sucessBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [sucessBtn sizeToFit];
    sucessBtn.frame = CGRectMake(WIDTH - 30*Proportion - (sucessBtn.frame.size.width + 20*Proportion*2),
                                 CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                 sucessBtn.frame.size.width + 20*Proportion*2,
                                 OrderDefaultVCBtnHeight*Proportion);
    sucessBtn.layer.borderColor = [UIColor CMLtextInputGrayColor].CGColor;
    sucessBtn.layer.borderWidth = 1;
    sucessBtn.layer.cornerRadius = 6*Proportion;
    [self.mainScrollView addSubview:sucessBtn];
    
    if ([self.obj.retData.orderInfo.payAmtE2 intValue] == 0) {
      
        UIButton *cancelOrderBtn = [[UIButton alloc] init];
        cancelOrderBtn.titleLabel.font = KSystemFontSize12;
        if ([self.obj.retData.projectInfo.isExpire intValue] == 1) {
            
            [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
        }else if([self.obj.retData.projectInfo.isExpire intValue] == 2){
            
           [cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
        
        [cancelOrderBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        [cancelOrderBtn sizeToFit];
        cancelOrderBtn.frame = CGRectMake(WIDTH - 30*Proportion - (cancelOrderBtn.frame.size.width + 20*Proportion*2),
                                     CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                     cancelOrderBtn.frame.size.width + 20*Proportion*2,
                                     OrderDefaultVCBtnHeight*Proportion);
        cancelOrderBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        cancelOrderBtn.layer.borderWidth = 1;
        cancelOrderBtn.layer.cornerRadius = 6*Proportion;
        [self.mainScrollView addSubview:cancelOrderBtn];
        [cancelOrderBtn addTarget:self action:@selector(showActiveMessage) forControlEvents:UIControlEventTouchUpInside];
        
        sucessBtn.frame = CGRectMake(WIDTH - 30*Proportion - (sucessBtn.frame.size.width + 20*Proportion + cancelOrderBtn.frame.size.width),
                                     CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                     sucessBtn.frame.size.width,
                                     OrderDefaultVCBtnHeight*Proportion);
    }else{
    
        
        
        if (self.obj.retData.projectInfo.packageInfo.chargeInfo.count != 0) {
         
            UIButton *costMessage = [[UIButton alloc] init];
            [costMessage setTitle:@"收费活动说明" forState:UIControlStateNormal];
            [costMessage setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
            costMessage.titleLabel.font = KSystemFontSize12;
            [costMessage setImage:[UIImage imageNamed:CostActivityMessageImg] forState:UIControlStateNormal];
            [costMessage setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
            [costMessage sizeToFit];
            costMessage.contentMode = UIViewContentModeLeft;
            costMessage.frame = CGRectMake(30*Proportion,
                                           CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                           costMessage.frame.size.width + 20*Proportion*2,
                                           OrderDefaultVCBtnHeight*Proportion);
            [self.mainScrollView addSubview:costMessage];
            [costMessage addTarget:self action:@selector(showActivityCostMessage) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self.obj.retData.projectInfo.isExpire intValue] == 2) {
                
                UIButton *cancelOrderBtn = [[UIButton alloc] init];
                cancelOrderBtn.titleLabel.font = KSystemFontSize12;
                [cancelOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [cancelOrderBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
                [cancelOrderBtn sizeToFit];
                cancelOrderBtn.frame = CGRectMake(WIDTH - 30*Proportion - (cancelOrderBtn.frame.size.width + 20*Proportion*2),
                                                  CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                                  cancelOrderBtn.frame.size.width + 20*Proportion*2,
                                                  OrderDefaultVCBtnHeight*Proportion);
                cancelOrderBtn.layer.borderColor = [UIColor CMLBrownColor].CGColor;
                cancelOrderBtn.layer.borderWidth = 1;
                cancelOrderBtn.layer.cornerRadius = 6*Proportion;
                [self.mainScrollView addSubview:cancelOrderBtn];
                [cancelOrderBtn addTarget:self action:@selector(setDeteleMessage) forControlEvents:UIControlEventTouchUpInside];
                
                sucessBtn.frame = CGRectMake(WIDTH - 30*Proportion - (sucessBtn.frame.size.width + 20*Proportion + cancelOrderBtn.frame.size.width),
                                             CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                             sucessBtn.frame.size.width,
                                             OrderDefaultVCBtnHeight*Proportion);
            }
        }
    }
    
    UIButton *invitationBtn = [[UIButton alloc] init];
    invitationBtn.titleLabel.font = KSystemFontSize12;
    [invitationBtn setTitle:@"查看邀请函" forState:UIControlStateNormal];
    [invitationBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [invitationBtn sizeToFit];
    invitationBtn.frame = CGRectMake(CGRectGetMinX(sucessBtn.frame) - 20*Proportion*3 - invitationBtn.frame.size.width,
                                     CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                     invitationBtn.frame.size.width + 20*Proportion*2,
                                     OrderDefaultVCBtnHeight*Proportion);
    invitationBtn.layer.borderColor = [UIColor CMLBlackColor].CGColor;
    invitationBtn.layer.borderWidth = 1;
    invitationBtn.layer.cornerRadius = 6*Proportion;
    [self.mainScrollView addSubview:invitationBtn];
    [invitationBtn addTarget:self action:@selector(setCurrentInvitationView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *upTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(sucessBtn.frame) + 40*Proportion,
                                                                 WIDTH,
                                                                 20*Proportion)];
    upTwoView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:upTwoView];
    
    /**支付信息*/
    UILabel *payMes = [[UILabel alloc] init];
    payMes.text = @"支付信息";
    payMes.textColor = [UIColor CMLtextInputGrayColor];
    payMes.font = KSystemFontSize12;
    [payMes sizeToFit];
    payMes.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(upTwoView.frame) + 30*Proportion,
                              payMes.frame.size.width,
                              payMes.frame.size.height);
    [self.mainScrollView addSubview:payMes];
    
    CMLLine *lineFive = [[CMLLine alloc] init];
    lineFive.startingPoint = CGPointMake(OrderDefaultVCLeftMargin*Proportion, CGRectGetMaxY(payMes.frame) + OrderDefaultVCBottomMargin*Proportion);
    lineFive.lineWidth = 1;
    lineFive.lineLength = WIDTH- OrderDefaultVCLeftMargin*Proportion*2;
    lineFive.LineColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:lineFive];
    
    
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
    
    UILabel *contactNum = [[UILabel alloc] init];
    contactNum.font = KSystemFontSize12;
    contactNum.textColor = [UIColor CMLUserBlackColor];
    contactNum.text = [NSString stringWithFormat:@"客服电话：%@",self.obj.retData.orderInfo.customerPhone];
    [contactNum sizeToFit];
    contactNum.frame = CGRectMake(payMes.frame.origin.x,
                                  CGRectGetMaxY(payTime.frame) +  OrderDefaultVCBottomMargin*Proportion,
                                  contactNum.frame.size.width,
                                  contactNum.frame.size.height);
    [self.mainScrollView addSubview:contactNum];
    
    UIButton *contactBtn = [[UIButton alloc] init];
    contactBtn.titleLabel.font = KSystemFontSize12;
    [contactBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [contactBtn sizeToFit];
    contactBtn.frame = CGRectMake(WIDTH - (contactBtn.frame.size.width + 20*Proportion*2) - 30*Proportion,
                                  CGRectGetMaxY(contactNum.frame) - OrderDefaultVCBtnHeight*Proportion,
                                  contactBtn.frame.size.width + 20*Proportion*2,
                                  OrderDefaultVCBtnHeight*Proportion);
    contactBtn.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    contactBtn.layer.borderWidth = 1;
    contactBtn.layer.cornerRadius = 6*Proportion;
    [self.mainScrollView addSubview:contactBtn];
    [contactBtn addTarget:self action:@selector(contactus) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bottomUpView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMaxY(contactNum.frame) + 30*Proportion,
                                                                    WIDTH,
                                                                    1000)];
    bottomUpView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:bottomUpView];
    
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               HEIGHT)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.alpha = 0;
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.shadowView];
    

    
}

- (void) setTeleView{

    
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
    [NetWorkTask postResquestWithApiName:MyOrderDetail paraDic:paraDic delegate:delegate];
    self.currentApiName = MyOrderDetail;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MyOrderDetail]) {
        [self stopLoading];
        NSLog(@"MyOrderDetail %@", responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.obj = obj;
            self.projectInfo = [BrandAndServeObj getBaseObjFrom:self.obj.retData.projectInfo];
            
            self.QRImageView = [[UIImageView alloc] init];
            [NetWorkTask setImageView:self.QRImageView WithURL:self.obj.retData.orderInfo.activityQrCode placeholderImage:nil];

            [self loadViews];
            if ([self.orderSuccess integerValue] == 1) {
                self.orderSuccess = [NSNumber numberWithInt:0];
                [self setCurrentInvitationView];
            }
            
            self.mainScrollView.hidden = NO;
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self stopLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:CancelAppointment]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        self.shadowView.userInteractionEnabled = YES;
        
        if ([obj.retCode intValue] == 0) {
            
            [self showResultMessage];
            [self performSelector:@selector(clearShadowView) withObject:nil afterDelay:2.0f];

        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self cancelCurrentActive];
        }
        
        [self stopIndicatorLoading];
    }else if ([self.currentApiName isEqualToString:delegateAppointment]){
        
         BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.delegate refreshCurrentVC];
            [[VCManger mainVC] dismissCurrentVC];
        }
    }
    
    [self stopIndicatorLoading];
    [self hideNetErrorTipOfNormalVC];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    self.shadowView.userInteractionEnabled = YES;
    [self showNetErrorTipOfNormalVC];
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    [self.delegate refreshCurrentVC];
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - contactus
- (void) contactus{
    
    [self setTeleView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.alpha = 1;
    }];
}

#pragma mark - enterServeDetailVC
- (void) enterServeDetailVC{
    
    if ([self.isDeleted intValue] == 1) {
        
        if ([self.obj.retData.projectInfo.isUserPublish intValue] == 1) {
          
            CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:self.obj.retData.projectInfo.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
            
            ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:self.obj.retData.projectInfo.currentID];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }

    }else{
        [self showFailTemporaryMes:@"该活动已删除"];
    }
}


- (void) showActiveMessage{
    
    if ([self.obj.retData.projectInfo.isExpire intValue] == 2) {
        
        [self setDeteleMessage];
        
    }else{
        
        [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.shadowView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
        
        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       660*Proportion,
                                                                       0)];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 4*Proportion;
        [self.shadowView addSubview:messageView];
        
        UILabel *labelOne = [[UILabel alloc] init];
        labelOne.text = @"您需要取消本次预约吗？";
        labelOne.font = KSystemFontSize14;
        labelOne.textColor = [UIColor CMLBlackColor];
        [labelOne sizeToFit];
        labelOne.frame = CGRectMake(660*Proportion/2.0 - labelOne.frame.size.width/2.0,
                                    40*Proportion,
                                    labelOne.frame.size.width,
                                    labelOne.frame.size.height);
        [messageView addSubview:labelOne];
        
        UILabel *labelTwo = [[UILabel alloc] init];
        labelTwo.text = @"（每个月最多有三次取消的机会哦！）";
        labelTwo.font = KSystemFontSize10;
        labelTwo.textColor = [UIColor CMLRedColor];
        [labelTwo sizeToFit];
        labelTwo.frame = CGRectMake(660*Proportion/2.0 - labelTwo.frame.size.width/2.0,
                                    CGRectGetMaxY(labelOne.frame) + 20*Proportion,
                                    labelTwo.frame.size.width,
                                    labelTwo.frame.size.height);
        [messageView addSubview:labelTwo];
        
        messageView.frame = CGRectMake(WIDTH/2.0 - 660*Proportion/2.0,
                                       HEIGHT/2.0 -  (40*Proportion*2 + labelOne.frame.size.height + labelTwo.frame.size.height + 20*Proportion)/2.0,
                                       660*Proportion,
                                       40*Proportion*2 + labelOne.frame.size.height + labelTwo.frame.size.height + 20*Proportion);
        
        
        UIButton *abandonBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.origin.x,
                                                                          CGRectGetMaxY(messageView.frame) + 20*Proportion,
                                                                          (660*Proportion - 20*Proportion)/2.0,
                                                                          72*Proportion)];
        abandonBtn.backgroundColor = [UIColor CMLBrownColor];
        abandonBtn.layer.cornerRadius = 4*Proportion;
        [abandonBtn setTitle:@"我再想想" forState:UIControlStateNormal];
        abandonBtn.titleLabel.font = KSystemBoldFontSize14;
        [abandonBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [self.shadowView addSubview:abandonBtn];
        [abandonBtn addTarget:self action:@selector(cancelCurrentActive) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(abandonBtn.frame) + 20*Proportion,
                                                                         CGRectGetMaxY(messageView.frame) + 20*Proportion,
                                                                         (660*Proportion - 20*Proportion)/2.0,
                                                                         72*Proportion)];
        selectBtn.backgroundColor = [UIColor CMLBrownColor];
        selectBtn.layer.cornerRadius = 4*Proportion;
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        selectBtn.titleLabel.font = KSystemBoldFontSize14;
        [selectBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [self.shadowView addSubview:selectBtn];
        [selectBtn addTarget:self action:@selector(confirmActive) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void) setDeteleMessage{

    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        weakSelf.shadowView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   660*Proportion,
                                                                   0)];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.layer.cornerRadius = 4*Proportion;
    [self.shadowView addSubview:messageView];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"您需要删除本次预约吗？";
    labelOne.font = KSystemFontSize14;
    labelOne.textColor = [UIColor CMLBlackColor];
    [labelOne sizeToFit];
    labelOne.frame = CGRectMake(660*Proportion/2.0 - labelOne.frame.size.width/2.0,
                                40*Proportion,
                                labelOne.frame.size.width,
                                labelOne.frame.size.height);
    [messageView addSubview:labelOne];
    
    
    messageView.frame = CGRectMake(WIDTH/2.0 - 660*Proportion/2.0,
                                   HEIGHT/2.0 -  (40*Proportion*2 + labelOne.frame.size.height + 20*Proportion)/2.0,
                                   660*Proportion,
                                   40*Proportion*2 + labelOne.frame.size.height  + 20*Proportion);
    
    
    UIButton *abandonBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.origin.x,
                                                                      CGRectGetMaxY(messageView.frame) + 20*Proportion,
                                                                      (660*Proportion - 20*Proportion)/2.0,
                                                                      72*Proportion)];
    abandonBtn.backgroundColor = [UIColor CMLBrownColor];
    abandonBtn.layer.cornerRadius = 4*Proportion;
    [abandonBtn setTitle:@"我再想想" forState:UIControlStateNormal];
    abandonBtn.titleLabel.font = KSystemBoldFontSize14;
    [abandonBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.shadowView addSubview:abandonBtn];
    [abandonBtn addTarget:self action:@selector(cancelCurrentActive) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(abandonBtn.frame) + 20*Proportion,
                                                                     CGRectGetMaxY(messageView.frame) + 20*Proportion,
                                                                     (660*Proportion - 20*Proportion)/2.0,
                                                                     72*Proportion)];
    selectBtn.backgroundColor = [UIColor CMLBrownColor];
    selectBtn.layer.cornerRadius = 4*Proportion;
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = KSystemBoldFontSize14;
    [selectBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [self.shadowView addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(seteDeleteAppointmentRequest) forControlEvents:UIControlEventTouchUpInside];

}

- (void) showResultMessage{
    
    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.shadowView.alpha = 1;
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,660*Proportion, 0)];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.layer.cornerRadius = 4*Proportion;
    [self.shadowView addSubview:messageView];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.numberOfLines = 0;
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = @"您已取消本次活动预约，期待您的再次参与！";
    labelOne.font = KSystemFontSize14;
    labelOne.textColor = [UIColor CMLBlackColor];
    CGRect tempRect =  [labelOne.text boundingRectWithSize:CGSizeMake(660*Proportion, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                   context:nil];
    labelOne.frame = CGRectMake(660*Proportion/2.0 - tempRect.size.width/2.0,
                                40*Proportion,
                                tempRect.size.width,
                                tempRect.size.height);
    [messageView addSubview:labelOne];
    
    messageView.frame = CGRectMake(WIDTH/2.0 - 660*Proportion/2.0,
                                   HEIGHT/2.0 -  (40*Proportion*2 + labelOne.frame.size.height)/2.0,
                                   660*Proportion,
                                   40*Proportion*2 + labelOne.frame.size.height);
    
}

- (void) cancelCurrentActive{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) confirmActive{
    
    [self setCancelAppointmentRequest];
    self.shadowView.userInteractionEnabled = NO;
    
}

- (void) clearShadowView{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.delegate refreshCurrentVC];
        [[VCManger mainVC] dismissCurrentVC];
        
    }];
    
}

- (void) setCancelAppointmentRequest{
    
    /**预约请求*/
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:self.obj.retData.projectInfo.currentID forKey:@"objId"];
    [paraDic setObject:self.obj.retData.orderInfo.orderId forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"parentType"];
    
    PackDetailInfoObj *freeObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.projectInfo.packageInfo.dataList firstObject]];
    
    [paraDic setObject:freeObj.currentID forKey:@"packageId"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.projectInfo.currentID,
                                                           [NSNumber numberWithInt:1],
                                                           self.obj.retData.orderInfo.orderId,
                                                           reqTime,
                                                           skey,
                                                           [NSNumber numberWithInt:2]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:CancelAppointment paraDic:paraDic delegate:delegate];
    self.currentApiName = CancelAppointment;

    
    [self startIndicatorLoading];
    
}

- (void) seteDeleteAppointmentRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:self.obj.retData.projectInfo.currentID forKey:@"objId"];
    [paraDic setObject:self.obj.retData.orderInfo.orderId forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"parentType"];
    
    PackDetailInfoObj *freeObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.projectInfo.packageInfo.dataList firstObject]];
    
    [paraDic setObject:freeObj.currentID forKey:@"packageId"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.projectInfo.currentID,
                                                           [NSNumber numberWithInt:1],
                                                           self.obj.retData.orderInfo.orderId,
                                                           reqTime,
                                                           skey,
                                                           freeObj.currentID,
                                                           [NSNumber numberWithInt:2]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:delegateAppointment paraDic:paraDic delegate:delegate];
    self.currentApiName = delegateAppointment;
    
    
    [self startIndicatorLoading];
    
    
}

- (void) showActivityCostMessage{

    [self.shadowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.shadowView.alpha = 1;
    
    UIView *messageBgView = [[UIView alloc] init];
    messageBgView.backgroundColor = [UIColor whiteColor];
    messageBgView.layer.cornerRadius = 20*Proportion;
    UILabel *topLab = [[UILabel alloc] init];
    topLab.font = KSystemBoldFontSize16;
    topLab.text = @"收费活动说明";
    topLab.textColor = [UIColor CMLBlackColor];
    [topLab sizeToFit];
    topLab.frame = CGRectMake(660*Proportion/2.0 - topLab.frame.size.width/2.0,
                              60*Proportion,
                              topLab.frame.size.width,
                              topLab.frame.size.height);
    [messageBgView addSubview:topLab];
    
    CGFloat currentHeight = CGRectGetMaxY(topLab.frame) + 40*Proportion;
    
    for (int i = 0 ; i < self.obj.retData.projectInfo.packageInfo.chargeInfo.count; i++) {
        
        UILabel *lab = [[UILabel alloc] init];
        lab.numberOfLines = 0;
        lab.text = self.obj.retData.projectInfo.packageInfo.chargeInfo[i];
        lab.textColor = [UIColor CMLBlackColor];
        lab.font = KSystemFontSize14;
        lab.textAlignment = NSTextAlignmentLeft;
        [lab sizeToFit];
        if (lab.frame.size.width > 540*Proportion) {
            
            CGRect labRect = [lab.text boundingRectWithSize:CGSizeMake(540*Proportion, 1000)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                    context:nil];
            lab.frame = CGRectMake(50*Proportion + 20*Proportion,
                                   currentHeight,
                                   540*Proportion,
                                   labRect.size.height);
        }else{
        
            lab.frame = CGRectMake(50*Proportion + 20*Proportion,
                                   currentHeight,
                                   540*Proportion,
                                   lab.frame.size.height);
        }
        [messageBgView addSubview:lab];
        
        UIView *dian = [[UIView alloc] initWithFrame:CGRectMake(50*Proportion,
                                                                lab.center.y,
                                                                2*Proportion,
                                                                2*Proportion)];
        dian.backgroundColor = [UIColor CMLBlackColor];
        dian.layer.cornerRadius = 2*Proportion/2.0;
        [messageBgView addSubview:dian];
        
        currentHeight += (lab.frame.size.height + 40*Proportion);
        
        if (i == self.obj.retData.projectInfo.packageInfo.chargeInfo.count - 1) {
            
            messageBgView.frame = CGRectMake(WIDTH/2.0 - 660*Proportion/2.0,
                                             HEIGHT/2.0 - (CGRectGetMaxY(lab.frame) + 60*Proportion)/2.0,
                                             660*Proportion,
                                             CGRectGetMaxY(lab.frame) + 60*Proportion);
        }
    }
    [self.shadowView addSubview:messageBgView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.shadowView.alpha = 0;
}

/*邀请函*/
- (void)setCurrentInvitationView {
    
    [self.invitationView removeFromSuperview];
    self.invitationView = [[CMLInvitationView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              WIDTH,
                                                                              HEIGHT)];
    self.invitationView.backgroundColor = [UIColor clearColor];
    self.invitationView.delegate = self;
    self.invitationView.userName = [[DataManager lightData] readUserName];
    self.invitationView.activityTitle = self.projectInfo.title;
    self.invitationView.timeZone = self.projectInfo.actDateZone;
    self.invitationView.address = self.projectInfo.address;
    self.invitationView.bgImageType = self.projectInfo.invitation;
    self.invitationView.QRImageUrl = self.obj.retData.orderInfo.activityQrCode;
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.orderInfo.activityQrCode]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.invitationView.QRCurrentImage.image = image;
    [self.invitationView refershInvitationView];
    [self.contentView addSubview:self.invitationView];
}

#pragma mark - InvitationViewDelegate
- (void)hiddenCurrentInvitationView {
    [self refreshLoadMessageOfVC];
    [self.invitationView removeFromSuperview];
}

- (void)saveCurrentInvitationView:(NSString *)str {
    
    if ([str hasSuffix:@"成功"]) {
        [self showSuccessTemporaryMes:str];
    }else{
        
        [self showFailTemporaryMes:str];
    }
    
    [self refreshLoadMessageOfVC];
    
    [self.invitationView removeFromSuperview];
    
}

- (void)shareCurrentInvitationView:(NSString *)str {
    
    if ([str hasSuffix:@"成功"]) {
        [self showSuccessTemporaryMes:str];
    }else{
        [self showFailTemporaryMes:str];
    }
    [self refreshLoadMessageOfVC];
    [self.invitationView removeFromSuperview];
    
}

- (void)refreshLoadMessageOfVC {
    [self loadData];
}

@end
