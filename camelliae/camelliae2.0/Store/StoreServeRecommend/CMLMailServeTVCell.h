//
//  CMLMailServeTVCell.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/25.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLMailServeTVCell;

@class  CMLServeObj;

@protocol CLTableViewCellDelegate <NSObject>

- (void)cl_tableViewCellPlayVideoWithCell:(CMLMailServeTVCell *)cell;

@end

@interface CMLMailServeTVCell : UITableViewCell

- (void) refreshCurrent:(CMLServeObj *) obj;

@property (nonatomic, weak) id <CLTableViewCellDelegate> delegate;
@property(nonatomic,assign)BOOL stopPlay;

@property (nonatomic,assign) int currentTag;

@property (nonatomic,assign) CGRect imageRect;

@property (nonatomic,assign) CGFloat currentheight;

- (void) showBtnView;

- (void) hidenBtnView;
@end
