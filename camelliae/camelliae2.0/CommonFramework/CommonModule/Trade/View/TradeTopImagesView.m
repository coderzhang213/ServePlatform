//
//  TradeTopImagesView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/3.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "TradeTopImagesView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"

@interface  TradeTopImagesView ()

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation TradeTopImagesView

- (instancetype)initWithImageurlArray:(NSArray *) array{

    self = [super init];
    
    if (self) {

        self.dataArray = array;
        [self loadViews];
        
        self.viewWidth = WIDTH;
        self.viewHeight = WIDTH/16*9;
    }
    return self;
}

- (void) loadViews{

    UIScrollView *imageBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                     0,
                                                                                     WIDTH,
                                                                                     WIDTH/16*9)];
    imageBgScrollView.pagingEnabled = YES;
    imageBgScrollView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:imageBgScrollView];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, WIDTH/16*9)];
        imageView.backgroundColor = [UIColor CMLPromptGrayColor];
        [imageBgScrollView addSubview:imageView];
        [NetWorkTask setImageView:imageView WithURL:self.dataArray[i] placeholderImage:nil];
        
    }
}
@end
