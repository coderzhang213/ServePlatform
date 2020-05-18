//
//  DetailMessageCommentListView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "DetailMessageCommentListView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "TImeLineCommentObj.h"
#import "CommentListObj.h"
#import "CommemtListVC.h"
#import "VCManger.h"
#import "CMLVIPNewDetailVC.h"
#import "DataManager.h"

@interface DetailMessageCommentListView ()<NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIView *topNumView;
@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,assign) int currentNum;
@end

@implementation DetailMessageCommentListView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {
       
        self.obj = obj;
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               20*Proportion)];
    topView.backgroundColor = [UIColor CMLNewActivityGrayColor];
    [self addSubview:topView];
    self.topNumView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               20*Proportion,
                                                               WIDTH,
                                                               86*Proportion)];
    self.topNumView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.topNumView];
    
    UILabel *promLab = [[UILabel alloc] init];
    promLab.font = KSystemFontSize13;
    promLab.text = @"评论";
    [promLab sizeToFit];
    promLab.frame = CGRectMake(20*Proportion,
                               86*Proportion/2.0 - promLab.frame.size.height/2.0,
                               promLab.frame.size.width,
                               promLab.frame.size.height);
    [self.topNumView addSubview:promLab];
    
    self.currentNum = [self.obj.retData.commentCount intValue];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = KSystemFontSize13;
    self.numLab.text = [NSString stringWithFormat:@"(%d)",self.currentNum];
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(CGRectGetMaxX(promLab.frame) + 20*Proportion,
                                   86*Proportion/2.0 - self.numLab.frame.size.height/2.0,
                                   self.numLab.frame.size.width,
                                   self.numLab.frame.size.height);
    [self.topNumView addSubview:self.numLab];
    
        
    if (self.obj.retData.commentInfo.dataList.count > 0) {
        
        [self loadComments];
        
    }else{
        
        [self loadNoMessageView];
    }
}

- (void) loadComments{

    CGFloat currentHeight = CGRectGetMaxY(self.topNumView.frame);
    
    NSArray *dataArray = self.obj.retData.commentInfo.dataList;
    
    for (int i = 0; i < dataArray.count; i++) {
        
        UIView *moduleView = [[UIView alloc] init];
        [self addSubview:moduleView];
        
        TImeLineCommentObj *obj = [TImeLineCommentObj getBaseObjFrom:dataArray[i]];
        
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                               30*Proportion,
                                                                               80*Proportion,
                                                                               80*Proportion)];
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        userImage.layer.cornerRadius = 80*Proportion/2.0;
        userImage.clipsToBounds = YES;
        [moduleView addSubview:userImage];
        userImage.userInteractionEnabled = YES;
        [NetWorkTask setImageView:userImage WithURL:obj.userHeadImg placeholderImage:nil];
        
        
        UIButton *enterBtn  =[[UIButton alloc] initWithFrame:userImage.bounds];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = i;
        [userImage addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *userNickName = [[UILabel alloc] init];
        userNickName.font = KSystemFontSize13;
        userNickName.text = obj.userNickName;
        [userNickName sizeToFit];
        userNickName.frame = CGRectMake(CGRectGetMaxX(userImage.frame) +20*Proportion,
                                        userImage.center.y - 10*Proportion/2.0 - userNickName.frame.size.height,
                                        userNickName.frame.size.width,
                                        userNickName.frame.size.height);
        [moduleView addSubview:userNickName];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:CommentLikeImg] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:CommentLikedImg] forState:UIControlStateSelected];
        [btn sizeToFit];
        btn.frame = CGRectMake( WIDTH - 20*Proportion - btn.frame.size.width,
                               userImage.center.y - btn.frame.size.height/2.0,
                               btn.frame.size.width,
                               btn.frame.size.height);
        [moduleView addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([obj.isUserLike intValue] == 1) {
            btn.selected = YES;
        }else{
        
            btn.selected = NO;
        }
        
        
        
        UILabel *numLab = [[UILabel alloc] init];
        numLab.font = KSystemFontSize11;
        numLab.text = [NSString stringWithFormat:@"%@",obj.likeNum];
        numLab.textColor = [UIColor CMLBlackColor];
        [numLab sizeToFit];
        numLab.frame = CGRectMake(btn.frame.origin.x - 10*Proportion - numLab.frame.size.width,
                                  CGRectGetMaxY(btn.frame)- numLab.frame.size.height,
                                  numLab.frame.size.width,
                                  numLab.frame.size.height);
        [moduleView addSubview:numLab];
        numLab.tag = 100 +i;
        
        
        UILabel *pushTimeStr = [[UILabel alloc] init];
        pushTimeStr.text = obj.postTimeStr;
        pushTimeStr.font = KSystemFontSize11;
        pushTimeStr.textColor = [UIColor CMLtextInputGrayColor];
        [pushTimeStr sizeToFit];
        pushTimeStr.frame = CGRectMake(CGRectGetMaxX(userImage.frame) +20*Proportion,
                                       CGRectGetMaxY(userNickName.frame) + 10*Proportion,
                                       pushTimeStr.frame.size.width,
                                       pushTimeStr.frame.size.height);
        [moduleView addSubview:pushTimeStr];
        
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.font = KSystemFontSize13;
        contentLab.numberOfLines = 0;
        contentLab.text = obj.comment;
         CGRect currentRect = [contentLab.text boundingRectWithSize:CGSizeMake(WIDTH - 20*Proportion*3 - userImage.frame.size.width, HEIGHT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                            context:nil];
        contentLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                      CGRectGetMaxY(userImage.frame) + 10*Proportion,
                                      WIDTH - 20*Proportion*3 - userImage.frame.size.width,
                                      currentRect.size.height);
        [moduleView addSubview:contentLab];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame) +20*Proportion,
                                                                      CGRectGetMaxY(contentLab.frame) + 30*Proportion,
                                                                      WIDTH - CGRectGetMaxX(userImage.frame) - 20*Proportion,
                                                                      1*Proportion)];
        bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
        [moduleView addSubview:bottomLine];
        
        moduleView.frame = CGRectMake(0,
                                      currentHeight,
                                      WIDTH,
                                      CGRectGetMaxY(bottomLine.frame));
        
        if (i == 0) {
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          WIDTH,
                                                                          1*Proportion)];
            bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
            [moduleView addSubview:bottomLine];
        }
        
        currentHeight += moduleView.frame.size.height;
        
        
        if (i == dataArray.count - 1) {
            
            if ([self.obj.retData.commentCount integerValue] > self.obj.retData.commentInfo.dataList.count) {
                
                UIButton *endLab = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(self.topNumView.frame),
                                                                              WIDTH,
                                                                              90*Proportion)];
                endLab.titleLabel.font = KSystemFontSize11;
                [endLab setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
                [endLab setTitle:[NSString stringWithFormat:@"查看全部%@条评论",self.obj.retData.commentCount] forState:UIControlStateNormal];
                [self addSubview:endLab];
                [endLab addTarget:self action:@selector(enterCommentListVC) forControlEvents:UIControlEventTouchUpInside];
                endLab.frame = CGRectMake(0,
                                          currentHeight,
                                          WIDTH,
                                          90*Proportion);
                
                self.currentHeight = CGRectGetMaxY(endLab.frame) + 50*Proportion;
                
            }else{
            
                self.currentHeight = currentHeight + 50*Proportion;
            }
        }
    }
}

- (void) loadNoMessageView{
    


    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topNumView.frame), WIDTH, 90*Proportion)];
    endLab.font = KSystemFontSize13;
    endLab.textColor = [UIColor CMLtextInputGrayColor];
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.text = @"暂无评论";
    [self addSubview:endLab];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  1*Proportion)];
    bottomLine.backgroundColor = [UIColor CMLNewGrayColor];
    [endLab addSubview:bottomLine];
    
    self.currentHeight = CGRectGetMaxY(endLab.frame) + 50*Proportion;
}

- (void) enterCommentListVC{

    CommemtListVC *vc =[[CommemtListVC alloc] initWithObjType:[NSNumber numberWithInt:98] currentID:self.obj.retData.recordId isActivity:NO isfromActivityBanner:NO];
    [[VCManger mainVC]pushVC:vc animate:YES];
}

- (void) changeStatus:(UIButton *) btn{

    btn.selected = !btn.selected;
    
    UIView *superView = btn.superview;
    
    UILabel *numLab = [superView viewWithTag:btn.tag + 100];
    
    TImeLineCommentObj *obj = [TImeLineCommentObj getBaseObjFrom:self.obj.retData.commentInfo.dataList[btn.tag]];
    
    if (btn.selected) {
        numLab.text = [NSString stringWithFormat:@"%d",[numLab.text intValue] + 1];
        [numLab sizeToFit];
        numLab.frame = CGRectMake(btn.frame.origin.x - 10*Proportion - numLab.frame.size.width,
                                  CGRectGetMaxY(btn.frame)- numLab.frame.size.height,
                                  numLab.frame.size.width,
                                  numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:1] andId:obj.currentID];
    }else{
        numLab.text = [NSString stringWithFormat:@"%d",[numLab.text intValue] - 1];
        [numLab sizeToFit];
        numLab.frame = CGRectMake(btn.frame.origin.x - 10*Proportion - numLab.frame.size.width,
                                  CGRectGetMaxY(btn.frame)- numLab.frame.size.height,
                                  numLab.frame.size.width,
                                  numLab.frame.size.height);
        [self likeCurrent:[NSNumber numberWithInt:2] andId:obj.currentID];
    }
    
}
#pragma mark - likeCurrent
- (void) likeCurrent:(NSNumber *) status andId:(NSNumber *) currentID{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"likeTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:97] forKey:@"objTypeId"];
    [paraDic setObject:status forKey:@"actType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[currentID,
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

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

}


- (void) enterDetailVC:(UIButton *) btn{
    
    TImeLineCommentObj *obj = [TImeLineCommentObj getBaseObjFrom:self.obj.retData.commentInfo.dataList[btn.tag]];
    
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:obj.nickName currnetUserId:obj.userId isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
