//
//  CMLBrandBigImgView.h
//  camelliae2.0
//
//  Created by 张越 on 2017/11/29.
//  Copyright © 2017年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLBrandBigImgViewDelegate<NSObject>

- (void) clearBrandBigImgView;
@end

@interface CMLBrandBigImgView : UIView

- (instancetype)initWithImageUrl:(NSString *)url andDetailMes:(NSString *)mes LogoImageUrl:(NSString *) logoUrl;

@property (nonatomic,weak) id<CMLBrandBigImgViewDelegate>delegate;

@end
