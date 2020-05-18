//
//  CMLProjectObj.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLProjectObj : BaseResultObj

@property (nonatomic,strong) NSNumber *authorId;

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSArray *coverPicArr;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@end
