//
//  CMLRecommendTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLRecommendTVCell.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "DataManager.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"

@interface CMLRecommendTVCell()

@property (nonatomic,strong) UIImageView *bgView;

@property (nonatomic,strong) UIImageView *userHeadImg;

@property (nonatomic,strong) UILabel *nickName;

@property (nonatomic,strong) UILabel *sig;

@property (nonatomic,strong) UILabel *detailMes;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIView *tempBgView;

@property (nonatomic,strong) ServeRecommedUserObj *obj;

@property (nonatomic,strong) UIButton *userVideoBtn;

@end

@implementation CMLRecommendTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    return self;
}

- (void) loadViews{
    
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                           30*Proportion,
                                                           WIDTH - 30*Proportion*2,
                                                           0)];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.image = [UIImage imageNamed:RecommendBgImg];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    
    self.userHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width/2.0 - 80*Proportion/2.0,
                                                                     30*Proportion,
                                                                     80*Proportion,
                                                                     80*Proportion)];
    self.userHeadImg.contentMode = UIViewContentModeScaleAspectFill;
    self.userHeadImg.layer.cornerRadius = 80*Proportion/2.0;
    self.userHeadImg.clipsToBounds = YES;
    self.userHeadImg.userInteractionEnabled = YES;
    self.userHeadImg.backgroundColor = [UIColor CMLNewGrayColor];
    [self.bgView addSubview:self.userHeadImg];
    
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:self.userHeadImg.bounds];
    enterBtn.backgroundColor = [UIColor clearColor];
    [self.userHeadImg addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(enterDetailMes) forControlEvents:UIControlEventTouchUpInside];
    
    self.nickName = [[UILabel alloc] init];
    self.nickName.font = KSystemFontSize14;
    self.nickName.textColor = [UIColor CMLBlackColor];
    [self.bgView addSubview:self.nickName];
    
    self.sig = [[UILabel alloc] init];
    self.sig.font = KSystemFontSize12;
    self.sig.textAlignment = NSTextAlignmentCenter;
    self.sig.textColor = [UIColor CMLtextInputGrayColor];
    [self.bgView addSubview:self.sig];
    
    self.detailMes = [[UILabel alloc] init];
    self.detailMes.numberOfLines = 0;
    self.detailMes.textAlignment = NSTextAlignmentCenter;
    self.detailMes.font = KSystemFontSize14;
    [self.bgView addSubview:self.detailMes];
    
    
    self.deleteBtn = [[UIButton alloc] init];
    self.deleteBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview: self.deleteBtn];
        
    self.userVideoBtn = [[UIButton alloc] init];
    [self.userVideoBtn setBackgroundImage:[UIImage imageNamed:RecommendUserVideoImg] forState:UIControlStateNormal];
    [self.bgView addSubview:self.userVideoBtn];
    
   

}

- (void) refreshCurrentCell:(ServeRecommedUserObj *) obj{
    
    self.obj = obj;
    
    
    [NetWorkTask setImageView:self.userHeadImg WithURL:obj.gravatar placeholderImage:nil];
    
    self.nickName.text = obj.nickName;
    [self.nickName sizeToFit];
    self.nickName.frame  =CGRectMake(self.bgView.frame.size.width/2.0 - self.nickName.frame.size.width/2.0,
                                     CGRectGetMaxY(self.userHeadImg.frame) + 20*Proportion,
                                     self.nickName.frame.size.width,
                                     self.nickName.frame.size.height);
    
    self.userVideoBtn.frame = CGRectMake(self.bgView.frame.size.width - 44*Proportion - 60*Proportion,
                                         self.nickName.center.y - 44*Proportion/2.0,
                                         44*Proportion,
                                         44*Proportion);
    self.userVideoBtn.tag = self.tag;
     [self.userVideoBtn addTarget:self action:@selector(showVideo:) forControlEvents:UIControlEventTouchUpInside];
     if (self.obj.videoUrl.length > 0) {
         
         self.userVideoBtn.hidden = NO;
     }else{
         
         self.userVideoBtn.hidden = YES;
     }
    
    self.sig.text = obj.signature;
    [self.sig sizeToFit];
    self.sig.frame = CGRectMake(60*Proportion,
                                CGRectGetMaxY(self.nickName.frame) + 10*Proportion,
                                self.bgView.frame.size.width - 60*Proportion*2,
                                self.sig.frame.size.height);
    self.detailMes.text = obj.recommDetail;
    CGRect currentRect =  [self.detailMes.text boundingRectWithSize:CGSizeMake(self.bgView.frame.size.width - 60*Proportion*2, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                            context:nil];
    self.detailMes.frame = CGRectMake(60*Proportion,
                                      CGRectGetMaxY(self.sig.frame) + 28*Proportion,
                                      self.bgView.frame.size.width - 60*Proportion*2,
                                      currentRect.size.height);
    
    self.bgView.frame = CGRectMake(30*Proportion,
                                   30*Proportion,
                                   WIDTH - 30*Proportion*2,
                                   CGRectGetMaxY(self.detailMes.frame) + 26*Proportion);
    
    if ([obj.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        
        self.deleteBtn.hidden = NO;
        [self.deleteBtn setImage:[UIImage imageNamed:DeleteRecommendImg] forState:UIControlStateNormal];
        [self.deleteBtn sizeToFit];
        self.deleteBtn.frame = CGRectMake(self.bgView.frame.size.width - 30*Proportion - self.deleteBtn.frame.size.width,
                                          30*Proportion,
                                          self.deleteBtn.frame.size.width,
                                          self.deleteBtn.frame.size.height);
        [self.deleteBtn addTarget:self action:@selector(showDeleteView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.deleteBtn.hidden = YES;
    }
    
    self.currentHeight = CGRectGetMaxY(self.bgView.frame);
    
}

- (void) showDeleteView{
    
    self.tempBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           WIDTH,
                                                           HEIGHT)];
    self.tempBgView.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
    [self.superview.superview addSubview:self.tempBgView];
    [self.superview.superview bringSubviewToFront:self.tempBgView];
    
    UIView *deleteBgView = [[UIView alloc] initWithFrame:CGRectMake(self.tempBgView.frame.size.width/2.0 - 400*Proportion/2.0,
                                                                    self.tempBgView.frame.size.height/2.0 - 360*Proportion/2.0,
                                                                    400*Proportion,
                                                                    360*Proportion)];
    deleteBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.tempBgView addSubview:deleteBgView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     deleteBgView.frame.size.height - 70*Proportion,
                                                                     200*Proportion,
                                                                     70*Proportion)];
    cancelBtn.backgroundColor = [UIColor CMLLightBrownColor];
    cancelBtn.titleLabel.font = KSystemFontSize14;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [deleteBgView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(deleteBgView.frame.size.width - 200*Proportion,
                                                                      deleteBgView.frame.size.height - 70*Proportion,
                                                                      200*Proportion,
                                                                      70*Proportion)];
    confirmBtn.backgroundColor = [UIColor CMLLightBrownColor];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [deleteBgView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(delegateCurrentRecommend) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(deleteBgView.frame.size.width/2.0,
                                                                 deleteBgView.frame.size.height - 10*Proportion - 50*Proportion,
                                                                 2*Proportion,
                                                                 70*Proportion - 10*Proportion*2)];
    spaceLine.backgroundColor = [UIColor CMLWhiteColor];
    [deleteBgView addSubview:spaceLine];
    
    UIImageView *promImg = [[UIImageView alloc] init];
    promImg.backgroundColor = [UIColor CMLWhiteColor];
    promImg.image = [UIImage imageNamed:DeletePromImg];
    [promImg sizeToFit];
    promImg.frame = CGRectMake(deleteBgView.frame.size.width/2.0 - promImg.frame.size.width/2.0,
                               90*Proportion,
                               promImg.frame.size.width,
                               promImg.frame.size.height);
    [deleteBgView addSubview:promImg];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize13;
    promLab.textColor = [UIColor CMLBlackColor];
    promLab.text = @"删除我的推荐";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(deleteBgView.frame.size.width/2.0 - promLab.frame.size.width/2.0,
                               CGRectGetMaxY(promImg.frame) + 20*Proportion,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [deleteBgView addSubview:promLab];
    
}

- (void) closeCurrentView{
    
    [self.tempBgView removeFromSuperview];
}

- (void) delegateCurrentRecommend{
    
    [self.tempBgView removeFromSuperview];
    self.deleteCurrentLineBlock(self.obj.recommId);
}

- (void) enterDetailMes{
    
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:@""
//                                                          currnetUserId:self.obj.userId
//                                                     isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) showVideo:(UIButton *) btn{
    
    self.playVideoBlock(btn.tag);
}
@end
