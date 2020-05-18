//
//  CMLGainPointsTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)(NSNumber *currentType);

@interface CMLGainPointsTVCell : UITableViewCell

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,strong) NSNumber *tyoe;

@property (nonatomic,strong) NSNumber *finishStatus;

@property (nonatomic,copy) NSString *finishStatusStr;

@property (nonatomic,copy) TouchBlock touchBlock;

- (void) refreshCurrentTVCellWithIndex:(NSInteger) index;

@end
