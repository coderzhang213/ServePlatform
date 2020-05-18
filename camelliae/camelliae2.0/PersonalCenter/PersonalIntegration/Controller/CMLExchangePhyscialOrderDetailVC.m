//
//  CMLExchangePhyscialVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLExchangePhyscialOrderDetailVC.h"
#import "VCManger.h"
#import "CMLServeObj.h"
#import "CMLOrderObj.h"
#import "LoginUserObj.h"
#import "CMLCommodityDetailMessageVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "GoodsModuleDetailMesObj.h"
#import "CMLGiftVC.h"

#define OrderDefaultVCLeftMargin            20
#define OrderDefaultVCBottomMargin          20
#define OrderDefaultVCImageViewHeight       160
#define OrderDefaultVCBtnHeight             44
#define AlterViewHeight                     300
#define AlterViewWidth                      620
#define CancelBtnLeftMargin                 60
#define CancelBtnHeight                     52
#define CancelBtnWidth                      160
@interface CMLExchangePhyscialOrderDetailVC ()<NavigationBarProtocol,NetWorkProtocol>


@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLExchangePhyscialOrderDetailVC

- (instancetype)initWithOrderId:(NSString *) orderId{
    
    
    self = [super init];
    if (self) {
        
        self.orderId = orderId;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"兑换详情";
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
    
    
    /**服务信息*/
    UILabel *serveMesLabel = [[UILabel alloc] init];
    serveMesLabel.text = @"商品信息";
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
    [NetWorkTask setImageView:serveImage WithURL:self.obj.retData.coverPicThumb placeholderImage:nil];
    
    UILabel *serveName = [[UILabel alloc] init];
    serveName.font = KSystemFontSize14;
    serveName.textColor = [UIColor CMLUserBlackColor];
    serveName.text = self.obj.retData.title;;
    [serveName sizeToFit];
    
    if (serveName.frame.size.width > WIDTH - CGRectGetMaxX(serveImage.frame) - OrderDefaultVCLeftMargin*Proportion - 10*Proportion ) {
        
        serveName.numberOfLines = 2;
        serveName.frame = CGRectMake(OrderDefaultVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                     serveImage.frame.origin.y,
                                     WIDTH - CGRectGetMaxX(serveImage.frame) - OrderDefaultVCLeftMargin*Proportion*2,
                                     serveName.frame.size.height*2);
    }else{
        
        serveName.frame = CGRectMake(OrderDefaultVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                     serveImage.frame.origin.y,
                                     WIDTH - CGRectGetMaxX(serveImage.frame) - OrderDefaultVCLeftMargin*Proportion*2,
                                     serveName.frame.size.height);
    }
    
    serveName.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:serveName];
    
    UIImageView  *pointImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationIconImg]];
    [pointImg sizeToFit];
    pointImg.frame = CGRectMake(serveName.frame.origin.x,
                                CGRectGetMaxY(serveImage.frame) - pointImg.frame.size.height,
                                pointImg.frame.size.width,
                                pointImg.frame.size.height);
    [self.mainScrollView addSubview:pointImg];
    
    UILabel *servePrice = [[UILabel alloc] init];
    servePrice.font = KSystemFontSize16;
    servePrice.textColor = [UIColor CMLBrownColor];
    servePrice.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
    [servePrice sizeToFit];
    servePrice.frame = CGRectMake(CGRectGetMaxX(pointImg.frame) + 8*Proportion,
                                  CGRectGetMaxY(serveImage.frame) - servePrice.frame.size.height,
                                  servePrice.frame.size.width,
                                  servePrice.frame.size.height);
    [self.mainScrollView addSubview:servePrice];
    
    
    UIButton *detailOfProjectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              imageBgView.frame.origin.y,
                                                                              WIDTH,
                                                                              imageBgView.frame.size.height)];
    detailOfProjectBtn.backgroundColor = [UIColor clearColor];
    [self.mainScrollView addSubview:detailOfProjectBtn];
    [detailOfProjectBtn addTarget:self action:@selector(enterServeDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *finalPay =[[UILabel alloc] init];
    finalPay.textColor = [UIColor CMLUserBlackColor];
    finalPay.font = KSystemFontSize12;
    
    finalPay.text = @"数量";
    [finalPay sizeToFit];
    finalPay.frame = CGRectMake(serveImage.frame.origin.x,
                                CGRectGetMaxY(imageBgView.frame) + 20*Proportion + 27*Proportion,
                                finalPay.frame.size.width,
                                finalPay.frame.size.height);
    [self.mainScrollView addSubview:finalPay];
    
    UILabel *finalPayNum =[[UILabel alloc] init];
    finalPayNum.textColor = [UIColor CMLUserBlackColor];
    finalPayNum.font = KSystemFontSize12;
    finalPayNum.text = @"x 1";
    [finalPayNum sizeToFit];
    finalPayNum.frame = CGRectMake(WIDTH - 30*Proportion - finalPayNum.frame.size.width,
                                   CGRectGetMaxY(imageBgView.frame) + 20*Proportion + 27*Proportion,
                                   finalPayNum.frame.size.width,
                                   finalPayNum.frame.size.height);
    [self.mainScrollView addSubview:finalPayNum];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.LineColor = [UIColor CMLNewGrayColor];
    spaceLine.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(finalPay.frame) + 27*Proportion);
    spaceLine.lineLength = WIDTH - 30*Proportion*2;
    [self.mainScrollView addSubview:spaceLine];
    
    UILabel *payTotalAmountLab = [[UILabel alloc] init];
    payTotalAmountLab.text = @"兑换积分：";
    payTotalAmountLab.textColor = [UIColor CMLBlackColor];
    payTotalAmountLab.font = KSystemFontSize16;
    [payTotalAmountLab sizeToFit];
    payTotalAmountLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(finalPay.frame) + 51*Proportion,
                                         payTotalAmountLab.frame.size.width,
                                         payTotalAmountLab.frame.size.height);
    [self.mainScrollView addSubview:payTotalAmountLab];
    
    
    UILabel *payTotalAmountNumLab = [[UILabel alloc] init];
    payTotalAmountNumLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
    payTotalAmountNumLab.textColor = [UIColor CMLBlackColor];
    payTotalAmountNumLab.font = KSystemBoldFontSize14;
    [payTotalAmountNumLab sizeToFit];
    payTotalAmountNumLab.frame = CGRectMake(WIDTH - payTotalAmountNumLab.frame.size.width - 30*Proportion,
                                            CGRectGetMaxY(finalPay.frame) + 51*Proportion,
                                            payTotalAmountNumLab.frame.size.width,
                                            payTotalAmountNumLab.frame.size.height);
    [self.mainScrollView addSubview:payTotalAmountNumLab];
    
    UIImageView  *point2Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationIconImg]];
    [point2Img sizeToFit];
    point2Img.frame = CGRectMake(payTotalAmountNumLab.frame.origin.x - 8*Proportion - point2Img.frame.size.width,
                                 payTotalAmountNumLab.center.y - point2Img.frame.size.height/2.0,
                                 point2Img.frame.size.width,
                                 point2Img.frame.size.height);
    [self.mainScrollView addSubview:point2Img];
    
    
    UIView *upTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(payTotalAmountNumLab.frame) + 50*Proportion,
                                                                 WIDTH,
                                                                 20*Proportion)];
    upTwoView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:upTwoView];
    
    
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
                                              CGRectGetMaxY(upTwoView.frame),
                                              WIDTH,
                                              CGRectGetMaxY(newView.frame));
        
        
        
    }else{
        
        buyerMessageBgView.frame = CGRectMake(0,
                                              CGRectGetMaxY(upTwoView.frame),
                                              WIDTH,
                                              0);
    }
    
    
    
    
    /**支付信息*/
    UILabel *payMes = [[UILabel alloc] init];
    payMes.text = @"支付信息";
    payMes.textColor = [UIColor CMLtextInputGrayColor];
    payMes.font = KSystemFontSize12;
    [payMes sizeToFit];
    payMes.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(buyerMessageBgView.frame) + 30*Proportion,
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
    
    UILabel *payTime = [[UILabel alloc] init];
    payTime.font = KSystemFontSize12;
    payTime.textColor = [UIColor CMLUserBlackColor];
    payTime.text = [NSString stringWithFormat:@"支付时间：%@",self.obj.retData.orderInfo.payEndTime];
    [payTime sizeToFit];
    payTime.frame = CGRectMake(payMes.frame.origin.x,
                               CGRectGetMaxY(orderNum.frame) +  OrderDefaultVCBottomMargin*Proportion,
                               payTime.frame.size.width,
                               payTime.frame.size.height);
    [self.mainScrollView addSubview:payTime];
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(payTime.frame) + OrderDefaultVCBottomMargin*Proportion,
                                                                 WIDTH,
                                                                 20*Proportion)];
    spaceView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:spaceView];
    
    UILabel *contactNum = [[UILabel alloc] init];
    contactNum.font = KSystemFontSize12;
    contactNum.textColor = [UIColor CMLUserBlackColor];
    contactNum.text = [NSString stringWithFormat:@"客服电话：%@",self.obj.retData.officialMobile];
    [contactNum sizeToFit];
    contactNum.frame = CGRectMake(payMes.frame.origin.x,
                                  CGRectGetMaxY(spaceView.frame) + OrderDefaultVCBottomMargin*Proportion,
                                  contactNum.frame.size.width,
                                  contactNum.frame.size.height);
    [self.mainScrollView addSubview:contactNum];
    
    [self.mainScrollView setContentSize:CGSizeMake(WIDTH, CGRectGetMaxY(contactNum.frame) + 20*Proportion)];
    
    UIButton *contactBtn = [[UIButton alloc] init];
    contactBtn.titleLabel.font = KSystemFontSize12;
    [contactBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [contactBtn sizeToFit];
    contactBtn.frame = CGRectMake(WIDTH - (contactBtn.frame.size.width + 20*Proportion*2) - 30*Proportion,
                                  contactNum.center.y - OrderDefaultVCBtnHeight*Proportion/2.0,
                                  contactBtn.frame.size.width + 20*Proportion*2,
                                  OrderDefaultVCBtnHeight*Proportion);
    contactBtn.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    contactBtn.layer.borderWidth = 1;
    contactBtn.layer.cornerRadius = 6*Proportion;
    [self.mainScrollView addSubview:contactBtn];
    [contactBtn addTarget:self action:@selector(contactus) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bottomUpView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMaxY(contactNum.frame) + 20*Proportion,
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
    phoneNum.text = [NSString stringWithFormat:@"%@",self.obj.retData.officialMobile];
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
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.obj.retData.officialMobile]]];

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
    [NetWorkTask postResquestWithApiName:ExchangeGiftOrderDetail paraDic:paraDic delegate:delegate];
    self.currentApiName = ExchangeGiftOrderDetail;
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ExchangeGiftOrderDetail]) {
        [self stopLoading];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
         
            self.obj = obj;
            
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
    
    CMLGiftVC *vc = [[CMLGiftVC alloc] initWithObjId:self.obj.retData.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}


@end
