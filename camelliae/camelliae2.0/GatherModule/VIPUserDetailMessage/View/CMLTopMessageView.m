//
//  CMLTopMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLTopMessageView.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLVIPNewsImageShowVC.h"
#import "VCManger.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"

@interface CMLTopMessageView ()

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *userNameLab;

@property (nonatomic,strong) UILabel *userTitleLab;

@property (nonatomic,strong) UIImageView *userMemberLvl;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) RecommendTimeLineObj *obj;

@end


@implementation CMLTopMessageView

- (instancetype)initWithObj:(RecommendTimeLineObj *) obj{
    
    self = [super init];
    
    if (self) {
        
        self.obj = obj;
        self.userInteractionEnabled = YES;
        [self loadViews];
    }
    
    return self;
    
}

- (void) loadViews{
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                   30*Proportion,
                                                                   80*Proportion,
                                                                   80*Proportion)];
    self.userImage.clipsToBounds = YES;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.cornerRadius = 80*Proportion/2.0;
    self.userImage.userInteractionEnabled = YES;
    [self addSubview:self.userImage];
    [NetWorkTask setImageView:self.userImage  WithURL:self.obj.gravatar placeholderImage:nil];
    
    UIButton *userBtn = [[UIButton alloc] initWithFrame:self.userImage.bounds];
    userBtn.backgroundColor = [UIColor clearColor];
    [self.userImage addSubview:userBtn];
    [userBtn addTarget:self action:@selector(enterUserDetail) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.font = KSystemFontSize14;
    self.userNameLab.textAlignment = NSTextAlignmentLeft;
    self.userNameLab.textColor = [UIColor CMLBlackColor];
    self.userNameLab.text = self.obj.nickName;
    [self.userNameLab sizeToFit];
    self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                        self.userImage.center.y - 10*Proportion/2.0 - self.userNameLab.frame.size.height,
                                        self.userNameLab.frame.size.width,
                                        self.userNameLab.frame.size.height);
    [self addSubview:self.userNameLab];
    
    self.userTitleLab = [[UILabel alloc] init];
    self.userTitleLab.font = KSystemFontSize12;
    self.userTitleLab.textAlignment = NSTextAlignmentLeft;
    self.userTitleLab.textColor = [UIColor CMLLineGrayColor];
    self.userTitleLab.text = self.obj.signature;
    [self.userTitleLab sizeToFit];
    self.userTitleLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                         CGRectGetMaxY(self.userNameLab.frame) + 10*Proportion,
                                         WIDTH - (CGRectGetMaxX(self.userImage.frame) + 20*Proportion*2),
                                         self.userTitleLab.frame.size.height);
    [self addSubview:self.userTitleLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = KSystemFontSize11;
    self.timeLab.textColor = [UIColor CMLtextInputGrayColor];
    self.timeLab.text = self.obj.publishTimeStr;
    [self addSubview:self.timeLab];
    
    self.userMemberLvl = [[UIImageView alloc] init];
    switch ([self.obj.memberLevel intValue]) {
        case 1:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlOneImg];
            break;
        case 2:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlTwoImg];
            break;
        case 3:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlThreeImg];
            break;
        case 4:
            self.userMemberLvl.image = [UIImage imageNamed:CMLLvlFourImg];
            break;
            
        default:
            break;
    }
    [self addSubview:self.userMemberLvl];
    

    
    if (self.obj.signature.length == 0) {
        
        self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            self.userImage.center.y - self.userNameLab.frame.size.height/2.0,
                                            self.userNameLab.frame.size.width,
                                            self.userNameLab.frame.size.height);
    }else{
        
        self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + 20*Proportion,
                                            self.userImage.center.y - 10*Proportion/2.0 - self.userNameLab.frame.size.height,
                                            self.userNameLab.frame.size.width,
                                            self.userNameLab.frame.size.height);
    }
    
    
    [self.userMemberLvl sizeToFit];
    self.userMemberLvl.frame = CGRectMake(CGRectGetMaxX(self.userNameLab.frame) + 10*Proportion,
                                          self.userNameLab.center.y - self.userMemberLvl.frame.size.height/2.0,
                                          self.userMemberLvl.frame.size.width,
                                          self.userMemberLvl.frame.size.height);
    
    [self.timeLab sizeToFit];
    self.timeLab.frame = CGRectMake(WIDTH - 20*Proportion - self.timeLab.frame.size.width,
                                    self.userNameLab.center.y - self.timeLab.frame.size.height/2.0,
                                    self.timeLab.frame.size.width,
                                    self.timeLab.frame.size.height);


    self.currentHeight = CGRectGetMaxY(self.userImage.frame) + 20*Proportion;
    
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        });
    //
    //    });
    
}

- (void) enterUserDetail{
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.nickName
//                                                          currnetUserId:self.obj.userId
//                                                     isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}


@end
