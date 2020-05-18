//
//  CMLServeOfBrandTableView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseTableView.h"
#import "KrVideoPlayerController.h"

@interface CMLServeOfBrandTableView : CMLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style brandID:(NSNumber *) brandID;

@property (nonatomic,strong) KrVideoPlayerController *videoController;

@end
