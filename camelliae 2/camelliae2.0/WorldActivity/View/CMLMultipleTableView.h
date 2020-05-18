//
//  CMLMultipleTableView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/1/4.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLMultipleTableViewDelegate <NSObject>

- (void) showMultipleTableSuccessMessage:(NSString *)srt;

- (void) showMultipleTableErrorMessage:(NSString *)srt;

- (void) multipleTableProgressSucess;

- (void) multipleTableProgressError;

- (void) scrollToTempLoation:(int) index;

@end

@interface CMLMultipleTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray *)tagIDsArr;

@property (nonatomic,strong) NSArray *tagNamesArr;

@property (nonatomic,weak) id<CMLMultipleTableViewDelegate> delegate;

- (void) scrollToIndex:(int) index;

- (void) scrollCurrentTableViewToTop;

@end
