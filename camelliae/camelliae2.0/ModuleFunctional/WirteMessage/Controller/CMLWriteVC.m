//
//  CMLWriteVC.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLWriteVC.h"
#import "VCManger.h"
#import "UIScrollView+CMLExspand.h"
#import "CMLLine.h"
#import "NSString+CMLExspand.h"
#import "ShowImageCell.h"
#import "UIImage+CMLExspand.h"
#import "BaseResultObj.h"
#import "CMLUpLoadImageObj.h"
#import "CMLRSAModule.h"
#import "UploadImageTool.h"
#import "CMLVIPNewDetailVC.h"
#import "DataManager.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "UITextView+Placeholder.h"
#import "CMLTimeLineRelevantActivitySerachVC.h"
#import "CMLTimeLineRelevantTopicSerachVC.h"
#import "NSString+CMLExspand.h"
#import "CMLSettingDetailVC.h"

#define WriteVCAroundMargin           20
#define WriteVCTextInputViewHeight    180
#define WriteVCTimeBtnHeight          56
#define WriteVCExpressBtnHeight       80
#define WriteImageBtnHeight           230
#define WriteBtnBgViewWidth           624
#define WriteBtnHeight                130

typedef NS_ENUM(NSInteger, NSPUIImageType){
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
};
static inline NSPUIImageType NSPUIImageTypeFromData(NSData *imageData){
    if (imageData.length > 4) {
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NSPUIImageType_JPEG;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return NSPUIImageType_PNG;
        }
    }
    
    return NSPUIImageType_Unknown;
}

@interface CMLWriteVC ()<UITextViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NetWorkProtocol,UIAlertViewDelegate,TimeLineRelevantActivitySerachDelegate,TimeLineRelevantTopicSerachDelegate>

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,copy) NSString *tempTimeLine;

@property (nonatomic,copy) NSString *currentTopic;

@property (nonatomic,strong) NSNumber *topicCurrentID;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UITextView *textInputView;

@property (nonatomic,strong) UILabel *indicateLab;

@property (nonatomic,strong) UIView *imageBgView;

@property (nonatomic,assign) CGFloat imagesTopY;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSMutableArray *showImageArray;

@property (nonatomic,strong) NSMutableArray *postImageMesArray;

@property (nonatomic,strong) NSMutableArray *upToNUImageDataArray;

@property (nonatomic,strong) NSMutableArray *tokensArray;

@property (nonatomic,strong) NSMutableArray *keysArray;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UICollectionView *blackShadowView;

@property (nonatomic,assign) int currentTag;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *timelineId;

@property (nonatomic,assign) int progress;

@property (nonatomic,strong) UIView * relevantActivityView;

@property (nonatomic,strong) UIView * relevantTopicView;


@property (nonatomic,assign) BOOL ishasActivity;

@property (nonatomic,assign) BOOL ishasTopic;

@property (nonatomic,assign) BOOL forbidTouch;

@property (nonatomic,copy) NSString *activityImageUrl;

@property (nonatomic,copy) NSString *titile;

@property (nonatomic,strong) NSNumber *activityID;

@property (nonatomic,strong) UILabel *promLab;

@property (nonatomic,strong) UIButton *promBtn;

@end

@implementation CMLWriteVC

- (instancetype)initWithTopic:(NSString *) topic TopicID:(NSNumber *) currentID{
    
    
    self = [super init];
    
    if (self) {
        
        self.currentTopic = topic;
        self.topicCurrentID = currentID;
        self.ishasTopic = YES;
        self.forbidTouch = YES;
    }
    
    return self;
}

- (instancetype)initWithPublishDate:(NSNumber *) publishDate tempTimeLine:(NSString *) tempTimeLine{


    self = [super init];
    if (self) {
        
        self.publishDate = publishDate;
        self.tempTimeLine = tempTimeLine;
    }
    return self;
}

- (NSMutableArray *)postImageMesArray{

    if (!_postImageMesArray) {
        _postImageMesArray = [NSMutableArray array];
    }
    return _postImageMesArray;
}

- (NSMutableArray *)tokensArray{

    if (!_tokensArray) {
        _tokensArray = [NSMutableArray array];
    }
    return _tokensArray;
}

- (NSMutableArray *)keysArray{

    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    return _keysArray;
}

- (NSMutableArray *)upToNUImageDataArray{

    if (!_upToNUImageDataArray) {
        _upToNUImageDataArray = [NSMutableArray array];
    }
    return _upToNUImageDataArray;
}

- (NSMutableArray *)imageArray{

    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)showImageArray{

    if (!_showImageArray) {
        _showImageArray = [NSMutableArray array];
    }
    return _showImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    
    [self loadTopBtn];
    /************************/
 
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame),
                                                                     WIDTH,
                                                                     HEIGHT - self.navBar.frame.size.height - SafeAreaBottomHeight)];
    _mainScrollView.delegate = self;
    [self.contentView addSubview:_mainScrollView];
    
    [self refreshViews];
    
    __weak typeof(self) weakSelf = self;
    self.refreshViewController = ^(){
    
        [weakSelf hideNetErrorTipOfNormalVC];
        
        [weakSelf.postImageMesArray removeAllObjects];
        [weakSelf.tokensArray removeAllObjects];
        [weakSelf.keysArray removeAllObjects];
        [weakSelf.upToNUImageDataArray removeAllObjects];
        [weakSelf.imageArray removeAllObjects];
        [weakSelf.showImageArray removeAllObjects];
        
        [weakSelf refreshViewController];
    
    };
    
}

- (void) loadTopBtn{
    
    UILabel *closeLab = [[UILabel alloc] init];
    closeLab.textColor = [UIColor CMLBlackColor];
    closeLab.text = @"关闭";
    closeLab.font = KSystemFontSize14;
    [closeLab sizeToFit];
    closeLab.frame = CGRectMake(30*Proportion,
                                NavigationBarHeight/2.0 - closeLab.frame.size.height/2.0 + StatusBarHeight,
                                closeLab.frame.size.width,
                                closeLab.frame.size.height);
    [self.navBar addSubview:closeLab];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    StatusBarHeight,
                                                                    CGRectGetMaxX(closeLab.frame),
                                                                    NavigationBarHeight)];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.navBar addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(didSelectedLeftBarItem) forControlEvents:UIControlEventTouchUpInside];
    
    
    /****************/
    
    UILabel *pushLab = [[UILabel alloc] init];
    pushLab.textColor = [UIColor CMLBlackColor];
    pushLab.text = @"发布";
    pushLab.font = KSystemFontSize14;
    [pushLab sizeToFit];
    pushLab.frame = CGRectMake(WIDTH - 30*Proportion - pushLab.frame.size.width,
                               NavigationBarHeight/2.0 - pushLab.frame.size.height/2.0 + StatusBarHeight,
                               pushLab.frame.size.width,
                               pushLab.frame.size.height);
    [self.navBar addSubview:pushLab];
    
    UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - (pushLab.frame.size.width + 30*Proportion),
                                                                   StatusBarHeight,
                                                                   pushLab.frame.size.width + 30*Proportion,
                                                                   NavigationBarHeight)];
    pushBtn.backgroundColor = [UIColor clearColor];
    [self.navBar addSubview:pushBtn];
        [pushBtn addTarget:self action:@selector(startExpress) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void) refreshViews{

    
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    
    [self loadData];
    
    [self loadViews];
}
- (void) loadData{
    
    [self.imageArray removeAllObjects];
    [self.upToNUImageDataArray removeAllObjects];
    [self.postImageMesArray removeAllObjects];
    [self.showImageArray removeAllObjects];
    [self.tokensArray removeAllObjects];
    [self.keysArray removeAllObjects];
    
}

- (void) loadViews{
    
    /**界面刷新*/
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.shadowView removeFromSuperview];
    [self.imageArray removeAllObjects];
    
    
    _textInputView = [[UITextView alloc] initWithFrame:CGRectMake(WriteVCAroundMargin*Proportion,
                                                                  10*Proportion,
                                                                  WIDTH - WriteVCAroundMargin*Proportion*2,
                                                                  WriteVCTextInputViewHeight*Proportion/4*5)];
    _textInputView.font = KSystemFontSize15;
    _textInputView.placeholder = @"晒出你的照片，分享你的心情...";
//    _textInputView.placeholderColor = [UIColor CMLPromptGrayColor];
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"晒出你的照片，分享你的心情..." attributes:@{NSForegroundColorAttributeName : [UIColor CMLPromptGrayColor]}];
    _textInputView.attributedPlaceholder = placeholderAtt;

    _textInputView.backgroundColor = [UIColor clearColor];
    if (self.tempTimeLine) {
        _textInputView.text = self.tempTimeLine;
        
    }
    _textInputView.delegate = self;
    
    [_mainScrollView addSubview:_textInputView];
    
    self.indicateLab = [[UILabel alloc] init];
    self.indicateLab.font = KSystemFontSize11;
    self.indicateLab.textColor = [UIColor CMLBrownColor];
    self.indicateLab.text = [NSString stringWithFormat:@"共输入%lu个字/还剩230个字",self.indicateLab.text.length];
    
    if (self.indicateLab.text.length > 230) {
        
        self.indicateLab.textColor = [UIColor CMLRedColor];
    }else{
        
        self.indicateLab.textColor = [UIColor CMLBrownColor];
    }
    [self.indicateLab sizeToFit];
    self.indicateLab.frame = CGRectMake(WIDTH - 30*Proportion - self.indicateLab.frame.size.width,
                                        CGRectGetMaxY(_textInputView.frame),
                                        self.indicateLab.frame.size.width,
                                        self.indicateLab.frame.size.height);
    [_mainScrollView addSubview:self.indicateLab];

    
    [self setImagesBgView];
    
     _mainScrollView.contentSize = CGSizeMake(WIDTH,
                                              self.imagesTopY + WriteVCAroundMargin*Proportion*4 + WriteImageBtnHeight*Proportion*3 + WriteVCExpressBtnHeight*Proportion);
    /***/
    self.shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.shadowView.hidden = YES;
    [self.contentView addSubview:self.shadowView];
    
}

- (void) setImagesBgView{
    
    self.imagesTopY = CGRectGetMaxY(_textInputView.frame) + 80*Proportion;
    
    [self.imageBgView removeFromSuperview];

    self.imageBgView = [[UIView alloc] init];
    self.imageBgView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:self.imageBgView];
    
    
    NSMutableArray *currentArray;
    
    if (self.imageArray.count < 9) {
        currentArray = [NSMutableArray arrayWithArray:self.imageArray];
        [currentArray addObject:[UIImage imageNamed:WriteExpressImagebtnImg]];
    }else{
        currentArray = [NSMutableArray arrayWithArray:self.imageArray];
    }
    
    for (int i = 0; i < currentArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UIButton *button = [[UIButton alloc] init];
        if (i <3) {
            
            imageView.frame = CGRectMake(WriteVCAroundMargin*Proportion + (WriteImageBtnHeight +10)*Proportion*i,
                                         WriteVCAroundMargin*Proportion,
                                         WriteImageBtnHeight*Proportion,
                                         WriteImageBtnHeight*Proportion);
        }else if (i >=3 && i < 6){
            imageView.frame = CGRectMake(WriteVCAroundMargin*Proportion + (WriteImageBtnHeight +10)*Proportion*(i - 3),
                                         WriteVCAroundMargin*Proportion*2 + WriteImageBtnHeight*Proportion,
                                         WriteImageBtnHeight*Proportion,
                                         WriteImageBtnHeight*Proportion);
        }else{
            imageView.frame = CGRectMake(WriteVCAroundMargin*Proportion + (WriteImageBtnHeight +10)*Proportion*(i - 6),
                                         WriteVCAroundMargin*Proportion*3 + WriteImageBtnHeight*Proportion*2,
                                         WriteImageBtnHeight*Proportion,
                                         WriteImageBtnHeight*Proportion);
        }
        button.frame = imageView.bounds;
        [imageView addSubview:button];
        [_imageBgView addSubview:imageView];
        
        

        imageView.image = currentArray[i];

        
       
        button.tag = i;
        [button addTarget:self action:@selector(enterSelectImageWayView:) forControlEvents:UIControlEventTouchUpInside];
        if (i == currentArray.count - 1) {
            
            self.imageBgView.frame = CGRectMake(0,
                                                self.imagesTopY,
                                                WIDTH,
                                                CGRectGetMaxY(imageView.frame) + 20*Proportion);
        }
    }
    
    [self loadRelevantActivityView];
}


- (void) loadRelevantActivityView{
    
    [self.relevantActivityView removeFromSuperview];
    
    [self.relevantTopicView removeFromSuperview];
    
    [self.promBtn removeFromSuperview];
    
    [self.promLab removeFromSuperview];
    
    self.relevantActivityView = [[UIView alloc] init];
    
    self.relevantActivityView.backgroundColor = [UIColor CMLWhiteColor];
    
    [self.mainScrollView addSubview:self.relevantActivityView];
    
    self.relevantTopicView = [[UIView alloc] init];
    
    self.relevantTopicView.backgroundColor = [UIColor CMLWhiteColor];
    
    [self.mainScrollView addSubview:self.relevantTopicView];
    
    
    if (self.ishasActivity) {
        
        self.relevantActivityView.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.imageBgView.frame) + 50*Proportion,
                                                     WIDTH,
                                                     184*Proportion);
        

        UILabel *title = [[UILabel alloc] init];
        title.textColor = [UIColor CMLBrownColor];
        title.font = KSystemFontSize14;
        title.text = @"关联活动";
        [title sizeToFit];
        title.frame = CGRectMake(72*Proportion,
                                 32*Proportion,
                                 title.frame.size.width,
                                 title.frame.size.height);
        [self.relevantActivityView addSubview:title];
        
        
        
        UIImageView *attentonImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityImg]];
        [attentonImg sizeToFit];
        attentonImg.frame = CGRectMake(30*Proportion,
                                       title.center.y - attentonImg.frame.size.height/2.0,
                                       attentonImg.frame.size.width,
                                       attentonImg.frame.size.height);
        [self.relevantActivityView addSubview:attentonImg];
        
        UIImageView *attentonEnterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityEnterImg]];
        [attentonEnterImg sizeToFit];
        attentonEnterImg.frame = CGRectMake(WIDTH - 30*Proportion - attentonEnterImg.frame.size.width,
                                            title.center.y - attentonEnterImg.frame.size.height/2.0,
                                            attentonEnterImg.frame.size.width,
                                            attentonEnterImg.frame.size.height);
        [self.relevantActivityView addSubview:attentonEnterImg];
        
        UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(title.frame),
                                                                        WIDTH,
                                                                        122*Proportion)];
        [self.relevantActivityView addSubview:activityView];
        
        UIImageView *activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(72*Proportion,
                                                                                   122*Proportion/2.0 - 72*Proportion/2.0,
                                                                                   128*Proportion,
                                                                                   72*Proportion)];
        activityImage.backgroundColor = [UIColor CMLPromptGrayColor];
        activityImage.clipsToBounds = YES;
        activityImage.contentMode = UIViewContentModeScaleAspectFill;
        [activityView addSubview:activityImage];
        [NetWorkTask setImageView:activityImage WithURL:self.activityImageUrl placeholderImage:nil];
        
        UILabel *activityLab = [[UILabel alloc] init];
        activityLab.numberOfLines = 0;
        activityLab.font = KSystemFontSize13;
        activityLab.text = self.titile;
        [activityLab sizeToFit];
        activityLab.frame = CGRectMake(CGRectGetMaxX(activityImage.frame) + 20*Proportion,
                                       122*Proportion/2.0 - activityLab.frame.size.height*2/2.0,
                                       WIDTH - (CGRectGetMaxX(activityImage.frame) + 20*Proportion) - 30*Proportion,
                                       activityLab.frame.size.height*2);
        [activityView addSubview:activityLab];
        
        
    }else{
        
        self.relevantActivityView.frame = CGRectMake(0,
                                                     CGRectGetMaxY(self.imageBgView.frame) + 50*Proportion,
                                                     WIDTH,
                                                     90*Proportion);
        
        UILabel *title = [[UILabel alloc] init];
        title.textColor = [UIColor CMLBrownColor];
        title.font = KSystemFontSize14;
        title.text = @"关联活动";
        [title sizeToFit];
        title.frame = CGRectMake(72*Proportion,
                                 self.relevantActivityView.frame.size.height/2.0 - title.frame.size.height/2.0,
                                 title.frame.size.width,
                                 title.frame.size.height);
        [self.relevantActivityView addSubview:title];
        
        UIImageView *attentonImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityImg]];
        [attentonImg sizeToFit];
        attentonImg.frame = CGRectMake(30*Proportion,
                                       title.center.y - attentonImg.frame.size.height/2.0,
                                       attentonImg.frame.size.width,
                                       attentonImg.frame.size.height);
        [self.relevantActivityView addSubview:attentonImg];
        

        
        UIImageView *attentonEnterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityEnterImg]];
        [attentonEnterImg sizeToFit];
        attentonEnterImg.frame = CGRectMake(WIDTH - 30*Proportion - attentonEnterImg.frame.size.width,
                                            title.center.y - attentonEnterImg.frame.size.height/2.0,
                                            attentonEnterImg.frame.size.width,
                                            attentonEnterImg.frame.size.height);
        [self.relevantActivityView addSubview:attentonEnterImg];
        
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.relevantActivityView.bounds];
    btn.backgroundColor = [UIColor clearColor];
    [self.relevantActivityView addSubview:btn];
    [btn addTarget:self action:@selector(enterSearchActivityVC) forControlEvents:UIControlEventTouchUpInside];
    
    CMLLine *topline = [[CMLLine alloc] init];
    topline.lineWidth = 1;
    topline.lineLength = WIDTH - 30*Proportion*2;
    topline.LineColor = [UIColor CMLNewGrayColor];
    topline.startingPoint = CGPointMake(30*Proportion, 0);
    [self.relevantActivityView addSubview:topline];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.lineLength = WIDTH - 30*Proportion*2;
    bottomLine.lineWidth =1;
    bottomLine.LineColor = [UIColor CMLNewGrayColor];
    bottomLine.startingPoint = CGPointMake(30*Proportion,
                                           self.relevantActivityView.frame.size.height - 1);
    [self.relevantActivityView addSubview:bottomLine];
    
    if (self.ishasTopic) {

        self.relevantTopicView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(self.relevantActivityView.frame),
                                                  WIDTH,
                                                  166*Proportion);
        
        
        UILabel *title = [[UILabel alloc] init];
        title.textColor = [UIColor CMLBrownColor];
        title.font = KSystemFontSize14;
        title.text = @"关联话题";
        [title sizeToFit];
        title.frame = CGRectMake(72*Proportion,
                                 32*Proportion,
                                 title.frame.size.width,
                                 title.frame.size.height);
        [self.relevantTopicView addSubview:title];
        
        
        
        UIImageView *attentonImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PushUserMessageTopicImg]];
        [attentonImg sizeToFit];
        attentonImg.frame = CGRectMake(30*Proportion,
                                       title.center.y - attentonImg.frame.size.height/2.0,
                                       attentonImg.frame.size.width,
                                       attentonImg.frame.size.height);
        [self.relevantTopicView addSubview:attentonImg];
        
        UIImageView *attentonEnterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityEnterImg]];
        [attentonEnterImg sizeToFit];
        attentonEnterImg.frame = CGRectMake(WIDTH - 30*Proportion - attentonEnterImg.frame.size.width,
                                            title.center.y - attentonEnterImg.frame.size.height/2.0,
                                            attentonEnterImg.frame.size.width,
                                            attentonEnterImg.frame.size.height);
        [self.relevantTopicView addSubview:attentonEnterImg];
        

        UILabel *topicLab = [[UILabel alloc] init];
        topicLab.text = [NSString stringWithFormat:@"%@",self.currentTopic];
        topicLab.font = KSystemFontSize12;
        topicLab.textAlignment = NSTextAlignmentCenter;
        topicLab.backgroundColor = [[UIColor CMLBrownColor] colorWithAlphaComponent:0.2];
        topicLab.layer.borderColor = [UIColor CMLBrownColor].CGColor;
        topicLab.textColor = [UIColor CMLBlackColor];
        topicLab.layer.borderWidth = 1;
        [topicLab sizeToFit];
        topicLab.frame = CGRectMake(72*Proportion,
                                    CGRectGetMaxY(title.frame) + 32*Proportion,
                                    topicLab.frame.size.width + 20*Proportion,
                                    topicLab.frame.size.height + 10*Proportion);
        [self.relevantTopicView addSubview:topicLab];
        

        CMLLine *bottomLine = [[CMLLine alloc] init];
        bottomLine.lineLength = WIDTH - 30*Proportion*2;
        bottomLine.lineWidth =1;
        bottomLine.LineColor = [UIColor CMLNewGrayColor];
        bottomLine.startingPoint = CGPointMake(30*Proportion,
                                               self.relevantTopicView.frame.size.height - 1);
        [self.relevantTopicView addSubview:bottomLine];
        
    }else{
        
        self.relevantTopicView.frame = CGRectMake(0,
                                                  CGRectGetMaxY(self.relevantActivityView.frame),
                                                  WIDTH,
                                                  90*Proportion);
        UILabel *title = [[UILabel alloc] init];
        title.textColor = [UIColor CMLBrownColor];
        title.font = KSystemFontSize14;
        title.text = @"关联话题";
        [title sizeToFit];
        title.frame = CGRectMake(72*Proportion,
                                 self.relevantTopicView.frame.size.height/2.0 - title.frame.size.height/2.0,
                                 title.frame.size.width,
                                 title.frame.size.height);
        [self.relevantTopicView addSubview:title];
        
        UIImageView *attentonImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PushUserMessageTopicImg]];
        [attentonImg sizeToFit];
        attentonImg.frame = CGRectMake(30*Proportion,
                                       title.center.y - attentonImg.frame.size.height/2.0,
                                       attentonImg.frame.size.width,
                                       attentonImg.frame.size.height);
        [self.relevantTopicView addSubview:attentonImg];
        
        
        
        UIImageView *attentonEnterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PostAttentionActivityEnterImg]];
        [attentonEnterImg sizeToFit];
        attentonEnterImg.frame = CGRectMake(WIDTH - 30*Proportion - attentonEnterImg.frame.size.width,
                                            title.center.y - attentonEnterImg.frame.size.height/2.0,
                                            attentonEnterImg.frame.size.width,
                                            attentonEnterImg.frame.size.height);
        [self.relevantTopicView addSubview:attentonEnterImg];
        
        CMLLine *bottomLine = [[CMLLine alloc] init];
        bottomLine.lineLength = WIDTH - 30*Proportion*2;
        bottomLine.lineWidth =1;
        bottomLine.LineColor = [UIColor CMLNewGrayColor];
        bottomLine.startingPoint = CGPointMake(30*Proportion,
                                               self.relevantTopicView.frame.size.height - 1);
        [self.relevantTopicView addSubview:bottomLine];
        
    }
    
    UIButton *topicBtn = [[UIButton alloc] initWithFrame:self.relevantTopicView.bounds];
    topicBtn.backgroundColor = [UIColor clearColor];
    [self.relevantTopicView addSubview:topicBtn];
    [topicBtn addTarget:self action:@selector(enterSearchTopicVC) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.forbidTouch) {
        
        topicBtn.userInteractionEnabled = NO;
    }
    
    if (CGRectGetMaxY(self.relevantTopicView.frame) + 100*Proportion < self.mainScrollView.frame.size.height) {
        
        self.promLab = [[UILabel alloc] init];
        self.promLab.font = KSystemFontSize11;
        self.promLab.textColor = [UIColor CMLtextInputGrayColor];
        self.promLab.text = @"发布动态即同意条款";
        [self.promLab sizeToFit];
        [self.mainScrollView addSubview:self.promLab];
        
        self.promBtn = [[UIButton alloc] init];
        self.promBtn.titleLabel.font = KSystemFontSize11;
        [self.promBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        [self.promBtn setTitle:@"服务于隐私条款" forState:UIControlStateNormal];
        [self.promBtn sizeToFit];
        [self.mainScrollView addSubview:self.promBtn];
        [self.promBtn addTarget:self action:@selector(messageVC) forControlEvents:UIControlEventTouchUpInside];
        
        self.promLab.frame = CGRectMake(WIDTH/2.0 - (self.promLab.frame.size.width + self.promBtn.frame.size.width)/2.0,
                                        self.mainScrollView.frame.size.height - 100*Proportion,
                                        self.promLab.frame.size.width,
                                        self.promLab.frame.size.height);
        
        self.promBtn.frame = CGRectMake(CGRectGetMaxX(self.promLab.frame),
                                        self.promLab.center.y - self.promBtn.frame.size.height/2.0,
                                        self.promBtn.frame.size.width,
                                        self.promBtn.frame.size.height);
        
    }else{
        
        self.promLab = [[UILabel alloc] init];
        self.promLab.font = KSystemFontSize11;
        self.promLab.textColor = [UIColor CMLtextInputGrayColor];
        self.promLab.text = @"发布动态即同意条款";
        [self.promLab sizeToFit];
        [self.mainScrollView addSubview:self.promLab];
        
        self.promBtn = [[UIButton alloc] init];
        self.promBtn.titleLabel.font = KSystemFontSize11;
        [self.promBtn setTitleColor:[UIColor CMLBrownColor] forState:UIControlStateNormal];
        [self.promBtn setTitle:@"服务及隐私条款" forState:UIControlStateNormal];
        [self.promBtn sizeToFit];
        [self.mainScrollView addSubview:self.promBtn];
        [self.promBtn addTarget:self action:@selector(messageVC) forControlEvents:UIControlEventTouchUpInside];
        
        self.promLab.frame = CGRectMake(WIDTH/2.0 - (self.promLab.frame.size.width + self.promBtn.frame.size.width)/2.0,
                                        CGRectGetMaxY(self.relevantTopicView.frame) + 100*Proportion,
                                        self.promLab.frame.size.width,
                                        self.promLab.frame.size.height);
        
        self.promBtn.frame = CGRectMake(CGRectGetMaxX(self.promLab.frame),
                                        self.promLab.center.y - self.promBtn.frame.size.height/2.0,
                                        self.promBtn.frame.size.width,
                                        self.promBtn.frame.size.height);
        
    }
   
    
    _mainScrollView.contentSize = CGSizeMake(WIDTH,
                                             CGRectGetMaxY(self.relevantTopicView.frame) + 200*Proportion);

    
    
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    
    /**************************/

        CGRect frame = textView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [textView sizeThatFits:constraintSize];
    
    
        if (size.height > WriteVCTextInputViewHeight*Proportion/4*5) {
         
            textView.frame = CGRectMake(frame.origin.x,
                                        frame.origin.y,
                                        frame.size.width,
                                        size.height);
            
            self.indicateLab.text = [NSString stringWithFormat:@"共输入%ld个字/还剩%ld个字",self.textInputView.text.length,230 - self.textInputView.text.length];
            
            if (self.textInputView.text.length > 230) {
                
                self.indicateLab.textColor = [UIColor CMLRedColor];
                self.indicateLab.text = [NSString stringWithFormat:@"共输入%ld个字/还剩0个字",self.textInputView.text.length];
            }else{
                
                self.indicateLab.textColor = [UIColor CMLBrownColor];
            }
            [self.indicateLab sizeToFit];
            self.indicateLab.frame = CGRectMake(WIDTH - 30*Proportion - self.indicateLab.frame.size.width,
                                                CGRectGetMaxY(_textInputView.frame) + 40*Proportion,
                                                self.indicateLab.frame.size.width,
                                                self.indicateLab.frame.size.height);
            
            
            [self setImagesBgView];
        }else{
        
            self.indicateLab.text = [NSString stringWithFormat:@"共输入%d个字/还剩%d个字",(int)self.textInputView.text.length,(int)(230 - self.textInputView.text.length)];
            
            if (self.textInputView.text.length > 230) {
                
                self.indicateLab.textColor = [UIColor CMLRedColor];
                self.indicateLab.text = [NSString stringWithFormat:@"共输入%d个字/还剩0个字",(int)self.textInputView.text.length];
            }else{
                
                self.indicateLab.textColor = [UIColor CMLBrownColor];
            }
            [self.indicateLab sizeToFit];
            self.indicateLab.frame = CGRectMake(WIDTH - 30*Proportion - self.indicateLab.frame.size.width,
                                                CGRectGetMaxY(_textInputView.frame) + 40*Proportion,
                                                self.indicateLab.frame.size.width,
                                                self.indicateLab.frame.size.height);
        }
        
        self.textInputView.scrollEnabled = NO;
    
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSelectedLeftBarItem{

    if (self.textInputView.text.length > 0 || self.imageArray.count > 0) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"退出此次编辑？"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"退出", nil];
        
        [self.view addSubview:alterView];
        [alterView show];
        
    }else{
    
        [self.textInputView resignFirstResponder];
        
        [[VCManger mainVC] dismissCurrentVC];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

     [self.textInputView resignFirstResponder];
}

- (void) enterSelectImageWayView:(UIButton*) button{
    
    if (button.tag == self.imageArray.count) {
        [self changUserHeadImage];
    }else{
    
        NSLog(@"图片浏览功能");
        self.currentTag = (int)button.tag;
        [self showImages];
    
    }


}

- (void) showImages{

    [self.blackShadowView removeFromSuperview];
    
    
    [self.showImageArray removeAllObjects];
    
    
    for (int i = 0; i < self.imageArray.count; i++) {
        
        [self.showImageArray addObject:self.imageArray[i]];
        
    }
    
    //创建collectionview
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.blackShadowView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             WIDTH+ 10,
                                                                             HEIGHT)
                                             collectionViewLayout:flowLayout];
    self.blackShadowView.bounces = YES;
    self.blackShadowView.delegate = self;
    self.blackShadowView.dataSource = self;
    self.blackShadowView.pagingEnabled = YES;
    self.blackShadowView.showsHorizontalScrollIndicator = NO;
    self.blackShadowView.showsVerticalScrollIndicator = NO;
    
    if (self.currentTag) {
        [self.blackShadowView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self.contentView addSubview:self.blackShadowView];
    
    //注册
    [self.blackShadowView registerClass:[ShowImageCell class]
             forCellWithReuseIdentifier:@"NFPhotoViewCell"];


}

#pragma mark - changUserHeadImage
- (void) changUserHeadImage{
    
    for (int i = 0; i < self.shadowView.subviews.count; i++) {
        UIView *view = self.shadowView.subviews[i];
        [view removeFromSuperview];
    }
    
    UIView *buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    WriteBtnBgViewWidth*Proportion,
                                                                    WriteBtnHeight*Proportion*2)];
    buttonBgView.center = self.shadowView.center;
    buttonBgView.backgroundColor = [UIColor whiteColor];
    buttonBgView.layer.cornerRadius = 4*Proportion;
    [self.shadowView addSubview:buttonBgView];
    
    UIButton *imagePickerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          WriteBtnBgViewWidth*Proportion,
                                                                          WriteBtnHeight*Proportion)];
    [imagePickerBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
    imagePickerBtn.titleLabel.font = KSystemFontSize15;
    [imagePickerBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [buttonBgView addSubview:imagePickerBtn];
    [imagePickerBtn addTarget:self action:@selector(enterPictureVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     WriteBtnHeight*Proportion,
                                                                     WriteBtnBgViewWidth*Proportion,
                                                                     WriteBtnHeight*Proportion)];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    cameraBtn.titleLabel.font = KSystemFontSize15;
    [cameraBtn setTitleColor:[UIColor CMLUserBlackColor] forState:UIControlStateNormal];
    [buttonBgView addSubview:cameraBtn];
    [cameraBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.LineColor = [UIColor CMLPromptGrayColor];
    line.lineLength = 550*Proportion;
    line.lineWidth = 1;
    line.startingPoint = CGPointMake((WriteBtnBgViewWidth - 550)*Proportion/2.0, WriteBtnHeight*Proportion);
    [buttonBgView addSubview:line];
    
    self.shadowView.hidden = NO;
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    [self.textInputView resignFirstResponder];
    if (!self.shadowView.hidden) {
        self.shadowView.hidden = YES;
    }
    
}

#pragma mark - 打开相册
- (void) enterPictureVC{
       
    __weak typeof(self) weakSelf = self;
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.maxSelectCount = 9;
    [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
       
//        [weakSelf.imageArray removeAllObjects];
        [weakSelf.imageArray addObjectsFromArray:selectPhotos];
        [weakSelf setImagesBgView];
        weakSelf.shadowView.hidden = YES;
        
    }];
}

#pragma mark - 打开相机
- (void) openCamera{

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.showImageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NFPhotoViewCell" forIndexPath:indexPath];
    
    [cell showViewInfo:self.showImageArray indexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    cell.touchUpBlock = ^(){
    
        weakSelf.blackShadowView.hidden = YES;
    
    };
    cell.deleteImage = ^(){
    
        if (weakSelf.imageArray.count == 1) {
            weakSelf.currentTag = 0;
            [weakSelf.imageArray removeLastObject];
            [weakSelf setImagesBgView];
            weakSelf.blackShadowView.hidden = YES;
            
        }else{
            weakSelf.currentTag = 0;
            [weakSelf.imageArray removeObjectAtIndex:indexPath.row];
            [weakSelf showImages];
            [weakSelf setImagesBgView];
            
        }
    };
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width,  self.blackShadowView.bounds.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 0, 5, 10);
}

- (void) startExpress{

    
    
    if (self.textInputView.text.length > 0 && self.textInputView.text.length <=230) {
        
        
        if (self.imageArray.count >0) {
        
            _progress = 0;
            
            /****/
            [self setExpressMessageRequest];
            
        }else{
        
            [self showFailTemporaryMes:@"请添加您的照片"];
        }
        
    }else if (self.textInputView.text.length > 230){
        
        [self showFailTemporaryMes:@"请精简直230字"];
        
    }else{
    
        
        [self showSuccessTemporaryMes:@"请书写您的故事"];
    }
    
    
}

- (void) setExpressMessageRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.textInputView.text forKey:@"eventContent"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:reqTime forKey:@"eventTime"];
    if (self.activityID) {
        [paraDic setObject:self.activityID forKey:@"objId"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"projectObjType"];
    }
    
    if (self.topicCurrentID) {
        
        [paraDic setObject:self.topicCurrentID forKey:@"themeId"];
    }
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"objType"];

    [NetWorkTask postResquestWithApiName:NewExpressMessage paraDic:paraDic delegate:delegate];
    self.currentApiName = NewExpressMessage;
    
    [self startIndicatorLoadingWithShadow];
    
}

- (void) setGetImageTokenRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.timelineId forKey:@"objId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.postImageMesArray options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *rawPicArr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [paraDic setObject:rawPicArr forKey:@"rawPicArr"];
   NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,self.timelineId,[rawPicArr md5],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:GetToken paraDic:paraDic delegate:delegate];
    self.currentApiName = GetToken;
 
    
}

- (void) delegateTimeLine{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.timelineId forKey:@"timelineId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.timelineId,skey,reqTime]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:DeleteTimeLine paraDic:paraDic delegate:delegate];
    self.currentApiName = DeleteTimeLine;

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:NewExpressMessage]) {
      
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.timelineId;
            
             [self initPostImageMessage];
            
            if (self.postImageMesArray.count > 0) {
                
                [self setGetImageTokenRequest];
                
            }else{
            
                [self stopIndicatorLoadingWithShadow];
                
//                CMLVIPNewDetailVC *vc1 = [[CMLVIPNewDetailVC alloc] initWithNickName:[[DataManager lightData] readNickName]
//                                                                       currnetUserId:[[DataManager lightData] readUserID] isReturnUpOneLevel:NO];
//                [[VCManger mainVC] pushVC:vc1 animate:YES];
                
            }
        }else if ([obj.retCode intValue] == 100101){
        
            [self showReloadView];
            
        }else{
            
            [self stopIndicatorLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
        
    }else if ([self.currentApiName isEqualToString:GetToken]){
    

        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        
        if ([obj.retCode intValue] == 0) {
            
                for (int i = 0; i < obj.retData.dataList.count; i++) {
                    
                    CMLUpLoadImageObj *imageObj = [CMLUpLoadImageObj getBaseObjFrom:obj.retData.dataList[i]];
                   
                    [self.keysArray addObject:imageObj.uploadKeyName];
                    NSString *token = [CMLRSAModule decryptString:imageObj.upToken publicKey:PUBKEY];
                    [self.tokensArray addObject:token];
                    
                }
            
            __weak typeof(self) weskSelf = self;
            [UploadImageTool uploadImages:self.upToNUImageDataArray keys:self.keysArray Tokens:self.tokensArray progress:^(CGFloat progress) {
                
                NSLog(@"*****%f",progress);
            } success:^(NSArray * array) {
               
                [weskSelf stopIndicatorLoading];
                NSLog(@"成功***%@",array);
                [weskSelf showSuccessTemporaryMes:@"发表成功"];
                
                if (weskSelf.isDismissPop) {
                    [self.delegate refreshVIPDetailVC];
                
                    [[VCManger mainVC] dismissCurrentVC];
                }else{
                
//                    CMLVIPNewDetailVC *vc1 = [[CMLVIPNewDetailVC alloc] initWithNickName:[[DataManager lightData] readNickName]
//                                                                           currnetUserId:[[DataManager lightData] readUserID] isReturnUpOneLevel:NO];
//                    [[VCManger mainVC] pushVC:vc1 animate:YES];
                }
                
            } failure:^{
                NSLog(@"失败");
                [weskSelf delegateTimeLine];
                
            }];
            
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopIndicatorLoading];
            [self showReloadView];
            
        }else{
            [self stopIndicatorLoading];
            [self showFailTemporaryMes:obj.retMsg];
        }
    
    }else if ([self.currentApiName isEqualToString:DeleteTimeLine]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
        

        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:obj.retMsg];
        }
        
        [self stopIndicatorLoading];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopIndicatorLoadingWithShadow];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    [self showNetErrorTipOfNormalVC];
    if ([self.currentApiName isEqualToString:GetToken]) {
        
        [self delegateTimeLine];
    }
}

- (void) initPostImageMessage{

    
    for ( int i = 0; i < self.imageArray.count; i++) {
        
        UIImage *image = self.imageArray[i];
        

        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(image, 1.0);
        }else{
            data = UIImagePNGRepresentation(image);
        }
        
        /**压缩并获取大小*/
        
        NSPUIImageType imageType = NSPUIImageTypeFromData(data);
        
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
        if (imageType == NSPUIImageType_JPEG) {
            
            NSData *uploaderData = UIImageJPEGRepresentation(image, 1.0);
            
            NSLog(@"该图片格式为jpeg");
            [imageDic setObject:@"jpg" forKey:@"imgType"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.width] forKey:@"imgWidth"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.height] forKey:@"imgHeight"];
            [imageDic setObject:[NSNumber numberWithInt:(int)uploaderData.length] forKey:@"fileSize"];
            
            
            [self.upToNUImageDataArray addObject:uploaderData];
        }else{
            
            NSLog(@"该图片格式为png");
            
            NSData *uploaderData = UIImagePNGRepresentation(image);
            [imageDic setObject:@"png" forKey:@"imgType"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.width] forKey:@"imgWidth"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.height] forKey:@"imgHeight"];
            [imageDic setObject:[NSNumber numberWithInt:(int)uploaderData.length] forKey:@"fileSize"];
            
            [self.upToNUImageDataArray addObject:uploaderData];
            
        }
        
        [self.postImageMesArray addObject:imageDic];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self.textInputView resignFirstResponder];
        [[VCManger mainVC] dismissCurrentVC];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.imageArray addObject:image];
    [self setImagesBgView];
    self.shadowView.hidden = YES;
    
    [picker dismissViewControllerAnimated:YES completion:^{
//        [UIApplication sharedApplication].statusBarHidden = YES;
    }];

}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if (!self.shadowView.hidden) {
        self.shadowView.hidden = YES;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void) enterSearchActivityVC{

    CMLTimeLineRelevantActivitySerachVC *vc = [[CMLTimeLineRelevantActivitySerachVC alloc] init];
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) refreshRelevantActivityWith:(NSString *) imageUrl activityID:(NSNumber *) currentID activityTitle:(NSString*) titile{

    self.titile= titile;
    self.activityImageUrl = imageUrl;
    self.activityID = currentID;
    self.ishasActivity = YES;
    [self loadRelevantActivityView];
}

- (void) enterSearchTopicVC{
    
    CMLTimeLineRelevantTopicSerachVC *vc = [[CMLTimeLineRelevantTopicSerachVC alloc] init];
    vc.delegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) refreshRelevantTopicID:(NSNumber *) currentID topicTitle:(NSString*) titile{
    
    self.currentTopic= titile;
    self.topicCurrentID = currentID;
    self.ishasTopic = YES;
    [self loadRelevantActivityView];
}


- (void) messageVC{
    
    CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] initWithTitle:@"服务及隐私条款"];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}
@end
