//
//  CMLGradeAndPointShowView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLGradeAndPointShowView.h"
#import "CMLCamelliaeVIPDetailVC.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"
#import "VCManger.h"
#import "UpGradeVC.h"
#import "CommonImg.h"

@interface CMLGradeAndPointShowView ()

@property (nonatomic,strong) NSNumber *currentGrade;

@property (nonatomic,strong) NSNumber *currentPoints;

@end

@implementation CMLGradeAndPointShowView

- (instancetype)initWithGrade:(NSNumber *) grade andPoints:(NSNumber *) points{

    self = [super init];
    if (self) {
       
        self.currentGrade = grade;
        self.currentPoints = points;
        
        self.frame = CGRectMake(0, 0, WIDTH, 174*Proportion);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.image = [UIImage imageNamed:OwnVIPBgImg];
        bgImageView.userInteractionEnabled = YES;
        [self addSubview:bgImageView];
        
        [self loadButton];
        
    }
    return self;
}

- (void) loadButton{

    CGFloat space = (WIDTH - 134*Proportion*3)/4.0;
    
    NSArray *imageArray = @[OwnVIPGradeImg,
                            OwnVIPPointsImg,
                            OwnVIPUpImg];
    NSArray *contentArray = @[[NSString stringWithFormat:@"%@",self.currentGrade],
                              [NSString stringWithFormat:@"%@",self.currentPoints],
                              @"特权升级"];
    for (int i = 0; i < 3; i++) {
        
        UIView *buttonBg = [[UIView alloc] initWithFrame:CGRectMake(space + (space + 134*Proportion)*i,
                                                                      0,
                                                                      134*Proportion,
                                                                      134*Proportion)];
        buttonBg.backgroundColor = [UIColor clearColor];
        [self addSubview:buttonBg];
        
        UIImageView *promImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
        promImage.userInteractionEnabled = YES;
        [promImage sizeToFit];
        promImage.frame = CGRectMake(buttonBg.frame.size.width/2.0 - 40*Proportion/2.0,
                                     40*Proportion,
                                     40*Proportion,
                                     40*Proportion);
        [buttonBg addSubview:promImage];
        

        
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            
            switch ([self.currentGrade intValue]) {
                case 1:
                    label.text = @"粉色会员";
                    break;
                case 2:
                    label.text = @"黛色会员";
                    break;
                case 3:
                    label.text = @"金色会员";
                    break;
                case 4:
                    label.text = @"墨色会员";
                    break;
                    
                default:
                    break;
            }
            
        }else{
            label.text = contentArray[i];
        }
        label.font = KSystemBoldFontSize12;
        label.textColor = [UIColor CMLDarkOrangeColor];
        label.userInteractionEnabled = YES;
        [label sizeToFit];
        label.frame = CGRectMake(buttonBg.frame.size.width/2.0 - label.frame.size.width/2.0,
                                 CGRectGetMaxY(promImage.frame) + 10*Proportion,
                                 label.frame.size.width,
                                 label.frame.size.height);
        [buttonBg addSubview:label];
        
        if (i == 2) {
            UIButton *button = [[UIButton alloc] initWithFrame:buttonBg.bounds];
            [buttonBg addSubview:button];
            [button addTarget:self action:@selector(enterUpGradeVC) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
//            UIButton *button = [[UIButton alloc] initWithFrame:buttonBg.bounds];
//            [buttonBg addSubview:button];
//            [button addTarget:self action:@selector(enterLvlMessageVC) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void) enterUpGradeVC{

    UpGradeVC *vc = [[UpGradeVC alloc] init];
    [[VCManger mainVC]pushVC:vc animate:YES];
}

- (void) enterLvlMessageVC{

//    CMLCamelliaeVIPDetailVC *vc = [[CMLCamelliaeVIPDetailVC alloc] initWithTitle:@"花伴等级"];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
