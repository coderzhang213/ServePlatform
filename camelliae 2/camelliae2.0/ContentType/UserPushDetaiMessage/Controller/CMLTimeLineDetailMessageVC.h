//
//  CMLTimeLineDetailMessageVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "CMLNewVipUseTimeLineTVCell.h"

@interface CMLTimeLineDetailMessageVC : CMLBaseVC

- (instancetype)initWithObj:(NSNumber *) objID;

@property (nonatomic,strong) CMLNewVipUseTimeLineTVCell *cell;

@end
