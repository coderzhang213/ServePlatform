//
//  CMLRecommendTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/5.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeRecommedUserObj.h"

typedef void(^DeleteCurrentLineBlock)(NSNumber *currentId);

typedef void(^PlayVideoBlock)(NSInteger currentTag);

@interface CMLRecommendTVCell : UITableViewCell

- (void) refreshCurrentCell:(ServeRecommedUserObj *) obj;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,copy) DeleteCurrentLineBlock deleteCurrentLineBlock;

@property (nonatomic,copy) PlayVideoBlock playVideoBlock;

@end
