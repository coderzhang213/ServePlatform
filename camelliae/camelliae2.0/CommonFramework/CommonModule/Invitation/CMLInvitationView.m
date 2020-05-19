//
//  CMLInvitationView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/4/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLInvitationView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "UIImage+CMLExspand.h"
#import "NetWorkTask.h"

#define MessageBgWidth  520
#define MessageBgHeight 880
#define ServeDefaultVCShareViewBtnAndBtnHSpace           120
#define ShareViewTitleLineOneTopMargin                   40

@interface CMLInvitationView ()

@property (nonatomic,strong) UIView *oldImageBgView;

@property (nonatomic,strong) UIView *shareView;

@property (nonatomic,strong) UIImageView *shareImage;

@property (nonatomic,strong) UIView *bgView;


@end

@implementation CMLInvitationView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    
}

- (void) refershInvitationView{

    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           WIDTH,
                                                           HEIGHT)];
    self.bgView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.bgView];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH,
                                                                     HEIGHT)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(hiddenIncitationView) forControlEvents:UIControlEventTouchUpInside];
    
    self.oldImageBgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 620*Proportion/2.0,
                                                                   107*Proportion,
                                                                   620*Proportion,
                                                                   1000*Proportion)];
    self.oldImageBgView.userInteractionEnabled = YES;
    self.oldImageBgView.layer.cornerRadius = 20*Proportion;
    self.oldImageBgView.layer.masksToBounds = YES;
    self.oldImageBgView.clipsToBounds = YES;
    self.oldImageBgView.backgroundColor = [UIColor clearColor];
    [cancelBtn addSubview:self.oldImageBgView];
    
    UIImageView *invitationBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:InvitationImg]];
    invitationBgImage.contentMode = UIViewContentModeScaleAspectFill;
    invitationBgImage.userInteractionEnabled = YES;
    invitationBgImage.clipsToBounds = YES;
    invitationBgImage.layer.cornerRadius = 20*Proportion;
    [invitationBgImage sizeToFit];
    invitationBgImage.frame = CGRectMake(0,
                                         0,
                                         620*Proportion,
                                         1000*Proportion);
    
    [self.oldImageBgView addSubview:invitationBgImage];
    
    
    BOOL isUpMove = YES;
    
    UIView *messageBgView = [[UIView alloc] initWithFrame:CGRectMake(invitationBgImage.frame.size.width/2.0 - MessageBgWidth*Proportion/2.0,
                                                                     0,
                                                                     MessageBgWidth*Proportion,
                                                                     0)];
    messageBgView.backgroundColor = [UIColor clearColor];
    [invitationBgImage addSubview:messageBgView];
    

    
    UILabel *userNameLab = [[UILabel alloc] init];
    userNameLab.text = [NSString stringWithFormat:@"尊敬的%@",self.userName];
    userNameLab.font = KSystemBoldFontSize14;
    userNameLab.textColor = [UIColor CMLWhiteColor];
    [userNameLab sizeToFit];
    userNameLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - userNameLab.frame.size.width/2.0,
                                   0,
                                   userNameLab.frame.size.width,
                                   userNameLab.frame.size.height);
    [messageBgView addSubview:userNameLab];
    
    UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:InvitationUpImg]];
    [upImage sizeToFit];
    upImage.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - upImage.frame.size.width/2.0,
                               CGRectGetMaxY(userNameLab.frame) + 20*Proportion,
                               upImage.frame.size.width,
                               upImage.frame.size.height);
    [messageBgView addSubview:upImage];
    
    UILabel*promOneLab = [[UILabel alloc] init];
    promOneLab.font = KSystemFontSize11;
    promOneLab.textColor = [UIColor CMLLineGrayColor];
    promOneLab.text = @"卡枚连真诚邀请您参加";
    [promOneLab sizeToFit];
    promOneLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - promOneLab.frame.size.width/2.0,
                                  CGRectGetMaxY(upImage.frame) + 30*Proportion,
                                  promOneLab.frame.size.width,
                                  promOneLab.frame.size.height);
    [messageBgView addSubview:promOneLab];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = KSystemBoldFontSize12;
    titleLab.textColor = [UIColor CMLWhiteColor];
    titleLab.numberOfLines = 0;
    titleLab.text = [NSString stringWithFormat:@"﹝%@﹞",self.activityTitle];
    [titleLab sizeToFit];
    titleLab.textAlignment = NSTextAlignmentCenter;
    CGRect currentRect = [titleLab.text boundingRectWithSize:CGSizeMake(messageBgView.frame.size.width - 20*Proportion*2, 1000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:KSystemBoldFontSize12}
                                                     context:nil];
    if (titleLab.frame.size.width > messageBgView.frame.size.width - 20*Proportion*2) {
        
        isUpMove = NO;
        titleLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                    CGRectGetMaxY(promOneLab.frame) + 15*Proportion,
                                    messageBgView.frame.size.width - 20*Proportion*2,
                                    currentRect.size.height);
    }else{
        
        titleLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                    CGRectGetMaxY(promOneLab.frame) + 15*Proportion,
                                    messageBgView.frame.size.width - 20*Proportion*2,
                                    titleLab.frame.size.height);
    }
    [messageBgView addSubview:titleLab];
    
    UILabel *promTwoLab = [[UILabel alloc] init];
    promTwoLab.textColor = [UIColor CMLLineGrayColor];
    promTwoLab.font = KSystemFontSize11;
    promTwoLab.text = @"时间";
    [promTwoLab sizeToFit];
    promTwoLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - promTwoLab.frame.size.width/2.0,
                                  CGRectGetMaxY(titleLab.frame) + 40*Proportion,
                                  promTwoLab.frame.size.width,
                                  promTwoLab.frame.size.height);
    [messageBgView addSubview:promTwoLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = KSystemBoldFontSize12;
    timeLab.textColor = [UIColor CMLWhiteColor];
    timeLab.text = self.timeZone;
    timeLab.textAlignment = NSTextAlignmentCenter;
    [timeLab sizeToFit];
    CGRect currentRect1 = [timeLab.text boundingRectWithSize:CGSizeMake(messageBgView.frame.size.width - 20*Proportion*2, 1000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:KSystemBoldFontSize12}
                                                     context:nil];
    if (timeLab.frame.size.width > messageBgView.frame.size.width - 20*Proportion*2) {
        
        isUpMove = NO;
        timeLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                   CGRectGetMaxY(promTwoLab.frame) + 15*Proportion,
                                   messageBgView.frame.size.width - 20*Proportion*2,
                                   currentRect1.size.height);
    }else{
        
        timeLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                   CGRectGetMaxY(promTwoLab.frame) + 15*Proportion,
                                   messageBgView.frame.size.width - 20*Proportion*2,
                                   timeLab.frame.size.height);
    }
    [messageBgView addSubview:timeLab];
    
    
    UILabel *promThreeLab = [[UILabel alloc] init];
    promThreeLab.textColor = [UIColor CMLLineGrayColor];
    promThreeLab.font = KSystemFontSize11;
    promThreeLab.text = @"地点";
    [promThreeLab sizeToFit];
    promThreeLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - promThreeLab.frame.size.width/2.0,
                                  CGRectGetMaxY(timeLab.frame) + 40*Proportion,
                                  promThreeLab.frame.size.width,
                                  promThreeLab.frame.size.height);
    [messageBgView addSubview:promThreeLab];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = KSystemBoldFontSize12;
    addressLab.textColor = [UIColor CMLWhiteColor];
    addressLab.text = self.address;
    addressLab.numberOfLines = 0;
    addressLab.textAlignment = NSTextAlignmentCenter;
    [addressLab sizeToFit];
    CGRect currentRect2 = [addressLab.text boundingRectWithSize:CGSizeMake(messageBgView.frame.size.width - 20*Proportion*2, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:KSystemBoldFontSize12}
                                                        context:nil];
    if (addressLab.frame.size.width > messageBgView.frame.size.width - 20*Proportion*2) {
        
        isUpMove = NO;
        addressLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                      CGRectGetMaxY(promThreeLab.frame) + 15*Proportion,
                                      messageBgView.frame.size.width - 20*Proportion*2,
                                      currentRect2.size.height);
    }else{
        
        addressLab.frame = CGRectMake(MessageBgWidth*Proportion/2.0 - (messageBgView.frame.size.width - 20*Proportion*2)/2.0,
                                      CGRectGetMaxY(promThreeLab.frame) + 15*Proportion,
                                      messageBgView.frame.size.width - 20*Proportion*2,
                                      addressLab.frame.size.height);
    }
    [messageBgView addSubview:addressLab];
    
    if (isUpMove) {
     
        messageBgView.frame =  CGRectMake(invitationBgImage.frame.size.width/2.0 - MessageBgWidth*Proportion/2.0,
                                          100*Proportion + 50*Proportion,
                                          MessageBgWidth*Proportion,
                                          CGRectGetMaxY(addressLab.frame));
    }else{
    
    
        messageBgView.frame =  CGRectMake(invitationBgImage.frame.size.width/2.0 - MessageBgWidth*Proportion/2.0,
                                          50*Proportion + 50*Proportion,
                                          MessageBgWidth*Proportion,
                                          CGRectGetMaxY(addressLab.frame));
    }
    
    
    UILabel *lastLab = [[UILabel alloc] init];
    lastLab.textColor = [UIColor CMLLineGrayColor];
    lastLab.font = KSystemFontSize10;
    lastLab.text = @"· 扫描二维码，查看精彩活动详情 ·";
    [lastLab sizeToFit];
    lastLab.frame = CGRectMake(invitationBgImage.frame.size.width/2.0  - lastLab.frame.size.width/2.0,
                               invitationBgImage.frame.size.height - 150*Proportion - 50*Proportion - lastLab.frame.size.height,
                               lastLab.frame.size.width,
                               lastLab.frame.size.height);
    [invitationBgImage addSubview:lastLab];
    
    UIView *QRImageBgView = [[UIView alloc] initWithFrame:CGRectMake(invitationBgImage.frame.size.width/2.0 - 160*Proportion/2.0,
                                                                     lastLab.frame.origin.y - 20*Proportion - 160*Proportion,
                                                                     160*Proportion,
                                                                     160*Proportion)];
    QRImageBgView.backgroundColor = [UIColor clearColor];
    QRImageBgView.layer.borderColor = [UIColor CMLWhiteColor].CGColor;
    QRImageBgView.layer.borderWidth = 1*Proportion;
    [invitationBgImage addSubview:QRImageBgView];
    
    UIImageView *QRImage = [[UIImageView alloc] initWithImage:nil];
    [QRImage sizeToFit];
    QRImage.frame = CGRectMake(QRImageBgView.frame.size.width/2.0 - 160*Proportion/2.0,
                               QRImageBgView.frame.size.height/2.0 - 160*Proportion/2.0,
                               160*Proportion,
                               160*Proportion);
    [QRImageBgView addSubview:QRImage];
    
    if (self.QRCurrentImage) {
    
        QRImage.image = self.QRCurrentImage.image;
    }else{
    
        [NetWorkTask setImageView:QRImage WithURL:self.QRImageUrl placeholderImage:nil];

    }
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.oldImageBgView.frame.origin.x,
                                                                   CGRectGetMaxY(self.oldImageBgView.frame) + 50*Proportion,
                                                                   270*Proportion,
                                                                   70*Proportion)];
    saveBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    saveBtn.layer.borderWidth = 2*Proportion;
    saveBtn.layer.cornerRadius = 4*Proportion;
    [saveBtn setTitle:@"保存邀请函" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = KSystemFontSize12;
    saveBtn.backgroundColor = [UIColor CMLBlackColor];
    [cancelBtn addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveCurrentInvitation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oldImageBgView.frame) - 270*Proportion,
                                                                   CGRectGetMaxY(self.oldImageBgView.frame) + 50*Proportion,
                                                                   270*Proportion,
                                                                   70*Proportion)];
    shareBtn.layer.borderColor = [UIColor CMLYellowColor].CGColor;
    shareBtn.layer.borderWidth = 2*Proportion;
    shareBtn.layer.cornerRadius = 4*Proportion;
    [shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = KSystemFontSize12;
    shareBtn.backgroundColor = [UIColor CMLBlackColor];
    [shareBtn addTarget:self action:@selector(shareInvitationImage) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addSubview:shareBtn];
    
    
    self.shareImage = invitationBgImage;
}

- (void) hiddenIncitationView{

    if (self.shareView) {
        if (self.shareView.frame.origin.y == HEIGHT) {
            
            [self.delegate hiddenCurrentInvitationView];
        }else{
        
            [self cancelShare];
        }
    }else{
    
        [self.delegate hiddenCurrentInvitationView];
    }
    
}


#pragma mark - 保存图片
- (void) saveCurrentInvitation{

   UIImage *targetImage = [UIImage getImageFromView:self.shareImage];
    
    [self saveImageToPhotos:targetImage];
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
    }else{
        msg = @"保存图片成功" ;
        
        [self.delegate saveCurrentInvitationView:msg];
    }
}



- (UIView *) setCurrentNewShareView{
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              HEIGHT,
                                                              0,
                                                              0)];
    self.shareView .backgroundColor = [UIColor whiteColor];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.textColor = [UIColor CMLLineGrayColor];
    promLab.font = KSystemFontSize14;
    promLab.text = @"分享至";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                               40*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self.shareView addSubview:promLab];
    
    NSArray *imageArray = @[Wechat_CShareImg,
                            wechat_momentShareImg,
                            SinaShareImg,
                            QQShareImg];
    NSArray *shareNameArray = @[@"微信",
                                @"朋友圈",
                                @"微博",
                                @"QQ"];
    
    
    for (int i = 0; i < imageArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button sizeToFit];
        
        UILabel *shareName = [[UILabel alloc] init];
        shareName.text = shareNameArray[i];
        shareName.font = KSystemFontSize12;
        shareName.textColor = [UIColor CMLtextInputGrayColor];
        [shareName sizeToFit];
        
        if (i < 4) {
            button.frame = CGRectMake(40*Proportion +( (WIDTH - 100*Proportion*4  - 40*2*Proportion)/3 + 100*Proportion)*i,
                                      CGRectGetMaxY(promLab.frame) + ShareViewTitleLineOneTopMargin*Proportion + 20*Proportion,
                                      100*Proportion,
                                      100*Proportion);
        }else{
            button.frame = CGRectMake(40*Proportion +( (WIDTH - 100*Proportion*4  - 40*2*Proportion)/3 + 100*Proportion)*(i - 4) ,
                                      CGRectGetMaxY(promLab.frame) + 20*Proportion*2 + 40*Proportion*2 + 100*Proportion + shareName.frame.size.height,
                                      100*Proportion,
                                      100*Proportion);
        }
        shareName.frame = CGRectMake(button.center.x - shareName.frame.size.width/2.0,
                                     CGRectGetMaxY(button.frame) + 10*Proportion,
                                     shareName.frame.size.width,
                                     shareName.frame.size.height);
        [self.shareView  addSubview:shareName];
        button.tag = i + 1;
        [self.shareView  addSubview:button];
        [button addTarget:self action:@selector(changeShareStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == imageArray.count - 1) {
            
            UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - 690*Proportion)/2.0,
                                                                       CGRectGetMaxY(shareName.frame) + 40*Proportion,
                                                                       690*Proportion,
                                                                       1)];
            lineTwo.backgroundColor = [UIColor CMLPromptGrayColor];
            [self.shareView  addSubview:lineTwo];
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareName.frame) + 40*Proportion, WIDTH, 100*Proportion)];
            cancelBtn.backgroundColor = [UIColor clearColor];
            cancelBtn.titleLabel.font = KSystemFontSize14;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
            [self.shareView addSubview:cancelBtn];
            [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
            
            self.shareView.frame = CGRectMake(0,
                                              HEIGHT,
                                              WIDTH,
                                              CGRectGetMaxY(cancelBtn.frame));
        }
    }
    return self.shareView;
    
}

- (void) shareInvitationImage{

    [self.bgView addSubview:[self setCurrentNewShareView]];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        weakSelf.shareView.frame = CGRectMake(0,
                                              HEIGHT - weakSelf.shareView.frame.size.height,
                                              weakSelf.shareView.frame.size.width,
                                              weakSelf.shareView.frame.size.height);

    }];
    
}

- (void) cancelShare{

    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        
        weakSelf.shareView.frame = CGRectMake(0,
                                              HEIGHT,
                                              weakSelf.shareView.frame.size.width,
                                              weakSelf.shareView.frame.size.height);

    } completion:^(BOOL finished) {
        
        [weakSelf.shareView removeFromSuperview];
    }];
}

#pragma mark - changeShareStyle
- (void) changeShareStyle:(UIButton *) button{
    
    if (button.tag == 1) {
        
        NSLog(@"分享到对话");
        
        __weak typeof(self) weakSelf = self;
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *targetImage = [UIImage getImageFromView:self.shareImage];
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"邀请函" descr:@"" thumImage:targetImage];

        shareObject.shareImage = targetImage;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
   
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:[self viewController] completion:^(id data, NSError *error) {
            if (error) {
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享失败"];
                [weakSelf.delegate hiddenCurrentInvitationView];
                
            }else{
                [weakSelf.delegate shareCurrentInvitationView:@"分享成功"];
                [weakSelf.delegate hiddenCurrentInvitationView];
                
            }
        }];
        

        
    }else if (button.tag == 2){
        
        NSLog(@"分享到朋友圈");
        
        __weak typeof(self) weakSelf = self;
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *targetImage = [UIImage getImageFromView:self.shareImage];
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"邀请函" descr:@"" thumImage:targetImage];
        shareObject.shareImage = targetImage;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:[self viewController] completion:^(id data, NSError *error) {
            if (error) {
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享失败"];
                [weakSelf.delegate hiddenCurrentInvitationView];
                
            }else{
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享成功"];
                [weakSelf.delegate hiddenCurrentInvitationView];
            }
        }];
        
    }else if (button.tag == 3){
        
        NSLog(@"分享到微博");
        
        __weak typeof(self) weakSelf = self;
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *targetImage = [UIImage getImageFromView:self.shareImage];
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"邀请函" descr:@"" thumImage:targetImage];
        shareObject.shareImage = targetImage;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:[self viewController] completion:^(id data, NSError *error) {
            
            if (weakSelf) {
                
                [self.delegate shareCurrentInvitationView:@"分享失败"];
                [weakSelf.delegate hiddenCurrentInvitationView];
                
            }else{
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享成功"];
                [weakSelf.delegate hiddenCurrentInvitationView];
            }
        }];
        
        
    }else if (button.tag == 4){
        
        NSLog(@"分享QQ");
        
        __weak typeof(self) weakSelf = self;
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *targetImage = [UIImage getImageFromView:self.shareImage];
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"邀请函" descr:@"" thumImage:targetImage];
        shareObject.shareImage = targetImage;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:[self viewController] completion:^(id data, NSError *error) {
            if (error) {
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享失败"];
                [weakSelf.delegate hiddenCurrentInvitationView];
                
            }else{
                
                [weakSelf.delegate shareCurrentInvitationView:@"分享成功"];
                [weakSelf.delegate hiddenCurrentInvitationView];
            }
        }];
        
    }
}

- (UIViewController*)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
