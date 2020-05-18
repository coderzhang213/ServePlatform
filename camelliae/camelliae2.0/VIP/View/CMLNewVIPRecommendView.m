//
//  CMLNewVIPRecommendView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLNewVIPRecommendView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "NSString+CMLExspand.h"
#import "DataManager.h"
#import "UIColor+SDExspand.h"
#import "BannerObj.h"
#import "UIImage+CMLExspand.h"
#import "CMLLine.h"
#import "CMLVIPNewDetailVC.h"
#import "VCManger.h"
#import "RecommendTimeLineObj.h"
#import "VIPImageObj.h"
#import "VIPDetailObj.h"
#import "CMLPageControl.h"
#import "CMLBannerObj.h"
#import "WebViewLinkVC.h"
#import "InformationDefaultVC.h"
#import "CMLTimeLineDetailMessageVC.h"
#import "CMLUserProjectDetailVC.h"
#import "CMLUserArticleVC.h"
#import "CMLVIPTopicListVC.h"
#import "CMLNewArticleListVC.h"
#import "CMLUserTopicVC.h"
#import "CMLNewSelectTypeView.h"
#import "RollView.h"
#import "CMLModuleObj.h"
#import "CMLUserPushActivityDetailVC.h"
#import "CMLUserPushServeDetailVC.h"
#import "CMLUserPushGoodsVC.h"

#define CMLOtherMessageScroHeight                360
#define CMLCenterViewHeight                      92
#define CMLVIPRecommendLeftMargin                20


@interface CMLNewVIPRecommendView ()<NetWorkProtocol,UIScrollViewDelegate,CMLVIPNewDetailDlegate,CMLNewSelectTypeViewDelegate,RollViewDelegate>


@property (nonatomic,strong) CMLLine *line;

@property (nonatomic,strong) RollView *rollView;

@property (nonatomic,strong) UIScrollView *recommendUserScrollView;

@property (nonatomic,strong) CMLNewSelectTypeView *selectTypeView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@end


@implementation CMLNewVIPRecommendView

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self loadMianViews];
    }
    return self;
}

- (void) loadMianViews{
    
    self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               WIDTH,
                                                               CMLOtherMessageScroHeight*Proportion)
                              withDistanceForScroll:30*Proportion
                                            withGap:10*Proportion];
    self.rollView.radius = 6*Proportion;
    self.rollView.backgroundColor = [UIColor CMLWhiteColor];
    self.rollView.delegate = self;
    [self.rollView rollView:@[@"1",@"2",@"3"]];
    [self addSubview:self.rollView];
    
    
        
    self.selectTypeView = [[CMLNewSelectTypeView alloc] initWithFrame:CGRectMake(0,
                                                                            CGRectGetMaxY(self.rollView.frame),
                                                                                 WIDTH,
                                                                                 80*Proportion)
                                                    andTypeNamesArray:@[@"全部",
                                                                        @"活动",
                                                                        @"商品"]];
    self.selectTypeView.currentSelectIndex = self.currentSelectIndex;
    [self.selectTypeView refreshNewTypeViews];
    self.selectTypeView.delegate = self;
    [self addSubview:self.selectTypeView];

        
    self.frame = CGRectMake(0,
                            0,
                            WIDTH,
                            CGRectGetMaxY(self.selectTypeView.frame));
     self.selctTopY = CGRectGetMaxY(self.rollView.frame);
    
}

- (void) refreshRecommendView{
    
    for (int i = 0 ; i < self.recommend.retData.dataList.count; i++) {
     
        CMLModuleObj *obj = [CMLModuleObj getBaseObjFrom:self.recommend.retData.dataList[i]];
        
        [self.imageArray addObject:obj.coverPic];
        
    }
    
    [self.rollView rollView:self.imageArray];
    
    self.selectTypeView.currentSelectIndex = self.currentSelectIndex;
    [self.selectTypeView refreshNewTypeViews];
    
}



- (void) setAttentionVIPMemberRequest:(NSNumber *) actType andUserId:(NSNumber *) userId{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
    [paraDic setObject:userId forKey:@"userId"];
    [paraDic setObject:actType forKey:@"actType"];
    [paraDic setObject:[[DataManager lightData] readSkey] forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:1],userId,actType,reqTime,[[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:AttentionVIPMember paraDic:paraDic delegate:delegate];
    
}


- (void) refreshCurrentViewController{
    
    [self.delegate refreshCurrentVC];
}

-(void)didSelectPicWithIndexPath:(NSInteger)index{
    
    CMLBannerObj *obj = [CMLBannerObj getBaseObjFrom:self.recommend.retData.dataList[index]];
    
    
    if ([obj.objType intValue] == 2){
        
        
                CMLUserPushActivityDetailVC *vc = [[CMLUserPushActivityDetailVC alloc] initWithObjId:obj.objId];
                [[VCManger mainVC] pushVC:vc animate:YES];

        
        }else if ([obj.objType intValue] == 3){
            
            CMLUserPushServeDetailVC *vc = [[CMLUserPushServeDetailVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else if ([obj.objType intValue] == 7){
            
            
            CMLUserPushGoodsVC *vc = [[CMLUserPushGoodsVC alloc] initWithObjId:obj.objId];
            [[VCManger mainVC] pushVC:vc animate:YES];
        }
}

- (void) scrollX:(CGFloat) x{
    
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{


}

#pragma mark - CMLNewSelectTypeViewDelegate
- (void) newSelectTypeViewSelect:(int) index{
    
    [self.delegate selectListIndex:index];
}


@end
