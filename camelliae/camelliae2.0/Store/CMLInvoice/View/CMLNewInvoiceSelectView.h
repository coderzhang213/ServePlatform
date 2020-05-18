//
//  CMLNewInvoiceSelectView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLNewInvoiceSelectViewDelegate<NSObject>

/**1,个人普通2,企业普通3,企业专用*/
- (void) selectType:(NSNumber *) type;

@end

@interface CMLNewInvoiceSelectView : UIView

/**1,个人2,专业*/
@property (nonatomic,strong) NSNumber *userType;

/**1,普通2,专业*/
@property (nonatomic,strong) NSNumber *invoiceType;

@property (nonatomic,weak) id<CMLNewInvoiceSelectViewDelegate> delegate;

- (void) loadViews;

@end
