//
//  CMLCommodityCVCell.m
//  camelliae2.0
//
//  Created by 张越 on 2017/5/8.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLCommodityCVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "AuctionDetailInfoObj.h"
#import "NetWorkTask.h"
#import "CMLPackageInfoModel.h"
#import "PackageInfoObj.h"

#define ImageWidth  330
#define ImageHeight 220

@interface CMLCommodityCVCell ()

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *priceLab;

@end

@implementation CMLCommodityCVCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{

    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       ImageWidth*Proportion,
                                                                       ImageHeight*Proportion)];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    self.mainImageView.layer.cornerRadius = 8*Proportion;
    [self.contentView addSubview:self.mainImageView];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = KSystemBoldFontSize12;
    self.titleLab.textColor = [UIColor CMLBlackColor];
    [self.contentView addSubview:self.titleLab];
    
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = KSystemRealBoldFontSize16;
    self.priceLab.numberOfLines = 2;
    self.priceLab.textColor = [UIColor CMLBrownColor];
    [self.contentView addSubview:self.priceLab];
}

- (void) refreshCVCell:(AuctionDetailInfoObj *) obj{
    
    if (self.isMoveModule) {
        
        self.mainImageView.frame = CGRectMake(30*Proportion,
                                              0,
                                              ImageWidth*Proportion,
                                              ImageHeight*Proportion);
    }else{
    
        self.mainImageView.frame = CGRectMake(0,
                                              0,
                                              ImageWidth*Proportion,
                                              ImageHeight*Proportion);
    }

    [NetWorkTask setImageView:self.mainImageView WithURL:obj.coverPicThumb placeholderImage:nil];


    CMLPackageInfoModel *packageInfoModel = [CMLPackageInfoModel getBaseObjFrom:obj.packageInfo.dataList[0]];
    
    self.titleLab.frame = CGRectZero;
    self.titleLab.text =  obj.title;
    [self.titleLab sizeToFit];
    
    self.priceLab.frame = CGRectZero;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",packageInfoModel.totalAmountStr];
    [self.priceLab sizeToFit];

    
    if (self.isMoveModule) {
        self.titleLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(self.mainImageView.frame) + 20*Proportion,
                                         ImageWidth*Proportion,
                                         self.titleLab.frame.size.height*2);
        self.priceLab.frame = CGRectMake(30*Proportion,
                                         CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                         ImageWidth*Proportion,
                                         self.priceLab.frame.size.height);
    }else{
    
        self.titleLab.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.mainImageView.frame) + 20*Proportion,
                                         ImageWidth*Proportion,
                                         self.titleLab.frame.size.height*2);
        self.priceLab.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.titleLab.frame) + 20*Proportion,
                                         ImageWidth*Proportion,
                                         self.priceLab.frame.size.height);
    }
    
}
@end
