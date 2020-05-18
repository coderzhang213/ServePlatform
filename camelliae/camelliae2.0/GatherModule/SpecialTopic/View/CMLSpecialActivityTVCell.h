//
//  CMLSpecialActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSpecialActivityTVCell : UITableViewCell

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *currentLvl;

@property (nonatomic,strong) NSNumber *beginTime;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refreshCurrentActivityCell;

@end
