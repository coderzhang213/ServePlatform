//
//  CMLBrandVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@interface CMLBrandVC : CMLBaseVC

- (instancetype)initWithImageUrl:(NSString *)url andDetailMes:(NSString *)mes LogoImageUrl:(NSString *) logoUrl brandID:(NSNumber *) brandID;

@property (nonatomic,strong) NSNumber *serveNum;

@property (nonatomic,strong) NSNumber *goodsNum;

@end
