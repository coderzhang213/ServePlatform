//
//  CMLUserProjectDetailVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "CMLUserProjectTVCell.h"

@interface CMLUserProjectDetailVC : CMLBaseVC

- (instancetype)initWithObj:(NSNumber *) objID;

@property (nonatomic,strong) CMLUserProjectTVCell *cell;
@end
