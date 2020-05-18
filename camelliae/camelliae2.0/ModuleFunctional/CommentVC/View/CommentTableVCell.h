//
//  CommentTableVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableVCell : UITableViewCell

@property (nonatomic,copy) NSString *userImageUrl;

@property (nonatomic,copy) NSString *userNickName;

@property (nonatomic,copy) NSString *pushTime;

@property (nonatomic,copy) NSString *pushContent;

@property (nonatomic,assign) CGFloat currentRowHeight;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *recordId;

@property (nonatomic,strong) NSNumber *num;

@property (nonatomic,strong) NSNumber *isUserLike;

- (void) refreshCurrentCell;

@end
