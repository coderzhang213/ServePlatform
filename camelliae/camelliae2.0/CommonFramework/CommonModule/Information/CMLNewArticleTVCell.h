//
//  CMLNewArcticleTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/10/16.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLCommIndexObj.h"
#import "CMLActivityObj.h"

@interface CMLNewArticleTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellheight;


- (void) refrshArcticleCellInActivityVC:(CMLActivityObj *) obj;


@end
