//
//  CMLSpecialServeTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSpecialServeTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,strong) NSNumber *isPre;

@property (nonatomic,strong) NSNumber *isHasPriceInterval;

@property (nonatomic,strong) NSNumber *isVerb;

@property (nonatomic,assign) CGFloat currentHeight;

- (void) refreshCurrentServeCell;


@end
