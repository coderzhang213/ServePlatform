//
//  NewPersonDetailInfoVC.m
//  camelliae2.0
//
//  Created by 张越 on 2016/11/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NewPersonDetailInfoVC.h"
#import "VCManger.h"
#import "LoginUserObj.h"
#import "CMLRSAModule.h"
#import "QNUploadManager.h"
#import "QiniuSDK.h"
#import "CMLUserAddressListVC.h"

#define NewPersonDetailInfoAttributeHeight      100
#define NewPersonDetailInfoAttributeLeftMargin  30
#define NewPersonDetailInfoUserImageHeight      60
#define NewPersonDetailInfoBgViewWidth          624
#define NewPersonDetailInfoBgViewHeight         270


#define PersonCenterDefaultInfoAlterLeftMargin          30
#define PersonCenterDefaultInfoAlterBottomMargin        20
#define PersonCenterDefaultInfoAlterLineAndLineMargin   100
#define PersonCenterDefaultInfoAlterTopMargin           40
#define PersonCenterDefaultInfoAlterBtnHeight           52
#define PersonCenterDefaultInfoAlterBtnWidth            160
#define PersonCenterDefaultInfoAlterBtnTopMargin        60
#define PersonCenterDefaultInfoAlterWidth               620
#define PersonCenterDefaultInfoAlterheight              412
#define PersonCenterDefaultInfoConfirmBtnHeight         100
#define PersonCenterDefaultInfoTextInputBtnHeight       104
#define PersonCenterDefaultInfoConsigneeAddressWidth    460
#define PersonCenterDefaultInfoMaximLeftAndRightMargin  40
#define PersonCenterDefaultInfoMaximTopMargin           50
#define PersonCenterDefaultInfoMaximHeight              150
#define PersonCenterDefaultInfoMaximBgViewHeight        360
#define PersonCenterDefaultInfoRealUserNameBgViewHeight 270


typedef NS_ENUM(NSInteger, NSPUIImageType){
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
};
static inline NSPUIImageType NSPUIImageTypeFromData(NSData *imageData){
    if (imageData.length > 4) {
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NSPUIImageType_JPEG;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return NSPUIImageType_PNG;
        }
    }
    
    return NSPUIImageType_Unknown;
}

@interface NewPersonDetailInfoVC ()<NavigationBarProtocol,NetWorkProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSArray *attributeArray;

@property (nonatomic,strong) NSMutableDictionary *attributeDic;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIView *firstSectionView;

@property (nonatomic,strong) UIView *secondSectionView;

@property (nonatomic,strong) UIView *thirdSectionView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isChangeBirthday;

/**头像*/

@property (nonatomic,strong) UIImageView *currentUserImage;

@property (nonatomic,strong) UIImage *currentImage;

@property (nonatomic,strong) UIImage *uploadImage;

@property (nonatomic,assign) int imageSize;

@property (nonatomic,strong) NSData *uploaderData;

@property (nonatomic,strong) NSData *uploaderData2;

@property (nonatomic,strong) NSData *uploaderData3;

@property (nonatomic,assign) BOOL isUploaderSuccess;

@property (nonatomic,copy) NSString *qiniuKey;

@property (nonatomic,copy) NSString *qiniuBucket;

@property (nonatomic,strong) QNUploadManager *uploadManager;

/**生日*/
@property (nonatomic,strong) NSMutableArray *yearArray;

@property (nonatomic,strong) NSMutableArray *monthArray;

@property (nonatomic,strong) NSMutableArray *dayArray;

@property (nonatomic,copy) NSString *year;

@property (nonatomic,copy) NSString *month;

@property (nonatomic,copy) NSString *day;

/**手机号*/
@property (nonatomic,strong) UISwitch *bindTeleSwitch;

@property (nonatomic,strong) UITextField *phoneNumField;

@property (nonatomic,strong) UIButton *getSmsCodeBtn;

@property (nonatomic,strong) UITextField *smsCodeField;

@property (nonatomic,strong) UITextField *codeField;

@property (nonatomic,strong) NSTimer *currentTimer;

@property (nonatomic,assign) int currentSeconds;

/**公共填写模块奥*/
@property (nonatomic,strong) UITextField *commenTextField;

/**个人信息*/
@property (nonatomic,strong) UITextView *signatureTextView;

@end

@implementation NewPersonDetailInfoVC

- (NSMutableDictionary *)attributeDic{

    if (!_attributeDic) {
        _attributeDic = [NSMutableDictionary dictionary];
    }
    return _attributeDic;
}
- (NSMutableArray *)yearArray{
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray{
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray{
    
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"PageTwoOfPersonalInfo"];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PageTwoOfPersonalInfo"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.titleContent = @"个人资料";
    self.navBar.titleColor = [UIColor CMLUserBlackColor];
    [self.navBar setLeftBarItem];
    self.isChangeBirthday = NO;

    [self loadMessageOfVC];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf.attributeDic removeAllObjects];
        [weakSelf.yearArray removeAllObjects];
        [weakSelf.monthArray removeAllObjects];
        [weakSelf.dayArray removeAllObjects];
        [weakSelf hideNetErrorTipOfNormalVC];
        [weakSelf loadMessageOfVC];
    
    };
}


- (void) loadMessageOfVC{

    [self loadData];
    
    [self loadViews];

}

- (void) loadData{

    self.attributeArray =  @[@"头像",
                             @"昵称",
                             @"性别",
                             @"生日",
                             @"绑定手机",
                             @"真实姓名"];
    
    for (int i = [[NSDate getCurrentYear] intValue]; i >= 1949  ; i--) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (int i = 1; i <= 12; i++) {
        if (i < 10) {
            
            [self.monthArray addObject:[NSString stringWithFormat:@"0%@",[NSNumber numberWithInt:i]]];
        }else{
            
            [self.monthArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    for (int i = 1; i <= 31; i++) {
        
        if (i < 10) {
            
            [self.dayArray addObject:[NSString stringWithFormat:@"0%@",[NSNumber numberWithInt:i]]];
        }else{
            
            [self.dayArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    self.currentSeconds = 60;
    [self getPersonalMesRequest];
}

- (void) loadViews{
    
    /**BG*/
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                         WIDTH,
                                                                         HEIGHT - self.navBar.frame.size.height - 20*Proportion)];
    self.mainScrollView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.mainScrollView];

    
    /***/
    self.firstSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH,
                                                                     self.attributeArray.count*NewPersonDetailInfoAttributeHeight*Proportion)];
    self.firstSectionView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.firstSectionView];
    
    self.secondSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.firstSectionView.frame) + 20*Proportion,
                                                                      WIDTH,
                                                                      NewPersonDetailInfoAttributeHeight*Proportion)];
    self.secondSectionView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.secondSectionView];
    
    self.thirdSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.secondSectionView.frame) + 20*Proportion,
                                                                     WIDTH,
                                                                     NewPersonDetailInfoAttributeHeight*Proportion)];
    self.thirdSectionView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.thirdSectionView];
    
    /**阴影*/
    self.shadowView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:0.5];
    self.shadowView.hidden = YES;
    [self.contentView addSubview:self.shadowView];
    [self.contentView bringSubviewToFront:self.shadowView];

    
}

- (void) reloadFirstSectionView{

    /**删除*/
    for (int i = 0; i < self.attributeArray.count; i++) {
        
        UIButton *btn = [self.firstSectionView viewWithTag:i+1];
        [btn removeFromSuperview];
    }
    
    /**添加*/
    for (int i = 0 ; i < self.attributeArray.count; i++) {
        
        /**enterBtn*/
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     NewPersonDetailInfoAttributeHeight*Proportion*i ,
                                                                     WIDTH,
                                                                     NewPersonDetailInfoAttributeHeight*Proportion)];
        bgBtn.backgroundColor = [UIColor clearColor];
        bgBtn.tag = i + 1;
        [self.firstSectionView addSubview:bgBtn];
        [bgBtn addTarget:self action:@selector(manageUserMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = KSystemFontSize12;
        label.textColor = [UIColor CMLtextInputGrayColor];
        label.text = self.attributeArray[i];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        label.frame = CGRectMake(NewPersonDetailInfoAttributeLeftMargin*Proportion,
                                 0,
                                 label.frame.size.width,
                                 bgBtn.frame.size.height);
        [bgBtn addSubview:label];
        
        /**commen*/
        if (i < self.attributeArray.count - 1) {
            
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = [UIColor CMLUserGrayColor];
            bottomLine.frame = CGRectMake(0,
                                          NewPersonDetailInfoAttributeHeight*Proportion,
                                          WIDTH,
                                          1);
            [bgBtn addSubview:bottomLine];
            
        }
        if (i != 4) {
            UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
            selectImage.userInteractionEnabled = YES;
            [selectImage sizeToFit];
            selectImage.frame = CGRectMake(WIDTH - selectImage.frame.size.width - NewPersonDetailInfoAttributeLeftMargin*Proportion,
                                           bgBtn.frame.size.height/2.0 - selectImage.frame.size.height/2.0,
                                           selectImage.frame.size.width,
                                           selectImage.frame.size.height);
            [bgBtn addSubview:selectImage];
            
            /**different*/
            
            if (i == 0) {
                self.currentUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(selectImage.frame.origin.x - NewPersonDetailInfoUserImageHeight*Proportion - 20*Proportion,
                                                                                       bgBtn.frame.size.height/2.0 - NewPersonDetailInfoUserImageHeight*Proportion/2.0,
                                                                                       NewPersonDetailInfoUserImageHeight*Proportion,
                                                                                       NewPersonDetailInfoUserImageHeight*Proportion)];
                self.currentUserImage.layer.cornerRadius = NewPersonDetailInfoUserImageHeight*Proportion/2.0;
                self.currentUserImage.clipsToBounds = YES;
                self.currentUserImage.backgroundColor = [UIColor CMLUserGrayColor];
                [bgBtn addSubview:self.currentUserImage];
                if (self.currentImage) {
                    self.currentUserImage.image = self.currentImage;
                }else{
                    [NetWorkTask setImageView:self.currentUserImage
                                      WithURL:[self.attributeDic valueForKey:self.attributeArray[i]]
                             placeholderImage:nil];
                }
            }else if (i == 1){
            
                UILabel *nickName = [[UILabel alloc] init];
                nickName.text = [self.attributeDic valueForKey:self.attributeArray[i]];
                nickName.textColor = [UIColor CMLUserBlackColor];
                nickName.font = KSystemFontSize14;
                [nickName sizeToFit];
                nickName.frame = CGRectMake(selectImage.frame.origin.x - 20*Proportion - nickName.frame.size.width,
                                            bgBtn.frame.size.height/2.0 - nickName.frame.size.height/2.0,
                                            nickName.frame.size.width,
                                            nickName.frame.size.height);
                [bgBtn addSubview:nickName];

            }else if (i == 2){
            
                UILabel *sexLabel = [[UILabel alloc] init];
                switch ([[self.attributeDic valueForKey:self.attributeArray[i]] intValue]) {
                    case 1:
                        sexLabel.text = @"男";
                        break;
                    case 2:
                        sexLabel.text = @"女";
                        break;
                    case 3:
                        sexLabel.text = @"保密";
                        break;
                        
                    default:
                        break;
                }
                sexLabel.textColor = [UIColor CMLUserBlackColor];
                sexLabel.font = KSystemFontSize14;
                [sexLabel sizeToFit];
                sexLabel.frame = CGRectMake(selectImage.frame.origin.x - 20*Proportion - sexLabel.frame.size.width,
                                            bgBtn.frame.size.height/2.0 - sexLabel.frame.size.height/2.0,
                                            sexLabel.frame.size.width,
                                            sexLabel.frame.size.height);
                [bgBtn addSubview:sexLabel];

            }else if (i == 3){
            
                UILabel *birthdayLabel = [[UILabel alloc] init];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy.MM.dd"];
                NSString *string=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[self.attributeDic valueForKey:self.attributeArray[i]] intValue]]];
                birthdayLabel.text = string;
                birthdayLabel.textColor = [UIColor CMLUserBlackColor];
                birthdayLabel.font = KSystemFontSize14;
                [birthdayLabel sizeToFit];
                birthdayLabel.frame = CGRectMake(selectImage.frame.origin.x - 20*Proportion - birthdayLabel.frame.size.width,
                                            bgBtn.frame.size.height/2.0 - birthdayLabel.frame.size.height/2.0,
                                            birthdayLabel.frame.size.width,
                                            birthdayLabel.frame.size.height);
                [bgBtn addSubview:birthdayLabel];
            }else if (i == 5){
                
                UILabel *realNameLabel = [[UILabel alloc] init];
                realNameLabel.textColor = [UIColor CMLUserBlackColor];
                realNameLabel.font = KSystemFontSize14;
                realNameLabel.text = [self.attributeDic valueForKey:self.attributeArray[i]];
                [realNameLabel sizeToFit];
                realNameLabel.frame = CGRectMake(selectImage.frame.origin.x - 20*Proportion - realNameLabel.frame.size.width,
                                                 bgBtn.frame.size.height/2.0 - realNameLabel.frame.size.height/2.0,
                                                 realNameLabel.frame.size.width,
                                                 realNameLabel.frame.size.height);
                [bgBtn addSubview: realNameLabel];

            }else if (i == 6){
              
                UILabel *inviteCOdeLabel = [[UILabel alloc] init];
                inviteCOdeLabel.textColor = [UIColor CMLUserBlackColor];
                inviteCOdeLabel.font = KSystemFontSize14;
                inviteCOdeLabel.text = [self.attributeDic valueForKey:self.attributeArray[i]];
                [inviteCOdeLabel sizeToFit];
                inviteCOdeLabel.frame = CGRectMake(selectImage.frame.origin.x - 20*Proportion - inviteCOdeLabel.frame.size.width,
                                                 bgBtn.frame.size.height/2.0 - inviteCOdeLabel.frame.size.height/2.0,
                                                 inviteCOdeLabel.frame.size.width,
                                                 inviteCOdeLabel.frame.size.height);
                [bgBtn addSubview: inviteCOdeLabel];

            }
            
        }else{
        
        
            /**uiswitch的大小为系统大小 长51 高31*/
            self.bindTeleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 51 - 30*Proportion,
                                                                             NewPersonDetailInfoAttributeHeight*Proportion/2.0 - 31/2.0,
                                                                             51,
                                                                             31)];
            self.bindTeleSwitch .onTintColor = [UIColor CMLYellowColor];
            
            if ([NSString stringWithFormat:@"%@",[self.attributeDic valueForKey:self.attributeArray[4]]].length == 11) {
                self.bindTeleSwitch.on = YES;
                self.bindTeleSwitch.userInteractionEnabled = NO;
                
                UILabel *teleLabel = [[UILabel alloc] init];
                teleLabel.textColor = [UIColor CMLUserBlackColor];
                teleLabel.font = KSystemFontSize14;
                teleLabel.text = [NSString stringWithFormat:@"%@",[self.attributeDic valueForKey:self.attributeArray[4]]];
                [teleLabel sizeToFit];
                teleLabel.frame = CGRectMake(self.bindTeleSwitch.frame.origin.x - 20*Proportion - teleLabel.frame.size.width, NewPersonDetailInfoAttributeHeight*Proportion/2.0 - teleLabel.frame.size.height/2.0,teleLabel.frame.size.width, teleLabel.frame.size.height);
                [bgBtn addSubview:teleLabel];
            }
            [self.bindTeleSwitch addTarget:self action:@selector(setBindInformation) forControlEvents:UIControlEventValueChanged];

            [bgBtn addSubview:self.bindTeleSwitch ];
        }
    }
}

- (void) reloadSecondSectionView{
    
    
        UIView *oldView = [self.secondSectionView viewWithTag:1];
        [oldView removeFromSuperview];
        /**添加*/
        UILabel *contetLabel = [[UILabel alloc] init];
        contetLabel.tag = 1;
        contetLabel.text = @"我的收货信息";
        contetLabel.backgroundColor = [UIColor clearColor];
        contetLabel.font = KSystemFontSize14;
        contetLabel.textColor = [UIColor CMLBlackColor];
        contetLabel.userInteractionEnabled = YES;
        [contetLabel sizeToFit];
        contetLabel.frame = CGRectMake(NewPersonDetailInfoAttributeLeftMargin*Proportion,
                                       0,
                                       contetLabel.frame.size.width,
                                       NewPersonDetailInfoAttributeHeight*Proportion);
        [self.secondSectionView addSubview:contetLabel];
        
        UIButton *deliveryBtn = [[UIButton alloc] initWithFrame:self.secondSectionView.bounds];
        [self.secondSectionView addSubview:deliveryBtn];
        [deliveryBtn addTarget:self action:@selector(setDeliveryMesView) forControlEvents:UIControlEventTouchUpInside];
}

- (void) reloadThirdSectionView{

    /**删除*/
    UILabel *oldLabel =  [self.thirdSectionView viewWithTag:1];
    [oldLabel removeFromSuperview];
    
    UIButton *oldBtn = [self.thirdSectionView viewWithTag:2];
    [oldBtn removeFromSuperview];
    
    UILabel *oldLabel2 =  [self.thirdSectionView viewWithTag:3];
    [oldLabel2 removeFromSuperview];
    /**添加*/
    UILabel *contetLabel = [[UILabel alloc] init];
    contetLabel.tag = 1;
    contetLabel.text = @"一句话描述";
    contetLabel.backgroundColor = [UIColor clearColor];
    contetLabel.userInteractionEnabled = YES;
    contetLabel.numberOfLines = 0;
    contetLabel.font = KSystemFontSize14;
    contetLabel.textColor = [UIColor CMLBlackColor];
    [contetLabel sizeToFit];
    contetLabel.frame = CGRectMake(NewPersonDetailInfoAttributeLeftMargin*Proportion,
                                   0,
                                   contetLabel.frame.size.width,
                                   NewPersonDetailInfoAttributeHeight*Proportion);
    [self.thirdSectionView addSubview:contetLabel];
    
    NSString *tempStr = [self.attributeDic valueForKey:@"一句话描述"];
    if (tempStr.length > 0) {
    
        UILabel *promLab = [[UILabel alloc] init];
        promLab.text = @"一句话描述";
        promLab.font = KSystemFontSize11;
        promLab.textColor = [UIColor CMLtextInputGrayColor];
        promLab.tag = 3;
        [promLab sizeToFit];
        promLab.frame = CGRectMake(NewPersonDetailInfoAttributeLeftMargin*Proportion, 10*Proportion, promLab.frame.size.width, promLab.frame.size.height);
        [self.thirdSectionView addSubview:promLab];
        
        contetLabel.text = [self.attributeDic valueForKey:@"一句话描述"];
        CGRect tempRect = [contetLabel.text boundingRectWithSize:CGSizeMake(WIDTH - NewPersonDetailInfoAttributeLeftMargin*Proportion*2, 1000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:KSystemFontSize14}
                                       context:nil];
        contetLabel.frame = CGRectMake(NewPersonDetailInfoAttributeLeftMargin*Proportion,
                                       NewPersonDetailInfoAttributeLeftMargin*Proportion + promLab.frame.size.height,
                                       WIDTH - NewPersonDetailInfoAttributeLeftMargin*Proportion*2,
                                       tempRect.size.height);
        if (tempRect.size.height + 2*Proportion*NewPersonDetailInfoAttributeLeftMargin + promLab.frame.size.height> NewPersonDetailInfoAttributeHeight*Proportion) {
            
            self.thirdSectionView.frame = CGRectMake(self.thirdSectionView.frame.origin.x,
                                                     CGRectGetMaxY(self.secondSectionView.frame) + 20*Proportion,
                                                     self.thirdSectionView.frame.size.width,
                                                     tempRect.size.height + 2*Proportion*NewPersonDetailInfoAttributeLeftMargin + promLab.frame.size.height);
        }else{
        
            self.thirdSectionView.frame =CGRectMake(0,
                                                    CGRectGetMaxY(self.secondSectionView.frame) + 20*Proportion,
                                                    WIDTH,
                                                    NewPersonDetailInfoAttributeHeight*Proportion);
        }
    }else{
    
        self.thirdSectionView.frame =CGRectMake(0,
                                                CGRectGetMaxY(self.secondSectionView.frame) + 20*Proportion,
                                                WIDTH,
                                                NewPersonDetailInfoAttributeHeight*Proportion);
    }
    
    
    UIButton *currentBtn = [[UIButton alloc] initWithFrame:self.thirdSectionView.bounds];
    currentBtn.tag = 2;
    [self.thirdSectionView addSubview:currentBtn];
    [currentBtn addTarget:self action:@selector(showsignatureView) forControlEvents:UIControlEventTouchUpInside];
    self.mainScrollView.contentSize = CGSizeMake(WIDTH,
                                                 CGRectGetMaxY(self.thirdSectionView.frame));
}

#pragma mark - manageUserMessage
- (void) manageUserMessage:(UIButton *) button{

    if (button.tag == 1) {
        
        [self changUserHeadImage];
        
    }else if (button.tag == 2){
    
//        NSString *tempNickName = [self.attributeDic valueForKey:self.attributeArray[(int)button.tag - 1]];
//        if (tempNickName.length > 0) {
//            
//            [self showFailTemporaryMes:@"不可修改"];
//        }else{
        
            [self setCommenInputViewWith:2];
//        }
    
    }else if (button.tag == 3){
    
        [self showSexChangeBoard];
    
    }else if (button.tag == 4){
    
        self.isChangeBirthday = YES;
        [self showBirthdayBoard];
    
    }else if (button.tag == 5){
    
    }else if (button.tag == 6){
    
        [self setCommenInputViewWith:6];
    }else{
    
        
        NSString *inviteCode = [self.attributeDic valueForKey:self.attributeArray[(int)button.tag - 1]];
        if (inviteCode.length > 1) {
           [self showFailTemporaryMes:@"不可修改"];
           
        }else{
           [self setCommenInputViewWith:7];
        }
    }
}

- (void) didSelectedLeftBarItem{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPoints" object:nil];
    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - 性别选择
- (void) showSexChangeBoard{

    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              NewPersonDetailInfoBgViewWidth*Proportion,
                                                              200*Proportion)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4*Proportion;
    bgView.center = self.shadowView.center;
    [self.shadowView addSubview:bgView];
    
    UIButton *manBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  bgView.frame.size.width,
                                                                  100*Proportion)];
    manBtn.titleLabel.font = KSystemFontSize15;
    [manBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateSelected];
    [manBtn setTitle:@"男" forState:UIControlStateNormal];
    manBtn.tag = 1;
    [bgView addSubview:manBtn];
    [manBtn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *womanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    100*Proportion,
                                                                    bgView.frame.size.width,
                                                                    100*Proportion)];
    womanBtn.titleLabel.font = KSystemFontSize15;
    [womanBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateSelected];
    [womanBtn setTitle:@"女" forState:UIControlStateNormal];
    womanBtn.tag = 2;
    [bgView addSubview:womanBtn];
    [womanBtn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                100*Proportion,
                                                                bgView.frame.size.width,
                                                                1*Proportion)];
    lineView.backgroundColor = [UIColor CMLLineGrayColor];
    [bgView addSubview:lineView];
    
    switch ([[self.attributeDic valueForKey:self.attributeArray[2]] intValue]) {
        case 1:
            manBtn.selected = YES;
            break;
        case 2:
            womanBtn.selected = YES;
            break;
            
        default:
            break;
    }

    
    self.shadowView.hidden = NO;
}

- (void) changeSex:(UIButton *) button{

    if (button.tag == 1) {
        if ([[self.attributeDic valueForKey:@"性别"] intValue] != 1) {
            
            [self.attributeDic setObject:[NSString stringWithFormat:@"1"] forKey:@"性别"];
            [self upDateUserMessage];
        }else{
        
            NSLog(@"不作处理");
        }
    }else{
        if ([[self.attributeDic valueForKey:@"性别"] intValue] != 2) {
            
            [self.attributeDic setObject:[NSString stringWithFormat:@"2"] forKey:@"性别"];
            [self upDateUserMessage];
        }else{
            NSLog(@"不作处理");
        }
    }
    self.shadowView.hidden = YES;

}
#pragma mark - 生日选择
- (void) showBirthdayBoard{
    
    /**clear*/
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *string=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[self.attributeDic valueForKey:self.attributeArray[3]] intValue]]];
    
    
    NSString *str = @"test";
    CGSize strSizez = [str sizeWithFontCompatible:KSystemFontSize15];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,
                                                                              0,
                                                                              NewPersonDetailInfoBgViewWidth*Proportion,
                                                                              240*Proportion + strSizez.height*3)];
    pickerView.layer.cornerRadius = 4*Proportion;
    pickerView.center = self.shadowView.center;
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    for (int i = 0; i < self.yearArray.count; i++) {
        
        if ([self.yearArray[i] isEqualToString:[string substringWithRange:NSMakeRange(0, 4)]]) {
            _year = [string substringWithRange:NSMakeRange(0, 4)];
            [pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.monthArray.count; i++) {
        
        if ([self.monthArray[i] isEqualToString:[string substringWithRange:NSMakeRange(5, 2)]]) {
            _month = [string substringWithRange:NSMakeRange(5, 2)];
            [pickerView selectRow:i inComponent:1 animated:NO];
            break;
        }
    }
    
    for (int i = 0; i < self.dayArray.count; i++) {
        
        if ([self.dayArray[i] isEqualToString:[string substringWithRange:NSMakeRange(8, 2)]]) {
            _day = [string substringWithRange:NSMakeRange(8, 2)];
            [pickerView selectRow:i inComponent:2 animated:NO];
            break;
        }
    }
    
    pickerView.backgroundColor = [UIColor whiteColor];
    
    
    self.shadowView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weakSelf.shadowView addSubview:pickerView];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - pickerView
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _yearArray.count;
    }else if(component == 1){
        return _monthArray.count;
    }else{
        return _dayArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return  [NSString stringWithFormat:@"%@",_yearArray[row]];
    }else if(component == 1){
        return  [NSString stringWithFormat:@"%@",_monthArray[row]];
    }else{
        return  [NSString stringWithFormat:@"%@",_dayArray[row]];
    }
    
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return NewPersonDetailInfoBgViewWidth*Proportion/3.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 60*Proportion;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:KSystemFontSize15];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        _year = [NSString stringWithFormat:@"%@",self.yearArray[row]];
        
    }else if (component == 1){
        _month = [NSString stringWithFormat:@"%@",self.monthArray[row]];
        
    }else{
        _day = [NSString stringWithFormat:@"%@",self.dayArray[row]];
    }
    
}

#pragma mark - 设置昵称
- (void) setCommenInputViewWith:(int) tag{
    
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - NewPersonDetailInfoBgViewWidth*Proportion/2.0,
                                                              CGRectGetMaxY(self.navBar.frame),
                                                              NewPersonDetailInfoBgViewWidth*Proportion,
                                                              NewPersonDetailInfoBgViewHeight*Proportion)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    [self.shadowView addSubview:bgView];
    
    CMLLine *line  = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(30*Proportion, 100*Proportion + 40*Proportion);
    line.lineLength = (NewPersonDetailInfoBgViewWidth - 2*30)*Proportion;
    line.lineWidth = 0.5;
    line.LineColor = [UIColor CMLtextInputGrayColor];
    line.directionOfLine = HorizontalLine;
    [bgView addSubview:line];
    
    UILabel *commenProLabel = [[UILabel alloc] init];
    if (tag == 2) {
        commenProLabel.text = @"昵称";
    }else if (tag == 6){
     commenProLabel.text = @"真实姓名";
    }
    
    commenProLabel.font = KSystemFontSize12;
    commenProLabel.textColor = [UIColor CMLtextInputGrayColor];
    [commenProLabel sizeToFit];
    commenProLabel.frame = CGRectMake(40*Proportion,
                                        line.startingPoint.y - 20*Proportion - commenProLabel.frame.size.height,
                                        commenProLabel.frame.size.width,
                                        commenProLabel.frame.size.height);
    [bgView addSubview:commenProLabel];
    
    self.commenTextField =[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commenProLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                         commenProLabel.frame.origin.y - PersonCenterDefaultInfoAlterBottomMargin*Proportion,
                                                                         (NewPersonDetailInfoBgViewWidth - PersonCenterDefaultInfoAlterLeftMargin)*Proportion - CGRectGetMaxX(commenProLabel.frame) - PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                         commenProLabel.frame.size.height + PersonCenterDefaultInfoAlterBottomMargin*Proportion*2)];
    if (tag == 2) {
        self.commenTextField.placeholder = @"请输入昵称";
    }else if (tag == 6){
        self.commenTextField.placeholder = @"请输入真实姓名";
        self.commenTextField.text = [self.attributeDic valueForKey:@"真实姓名"];
    }
    self.commenTextField.font = KSystemFontSize14;
    self.commenTextField.textColor = [UIColor CMLUserBlackColor];
    [bgView addSubview:self.commenTextField];
    [self.commenTextField becomeFirstResponder];
    
    /**确定*/
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(NewPersonDetailInfoBgViewWidth*Proportion/2.0 - PersonCenterDefaultInfoAlterBtnWidth*Proportion/2.0,
                                                                      line.startingPoint.y + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnWidth*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnHeight*Proportion)];
    confirmBtn.layer.cornerRadius = PersonCenterDefaultInfoAlterBtnHeight*Proportion/2.0;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    confirmBtn.tag = tag;
    [bgView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmUserMes:) forControlEvents:UIControlEventTouchUpInside];
    
    bgView.frame = CGRectMake(bgView.frame.origin.x,
                              bgView.frame.origin.y,
                              bgView.frame.size.width,
                              CGRectGetMaxY(confirmBtn.frame) + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion);
    
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.5 animations:^{
        weak.shadowView.hidden = NO;
    }];
    
}

- (void) confirmUserMes:(UIButton *)button{

    if (button.tag == 2) {
        
        if (self.commenTextField.text.length > 0) {
            
            [self.attributeDic setObject:self.commenTextField.text forKey:@"昵称"];
            [self upDateUserMessage];
            
        }else{
            [self showFailTemporaryMes:@"请输入昵称"];
        }
        
    }else if (button.tag == 6){
    
        if (self.commenTextField.text.length > 0) {
            
            [self.attributeDic setObject:self.commenTextField.text forKey:@"真实姓名"];
            [self upDateUserMessage];
            
        }else{
            [self showFailTemporaryMes:@"请输入真实姓名"];
        }

    }
}

#pragma mark - 设置收货信息填写
- (void) setDeliveryMesView{

    CMLUserAddressListVC *vc = [[CMLUserAddressListVC alloc] init];
    vc.currentTitle = @"我的收货信息";
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - 设置绑定信息
- (void) setBindInformation{
    
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - PersonCenterDefaultInfoAlterWidth*Proportion/2.0,
                                                           CGRectGetMaxY(self.navBar.frame),
                                                           PersonCenterDefaultInfoAlterWidth*Proportion,
                                                           PersonCenterDefaultInfoAlterheight*Proportion)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    [self.shadowView addSubview:bgView];
    
    /**手机号输入*/
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    phoneNumLabel.text = @"手机号";
    phoneNumLabel.font = KSystemFontSize12;
    phoneNumLabel.textColor = [UIColor CMLtextInputGrayColor];
    [phoneNumLabel sizeToFit];
    phoneNumLabel.frame = CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion*2,
                                     PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion + PersonCenterDefaultInfoAlterTopMargin*Proportion - PersonCenterDefaultInfoAlterBottomMargin*Proportion - phoneNumLabel.frame.size.height,
                                     phoneNumLabel.frame.size.width,
                                     phoneNumLabel.frame.size.height);
    [bgView addSubview:phoneNumLabel];
    
    self.phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneNumLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                       phoneNumLabel.frame.origin.y - PersonCenterDefaultInfoAlterBottomMargin*Proportion,
                                                                       bgView.frame.size.width - (CGRectGetMaxX(phoneNumLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion) - PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                       phoneNumLabel.frame.size.height + 2*PersonCenterDefaultInfoAlterBottomMargin*Proportion)];
    self.phoneNumField.placeholder = @"请输入手机号";
    self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumField.font = KSystemFontSize12;
    [self.phoneNumField becomeFirstResponder];
    [bgView addSubview:self.phoneNumField];
    
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                               PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion + PersonCenterDefaultInfoAlterTopMargin*Proportion,
                                                               bgView.frame.size.width - 2*PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                               0.5)];
    lineOne.backgroundColor = [UIColor CMLPromptGrayColor];
    [bgView addSubview:lineOne];
    
    /**验证码*/
    UILabel *smsCodeLabel = [[UILabel alloc] init];
    smsCodeLabel.text = @"验证码";
    smsCodeLabel.font = KSystemFontSize12;
    smsCodeLabel.textColor = [UIColor CMLtextInputGrayColor];
    [smsCodeLabel sizeToFit];
    smsCodeLabel.frame = CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion*2,
                                    PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion*2 + PersonCenterDefaultInfoAlterTopMargin*Proportion - PersonCenterDefaultInfoAlterBottomMargin*Proportion - smsCodeLabel.frame.size.height,
                                    smsCodeLabel.frame.size.width,
                                    smsCodeLabel.frame.size.height);
    [bgView addSubview:smsCodeLabel];
    
    /**获取验证码*/
    self.getSmsCodeBtn = [[UIButton alloc] init];
    NSString *str = @"发送验证码";
    CGSize btnSize = [str sizeWithFontCompatible:KSystemFontSize12];
    [self.getSmsCodeBtn setTitle:str forState:UIControlStateNormal];
    [self.getSmsCodeBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.getSmsCodeBtn.titleLabel.font = KSystemFontSize12;
    self.getSmsCodeBtn.frame = CGRectMake(bgView.frame.size.width - 2*Proportion*PersonCenterDefaultInfoAlterLeftMargin - btnSize.width,
                                          smsCodeLabel.frame.origin.y - PersonCenterDefaultInfoAlterBottomMargin*Proportion,
                                          btnSize.width,
                                          btnSize.height + 2*Proportion*PersonCenterDefaultInfoAlterBottomMargin);
    [self.getSmsCodeBtn addTarget:self action:@selector(newPostGetSmsCode) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.getSmsCodeBtn];
    
    /**竖线*/
    CMLLine *specialLine = [[CMLLine alloc] init];
    specialLine.lineWidth = 1;
    specialLine.lineLength = btnSize.height;
    specialLine.LineColor = [UIColor CMLtextInputGrayColor];
    specialLine.startingPoint =CGPointMake( bgView.frame.size.width - 3*PersonCenterDefaultInfoAlterLeftMargin*Proportion - btnSize.width - 1, smsCodeLabel.frame.origin.y);
    specialLine.directionOfLine = VerticalLine;
    [bgView addSubview:specialLine];
    
    self.smsCodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsCodeLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                      smsCodeLabel.frame.origin.y - PersonCenterDefaultInfoAlterBottomMargin*Proportion,
                                                                      bgView.frame.size.width - (CGRectGetMaxX(smsCodeLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion*4) - btnSize.width - 1,
                                                                      smsCodeLabel.frame.size.height + 2*PersonCenterDefaultInfoAlterBottomMargin*Proportion)];
    self.smsCodeField.placeholder = @"请输入验证码";
    self.smsCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.smsCodeField.font = KSystemFontSize12;
    [bgView addSubview:self.smsCodeField];
    
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                               PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion*2 + PersonCenterDefaultInfoAlterTopMargin*Proportion,
                                                               bgView.frame.size.width - 2*PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                               0.5)];
    lineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
    [bgView addSubview:lineTwo];
    
    UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                 lineTwo.frame.origin.y + PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion,
                                                                 bgView.frame.size.width - 2*PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                 0.5)];
    lineThree.backgroundColor = [UIColor CMLPromptGrayColor];
    [bgView addSubview:lineThree];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"密 码";
    codeLabel.textColor = [UIColor CMLtextInputGrayColor];
    codeLabel.font = KSystemFontSize12;
    [codeLabel sizeToFit];
    codeLabel.frame = CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion*2,
                                 PersonCenterDefaultInfoAlterLineAndLineMargin*Proportion*3 + PersonCenterDefaultInfoAlterTopMargin*Proportion - PersonCenterDefaultInfoAlterBottomMargin*Proportion - codeLabel.frame.size.height,
                                 codeLabel.frame.size.width,
                                 codeLabel.frame.size.height);
    [bgView addSubview:codeLabel];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsCodeLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                   codeLabel.frame.origin.y - PersonCenterDefaultInfoAlterBottomMargin*Proportion,
                                                                   bgView.frame.size.width - (CGRectGetMaxX(codeLabel.frame) + PersonCenterDefaultInfoAlterLeftMargin*Proportion) - PersonCenterDefaultInfoAlterLeftMargin*Proportion,
                                                                   codeLabel.frame.size.height + 2*PersonCenterDefaultInfoAlterBottomMargin*Proportion)];
    self.codeField.secureTextEntry = YES;
    self.codeField.textColor = [UIColor CMLtextInputGrayColor];
    self.codeField.placeholder = @"请输入绑定密码";
    self.codeField.font = KSystemFontSize12;
    [bgView addSubview:self.codeField];
    
    /**确定*/
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((PersonCenterDefaultInfoAlterWidth - PersonCenterDefaultInfoAlterBtnWidth)*Proportion/2.0,
                                                                      lineThree.frame.origin.y + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnWidth*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnHeight*Proportion)];
    confirmBtn.layer.cornerRadius = PersonCenterDefaultInfoAlterBtnHeight*Proportion/2.0;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    [confirmBtn addTarget:self action:@selector(confirmNewBindPhone) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    
    bgView.frame = CGRectMake(bgView.frame.origin.x,
                              bgView.frame.origin.y,
                              bgView.frame.size.width,
                              CGRectGetMaxY(confirmBtn.frame) + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion);
    
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.5 animations:^{
        weak.shadowView.hidden = NO;
    }];
    
}

- (void) confirmNewBindPhone{

    if (self.smsCodeField.text.length > 0) {
        
        if (self.codeField.text.length > 5) {
            
            [self setNewBindPhoneRequest];
            [self.phoneNumField resignFirstResponder];
            [self.smsCodeField resignFirstResponder];
            [self.codeField resignFirstResponder];
            self.shadowView.hidden = YES;
        }else{
        
            [self showFailTemporaryMes:@"密码不能低于6位数"];
        }
        
    }else{
        [self showFailTemporaryMes:@"请输入验证码"];
    }

}

#pragma mark - 设置个性签名
- (void) showsignatureView{
    
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
    
    
    self.signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion*2,
                                                                        PersonCenterDefaultInfoAlterTopMargin*Proportion,
                                                                        (620 - 4*PersonCenterDefaultInfoAlterLeftMargin)*Proportion,
                                                                        360*Proportion)];
    self.signatureTextView.text = [self.attributeDic valueForKey:@"一句话描述"];;
    self.signatureTextView.textColor = [UIColor CMLtextInputGrayColor];
    self.signatureTextView.tag = 1;
    self.signatureTextView.font = KSystemFontSize14;
    self.signatureTextView.delegate = self;
    [bgView addSubview:self.signatureTextView];
    [self.signatureTextView becomeFirstResponder];
    
    CMLLine *line  = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(PersonCenterDefaultInfoAlterLeftMargin*Proportion, CGRectGetMaxY(self.signatureTextView.frame));
    line.lineLength = (620 - 2*PersonCenterDefaultInfoAlterLeftMargin)*Proportion;
    line.lineWidth = 0.5;
    line.LineColor = [UIColor CMLtextInputGrayColor];
    line.directionOfLine = HorizontalLine;
    [bgView addSubview:line];
    
    /**确定*/
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(620*Proportion/2.0 - PersonCenterDefaultInfoAlterBtnWidth*Proportion/2.0,
                                                                      line.startingPoint.y + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnWidth*Proportion,
                                                                      PersonCenterDefaultInfoAlterBtnHeight*Proportion)];
    confirmBtn.layer.cornerRadius = PersonCenterDefaultInfoAlterBtnHeight*Proportion/2.0;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmSignature) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    [bgView addSubview:confirmBtn];
    
    bgView.frame = CGRectMake(bgView.frame.origin.x,
                              bgView.frame.origin.y,
                              bgView.frame.size.width,
                             CGRectGetMaxY(confirmBtn.frame) + PersonCenterDefaultInfoAlterBtnTopMargin*Proportion);
    
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.5 animations:^{
        weak.shadowView.hidden = NO;
    }];
}


#pragma mark - confirmSignature
- (void) confirmSignature{

    if (self.signatureTextView.text.length > 0 ) {
        
        if (self.signatureTextView.text.length > 18) {
            
            [self showFailTemporaryMes:@"一句话描述不能超过18个字"];
        }else{
         
            [self.attributeDic setObject:self.signatureTextView.text forKey:@"一句话描述"];
            [self upDateUserMessage];
        }
    }else{
    
        [self showFailTemporaryMes:@"请输入一句话描述"];
    }
}

#pragma mark - 整体信息
- (void) getPersonalMesRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSNumber *userId = [[DataManager lightData] readUserID];
    [paraDic setObject:userId forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[userId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:NewMemberUser paraDic:paraDic delegate:delegate];
    self.currentApiName = NewMemberUser;
    
    [self startLoading];
    
}

#pragma mark - 头像更新
- (void) sendImageWithType:(NSString*) type{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[NSNumber numberWithInt:300] forKey:@"imgWidth"];
    [paraDic setObject:[NSNumber numberWithInt:300] forKey:@"imgHeight"];
    [paraDic setObject:type forKey:@"imgType"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:self.imageSize] forKey:@"fileSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,type,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:UpGravatar paraDic:paraDic delegate:delegate];
    self.currentApiName = UpGravatar;
    [self startIndicatorLoading];
    
}

#pragma mark - bindPhone
- (void) setNewCheckBindPhoneNumRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.phoneNumField.text forKey:@"mobile"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,self.phoneNumField.text,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:CheckBindPhone paraDic:paraDic delegate:delegate];
    self.currentApiName = CheckBindPhone;
    [self startIndicatorLoading];
}

#pragma mark - 个人信息的更新
- (void) upDateUserMessage{

        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];

        [paraDic setObject:[self.attributeDic valueForKey:@"真实姓名"] forKey:@"userRealName"];
        [paraDic setObject:[self.attributeDic valueForKey:@"昵称"] forKey:@"nickName"];
        [paraDic setObject:[NSNumber numberWithInt:[[self.attributeDic valueForKey:@"生日"] intValue]]  forKey:@"birthday"];
        [paraDic setObject:[self.attributeDic valueForKey:@"一句话描述"] forKey:@"signature"];
        [paraDic setObject:[NSNumber numberWithInt:[[self.attributeDic valueForKey:@"性别"] intValue]] forKey:@"gender"];
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        [NetWorkTask postResquestWithApiName:UpdateUser paraDic:paraDic delegate:delegate];
        self.currentApiName = UpdateUser;
        [self startIndicatorLoading];
        self.shadowView.hidden = YES;
        [self.commenTextField resignFirstResponder];
        [self.signatureTextView resignFirstResponder];
    

}

#pragma mark - setBindPhoneRequest
- (void) setNewBindPhoneRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.phoneNumField.text forKey:@"mobile"];
    [paraDic setObject:self.smsCodeField.text forKey:@"smsCode"];
    [paraDic setObject:[NSString getEncryptStringfrom:@[self.codeField.text]] forKey:@"passwd"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,
                                                           self.phoneNumField.text,
                                                           self.smsCodeField.text,
                                                           self.codeField.text,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:BindPhone paraDic:paraDic delegate:delegate];
    self.currentApiName = BindPhone;
    
    [self startIndicatorLoading];
    
}

- (void) newPostGetSmsCode{

    
    if ([self.phoneNumField.text valiMobile]) {
        
        [self setNewCheckBindPhoneNumRequest];
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshSeconds) userInfo:nil repeats:YES];
        
    }else{
    
        [self showFailTemporaryMes:@"请输入正确手机号"];
    }
   
}

#pragma mark - refreshSeconds
- (void) refreshSeconds{

    if (self.currentSeconds == 0) {
        
        [self initTimer];
       
    }else{
    
        self.currentSeconds -- ;
        [self.getSmsCodeBtn setTitle:[NSString stringWithFormat:@"%d s",self.currentSeconds] forState:UIControlStateNormal];
        self.getSmsCodeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:NewMemberUser]) {
        
        BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([resObj.retCode intValue] == 0 && resObj) {
            
            [self saveCurrentUserInfo:resObj];
            
            [self reloadFirstSectionView];
            
            [self reloadSecondSectionView];
            
            [self reloadThirdSectionView];
            
        }else if ([resObj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:UpGravatar]) {
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.qiniuKey = obj.retData.uploadKeyName;
            self.qiniuBucket = obj.retData.uploadBucket;
            
            NSString *token = [CMLRSAModule decryptString:obj.retData.upToken publicKey:PUBKEY];
            /**上传图片*/
            
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                
                builder.zone = [QNFixedZone zone0];
            }];

            self.uploadManager = [[QNUploadManager alloc] initWithConfiguration:config];
            
            __weak typeof(self) weakSelf = self;
            
            [self.uploadManager putData:self.uploaderData key:self.qiniuKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                weakSelf.isUploaderSuccess = YES;
                [weakSelf stopIndicatorLoading];
                [weakSelf reloadFirstSectionView];
                [weakSelf.delegate refrshPersonalCenter];
                
            } option:nil];
            
            [self ChangePointsRequest];

            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            self.isUploaderSuccess = NO;
            
            [self showFailTemporaryMes:@"头像修改失败"];
        }
    }else if ([self.currentApiName isEqualToString:UpdateUser]){
    
     
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
    
            //昵称刷新
            if ([self.commenTextField.placeholder isEqualToString:@"请输入昵称"]) {
                [self.delegate refrshPersonalCenter];
            }
            
            [self showSuccessTemporaryMes:@"更新成功"];
            [self reloadFirstSectionView];
            
            [self reloadThirdSectionView];
            
            if (![[[DataManager lightData] readSignature] isEqualToString:[self.attributeDic valueForKey:@"一句话描述"]]) {
                [self.delegate refrshPersonalCenter];
            }
    
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:@"信息更新失败"];
        }
        [self stopIndicatorLoading];
    }else if ([self.currentApiName isEqualToString:CheckBindPhone]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 200103 && obj) {
            
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:self.phoneNumField.text forKey:@"mobile"];
            NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
            [paraDic setObject:reqTime forKey:@"reqTime"];
            [paraDic setObject:[NSNumber numberWithInt:10001] forKey:@"reqType"];
            [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
            NSString *hashToken = [NSString getEncryptStringfrom:@[self.phoneNumField.text,[NSNumber numberWithInt:10001],[[DataManager lightData] readSkey]]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
            [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
            self.currentApiName = MessageVerify;
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self initTimer];
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }else{
            [self stopIndicatorLoading];
            [self initTimer];
            [self showFailTemporaryMes:@"该手机号已绑定"];
        }
    }else if ([self.currentApiName isEqualToString:MessageVerify]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self showSuccessTemporaryMes:@"验证码已发送"];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self stopIndicatorLoading];
    }else if([self.currentApiName isEqualToString:BindPhone]){
        
        [self stopIndicatorLoading];
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            [self showSuccessTemporaryMes:@"绑定成功"];
            [self.attributeDic setObject:self.phoneNumField.text forKey:@"绑定手机"];
            [[DataManager lightData] savePhone:self.phoneNumField.text];
            [self reloadFirstSectionView];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }else{
            self.bindTeleSwitch.on = NO;
            [self showFailTemporaryMes:obj.retMsg];
        }
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self initTimer];
    [self stopLoading];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfNormalVC];

}

#pragma mark - 数据存储
- (void) saveCurrentUserInfo:(BaseResultObj *)obj{
    
    /**本地存储*/
    [[DataManager lightData] saveUser:obj];
    LoginUserObj *userInfo = obj.retData.user;    
    
    /**当前数据使用*/
    [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.gravatar] forKey:@"头像"];
    if (userInfo.nickName) {
     
        [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.nickName] forKey:@"昵称"];
        
    }else{
    
        [self.attributeDic setObject:@"" forKey:@"昵称"];
    }
    [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.gender] forKey:@"性别"];
    [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.birthday] forKey:@"生日"];
    [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.mobile] forKey:@"绑定手机"];
    if (userInfo.userRealName) {
        
       [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.userRealName] forKey:@"真实姓名"];
        
    }else{
        
       [self.attributeDic setObject:@"" forKey:@"真实姓名"];
        
    }


    NSMutableDictionary *deliveryDic = [NSMutableDictionary dictionary];
    if (userInfo.deliveryAddress) {
       [deliveryDic setObject:[NSString stringWithFormat:@"%@",userInfo.deliveryAddress] forKey:@"收货地址"];
    }else{
       [deliveryDic setObject:@"" forKey:@"收货地址"];
    }
    if (userInfo.deliveryMobile) {
      [deliveryDic setObject:[NSString stringWithFormat:@"%@",userInfo.deliveryMobile] forKey:@"收货电话"];
    }else{
      [deliveryDic setObject:@"" forKey:@"收货电话"];
    }
    if (userInfo.deliveryConsignee) {
        [deliveryDic setObject:[NSString stringWithFormat:@"%@",userInfo.deliveryConsignee] forKey:@"收货人"];
    }else{
        [deliveryDic setObject:@"" forKey:@"收货人"];
    }

    [self.attributeDic setObject:deliveryDic forKey:@"收货信息"];
    if (userInfo.signature) {
        [self.attributeDic setObject:[NSString stringWithFormat:@"%@",userInfo.signature] forKey:@"一句话描述"];
    }else{
        [self.attributeDic setObject:@"" forKey:@"一句话描述"];
    }
}

#pragma mark - 修改头像
- (void) changUserHeadImage{
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        //        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        self.currentImage = [UIImage CropImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(self.currentImage, 1.0);
        }else{
            data = UIImagePNGRepresentation(self.currentImage);
        }
        
        /**压缩并获取大小*/
        self.uploadImage = [UIImage scaleToSize:self.currentImage size:CGSizeMake(300, 300)];
        UIImage *image2 = [UIImage scaleToSize:self.currentImage size:CGSizeMake(200, 200)];
        UIImage *image3 = [UIImage scaleToSize:self.currentImage size:CGSizeMake(500, 500)];
        NSData *compressImageData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
        self.imageSize = (int)compressImageData.length;
        
        NSPUIImageType imageType = NSPUIImageTypeFromData(data);
        
        
        if (imageType == NSPUIImageType_JPEG) {
            
            self.uploaderData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
            self.uploaderData2 = UIImageJPEGRepresentation(image2, 1.0);
            self.uploaderData3 = UIImageJPEGRepresentation(image3, 1.0);
            NSLog(@"该图片格式为jpeg");
            [self sendImageWithType:@"jpg"];
        }else{
            NSLog(@"该图片格式为png");
            
            self.uploaderData = UIImagePNGRepresentation(self.uploadImage);
            self.uploaderData2 = UIImagePNGRepresentation(image2);
            self.uploaderData3 = UIImagePNGRepresentation(image3);
            [self sendImageWithType:@"png"];
            
        }
        //关闭相册界面
        
        [picker dismissViewControllerAnimated:YES completion:^{

        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self initTimer];
    self.shadowView.hidden = YES;
    [self.commenTextField resignFirstResponder];
    [self.signatureTextView resignFirstResponder];
    [self.phoneNumField resignFirstResponder];
    [self.smsCodeField resignFirstResponder];
    [self.codeField resignFirstResponder];
    
    if (self.bindTeleSwitch.userInteractionEnabled) {
        
        self.bindTeleSwitch.on = NO;
    }
    
    if (self.isChangeBirthday) {
        self.isChangeBirthday = NO;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *string=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[self.attributeDic valueForKey:self.attributeArray[3]] intValue]]];
         NSString *oldYear = [string substringWithRange:NSMakeRange(0, 4)];
         NSString *oldMonth = [string substringWithRange:NSMakeRange(5, 2)];
         NSString *oldDay = [string substringWithRange:NSMakeRange(8, 2)];

        if ([oldYear isEqualToString:_year] && [oldMonth isEqualToString:_month] && [oldDay isEqualToString:_day]) {
        
            NSLog(@"不做处理");
        }else{
        
            NSDate *tempDate = [formatter dateFromString:[NSString stringWithFormat:@"%@.%@.%@",_year,_month,_day]];
            [self.attributeDic  setObject:[NSString stringWithFormat:@"%ld",(long)[tempDate timeIntervalSince1970]] forKey:@"生日"];
            [self upDateUserMessage];
        }
    }
}

#pragma mark -  初始化timer
- (void) initTimer{
    
    [self.currentTimer invalidate];
    self.currentTimer = nil;
    self.currentSeconds = 60;
    [self.getSmsCodeBtn setTitle:@"发送验证码"forState:UIControlStateNormal];
    self.getSmsCodeBtn.userInteractionEnabled = YES;
}

- (void) ChangePointsRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ChangePointOfImage paraDic:paraDic delegate:delegate];
    self.currentApiName = ChangePointOfImage;
    
}
@end

