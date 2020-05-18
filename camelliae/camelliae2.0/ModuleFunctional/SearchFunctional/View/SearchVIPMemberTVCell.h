//
//  SearchVIPMemberTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVIPMemberTVCell : UITableViewCell

@property (nonatomic,copy) NSString *userImageUrl;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *lvl;

@property (nonatomic,strong) NSNumber *memberLvl;

@property (nonatomic,copy) NSNumber *vipGrade;

@property (nonatomic,copy) NSString *position;

- (void) refreshSearchCell;
@end
