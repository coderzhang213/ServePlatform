//
//  CMLImageShowVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/12.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@interface CMLImageShowVC : CMLBaseVC

@property (nonatomic,assign) int dataCount;

@property (nonatomic,strong) NSNumber *albumId;

- (instancetype)initWithTag:(int)currentTag dataArray:(NSMutableArray *) dataArray originImageUrlArray:(NSArray *)originImageUrlArray;


@end
