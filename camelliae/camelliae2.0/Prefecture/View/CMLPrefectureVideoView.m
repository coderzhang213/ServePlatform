//
//  CMLPrefectureVideoView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLPrefectureVideoView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "VCManger.h"
#import "CMLLine.h"
#import "BaseResultObj.h"
#import "VideoInfo.h"
#import "VideoDetailInfoObj.h"
#import "NetWorkTask.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CMLVideoListVC.h"
#import "CMLPlayVideoViewController.h"

#define LeftMargin       30
#define TopMargin        40
#define VideoViewHeight  360


@interface CMLPrefectureVideoView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *realScrollView;

@property (nonatomic,strong) UIScrollView *suspendScrollView;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLPrefectureVideoView

- (instancetype)initWithObj:(BaseResultObj *)obj{

    self = [super init];
    if (self) {
      
        self.dataArray = obj.retData.videoInfoModule.dataList;
        
        self.obj = obj;
        
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.videoInfoModule.dataInfo.ModuleName;
    nameLab.font = KSystemBoldFontSize14;
    nameLab.textColor = [UIColor CMLBlackColor];
    [nameLab sizeToFit];
    nameLab.frame = CGRectMake(LeftMargin*Proportion,
                               TopMargin*Proportion,
                               nameLab.frame.size.width,
                               nameLab.frame.size.height);
    [self addSubview:nameLab];
    
    UIImageView *decorateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PreffectureDecorateImg]];
    [decorateImage sizeToFit];
    decorateImage.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + 10*Proportion,
                                     nameLab.center.y - decorateImage.frame.size.height/2.0,
                                     decorateImage.frame.size.width,
                                     decorateImage.frame.size.height);
    [self addSubview:decorateImage];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:PrefectureMoreMessageImg] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = KSystemFontSize12;
    [moreBtn sizeToFit];
    CGSize strSize1 = [moreBtn.currentTitle sizeWithFontCompatible:KSystemFontSize12];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                 - moreBtn.currentImage.size.width - 5*Proportion,
                                                 0,
                                                 0)];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                 strSize1.width + moreBtn.currentImage.size.width + 5*Proportion,
                                                 0,
                                                 0)];
    moreBtn.frame = CGRectMake(WIDTH - moreBtn.frame.size.width - 20*Proportion*2 - LeftMargin*Proportion,
                               nameLab.center.y - moreBtn.frame.size.height/2.0,
                               moreBtn.frame.size.width + 20*Proportion*2,
                               moreBtn.frame.size.height);
    [self addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(enterVideoListVC) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.obj.retData.videoInfoModule.dataCount intValue] <= self.dataArray.count) {
        moreBtn.hidden = YES;
    }
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(nameLab.frame) + 20*Proportion);
    line.lineLength = WIDTH - LeftMargin*Proportion*2;
    line.lineWidth = 1;
    line.LineColor = [UIColor CMLNewGrayColor];
    [self addSubview:line];

    
    self.realScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(nameLab.frame) + TopMargin*Proportion,
                                                                         WIDTH,
                                                                         VideoViewHeight*Proportion)];
    self.realScrollView.contentSize = CGSizeMake(640*Proportion + (324*640/360*Proportion)*(self.dataArray.count - 1) + (self.dataArray.count + 1)*20*Proportion + 30*Proportion*2, VideoViewHeight*Proportion);
    self.realScrollView.showsVerticalScrollIndicator = NO;
    self.realScrollView.showsHorizontalScrollIndicator = NO;
    self.realScrollView.userInteractionEnabled = YES;
    self.realScrollView.delegate = self;
    [self addSubview:self.realScrollView];
    
    self.suspendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                            CGRectGetMaxY(nameLab.frame) + TopMargin*Proportion,
                                                                            WIDTH,
                                                                            VideoViewHeight*Proportion)];
    self.suspendScrollView.contentSize = CGSizeMake(WIDTH*self.dataArray.count, VideoViewHeight*Proportion);
    self.suspendScrollView.pagingEnabled = YES;
    self.suspendScrollView.delegate = self;
    self.suspendScrollView.backgroundColor = [UIColor clearColor];
    self.suspendScrollView.userInteractionEnabled = YES;
    self.suspendScrollView.showsHorizontalScrollIndicator = NO;
    self.suspendScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.suspendScrollView];
    
    [self initVideoView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.realScrollView.frame) + TopMargin*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:bottomView];
    
    self.viewHeight = CGRectGetMaxY(bottomView.frame);
    
    if (self.dataArray.count == 0) {
        
        self.viewHeight = 0;
        self.hidden = YES;
    }
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.suspendScrollView) {
        
        [self.realScrollView setContentOffset:CGPointMake( (CGFloat)((324*640/360*Proportion) + 20*Proportion)*self.suspendScrollView.contentOffset.x/WIDTH, 0)];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.suspendScrollView) {
        
        [self addVideoViewBiggerIndex:self.suspendScrollView.contentOffset.x/WIDTH];
        [self.realScrollView setContentOffset:CGPointMake(self.suspendScrollView.contentOffset.x/WIDTH*(640*Proportion + 20*Proportion), 0)];
    }
}

- (void) initVideoView{

    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor CMLPromptGrayColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        VideoDetailInfoObj *obj = [VideoDetailInfoObj getBaseObjFrom:self.dataArray[i]];
        [NetWorkTask setImageView:view WithURL:obj.coverPic placeholderImage:nil];
        view.tag = i + 1;
        view.layer.cornerRadius = 8*Proportion;
       
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor CMLWhiteColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.7];
        titleLab.tag = 100;
        titleLab.text = obj.title;
        titleLab.font =KSystemBoldFontSize14;
        
       if (i == 0){
           
            view.frame = CGRectMake(30*Proportion + 20*Proportion,
                                    0,
                                    640*Proportion,
                                    VideoViewHeight*Proportion);
           titleLab.frame = CGRectMake(0,
                                       VideoViewHeight*Proportion - 60*Proportion,
                                       640*Proportion,
                                       60*Proportion);
        }else{
            
            view.frame = CGRectMake(30*Proportion + 20*Proportion + (i - 1)*((324*640/360*Proportion) + 20*Proportion) + 640*Proportion + 20*Proportion ,
                                    VideoViewHeight*Proportion/2.0 - 324*Proportion/2.0,
                                    (324*640/360*Proportion),
                                    324*Proportion);
            titleLab.frame = CGRectMake(0,
                                        324*Proportion - 60*Proportion,
                                        (324*640/360*Proportion),
                                        60*Proportion);
        }
        
        [view addSubview:titleLab];
        [self.realScrollView addSubview:view];
    
        
    
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                        0,
                                                                        WIDTH,
                                                                        VideoViewHeight*Proportion)];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = view.tag;
        [self.suspendScrollView addSubview:enterBtn];
        [enterBtn setImage:[UIImage imageNamed:PrefectureImg] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];

    }

}

- (void) addVideoViewBiggerIndex:(int) index{

    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIImageView *view = [self.realScrollView viewWithTag:i+1];
        UILabel *lab = [view viewWithTag:100];
        __weak typeof(view) weakView = view;
        
        [UIView animateWithDuration:0.3 animations:^{
            
        if (i < index) {
        
            weakView.frame = CGRectMake(30*Proportion + 20*Proportion + ((324*640/360*Proportion) + 20*Proportion)*i,
                                        VideoViewHeight*Proportion/2.0 - 324*Proportion/2.0 ,
                                        (324*640/360*Proportion),
                                        324*Proportion);
            lab.frame = CGRectMake(0,
                                   324*Proportion - 60*Proportion,
                                   (324*640/360*Proportion),
                                   60*Proportion);
            
        }else if (i == index){
        
                weakView.frame = CGRectMake(30*Proportion + 20*Proportion + index*((324*640/360*Proportion) + 20*Proportion),
                                            0,
                                            640*Proportion,
                                            VideoViewHeight*Proportion);
            
                lab.frame = CGRectMake(0,
                                       VideoViewHeight*Proportion - 60*Proportion,
                                       640*Proportion,
                                       60*Proportion);

        }else{
        
            weakView.frame = CGRectMake(30*Proportion + 20*Proportion + (i - 1)*((324*640/360*Proportion) + 20*Proportion) + 640*Proportion + 20*Proportion ,
                                        VideoViewHeight*Proportion/2.0 - 324*Proportion/2.0,
                                        (324*640/360*Proportion),
                                        324*Proportion);
            
            lab.frame = CGRectMake(0,
                                   324*Proportion - 60*Proportion,
                                   (324*640/360*Proportion),
                                   60*Proportion);
        }
            
        } ];
    }
}

#pragma mark - video

- (void)playVideo:(UIButton *) button {
    VideoDetailInfoObj *obj = [VideoDetailInfoObj getBaseObjFrom:self.dataArray[button.tag - 1]];
    NSLog(@"%@", obj.urlLink);
//    [self openmovie:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    CMLPlayVideoViewController *vc = [[CMLPlayVideoViewController alloc] initWithHTTPMediaURL:[NSURL URLWithString:obj.urlLink]];
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) enterVideoListVC{

    CMLVideoListVC *vc = [[CMLVideoListVC alloc] initWithID:self.obj.retData.videoInfoModule.dataInfo.parentZoneModuleId
                                                   andTitle:self.obj.retData.videoInfoModule.dataInfo.ModuleName];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
