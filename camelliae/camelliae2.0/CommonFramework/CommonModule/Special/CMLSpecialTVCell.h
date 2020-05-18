//
//  CMLSpecialTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSpecialTVCell : UITableViewCell

@property (nonatomic,assign) CGFloat rowHeight;

- (void) refreshCurrentCellWithImageUrl:(NSString*)imageUrl SpecialName:(NSString *)specialName;
@end
