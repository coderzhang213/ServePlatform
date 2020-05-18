//
//  NewCardView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "NewCardView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "LoginUserObj.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "NewCardEditVC.h"

#define BgViewWidth       690
#define LeftMargin        40
#define TopMargin         50
#define UserBgViewHeight  120
#define UserImageHeight   108

@interface NewCardView ()<NetWorkProtocol>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIView *view2;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation NewCardView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                HEIGHT);
        self.backgroundColor = [[UIColor CMLBlackColor]colorWithAlphaComponent:0.5];
        
        
    }
    
    return self;
}

- (void) loadViews{

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - BgViewWidth*Proportion/2.0,
                                                           0,
                                                           BgViewWidth*Proportion,
                                                           HEIGHT)];
    self.bgView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.bgView];
    
    
    [self loadDetailMessage];
    
    
}

- (void) setCardView{

    [self getNameCardMessageRequest];;
}

- (void) loadDetailMessage{

    UIView *userImageBgView = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin*Proportion,
                                                                       TopMargin*Proportion,
                                                                       UserBgViewHeight*Proportion,
                                                                       UserBgViewHeight*Proportion)];
    userImageBgView.layer.cornerRadius = UserBgViewHeight*Proportion/2.0;
    userImageBgView.clipsToBounds = YES;
    userImageBgView.layer.borderWidth = 1;
    
    switch ([self.memeberLvl intValue]) {
        case 1:
            userImageBgView.layer.borderColor = [UIColor CMLPinkColor].CGColor;
            break;
        case 2:
            userImageBgView.layer.borderColor = [UIColor CMLBlackPigmentColor].CGColor;
            break;
        case 3:
            userImageBgView.layer.borderColor = [UIColor CMLGoldColor].CGColor;
            break;
        case 4:
            userImageBgView.layer.borderColor = [UIColor CMLGrayColor].CGColor;
            break;
            
        default:
            break;
    }
    
    [self.bgView addSubview:userImageBgView];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(UserBgViewHeight*Proportion/2.0 - UserImageHeight*Proportion/2.0,
                                                                           UserBgViewHeight*Proportion/2.0 - UserImageHeight*Proportion/2.0,
                                                                           UserImageHeight*Proportion,
                                                                           UserImageHeight*Proportion)];
    userImage.layer.cornerRadius = UserImageHeight*Proportion/2.0;
    userImage.clipsToBounds = YES;

    [userImageBgView addSubview:userImage];
    
    [NetWorkTask setImageView:userImage WithURL:self.userImageUrl placeholderImage:nil];
    
    UILabel *userLab = [[UILabel alloc] init];
    userLab.font = KSystemFontSize15;
    userLab.text = self.nickName;
    [userLab sizeToFit];
    userLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                               userImageBgView.center.y - userLab.frame.size.height/2.0,
                               userLab.frame.size.width,
                               userLab.frame.size.height);
    [self.bgView addSubview:userLab];
    
    UIImageView *lvlImage = [[UIImageView alloc] init];
    switch ([self.memeberLvl intValue]) {
        case 1:
            lvlImage.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
        case 2:
            lvlImage.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
        case 3:
            lvlImage.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
        case 4:
            lvlImage.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    [lvlImage sizeToFit];
    lvlImage.frame = CGRectMake(CGRectGetMaxX(userLab.frame) + 10*Proportion,
                                userLab.center.y - lvlImage.frame.size.height/2.0,
                                lvlImage.frame.size.width,
                                lvlImage.frame.size.height);
    [self.bgView addSubview:lvlImage];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                                                 CGRectGetMaxY(userImageBgView.frame) + 10*Proportion,
                                                                 470*Proportion,
                                                                 1)];
    spaceLine.backgroundColor = [UIColor CMLPromptGrayColor];
    [self.bgView addSubview:spaceLine];
    
    
    UILabel *positionPromLab = [[UILabel alloc] init];
    positionPromLab.text = @"头衔";
    positionPromLab.textColor = [UIColor CMLtextInputGrayColor];
    positionPromLab.font = KSystemFontSize13;
    [positionPromLab sizeToFit];
    positionPromLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                       CGRectGetMaxY(userImageBgView.frame) + 10*Proportion+ 30*Proportion,
                                       positionPromLab.frame.size.width,
                                       positionPromLab.frame.size.height);
    [self.bgView addSubview:positionPromLab];
    
    UILabel *positionLab = [[UILabel alloc] init];
    positionLab.text = self.obj.retData.title;
    positionLab.textColor = [UIColor CMLBlackColor];
    positionLab.font = KSystemFontSize14;
    [positionLab sizeToFit];
    positionLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(positionPromLab.frame) + 15*Proportion,
                                   positionLab.frame.size.width,
                                   positionLab.frame.size.height);
    [self.bgView addSubview:positionLab];
    
    if (self.obj.retData.title.length == 0) {
        
        positionLab.text = @"暂未填写";
        [positionLab sizeToFit];
        positionLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                       CGRectGetMaxY(positionPromLab.frame) + 15*Proportion,
                                       positionLab.frame.size.width,
                                       positionLab.frame.size.height);
        positionLab.textColor = [UIColor clearColor];
    }

    UILabel *commpanyPromLab = [[UILabel alloc] init];
    commpanyPromLab.text = @"公司";
    commpanyPromLab.textColor = [UIColor CMLtextInputGrayColor];
    commpanyPromLab.font = KSystemFontSize13;
    [commpanyPromLab sizeToFit];
    commpanyPromLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                       CGRectGetMaxY(positionLab.frame) + 30*Proportion,
                                       commpanyPromLab.frame.size.width,
                                       commpanyPromLab.frame.size.height);
    [self.bgView addSubview:commpanyPromLab];
    
    UILabel *commpanyLab = [[UILabel alloc] init];
    commpanyLab.text = self.obj.retData.companyName;
    commpanyLab.textColor = [UIColor CMLBlackColor];
    commpanyLab.textAlignment = NSTextAlignmentLeft;
    commpanyLab.numberOfLines = 0;
    commpanyLab.font = KSystemFontSize14;
    CGRect commpanyCurrentrect =  [commpanyLab.text boundingRectWithSize:CGSizeMake(470*Proportion, HEIGHT)
                                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                                          attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                                             context:nil];
    commpanyLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(commpanyPromLab.frame) + 15*Proportion,
                                   470*Proportion,
                                   commpanyCurrentrect.size.height);
    [self.bgView addSubview:commpanyLab];
    
    if (self.obj.retData.companyName.length == 0) {
        
        commpanyLab.text = @"暂未填写";
        [commpanyLab sizeToFit];
        commpanyLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                       CGRectGetMaxY(commpanyPromLab.frame) + 15*Proportion,
                                       commpanyLab.frame.size.width,
                                       commpanyLab.frame.size.height);
        commpanyLab.textColor = [UIColor clearColor];
    }

    UILabel *telePromLab = [[UILabel alloc] init];
    telePromLab.text = @"电话";
    telePromLab.textColor = [UIColor CMLtextInputGrayColor];
    telePromLab.font = KSystemFontSize13;
    [telePromLab sizeToFit];
    telePromLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(commpanyLab.frame) + 30*Proportion,
                                   telePromLab.frame.size.width,
                                   telePromLab.frame.size.height);
    [self.bgView addSubview:telePromLab];
    
    UILabel *teleLab = [[UILabel alloc] init];
    teleLab.text = self.obj.retData.contactPhone;
    teleLab.textColor = [UIColor CMLBlackColor];
    teleLab.font = KSystemFontSize14;
    
    [teleLab sizeToFit];
    teleLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                               CGRectGetMaxY(telePromLab.frame) + 15*Proportion,
                               teleLab.frame.size.width,
                               teleLab.frame.size.height);
    [self.bgView addSubview:teleLab];
    
    if (self.obj.retData.contactPhone.length == 0) {
        
        teleLab.text = @"暂未填写";
        [teleLab sizeToFit];
        teleLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(telePromLab.frame) + 15*Proportion,
                                   teleLab.frame.size.width,
                                   teleLab.frame.size.height);
        teleLab.textColor = [UIColor clearColor];
    }
    
    UILabel *emailPromLab = [[UILabel alloc] init];
    emailPromLab.text = @"邮箱";
    emailPromLab.textColor = [UIColor CMLtextInputGrayColor];
    emailPromLab.font = KSystemFontSize13;
    [emailPromLab sizeToFit];
    emailPromLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(teleLab.frame) + 30*Proportion,
                                   emailPromLab.frame.size.width,
                                   emailPromLab.frame.size.height);
    [self.bgView addSubview:emailPromLab];
    
    UILabel *emailLab = [[UILabel alloc] init];
    emailLab.text = self.obj.retData.contactEmail;
    emailLab.textColor = [UIColor CMLBlackColor];
    emailLab.font = KSystemFontSize14;
    emailLab.textAlignment = NSTextAlignmentLeft;
    [emailLab sizeToFit];
    emailLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                               CGRectGetMaxY(emailPromLab.frame) + 15*Proportion,
                               emailLab.frame.size.width,
                               emailLab.frame.size.height);
    [self.bgView addSubview:emailLab];
    
    if (self.obj.retData.contactEmail.length == 0) {
        
        emailLab.text = @"暂未填写";
        [emailLab sizeToFit];
        emailLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                   CGRectGetMaxY(emailPromLab.frame) + 15*Proportion,
                                   emailLab.frame.size.width,
                                   emailLab.frame.size.height);
        emailLab.textColor = [UIColor clearColor];
    }
    
    UILabel *addressPromLab = [[UILabel alloc] init];
    addressPromLab.text = @"地址";
    addressPromLab.textColor = [UIColor CMLtextInputGrayColor];
    addressPromLab.font = KSystemFontSize13;
    [addressPromLab sizeToFit];
    addressPromLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                    CGRectGetMaxY(emailLab.frame) + 30*Proportion,
                                    addressPromLab.frame.size.width,
                                    addressPromLab.frame.size.height);
    [self.bgView addSubview:addressPromLab];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.text = self.obj.retData.contactAddress;
    addressLab.textColor = [UIColor CMLBlackColor];
    addressLab.font = KSystemFontSize14;
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.numberOfLines = 0;
    CGRect addressCurrentRect = [addressLab.text boundingRectWithSize:CGSizeMake(470*Proportion, HEIGHT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                              context:nil];
    addressLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                CGRectGetMaxY(addressPromLab.frame) + 15*Proportion,
                                470*Proportion,
                                addressCurrentRect.size.height);
    [self.bgView addSubview:addressLab];
    
    if (self.obj.retData.contactAddress.length == 0) {
        
        addressLab.text = @"暂未填写";
        [addressLab sizeToFit];
        addressLab.frame = CGRectMake(CGRectGetMaxX(userImageBgView.frame) + 20*Proportion,
                                      CGRectGetMaxY(addressPromLab.frame) + 15*Proportion,
                                      addressLab.frame.size.width,
                                      addressLab.frame.size.height);
        addressLab.textColor = [UIColor clearColor];
    }

    
    self.bgView.frame = CGRectMake(WIDTH/2.0 - self.bgView.frame.size.width/2.0,
                                   HEIGHT/2.0 - (CGRectGetMaxY(addressLab.frame) + 80*Proportion + 50*Proportion)/2.0,
                                   self.bgView.frame.size.width,
                                   CGRectGetMaxY(addressLab.frame) + 80*Proportion + 50*Proportion);
    
    
    [self setBottomView];

    self.bgView.layer.cornerRadius = 40*Proportion;
    
}

- (void) setBottomView{

    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             self.bgView.frame.size.height - 80*Proportion,
                                                             self.bgView.frame.size.width,
                                                             80*Proportion)];
    
    self.view2.backgroundColor = [UIColor CMLBrownColor];
    self.view2.tag = 100;
    
    [self.bgView addSubview:self.view2];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view2.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(80*Proportion,80*Proportion)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.view2.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.view2.layer.mask = maskLayer;

    
    if ([self.userID intValue] == [[[DataManager lightData] readUserID] intValue]) {

        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 1/2.0,
                                                                      80*Proportion/2.0 - 38*Proportion/2.0,
                                                                      1,
                                                                      38*Proportion)];
        centerLine.backgroundColor = [UIColor CMLWhiteColor];
        [self.view2 addSubview:centerLine];
        
        UIButton *saveCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.bgView.frame.size.width/2.0,
                                                                           80*Proportion)];
        saveCardBtn.backgroundColor = [UIColor clearColor];
        [saveCardBtn setTitle:@"保存名片" forState:UIControlStateNormal];
        saveCardBtn.titleLabel.font = KSystemFontSize15;
        [self.view2 addSubview:saveCardBtn];
        [saveCardBtn addTarget:self action:@selector(saveCurrentInvitation) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *editCardbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width/2.0,
                                                                           0,
                                                                           self.bgView.frame.size.width/2.0,
                                                                           80*Proportion)];
        editCardbtn.backgroundColor = [UIColor clearColor];
        [editCardbtn setTitle:@"编辑名片" forState:UIControlStateNormal];
        editCardbtn.titleLabel.font = KSystemFontSize15;
        [self.view2 addSubview:editCardbtn];
        [editCardbtn addTarget:self action:@selector(enterEditVC) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
    
        UIButton *saveCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.bgView.frame.size.width,
                                                                           80*Proportion)];
        saveCardBtn.backgroundColor = [UIColor clearColor];
        [saveCardBtn setTitle:@"保存名片" forState:UIControlStateNormal];
        saveCardBtn.titleLabel.font = KSystemFontSize15;
        [self.view2 addSubview:saveCardBtn];
        [saveCardBtn addTarget:self action:@selector(saveCurrentInvitation) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];
}

#pragma mark - 获取个人名片
- (void) getNameCardMessageRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.userID forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.userID,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:NewNameCard param:paraDic delegate:delegate];
    
    [self.delegate startNewCardLoading];
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        
        self.obj = obj;
         [self loadViews];
        
    }else{
    
        [self removeFromSuperview];
    }
   
    [self.delegate endNewCardLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self removeFromSuperview];


    [self.delegate endNewCardLoading];
}

- (void) saveCurrentInvitation{
    
    [self.view2 removeFromSuperview];

    UIImage *targetImage = [UIImage getImageFromView:self.bgView];
    
    [self saveImageToPhotos:targetImage];
    
    [self setBottomView];
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        [self.delegate saveCurrentNewCardView:msg];
    }else{
        msg = @"保存图片成功" ;
        
        [self.delegate saveCurrentNewCardView:msg];
        
        [self removeFromSuperview];
        
    }
}

- (void) enterEditVC{

    NewCardEditVC *vc = [[NewCardEditVC alloc] initWithObj:self.obj];
    [[VCManger mainVC] pushVC:vc animate:YES];
 
    [self removeFromSuperview];
}
@end
