//
//  CMLInfoTVCell.m
//  camelliae2.0
//
//  Created by 张越 on 16/5/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLInfoTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "NSString+CMLExspand.h"
#import <UMAnalytics/MobClick.h>
#import "CommenClickBottomView.h"

#define CMLInfoCellTypeTopMargin       30
#define CMLInfoCellTypeBottomMargin    30
#define CMLInfoCellTypeImageAndTypeSpace  10
#define CMLInfoCellImageHeight         200
#define CMLInfoCellImageWidth          280
#define CMLInfoCellHeight              70
#define CMLInfoCellLeftMargin          20
#define CMLInfoCellLineAndTitleSpace   10
#define CMLInfoCellBtnTopMargin        30
#define CMLInfoCellBtnBottomMargin     30
#define CMLInfoCellBtnAndBtnSpace      60
#define CMLInfoCellBtnImgAndTitleSpace 10
#define CMLInfoCellBottomMargin        40
#define CMLInfoCellBottomViewHeight    20


@interface CMLInfoTVCell()<NetWorkProtocol>

@property (nonatomic,strong) CommenClickBottomView *clickBottomView;

@property (nonatomic,strong) UIImageView *mainImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *briefLabel;

@property (nonatomic,strong) CMLLine *line;

@property (nonatomic,strong) NSNumber *typeID;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIView *bottomView;

/**data*/
@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,copy) NSString *infoTitle;

@property (nonatomic,copy) NSString *infoBrief;

@property (nonatomic,copy) NSString *infoRootType;

@property (nonatomic,copy) NSString *infoType;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favState;

@end

@implementation CMLInfoTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadviews];
        self.typeID =[NSNumber numberWithInt:1];
    }
    return self;
}

- (void) loadviews{

    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.backgroundColor = [UIColor CMLPromptGrayColor];
    self.mainImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.mainImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemBoldFontSize18;
    self.titleLabel.textColor = [UIColor CMLUserBlackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.briefLabel = [[UILabel alloc] init];
    self.briefLabel.font = KSystemFontSize13;
    self.briefLabel.textColor = [UIColor CMLLineGrayColor];
    self.briefLabel.backgroundColor = [UIColor whiteColor];
    self.briefLabel.numberOfLines = 0;
    self.briefLabel.textAlignment =NSTextAlignmentLeft;
    [self.contentView addSubview:self.briefLabel];
    
    self.clickBottomView = [[CommenClickBottomView alloc] initWithTag:1];
    [self.contentView addSubview:self.clickBottomView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor CMLUserGrayColor];
    [self.contentView addSubview:self.bottomView];

}

- (void) refrshInfoCellInMainInterfaceVC:(CMLCommIndexObj *) obj{

    if (obj) {
      
        self.imgUrl = obj.coverPicThumb;
        self.infoTitle = obj.title;
        self.infoType = obj.subTypeName;
        self.infoRootType = obj.rootTypeName;
        self.infoBrief = obj.briefIntro;
        self.currentID = obj.currentID;
        self.favNum = obj.favNum;
        self.hitNum = obj.hitNum;
        self.favState = obj.isUserFav;
        
    }else{
    
        self.imgUrl = @"";
        self.infoTitle = @"test";
        self.infoBrief = @"test";
        self.infoRootType = @"test";
        self.infoType = @"test";
        self.currentID = [NSNumber numberWithInt:1];
    
    }
    
    [self reloadCurrentCell];
}

- (void) refrshInfoCellInInfoVC:(CMLInfoObj *) obj{

    if (obj) {
     
        self.imgUrl = obj.coverPicThumb;
        self.infoTitle = obj.title;
        self.infoBrief = obj.briefIntro;
        self.infoRootType = obj.rootTypeName;
        self.infoType = obj.subTypeName;
        self.currentID = obj.currentID;
        self.favNum = obj.favNum;
        self.hitNum = obj.hitNum;
        self.favState = obj.isUserFav;
        
    }else{
      
        self.imgUrl = @"";
        self.infoTitle = @"test";
        self.infoBrief = @"test";
        self.infoRootType = @"test";
        self.infoType = @"test";
        self.currentID = [NSNumber numberWithInt:1];
        
    }

    [self reloadCurrentCell];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"1%@fav",self.currentID] object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"1%@disFav",self.currentID] object:nil];
}

- (void) reloadCurrentCell{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favThisActivity) name:[NSString stringWithFormat:@"1%@fav",self.currentID] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disFavThisActivity) name:[NSString stringWithFormat:@"1%@disFav",self.currentID] object:nil];
    /*********/

    /**图片请求*/
    self.mainImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - CMLInfoCellLeftMargin*Proportion - CMLInfoCellImageWidth*Proportion,
                                          40*Proportion,
                                          CMLInfoCellImageWidth*Proportion,
                                          CMLInfoCellImageHeight*Proportion);
    [NetWorkTask setImageView:self.mainImageView
                      WithURL:self.imgUrl
             placeholderImage:nil];
    /**名字*/
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = self.infoTitle;
    [self.titleLabel sizeToFit];
    
    if (self.titleLabel.frame.size.width <= (WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion)) {
        self.titleLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                           40*Proportion,
                                           WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion,
                                           self.titleLabel.frame.size.height);
    }else{
        
        self.titleLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                           40*Proportion,
                                           WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion,
                                           self.titleLabel.frame.size.height*2);
    }
    /**brief*/
    self.briefLabel.frame = CGRectZero;
    self.briefLabel.text = self.infoBrief;
    [self.briefLabel sizeToFit];
    self.briefLabel.frame = CGRectMake(CMLInfoCellLeftMargin*Proportion,
                                       CGRectGetMaxY(self.mainImageView.frame) - self.briefLabel.frame.size.height*3,
                                       WIDTH - CMLInfoCellLeftMargin*Proportion*3 - CMLInfoCellImageWidth*Proportion,
                                       self.briefLabel.frame.size.height*3);
    /***/
    if (self.isMainView) {
        
        self.clickBottomView.rootTypeName = self.infoRootType;
        self.clickBottomView.currentTypeName = self.infoType;
        self.clickBottomView.currentID = self.currentID;
        self.clickBottomView.hitNum = self.hitNum;
        self.clickBottomView.collectNum = self.favNum;
        self.clickBottomView.selectState = self.favState;
        [self.clickBottomView refreshCommenClickBottomView];

        self.clickBottomView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.mainImageView.frame) + CMLInfoCellBottomMargin*Proportion,
                                                WIDTH,
                                                self.clickBottomView.currentHeight);
        
        self.bottomView.frame =CGRectMake(0,
                                          CGRectGetMaxY(self.clickBottomView.frame),
                                          WIDTH,
                                          CMLInfoCellBottomViewHeight*Proportion);
    }else{
        self.clickBottomView.hidden = YES;
        self.bottomView.frame =CGRectMake(0,
                                          CGRectGetMaxY(self.mainImageView.frame) + CMLInfoCellBottomMargin*Proportion,
                                          WIDTH,
                                          CMLInfoCellBottomViewHeight*Proportion);
    }
    
    self.cellheight = CGRectGetMaxY(self.bottomView.frame);
}

/************************/
- (void) favThisActivity{
    NSLog(@"收藏");
    /**数据存储地址*/
    [self.clickBottomView refreshCommenClickBottomSelectState:[NSNumber numberWithInt:1]];
}

- (void) disFavThisActivity{
    NSLog(@"不收藏");
    /**数据存储地址*/
    [self.clickBottomView refreshCommenClickBottomSelectState:[NSNumber numberWithInt:2]];

}


@end
