//
//  CMLNewVipUseTimeLineTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/18.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewVipUseTimeLineTVCell.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLImageObj.h"
#import "CMLLine.h"
#import "CMLVIPNewsImageShowVC.h"
#import "VCManger.h"
#import "CMLVIPNewDetailVC.h"
#import "ActivityDefaultVC.h"
#import "ProjectInfoObj.h"
#import "CMLTimeLineDetailMessageVC.h"
#import "VCManger.h"
#import "RecommendTimeLineObj.h"
#import "CMLTopMessageView.h"
#import "CMLUserTopicVC.h"

#define UserImageWidth         80
#define LeftMargin             20
#define TopMargin              30

@interface CMLNewVipUseTimeLineTVCell ()<NetWorkProtocol>

@property (nonatomic,strong) RecommendTimeLineObj *obj;

@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) UIImageView *BigImage;

@property (nonatomic,strong) UIScrollView *imageBgScrollView;

@property (nonatomic,strong) UIView *activityBgView;

@property (nonatomic,strong) UIButton *activityBtn;

@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,assign) BOOL drawed;

@property (nonatomic,strong) CMLTopMessageView *topMessageView;

@property (nonatomic,strong) UILabel *topicLab;

@end

@implementation CMLNewVipUseTimeLineTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
    
    self.topicLab = [[UILabel alloc] init];
    self.topicLab.backgroundColor = [[UIColor CMLBrownColor] colorWithAlphaComponent:0.2];
    self.topicLab.layer.borderColor = [UIColor CMLBrownColor].CGColor;
    self.topicLab.layer.borderWidth = 1;
    self.topicLab.font = KSystemFontSize12;
    self.topicLab.userInteractionEnabled = YES;
    self.topicLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topicLab];
    
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.textAlignment = NSTextAlignmentLeft;
    self.contentLab.font = KSystemFontSize14;
    self.contentLab.numberOfLines = 0;
    self.contentLab.textColor = [UIColor CMLBlackColor];
    [self addSubview:self.contentLab];
    
    self.BigImage = [[UIImageView alloc] init];
    self.BigImage.contentMode = UIViewContentModeScaleAspectFill;
    self.BigImage.clipsToBounds = YES;
    self.BigImage.backgroundColor = [UIColor CMLNewGrayColor];
    self.BigImage.userInteractionEnabled = YES;
    [self addSubview:self.BigImage];
    
    self.imageBgScrollView = [[UIScrollView alloc] init];
    self.imageBgScrollView.showsVerticalScrollIndicator = NO;
    self.imageBgScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.imageBgScrollView];
    
    self.activityBgView = [[UIView alloc] init];
    self.activityBgView.backgroundColor = [UIColor CMLNewActivityGrayColor];
    self.activityBgView.layer.borderWidth = 1*Proportion;
    self.activityBgView.layer.borderColor = [UIColor CMLPromptGrayColor].CGColor;;
    [self addSubview:self.activityBgView];
    
    self.activityBtn = [[UIButton alloc] init];
    self.activityBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.activityBtn];
    [self.activityBtn addTarget:self action:@selector(enterActivityVC) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.attentionBtn = [[UIButton alloc] init];
    [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
    [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
    [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateSelected];
    self.attentionBtn.titleLabel.font = KSystemFontSize11;
    self.attentionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.attentionBtn];
    [self.attentionBtn addTarget:self action:@selector(changeBtnStatus) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn = [[UIButton alloc] init];
    [self.commentBtn setContentMode:UIViewContentModeLeft];
    [self.commentBtn setImage:[UIImage imageNamed:UserTimelIneCommentImg] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = KSystemFontSize11;
    self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.commentBtn];
    [self.commentBtn addTarget:self action:@selector(enterDetail) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setContentMode:UIViewContentModeRight];
    [self.deleteBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = KSystemFontSize12;
    [self addSubview:self.deleteBtn];
    self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.deleteBtn addTarget:self action:@selector(deleteCurrentTimeLine) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:self.bottomLine];
    
}

- (void) refreshCurrentCellWith:(RecommendTimeLineObj *) obj atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.drawed) {
        
        return;
    }
    
    self.drawed = YES;
    
    self.obj = obj;
    
    self.topMessageView = [[CMLTopMessageView alloc] initWithObj:self.obj];
    self.topMessageView.frame = CGRectMake(0,
                                           0,
                                           WIDTH,
                                           130*Proportion);
    [self addSubview:self.topMessageView];

    
    self.contentLab.text = obj.content;
    
    
    CGRect currentRect = [self.contentLab.text boundingRectWithSize:CGSizeMake(WIDTH - (80*Proportion + 20*Proportion*3),HEIGHT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize14}
                                                            context:nil];
    self.contentLab.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                       130*Proportion,
                                       WIDTH - (80*Proportion + 20*Proportion*3),
                                       currentRect.size.height);
    
    if (self.obj.themeInfo) {
     
        if (self.isHasTopicBtn) {
            
            self.topicLab.text = self.obj.themeInfo.title;
            [self.topicLab sizeToFit];
            self.topicLab.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                             130*Proportion,
                                             self.topicLab.frame.size.width + 20*Proportion,
                                             self.topicLab.frame.size.height + 10*Proportion);
            [self.topicLab.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UIButton *enterBtn = [[UIButton alloc] initWithFrame:self.topicLab.bounds];
            enterBtn.backgroundColor = [UIColor clearColor];
            [self.topicLab addSubview:enterBtn];
            [enterBtn addTarget:self action:@selector(enterTopicDetailVC) forControlEvents:UIControlEventTouchUpInside];
            
            self.contentLab.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                               CGRectGetMaxY(self.topicLab.frame) + 10*Proportion,
                                               WIDTH - (80*Proportion + 20*Proportion*3),
                                               currentRect.size.height);
        }else{
            
            self.topicLab.frame = CGRectMake(0, 0, 0, 0);
        }

    }else{
        
        self.topicLab.frame = CGRectMake(0, 0, 0, 0);
    }
    
    
    if (obj.coverPicArr.count == 0) {
        
        self.BigImage.hidden = YES;
        self.imageBgScrollView.hidden = YES;
        
        [self loadActivity:CGRectGetMaxY(self.contentLab.frame)];
        
        
    }else if (obj.coverPicArr.count == 1){
        
        self.imageBgScrollView.hidden = YES;
        self.BigImage.hidden = NO;
        
        NSArray *targetArray = obj.coverPicArr;
        
        CMLImageObj *obj = [CMLImageObj getBaseObjFrom:[targetArray firstObject]];
        
        
        [NetWorkTask setImageView:self.BigImage WithURL:obj.coverPic placeholderImage:nil];
        
        
        if ([obj.ratio floatValue] < 3.0/4.0) {
            
            self.BigImage.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                             CGRectGetMaxY(self.contentLab.frame) + 10*Proportion,
                                             self.contentLab.frame.size.width,
                                             self.contentLab.frame.size.width/3*4);
            
        }else{
            
            self.BigImage.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                             CGRectGetMaxY(self.contentLab.frame) + 10*Proportion,
                                             self.contentLab.frame.size.width,
                                             self.contentLab.frame.size.width/[obj.ratio floatValue]);
        }
        
        [self loadActivity:CGRectGetMaxY(self.BigImage.frame)];
        
        
        UIButton *showBtn = [[UIButton alloc] initWithFrame:self.BigImage.bounds];
        showBtn.backgroundColor = [UIColor clearColor];
        showBtn.tag = 0;
        [showBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.BigImage addSubview:showBtn];
        
    }else{
        
        self.imageBgScrollView.hidden = NO;
        self.BigImage.hidden = YES;
        
        self.imageBgScrollView.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                                  CGRectGetMaxY(self.contentLab.frame) + 10*Proportion,
                                                  WIDTH - (80*Proportion + 20*Proportion*2),
                                                  300*Proportion);
        
        [self loadActivity:CGRectGetMaxY(self.imageBgScrollView.frame)];
        
        [self loadImages];
    }

}

- (void) clear{
    
    if (!self.drawed) {
        
        return;
    }
    
    
    [self.topMessageView removeFromSuperview];
    self.BigImage.frame = CGRectZero;
    self.BigImage.image = nil;
    self.contentLab.frame = CGRectZero;

    [self.imageBgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.drawed = NO;
}

- (void) setOtherBtn:(CGFloat) height{
    
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"%@",self.obj.likeNum] forState:UIControlStateNormal];
    [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",self.obj.commentCount] forState:UIControlStateNormal];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    
    if ([self.obj.isUserLike intValue] ==1) {
        
        self.attentionBtn.selected = YES;
    }else{
    
        self.attentionBtn.selected = NO;
    }
    

    self.attentionBtn.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                         height,
                                         90*Proportion,
                                         90*Proportion);
    
    
    
    self.commentBtn.frame = CGRectMake(CGRectGetMaxX(self.attentionBtn.frame) + 20*Proportion,
                                       height,
                                       90*Proportion,
                                       90*Proportion);
    
    if ([self.obj.userId intValue] == [[[DataManager lightData] readUserID] intValue]) {
        
        if (self.isAllReport) {
          
            self.deleteBtn.hidden = NO;
            [self.deleteBtn setTitle:@"" forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:ReportImg] forState:UIControlStateNormal];
            self.deleteBtn.frame = CGRectMake(WIDTH - 30*Proportion - 90*Proportion,
                                              height,
                                              90*Proportion,
                                              90*Proportion);
            
        }else{

            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.deleteBtn.hidden = NO;
            self.deleteBtn.frame = CGRectMake(WIDTH - 30*Proportion - 90*Proportion,
                                              height,
                                              90*Proportion,
                                              90*Proportion);
            
        }

    }else{
    
        self.deleteBtn.hidden = NO;
        [self.deleteBtn setTitle:@"" forState:UIControlStateNormal];
        [self.deleteBtn setImage:[UIImage imageNamed:ReportImg] forState:UIControlStateNormal];
        self.deleteBtn.frame = CGRectMake(WIDTH - 30*Proportion - 90*Proportion,
                                          height,
                                          90*Proportion,
                                          90*Proportion);
    }
    
    self.bottomLine.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                       height + 90*Proportion + 10*Proportion,
                                       WIDTH - (80*Proportion + 20*Proportion*2),
                                       1*Proportion);
    
    self.currentCellHeight = CGRectGetMaxY(self.commentBtn.frame) + 11*Proportion;
    
}

- (void) loadImages{

    [self.imageBgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *targetArray = self.obj.coverPicArr;
    
    CGFloat currentX = 0;
    for (int i = 0; i < targetArray.count; i++) {
        
        CMLImageObj *obj = [CMLImageObj getBaseObjFrom:targetArray[i]];
        
        UIImageView *module = [[UIImageView alloc] initWithFrame:CGRectMake(currentX,
                                                                            0,
                                                                            300*Proportion*[obj.ratio floatValue],
                                                                            300*Proportion)];
        module.contentMode = UIViewContentModeScaleAspectFill;
        module.userInteractionEnabled = YES;
        [self.imageBgScrollView addSubview:module];
        
        [NetWorkTask setImageView:module WithURL:obj.coverPicThumb placeholderImage:nil];
        
        UIButton *showBtn = [[UIButton alloc] initWithFrame:module.bounds];
        showBtn.backgroundColor = [UIColor clearColor];
        showBtn.tag = i;
        [showBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [module addSubview:showBtn];
        
        currentX += (20*Proportion + module.frame.size.width);
        
        if (i == targetArray.count - 1) {
            
            self.imageBgScrollView.contentSize = CGSizeMake(currentX, 300*Proportion);
        }
        
    }
    
}

- (void) loadActivity:(CGFloat) height{

    
    if ([self.obj.hadProjectInfoStatus intValue] == 1) {
        self.activityBgView.hidden =NO;
        self.activityBgView.frame = CGRectMake(80*Proportion + 20*Proportion*2,
                                               height + 10*Proportion,
                                               WIDTH - (80*Proportion + 20*Proportion*2) - 30*Proportion,
                                               130*Proportion);
        self.activityBtn.hidden = NO;
        self.activityBtn.frame = self.activityBgView.frame;
        
        [self loadActivityMessage];
        
        [self setOtherBtn:CGRectGetMaxY(self.activityBgView.frame)];
    }else{
    
        self.activityBtn.hidden = YES;
        self.activityBgView.hidden =YES;
        [self setOtherBtn:height];
    }

}

- (void) loadActivityMessage{

    [self.activityBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*Proportion,
                                                                               self.activityBgView.frame.size.height/2.0 - 90*Proportion/2.0,
                                                                               160*Proportion,
                                                                               90*Proportion)];
    activityImage.contentMode = UIViewContentModeScaleAspectFill;
    activityImage.clipsToBounds = YES;
    activityImage.backgroundColor = [UIColor CMLNewGrayColor];
    [self.activityBgView addSubview:activityImage];
    
    [NetWorkTask setImageView:activityImage WithURL:self.obj.linkProjectInfo.objCoverPic placeholderImage:nil];
    
    UILabel *titileLab = [[UILabel alloc] init];
    titileLab.numberOfLines = 2;
    titileLab.font = KSystemFontSize11;
    titileLab.text = self.obj.linkProjectInfo.title;
    titileLab.textColor = [UIColor CMLBlackColor];
    titileLab.textAlignment = NSTextAlignmentLeft;
    [titileLab sizeToFit];
    if (titileLab.frame.size.width > (self.activityBgView.frame.size.width - CGRectGetMaxX(activityImage.frame) - 20*Proportion*2)) {
        
        titileLab.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + 20*Proportion,
                                     activityImage.frame.origin.y,
                                     (self.activityBgView.frame.size.width - CGRectGetMaxX(activityImage.frame) - 20*Proportion*2),
                                     titileLab.frame.size.height*2);
    }else{
    
        titileLab.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + 20*Proportion,
                                     activityImage.frame.origin.y,
                                     (self.activityBgView.frame.size.width - CGRectGetMaxX(activityImage.frame) - 20*Proportion*2),
                                     titileLab.frame.size.height);
    }
    
    [self.activityBgView addSubview:titileLab];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = KSystemFontSize10;
    addressLab.textColor = [UIColor CMLtextInputGrayColor];
    addressLab.text = self.obj.linkProjectInfo.provinceName;

    addressLab.textAlignment = NSTextAlignmentLeft;
    [addressLab sizeToFit];
    addressLab.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + 20*Proportion,
                                  CGRectGetMaxY(activityImage.frame) - addressLab.frame.size.height,
                                  (self.activityBgView.frame.size.width - CGRectGetMaxX(activityImage.frame) - 20*Proportion*2),
                                  addressLab.frame.size.height);
    [self.activityBgView addSubview:addressLab];
    
    UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityEnterImg]];
    [enterImage sizeToFit];
    enterImage.frame = CGRectMake(self.activityBgView.frame.size.width - 10*Proportion - enterImage.frame.size.width,
                                  self.activityBgView.frame.size.height/2.0 - enterImage.frame.size.height/2.0,
                                  enterImage.frame.size.width,
                                  enterImage.frame.size.height);
    [self.activityBgView addSubview:enterImage];
    
}

- (void) showImage:(UIButton *) button{

    CMLVIPNewsImageShowVC *vc;
    
    NSArray *targetArray = self.obj.coverPicArr;
    
    NSMutableArray *newImageArray = [NSMutableArray array];

    for (int i = 0; i < targetArray.count; i++) {
        NSDictionary *targetDic = targetArray[i];
        [newImageArray addObject:[targetDic valueForKey:@"originPic"]];
    }
    vc = [[CMLVIPNewsImageShowVC alloc] initWithTag:(int) button.tag andImagesArray:newImageArray];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterUserDetail{

//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:self.obj.nickName
//                                                          currnetUserId:self.obj.userId
//                                                     isReturnUpOneLevel:YES];
//    
//    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) changeBtnStatus{

    self.attentionBtn.selected = !self.attentionBtn.selected;
    
    if (self.attentionBtn.selected) {
        
        int num = [self.attentionBtn.currentTitle intValue];
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
        [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
        [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    }else{
        
        int num = [self.attentionBtn.currentTitle intValue];
        self.attentionBtn.backgroundColor = [UIColor CMLWhiteColor];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikeBtnImg] forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:UserTimelIneLikedBtnImg] forState:UIControlStateSelected];
        [self.attentionBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
        [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
    }
    
    [self likeCurrent];
}

#pragma mark - likeCurrent
- (void) likeCurrent{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.obj.recordId forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:98] forKey:@"objTypeId"];
    if (!self.attentionBtn.selected) {
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.recordId,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:2],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }else{
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.recordId,
                                                               [NSNumber numberWithInt:98],
                                                               reqTime,
                                                               [NSNumber numberWithInt:1],
                                                               skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
    }
    
    [NetWorkTask postResquestWithApiName:LikeCurrent paraDic:paraDic delegate:delegate];
    
}

- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{


}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

}

- (void) enterActivityVC{

    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:self.obj.linkProjectInfo.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) deleteCurrentTimeLine{
    
    self.deleteTimeLine(self.obj.recordId);
}

- (void) refreshCurrentCellLikebtnStatus:(NSNumber *) status andNum:(int) number{

    if ([status intValue] == 1) {
        
        self.attentionBtn.selected = YES;
        
    }else{
    
        self.attentionBtn.selected = NO;
    }
    
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
    [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20*Proportion, 0, 0)];
}

- (void) enterDetail{
    
    CMLTimeLineDetailMessageVC *vc = [[CMLTimeLineDetailMessageVC alloc] initWithObj:self.obj.recordId];
    vc.cell = self;
    [[VCManger mainVC] pushVC:vc animate:YES];

}

- (void) enterTopicDetailVC{
    
    CMLUserTopicVC *vc = [[CMLUserTopicVC alloc] initWithObj:self.obj.themeInfo.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
