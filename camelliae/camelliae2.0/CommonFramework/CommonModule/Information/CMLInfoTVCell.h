//
//  CMLInfoTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/5/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLCommIndexObj.h"
#import "CMLInfoObj.h"

@interface CMLInfoTVCell : UITableViewCell

@property (nonatomic,assign) BOOL isMainView;

@property (nonatomic,assign) CGFloat cellheight;


- (void) refrshInfoCellInMainInterfaceVC:(CMLCommIndexObj *) obj;

- (void) refrshInfoCellInInfoVC:(CMLInfoObj *) obj;

@end
