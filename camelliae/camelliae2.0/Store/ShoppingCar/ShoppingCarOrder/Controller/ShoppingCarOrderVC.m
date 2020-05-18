//
//  ShoppingCarOrderVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/8.
//  Copyright © 2017年 张越. All rights reserved.
//  购物车-确认订单

#import "ShoppingCarOrderVC.h"
#import "VCManger.h"
#import "CMLServeObj.h"
#import "CMLOrderObj.h"
#import "LoginUserObj.h"
#import "DataManager.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLUserAddressListVC.h"
#import "CMLAlterAddressMesaageVC.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "CMLRSAModule.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CMLGoodsOrderDetailVC.h"
#import "GoodsModuleDetailMesObj.h"
#import "BrandShowView.h"
#import "CMLNewInvoiceVC.h"
#import "CMLCarChooseCouponsVC.h"
#import "CMLMyCouponsModel.h"
#import "CMLShoppingCarBrandObj.h"

#define CommodityVCLeftMargin            20
#define CommodityVCBottomMargin          20
#define CommodityVCImageViewHeight       160
#define CommodityVCBtnHeight             44



@interface ShoppingCarOrderVC () <NavigationBarProtocol,NetWorkProtocol,CMLUserAddressLisDelgate,AlterAddressMessageDeleagte,UITextViewDelegate,CMLNewInvoiceVCDelegate, CMLCarChooseCouponsVCDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIView *userMessageView;

@property (nonatomic,copy) NSString *deliveryUserName;

@property (nonatomic,copy) NSString *deliveryUserTele;

@property (nonatomic,copy) NSString *deliveryUserAddress;

@property (nonatomic,strong) UIImageView *WXSelectedImage;

@property (nonatomic,strong) UIImageView *ZFBSelectedImage;

@property (nonatomic,copy) NSString *buyerMessage;

@property (nonatomic,strong) UIView *buyerMessageBgView;

@property (nonatomic,copy) NSString *goodsOrderID;

@property (nonatomic,strong) NSNumber *currentAddressID;

@property (nonatomic,strong) UITextView *buyerInputField;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) BrandShowView *tempBrandShowView;

@property (nonatomic,strong) UISwitch *invoiceSwitch;

@property (nonatomic,strong) UIView *invoiceBgView;

@property (nonatomic,assign) BOOL isOn;

@property (nonatomic,strong) UISwitch *pointSwitch;

@property (nonatomic,copy) NSString *pointDeductionStr;

@property (nonatomic,strong) NSNumber *isPonit;

@property (nonatomic,strong) NSNumber *nowPoint;

@property (nonatomic,strong) NSNumber *reduceMoney;

@property (nonatomic,assign) BOOL pointSwitchOn;

@property (nonatomic,strong) NSNumber *payPrice;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic, assign) CGFloat couponPrice;

/**1,wx 0zfb*/
@property (nonatomic,assign) BOOL payStyle;

/**支付信息*/

@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *noncestr;

@property (nonatomic,copy) NSString *package;

@property (nonatomic,copy) NSString *partnerid;

@property (nonatomic,copy) NSString *prepayid;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,assign) int timestamp;

@property (nonatomic,strong) NSMutableDictionary *invoiceDic;
/*积分*/
@property (nonatomic, strong) UIView *pointBgView;
/*间隔*/
@property (nonatomic, strong) UIView *spaceView;
/*可用优惠券*/
@property (nonatomic, strong) UIView *couponView;

@property (nonatomic, strong) CMLMyCouponsModel *chooseCouponsModel;

@property (nonatomic, strong) UILabel *couponContentLabel;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSMutableArray *targetArray;

@property (nonatomic, strong) NSMutableArray *carPriceArray;

@property (nonatomic, strong) NSMutableArray *carIdArray;

@property (nonatomic, assign) NSInteger carPrice;

@property (nonatomic, copy) NSString *carIdArr;

@property (nonatomic, copy) NSString *carPriceArr;

@property (nonatomic, strong) BaseResultObj *carCouponsObj;

@property (nonatomic, strong) NSMutableArray *carCouponsArray;

/*已选中*/
@property (nonatomic, strong) CMLMyCouponsModel *isChooseModel;

@property (nonatomic, assign) NSInteger dataCount;

@property (nonatomic, strong) NSArray *selectCouponsArray;

@property (nonatomic, strong) NSMutableArray *selectCouponsIdArray;

@property (nonatomic, strong) NSMutableDictionary *selectDict;

@property (nonatomic, strong) BaseResultObj *carCouponsBaseObj;

@property (nonatomic, assign) int isHasDiscount;
/*划线价*/
@property (nonatomic, strong) UILabel *linePriceLabel;

@end

@implementation ShoppingCarOrderVC

- (NSMutableArray *)carCouponsArray {
    
    if (!_carCouponsArray) {
        _carCouponsArray = [NSMutableArray array];
    }
    return _carCouponsArray;
    
}

- (NSMutableArray *)targetArray {
    
    if (!_targetArray) {
        _targetArray = [NSMutableArray array];
    }
    return _targetArray;
    
}

- (NSMutableArray *)carPriceArray {
    
    if (!_carPriceArray) {
        _carPriceArray = [NSMutableArray array];
    }
    return _carPriceArray;
    
}

- (NSMutableArray *)carIdArray {
    
    if (!_carIdArray) {
        _carIdArray = [NSMutableArray array];
    }
    return _carIdArray;
    
}

- (NSMutableDictionary *)invoiceDic{
    
    if (!_invoiceDic) {
        _invoiceDic = [NSMutableDictionary dictionary];
    }
    return _invoiceDic;
    
}

- (NSArray *)selectCouponsArray {
    if (!_selectCouponsArray) {
        _selectCouponsArray = [NSMutableArray array];
    }
    return _selectCouponsArray;
}

- (NSMutableDictionary *)selectDict {
    if (!_selectDict) {
        _selectDict = [NSMutableDictionary dictionary];
    }
    return _selectDict;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(weixinPaySuccess)
     
                                                 name:@"WXPaySuccess" object:nil];
    
    //微信支付取消
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(weixinPayCancel)
     
                                                 name:@"WXErrCodeUserCancel" object:nil];
    
    
    
    //支付宝支付
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ZFBPaySuccess)
                                                 name:@"successPayOfZFB"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ZFBPayCancel)
                                                 name:@"cancelPayOfZFB"
                                               object:nil];
    
}

#pragma mark - 离开页面移除通知
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXPayError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"successPayOfZFB" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXErrCodeUserCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelPayOfZFB" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"确认订单";
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
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - 20*Proportion - SafeAreaBottomHeight)];
    self.mainScrollView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.mainScrollView];
    

    [self loadData];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  HEIGHT - 100*Proportion - SafeAreaBottomHeight,
                                                                  WIDTH,
                                                                  100*Proportion)];
    bottomView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:bottomView];
    
    UILabel *pricePromLab = [[UILabel alloc] init];
    pricePromLab.textColor = [UIColor CMLBlackColor];
    pricePromLab.font = KSystemFontSize14;
    pricePromLab.text = @"支付总额：";
    [pricePromLab sizeToFit];
    pricePromLab.frame = CGRectMake(30*Proportion,
                                    100*Proportion/2.0 - pricePromLab.frame.size.height/2.0,
                                    pricePromLab.frame.size.width,
                                    pricePromLab.frame.size.height);
    [bottomView addSubview:pricePromLab];
    
    
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.textColor = [UIColor CMLGreeenColor];
    self.priceLab.font = KSystemFontSize14;
    self.priceLab.text = [NSString stringWithFormat:@"¥ %d",[[BrandShowView alloc] initWithSource:self.sourceArray  andSelectArray:self.selectArray withBaseObj:self.carOrderBaseObj].tempTotalMoney];
    
    self.payPrice = [NSNumber numberWithInt:[[BrandShowView alloc] initWithSource:self.sourceArray  andSelectArray:self.selectArray withBaseObj:self.carOrderBaseObj].tempTotalMoney];
    
    [self.priceLab sizeToFit];
    self.priceLab.frame = CGRectMake(CGRectGetMaxX(pricePromLab.frame),
                                100*Proportion/2.0 - self.priceLab.frame.size.height/2.0,
                                self.priceLab.frame.size.width,
                                self.priceLab.frame.size.height);
    [bottomView addSubview:self.priceLab];
    
    /*划线价*/
    self.linePriceLabel = [[UILabel alloc] init];
    self.linePriceLabel.font = KSystemFontSize12;
    self.linePriceLabel.textColor = [UIColor CMLPromptGrayColor];
    [bottomView addSubview:self.linePriceLabel];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 250*Proportion,
                                                                  0,
                                                                  250*Proportion,
                                                                  100*Proportion)];
    buyBtn.backgroundColor = [UIColor CMLGreeenColor];
    buyBtn.titleLabel.font = KSystemFontSize16;
    [buyBtn setTitle:@"确认支付" forState:UIControlStateNormal];
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
    
    
    [self setPonitDeductionRequest];
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
    self.payStyle = NO;
    
    [self.invoiceDic setObject:[NSNumber numberWithInt:1] forKey:@"invoiceTop"];
    [self.invoiceDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    
    [self getData];
}

/*请求优惠券数据以判断是否有优惠券*/
- (void)setChooseRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInt:10000] forKey:@"pageSize"];
    [dict setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"process"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"isUse"];
    if (self.carPriceArr.length > 0) {
        [dict setObject:self.carPriceArr forKey:@"priceArr"];
    }
    if (self.carIdArr.length > 0) {
        [dict setObject:self.carIdArr forKey:@"carIdArr"];
    }
    NSLog(@"%@", dict);
    [NetWorkTask postResquestWithApiName:PersonCenterCarUseCoupons paraDic:dict delegate:delegate];
    self.currentApiName = PersonCenterCarUseCoupons;
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
    
    /**商品信息*/
    self.tempBrandShowView = [[BrandShowView alloc] initWithSource:self.sourceArray  andSelectArray:self.selectArray withBaseObj:self.carOrderBaseObj];
    self.tempBrandShowView.frame = CGRectMake(0,
                                              CGRectGetMaxY(spaceView1.frame),
                                              WIDTH,
                                              self.tempBrandShowView.currentheight);
    [self.mainScrollView addSubview:self.tempBrandShowView];
    
    UIView *upTwoView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.tempBrandShowView.frame),
                                                                 WIDTH,
                                                                 20*Proportion)];
    upTwoView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:upTwoView];
    
    /*买家留言*/
    if (self.buyerMessage.length == 0) {
        
        self.buyerMessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(upTwoView.frame),
                                                                           WIDTH,
                                                                           76*Proportion)];
        self.buyerMessageBgView.backgroundColor = [UIColor CMLWhiteColor];
        [self.mainScrollView addSubview:self.buyerMessageBgView];
        
        UILabel *buyerMessagePromLab = [[UILabel alloc] init];
        buyerMessagePromLab.text = @"买家留言：";
        buyerMessagePromLab.font = KSystemFontSize13;
        [buyerMessagePromLab sizeToFit];
        buyerMessagePromLab.frame = CGRectMake(30*Proportion,
                                               self.buyerMessageBgView.frame.size.height/2.0 - buyerMessagePromLab.frame.size.height/2.0,
                                               buyerMessagePromLab.frame.size.width,
                                               buyerMessagePromLab.frame.size.height);
        [self.buyerMessageBgView addSubview:buyerMessagePromLab];
        
        UILabel *buyerMessagePromLab2 = [[UILabel alloc] init];
        buyerMessagePromLab2.text = @"请在这里填写您的商品备注（限30字以内）";
        buyerMessagePromLab2.font = KSystemFontSize13;
        [buyerMessagePromLab2 sizeToFit];
        buyerMessagePromLab2.textColor = [UIColor CMLPromptGrayColor];
        buyerMessagePromLab2.frame = CGRectMake(CGRectGetMaxX(buyerMessagePromLab.frame),
                                                buyerMessagePromLab.center.y - buyerMessagePromLab2.frame.size.height/2.0,
                                                buyerMessagePromLab2.frame.size.width,
                                                buyerMessagePromLab2.frame.size.height);
        [self.buyerMessageBgView addSubview:buyerMessagePromLab2];
        
        UIButton *button = [[UIButton alloc] initWithFrame:self.buyerMessageBgView.bounds];
        button.backgroundColor = [UIColor clearColor];
        [self.buyerMessageBgView addSubview:button];
        [button addTarget:self action:@selector(editBuyerMessage) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        UILabel *buyerMessageLab = [[UILabel alloc] init];
        buyerMessageLab.text = [NSString stringWithFormat:@"买家留言：%@",self.buyerMessage];
        buyerMessageLab.font = KSystemFontSize13;
        buyerMessageLab.numberOfLines = 0;
        buyerMessageLab.textColor = [UIColor CMLBlackColor];
        CGRect currentRect= [buyerMessageLab.text boundingRectWithSize:CGSizeMake(WIDTH - 30*Proportion*2, 1000)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                               context:nil];
        buyerMessageLab.frame = CGRectMake(30*Proportion,
                                           20*Proportion,
                                           WIDTH - 30*Proportion*2,
                                           currentRect.size.height);
        
        self.buyerMessageBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(upTwoView.frame),
                                                                           WIDTH,
                                                                           buyerMessageLab.frame.size.height +20*Proportion*2)];
        self.buyerMessageBgView.backgroundColor = [UIColor CMLWhiteColor];
        [self.mainScrollView addSubview:self.buyerMessageBgView];
        [self.buyerMessageBgView addSubview:buyerMessageLab];
        
        UIButton *button = [[UIButton alloc] initWithFrame:self.buyerMessageBgView.bounds];
        button.backgroundColor = [UIColor clearColor];
        [self.buyerMessageBgView addSubview:button];
        [button addTarget:self action:@selector(editBuyerMessage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    self.spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetMaxY(self.buyerMessageBgView.frame),
                                                              WIDTH,
                                                              20*Proportion)];
    self.spaceView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:self.spaceView];
    
    /*选择优惠券*/
    self.couponView = [[UIView alloc] init];
    self.couponView.backgroundColor = [UIColor CMLWhiteColor];
    self.couponView.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.spaceView.frame),
                                       WIDTH,
                                       74 * Proportion);
    [self.mainScrollView addSubview:self.couponView];
    
    UILabel *couponTitleLabel = [[UILabel alloc] init];
    couponTitleLabel.backgroundColor = [UIColor clearColor];
    couponTitleLabel.text = @"使用优惠券";
    couponTitleLabel.font = KSystemFontSize13;
    [couponTitleLabel sizeToFit];
    couponTitleLabel.frame = CGRectMake(30 * Proportion,
                                        CGRectGetHeight(self.couponView.frame)/2.0 - CGRectGetHeight(couponTitleLabel.frame)/2.0,
                                        CGRectGetWidth(couponTitleLabel.frame),
                                        CGRectGetHeight(couponTitleLabel.frame));
    [self.couponView addSubview:couponTitleLabel];
    
    UIImageView *enterCouponView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLEnterDiscountCouponIcon]];
    enterCouponView.backgroundColor = [UIColor clearColor];
    [enterCouponView sizeToFit];
    enterCouponView.frame = CGRectMake(WIDTH - 30 * Proportion - CGRectGetWidth(enterCouponView.frame),
                                       CGRectGetMidY(couponTitleLabel.frame) - CGRectGetHeight(enterCouponView.frame)/2.0,
                                       CGRectGetWidth(enterCouponView.frame),
                                       CGRectGetHeight(enterCouponView.frame));
    [self.couponView addSubview:enterCouponView];
    
    self.couponContentLabel = [[UILabel alloc] init];
    self.couponContentLabel.backgroundColor = [UIColor clearColor];
    self.couponContentLabel.text = @"有可用优惠券";
    self.couponContentLabel.textColor = [UIColor CMLYellowD9AB5EColor];
    self.couponContentLabel.font = KSystemFontSize13;
    self.couponContentLabel.textAlignment = NSTextAlignmentRight;
    [self.couponContentLabel sizeToFit];
    self.couponContentLabel.frame = CGRectMake(CGRectGetMinX(enterCouponView.frame) - 15 * Proportion - 450 * Proportion,
                                               CGRectGetMidY(couponTitleLabel.frame) - CGRectGetHeight(self.couponContentLabel.frame)/2.0,
                                               450 * Proportion,
                                               CGRectGetHeight(self.couponContentLabel.frame));
    [self.couponView addSubview:self.couponContentLabel];
    
    UIButton *enterCouponBtn = [[UIButton alloc] initWithFrame:self.couponView.bounds];
    enterCouponBtn.backgroundColor = [UIColor clearColor];
    [self.couponView addSubview:enterCouponBtn];
    [enterCouponBtn addTarget:self action:@selector(enterCouponBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    /*积分抵用*/
    self.pointBgView = [[UIView alloc] init];
    self.pointBgView.backgroundColor = [UIColor CMLWhiteColor];
    self.pointBgView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.spaceView.frame) + CGRectGetHeight(self.couponView.frame),
                                        WIDTH,
                                        74*Proportion);
    [self.mainScrollView addSubview:self.pointBgView];
    
    UILabel *pointPromLab = [[UILabel alloc] init];
    pointPromLab.text = self.pointDeductionStr;
    pointPromLab.font = KSystemFontSize13;
    [pointPromLab sizeToFit];
    pointPromLab.frame = CGRectMake(30*Proportion,
                                    74*Proportion/2.0 - pointPromLab.frame.size.height/2.0,
                                    pointPromLab.frame.size.width,
                                    pointPromLab.frame.size.height);
    [self.pointBgView addSubview:pointPromLab];
    
    self.pointSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - 76*Proportion,
                                                                  74*Proportion/2.0 - 40*Proportion/2.0,
                                                                  76*Proportion,
                                                                  40*Proportion)];
    self.pointSwitch.onTintColor = [UIColor CMLBrownColor];
    self.pointSwitch.transform = CGAffineTransformMakeScale( 0.6, 0.6);
    self.pointSwitch.center = CGPointMake(self.pointSwitch.center.x - 20*Proportion, pointPromLab.center.y);
    [self.pointSwitch addTarget:self action:@selector(changePointStatus) forControlEvents:UIControlEventValueChanged];
    [self.pointBgView addSubview:self.pointSwitch];
    self.pointSwitch.on = self.pointSwitchOn;
    
    if ([self.isPonit intValue] == 1) {
        self.pointSwitch.userInteractionEnabled = YES;
    }else{
        self.pointSwitch.userInteractionEnabled = NO;
    }

    /*是否有优惠券可用*/
    if (self.dataCount > 0) {
        self.couponView.hidden = NO;
    }else {
        self.couponView.hidden = YES;
        self.couponView.frame = CGRectZero;
    }
    /*是否显示积分*/
    if (self.dataCount > 0 || self.isHasDiscount > 0) {
        self.pointBgView.hidden = YES;
        self.pointBgView.frame = CGRectZero;
    }else {
        self.pointBgView.hidden = NO;
        self.pointBgView.frame = CGRectMake(0,
                                            CGRectGetMaxY(self.spaceView.frame) + CGRectGetHeight(self.couponView.frame),
                                            WIDTH,
                                            74*Proportion);
    }

    /*发票*/
    self.invoiceBgView = [[UIView alloc] init];
    self.invoiceBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.mainScrollView addSubview:self.invoiceBgView];
    
    UILabel *invoicePromLab = [[UILabel alloc] init];
    invoicePromLab.text = @"开具发票：";
    invoicePromLab.font = KSystemFontSize13;
    [invoicePromLab sizeToFit];
    invoicePromLab.frame = CGRectMake(30*Proportion,
                                      74*Proportion/2.0 - invoicePromLab.frame.size.height/2.0,
                                      invoicePromLab.frame.size.width,
                                      invoicePromLab.frame.size.height);
    [self.invoiceBgView addSubview:invoicePromLab];
    
    self.invoiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 30*Proportion - 76*Proportion,
                                                                    74*Proportion/2.0 - 40*Proportion/2.0,
                                                                    76*Proportion,
                                                                    40*Proportion)];
    self.invoiceSwitch.onTintColor = [UIColor CMLBrownColor];
    self.invoiceSwitch.transform = CGAffineTransformMakeScale( 0.6, 0.6);
    self.invoiceSwitch.center = CGPointMake(self.invoiceSwitch.center.x - 20*Proportion, invoicePromLab.center.y - self.invoiceBgView.frame.size.height/2.0);
    [self.invoiceSwitch addTarget:self action:@selector(changeInvoiceStatus) forControlEvents:UIControlEventValueChanged];
    [self.invoiceBgView addSubview:self.invoiceSwitch];
    self.invoiceSwitch.on = self.isOn;
    
    if (self.invoiceSwitch.on) {
        
        self.invoiceBgView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.spaceView.frame) + CGRectGetHeight(self.pointBgView.frame) + CGRectGetHeight(self.couponView.frame),
                                              WIDTH,
                                              74*Proportion + 84*Proportion);
        
        UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                     74*Proportion,
                                                                     WIDTH - 30*Proportion*2,
                                                                     1*Proportion)];
        spaceLine.backgroundColor = [UIColor CMLNewGrayColor];
        [self.invoiceBgView addSubview:spaceLine];
        
        if ([self.invoiceDic allKeys].count > 0) {
            
            UILabel *firstLab = [[UILabel alloc] init];
            firstLab.font = KSystemBoldFontSize12;
            
            if ([[self.invoiceDic valueForKey:@"invoiceTop"] intValue] == 1 && [[self.invoiceDic valueForKey:@"type"] intValue] == 1) {
                firstLab.text = @"发票抬头：个人           发票类型：普通发票";
            }else if ([[self.invoiceDic valueForKey:@"invoiceTop"] intValue] == 2 && [[self.invoiceDic valueForKey:@"type"] intValue] == 1){
                
                firstLab.text = @"发票抬头：企业           发票类型：普通发票";
            }else if ([[self.invoiceDic valueForKey:@"invoiceTop"] intValue] == 2 && [[self.invoiceDic valueForKey:@"type"] intValue] == 2){
                
                firstLab.text = @"发票抬头：企业           发票类型：专业发票";
            }
            
            [firstLab sizeToFit];
            firstLab.textColor = [UIColor CMLBlackColor];
            firstLab.frame = CGRectMake(30*Proportion,
                                        74*Proportion + (84*Proportion/2.0 - firstLab.frame.size.height/2.0),
                                        firstLab.frame.size.width,
                                        firstLab.frame.size.height);
            [self.invoiceBgView addSubview:firstLab];
            
            UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MoreMessageImg]];
            enterImage.userInteractionEnabled = YES;
            [enterImage sizeToFit];
            enterImage.frame = CGRectMake(WIDTH - enterImage.frame.size.width - 30*Proportion,
                                          firstLab.center.y - enterImage.frame.size.height/2.0,
                                          enterImage.frame.size.width,
                                          enterImage.frame.size.height);
            [self.invoiceBgView addSubview:enterImage];
            
        }else{
            
            UILabel *firstLab = [[UILabel alloc] init];
            firstLab.font = KSystemBoldFontSize12;
            firstLab.text = @"发票抬头：个人           发票类型：普通发票";
            [firstLab sizeToFit];
            firstLab.textColor = [UIColor CMLBlackColor];
            firstLab.frame = CGRectMake(30*Proportion,
                                        74*Proportion + (84*Proportion/2.0 - firstLab.frame.size.height/2.0),
                                        firstLab.frame.size.width,
                                        firstLab.frame.size.height);
            [self.invoiceBgView addSubview:firstLab];
            
            UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MoreMessageImg]];
            enterImage.userInteractionEnabled = YES;
            [enterImage sizeToFit];
            enterImage.frame = CGRectMake(WIDTH - enterImage.frame.size.width - 30*Proportion,
                                          firstLab.center.y - enterImage.frame.size.height/2.0,
                                          enterImage.frame.size.width,
                                          enterImage.frame.size.height);
            [self.invoiceBgView addSubview:enterImage];
            
        }
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                        74*Proportion,
                                                                        WIDTH,
                                                                        84*Proportion)];
        enterBtn.backgroundColor = [UIColor clearColor];
        [self.invoiceBgView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterInvoiceVC) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        self.invoiceBgView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.spaceView.frame) + CGRectGetHeight(self.couponView.frame) + CGRectGetHeight(self.pointBgView.frame),
                                              WIDTH,
                                              74*Proportion);
        
    }
    
    
    UIView *newAddView2 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.invoiceBgView.frame),
                                                                   WIDTH,
                                                                   20*Proportion)];
    newAddView2.backgroundColor = [UIColor CMLUserGrayColor];
    [self.mainScrollView addSubview:newAddView2];
    
    /**支付信息*/
    UILabel *payMes = [[UILabel alloc] init];
    payMes.text = @"支付方式";
    payMes.textColor = [UIColor CMLtextInputGrayColor];
    payMes.font = KSystemFontSize12;
    [payMes sizeToFit];
    payMes.frame = CGRectMake(30*Proportion,
                              CGRectGetMaxY(newAddView2.frame) + 30*Proportion,
                              payMes.frame.size.width,
                              payMes.frame.size.height);
    [self.mainScrollView addSubview:payMes];
    
    
    UIView *ZFBbgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(payMes.frame) + 20*Proportion,
                                                                 WIDTH,
                                                                 140*Proportion)];
    ZFBbgView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:ZFBbgView];
    
    UIImageView *ZFBImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsZFBPayImg]];
    [ZFBImage sizeToFit];
    ZFBImage.frame = CGRectMake(30*Proportion,
                                140*Proportion/2.0 - ZFBImage.frame.size.height/2.0,
                                ZFBImage.frame.size.width,
                                ZFBImage.frame.size.height);
    [ZFBbgView addSubview:ZFBImage];
    
    UILabel *ZFBPromLab = [[UILabel alloc] init];
    ZFBPromLab.textColor = [UIColor CMLBlackColor];
    ZFBPromLab.text = @"支付宝支付";
    ZFBPromLab.font = KSystemFontSize12;
    [ZFBPromLab sizeToFit];
    ZFBPromLab.frame = CGRectMake(CGRectGetMaxX(ZFBImage.frame) + 20*Proportion,
                                  ZFBImage.center.y - ZFBPromLab.frame.size.height/2.0,
                                  ZFBPromLab.frame.size.width,
                                  ZFBPromLab.frame.size.height);
    [ZFBbgView addSubview:ZFBPromLab];
    
    UIImageView *ZFBSelectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsSelectImg]];
    [ZFBSelectImage sizeToFit];
    ZFBSelectImage.frame = CGRectMake(WIDTH - 30*Proportion - ZFBSelectImage.frame.size.width,
                                      140*Proportion/2.0 - ZFBSelectImage.frame.size.height/2.0,
                                      ZFBSelectImage.frame.size.width,
                                      ZFBSelectImage.frame.size.height);
    [ZFBbgView addSubview:ZFBSelectImage];
    
    self.ZFBSelectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsSelectedImg]];
    [self.ZFBSelectedImage sizeToFit];
    self.ZFBSelectedImage.frame = CGRectMake(ZFBSelectImage.center.x - self.ZFBSelectedImage.frame.size.width/2.0,
                                             140*Proportion/2.0 - self.ZFBSelectedImage.frame.size.height/2.0,
                                             self.ZFBSelectedImage.frame.size.width,
                                             self.ZFBSelectedImage.frame.size.height);
    [ZFBbgView addSubview:self.ZFBSelectedImage];
    
    if (self.payStyle) {
        
        self.ZFBSelectedImage.hidden = YES;
    }
    
    UIButton *ZFBSelectBtn = [[UIButton alloc] initWithFrame:ZFBbgView.bounds];
    ZFBSelectBtn.backgroundColor = [UIColor clearColor];
    [ZFBbgView addSubview:ZFBSelectBtn];
    [ZFBSelectBtn addTarget:self action:@selector(selectZFBPayStyle) forControlEvents:UIControlEventTouchUpInside];
    
    CMLLine *topLine = [[CMLLine alloc] init];
    topLine.startingPoint = CGPointMake(30*Proportion, 1*Proportion);
    topLine.LineColor = [UIColor CMLPromptGrayColor];
    topLine.lineWidth = 1*Proportion;
    topLine.lineLength = WIDTH - 30*Proportion*2;
    [ZFBbgView addSubview:topLine];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.startingPoint = CGPointMake(30*Proportion, 138*Proportion);
    bottomLine.LineColor = [UIColor CMLPromptGrayColor];
    bottomLine.lineWidth = 1*Proportion;
    bottomLine.lineLength = WIDTH - 30*Proportion*2;
    [ZFBbgView addSubview:bottomLine];
    
    
    UIView *WXbgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                CGRectGetMaxY(ZFBbgView.frame),
                                                                WIDTH,
                                                                140*Proportion)];
    WXbgView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:WXbgView];
    
    UIImageView *WXImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsWXPayImg]];
    [WXImage sizeToFit];
    WXImage.frame = CGRectMake(30*Proportion,
                               140*Proportion/2.0 - WXImage.frame.size.height/2.0,
                               WXImage.frame.size.width,
                               WXImage.frame.size.height);
    [WXbgView addSubview:WXImage];
    
    UILabel *WXPromLab = [[UILabel alloc] init];
    WXPromLab.textColor = [UIColor CMLBlackColor];
    WXPromLab.text = @"微信支付";
    WXPromLab.font = KSystemFontSize12;
    [WXPromLab sizeToFit];
    WXPromLab.frame = CGRectMake(CGRectGetMaxX(WXImage.frame) + 20*Proportion,
                                 WXImage.center.y - WXPromLab.frame.size.height/2.0,
                                 WXPromLab.frame.size.width,
                                 WXPromLab.frame.size.height);
    [WXbgView addSubview:WXPromLab];
    UIImageView *WXSelectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsSelectImg]];
    [WXSelectImage sizeToFit];
    WXSelectImage.frame = CGRectMake(WIDTH - 30*Proportion - WXSelectImage.frame.size.width,
                                     140*Proportion/2.0 - WXSelectImage.frame.size.height/2.0,
                                     WXSelectImage.frame.size.width,
                                     WXSelectImage.frame.size.height);
    [WXbgView addSubview:WXSelectImage];
    
    self.WXSelectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:GoodsSelectedImg]];
    [self.WXSelectedImage sizeToFit];
    self.WXSelectedImage.frame = CGRectMake(WXSelectImage.center.x - self.WXSelectedImage.frame.size.width/2.0,
                                            140*Proportion/2.0 - self.WXSelectedImage.frame.size.height/2.0,
                                            self.WXSelectedImage.frame.size.width,
                                            self.WXSelectedImage.frame.size.height);
    [WXbgView addSubview:self.WXSelectedImage];
    
    UIButton *WXSelectBtn = [[UIButton alloc] initWithFrame:WXbgView.bounds];
    WXSelectBtn.backgroundColor = [UIColor clearColor];
    [WXbgView addSubview:WXSelectBtn];
    [WXSelectBtn addTarget:self action:@selector(selectWXPayStyle) forControlEvents:UIControlEventTouchUpInside];
    
    
    CMLLine *bottomLine2 = [[CMLLine alloc] init];
    bottomLine2.startingPoint = CGPointMake(30*Proportion, 138*Proportion);
    bottomLine2.LineColor = [UIColor CMLPromptGrayColor];
    bottomLine2.lineWidth = 1*Proportion;
    bottomLine2.lineLength = WIDTH - 30*Proportion*2;
    [WXbgView addSubview:bottomLine2];
    
    if (!self.payStyle) {
        
        self.WXSelectedImage.hidden = YES;
    }

    self.mainScrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(WXbgView.frame) + 150*Proportion);
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

- (void) selectWXPayStyle{
    
    self.payStyle = YES;
    self.WXSelectedImage.hidden = NO;
    self.ZFBSelectedImage.hidden = YES;
}

- (void) selectZFBPayStyle{
    
    self.payStyle = NO;
    self.WXSelectedImage.hidden = YES;
    self.ZFBSelectedImage.hidden = NO;
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
    
    NSString *str = [self.selectArray componentsJoinedByString:@","];
    
    [paraDic setObject:[NSString stringWithFormat:@"[%@]",str] forKey:@"carId"];
    
    int reqTime = [AppGroup getCurrentDate];
    
    [paraDic setObject:[NSNumber numberWithInt:reqTime] forKey:@"reqTime"];
    [paraDic setObject:self.deliveryUserName forKey:@"consigneeName"];
    [paraDic setObject:self.deliveryUserTele forKey:@"consigneePhone"];
    [paraDic setObject:self.deliveryUserAddress forKey:@"consigneeAddress"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithBool:self.pointSwitch.isOn] forKey:@"isPoint"];
    
    if (self.buyerMessage.length > 0) {
        [paraDic setObject:self.buyerMessage forKey:@"remark"];
    }
    
    if (self.isOn) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.invoiceDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [paraDic setObject:jsonString forKey:@"invoiceObj"];
        
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"invoiceStatus"];
        
        NSString *hashToken;
        
        hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                     self.deliveryUserAddress,
                                                     self.deliveryUserName,
                                                     self.deliveryUserTele,
                                                     [NSNumber numberWithInt:1],
                                                     [NSNumber numberWithInt:reqTime],
                                                     [[DataManager lightData] readSkey]]];
        
        
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
    }else{
        
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"invoiceStatus"];
        
        NSString *hashToken;
        
        hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],
                                                     self.deliveryUserAddress,
                                                     self.deliveryUserName,
                                                     self.deliveryUserTele,
                                                     [NSNumber numberWithInt:2],
                                                     [NSNumber numberWithInt:reqTime],
                                                     [[DataManager lightData] readSkey]]];
        
        
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }

    if (self.selectCouponsArray) {
        [paraDic setObject:@"1" forKey:@"isCoupons"];
        if (self.selectCouponsIdArray.count > 1) {
            [paraDic setObject:[NSString stringWithFormat:@"[%@]", [self.selectCouponsArray componentsJoinedByString:@","]] forKey:@"couponsId"];
        }else {
            [paraDic setObject:[NSString stringWithFormat:@"[%@]", [self.selectCouponsArray firstObject]] forKey:@"couponsId"];
        }

    }
    
    [NetWorkTask postResquestWithApiName:MailNewCreateCarOrder paraDic:paraDic delegate:delegate];
    
    self.currentApiName = MailNewCreateCarOrder;
    [self startIndicatorLoading];
 
}

- (void) setPonitDeductionRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.payPrice forKey:@"price"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    
    [NetWorkTask postResquestWithApiName:GoodsPointDeduction paraDic:paraDic delegate:delegate];
    
    self.currentApiName = GoodsPointDeduction;
    
    [self startIndicatorLoading];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    
    if ([self.currentApiName isEqualToString:MailNewCreateCarOrder]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        NSLog(@"%@", responseResult);
        if ([obj.retCode intValue] == 0) {
            
            self.goodsOrderID = obj.retData.orderId;
            
            if (self.payStyle) {
                
                [self startPayProcess];
                
            }else{
                
                [self startzhifubaoPayProcess];
            }
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
    }else  if ([self.currentApiName isEqualToString:GoodsWXGetMessage]){
        
        [self stopIndicatorLoading];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            /**微信支付所需信息*/
            self.appid = obj.retData.appid;
            self.noncestr = obj.retData.noncestr;
            self.package = obj.retData.package;
            self.partnerid = obj.retData.partnerid;
            self.prepayid = obj.retData.prepayid;
            self.sign = obj.retData.sign;
            self.timestamp = [obj.retData.timestamp intValue];
            /**************/
            /**进入微信进行支付*/
            [self enterWXAPP];
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:GoodsZFBGetMessage]){
        
        [self stopIndicatorLoading];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            NSString *sign1 =[CMLRSAModule decryptString:obj.retData.alipaySignToken  publicKey:PUBKEY];
            if ([[obj.retData.alipaySign md5] isEqualToString:sign1]) {
                [[AlipaySDK defaultService] payOrder:obj.retData.alipaySign fromScheme:@"alipaySDKCML" callback:^(NSDictionary *resultDic) {
                    
                }];
            }
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:GoodsOrderConfirm]){
        
        [CMLMobClick ShoppingCartSettlement];
        [CMLMobClick PaymentSuccess];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
        }
    }else if ([self.currentApiName isEqualToString:GoodsPointDeduction]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.pointDeductionStr = obj.retData.ispointstr;
            self.isPonit = obj.retData.ispoint;
            self.nowPoint = obj.retData.now_point;
            self.reduceMoney =  obj.retData.deduc_money;
        
            [self loadViews];
            [self setChooseRequest];/*请求结果验证是否存在优惠券*/
            
        }
    }else if ([self.currentApiName isEqualToString:PersonCenterCarUseCoupons]) {
        NSLog(@"%@", responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            self.dataCount = [obj.retData.dataCount integerValue];
            NSLog(@"%ld", self.dataCount);
            [self loadViews];
        }
    }
    [self stopIndicatorLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
}

#pragma mark - 进入微信支付流程
- (void) startPayProcess{
    
    
    if ([WXApi isWXAppInstalled]) {
        
        
        [self getWeiXinMesRequest];
        
    }else{
        
        [self showFailTemporaryMes:@"没有检测到您的支付软件"];
    }
    
}

#pragma mark - 进入支付宝
- (void) startzhifubaoPayProcess{
    
    
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        
        [self showFailTemporaryMes:@"没有检测到您的支付软件"];
        
    }else{
        
        [self getZFBMesRequest];
    }
}

#pragma mark -调起支付
- (void) enterWXAPP{
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = self.partnerid;
    req.prepayId            = self.prepayid;
    req.nonceStr            = self.noncestr;
    req.timeStamp           = self.timestamp;
    req.package             = self.package;
    req.sign                = [CMLRSAModule decryptString:self.sign publicKey:PUBKEY];
    
    [WXApi sendReq:req];
    
}


#pragma mark - 获取微信支付信息
- (void) getWeiXinMesRequest{
    if (self.goodsOrderID) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.goodsOrderID forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.goodsOrderID,reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:GoodsWXGetMessage paraDic:paraDic delegate:delegate];
        self.currentApiName = GoodsWXGetMessage;
    }
}

#pragma mark - 获取支付宝支付信息
- (void) getZFBMesRequest{
    if (self.goodsOrderID) {
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
        [paraDic setObject:self.goodsOrderID forKey:@"orderId"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.goodsOrderID,reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        [NetWorkTask postResquestWithApiName:GoodsZFBGetMessage paraDic:paraDic delegate:delegate];
        self.currentApiName = GoodsZFBGetMessage;
    }
}

#pragma mark - 确认
- (void) setRequestOfConfirm{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:self.goodsOrderID forKey:@"orderId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],self.goodsOrderID,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:GoodsOrderConfirm paraDic:paraDic delegate:delegate];
    self.currentApiName = GoodsOrderConfirm;
    
}

- (void) weixinPaySuccess{
    
    [self setRequestOfConfirm];
    
    [self showPaySuccessView];
    
}

/*取消微信支付*/
- (void)weixinPayCancel {
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) ZFBPaySuccess{
    
    [self setRequestOfConfirm];
    
    [self showPaySuccessView];
    
}

/*支付宝支付取消*/
- (void)ZFBPayCancel {
    
    [[VCManger mainVC] dismissCurrentVC];
    
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
    titleLabel.text = @"支付成功";
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
    [checkBtn setTitle:@"订单详情"  forState:UIControlStateNormal];
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
    for (int i = 0; i < 100; i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d", i]];
    }
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) dismissCurrentVController{
    for (int i = 0; i < 100; i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d", i]];
    }
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) enterOrderDetailMessage{
    
    CMLGoodsOrderDetailVC * vc  = [[CMLGoodsOrderDetailVC alloc] initWithOrderId:self.goodsOrderID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) backMainVC{
    for (int i = 0; i < 100; i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d", i]];
    }
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

- (void) changeInvoiceStatus{
    
    self.isOn = !self.isOn;
    
    [self loadViews];
}

- (void) enterInvoiceVC{
    
    CMLNewInvoiceVC *vc = [[CMLNewInvoiceVC alloc] initWith:self.invoiceDic];
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

#pragma mark - CMLNewInvoiceVCDelegate
- (void) outPutInvoiceMes:(NSDictionary *) targetDic{
    
    self.invoiceDic = [NSMutableDictionary dictionaryWithDictionary:targetDic];
    [self loadViews];
    
}

- (void) changePointStatus{
    
    self.pointSwitchOn = self.pointSwitch.isOn;
    
    if (self.pointSwitchOn == 1) {
        
        self.priceLab.text = [NSString stringWithFormat:@"¥ %0.2f",[self.payPrice floatValue] - [self.reduceMoney floatValue]];
        [self.priceLab sizeToFit];
        self.priceLab.frame = CGRectMake(self.priceLab.frame.origin.x,
                                         100*Proportion/2.0 - self.priceLab.frame.size.height/2.0,
                                         self.priceLab.frame.size.width,
                                         self.priceLab.frame.size.height);
        
        [self.tempBrandShowView refreshPoints:self.nowPoint];
    }else{
        
        self.priceLab.text = [NSString stringWithFormat:@"¥ %0.2f",[self.payPrice floatValue]];
        [self.priceLab sizeToFit];
        self.priceLab.frame = CGRectMake(self.priceLab.frame.origin.x,
                                         100*Proportion/2.0 - self.priceLab.frame.size.height/2.0,
                                         self.priceLab.frame.size.width,
                                         self.priceLab.frame.size.height);
        

        [self.tempBrandShowView refreshOldPoints];
        
        
    }
    
}
/*购物车优惠*/
- (void)getData {
    
    /***数据处理*/
    for (int i = 0; i < self.sourceArray.count; i++) {
        
        CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:self.sourceArray[i]];
        
        for (int j = 0; j < self.selectArray.count; j++) {
            
            if ([tempObj.carId intValue] == [self.selectArray[j] intValue]) {
                
                [self.targetArray addObject:self.sourceArray[i]];
                
            }
        }
    }
    
    for (int i = 0; i < self.targetArray.count; i++) {
        
        CMLShoppingCarBrandObj *obj = [CMLShoppingCarBrandObj getBaseObjFrom:self.targetArray[i]];
        [self.carIdArray addObject:obj.carId];
        
        if ([obj.objType intValue] == 3) {
            
            if ([obj.packageInfo.payMode intValue] == 1) {
                self.carPrice = [obj.packageInfo.subscription integerValue];
            }else{
                self.carPrice = [obj.packageInfo.totalAmount integerValue];
            }
            
        }else if ([obj.objType intValue] == 7){

            if ([obj.projectInfo.is_deposit intValue] == 1) {
                self.carPrice = [obj.projectInfo.deposit_money integerValue];
            }else{
                self.carPrice = [obj.packageInfo.totalAmount integerValue];
            }
        }

        /*如果存在折扣价*/
        if ([self.carOrderBaseObj.retData.isEnjoyDiscount intValue] == 1) {
            if (obj.projectInfo.is_discount) {
                if ([obj.projectInfo.is_discount intValue] == 1) {
                    if ([obj.packageInfo.discount intValue] != 0) {
                        self.carPrice = [obj.packageInfo.discount integerValue];
                        self.isHasDiscount = 1;
                    }
                }
            }
        }
        
        [self.carPriceArray addObject:[NSNumber numberWithInteger:self.carPrice]];
        
    }
    self.carIdArr = [self ObjectToJsonString:self.carIdArray];
    self.carPriceArr = [self ObjectToJsonString:self.carPriceArray];
//    self.carIdArr = [self.carIdArray componentsJoinedByString:@","];
//    self.carPriceArr = [self.carPriceArray componentsJoinedByString:@","];
    
}

- (void)enterCouponBtnClicked {
    
    CMLCarChooseCouponsVC *vc = [[CMLCarChooseCouponsVC alloc] init];
    vc.delegate = self;
    vc.carIdArr = self.carIdArr;
    vc.carPriceArr = self.carPriceArr;
    vc.isSelect = self.isSelect;
    vc.couponsIdArray = self.selectCouponsArray;
    vc.carSelectDict = self.selectDict;

    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

/*临时工具方法*/
- (NSString *)ObjectToJsonString:(id)object {
    
    NSString *jsonString = [[NSString alloc] init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

#pragma mark - CMLCarChooseCouponsVCDelegate
- (void)backChooseCarModelOfChooseVC:(NSArray *)chooseCoupons withRow:(NSNumber *)row withIsSelect:(BOOL)isSelect {
}
- (void)backChooseCarCouponsRefreshPrice {
}
- (void)backChooseCarCouponsWithDataCount:(int)dataCount with:(BaseResultObj *)carCouponsObj {
}

- (void)backCarChooseCouponsWithDataArray:(NSArray *)dataArray WithDict:(NSMutableDictionary *)dict {
    
    self.selectDict = dict;
    self.selectCouponsArray = [dict allKeys];
    NSLog(@"%ld", (long)self.selectCouponsArray.count);
    int couponsPrice = 0;
    for (int i = 0; i < self.selectCouponsArray.count; i++) {
        
        for (int j = 0; j < dataArray.count; j++) {
            CMLMyCouponsModel *chooseModel = [CMLMyCouponsModel getBaseObjFrom:dataArray[j]];
            if ([chooseModel.currentID intValue] == [self.selectCouponsArray[i] intValue]) {
                
                couponsPrice += [chooseModel.breaksMoney intValue];
            }
        }
    }
    self.priceLab.text = [NSString stringWithFormat:@"¥ %0.2f", [self.payPrice floatValue] - couponsPrice];
//#warning 添加使用优惠券后价格是否为负判断
    if ([self.payPrice floatValue] - couponsPrice < 0) {
        self.priceLab.text = [NSString stringWithFormat:@"¥ 0.00"];
    }
    [self.priceLab sizeToFit];
    self.priceLab.frame = CGRectMake(self.priceLab.frame.origin.x,
                                     100*Proportion/2.0 - self.priceLab.frame.size.height/2.0,
                                     self.priceLab.frame.size.width,
                                     self.priceLab.frame.size.height);
    if (self.selectCouponsArray.count > 0) {
        self.couponContentLabel.text = @"已使用优惠券";
//#warning 添加划线价
        self.linePriceLabel.text = [NSString stringWithFormat:@"¥ %0.2f", [self.payPrice floatValue]];
    }else {
        self.couponContentLabel.text = @"有可用优惠券";
        self.linePriceLabel.text = @"";
    }
    /*划线价frame*/
    NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:self.linePriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    self.linePriceLabel.attributedText = attstring;
    [self.linePriceLabel sizeToFit];
    self.linePriceLabel.frame = CGRectMake(CGRectGetMidX(self.priceLab.frame) - self.linePriceLabel.frame.size.width/2.0,
                                           CGRectGetMaxY(self.priceLab.frame) + 0*Proportion,
                                           self.linePriceLabel.frame.size.width,
                                           self.linePriceLabel.frame.size.height);
    
}

@end
