//
//  ActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTVCell : UITableViewCell

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *begintime;

@property (nonatomic,copy) NSString *brief;

- (void) refreshCurrentActivityCell;

@end
