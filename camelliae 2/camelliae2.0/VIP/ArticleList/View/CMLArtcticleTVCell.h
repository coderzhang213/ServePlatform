//
//  CMLArcticleTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/10/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendTimeLineObj.h"

typedef void(^DeleteArticleBlock)(NSNumber *currentId);

@interface CMLArtcticleTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat currentCellHeight;

@property (nonatomic,copy) DeleteArticleBlock deleteArticle;

- (void) refreshCurrentCellWith:(RecommendTimeLineObj *) obj atIndexPath:(NSIndexPath *)indexPath;

- (void) refreshCurrentCellLikebtnStatus:(NSNumber *) status andNum:(int) number;
@end
