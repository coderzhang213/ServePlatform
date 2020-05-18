//
//  InformationTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTVCell : UITableViewCell

@property (nonatomic,copy) NSString *brief;

@property (nonatomic,copy) NSString *subType;

@property (nonatomic,copy) NSString *time;

- (void) refreshCurrentInformationTVCell:(NSString *) imagrUrl andTitle:(NSString *)title;

@end
