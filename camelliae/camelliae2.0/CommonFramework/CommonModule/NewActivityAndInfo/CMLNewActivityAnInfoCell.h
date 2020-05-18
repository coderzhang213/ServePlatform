//
//  CMLNewActivityAnInfoCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/9/14.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLCommIndexObj.h"
#import "CMLActivityObj.h"

@interface CMLNewActivityAnInfoCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellheight;

@property (nonatomic,assign) BOOL isShowSubscribe;

- (void) refrshActivityCellInMainInterfaceVC:(CMLCommIndexObj *) obj;

- (void) refrshActivityCellInActivityVC:(CMLActivityObj *) obj;

@end
