//
//  CMLNewInvoiceDetailMesView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLNewInvoiceDetailMesViewDelegate<NSObject>

- (void) refreshCurrentHeight:(CGFloat) currentHeight;

@end

@interface CMLNewInvoiceDetailMesView : UIView

@property (nonatomic,weak) id<CMLNewInvoiceDetailMesViewDelegate>delegate;

@property (nonatomic,strong) NSDictionary *targetDic;

- (void) refrshViews;

- (void) refreshInvoiceType:(NSNumber *) type;

@end
