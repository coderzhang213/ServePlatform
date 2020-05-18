//
//  CMLRelevanceActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLRelevanceActivityTVCell : UITableViewCell

@property (nonatomic,copy) NSString *titile;

@property (nonatomic,copy) NSString *imageUrl;

- (void) refreshTVCell;

@end
