//
//  CMLTansAndAttentionTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLFansAndAttentionTVCell : UITableViewCell

@property (nonatomic,copy) NSString *userHeadeImageUrl;

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *userPosition;

@property (nonatomic,strong) NSNumber *userLevel;

@property (nonatomic,copy) NSString *specificLevel;

@property (nonatomic,strong) NSNumber *currentUserId;


//1，关注 2，不关注
@property (nonatomic,strong) NSNumber *isAttention;

//是否互相关注（只对粉丝列表有影响）
@property (nonatomic,strong) NSNumber *isBothAttention;

//是否是自己的粉丝列表
@property (nonatomic,assign) BOOL isOwnList;

- (void) refershCurrentTVCell;


@end
