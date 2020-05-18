//
//  WebViewLinkVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/6/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@interface WebViewLinkVC : CMLBaseVC

@property (nonatomic,copy) NSString *shareUrl;

@property (nonatomic,strong) NSNumber *isShare;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *desc;

@property (nonatomic,assign) BOOL isDetailMes;

@end
