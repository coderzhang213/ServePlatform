//
//  ServeTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServeTVCell : UITableViewCell

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,strong) NSNumber *is_pre;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *subTypeName;

@property (nonatomic,copy) NSString *parentTypeName;


- (void) refreshCurrentServeCell;

@end
