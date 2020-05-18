//
//  CommentTableVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CommentTableVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLVIPNewDetailVC.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "BaseResultObj.h"

#define CommentTableVCellUserImageLeftMargin   20
#define CommentTableVCellUserImageTopMargin    30
#define CommentTableVCellUserImageHeight       80
#define CommentTableVCellUserNickNameTopMargin 46
#define CommentTableVCellUserNickNameLeftMargin 20
#define CommentTableVCellContentTopMargin       20
#define CommentTableVCellContentBottomMargin    40
#define CommentTableVCellNameAndContentMargin   40
@interface CommentTableVCell ()<NetWorkProtocol>

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UILabel *userNickNameLabel;

@property (nonatomic,strong) UILabel *pushTimeLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UILabel *numLab;

@end

@implementation CommentTableVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(CommentTableVCellUserImageLeftMargin*Proportion,
                                                                   CommentTableVCellUserImageTopMargin*Proportion,
                                                                   CommentTableVCellUserImageHeight*Proportion,
                                                                   CommentTableVCellUserImageHeight*Proportion)];
    self.userImage.clipsToBounds = YES;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.cornerRadius = CommentTableVCellUserImageHeight*Proportion/2.0;
    self.userImage.backgroundColor = [UIColor CMLPromptGrayColor];
    self.userImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.userImage];
    
    UIButton *enterUserMainViewBtn = [[UIButton alloc] initWithFrame:self.userImage.bounds];
    enterUserMainViewBtn.backgroundColor = [UIColor clearColor];
    [self.userImage addSubview:enterUserMainViewBtn];
    [enterUserMainViewBtn addTarget:self action:@selector(enterPersonMainView) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.userNickNameLabel = [[UILabel alloc] init];
    self.userNickNameLabel.font = KSystemFontSize12;
    self.userNickNameLabel.textColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:self.userNickNameLabel];
    
    self.pushTimeLabel = [[UILabel alloc] init];
    self.pushTimeLabel.font = KSystemFontSize10;
    self.pushTimeLabel.textColor = [UIColor CMLtextInputGrayColor];
    [self.contentView addSubview:self.pushTimeLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = KSystemFontSize14;
    self.contentLabel.textColor = [UIColor CMLUserBlackColor];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    
    self.btn = [[UIButton alloc] init];
    [self.btn setBackgroundImage:[UIImage imageNamed:CommentLikeImg] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage imageNamed:CommentLikedImg] forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn];

    
    
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemFontSize11;
    self.numLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.numLab];


    
}

- (void) refreshCurrentCell{

    /**userimage*/
    [NetWorkTask setImageView:self.userImage WithURL:self.userImageUrl placeholderImage:nil];
    
    /**nickName*/
    self.userNickNameLabel.text = self.userNickName;
    [self.userNickNameLabel sizeToFit];
    self.userNickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + CommentTableVCellUserNickNameLeftMargin*Proportion,
                                              self.userImage.frame.origin.y + ((CommentTableVCellUserImageHeight - CommentTableVCellNameAndContentMargin)*Proportion/2.0 - self.userNickNameLabel.frame.size.height/2.0),
                                              self.userNickNameLabel.frame.size.width,
                                              self.userNickNameLabel.frame.size.height);
    
    
    /**pushTime*/
    self.pushTimeLabel.text = self.pushTime;
    [self.pushTimeLabel sizeToFit];
    self.pushTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame) + CommentTableVCellUserNickNameLeftMargin*Proportion,
                                          CGRectGetMaxY(self.userNickNameLabel.frame) - self.pushTimeLabel.frame.size.height,
                                          self.pushTimeLabel.frame.size.width,
                                          self.pushTimeLabel.frame.size.height);
    
    [self.btn sizeToFit];
    self.btn.frame = CGRectMake( WIDTH - 20*Proportion - self.btn.frame.size.width,
                                self.userImage.center.y - self.btn.frame.size.height/2.0,
                                self.btn.frame.size.width,
                                self.btn.frame.size.height);
    
    
    if ([self.isUserLike intValue] == 1) {
        self.btn.selected = YES;
    }else{
    
        self.btn.selected = NO;
    }
    
    self.numLab.text = [NSString stringWithFormat:@"%@",self.num];
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                   CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                   self.numLab.frame.size.width,
                                   self.numLab.frame.size.height);
    
    /**content*/
    self.contentLabel.text = self.pushContent;
    CGRect textSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.userImage.frame) - CommentTableVCellUserNickNameLeftMargin*Proportion*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize14} context:nil];
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.userImage.frame) + CommentTableVCellUserNickNameLeftMargin*Proportion,
                                         CGRectGetMaxY(self.userNickNameLabel.frame) + CommentTableVCellNameAndContentMargin*Proportion - self.userNickNameLabel.frame.size.height,
                                         [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.userImage.frame) - CommentTableVCellUserNickNameLeftMargin*Proportion*2,
                                         textSize.size.height);
    
    
    
    
    
    
    self.currentRowHeight = CGRectGetMaxY(self.contentLabel.frame) + CommentTableVCellContentBottomMargin*Proportion;
    
}

- (void) enterPersonMainView{

//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:self.userNickName currnetUserId:self.userId isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) changeStatus:(UIButton *) btn{
    
    self.btn.selected = !self.btn.selected;
    
    if (self.btn.selected) {
        
        self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] + 1];
        [self.numLab sizeToFit];
        self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                  CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                  self.numLab.frame.size.width,
                                  self.numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:1]];
    }else{
        self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] - 1];
        [self.numLab sizeToFit];
        self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                  CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                  self.numLab.frame.size.width,
                                  self.numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:2]];
    }
    
}
#pragma mark - likeCurrent
- (void) likeCurrent:(NSNumber *) status{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.recordId forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:97] forKey:@"objTypeId"];
    [paraDic setObject:status forKey:@"actType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.recordId,
                                                           [NSNumber numberWithInt:97],
                                                           reqTime,
                                                           status,
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:LikeCurrent paraDic:paraDic delegate:delegate];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        
    }else{
    
        self.btn.selected = !self.btn.selected;
        
        if (self.btn.selected) {
            
            self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] + 1];
            [self.numLab sizeToFit];
            self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                           CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                           self.numLab.frame.size.width,
                                           self.numLab.frame.size.height);
            [self likeCurrent:[NSNumber numberWithInt:1]];
        }else{
            self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] - 1];
            [self.numLab sizeToFit];
            self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                           CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                           self.numLab.frame.size.width,
                                           self.numLab.frame.size.height);
            [self likeCurrent:[NSNumber numberWithInt:2]];
        }
    }
    
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    self.btn.selected = !self.btn.selected;
    
    if (self.btn.selected) {
        
        self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] + 1];
        [self.numLab sizeToFit];
        self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                       CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                       self.numLab.frame.size.width,
                                       self.numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:1]];
    }else{
        self.numLab.text = [NSString stringWithFormat:@"%d",[self.numLab.text intValue] - 1];
        [self.numLab sizeToFit];
        self.numLab.frame = CGRectMake(self.btn.frame.origin.x - 10*Proportion - self.numLab.frame.size.width,
                                       CGRectGetMaxY(self.btn.frame)- self.numLab.frame.size.height,
                                       self.numLab.frame.size.width,
                                       self.numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:2]];
    }
}


@end
