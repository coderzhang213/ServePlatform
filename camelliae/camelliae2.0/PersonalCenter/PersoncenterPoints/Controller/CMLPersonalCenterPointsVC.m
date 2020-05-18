//
//  CMLPersonalCenterPointsVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonalCenterPointsVC.h"
#import "VCManger.h"

#define PersonalCenterPointsTopLabelTopMargin    40
#define PersonalCenterPointsTopMargin            100
#define PersonalCenterPointsAndFenMargin         10
#define PersonalCenterPointsRecordsTopMargin     100
#define PersonalCenterPointsRecordsBottomMargin  40

@interface CMLPersonalCenterPointsVC ()<NavigationBarProtocol>

@end

@implementation CMLPersonalCenterPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleColor = [UIColor CMLYellowColor];
    self.navBar.titleContent = @"我的积分";
    self.navBar.delegate = self;
    [self.navBar setYellowLeftBarItem];
    /*******************************************/
    
    [self loadViews];
}

- (void) loadViews{

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor CMLUserBlackColor];
    [self.contentView addSubview:bgView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"当前积分";
    topLabel.font = KSystemFontSize14;
    [topLabel sizeToFit];
    topLabel.textColor = [UIColor CMLPromptGrayColor];
    topLabel.frame = CGRectMake(WIDTH/2.0 - topLabel.frame.size.width/2.0,
                                PersonalCenterPointsTopLabelTopMargin*Proportion,
                                topLabel.frame.size.width,
                                topLabel.frame.size.height);
    
    [bgView addSubview:topLabel];
    
    NSMutableAttributedString *pointsStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分",[[DataManager lightData] readUserPoints]]];
    [pointsStr setAttributes:@{NSFontAttributeName:KSystemFontSize14} range:NSMakeRange(pointsStr.length - 1, 1)];
    
    UILabel *pointsLabel = [[UILabel alloc] init];
    pointsLabel.text = [NSString stringWithFormat:@"%@",[[DataManager lightData] readUserPoints]];
    pointsLabel.textColor = [UIColor CMLYellowColor];
    pointsLabel.font = KSystemBoldFontSize30;
    pointsLabel.attributedText = pointsStr;
    [pointsLabel sizeToFit];
    pointsLabel.frame = CGRectMake(WIDTH/2.0 - pointsLabel.frame.size.width/2.0,
                                   CGRectGetMaxY(topLabel.frame) + PersonalCenterPointsTopMargin*Proportion,
                                   pointsLabel.frame.size.width,
                                   pointsLabel.frame.size.height);
    [bgView addSubview:pointsLabel];
    
    
    UILabel *consumptionRecords = [[UILabel alloc] init];
    consumptionRecords.textColor = [UIColor CMLPromptGrayColor];
    consumptionRecords.text = @"消费记录";
    consumptionRecords.font = KSystemFontSize12;
    [consumptionRecords sizeToFit];
    consumptionRecords.frame = CGRectMake(WIDTH/2.0 - consumptionRecords.frame.size.width/2.0,
                                          CGRectGetMaxY(pointsLabel.frame) + PersonalCenterPointsRecordsTopMargin*Proportion,
                                          consumptionRecords.frame.size.width,
                                          consumptionRecords.frame.size.height);
    [bgView addSubview:consumptionRecords];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.startingPoint = CGPointMake(consumptionRecords.frame.origin.x, CGRectGetMaxY(consumptionRecords.frame));
    bottomLine.lineWidth =1;
    bottomLine.LineColor = [UIColor CMLPromptGrayColor];
    bottomLine.lineLength = consumptionRecords.frame.size.width;
    bottomLine.directionOfLine = HorizontalLine;
    [bgView addSubview:bottomLine];
    
    
    bgView.frame = CGRectMake(0,
                              CGRectGetMaxY(self.navBar.frame),
                              WIDTH,
                              (PersonalCenterPointsTopLabelTopMargin + PersonalCenterPointsTopMargin + PersonalCenterPointsRecordsTopMargin + PersonalCenterPointsRecordsBottomMargin)*Proportion + topLabel.frame.size.height + pointsLabel.frame.size.height + consumptionRecords.frame.size.height);
    
    
}

- (void) didSelectedLeftBarItem{
    [[VCManger mainVC] dismissCurrentVC];
}

@end
