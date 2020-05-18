//
//  ShowVIPGradeMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ShowVIPGradeMessageView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "CMLLine.h"

@interface ShowVIPGradeMessageView ()

@property (nonatomic,copy) NSString *roleName;

@end

@implementation ShowVIPGradeMessageView

- (instancetype)initWithLvl:(int)tag andPrice:(NSNumber *)price andPoints:(NSNumber *)points andBgView:(UIView *)view roleName:(NSString *)roleName {

    self = [super init];
    if (self) {
        self.roleName = roleName;
        self.frame = view.bounds;
        self.backgroundColor = [UIColor clearColor];
        [self loadViewsWithTag:tag andPrice:price andPoints:points andBgView:view];
    }
    return self;
}


- (void) loadViewsWithTag:(int) tag andPrice:(NSNumber *) price andPoints:(NSNumber *) points andBgView:(UIView *) view{

    /**控制周边不伸缩*/
    UIImage *bgImage = [[UIImage imageNamed:UpGradeMessageShowBgLongImg] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                        resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(0,
                                   0,
                                   690*Proportion,
                                   690*Proportion);
    bgImageView.center = self.center;
    [self addSubview:bgImageView];
    
    NSArray *upArray;
    
    UILabel *topTitle = [[UILabel alloc] init];
    switch (tag) {
        case 2:
            topTitle.text = @"购买粉银特权";
            upArray = @[@"粉银",@"尊享"];
            break;
        case 3:
            topTitle.text = @"购买粉金特权";
            upArray = @[@"粉金",@"尊享"];
            break;
        case 4:
            topTitle.text = @"购买粉钻特权";
            upArray = @[@"粉钻",@"尊享"];
            break;
        case 5:
            topTitle.text = @"购买黛色特权";
            upArray = @[@"黛色",@"尊享"];
            break;
        case 6:
            topTitle.text = @"购买黛色特权";
            upArray = @[@"黛色",@"尊享"];
            break;
        case 7:
            topTitle.text = @"购买金色特权";
            upArray = @[@"金色",@"尊享"];
            break;
            
        default:
            break;
    }

    topTitle.text = [NSString stringWithFormat:@"购买%@特权", self.roleName];
    upArray = @[self.roleName, @"尊享"];
    NSLog(@"%@", self.roleName);
    NSLog(@"%@", topTitle.text);
    topTitle.font = KSystemBoldFontSize14;
    topTitle.textColor = [UIColor CMLUserBlackColor];
    [topTitle sizeToFit];
    topTitle.frame = CGRectMake(bgImageView.frame.size.width/2.0 - topTitle.frame.size.width/2.0,
                                60*Proportion,
                                topTitle.frame.size.width,
                                topTitle.frame.size.height);
    [bgImageView addSubview:topTitle];
    
    
    UILabel *subheadLabel = [[UILabel alloc] init];
    subheadLabel.text = @"您将获得";
    subheadLabel.font = KSystemFontSize12;
    subheadLabel.textColor = [UIColor CMLtextInputGrayColor];
    [subheadLabel sizeToFit];
    subheadLabel.frame = CGRectMake(690*Proportion/2.0 - subheadLabel.frame.size.width/2.0,
                                    CGRectGetMaxY(topTitle.frame) + 20*Proportion,
                                    subheadLabel.frame.size.width,
                                    subheadLabel.frame.size.height);
    [bgImageView addSubview:subheadLabel];
    
    NSArray *bottomArray = @[@"会员",@"特权"];
    for (int i = 0; i < 2; i++) {
        
        UIImageView *describeBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:UpGradeMessageTagBgImg]];
        [describeBgImage sizeToFit];
        
        if (i == 0) {
            describeBgImage.frame = CGRectMake((690*Proportion - describeBgImage.frame.size.width*2)/3.0,
                                               CGRectGetMaxY(subheadLabel.frame) + 40*Proportion,
                                               describeBgImage.frame.size.width,
                                               describeBgImage.frame.size.height);
        }else if (i == 1){
            describeBgImage.frame = CGRectMake((690*Proportion - describeBgImage.frame.size.width*2)/3.0*2.0 + describeBgImage.frame.size.width,
                                               CGRectGetMaxY(subheadLabel.frame) + 40*Proportion,
                                               describeBgImage.frame.size.width,
                                               describeBgImage.frame.size.height);
        }
        
        [bgImageView addSubview:describeBgImage];
        
        UILabel *upLabel = [[UILabel alloc] init];
        upLabel.font = KSystemRealBoldFontSize14;
        upLabel.textColor = [UIColor CMLWhiteColor];
        upLabel.text = upArray[i];
        [upLabel sizeToFit];
        upLabel.frame = CGRectMake(describeBgImage.frame.size.width/2.0 - upLabel.frame.size.width/2.0,
                                   describeBgImage.frame.size.height/2.0 - upLabel.frame.size.height,
                                   upLabel.frame.size.width,
                                   upLabel.frame.size.height);
        [describeBgImage addSubview:upLabel];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.font = KSystemRealBoldFontSize14;
        bottomLabel.textColor = [UIColor CMLWhiteColor];
        bottomLabel.text = bottomArray[i];
        [bottomLabel sizeToFit];
        bottomLabel.frame = CGRectMake(describeBgImage.frame.size.width/2.0 - bottomLabel.frame.size.width/2.0,
                                   CGRectGetMaxY(upLabel.frame),
                                   bottomLabel.frame.size.width,
                                   bottomLabel.frame.size.height);
        [describeBgImage addSubview:bottomLabel];
        
        if (i == 1) {
            
            CMLLine *dottedLine = [[CMLLine alloc] init];
            dottedLine.kindOfLine = DottedLine;
            dottedLine.startingPoint = CGPointMake(bgImageView.frame.size.width/2.0 - 590*Proportion/2.0, CGRectGetMaxY(describeBgImage.frame) + 40*Proportion);
            dottedLine.lineWidth = 1*Proportion;
            dottedLine.lineLength = 590*Proportion;
            dottedLine.LineColor = [UIColor CMLOrangeColor];
            [bgImageView addSubview:dottedLine];
            
            UILabel *promLabel = [[UILabel alloc] init];
            promLabel.text = @"总共需要支付";
            promLabel.textColor = [UIColor CMLLineGrayColor];
            promLabel.font = KSystemBoldFontSize14;
            [promLabel sizeToFit];
            promLabel.frame = CGRectMake(690*Proportion/2.0 - promLabel.frame.size.width/2.0,
                                         CGRectGetMaxY(describeBgImage.frame) + 40*Proportion + 30*Proportion,
                                         promLabel.frame.size.width,
                                         promLabel.frame.size.height);
            [bgImageView addSubview:promLabel];
            
            UIButton *priceBtn = [[UIButton alloc] init];
            priceBtn.titleLabel.font = KSystemBoldFontSize16;
            priceBtn.userInteractionEnabled = NO;
            [priceBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
            [priceBtn setImage:[UIImage imageNamed:UpGradeVIPPriceImg] forState:UIControlStateNormal];
            [priceBtn setTitle:[NSString stringWithFormat:@"%@",price] forState:UIControlStateNormal];
            [priceBtn sizeToFit];
            priceBtn.frame = CGRectMake(690*Proportion/2.0 - priceBtn.frame.size.width/2.0,
                                        CGRectGetMaxY(promLabel.frame) + 10*Proportion,
                                        priceBtn.frame.size.width,
                                        priceBtn.frame.size.height);
            [bgImageView addSubview:priceBtn];
            
            
            UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80*Proportion,
                                                                             CGRectGetMaxY(priceBtn.frame) + 51*Proportion,
                                                                             192*Proportion,
                                                                             68*Proportion)];
            cancelBtn.titleLabel.font = KSystemFontSize12;
            [cancelBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
            [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
            cancelBtn.backgroundColor = [UIColor CMLNewGrayColor];
            [bgImageView addSubview:cancelBtn];
            cancelBtn.layer.cornerRadius = 4*Proportion;
            [cancelBtn addTarget:self action:@selector(hiddenShadow) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(690*Proportion- 80*Proportion - 192*Proportion,
                                                                          CGRectGetMaxY(priceBtn.frame) + 51*Proportion,
                                                                          192*Proportion,
                                                                          68*Proportion)];
            buyBtn.titleLabel.font = KSystemFontSize12;
            [buyBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
            [buyBtn setTitle:@"确认信息" forState:UIControlStateNormal];
            buyBtn.backgroundColor = [UIColor CMLGreeenColor];
            buyBtn.tag = tag;
            [bgImageView addSubview:buyBtn];
            buyBtn.layer.cornerRadius = 4*Proportion;
            [buyBtn addTarget:self action:@selector(prepareToPay:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

- (void) hiddenShadow{

    [self.delegate cancelBuyState];
}

- (void) prepareToPay:(UIButton *) button{

    [self.delegate entreBuyState:(int)button.tag];
}
@end
