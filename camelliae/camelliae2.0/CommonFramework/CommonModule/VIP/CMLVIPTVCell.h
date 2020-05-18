//
//  CMLVIPTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2016/12/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPDetailObj.h"

@interface CMLVIPTVCell : UITableViewCell


@property (nonatomic,assign) CGFloat cellHeight;

- (void) refreshVIPCellWith:(VIPDetailObj*) obj;

@end
