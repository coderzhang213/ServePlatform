//
//  YPBaseSwipeTableViewCell.h
//  cell侧滑自定义
//
//  Created by hbck on 2018/11/18.
//  Copyright © 2018年 com.hbck.mg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YPVerOrTrainInterger) {
    kCellTransverse = 0, // 默认横向排布
    kCellVertical,       // 竖向排布
    
};
@protocol YPSwipeTableViewCellDelegate <NSObject>

- (void)YPSwipeTableViewCelldidSelectBtnWithTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexpath;

@end

@interface YPBaseSwipeTableViewCell : UITableViewCell

/**
 排布类型
 */
@property (nonatomic,assign)YPVerOrTrainInterger intergalType;

@property (nonatomic, weak)id<YPSwipeTableViewCellDelegate>delegate;

/*
 右部自定义按钮组
 */
@property (nonatomic, retain)NSArray *rightBtnArr;


/**
 排布按钮背景色
 */
@property (nonatomic, retain)UIColor *cellBackGroundColor;


/*
 cell显示的内容视图(可将继承的类的布局添加到此视图上显示)
 */
@property (nonatomic, retain)UIView *YPContentView;

/*必须要实现didsele方法否则报错，父类调用整个cell点击事件 */
@property (nonatomic, retain)UITableView *superTableView;

/*
 右部按钮显示
 */
@property (nonatomic, assign, readonly)BOOL isRightBtnShow;


/**
继承类的布局放在这里
 */
- (void)creatUI;

/**
 cell

 @param style <#style description#>
 @param reuseIdentifier <#reuseIdentifier description#>
 @param arr 按钮排布,可以2个可多个
 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>
 @param type 竖向/横向
 @return <#return value description#>
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBtn:(NSArray *)arr tableView:(UITableView *)tableView cellIndexPath:(NSIndexPath *)indexPath andType:(YPVerOrTrainInterger)type;
@end
