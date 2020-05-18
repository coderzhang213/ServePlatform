//
//  CMLSpecialGoodsTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2018/2/5.
//  Copyright © 2018年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSpecialGoodsTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *price;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *brandName;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,strong) NSNumber *isPre;

@property (nonatomic,strong) NSNumber *isVerb;

- (void) refreshCurrentServeCell;

@end
