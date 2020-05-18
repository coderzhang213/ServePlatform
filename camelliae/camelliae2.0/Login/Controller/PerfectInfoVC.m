//
//  PerfectInfoVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "PerfectInfoVC.h"
#import "QNUploadManager.h"
#import "CMLRSAModule.h"
#import "VCManger.h"
#import "LoginUserObj.h"

#define PerfectInfoVCTopImageHeight            360
#define PerfectInfoVCUserHeadImageHeight       160
#define PerfectInfoVCOneLineLength             630
#define PerfectInfoVCLineSpace                 140
#define PerfectInfoVCFinshedBtnHeight          60

#define PerfectInfoVCTextfiedNameBttomMargin   20

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


@interface PerfectInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NetWorkProtocol>

@property (nonatomic,strong) UIImageView *userHeadImage;

@property (nonatomic,strong) UITextField *nickNameTextField;

@property (nonatomic,strong) UITextField *codeTextField;

@property (nonatomic,strong) UITextField *inviteCodeTextField;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIButton *finshedBtn;

@property (nonatomic,strong) UIButton *selectBoyBtn;

@property (nonatomic,strong) UIButton *selectGrilBtn;

/*******************************************/

@property (nonatomic,strong) UIImage *uploadImage;

@property (nonatomic,assign) int imageSize;

@property (nonatomic,strong) NSData *uploaderData;

@property (nonatomic,strong) NSData *uploaderData2;

@property (nonatomic,strong) NSData *uploaderData3;

@property (nonatomic,copy) NSString *qiniuKey;

@property (nonatomic,copy) NSString *qiniuBucket;

@property (nonatomic,strong) QNUploadManager *uploadManager;


@end

@implementation PerfectInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /********************/
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self loadViews];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    /**退出控制器时对定时器的处理*/
//    [self.timer invalidate];
//    self.timer = nil;
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification*) noti{
    
    NSDictionary *info = [noti userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.contentView.center = CGPointMake(self.contentView.center.x, self.view.center.y - keyboardSize.height/2.0);
    
}

- (void) keyboardWillBeHidden{
    
    self.contentView.center = self.view.center;
    
}

- (void) loadViews{

    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              WIDTH,
                                                                              PerfectInfoVCTopImageHeight*Proportion)];
    topImageView.backgroundColor = [UIColor CMLYellowColor];
    topImageView.clipsToBounds = YES;
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:topImageView];

    if ([[DataManager lightData] readLoginBannerImageUlr].length > 0 ) {
        
        [NetWorkTask setImageView:topImageView WithURL:[[DataManager lightData] readLoginBannerImageUlr] placeholderImage:nil];
        
    }else{
        
        topImageView.image = [UIImage imageNamed:LaunchBannerImg];
    }
     /**头像*/
    UIView *userHeadBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - ( PerfectInfoVCUserHeadImageHeight + 10*2)*Proportion/2.0,
                                                                     CGRectGetMaxY(topImageView.frame) - ( PerfectInfoVCUserHeadImageHeight + 10*2)*Proportion/2.0,
                                                                      (PerfectInfoVCUserHeadImageHeight + 10*2)*Proportion,
                                                                      (PerfectInfoVCUserHeadImageHeight + 10*2)*Proportion)];
    userHeadBgView.layer.cornerRadius = userHeadBgView.frame.size.width/2.0;
    userHeadBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:userHeadBgView];
    
    
    self.userHeadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LoginVCDefaultImg]];
    self.userHeadImage.frame = CGRectMake(WIDTH/2.0 - PerfectInfoVCUserHeadImageHeight*Proportion/2.0,
                                          CGRectGetMaxY(topImageView.frame) - PerfectInfoVCUserHeadImageHeight*Proportion/2.0,
                                          PerfectInfoVCUserHeadImageHeight*Proportion,
                                          PerfectInfoVCUserHeadImageHeight*Proportion);
    self.userHeadImage.layer.cornerRadius = self.userHeadImage.frame.size.width/2.0;
    self.userHeadImage.clipsToBounds = YES;
    self.userHeadImage.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.contentView addSubview:self.userHeadImage];
    
    UIButton *changeUserHeadImageBtn = [[UIButton alloc] init];
    changeUserHeadImageBtn.frame = CGRectMake(self.view.center.x - WIDTH*0.3/2.0,
                                              HEIGHT*0.15,
                                              WIDTH*0.3,
                                              WIDTH*0.3);
    changeUserHeadImageBtn.layer.cornerRadius = changeUserHeadImageBtn.frame.size.width/2.0;
    changeUserHeadImageBtn.backgroundColor = [UIColor clearColor];
    [changeUserHeadImageBtn addTarget:self action:@selector(changUserHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:changeUserHeadImageBtn];
    
    /**男*/
    self.selectBoyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 20*Proportion - 120*Proportion,
                                                                   CGRectGetMaxY(self.userHeadImage.frame) + 40*Proportion,
                                                                   120*Proportion,
                                                                   52*Proportion)];
    self.selectBoyBtn.layer.cornerRadius = 52*Proportion/2.0;
    self.selectBoyBtn.titleLabel.font = KSystemFontSize15;
    [self.selectBoyBtn setTitle:@"男" forState:UIControlStateNormal];
    [self.selectBoyBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.selectBoyBtn.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.selectBoyBtn];
    [self.selectBoyBtn addTarget:self action:@selector(selectBoy) forControlEvents:UIControlEventTouchUpInside];
    
    /**女*/
    self.selectGrilBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBoyBtn.frame) + 40*Proportion,
                                                                    CGRectGetMaxY(self.userHeadImage.frame) + 40*Proportion,
                                                                    120*Proportion,
                                                                    52*Proportion)];
    self.selectGrilBtn.layer.cornerRadius = 52*Proportion/2.0;
    self.selectGrilBtn.titleLabel.font = KSystemFontSize15;
    [self.selectGrilBtn setTitle:@"女" forState:UIControlStateNormal];
    [self.selectGrilBtn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    self.selectGrilBtn.backgroundColor = [UIColor CMLYellowColor];
    [self.contentView addSubview:self.selectGrilBtn];
    self.selectGrilBtn.selected = YES;
    [self.selectGrilBtn addTarget:self action:@selector(selectGril) forControlEvents:UIControlEventTouchUpInside];
    
    /**第一条线*/
    CMLLine *oneLine = [[CMLLine alloc] init];
    oneLine.startingPoint = CGPointMake(WIDTH/2.0 - PerfectInfoVCOneLineLength*Proportion/2.0,CGRectGetMaxY(self.selectBoyBtn.frame) +  PerfectInfoVCLineSpace*Proportion);
    oneLine.lineLength = PerfectInfoVCOneLineLength*Proportion;
    oneLine.lineWidth = 1;
    oneLine.LineColor = [UIColor CMLPromptGrayColor];
    oneLine.directionOfLine = HorizontalLine;
    [self.contentView addSubview:oneLine];
    
    UIImageView *nickNameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PerfectInfoNickNameImg]];
    nickNameImage.backgroundColor = [UIColor whiteColor];
    [nickNameImage sizeToFit];
    nickNameImage.frame = CGRectMake(oneLine.startingPoint.x,
                                     oneLine.startingPoint.y - nickNameImage.frame.size.height - PerfectInfoVCTextfiedNameBttomMargin*Proportion,
                                     nickNameImage.frame.size.width,
                                     nickNameImage.frame.size.height);
    [self.contentView addSubview:nickNameImage];
    
    
    /**昵称输入*/
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameImage.frame) + 30*Proportion,
                                                                           nickNameImage.frame.origin.y - PerfectInfoVCTextfiedNameBttomMargin*Proportion,
                                                                           oneLine.lineLength - 2*nickNameImage.frame.size.width,
                                                                           nickNameImage.frame.size.height + PerfectInfoVCTextfiedNameBttomMargin*Proportion*2)];
    self.nickNameTextField.placeholder = @"请输入昵称";
    self.nickNameTextField.font = KSystemFontSize14;
    [self.nickNameTextField addTarget:self action:@selector(inputNickName) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nickNameTextField];
    
    /**第二条*/
    CMLLine *twoLine = [[CMLLine alloc] init];
    twoLine.startingPoint = CGPointMake(WIDTH/2.0 - PerfectInfoVCOneLineLength*Proportion/2.0, PerfectInfoVCLineSpace*Proportion + oneLine.startingPoint.y);
    twoLine.lineLength = PerfectInfoVCOneLineLength*Proportion;
    twoLine.lineWidth = 1;
    twoLine.LineColor = [UIColor CMLPromptGrayColor];
    twoLine.directionOfLine = HorizontalLine;
    [self.contentView addSubview:twoLine];
    
    
    UIImageView *codeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MesCodeImg]];
    codeImage.backgroundColor = [UIColor whiteColor];
    [codeImage sizeToFit];
    codeImage.frame = CGRectMake(oneLine.startingPoint.x ,
                                   twoLine.startingPoint.y - codeImage.frame.size.height - PerfectInfoVCTextfiedNameBttomMargin*Proportion,
                                   codeImage.frame.size.width,
                                   codeImage.frame.size.height);
    [self.contentView addSubview:codeImage];
    
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeImage.frame) + 30*Proportion,
                                                                             codeImage.frame.origin.y - PerfectInfoVCTextfiedNameBttomMargin*Proportion ,
                                                                             oneLine.lineLength - 2*codeImage.frame.size.width,
                                                                             codeImage.frame.size.height + PerfectInfoVCTextfiedNameBttomMargin*Proportion*2)];
    self.codeTextField.placeholder = @"请输入密码(不能低于6位)";
    self.codeTextField.font = KSystemFontSize14;
    [self.contentView addSubview:self.codeTextField];
    
    /**第三条线*/
    CMLLine *threeLine = [[CMLLine alloc] init];
    threeLine.startingPoint = CGPointMake(WIDTH/2.0 - PerfectInfoVCOneLineLength*Proportion/2.0, PerfectInfoVCLineSpace*Proportion*2 + oneLine.startingPoint.y);
    threeLine.lineLength = PerfectInfoVCOneLineLength*Proportion;
    threeLine.lineWidth = 1;
    threeLine.LineColor = [UIColor CMLPromptGrayColor];
    threeLine.directionOfLine = HorizontalLine;
    [self.contentView addSubview:threeLine];
    
    
//    UIImageView *inviteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PerfectInfoInviteCodeImg]];
//    inviteImage.backgroundColor = [UIColor whiteColor];
//    [inviteImage sizeToFit];
//    inviteImage.frame = CGRectMake(oneLine.startingPoint.x ,
//                                   threeLine.startingPoint.y - inviteImage.frame.size.height - PerfectInfoVCTextfiedNameBttomMargin*Proportion,
//                                   inviteImage.frame.size.width,
//                                   inviteImage.frame.size.height);
//    [self.contentView addSubview:inviteImage];
//
//
//    self.inviteCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inviteImage.frame) + 30*Proportion,
//                                                                            inviteImage.frame.origin.y - PerfectInfoVCTextfiedNameBttomMargin*Proportion ,
//                                                                             oneLine.lineLength - 2*inviteImage.frame.size.width,
//                                                                           inviteImage.frame.size.height + PerfectInfoVCTextfiedNameBttomMargin*Proportion*2)];
//    self.inviteCodeTextField.placeholder = @"请输入邀请码(选填)";
//    self.inviteCodeTextField.font = KSystemFontSize14;
//    self.inviteCodeTextField.textColor = [UIColor CMLtextInputGrayColor];
//    [self.contentView addSubview:self.inviteCodeTextField];
    
    
    
    /**完成按键*/
    self.finshedBtn = [[UIButton alloc] init];
    self.finshedBtn.frame = CGRectMake(WIDTH/2.0 - PerfectInfoVCOneLineLength*Proportion/2.0,
                                  threeLine.startingPoint.y + 60*Proportion,
                                  PerfectInfoVCOneLineLength*Proportion,
                                  PerfectInfoVCFinshedBtnHeight*Proportion);
    self.finshedBtn.layer.cornerRadius = self.finshedBtn.frame.size.height/2.0;
    self.finshedBtn.backgroundColor = [UIColor CMLBlackColor];
    [self.finshedBtn setTitle:@"进入首页" forState:UIControlStateNormal];
    self.finshedBtn.titleLabel.font = KSystemFontSize15;
    [self.finshedBtn addTarget:self action:@selector(updateUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.finshedBtn];
    
    if (self.isNormalRegisterStyle) {
        self.codeTextField.hidden = YES;
        codeImage.hidden = YES;
        threeLine.hidden = YES;
//        inviteImage.frame = CGRectMake(oneLine.startingPoint.x ,
//                                       twoLine.startingPoint.y - inviteImage.frame.size.height - PerfectInfoVCTextfiedNameBttomMargin*Proportion,
//                                       inviteImage.frame.size.width,
//                                       inviteImage.frame.size.height);
//        self.inviteCodeTextField.frame = CGRectMake(CGRectGetMaxX(inviteImage.frame) + 30*Proportion,
//                                                    inviteImage.frame.origin.y - PerfectInfoVCTextfiedNameBttomMargin*Proportion ,
//                                                    oneLine.lineLength - 2*inviteImage.frame.size.width,
//                                                    inviteImage.frame.size.height + PerfectInfoVCTextfiedNameBttomMargin*Proportion*2);
        self.finshedBtn.frame = CGRectMake(WIDTH/2.0 - PerfectInfoVCOneLineLength*Proportion/2.0,
                                           twoLine.startingPoint.y + 60*Proportion,
                                           PerfectInfoVCOneLineLength*Proportion,
                                           PerfectInfoVCFinshedBtnHeight*Proportion);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.nickNameTextField resignFirstResponder];
    [self.inviteCodeTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

#pragma mark - changUserHeadImage
- (void) changUserHeadImage{

    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        
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
        
        self.userHeadImage.image = [UIImage CropImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(self.userHeadImage.image, 1.0);
        }else{
            data = UIImagePNGRepresentation(self.userHeadImage.image);
        }
        
        /**压缩并获取大小*/
        self.uploadImage = [UIImage scaleToSize:self.userHeadImage.image size:CGSizeMake(300, 300)];
        UIImage *image2 = [UIImage scaleToSize:self.userHeadImage.image size:CGSizeMake(200, 200)];
        UIImage *image3 = [UIImage scaleToSize:self.userHeadImage.image size:CGSizeMake(500, 500)];
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

#pragma mark - 用户图片的更新请求
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
    
}


#pragma mark -  用户信息的更新
- (void) setRenewUserInfo{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.nickNameTextField.text forKey:@"nickName"];
    if (self.inviteCodeTextField.text > 0) {
        [paraDic setObject:self.inviteCodeTextField.text forKey:@"invite_code"];
    }
    if (self.selectBoyBtn.selected) {
        
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    }else{
        
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
    }
    
    if (!self.isNormalRegisterStyle) {
        
        [paraDic setObject:[NSString getEncryptStringfrom:@[self.codeTextField.text]] forKey:@"password"];
    }
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:UpdateUser paraDic:paraDic delegate:delegate];
    self.currentApiName = UpdateUser;
    
    [self startIndicatorLoadingWithShadow];

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:UpGravatar]) {
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            self.qiniuKey = obj.retData.uploadKeyName;
            self.qiniuBucket = obj.retData.uploadBucket;
            
            NSString *token = [CMLRSAModule decryptString:obj.retData.upToken publicKey:PUBKEY];
            /**上传图片*/
            
            self.uploadManager = [[QNUploadManager alloc] init];
            
            [self.uploadManager putData:self.uploaderData key:self.qiniuKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                
            } option:nil];
            
        }else{
            [self showAlterViewWithText:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:UpdateUser] ){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self setAppStartingRequest];
        }else{
            
            [self stopIndicatorLoadingWithShadow];
            [self showAlterViewWithText:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:NewMemberUser]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0 && obj) {
            [self saveUserInfo:obj];
            /***???***/
        
            [[VCManger homeVC] viewDidLoad];
            [[VCManger mainVC] pushVC:[VCManger homeVC] animate:YES];
            
        }else{
            [self showAlterViewWithText:obj.retMsg];
        }
        
        [self stopIndicatorLoadingWithShadow];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopIndicatorLoadingWithShadow];
    [self showAlterViewWithText:@"您的网络不给力奥～"];

}

- (void) setAppStartingRequest{

    /**网络请求*/
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
    
}

#pragma mark - inputNickName
- (void) inputNickName{

    if (self.nickNameTextField.text.length > 0) {
        self.finshedBtn.userInteractionEnabled = YES;
    }else{
        self.finshedBtn.userInteractionEnabled = NO;
    }

}

#pragma mark - updateUserInfo
- (void) updateUserInfo{

    [self.nickNameTextField resignFirstResponder];
    [self.inviteCodeTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    if (self.nickNameTextField.text.length > 0 && self.nickNameTextField.text.length < 10) {
        
        if (self.isNormalRegisterStyle) {
            
            [self setRenewUserInfo];
        }else{
        
            if (self.codeTextField.text.length > 5) {
                
                [self setRenewUserInfo];
                
            }else{
                
                [self showFailTemporaryMes:@"请保证密码不少于6位数"];
            }
        }
        
    }else{
        [self showFailTemporaryMes:@"请输入昵称"];
    }
    
}

- (void) saveUserInfo:(BaseResultObj *)obj{
    
    [[DataManager lightData] saveUser:obj];
    
}

#pragma mark - selectBoy
- (void) selectBoy{

    if (!self.selectBoyBtn.selected) {
       
        self.selectBoyBtn.selected = YES;
        self.selectGrilBtn.selected = NO;
        self.selectBoyBtn.backgroundColor = [UIColor CMLYellowColor];
        self.selectGrilBtn.backgroundColor = [UIColor CMLUserGrayColor];
    }
}

#pragma mark - selectGril
- (void) selectGril{

    if (!self.selectGrilBtn.selected) {
        
        self.selectGrilBtn.selected = YES;
        self.selectBoyBtn.selected = NO;
        self.selectGrilBtn.backgroundColor = [UIColor CMLYellowColor];
        self.selectBoyBtn.backgroundColor = [UIColor CMLUserGrayColor];
    }
}
@end
