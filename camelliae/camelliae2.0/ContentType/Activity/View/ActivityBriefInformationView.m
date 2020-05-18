//
//  ActivityTopMessageView.m
//  camelliae2.0
//
//  Created by 张越 on 2016/12/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "ActivityBriefInformationView.h"
#import "BaseResultObj.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NetWorkTask.h"
#import "CMLLine.h"
#import "NSDate+CMLExspand.h"
#import "InformationDefaultVC.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"
#import "UpGradeVC.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"
#import "CMLPicObjInfo.h"

#define ActivityDefaultVCLeftMargn                  30
#define ActivityDefaultVCNameTopMargin              30
#define ActivityDefaultVCNameBottomMargin           20
#define ActivityDefaultVCNumLabelBottomMargin       30
#define ActivityDefaultVCAttributeLabelSpace        20
#define ActivityDefaultVCAttributeLabelBottomMargin 40
#define ActivityDefaultVCReviewRowHeight            100
#define ActivityDefaultVCReviewTypeAndNameSpace     30
#define ActivityDefaultVCDianHeightAndWidth         14

@interface ActivityBriefInformationView ()<UIActionSheetDelegate,UIScrollViewDelegate>

@property (nonatomic,copy) NSString *telePhoneNum;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong)UIScrollView *topImageScrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation ActivityBriefInformationView

- (instancetype)initWith:(BaseResultObj *)obj{

    self = [super init];
    
    if (self) {

        self.obj = obj;
        self.backgroundColor = [UIColor clearColor];
        [self loadViews];
    }
    
    return self;
}

- (void) loadViews{
        
    self.currentIndex = 0 ;

    UIView *contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         WIDTH,
                                                                         10000)];
    contentHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentHeaderView];
    
    self.topImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             WIDTH,
                                                                             WIDTH/16*9)];
    self.topImageScrollView.pagingEnabled = YES;
    self.topImageScrollView.backgroundColor = [UIColor CMLNewGrayColor];
    self.topImageScrollView.contentSize = CGSizeMake(WIDTH*self.obj.retData.coverPicArr.count,
                                                     WIDTH/16*9);
    self.topImageScrollView.showsVerticalScrollIndicator = NO;
    self.topImageScrollView.showsHorizontalScrollIndicator = NO;
    self.topImageScrollView.delegate = self;
    [contentHeaderView addSubview:self.topImageScrollView];
    
    for (int i = 0; i < self.obj.retData.coverPicArr.count; i ++) {
        
        CMLPicObjInfo *imageObj = [CMLPicObjInfo getBaseObjFrom:self.obj.retData.coverPicArr[i]];
        /*对gif图片的处理*/
        if ([imageObj.coverPic hasSuffix:@"gif"]) {
            YYAnimatedImageView *topImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                                  0,
                                                                                                  WIDTH,
                                                                                                  WIDTH/16*9)];
            topImage.backgroundColor = [UIColor CMLPromptGrayColor];
            topImage.contentMode = UIViewContentModeScaleAspectFill;
            topImage.clipsToBounds = YES;
            [self.topImageScrollView addSubview:topImage];
            [NetWorkTask setImageView:topImage WithURL:imageObj.coverPic placeholderImage:nil];
            topImage.tag = i + 1;

        }else {
            UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i,
                                                                                  0,
                                                                                  WIDTH,
                                                                                  WIDTH/16*9)];
            topImage.backgroundColor = [UIColor CMLPromptGrayColor];
            topImage.contentMode = UIViewContentModeScaleAspectFill;
            topImage.clipsToBounds = YES;
            [self.topImageScrollView addSubview:topImage];
            [NetWorkTask setImageView:topImage WithURL:imageObj.coverPic placeholderImage:nil];
            topImage.tag = i + 1;

        }
        
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                       WIDTH/16*9 - 60*Proportion,
                                                                       WIDTH,
                                                                       20*Proportion)];
    self.pageControl.numberOfPages = self.obj.retData.coverPicArr.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor CMLBlackColor];
    self.pageControl.pageIndicatorTintColor = [[UIColor CMLBlackColor]colorWithAlphaComponent:0.5 ];
    self.pageControl.currentPage = 0;
    [contentHeaderView addSubview:self.pageControl];
    
    if (self.obj.retData.coverPicArr.count == 1) {
        
        self.pageControl.hidden = YES;
    }
    
    UIView *otherMessageView = [[UIView alloc] initWithFrame:CGRectMake(20*Proportion,
                                                                        WIDTH/16*9 - 20*Proportion,
                                                                        WIDTH - 20*Proportion*2,
                                                                        1000)];
    otherMessageView.backgroundColor = [UIColor whiteColor];
    otherMessageView.layer.shadowColor = [UIColor blackColor].CGColor;
    otherMessageView.layer.shadowOpacity = 0.05;
    otherMessageView.layer.shadowOffset = CGSizeMake(0, 0);
    [contentHeaderView addSubview:otherMessageView];
    
    /**name*/
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = KSystemRealBoldFontSize15;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor CMLUserBlackColor];
    nameLabel.text = self.obj.retData.title;
    nameLabel.numberOfLines = 0;
    CGRect nameRect = [nameLabel.text boundingRectWithSize:CGSizeMake(WIDTH - 2*ActivityDefaultVCLeftMargn*Proportion - 20*Proportion*2, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:KSystemBoldFontSize15 }
                                                   context:nil];
    nameLabel.frame =CGRectMake(ActivityDefaultVCLeftMargn*Proportion,
                                ActivityDefaultVCNameTopMargin*Proportion,
                                otherMessageView.frame.size.width - 2*ActivityDefaultVCLeftMargn*Proportion,
                                nameRect.size.height);
    [otherMessageView addSubview:nameLabel];
    
    /**numLabel*/
    
    UILabel *promLabel = [[UILabel alloc] init];
    promLabel.font = KSystemRealBoldFontSize16;
    
    
        PackDetailInfoObj *costObj = [PackDetailInfoObj getBaseObjFrom:[self.obj.retData.packageInfo.dataList firstObject]];
        
        if ([costObj.totalAmount intValue] == 0) {
            
            promLabel.text = @"免费";
            
        }else{
            
            promLabel.text = [NSString stringWithFormat:@"%@元／人",costObj.totalAmount];
        }


    
    promLabel.textColor = [UIColor CMLBrownColor];
    [promLabel sizeToFit];
    promLabel.frame = CGRectMake(otherMessageView.frame.size.width/2.0 - promLabel.frame.size.width - 14*Proportion,
                                 CGRectGetMaxY(nameLabel.frame) + 20*Proportion,
                                 promLabel.frame.size.width,
                                 promLabel.frame.size.height);
    [otherMessageView addSubview:promLabel];
    
    UILabel *allStation = [[UILabel alloc] init];
    allStation.font = KSystemFontSize13;
    allStation.textColor = [UIColor CMLBlackColor];
    allStation.text = [NSString stringWithFormat:@"总席位%@个",self.obj.retData.memberLimitNum];
    [allStation sizeToFit];
    allStation.frame = CGRectMake(CGRectGetMaxX(promLabel.frame) + 28*Proportion,
                                  CGRectGetMaxY(promLabel.frame) - allStation.frame.size.height,
                                  allStation.frame.size.width,
                                  allStation.frame.size.height);
    [otherMessageView addSubview:allStation];
    
    promLabel.frame = CGRectMake(otherMessageView.frame.size.width/2.0  - (promLabel.frame.size.width + 20*Proportion + allStation.frame.size.width)/2.0 ,
                                 CGRectGetMaxY(nameLabel.frame) + 20*Proportion,
                                 promLabel.frame.size.width,
                                 promLabel.frame.size.height);
    allStation.frame = CGRectMake(CGRectGetMaxX(promLabel.frame) + 28*Proportion,
                                  CGRectGetMaxY(promLabel.frame) - allStation.frame.size.height,
                                  allStation.frame.size.width,
                                  allStation.frame.size.height);
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(ActivityDefaultVCLeftMargn*Proportion, CGRectGetMaxY(promLabel.frame) + 50*Proportion);
    line.lineWidth = 2*Proportion;
    line.LineColor = [UIColor CMLPromptGrayColor];
    line.directionOfLine = HorizontalLine;
    line.lineLength = otherMessageView.frame.size.width - ActivityDefaultVCLeftMargn*Proportion*2;
    [otherMessageView addSubview:line];
    
    /**attribute*/
    
    
    UILabel *memeberLvlLab = [[UILabel alloc] init];
    memeberLvlLab.textColor = [UIColor CMLBlackColor];
    memeberLvlLab.textAlignment = NSTextAlignmentCenter;
    memeberLvlLab.font = KSystemFontSize13;
    if ([self.obj.retData.memberLevelId intValue] == 1) {
        
        memeberLvlLab.text = @"粉色会员";
        
    }else if ([self.obj.retData.memberLevelId intValue] == 2){
        
        memeberLvlLab.text = @"黛色会员";
        
    }else if ([self.obj.retData.memberLevelId intValue] == 3){
        
        memeberLvlLab.text = @"金色会员";
    }else{
        
        memeberLvlLab.text = @"墨色会员";
    }
    [memeberLvlLab sizeToFit];
    memeberLvlLab.frame = CGRectMake(0,
                                     CGRectGetMaxY(promLabel.frame) + 100*Proportion,
                                     otherMessageView.frame.size.width,
                                     memeberLvlLab.frame.size.height);
    [otherMessageView addSubview:memeberLvlLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor CMLBlackColor];
    timeLab.font = KSystemFontSize13;
    timeLab.textAlignment = NSTextAlignmentCenter;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actBeginTime intValue]];
    NSString *weakNum = [NSDate getTheWeekOfDate:date];
    NSString *finalTimeStyle;
    NSString *beginTime = [NSDate getStringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actBeginTime integerValue]]];
    NSString *endTime = [NSDate getStringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actEndTime integerValue]]];
    
    if ([beginTime isEqualToString:endTime]) {
        
        finalTimeStyle = [NSString stringWithFormat:@"%@  %@",self.obj.retData.actDateZone,weakNum];
    }else{
        finalTimeStyle = [NSString stringWithFormat:@"%@",self.obj.retData.actDateZone];
    }
    
    timeLab.text = finalTimeStyle;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(0,
                               CGRectGetMaxY(memeberLvlLab.frame) + ActivityDefaultVCNameTopMargin*Proportion,
                               otherMessageView.frame.size.width,
                               timeLab.frame.size.height);
    [otherMessageView addSubview:timeLab];
    
    UILabel *teleNumLab = [[UILabel alloc] init];
    teleNumLab.textColor = [UIColor CMLBlackColor];
    teleNumLab.font = KSystemFontSize13;
    
    if (self.obj.retData.telephoneArr.count == 1) {
        teleNumLab.text = [NSString stringWithFormat:@"%@",[self.obj.retData.telephoneArr firstObject]];
    }else{
    
        NSMutableString *targetStr = [NSMutableString string];
        for (int i = 0; i < self.obj.retData.telephoneArr.count; i++) {
            
            [targetStr appendString:[NSString stringWithFormat:@"%@;",self.obj.retData.telephoneArr[i]]];
        }
        
        teleNumLab.text = [targetStr substringToIndex:targetStr.length - 1];
    }
    
    teleNumLab.textAlignment = NSTextAlignmentCenter;
    [teleNumLab sizeToFit];
    teleNumLab.frame = CGRectMake(0,
                                  CGRectGetMaxY(timeLab.frame) + ActivityDefaultVCNameTopMargin*Proportion,
                                  otherMessageView.frame.size.width,
                                  teleNumLab.frame.size.height);
    [otherMessageView addSubview:teleNumLab];
    
    UIButton *telebtn = [[UIButton alloc] init];
    [telebtn setImage:[UIImage imageNamed:NewDetailMessageTeltNumBtnImg] forState:UIControlStateNormal];
    [telebtn sizeToFit];
    telebtn.frame = CGRectMake(otherMessageView.frame.size.width - 30*Proportion - telebtn.frame.size.width,
                           teleNumLab.center.y - telebtn.frame.size.height/2.0,
                           telebtn.frame.size.width,
                           telebtn.frame.size.height);
    [otherMessageView addSubview:telebtn];
    [telebtn addTarget:self action:@selector(callNum) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = [UIColor CMLBlackColor];
    addressLab.font = KSystemFontSize13;
    addressLab.text = self.obj.retData.simpleAddress;
    addressLab.numberOfLines = 0;
    addressLab.textAlignment = NSTextAlignmentCenter;
     CGRect currentRect = [addressLab.text boundingRectWithSize:CGSizeMake(otherMessageView.frame.size.width - 115*Proportion*2, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                            context:nil];
    addressLab.frame = CGRectMake(115*Proportion,
                                  CGRectGetMaxY(teleNumLab.frame) + ActivityDefaultVCNameTopMargin*Proportion,
                                  otherMessageView.frame.size.width - 115*Proportion*2,
                                  currentRect.size.height);
    [otherMessageView addSubview:addressLab];
    
    UIButton *addressbtn = [[UIButton alloc] init];
    [addressbtn setImage:[UIImage imageNamed:NewDetailMessageAddressBtnImg] forState:UIControlStateNormal];
    [addressbtn sizeToFit];
    addressbtn.frame = CGRectMake(otherMessageView.frame.size.width - 30*Proportion - telebtn.frame.size.width,
                                  addressLab.center.y - addressbtn.frame.size.height/2.0,
                                  addressbtn.frame.size.width,
                                  addressbtn.frame.size.height);
    [otherMessageView addSubview:addressbtn];
    [addressbtn addTarget:self action:@selector(enterBDMap) forControlEvents:UIControlEventTouchUpInside];
    

    otherMessageView.frame = CGRectMake(20*Proportion,
                                        WIDTH/16*9 - 20*Proportion,
                                        WIDTH - 20*Proportion*2,
                                        CGRectGetMaxY(addressLab.frame) + 50*Proportion);
    
    contentHeaderView.frame = CGRectMake(0,
                                         0,
                                         WIDTH,
                                         CGRectGetMaxY(otherMessageView.frame));
    

    self.currentHeight = CGRectGetMaxY(otherMessageView.frame);
}


#pragma mark - enterBDMap
- (void) enterBDMap{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSString *str1 = [self.obj.retData.simpleAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *stringURL =[NSString stringWithFormat:@"baidumap://map/geocoder?address=%@",str1];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];

    }else{
    
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"抱歉，请您先下载百度地图"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alterView show];
    }
    
}

- (void) callNum{
    
    UIActionSheet *sheet;
    if (self.obj.retData.telephoneArr.count == 1) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: [self.obj.retData.telephoneArr firstObject], nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: [self.obj.retData.telephoneArr firstObject],[self.obj.retData.telephoneArr lastObject], nil];
    }
    [sheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != self.obj.retData.telephoneArr.count) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.obj.retData.telephoneArr[buttonIndex]]]];
    }
}

- (void) hiddenTopImage{

    if (!self.topImageScrollView.hidden) {
        self.topImageScrollView.hidden = YES;
        self.pageControl.hidden = YES;
        
        if (self.obj.retData.coverPicArr.count == 1) {
            
            self.pageControl.hidden = YES;
        }
    }
    
}

- (void) showTopImage{

    if (self.topImageScrollView.hidden) {
         self.topImageScrollView.hidden = NO;
        self.pageControl.hidden = NO;
        
        if (self.obj.retData.coverPicArr.count == 1) {
            
            self.pageControl.hidden = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int i = scrollView.contentOffset.x/WIDTH;
    self.pageControl.currentPage = i;
    self.currentIndex = i;
    self.currentImage = [self.topImageScrollView viewWithTag:i+1];
}

@end
