//
//  CMLWebLinkTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLWebLinkTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) BOOL isTopicWeb;

- (void) refreshCurrentCellWithImageUrl:(NSString *) imageurl;
@end
