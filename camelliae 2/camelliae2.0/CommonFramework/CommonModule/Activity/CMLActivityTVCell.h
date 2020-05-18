//
//  CMLActivityTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLCommIndexObj.h"
#import "CMLActivityObj.h"

@interface CMLActivityTVCell : UITableViewCell


@property (nonatomic,assign) CGFloat cellheight;

@property (nonatomic,assign) BOOL isShowSubscribe;

- (void) refrshActivityCellInActivityVC:(CMLActivityObj *) obj;


@end
