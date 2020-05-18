//
//  CMLBaseTableView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/2.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLBaseTableViewDlegate <NSObject>

@optional

- (void) startRequesting;

- (void) endRequesting;

- (void) showSuccessActionMessage:(NSString *) str;

- (void) showFailActionMessage:(NSString *) str;

- (void) showAlterView:(NSString *) text;

@optional

- (void) tableScrollUp;

- (void) tableScrollDown;

- (void) tableScrollZero;

- (void) tableViewDidScroll:(CGFloat) Y;

@end


@interface CMLBaseTableView : UITableView

@property (nonatomic,weak) id<CMLBaseTableViewDlegate> baseTableViewDlegate;

@end
