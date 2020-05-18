//
//  CMLPrefectureActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/5/11.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLActivityObj;

@interface CMLPrefectureActivityTVCell : UITableViewCell

- (void) refreshCurrentCell:(CMLActivityObj *) obj;
@end
