//
//  TopRecommendTopic.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "TopRecommendTopic.h"
#import "BaseResultObj.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CMLRecommendCommonModuleObj.h"
#import "VCManger.h"
#import "CMLSpecialTopicVC.h"
#import "CMLPicObjInfo.h"
#import "CMLTopicObj.h"
#import "CMLNewSpecialDetailTopicVC.h"
#import "CMLPicObjInfo.h"

#define MainInterfaceLeftMargin              30
#define MainInterfaceSpace                   30
#define MainInterfaceOtherSpace              60
#define MainInterfaceTopMargin               40
#define MainInterfaceTopImageHeight          120
#define MainInterfaceTopicImageHeight        420
#define MainInterfaceShortTitleTopMargin     10

@interface TopRecommendTopic ()<UIScrollViewDelegate>

@property (nonatomic,strong) BaseResultObj *recommenModuleObj;

@property (nonatomic,strong) UIView *scrollLineView;

@end
@implementation TopRecommendTopic

- (instancetype)initWith:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {

        self.recommenModuleObj = obj;
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    if (self.recommenModuleObj.retData.moduleTopic) {

        UILabel *topTitleLab = [[UILabel alloc] init];
        topTitleLab.text = @"精彩专题";
        topTitleLab.font = KSystemRealBoldFontSize18;
        topTitleLab.textColor = [UIColor CMLBlackColor];
        [topTitleLab sizeToFit];
        topTitleLab.frame = CGRectMake(WIDTH/2.0 - topTitleLab.frame.size.width/2.0,
                                       60*Proportion,
                                       topTitleLab.frame.size.width,
                                       topTitleLab.frame.size.height);
        [bgView addSubview:topTitleLab];
        
        UILabel *shortTitleLab = [[UILabel alloc] init];
        shortTitleLab.text = @"我们替你打包最新热门好享受";
        shortTitleLab.font = KSystemBoldFontSize12;
        [shortTitleLab sizeToFit];
        shortTitleLab.frame = CGRectMake(WIDTH/2.0 - shortTitleLab.frame.size.width/2.0,
                                         CGRectGetMaxY(topTitleLab.frame) + 30*Proportion,
                                         shortTitleLab.frame.size.width,
                                         shortTitleLab.frame.size.height);
        [bgView addSubview:shortTitleLab];

        
        
        UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                    CGRectGetMaxY(shortTitleLab.frame) + 60*Proportion,
                                                                                    WIDTH,
                                                                                    WIDTH/16*9)];
        bgScrollView.showsVerticalScrollIndicator = NO;
        bgScrollView.showsHorizontalScrollIndicator = NO;
        bgScrollView.pagingEnabled = YES;
        bgScrollView.delegate = self;
        bgScrollView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:bgScrollView];
        
       
        
        for (int i = 0; i < self.recommenModuleObj.retData.moduleTopic.dataList.count; i++) {
            
            
            CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.recommenModuleObj.retData.moduleTopic.dataList[i]];
            
            UIImageView *topicImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                    0,
                                                                                    WIDTH,
                                                                                    WIDTH/16*9)];
            topicImage.userInteractionEnabled = YES;
            topicImage.contentMode = UIViewContentModeScaleAspectFill;
            topicImage.clipsToBounds = YES;
            [NetWorkTask setImageView:topicImage WithURL:currentObj.coverPic placeholderImage:nil];
            [bgScrollView addSubview:topicImage];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                       0,
                                                                       WIDTH,
                                                                       WIDTH/16*9)];
            btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            btn.tag = i + 1;
            [bgScrollView addSubview:btn];
            [btn addTarget:self action:@selector(enterTopicDetailVC:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = KSystemBoldFontSize17;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = currentObj.title;
            titleLabel.numberOfLines = 1;
            [titleLabel sizeToFit];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.frame = CGRectMake(WIDTH/2.0 - titleLabel.frame.size.width/2.0,
                                          165*Proportion,
                                          titleLabel.frame.size.width,
                                          titleLabel.frame.size.height);
            [btn addSubview:titleLabel];
            
            UILabel *descLabel = [[UILabel alloc] init];
            descLabel.font = KSystemFontSize13;
            descLabel.backgroundColor = [UIColor clearColor];
            descLabel.textColor = [UIColor whiteColor];
            descLabel.text = currentObj.shortTitle;
            descLabel.numberOfLines = 1;
            [descLabel sizeToFit];
            descLabel.textAlignment = NSTextAlignmentCenter;
            descLabel.frame = CGRectMake(WIDTH/2.0 - descLabel.frame.size.width/2.0,
                                         CGRectGetMaxY(titleLabel.frame) + 30*Proportion,
                                         descLabel.frame.size.width,
                                         descLabel.frame.size.height);
            [btn addSubview:descLabel];
            
            if (i == self.recommenModuleObj.retData.moduleTopic.dataList.count - 1) {
                
                bgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), bgScrollView.frame.size.height);
            }
        }
        

        
        UIView *pageControlView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 635*Proportion/2.0,
                                                                           CGRectGetMaxY(bgScrollView.frame) - 42*Proportion - 6*Proportion,
                                                                           635*Proportion,
                                                                           6*Proportion)];
        pageControlView.layer.cornerRadius = 6*Proportion/2.0;
        pageControlView.backgroundColor = [[UIColor CMLSerachLineGrayColor] colorWithAlphaComponent:0.5];
        [bgView addSubview:pageControlView];
        
        self.scrollLineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       635*Proportion/self.recommenModuleObj.retData.moduleTopic.dataList.count,
                                                                       6*Proportion)];
        self.scrollLineView.backgroundColor = [UIColor CMLScrollLineWhiterColor];
        self.scrollLineView.layer.cornerRadius = 6*Proportion/2.0;
        [pageControlView addSubview:self.scrollLineView];
        
        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(bgScrollView.frame) + 40*Proportion,
                                                                      WIDTH,
                                                                      20*Proportion)];
        bottomView.backgroundColor = [UIColor CMLNewUserGrayColor];
        [bgView addSubview:bottomView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = KSystemRealBoldFontSize18;
        titleLab.text = @"全球最IN";
        [titleLab sizeToFit];
        titleLab.frame = CGRectMake(WIDTH/2.0 - titleLab.frame.size.width/2.0,
                                    60*Proportion + CGRectGetMaxY(bottomView.frame),
                                    titleLab.frame.size.width,
                                    titleLab.frame.size.height);
        [bgView addSubview:titleLab];
        
        UILabel *descLab = [[UILabel alloc] init];
        descLab.font = KSystemBoldFontSize12;
        descLab.text = @"为你收集全球最in动态与活动";
        [descLab sizeToFit];
        descLab.frame = CGRectMake(WIDTH/2.0 - descLab.frame.size.width/2.0,
                                   CGRectGetMaxY(titleLab.frame) + 30*Proportion,
                                   descLab.frame.size.width,
                                   descLab.frame.size.height);
        [bgView addSubview:descLab];

        
        bgView.frame = CGRectMake(0,
                                  0,
                                  WIDTH,
                                  CGRectGetMaxY(descLab.frame) + 60*Proportion);
        
        self.currentHeight = bgView.frame.size.height;
        

    }else{
        
        self.hidden = YES;
        bgView.frame = CGRectMake(0,
                                  0,
                                  WIDTH,
                                  0);
        
        self.currentHeight = bgView.frame.size.height;
    }


}


- (void) enterTopicDetailVC:(UIButton *) btn{

   CMLTopicObj *currentObj = [CMLTopicObj getBaseObjFrom:self.recommenModuleObj.retData.moduleTopic.dataList[btn.tag - 1]];
    
    CMLNewSpecialDetailTopicVC *vc = [[CMLNewSpecialDetailTopicVC alloc] initWithCurrentId:currentObj.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
      
        weakSelf.scrollLineView.frame = CGRectMake(scrollView.contentOffset.x/WIDTH*(635*Proportion/self.recommenModuleObj.retData.moduleTopic.dataList.count),
                                                   0,
                                                   self.scrollLineView.frame.size.width,
                                                   self.scrollLineView.frame.size.height);
    }];
}
@end
