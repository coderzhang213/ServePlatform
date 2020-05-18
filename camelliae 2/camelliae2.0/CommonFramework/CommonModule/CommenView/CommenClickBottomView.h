//
//  CommenClickBottomView.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommenClickBottomView : UIView

- (instancetype)initWithTag:(int) tag;

@property (nonatomic,assign) CGFloat currentHeight;

@property (nonatomic,copy) NSString *rootTypeName;

@property (nonatomic,copy) NSString *currentTypeName;

@property (nonatomic,strong) NSNumber *collectNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *selectState;

@property (nonatomic,strong) NSNumber *currentID;

- (void) refreshCommenClickBottomView;


- (void) refreshCommenClickBottomSelectState:(NSNumber *) state;

@end
