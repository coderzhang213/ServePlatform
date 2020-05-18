//
//  PhysicalGiftExchangeVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "PhysicalGiftExchangeVC.h"
#import "VCManger.h"
#import "CMLServeObj.h"
#import "CMLOrderObj.h"
#import "LoginUserObj.h"
#import "DataManager.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLUserAddressListVC.h"
#import "CMLAlterAddressMesaageVC.h"
#import "CMLRSAModule.h"
#import "Order.h"
#import "DataSigner.h"
#import "CMLGiftVC.h"

#define CommodityVCLeftMargin            20
#define CommodityVCBottomMargin          20
#define CommodityVCImageViewHeight       160
#define CommodityVCBtnHeight             44


@interface PhysicalGiftExchangeVC () <NavigationBarProtocol,NetWorkProtocol,CMLUserAddressLisDelgate,AlterAddressMessageDeleagte,UITextViewDelegate>


@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIView *userMessageView;

@property (nonatomic,copy) NSString *deliveryUserName;

@property (nonatomic,copy) NSString *deliveryUserTele;

@property (nonatomic,copy) NSString *deliveryUserAddress;


@property (nonatomic,copy) NSString *buyerMessage;

@property (nonatomic,strong) UIView *buyerMessageBgView;

@property (nonatomic,copy) NSString *goodsOrderID;

@property (nonatomic,strong) NSNumber *currentAddressID;

@property (nonatomic,strong) UITextView *buyerInputField;

@property (nonatomic,strong) UIView *shadowView;


@end

@implementation PhysicalGiftExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"确认兑换";
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    /*************************************************/
    
    self.buyerMessage = @"";
    
    [self loadMessageOfVC];
    
    /**阴影*/
    self.shadowView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:0.5];
    self.shadowView.hidden = YES;
    [self.contentView addSubview:self.shadowView];
    [self.contentView bringSubviewToFront:self.shadowView];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
        
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    };
}

- (void) loadMessageOfVC{
    
    [self loadData];
    
    if (self.isVirtual) {
        
        
        
        UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                                30*Proportion + CGRectGetMaxY(self.navBar.frame),
                                                                                CommodityVCImageViewHeight*Proportion,
                                                                                CommodityVCImageViewHeight*Proportion)];
        serveImage.backgroundColor = [UIColor CMLPromptGrayColor];
        serveImage.layer.cornerRadius = 2;
        serveImage.contentMode = UIViewContentModeScaleAspectFill;
        serveImage.clipsToBounds = YES;
        [self.contentView addSubview:serveImage];
        [NetWorkTask setImageView:serveImage WithURL:self.obj.retData.objCoverPic placeholderImage:nil];
        
        
        UILabel *serveName = [[UILabel alloc] init];
        serveName.font = KSystemFontSize14;
        serveName.textColor = [UIColor CMLUserBlackColor];
        
        serveName.text = self.obj.retData.title;
        
        [serveName sizeToFit];
        
        if (serveName.frame.size.width > WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion - 30*Proportion ) {
            serveName.numberOfLines = 2;
            serveName.frame = CGRectMake(CommodityVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                         serveImage.frame.origin.y,
                                         WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion - 30*Proportion,
                                         serveName.frame.size.height*2);
        }else{
            
            serveName.frame = CGRectMake(CommodityVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                         serveImage.frame.origin.y,
                                         WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion*2,
                                         serveName.frame.size.height);
        }
        serveName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:serveName];
        
        UIImageView  *pointImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationIconImg]];
        [pointImg sizeToFit];
        pointImg.frame = CGRectMake(serveName.frame.origin.x,
                                    CGRectGetMaxY(serveImage.frame) - pointImg.frame.size.height,
                                    pointImg.frame.size.width,
                                    pointImg.frame.size.height);
        [self.contentView addSubview:pointImg];
        
        UILabel *servePrice = [[UILabel alloc] init];
        servePrice.font = KSystemFontSize16;
        servePrice.textColor = [UIColor CMLBrownColor];
        servePrice.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
        [servePrice sizeToFit];
        servePrice.frame = CGRectMake(CGRectGetMaxX(pointImg.frame) + 8*Proportion,
                                      CGRectGetMaxY(serveImage.frame) - servePrice.frame.size.height,
                                      servePrice.frame.size.width,
                                      servePrice.frame.size.height);
        [self.contentView addSubview:servePrice];
        
        
        UIButton *detailOfProjectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                  serveImage.frame.origin.y,
                                                                                  WIDTH,
                                                                                  serveImage.frame.size.height)];
        detailOfProjectBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:detailOfProjectBtn];
        [detailOfProjectBtn addTarget:self action:@selector(enterServeDetailVC) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *finalPay =[[UILabel alloc] init];
        finalPay.textColor = [UIColor CMLUserBlackColor];
        finalPay.font = KSystemFontSize12;
        
        finalPay.text = @"数量";
        [finalPay sizeToFit];
        finalPay.frame = CGRectMake(serveImage.frame.origin.x,
                                    CGRectGetMaxY(serveImage.frame) + 47*Proportion,
                                    finalPay.frame.size.width,
                                    finalPay.frame.size.height);
        [self.contentView addSubview:finalPay];
        
        UILabel *finalPayNum =[[UILabel alloc] init];
        finalPayNum.textColor = [UIColor CMLUserBlackColor];
        finalPayNum.font = KSystemFontSize12;
        finalPayNum.text = @"x 1";
        [finalPayNum sizeToFit];
        finalPayNum.frame = CGRectMake(WIDTH - 30*Proportion - finalPayNum.frame.size.width,
                                       CGRectGetMaxY(serveImage.frame) + 47*Proportion,
                                       finalPayNum.frame.size.width,
                                       finalPayNum.frame.size.height);
        [self.contentView addSubview:finalPayNum];
        
        
        CMLLine *spaceLine = [[CMLLine alloc] init];
        spaceLine.lineWidth = 1*Proportion;
        spaceLine.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(finalPay.frame) + 27*Proportion);
        spaceLine.lineLength = WIDTH - 30*Proportion*2;
        [self.contentView addSubview:spaceLine];
        
        UILabel *payTotalAmountLab = [[UILabel alloc] init];
        payTotalAmountLab.text = @"兑换积分：";
        payTotalAmountLab.textColor = [UIColor CMLBlackColor];
        payTotalAmountLab.font = KSystemFontSize16;
        [payTotalAmountLab sizeToFit];
        payTotalAmountLab.frame = CGRectMake(30*Proportion,
                                             CGRectGetMaxY(finalPay.frame) + 51*Proportion,
                                             payTotalAmountLab.frame.size.width,
                                             payTotalAmountLab.frame.size.height);
        [self.contentView addSubview:payTotalAmountLab];
        
        
        UILabel *payTotalAmountNumLab = [[UILabel alloc] init];
        payTotalAmountNumLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
        payTotalAmountNumLab.textColor = [UIColor CMLBlackColor];
        payTotalAmountNumLab.font = KSystemBoldFontSize14;
        [payTotalAmountNumLab sizeToFit];
        payTotalAmountNumLab.frame = CGRectMake(WIDTH - payTotalAmountNumLab.frame.size.width - 30*Proportion,
                                                CGRectGetMaxY(finalPay.frame) + 51*Proportion,
                                                payTotalAmountNumLab.frame.size.width,
                                                payTotalAmountNumLab.frame.size.height);
        [self.contentView addSubview:payTotalAmountNumLab];
        
        UIImageView  *point2Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationIconImg]];
        [point2Img sizeToFit];
        point2Img.frame = CGRectMake(payTotalAmountNumLab.frame.origin.x - 8*Proportion - point2Img.frame.size.width,
                                     payTotalAmountNumLab.center.y - point2Img.frame.size.height/2.0,
                                     point2Img.frame.size.width,
                                     point2Img.frame.size.height);
        [self.contentView addSubview:point2Img];
        
        
        UIView *upTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(payTotalAmountNumLab.frame) + 24*Proportion,
                                                                     WIDTH,
                                                                     HEIGHT - (CGRectGetMaxY(payTotalAmountNumLab.frame) + 24*Proportion))];
        upTwoView.backgroundColor = [UIColor CMLUserGrayColor];
        [self.contentView addSubview:upTwoView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      HEIGHT - 90*Proportion,
                                                                      WIDTH,
                                                                      90*Proportion)];
        bottomView.backgroundColor = [UIColor CMLWhiteColor];
        [self.contentView addSubview:bottomView];
        
        UILabel *pricePromLab = [[UILabel alloc] init];
        pricePromLab.textColor = [UIColor CMLBrownColor];
        pricePromLab.font = KSystemFontSize15;
        pricePromLab.text = [NSString stringWithFormat:@"积分：%@",self.obj.retData.point];
        pricePromLab.textAlignment = NSTextAlignmentCenter;
        [pricePromLab sizeToFit];
        pricePromLab.frame = CGRectMake(0,
                                        0,
                                        300*Proportion,
                                        90*Proportion);
        [bottomView addSubview:pricePromLab];
        
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(300*Proportion,
                                                                      0,
                                                                      WIDTH - 300*Proportion,
                                                                      90*Proportion)];
        buyBtn.backgroundColor = [UIColor CMLGreeenColor];
        buyBtn.titleLabel.font = KSystemFontSize16;
        [buyBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(enterBuyProcess) forControlEvents:UIControlEventTouchUpInside];
        
        CMLLine *upLine = [[CMLLine alloc] init];
        upLine.lineWidth = 1*Proportion;
        upLine.lineLength = WIDTH;
        upLine.LineColor = [UIColor CMLPromptGrayColor];
        upLine.lineWidth = 1*Proportion;
        upLine.startingPoint = CGPointMake(0, 1*Proportion);
        [bottomView addSubview:upLine];

        
        
    }else{
    
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                             WIDTH,
                                                                             HEIGHT - self.navBar.frame.size.height - 20*Proportion)];
        self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:self.mainScrollView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      HEIGHT - 90*Proportion - SafeAreaBottomHeight,
                                                                      WIDTH,
                                                                      90*Proportion)];
        bottomView.backgroundColor = [UIColor CMLWhiteColor];
        [self.contentView addSubview:bottomView];
        
        UILabel *pricePromLab = [[UILabel alloc] init];
        pricePromLab.textColor = [UIColor CMLBrownColor];
        pricePromLab.font = KSystemFontSize15;
        pricePromLab.text = [NSString stringWithFormat:@"积分：%@",self.obj.retData.point];
        pricePromLab.textAlignment = NSTextAlignmentCenter;
        [pricePromLab sizeToFit];
        pricePromLab.frame = CGRectMake(0,
                                        0,
                                        300*Proportion,
                                        90*Proportion);
        [bottomView addSubview:pricePromLab];
        
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(300*Proportion,
                                                                      0,
                                                                      WIDTH - 300*Proportion,
                                                                      90*Proportion)];
        buyBtn.backgroundColor = [UIColor CMLGreeenColor];
        buyBtn.titleLabel.font = KSystemFontSize16;
        [buyBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [bottomView addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(enterBuyProcess) forControlEvents:UIControlEventTouchUpInside];
        
        CMLLine *upLine = [[CMLLine alloc] init];
        upLine.lineWidth = 1*Proportion;
        upLine.lineLength = WIDTH;
        upLine.LineColor = [UIColor CMLPromptGrayColor];
        upLine.lineWidth = 1*Proportion;
        upLine.startingPoint = CGPointMake(0, 1*Proportion);
        [bottomView addSubview:upLine];
        
        [self loadViews];
    
    }
    
    
}

- (void) loadData{
    
    if ([[DataManager lightData] readDeliveryUser]) {
        self.deliveryUserName = [[DataManager lightData] readDeliveryUser];
    }
    
    if ([[DataManager lightData] readDeliveryPhone]) {
        self.deliveryUserTele = [[DataManager lightData] readDeliveryPhone];
    }
    
    if ([[DataManager lightData] readDeliveryAddress]) {
        self.deliveryUserAddress = [[DataManager lightData] readDeliveryAddress];
    }
    
    if ([[DataManager lightData]readDeliveryAddressID]) {
        
        self.currentAddressID = [[DataManager lightData] readDeliveryAddressID];
    }
    
}



- (void) loadViews{
    
    
    
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
    
    UIView *spaceView1 = [[UIView alloc] init];
    
    if (self.deliveryUserName.length > 0) {
        
        UILabel *serveUserNameLab = [[UILabel alloc] init];
        serveUserNameLab.font = KSystemFontSize14;
        serveUserNameLab.textColor = [UIColor CMLBlackColor];
        serveUserNameLab.text = [NSString stringWithFormat:@"姓名：%@",self.deliveryUserName];
        [serveUserNameLab sizeToFit];
        serveUserNameLab.frame = CGRectMake(30*Proportion,
                                            CGRectGetMaxY(serveUserMesLab.frame) + 20*Proportion*2,
                                            serveUserNameLab.frame.size.width,
                                            serveUserNameLab.frame.size.height);
        [self.mainScrollView addSubview:serveUserNameLab];
        
        UILabel *serveUserTeleLab = [[UILabel alloc] init];
        serveUserTeleLab.font = KSystemFontSize14;
        serveUserTeleLab.textColor = [UIColor CMLBlackColor];
        
        serveUserTeleLab.text = [NSString stringWithFormat:@"电话：%@",self.deliveryUserTele];
        [serveUserTeleLab sizeToFit];
        serveUserTeleLab.frame = CGRectMake(30*Proportion,
                                            CGRectGetMaxY(serveUserNameLab.frame) + 20*Proportion,
                                            serveUserTeleLab.frame.size.width,
                                            serveUserTeleLab.frame.size.height);
        [self.mainScrollView addSubview:serveUserTeleLab];
        
        UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
        [enterImage sizeToFit];
        enterImage.frame = CGRectMake(WIDTH - 30*Proportion - enterImage.frame.size.width,
                                      serveUserTeleLab.center.y - enterImage.frame.size.height/2.0,
                                      enterImage.frame.size.width,
                                      enterImage.frame.size.height);
        [self.mainScrollView addSubview:enterImage];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - enterImage.frame.size.width,
                                                                        serveUserTeleLab.center.y - enterImage.frame.size.height/2.0 - 20*Proportion - serveUserTeleLab.frame.size.height,
                                                                        30*Proportion + enterImage.frame.size.width,
                                                                        enterImage.frame.size.height + 20*Proportion*2 + serveUserTeleLab.frame.size.height*2)];
        enterBtn.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterAddressSelectList) forControlEvents:UIControlEventTouchUpInside];
        
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
        serveUserAddressLab.text = self.deliveryUserAddress;
        serveUserAddressLab.textAlignment = NSTextAlignmentLeft;
        [serveUserAddressLab sizeToFit];
        if (serveUserAddressLab.frame.size.width > WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion - enterImage.frame.size.width) {
            serveUserAddressLab.numberOfLines = 0;
            CGRect currentRect =  [serveUserAddressLab.text boundingRectWithSize:CGSizeMake(WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion, HEIGHT)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                                         context:nil];
            serveUserAddressLab.frame = CGRectMake(CGRectGetMaxX(serveUserAddressPromLab.frame),
                                                   CGRectGetMaxY(serveUserTeleLab.frame) + 20*Proportion,
                                                   WIDTH - CGRectGetMaxX(serveUserAddressPromLab.frame) - 30*Proportion - enterImage.frame.size.width,
                                                   currentRect.size.height);
        }else{
            serveUserAddressLab.numberOfLines = 1;
            serveUserAddressLab.frame = CGRectMake(CGRectGetMaxX(serveUserAddressPromLab.frame),
                                                   CGRectGetMaxY(serveUserTeleLab.frame) + 20*Proportion,
                                                   serveUserAddressLab.frame.size.width,
                                                   serveUserAddressLab.frame.size.height);
            
            
        }
        
        [self.mainScrollView addSubview:serveUserAddressLab];
        
        spaceView1.frame = CGRectMake(0,
                                      CGRectGetMaxY(serveUserAddressLab.frame) + 40*Proportion,
                                      WIDTH,
                                      20*Proportion);
        
    }else{
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(serveUserMesLab.frame) + 20*Proportion*2,
                                                                  WIDTH,
                                                                  100*Proportion)];
        bgView.backgroundColor = [UIColor CMLWhiteColor];
        [self.mainScrollView addSubview:bgView];
        
        UILabel *promLab = [[UILabel alloc] init];
        promLab.text = @"请添加收货信息";
        promLab.font = KSystemFontSize12;
        promLab.textColor = [UIColor CMLLineGrayColor];
        [promLab sizeToFit];
        promLab.frame = CGRectMake(30*Proportion, 100*Proportion/2.0 - promLab.frame.size.height/2.0, promLab.frame.size.width, promLab.frame.size.height);
        [bgView addSubview:promLab];
        
        UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
        [enterImage sizeToFit];
        enterImage.frame = CGRectMake(WIDTH - 30*Proportion - enterImage.frame.size.width,
                                      100*Proportion/2.0 - enterImage.frame.size.height/2.0,
                                      enterImage.frame.size.width,
                                      enterImage.frame.size.height);
        [bgView addSubview:enterImage];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        WIDTH,
                                                                        100*Proportion)];
        enterBtn.backgroundColor = [UIColor clearColor];
        [bgView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterAddressSelectList) forControlEvents:UIControlEventTouchUpInside];
        
        
        spaceView1.frame = CGRectMake(0,
                                      CGRectGetMaxY(bgView.frame),
                                      WIDTH,
                                      20*Proportion);
    }
    
    
    
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
                                                                   CommodityVCImageViewHeight*Proportion + 20*Proportion*2)];
    imageBgView.backgroundColor = [UIColor CMLOrderCellBgGrayColor];
    [self.mainScrollView addSubview:imageBgView];
    
    
    
    UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                            CGRectGetMaxY(serveMesLabel.frame) + 20*Proportion*2,
                                                                            CommodityVCImageViewHeight*Proportion,
                                                                            CommodityVCImageViewHeight*Proportion)];
    serveImage.backgroundColor = [UIColor CMLPromptGrayColor];
    serveImage.layer.cornerRadius = 2;
    serveImage.contentMode = UIViewContentModeScaleAspectFill;
    serveImage.clipsToBounds = YES;
    [self.mainScrollView addSubview:serveImage];
    [NetWorkTask setImageView:serveImage WithURL:self.obj.retData.objCoverPic placeholderImage:nil];
    
    
    UILabel *serveName = [[UILabel alloc] init];
    serveName.font = KSystemFontSize14;
    serveName.textColor = [UIColor CMLUserBlackColor];
    
    serveName.text = self.obj.retData.title;
    
    [serveName sizeToFit];
    
    if (serveName.frame.size.width > WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion - 30*Proportion ) {
        serveName.numberOfLines = 2;
        serveName.frame = CGRectMake(CommodityVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                     serveImage.frame.origin.y,
                                     WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion - 30*Proportion,
                                     serveName.frame.size.height*2);
    }else{
        
        serveName.frame = CGRectMake(CommodityVCLeftMargin*Proportion + CGRectGetMaxX(serveImage.frame),
                                     serveImage.frame.origin.y,
                                     WIDTH - CGRectGetMaxX(serveImage.frame) - CommodityVCLeftMargin*Proportion*2,
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
    
        
    self.buyerMessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(upTwoView.frame),
                                                                       WIDTH,
                                                                       76*Proportion)];
    self.buyerMessageBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:self.buyerMessageBgView];
    
    UILabel *buyerMessagePromLab = [[UILabel alloc] init];
    buyerMessagePromLab.text = @"买家留言";
    buyerMessagePromLab.font = KSystemFontSize13;
    [buyerMessagePromLab sizeToFit];
    buyerMessagePromLab.frame = CGRectMake(30*Proportion,
                                           30*Proportion,
                                           buyerMessagePromLab.frame.size.width,
                                           buyerMessagePromLab.frame.size.height);
    [self.buyerMessageBgView addSubview:buyerMessagePromLab];
    
    CMLLine *spaceLineTwo = [[CMLLine alloc] init];
    spaceLineTwo.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(buyerMessagePromLab.frame) + 30*Proportion);
    spaceLineTwo.lineWidth = 1*Proportion;
    spaceLineTwo.lineLength = WIDTH - 30*Proportion*2;
    spaceLineTwo.LineColor = [UIColor CMLNewGrayColor];
    [self.buyerMessageBgView addSubview:spaceLineTwo];
    
    UILabel *buyerMessagePromLab2 = [[UILabel alloc] init];
    
    if (self.buyerMessage.length == 0) {
        buyerMessagePromLab2.text = @"请在这里填写您的商品备注（限30字以内）";
    }else{
    
        buyerMessagePromLab2.text = self.buyerMessage;
    }
    
    buyerMessagePromLab2.font = KSystemFontSize13;
    [buyerMessagePromLab2 sizeToFit];
    buyerMessagePromLab2.textAlignment = NSTextAlignmentLeft;
    buyerMessagePromLab2.textColor = [UIColor CMLPromptGrayColor];
    if (buyerMessagePromLab2.frame.size.width > WIDTH - 30*Proportion*2) {
     
        buyerMessagePromLab2.frame = CGRectMake(30*Proportion,
                                                CGRectGetMaxY(buyerMessagePromLab.frame) + 60*Proportion,
                                                buyerMessagePromLab2.frame.size.width,
                                                buyerMessagePromLab2.frame.size.height);
    }else{
    
        CGRect currentRect= [buyerMessagePromLab2.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, 1000)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                                    context:nil];
        
        buyerMessagePromLab2.frame = CGRectMake(30*Proportion,
                                                CGRectGetMaxY(buyerMessagePromLab.frame) + 60*Proportion,
                                                WIDTH - 30*Proportion*2,
                                                currentRect.size.height);
    
    }
    
    
    [self.buyerMessageBgView addSubview:buyerMessagePromLab2];
    
    self.buyerMessageBgView.frame = CGRectMake(0,
                                               CGRectGetMaxY(upTwoView.frame),
                                               WIDTH,
                                               CGRectGetMaxY(buyerMessagePromLab2.frame) + 30*Proportion);
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.buyerMessageBgView.bounds];
    button.backgroundColor = [UIColor clearColor];
    [self.buyerMessageBgView addSubview:button];
    [button addTarget:self action:@selector(editBuyerMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *newAddView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.buyerMessageBgView.frame),
                                                                  WIDTH,
                                                                  HEIGHT - CGRectGetMaxY(self.buyerMessageBgView.frame))];
    newAddView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:newAddView];
    
    
    
    self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(newAddView.frame));
    
    
    
    
}


#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
}


#pragma mark - enterServeDetailVC
- (void) enterServeDetailVC{
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) enterAddressSelectList{
    
    if (self.deliveryUserAddress.length > 0) {
        
        CMLUserAddressListVC *vc = [[CMLUserAddressListVC alloc] init];
        vc.currentTitle = @"选择收货信息";
        vc.delegate = self;
        vc.currentAddressID = self.currentAddressID;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else{
        
        CMLAlterAddressMesaageVC *vc = [[CMLAlterAddressMesaageVC alloc] init];
        vc.delegate = self;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
}


#pragma mark - CMLUserAddressLisDelgate

- (void) refreshUserName:(NSString *) name userTele:(NSString *) tele userAddress:(NSString *) address addressID:(NSNumber *)addressID{
    
    self.deliveryUserName = name;
    self.deliveryUserTele = tele;
    self.deliveryUserAddress = address;
    self.currentAddressID = addressID;
    
    [self loadViews];
}

- (void) refreshOrderMessageWithUserName:(NSString *) userName userTele:(NSString *) userTele userAddress:(NSString *) userAddress andAddressID:(NSNumber *)addressID{
    
    self.deliveryUserName = userName;
    self.deliveryUserTele = userTele;
    self.deliveryUserAddress = userAddress;
    self.currentAddressID = addressID;
    
    [self loadViews];
    
}


- (void) enterBuyProcess{
    
    
    if (self.deliveryUserName.length > 0 && [self.deliveryUserTele valiMobile] && self.deliveryUserAddress > 0) {
        [self setRequestOfCreateOrder];
    }else{
        
        [self showFailTemporaryMes:@"请完善收货信息"];
    }
    
}

#pragma mark - 创建订单
-  (void) setRequestOfCreateOrder{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];

    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    
    int reqTime = [AppGroup getCurrentDate];
    
    [paraDic setObject:[NSNumber numberWithInt:reqTime] forKey:@"reqTime"];
    
    if (!self.isVirtual) {
        [paraDic setObject:self.deliveryUserName forKey:@"consignee_name"];
        [paraDic setObject:self.deliveryUserTele forKey:@"consignee_phone"];
        [paraDic setObject:self.deliveryUserAddress forKey:@"consignee_address"];
        [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
        
    }

    if (self.buyerMessage.length > 0) {
        [paraDic setObject:self.buyerMessage forKey:@"remark"];
    }
    
    NSString *hashToken;
    
    
    hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                 [NSNumber numberWithInt:1],
                                                 [NSNumber numberWithInt:reqTime],
                                                 [[DataManager lightData] readSkey]
                                                 ]];
    
    
    [paraDic setObject:hashToken forKey:@"hashToken"];

    [NetWorkTask postResquestWithApiName:GiftCreate paraDic:paraDic delegate:delegate];
    self.currentApiName = GiftCreate;
    [self startIndicatorLoading];
    
    
}



/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    
    if ([self.currentApiName isEqualToString:GiftCreate]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            self.goodsOrderID = obj.retData.orderId;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPoints" object:nil];
            
            [self showPaySuccessView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
    
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
}


- (void) showPaySuccessView{
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH,
                                                                   HEIGHT)];
    successView.backgroundColor = [UIColor CMLWhiteColor];
    [self.view addSubview:successView];
    
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              StatusBarHeight,
                                                              WIDTH,
                                                              NavigationBarHeight)];
    navBar.backgroundColor = [UIColor CMLWhiteColor];
    navBar.layer.shadowColor = [UIColor blackColor].CGColor;
    navBar.layer.shadowOpacity = 0.05;
    navBar.layer.shadowOffset = CGSizeMake(0, 2);
    [successView addSubview:navBar];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    [leftBtn setImage:[UIImage imageNamed:NavcBackBtnImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:leftBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"兑换成功";
    titleLabel.font = KSystemBoldFontSize17;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.frame  = CGRectMake(WIDTH/2.0 - titleLabel.frame.size.width/2.0,
                                   NavigationBarHeight/2.0 - titleLabel.frame.size.height/2.0,
                                   titleLabel.frame.size.width,
                                   titleLabel.frame.size.height);
    [navBar addSubview:titleLabel];
    
    UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsPaySuccessImg]];
    [upImage sizeToFit];
    upImage.frame = CGRectMake(WIDTH/2.0 - upImage.frame.size.width/2.0,
                               CGRectGetMaxY(navBar.frame) + 20*Proportion,
                               upImage.frame.size.width,
                               upImage.frame.size.height);
    [successView addSubview:upImage];
    
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 300*Proportion/2.0,
                                                                    CGRectGetMaxY(upImage.frame) + 60*Proportion,
                                                                    300*Proportion,
                                                                    70*Proportion)];
    checkBtn.backgroundColor = [UIColor CMLBrownColor];
    checkBtn.layer.cornerRadius = 8*Proportion;
    checkBtn.titleLabel.font = KSystemFontSize14;
    [checkBtn setTitle:@"兑换详情"  forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [successView addSubview:checkBtn];
    [checkBtn addTarget:self action:@selector(enterOrderDetailMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 300*Proportion/2.0,
                                                                   CGRectGetMaxY(checkBtn.frame) + 60*Proportion,
                                                                   300*Proportion,
                                                                   70*Proportion)];
    backBtn.backgroundColor = [UIColor CMLPromptGrayColor];
    backBtn.layer.cornerRadius = 8*Proportion;
    backBtn.titleLabel.font = KSystemFontSize14;
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    [successView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backMainVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) backVC{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) dismissCurrentVController{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) enterOrderDetailMessage{
    
    CMLGiftVC * vc  = [[CMLGiftVC alloc] initWithObjId:self.obj.retData.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) backMainVC{
    
    [[VCManger mainVC] popToRootVCWithAnimated];
}

- (void) editBuyerMessage{
    
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 620*Proportion/2.0,
                                                              CGRectGetMaxY(self.navBar.frame),
                                                              620*Proportion,
                                                              360*Proportion)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    [self.shadowView addSubview:bgView];
    
    
    self.buyerInputField = [[UITextView alloc] initWithFrame:CGRectMake(30*Proportion*2,
                                                                        40*Proportion,
                                                                        (620 - 4*30)*Proportion,
                                                                        360*Proportion)];
    self.buyerInputField.text = self.buyerMessage;;
    self.buyerInputField.textColor = [UIColor CMLtextInputGrayColor];
    self.buyerInputField.tag = 1;
    self.buyerInputField.font = KSystemFontSize14;
    self.buyerInputField.delegate = self;
    [bgView addSubview:self.buyerInputField];
    [self.buyerInputField becomeFirstResponder];
    
    CMLLine *line  = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(30*Proportion, CGRectGetMaxY(self.buyerInputField.frame));
    line.lineLength = (620 - 2*30)*Proportion;
    line.lineWidth = 0.5;
    line.LineColor = [UIColor CMLtextInputGrayColor];
    line.directionOfLine = HorizontalLine;
    [bgView addSubview:line];
    
    /**确定*/
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(620*Proportion/2.0 - 160*Proportion/2.0,
                                                                      line.startingPoint.y + 40*Proportion,
                                                                      160*Proportion,
                                                                      52*Proportion)];
    confirmBtn.layer.cornerRadius = 52*Proportion/2.0;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBuyMessage) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    [bgView addSubview:confirmBtn];
    
    bgView.frame = CGRectMake(bgView.frame.origin.x,
                              bgView.frame.origin.y,
                              bgView.frame.size.width,
                              CGRectGetMaxY(confirmBtn.frame) + 40*Proportion);
    
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.5 animations:^{
        weak.shadowView.hidden = NO;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.buyerInputField resignFirstResponder];
    self.shadowView.hidden = YES;
    
}

- (void) confirmBuyMessage{
    
    if (self.buyerInputField.text.length > 30) {
        
        [self showFailTemporaryMes:@"请您填写30字以内的备注"];
        
    }else{
        
        self.buyerMessage = self.buyerInputField.text;
        self.shadowView.hidden = YES;
        [self.buyerInputField resignFirstResponder];
        [self loadViews];
    }
}

@end
