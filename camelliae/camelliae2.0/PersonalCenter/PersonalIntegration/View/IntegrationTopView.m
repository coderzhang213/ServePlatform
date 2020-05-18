//
//  IntegrationTopView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/8/15.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "IntegrationTopView.h"
#import "VCManger.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "CMLINtgrationRulesVC.h"
#import "CMLIntegrationDeailParticularsVC.h"
#import "CMLGainPointsVC.h"
#import "CMLMyChangeVC.h"
#import "WebViewLinkVC.h"

@interface IntegrationTopView ()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation IntegrationTopView

- (instancetype)initWith:(BaseResultObj *) obj{

    self = [super init];
    
    if (self) {
      
        self.obj = obj;
        [self loadViews];
        
    }

    return self;
}

- (void) loadViews{

    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IntegrationBgImg]];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.userInteractionEnabled = YES;
    bgImage.backgroundColor = [UIColor CMLBlackColor];
    [self addSubview:bgImage];

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                   StatusBarHeight,
                                                                   NavigationBarHeight,
                                                                   NavigationBarHeight)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:VIPBackImg] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(dismissCurrentVC) forControlEvents:UIControlEventTouchUpInside];
    

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"我的积分";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor CMLWhiteColor];
    nameLabel.font = KSystemFontSize16;
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(WIDTH/2.0 - nameLabel.frame.size.width/2.0,
                                 backBtn.center.y - nameLabel.frame.size.height/2.0,
                                 nameLabel.frame.size.width,
                                 nameLabel.frame.size.height);
    [self addSubview:nameLabel];
    
    
    UILabel *pointsLab = [[UILabel alloc] init];
    pointsLab.font = KSystemBoldFontSize40;
    if (self.obj.retData.point) {
     
        pointsLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.point];
    }else{
    
        pointsLab.text = @"0";
    }
    
    pointsLab.textColor = [UIColor CMLWhiteColor];
    pointsLab.backgroundColor = [UIColor clearColor];
    [pointsLab sizeToFit];
    pointsLab.frame = CGRectMake(WIDTH/2.0 - pointsLab.frame.size.width/2.0,
                                 CGRectGetMaxY(nameLabel.frame) + 58*Proportion,
                                 pointsLab.frame.size.width,
                                 pointsLab.frame.size.height);
    [self addSubview:pointsLab];
    
    
    UIButton *integrationRulesBtn = [[UIButton alloc] init];
    [integrationRulesBtn setTitle:@"积分规则" forState:UIControlStateNormal];
    [integrationRulesBtn setImage:[UIImage imageNamed:IntegrationEnterRulesImg] forState:UIControlStateNormal];
    CGSize strSize = [integrationRulesBtn.currentTitle sizeWithFontCompatible:KSystemFontSize12];
    [integrationRulesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                                             - integrationRulesBtn.currentImage.size.width - 10*Proportion,
                                                             0,
                                                             0)];
    [integrationRulesBtn setImageEdgeInsets:UIEdgeInsetsMake(0,
                                                             strSize.width + integrationRulesBtn.currentImage.size.width + 10*Proportion,
                                                             0,
                                                             0)];
    integrationRulesBtn.titleLabel.font = KSystemFontSize12;
    integrationRulesBtn.backgroundColor = [UIColor clearColor];
    [integrationRulesBtn sizeToFit];
    [integrationRulesBtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    integrationRulesBtn.frame = CGRectMake(WIDTH/2.0 - integrationRulesBtn.frame.size.width/2.0,
                                           CGRectGetMaxY(pointsLab.frame) + 41*Proportion,
                                           integrationRulesBtn.frame.size.width,
                                           integrationRulesBtn.frame.size.height);
    [self addSubview:integrationRulesBtn];
    [integrationRulesBtn addTarget:self action:@selector(enterRulesVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    bgImage.frame = CGRectMake(0,
                               0,
                               WIDTH,
                               CGRectGetMaxY(integrationRulesBtn.frame) + 81*Proportion);
    
    
    NSArray *btnNamesAry = @[@"我的兑换",@"积分明细",@"赚积分"];
    NSArray *btnImageAry = @[IntegrationExchangeImg,IntegrationDetailMessageImg,IntegrationTaskImg];
    
    for (int i = 0; i < btnNamesAry.count; i++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/3*i,
                                                                  CGRectGetMaxY(bgImage.frame),
                                                                  WIDTH/3.0,
                                                                  152*Proportion)];
        
        [self addSubview:bgView];
        
        
        UIButton *touchBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/3*i,
                                                                        CGRectGetMaxY(bgImage.frame),
                                                                        WIDTH/3.0,
                                                                        152*Proportion)];
        touchBtn.backgroundColor = [UIColor clearColor];
        touchBtn.tag = i+1;
        [self addSubview:touchBtn];
        [touchBtn addTarget:self action:@selector(enterOtherVC:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *btnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:btnImageAry[i]]];
        btnImg.userInteractionEnabled = YES;
        [btnImg sizeToFit];
        [bgView addSubview:btnImg];
        
        UILabel *btnLabel = [[UILabel alloc] init];
        btnLabel.text = btnNamesAry[i];
        btnLabel.textColor = [UIColor CMLBlackColor];
        btnLabel.font = KSystemFontSize12;
        btnLabel.userInteractionEnabled = YES;
        [btnLabel sizeToFit];
        [bgView addSubview:btnLabel];
        
        btnImg.frame = CGRectMake(touchBtn.frame.size.width/2.0 - btnImg.frame.size.width/2.0,
                                  152*Proportion/2.0 - (btnImg.frame.size.height + btnLabel.frame.size.height + 21*Proportion)/2.0,
                                  btnImg.frame.size.width,
                                  btnImg.frame.size.height);
        btnLabel.frame = CGRectMake(touchBtn.frame.size.width/2.0 - btnLabel.frame.size.width/2.0,
                                    CGRectGetMaxY(btnImg.frame) + 21*Proportion,
                                    btnLabel.frame.size.width,
                                    btnLabel.frame.size.height);
        
    
        
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(bgImage.frame) + 152*Proportion,
                                                                  WIDTH,
                                                                  20*Proportion)];
    bottomView.backgroundColor = [UIColor CMLNewGrayColor];
    [self addSubview:bottomView];
    
    self.currentHeight = CGRectGetMaxY(bottomView.frame);
    
}

- (void) enterOtherVC:(UIButton *) btn{

    if (btn.tag == 1) {

        CMLMyChangeVC *vc = [[CMLMyChangeVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (btn.tag == 2){
        
        CMLIntegrationDeailParticularsVC *vc = [[CMLIntegrationDeailParticularsVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    
    }else if (btn.tag == 3){
        
        
        CMLGainPointsVC *vc = [[CMLGainPointsVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }
}

- (void) dismissCurrentVC{

    [[VCManger mainVC] dismissCurrentVC];
}

- (void) enterRulesVC{

        WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
        vc.url = self.obj.retData.jfRulesUrl;
        vc.name = @"积分规则";
        [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
