//
//  CMLBrandModuleTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandModuleObj;

@interface CMLBrandModuleTVCell : UITableViewCell

- (void) refreshCurrentCellWith:(BrandModuleObj *) obj;

- (void) hiddenLine;

- (void) showLine;
@end
