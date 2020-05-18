//
//  CMLOrderTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShowInvitationBlock)();

@interface CMLOrderTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *orderName;

@property (nonatomic,copy) NSString *serveTime;

@property (nonatomic,strong) NSNumber *price;

@property(nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,strong) NSNumber *isUserPush;

@property (nonatomic,assign) BOOL isActivityCell;


@property (nonatomic,copy) ShowInvitationBlock showInvitationBlock;


- (void) refreshCurrentCell;
@end
