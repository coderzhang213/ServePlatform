//
//  CMLSpecialInfoTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSpecialInfoTVCell : UITableViewCell

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,copy) NSString *beginTimeStr;


- (void) refreshCurrentInfoCell;

@end
