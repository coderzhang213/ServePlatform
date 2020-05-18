//
//  CMLUserArticleVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/26.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

#import "CMLArtcticleTVCell.h"
@interface CMLUserArticleVC : CMLBaseVC

- (instancetype)initWithObj:(NSNumber *) objID;

@property (nonatomic,strong) CMLArtcticleTVCell *cell;

@end
