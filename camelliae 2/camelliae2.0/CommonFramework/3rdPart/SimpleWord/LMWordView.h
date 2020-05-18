//
//  LMWordView.h
//  SimpleWord
//
//  Created by Chenly on 16/5/12.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseResultObj.h"

@protocol LMWordViewDelegate <NSObject>

- (void) touchActivityTicketPriceBtn;

- (void) touchActivityTimeBtn;

@end

@interface LMWordView : UITextView

@property (nonatomic, strong) BaseResultObj *obj;
/**0,项目 1，活动 2，商品，3服务*/
@property (nonatomic,strong) NSNumber *currentTag;

@property (nonatomic,strong) UILabel *ticketPriceLab;

@property (nonatomic,strong) UIButton *ticketPriceBtn;

@property (nonatomic,strong) UILabel *activityTimeLab;

@property (nonatomic,strong) UIButton *activityTimeBtn;

@property (nonatomic,strong) UITextField *cityTextField;

@property (nonatomic,strong) UITextView *titleTextField;

@property (nonatomic,strong) UILabel *tempPrice;

@property (nonatomic,strong) UILabel *beginTime;

@property (nonatomic, strong) UIImageView *surfacePlotImage;

@property (nonatomic,weak) id<LMWordViewDelegate> wordViewDelegate;

- (void) refreshTitleViewRect:(CGRect) rect;

- (void) setup;

@property (nonatomic,copy) NSString *topTitle;

@property (nonatomic,strong) UIImage *topImage;

@property (nonatomic, copy) NSString *cityNameString;

- (void) refreshPrice:(NSString *) str;

- (void) refresTime:(NSString *) startTimeStr;


@end
