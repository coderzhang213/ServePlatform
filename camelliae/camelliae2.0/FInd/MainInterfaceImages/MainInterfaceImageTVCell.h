//
//  MainInterfaceImageTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/23.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLImageListObj;

@interface MainInterfaceImageTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refreshCurrentCell:(CMLImageListObj *) obj;

@end
