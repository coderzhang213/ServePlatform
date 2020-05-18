//
//  OwnExchangeTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/8/24.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnExchangeTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *orderName;

@property (nonatomic,strong) NSNumber *price;

@property(nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,strong) NSNumber *expressStatus;

@property (nonatomic,copy) NSString *expressUrl;




- (void) refreshCurrentCell;

@end
