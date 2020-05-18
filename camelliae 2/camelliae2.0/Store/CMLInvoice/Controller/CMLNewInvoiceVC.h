//
//  CMLNewInvoiceVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/12/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol CMLNewInvoiceVCDelegate<NSObject>

- (void) outPutInvoiceMes:(NSDictionary *) targetDic;

@end

@interface CMLNewInvoiceVC : CMLBaseVC

- (instancetype)initWith:(NSDictionary *) dic;

@property (nonatomic,strong) id<CMLNewInvoiceVCDelegate> delegate;

@end
