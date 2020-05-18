//
//  CMLIntegrationDetailTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/17.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLIntegrationDetailTVCell : UITableViewCell

@property (nonatomic,copy) NSString *logTypeName;

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *point;

- (void) refreshCurrentTVCell;
@end
