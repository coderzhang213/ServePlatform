//
//  CMLChildPrefectureView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/10/22.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLChildPrefectureView.h"
#import "CMLPrefectureVC.h"
#import "ChildPrefectureModel.h"
#import "ChildPrefectureDetailModel.h"
#import "CMLLine.h"
#import "VCManger.h"

#define LeftMargin       30
#define TopMargin        40
#define VideoViewHeight  360

@interface CMLChildPrefectureView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *realScrollView;

@property (nonatomic, strong) UIScrollView *suspendScrollView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) BaseResultObj *obj;

@end

@implementation CMLChildPrefectureView

- (instancetype)initWithObj:(BaseResultObj *)obj
{
    self = [super init];
    if (self) {
        self.dataArray = obj.retData.childZone.dataList;
        self.obj = obj;
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = self.obj.retData.childZone.dataInfo.ModuleName;
    NSLog(@"%@", self.obj.retData.childZone.dataInfo.ModuleName);
    nameLab.font = KSystemBoldFontSize14;
    nameLab.textColor = [UIColor CMLBlackColor];
    [nameLab sizeToFit];
    nameLab.frame = CGRectMake(LeftMargin*Proportion,
                               TopMargin*Proportion,
                               nameLab.frame.size.width,
                               nameLab.frame.size.height);
    [self addSubview:nameLab];
    
    /*标题装饰*/
    UIImageView *decorateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PreffectureDecorateImg]];
    [decorateImage sizeToFit];
    decorateImage.frame = CGRectMake(CGRectGetMaxX(nameLab.frame) + 10*Proportion,
                                     nameLab.center.y - decorateImage.frame.size.height/2.0,
                                     decorateImage.frame.size.width,
                                     decorateImage.frame.size.height);
    [self addSubview:decorateImage];
    
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
    
    [self initChildView];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.suspendScrollView) {
        [self.realScrollView setContentOffset:CGPointMake((CGFloat)((324 * 640 / 360 * Proportion) + 20 * Proportion) * self.suspendScrollView.contentOffset.x/WIDTH, 0)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.suspendScrollView) {
        [self addChildViewBiggerIndex:self.suspendScrollView.contentOffset.x/WIDTH];
        [self.realScrollView setContentOffset:CGPointMake(self.suspendScrollView.contentOffset.x/WIDTH*(640*Proportion + 20*Proportion), 0)];
    }
}

- (void)initChildView {
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor CMLPromptGrayColor];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        ChildPrefectureDetailModel *model = [ChildPrefectureDetailModel getBaseObjFrom:self.dataArray[i]];
        [NetWorkTask setImageView:view WithURL:model.coverPic placeholderImage:nil];
        view.tag = i + 1;
        view.layer.cornerRadius = 8*Proportion;
        
        if (i == 0){
            view.frame = CGRectMake(30*Proportion + 20*Proportion,
                                    0,
                                    640*Proportion,
                                    VideoViewHeight*Proportion);
            
        }else{
            view.frame = CGRectMake(30*Proportion + 20*Proportion + (i - 1)*((324*640/360*Proportion) + 20*Proportion) + 640*Proportion + 20*Proportion ,
                                    VideoViewHeight*Proportion/2.0 - 324*Proportion/2.0,
                                    (324*640/360*Proportion),
                                    324*Proportion);
            
        }
        
        [self.realScrollView addSubview:view];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                        0,
                                                                        WIDTH,
                                                                        VideoViewHeight*Proportion)];
        enterBtn.backgroundColor = [UIColor clearColor];
        enterBtn.tag = view.tag;
        [self.suspendScrollView addSubview:enterBtn];
        [enterBtn addTarget:self action:@selector(enterChildPrefectureWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)enterChildPrefectureWithButton:(UIButton *)button {
    CMLPrefectureVC *vc = [[CMLPrefectureVC alloc] init];
    ChildPrefectureDetailModel *model = [ChildPrefectureDetailModel getBaseObjFrom:self.dataArray[button.tag - 1]];
    vc.currentID = model.currentID;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void)addChildViewBiggerIndex:(int)index {
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
