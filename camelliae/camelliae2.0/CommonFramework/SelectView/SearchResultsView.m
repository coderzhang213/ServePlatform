//
//  SearchResultsView.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "SearchResultsView.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "SearchVIPMemberView.h"
#import "SearchInformationView.h"
#import "SearchActivityView.h"
#import "SearchServeView.h"
#import "SerachGoodsView.h"

@interface SearchResultsView ()

@property (nonatomic,strong) UIScrollView *resultsScrollView;

@property (nonatomic,assign) int informationCount;

@property (nonatomic,assign) int activityCount;

@property (nonatomic,assign) int serveCount;

@property (nonatomic,assign) int VIPMemberCount;

@property (nonatomic,assign) int goodsCount;

@property (nonatomic,strong) NSArray *informationArray;

@property (nonatomic,strong) NSArray *activityArray;

@property (nonatomic,strong) NSArray *serveArray;

@property (nonatomic,strong) NSArray *VIPMemberArray;

@property (nonatomic,strong) NSArray *goodsArray;

@property (nonatomic,strong) UIView *noMessageView;



@end

@implementation SearchResultsView

- (instancetype)initWithFrame:(CGRect)frame{


    self = [super initWithFrame:frame];
    if (self) {
    
        _resultsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            self.frame.size.width,
                                                                            self.frame.size.height)];
        _resultsScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_resultsScrollView];
        
    }
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    if (self.dataArray.count == 3) {
     
        
        self.informationArray = [[self.dataArray firstObject] valueForKey:@"dataList"];
        
        self.activityArray = [self.dataArray[1] valueForKey:@"dataList"];
        
        self.serveArray =    [[self.dataArray lastObject] valueForKey:@"dataList"];
        
        self.informationCount = (int)self.informationArray.count;
        
        self.activityCount = (int)self.activityArray.count;
        
        self.serveCount = (int)self.serveArray.count;
        
    }else if (self.dataArray.count == 4){
    
        
        self.informationArray = [[self.dataArray firstObject] valueForKey:@"dataList"];
        
        self.activityArray = [self.dataArray[1] valueForKey:@"dataList"];
        
        self.serveArray = [self.dataArray[2] valueForKey:@"dataList"];
        
        self.VIPMemberArray = [self.dataArray[3] valueForKey:@"dataList"];
        
        self.informationCount = (int)self.informationArray.count;
        
        self.activityCount = (int)self.activityArray.count;
        
        self.serveCount = (int)self.serveArray.count;
        
        self.VIPMemberCount = (int)self.VIPMemberArray.count;
        
        
    
    }else if (self.dataArray.count == 5){
        
        self.informationArray = [[self.dataArray firstObject] valueForKey:@"dataList"];
        
        self.activityArray = [self.dataArray[1] valueForKey:@"dataList"];
        
        self.serveArray = [self.dataArray[2] valueForKey:@"dataList"];
        
        self.VIPMemberArray = [self.dataArray[3] valueForKey:@"dataList"];
        
        self.goodsArray = [self.dataArray[4] valueForKey:@"dataList"];
        
        self.informationCount = [[[self.dataArray firstObject] valueForKey:@"dataCount"] intValue];
        
        self.activityCount = [[self.dataArray[1] valueForKey:@"dataCount"] intValue];
        
        self.serveCount = [[self.dataArray[2] valueForKey:@"dataCount"] intValue];
        
        self.VIPMemberCount = [[self.dataArray[3] valueForKey:@"dataCount"] intValue];
        
        self.goodsCount = [[self.dataArray[4] valueForKey:@"dataCount"] intValue];

    }
    
    [_resultsScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    
    
    CGFloat currentHeight = 0;
    
    /**服务*/
    SearchServeView *serveView = [[SearchServeView alloc] initWithDataArray:self.serveArray
                                                                  dataCount:self.serveCount
                                                               andSearchStr:self.searchStr];
    serveView.backgroundColor = [UIColor whiteColor];
    serveView.frame = CGRectMake(0,
                                 currentHeight,
                                 WIDTH,
                                 serveView.currentHeight);
    [_resultsScrollView addSubview:serveView];
    currentHeight += serveView.currentHeight;

    
    if (self.dataArray.count == 5) {
        
        SerachGoodsView *goodsView = [[SerachGoodsView alloc] initWithDataArray:self.goodsArray
                                                                      dataCount:self.goodsCount
                                                                   andSearchStr:self.searchStr];
        goodsView.backgroundColor = [UIColor whiteColor];
        goodsView.frame = CGRectMake(0, currentHeight,
                                     WIDTH,
                                     goodsView.currentHeight);
        [_resultsScrollView addSubview:goodsView];
        currentHeight += goodsView.currentHeight;
    }

    /**活动*/
    SearchActivityView *activtyView = [[SearchActivityView alloc] initWithDataArray:self.activityArray
                                                                          dataCount:self.activityCount
                                                                       andSearchStr:self.searchStr];
    activtyView.backgroundColor = [UIColor whiteColor];
    activtyView.frame = CGRectMake(0,
                                   currentHeight,
                                   WIDTH,
                                   activtyView.currentHeight);
    [_resultsScrollView addSubview:activtyView];
    
    currentHeight += activtyView.currentHeight;
    /*************************************************************/
    
    
    /**资讯*/
    SearchInformationView *informationView = [[SearchInformationView alloc] initWithDataArray:self.informationArray
                                                                                    dataCount:self.informationCount
                                                                                 andSearchStr:self.searchStr];
    informationView.backgroundColor = [UIColor whiteColor];
    informationView.frame = CGRectMake(0,
                                       currentHeight,
                                       WIDTH,
                                       informationView.currentHeight);
    [_resultsScrollView addSubview:informationView];
    
    currentHeight +=  informationView.currentHeight;
    /****************************************************/
    
    /**秀逗了 忘记写VIP的判断了*/
    if (self.dataArray.count >= 4) {
        
        /**会员*/
        SearchVIPMemberView *vipView = [[SearchVIPMemberView alloc] initWithDataArray:self.VIPMemberArray
                                                                            dataCount:self.VIPMemberCount
                                                                         andSearchStr:self.searchStr];
        vipView.backgroundColor = [UIColor whiteColor];
        vipView.frame = CGRectMake(0,
                                   currentHeight,
                                   WIDTH,
                                   vipView.currentHeight);
        [_resultsScrollView addSubview:vipView];
        
        currentHeight += vipView.currentHeight;
        
    }else{
        
        currentHeight += 0;
        
    }

    
    _resultsScrollView.contentSize = CGSizeMake(WIDTH, currentHeight + 20*Proportion);
    
    
    /**无信息*/
    self.noMessageView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  self.frame.size.width,
                                                                  self.frame.size.height)];
    self.noMessageView.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.noMessageView];
    [self bringSubviewToFront:self.noMessageView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无相关信息";
    label.font = KSystemFontSize13;
    label.textColor = [UIColor CMLtextInputGrayColor];
    [label sizeToFit];
    label.frame = CGRectMake(20*Proportion,
                             40*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [self.noMessageView addSubview:label];
    if ((self.informationCount + self.activityCount + self.serveCount + self.VIPMemberCount + self.goodsCount) == 0) {
        self.noMessageView.hidden = NO;
    }else{
       self.noMessageView.hidden = YES;
    }
    
}

@end
