//
//  LMWordViewOfGoodsController.m
//  camelliae2.0
//
//  Created by 张越 on 2018/11/7.
//  Copyright © 2018 张越. All rights reserved.
//

#import "LMWordViewOfGoodsController.h"
#import "LMWordView.h"
#import "LMSegmentedControl.h"
#import "LMStyleSettingsController.h"
#import "LMImageSettingsController.h"
#import "LMTextStyle.h"
#import "LMParagraphConfig.h"
#import "NSTextAttachment+LMText.h"
#import "UIFont+LMText.h"
#import "LMTextHTMLParser.h"
#import "UITextView+Placeholder.h"
#import "YYTextView.h"
#import "VCManger.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CMLVIPNewDetailVC.h"
#import "CMLUpLoadImageObj.h"
#import "CMLRSAModule.h"
#import "UploadImageTool.h"
#import "CMLActivityTicketPriceVC.h"
#import "CMLServePriceVC.h"
#import "CMLActivityTimeVC.h"
#import "CMLGoodsVC.h"
#import "UIImage+CMLExspand.h"
#import "CMLPublishEditorModel.h"
#import "CMLPackageInfoModel.h"
#import "PackageInfoObj.h"

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


@interface LMWordViewOfGoodsController ()<UITextViewDelegate, UITextFieldDelegate, LMSegmentedControlDelegate, LMStyleSettingsControllerDelegate, LMImageSettingsControllerDelegate,NetWorkProtocol,LMWordViewDelegate,ActivityTicketPriceDelegate,ServePriceDelegate,GoodsPriceDelegate,ActivityTimeDelegate>

@property (nonatomic,strong) UIView *topView;

@property (nonatomic, assign) CGFloat keyboardSpacingHeight;
@property (nonatomic, strong) LMSegmentedControl *contentInputAccessoryView;

@property (nonatomic, readonly) UIStoryboard *lm_storyboard;
//@property (nonatomic, strong) LMStyleSettingsController *styleSettingsViewController;
@property (nonatomic, strong) LMImageSettingsController *imageSettingsViewController;

@property (nonatomic, assign) CGFloat inputViewHeight;

@property (nonatomic, strong) LMTextStyle *currentTextStyle;

@property (nonatomic, strong) LMParagraphConfig *currentParagraphConfig;

@property (nonatomic, strong) LMWordView *textView;

@property (nonatomic, copy) NSString *currentApiName;

@property (nonatomic,strong) NSNumber *timelineId;

@property (nonatomic,strong) NSMutableArray *postImageMesArray;

@property (nonatomic,strong) NSMutableArray *keysArray;

@property (nonatomic,strong) NSMutableArray *tokensArray;

@property (nonatomic,strong) NSMutableArray *upToNUImageDataArray;

@property (nonatomic,assign) BOOL isContentImage;

/***/
@property (nonatomic,assign) int surplus_stock;

@property (nonatomic,assign) int projectPrice;

@property (nonatomic,assign) int freight;

@property (nonatomic,copy) NSString *activityStartTime;

@property (nonatomic,copy) NSString *activityEndTime;

@end

@implementation LMWordViewOfGoodsController
{
    NSRange _lastSelectedRange;
    BOOL _keepCurrentTextStyle;
}

- (NSMutableArray *)postImageMesArray{
    
    if (!_postImageMesArray) {
        _postImageMesArray = [NSMutableArray array];
    }
    return _postImageMesArray;
}

- (NSMutableArray *)keysArray{
    
    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    
    return _keysArray;
}

- (NSMutableArray *)tokensArray{
    
    if (!_tokensArray) {
        _tokensArray = [NSMutableArray array];
    }
    
    return _tokensArray;
}

- (NSMutableArray *)upToNUImageDataArray{
    
    if (!_upToNUImageDataArray) {
        _upToNUImageDataArray = [NSMutableArray array];
    }
    
    return _upToNUImageDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            NavigationBarHeight + StatusBarHeight)];
    self.topView.backgroundColor = [UIColor CMLWhiteColor];
    [self.contentView addSubview:self.topView];
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.lineWidth = 1*Proportion;
    bottomLine.lineLength = WIDTH;
    bottomLine.LineColor = [UIColor CMLNewGrayColor];
    bottomLine.startingPoint = CGPointMake(0, NavigationBarHeight + StatusBarHeight - 1*Proportion);
    [self.topView addSubview:bottomLine];
    
    
    [self loadTopBtn];
    
    NSArray *items = @[
                       [UIImage imageNamed:@"ABC_icon"],
                       [UIImage imageNamed:@"img_icon"],
                       [UIImage imageNamed:@"clear_icon"]
                       ];
    _contentInputAccessoryView = [[LMSegmentedControl alloc] initWithItems:items];
    _contentInputAccessoryView.delegate = self;
    _contentInputAccessoryView.changeSegmentManually = YES;
    
    /*textView*/
    _textView = [[LMWordView alloc] init];
    _textView.obj = self.obj;
    _textView.currentTag = [NSNumber numberWithInt:self.currentType];
    _textView.delegate = self;
    _textView.font = KSystemFontSize14;
//    _textView.placeholder = @"请在这里输入内容详情，同时可以插入图片哦";
    _textView.wordViewDelegate = self;
//    _textView.placeholderColor = [UIColor CMLLineGrayColor];
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请在这里输入内容详情，同时可以插入图片哦" attributes:@{NSForegroundColorAttributeName : [UIColor CMLLineGrayColor]}];
    _textView.attributedPlaceholder = placeholderAtt;
    
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView setup];
//    [_textView backEditData];

    
    if (self.obj) {
        _textView.cityTextField.text = self.obj.retData.address;
        _textView.titleTextField.text = self.obj.retData.title;
        _textView.titleTextField.font = KSystemRealBoldFontSize16;
        _textView.topTitle = _textView.titleTextField.text;
        if (self.obj.retData.memberLimitNum) {
            self.surplus_stock = [self.obj.retData.memberLimitNum intValue];
        }
        if (self.obj.retData.totalAmountMin) {
            self.projectPrice = [self.obj.retData.totalAmountMin intValue];
        }
        if (self.obj.retData.freight) {
            self.freight = [self.obj.retData.freight intValue];
        }
        if (self.obj.retData.actBeginTime) {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.activityStartTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actBeginTime intValue]]];
        }
        if (self.obj.retData.actEndTime) {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.activityEndTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actEndTime intValue]]];
        }
        NSDictionary *attDict = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                  NSFontAttributeName : [UIFont systemFontOfSize:15]
                                  };
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[self.obj.retData.content dataUsingEncoding:NSUnicodeStringEncoding] options:attDict documentAttributes:nil error:nil];
        
        [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                NSTextAttachment *textAttachment = value;
                CGFloat width = CGRectGetWidth(textAttachment.bounds);
                CGFloat height = CGRectGetHeight(textAttachment.bounds);
                if (width > WIDTH) {
                    height = (WIDTH - 42 * 2 * Proportion) / width * height;
                    width = WIDTH - 42 * 2 * Proportion;
                    textAttachment.bounds = CGRectMake(0, 0, width, height);
                }
            }
        }];
        
        NSArray *imageArray = [self filterImageUrlFromHTML:self.obj.retData.content];
        
        [self handlerAllAttechmentWith:attributedString withimagesArr:imageArray];
        _textView.attributedText = attributedString;

        if (self.obj.retData.coverPic) {
            NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
            UIImage *image = [UIImage imageWithData:imageNata];
//            [NetWorkTask setImageView:_textView.surfacePlotImage WithURL:self.obj.retData.coverPic placeholderImage:nil];
            _textView.surfacePlotImage.image = image;
            _textView.topImage = image;
            NSLog(@"%@***%@", _textView.surfacePlotImage.image, _textView.topImage);
        }
        /*编辑：票种价格和时间*/
        if (self.obj.retData.actBeginTime) {
            
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
            [_textView refresTime:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actBeginTime intValue]]]];
        }
        
        if (self.obj.retData.totalAmountMin) {
            
            if ([self.obj.retData.totalAmountMin intValue] == 0) {
                [_textView refreshPrice:@"免费"];
            }else{
                [_textView refreshPrice:[NSString stringWithFormat:@"￥%@", self.obj.retData.totalAmountMin]];
            }
            
        }
        
    }
    
    [self.contentView addSubview:_textView];
    
    [self setCurrentParagraphConfig:[[LMParagraphConfig alloc] init]];
    [self setCurrentTextStyle:[LMTextStyle textStyleWithType:LMTextStyleFormatNormal]];
    [self updateParagraphTypingAttributes];
    [self updateTextStyleTypingAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [_contentInputAccessoryView addTarget:self action:@selector(changeTextInputView:) forControlEvents:UIControlEventValueChanged];
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
    [self.topView addSubview:closeLab];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    StatusBarHeight,
                                                                    CGRectGetMaxX(closeLab.frame),
                                                                    NavigationBarHeight)];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    /****************/
    /*发布按钮*/
    UILabel *pushLab = [[UILabel alloc] init];
    pushLab.textColor = [UIColor CMLBlackColor];
    pushLab.text = @"发布";
    pushLab.font = KSystemFontSize14;
    [pushLab sizeToFit];
    pushLab.frame = CGRectMake(WIDTH - 30*Proportion - pushLab.frame.size.width,
                               NavigationBarHeight/2.0 - pushLab.frame.size.height/2.0 + StatusBarHeight,
                               pushLab.frame.size.width,
                               pushLab.frame.size.height);
    [self.topView addSubview:pushLab];
    
    UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - (pushLab.frame.size.width + 30*Proportion),
                                                                   StatusBarHeight,
                                                                   pushLab.frame.size.width + 30*Proportion,
                                                                   NavigationBarHeight)];
    pushBtn.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:pushBtn];
    [pushBtn addTarget:self action:@selector(exportHTML) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTextView];
    
    CGRect rect = self.contentView.bounds;
    rect.size.height = 40.f;
    self.contentInputAccessoryView.frame = rect;
}

- (void)layoutTextView {
    //    CGRect rect = self.contentView.bounds;
    //    rect.origin.y = [self.topLayoutGuide length];
    //    rect.size.height -= rect.origin.y;
    //    self.textView.frame = rect;
    self.textView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.topView.frame),
                                     WIDTH,
                                     HEIGHT - CGRectGetMaxY(self.topView.frame));
    UIEdgeInsets insets = self.textView.contentInset;
    insets.bottom = self.keyboardSpacingHeight;
    self.textView.contentInset = insets;
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.keyboardSpacingHeight == keyboardSize.height) {
        return;
    }
    self.keyboardSpacingHeight = keyboardSize.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardSpacingHeight == 0) {
        return;
    }
    self.keyboardSpacingHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = textField.placeholder;
    }
    self.textView.editable = NO;
    [textField resignFirstResponder];
    self.textView.editable = YES;
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [self.contentInputAccessoryView setSelectedSegmentIndex:0 animated:NO];
    _textView.inputAccessoryView = self.contentInputAccessoryView;
    [self.imageSettingsViewController reload];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    _textView.inputAccessoryView = nil;
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    if (_lastSelectedRange.location != textView.selectedRange.location) {
        
        if (_keepCurrentTextStyle) {
            // 如果当前行的内容为空，TextView 会自动使用上一行的 typingAttributes，所以在删除内容时，保持 typingAttributes 不变
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            _keepCurrentTextStyle = NO;
        }
        else {
            self.currentTextStyle = [self textStyleForSelection];
            self.currentParagraphConfig = [self paragraphForSelection];
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            //            [self reloadSettingsView];
        }
    }
    _lastSelectedRange = textView.selectedRange;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location == 0 && range.length == 0 && text.length == 0) {
        // 光标在第一个位置时，按下退格键，则删除段落设置
        self.currentParagraphConfig.indentLevel = 0;
        [self updateParagraphTypingAttributes];
    }
    _lastSelectedRange = NSMakeRange(range.location + text.length - range.length, 0);
    if (text.length == 0 && range.length > 0) {
        _keepCurrentTextStyle = YES;
    }
    return YES;
}


#pragma mark - Change InputView

- (void)lm_segmentedControl:(LMSegmentedControl *)control didTapAtIndex:(NSInteger)index {
    
    if (index == control.numberOfSegments - 1) {
        [self.textView resignFirstResponder];
        return;
    }
    if (index != control.selectedSegmentIndex) {
        [control setSelectedSegmentIndex:index animated:YES];
    }
}

- (UIStoryboard *)lm_storyboard {
    static dispatch_once_t onceToken;
    static UIStoryboard *storyboard;
    dispatch_once(&onceToken, ^{
        storyboard = [UIStoryboard storyboardWithName:@"LMWord" bundle:nil];
    });
    return storyboard;
}

//- (LMStyleSettingsController *)styleSettingsViewController {
//    if (!_styleSettingsViewController) {
//        _styleSettingsViewController = [self.lm_storyboard instantiateViewControllerWithIdentifier:@"style"];
//        _styleSettingsViewController.textStyle = self.currentTextStyle;
//        _styleSettingsViewController.delegate = self;
//    }
//    return _styleSettingsViewController;
//}

- (LMImageSettingsController *)imageSettingsViewController {
    if (!_imageSettingsViewController) {
        _imageSettingsViewController = [self.lm_storyboard instantiateViewControllerWithIdentifier:@"image"];
        _imageSettingsViewController.delegate = self;
    }
    return _imageSettingsViewController;
}

- (void)changeTextInputView:(LMSegmentedControl *)control {
    
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.keyboardSpacingHeight - CGRectGetHeight(self.contentInputAccessoryView.frame);
    switch (control.selectedSegmentIndex) {

        case 1:
        {
            UIView *inputView = [[UIView alloc] initWithFrame:rect];
            self.imageSettingsViewController.view.frame = rect;
            [inputView addSubview:self.imageSettingsViewController.view];
            self.textView.inputView = inputView;
            break;
        }
        default:
            self.textView.inputView = nil;
            break;
    }
    [self.textView reloadInputViews];
}

#pragma mark - settings

// 刷新设置界面
//- (void)reloadSettingsView {
//
//    self.styleSettingsViewController.textStyle = self.currentTextStyle;
//    [self.styleSettingsViewController setParagraphConfig:self.currentParagraphConfig];
//    [self.styleSettingsViewController reload];
//}

- (LMTextStyle *)textStyleForSelection {
    
    LMTextStyle *textStyle = [[LMTextStyle alloc] init];
    UIFont *font = self.textView.typingAttributes[NSFontAttributeName];
    textStyle.bold = font.bold;
    textStyle.italic = font.italic;
    textStyle.fontSize = font.fontSize;
    textStyle.textColor = self.textView.typingAttributes[NSForegroundColorAttributeName] ?: textStyle.textColor;
    if (self.textView.typingAttributes[NSUnderlineStyleAttributeName]) {
        textStyle.underline = [self.textView.typingAttributes[NSUnderlineStyleAttributeName] integerValue] == NSUnderlineStyleSingle;
    }
    return textStyle;
}

- (LMParagraphConfig *)paragraphForSelection {
    
    NSParagraphStyle *paragraphStyle = self.textView.typingAttributes[NSParagraphStyleAttributeName];
    LMParagraphType type = [self.textView.typingAttributes[LMParagraphTypeName] integerValue];
    LMParagraphConfig *paragraphConfig = [[LMParagraphConfig alloc] initWithParagraphStyle:paragraphStyle type:type];
    return paragraphConfig;
}

// 获取所有选中的段落，通过"\n"来判断段落。
- (NSArray *)rangesOfParagraphForCurrentSelection {
    
    NSRange selection = self.textView.selectedRange;
    NSInteger location;
    NSInteger length;
    
    NSInteger start = 0;
    NSInteger end = selection.location;
    NSRange range = [self.textView.text rangeOfString:@"\n"
                                              options:NSBackwardsSearch
                                                range:NSMakeRange(start, end - start)];
    location = (range.location != NSNotFound) ? range.location + 1 : 0;
    
    start = selection.location + selection.length;
    end = self.textView.text.length;
    range = [self.textView.text rangeOfString:@"\n"
                                      options:0
                                        range:NSMakeRange(start, end - start)];
    length = (range.location != NSNotFound) ? (range.location + 1 - location) : (self.textView.text.length - location);
    
    range = NSMakeRange(location, length);
    NSString *textInRange = [self.textView.text substringWithRange:range];
    NSArray *components = [textInRange componentsSeparatedByString:@"\n"];
    
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        if (i == components.count - 1) {
            if (component.length == 0) {
                break;
            }
            else {
                [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length)]];
            }
        }
        else {
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length + 1)]];
            location += component.length + 1;
        }
    }
    if (ranges.count == 0) {
        return nil;
    }
    return ranges;
}

- (void)updateTextStyleTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = self.currentTextStyle.font;
    typingAttributes[NSForegroundColorAttributeName] = self.currentTextStyle.textColor;
    typingAttributes[NSUnderlineStyleAttributeName] = @(self.currentTextStyle.underline ? NSUnderlineStyleSingle : NSUnderlineStyleNone);
    self.textView.typingAttributes = typingAttributes;
}

- (void)updateParagraphTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[LMParagraphTypeName] = @(self.currentParagraphConfig.type);
    typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
    self.textView.typingAttributes = typingAttributes; 
}

- (void)updateTextStyleForSelection {
    if (self.textView.selectedRange.length > 0) {
        [self.textView.textStorage addAttributes:self.textView.typingAttributes range:self.textView.selectedRange];
    }
}

- (void)updateParagraphForSelectionWithKey:(NSString *)key {
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (!ranges) {
        if (self.currentParagraphConfig.type == 0) {
            NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
            typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
            self.textView.typingAttributes = typingAttributes;
            return;
        }
        ranges = @[[NSValue valueWithRange:NSMakeRange(0, 0)]];
    }
    NSInteger offset = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSValue *rangeValue in ranges) {
        
        NSRange range = NSMakeRange(rangeValue.rangeValue.location + offset, rangeValue.rangeValue.length);
        LMParagraphType type;
        if ([key isEqualToString:LMParagraphTypeName]) {
            
            type = self.currentParagraphConfig.type;
            if (self.currentParagraphConfig.type == LMParagraphTypeNone) {
                [attributedText deleteCharactersInRange:NSMakeRange(range.location, 1)];
                offset -= 1;
            }
            else {
                NSTextAttachment *textAttachment = [NSTextAttachment checkBoxAttachment];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, 1)];
                [attributedText insertAttributedString:attributedString atIndex:range.location];
                offset += 1;
            }
        }
        else {
            [attributedText addAttribute:NSParagraphStyleAttributeName value:self.currentParagraphConfig.paragraphStyle range:range];
        }
    }
    if (offset > 0) {
        _keepCurrentTextStyle = YES;
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length + offset - 1);
    }
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.selectedRange = selectedRange;
}

- (NSTextAttachment *)insertImage:(UIImage *)image {
    // textView 默认会有一些左右边距
    CGFloat width = CGRectGetWidth(self.textView.frame) - (self.textView.textContainerInset.left + self.textView.textContainerInset.right + 12.f);
    NSTextAttachment *textAttachment = [NSTextAttachment attachmentWithImage:image width:width];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attributedString insertAttributedString:attachmentString atIndex:0];
    if (self.textView.text.length > 0) {

        if (_lastSelectedRange.location != 0 &&
            ![[self.textView.text substringWithRange:NSMakeRange(_lastSelectedRange.location - 1, 1)] isEqualToString:@"\n"]){
            // 上一个字符不为"\n"则图片前添加一个换行 且 不是第一个位置
            [attributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
        }
    }
    [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.paragraphSpacingBefore = 8.f;
    paragraphStyle.paragraphSpacing = 8.f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    
    if (attributedText.length == 0) {
        [attributedText replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:attributedString];
    }else {
        [attributedText replaceCharactersInRange:_lastSelectedRange withAttributedString:attributedString];
    }
    
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    
    return textAttachment;
}

#pragma mark - <LMStyleSettingsControllerDelegate>

- (void)lm_didChangedTextStyle:(LMTextStyle *)textStyle {
    
    self.currentTextStyle = textStyle;
    [self updateTextStyleTypingAttributes];
    [self updateTextStyleForSelection];
}

- (void)lm_didChangedParagraphIndentLevel:(NSInteger)level {
    
    self.currentParagraphConfig.indentLevel += level;
    
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (ranges.count <= 1) {
        [self updateParagraphForSelectionWithKey:LMParagraphIndentName];
    }
    else {
        self.textView.allowsEditingTextAttributes = YES;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        for (NSValue *rangeValue in ranges) {
            NSRange range = rangeValue.rangeValue;
            self.textView.selectedRange = range;
            LMParagraphConfig *paragraphConfig = [self paragraphForSelection];
            paragraphConfig.indentLevel += level;
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphConfig.paragraphStyle range:range];
        }
        self.textView.attributedText = attributedText;
        self.textView.allowsEditingTextAttributes = NO;
        self.textView.selectedRange = selectedRange;
    }
    [self updateParagraphTypingAttributes];
}

- (void)lm_didChangedParagraphType:(NSInteger)type {
    //    self.currentParagraphConfig.type = type;
    //
    //    [self updateParagraphTypingAttributes];
    //    [self updateParagraphForSelectionWithKey:LMParagraphTypeName];
}

#pragma mark - <LMImageSettingsControllerDelegate>

- (void)lm_imageSettingsController:(LMImageSettingsController *)viewController presentPreview:(UIViewController *)previewController {
    [self presentViewController:previewController animated:YES completion:nil];
}


- (void)lm_imageSettingsController:(LMImageSettingsController *)viewController insertImage:(UIImage *)image {
    
    // 降低图片质量用于流畅显示，将原始图片存入到 Document 目录下，将图片文件 URL 与 Attachment 绑定。
    NSInteger maxLength = 512000;
    image = [image compressToByte:maxLength];
    
    NSTextAttachment *attachment = [self insertImage:image];
    [self.textView resignFirstResponder];
    [self.textView scrollRangeToVisible:_lastSelectedRange];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 实际应用时候可以将存本地的操作改为上传到服务器，URL 也由本地路径改为服务器图片地址。
        NSURL *documentDir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                    inDomain:NSUserDomainMask
                                                           appropriateForURL:nil
                                                                      create:NO
                                                                       error:nil];
        NSURL *filePath = [documentDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [NSDate date].description]];
        NSData *originImageData = UIImagePNGRepresentation(image);
        
        if ([originImageData writeToFile:filePath.path atomically:YES]) {
            attachment.attachmentType = LMTextAttachmentTypeImage;
            attachment.userInfo = filePath.absoluteString;
        }
    });
}

- (void)lm_imageSettingsController:(LMImageSettingsController *)viewController presentImagePickerView:(UIViewController *)picker {
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentDirImage:(UIImage *)image {
    
    NSTextAttachment *attachment = [self insertImage:image];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 实际应用时候可以将存本地的操作改为上传到服务器，URL 也由本地路径改为服务器图片地址。
        NSURL *documentDir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                    inDomain:NSUserDomainMask
                                                           appropriateForURL:nil
                                                                      create:NO
                                                                       error:nil];
        NSURL *filePath = [documentDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [NSDate date].description]];
        NSData *originImageData = UIImagePNGRepresentation(image);
        [originImageData writeToFile:filePath.path atomically:YES];
        attachment.attachmentType = LMTextAttachmentTypeImage;
        attachment.userInfo = filePath.absoluteString;
        attachment.image = image;
    });
    
}

#pragma mark - export

- (void)exportHTML {
    
    if (self.currentType == 1) {/*活动*/
        
        if (self.textView.cityTextField.text.length > 0) {
            
            if (self.textView.beginTime.text.length > 0) {
                
                if (self.textView.tempPrice.text.length > 0) {
                    
                    if (self.textView.topImage) {
                        
                        if (self.textView.topTitle.length > 0) {
                            
                            if ([LMTextHTMLParser HTMLFromAttributedString:self.textView.attributedText]) {
                                
                                [self setExpressMessageRequest];
                                
                            }else{
                                [self showFailTemporaryMes:@"请输入正文"];
                            }
                        }else{
                            [self showFailTemporaryMes:@"请输入标题"];
                        }
                    }else{
                        [self showFailTemporaryMes:@"请添加封面图"];
                    }
                }else{
                    [self showFailTemporaryMes:@"请输入票种价格"];
                }
            }else{
                [self showFailTemporaryMes:@"请输入活动时间"];
            }
        }else{
            [self showFailTemporaryMes:@"请输入城市"];
        }
    }else if (self.currentType == 2){
        
            if (self.textView.tempPrice.text.length > 0) {
                
                if (self.textView.topImage) {
                    
                    if (self.textView.topTitle.length > 0) {
                        
                        if ([LMTextHTMLParser HTMLFromAttributedString:self.textView.attributedText]) {
                            
                            [self setExpressMessageRequest];
                            
                        }else{
                            [self showFailTemporaryMes:@"请输入正文"];
                        }
                    }else{
                        [self showFailTemporaryMes:@"请输入标题"];
                    }
                }else{
                    [self showFailTemporaryMes:@"请添加封面图"];
                }
            }else{
                [self showFailTemporaryMes:@"请输入价格"];
            }
        
    }else if (self.currentType == 3){
        
        if (self.textView.cityTextField.text.length > 0) {
        
            if (self.textView.tempPrice.text.length > 0) {
                
                if (self.textView.topImage) {
                    
                    if (self.textView.topTitle.length > 0) {
                        
                        if ([LMTextHTMLParser HTMLFromAttributedString:self.textView.attributedText]) {
                            
                            [self setExpressMessageRequest];
                            
                        }else{
                            [self showFailTemporaryMes:@"请输入正文"];
                        }
                    }else{
                        [self showFailTemporaryMes:@"请输入标题"];
                    }
                }else{
                    [self showFailTemporaryMes:@"请添加封面图"];
                }
            }else{
                [self showFailTemporaryMes:@"请输入价格"];
            }
        }else{
            [self showFailTemporaryMes:@"请输入城市"];
        }
    }
}

- (void) closeVC{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) setExpressMessageRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *test =    [LMTextHTMLParser HTMLFromAttributedString:self.textView.attributedText];
    NSMutableString *str = [NSMutableString stringWithString:test];
    
    [paraDic setObject:[str stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""] forKey:@"content"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.textView.topTitle forKey:@"title"];
    
    [paraDic setObject:[NSNumber numberWithInt:self.surplus_stock] forKey:@"surplus_stock"];
    [paraDic setObject:[NSNumber numberWithInt:self.projectPrice] forKey:@"price"];
    
    if (self.objId) {
        NSLog(@"self.objId) == %@", self.objId);
        [paraDic setObject:self.objId forKey:@"objId"];
    }
    
    if (self.currentType == 1) {/*活动发布*/
        
        if (_textView.cityTextField.text.length > 0) {
            [paraDic setObject:_textView.cityTextField.text forKey:@"act_address"];
        }
    
        [paraDic setObject:self.activityStartTime forKey:@"act_begin_time"];
        [paraDic setObject:self.activityEndTime forKey:@"act_end_time"];
        
        if (self.isEdit) {
            [NetWorkTask postResquestWithApiName:ActivPublishUpdate paraDic:paraDic delegate:delegate];
            self.currentApiName = ActivPublishUpdate;
        }else {
            [NetWorkTask postResquestWithApiName:NewExpressMessageOfActivity paraDic:paraDic delegate:delegate];
            self.currentApiName = NewExpressMessageOfActivity;
        }
        
    }else if (self.currentType == 2){/*商品发布*/
        
        if (self.freight != 0) {
            [paraDic setObject:[NSNumber numberWithInt:self.freight] forKey:@"freight"];
        }
        
        if (self.isEdit) {
            [NetWorkTask postResquestWithApiName:GoodsPublishUpdate paraDic:paraDic delegate:delegate];
            self.currentApiName = GoodsPublishUpdate;
        }else {
            [NetWorkTask postResquestWithApiName:NewExpressMessageOfGoods paraDic:paraDic delegate:delegate];
            self.currentApiName = NewExpressMessageOfGoods;
        }
        
    }else if (self.currentType == 3){
        
        if (_textView.cityTextField.text.length > 0) {
            [paraDic setObject:_textView.cityTextField.text forKey:@"address_sign"];
        }
        
        [NetWorkTask postResquestWithApiName:NewExpressMessageOfServe paraDic:paraDic delegate:delegate];
        self.currentApiName = NewExpressMessageOfServe;
    }
    
    [self startIndicatorLoadingWithShadow];
    
}

/*花伴上传图片*/
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
    
    if (self.currentType == 1) {
        
        if (self.isContentImage) {
            
            [paraDic setObject:[NSNumber numberWithInt:1047] forKey:@"cacheType"];
        }else{
            
            [paraDic setObject:[NSNumber numberWithInt:1010] forKey:@"cacheType"];
        }
        
    }else if (self.currentType == 2){
        
        if (self.isContentImage) {
            
            [paraDic setObject:[NSNumber numberWithInt:1046] forKey:@"cacheType"];
        }else{
            
            [paraDic setObject:[NSNumber numberWithInt:1024] forKey:@"cacheType"];
        }
    }else if (self.currentType == 3){
        
        if (self.isContentImage) {
            [paraDic setObject:[NSNumber numberWithInt:1045] forKey:@"cacheType"];
        }else{
            
            [paraDic setObject:[NSNumber numberWithInt:1011] forKey:@"cacheType"];
        }

    }
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,self.timelineId,[rawPicArr md5],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:GetToken paraDic:paraDic delegate:delegate];
    self.currentApiName = GetToken;/*上传图片接口*/
    
}

- (void) delegateTimeLine{
    
//    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
//    delegate.delegate = self;
//
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
//    [paraDic setObject:reqTime forKey:@"reqTime"];
//    [paraDic setObject:self.timelineId forKey:@"timelineId"];
//    NSString *skey = [[DataManager lightData] readSkey];
//    [paraDic setObject:skey forKey:@"skey"];
//
//    NSString *hashToken = [NSString getEncryptStringfrom:@[self.timelineId,skey,reqTime]];
//    [paraDic setObject:hashToken forKey:@"hashToken"];
//    [NetWorkTask postResquestWithApiName:DeleteTimeLine paraDic:paraDic delegate:delegate];
//    self.currentApiName = DeleteTimeLine;
    
}


#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:NewExpressMessage]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.timelineId;
            
            [self initPostImageMessage];
            
            [self setGetImageTokenRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
        }
        
    }else if ([self.currentApiName isEqualToString:NewExpressMessageOfActivity]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.activityId;
            
            [self initPostImageMessage];
            
            [self setGetImageTokenRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
        }

        
    }else if ([self.currentApiName isEqualToString:NewExpressMessageOfGoods]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.goodsId;
            
            [self initPostImageMessage];
            
            [self setGetImageTokenRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
        }

        
    }else if ([self.currentApiName isEqualToString:NewExpressMessageOfServe]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.projectId;
            
            [self initPostImageMessage];
            
            [self setGetImageTokenRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
        }

        
    }else if ([self.currentApiName isEqualToString:GoodsPublishUpdate]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.timelineId = obj.retData.goodsId;
            
            [self initPostImageMessage];
            
            [self setGetImageTokenRequest];
            
        }else if ([obj.retCode intValue] == 100101){
            
            [self showReloadView];
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
        }

    }else if ([self.currentApiName isEqualToString:ActivPublishUpdate]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            self.timelineId = obj.retData.activityId;
            [self initPostImageMessage];
            [self setGetImageTokenRequest];
        }else if ([obj.retCode intValue] == 100101){
            [self showReloadView];
        }else{
            [self showFailTemporaryMes:obj.retMsg];
            [self stopIndicatorLoadingWithShadow];
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
            NSLog(@"upToNUImageDataArray%@", self.upToNUImageDataArray);
            [UploadImageTool uploadImages:self.upToNUImageDataArray keys:self.keysArray Tokens:self.tokensArray progress:^(CGFloat progress) {
            
            } success:^(NSArray * array) {
                if (weskSelf.isContentImage) {
                    [weskSelf stopIndicatorLoading];
                    [weskSelf showSuccessTemporaryMes:@"发表成功,请等待审核"];
                    NSLog(@"isContentImage发表成功");
                    if (self.isUserVC) {
                        [self.delegate refreshVC];
                        [[VCManger mainVC] dismissCurrentVC];
                    }else{
                        CMLVIPNewDetailVC *vc1 = [[CMLVIPNewDetailVC alloc] initWithNickName:[[DataManager lightData] readNickName]
                                                                               currnetUserId:[[DataManager lightData] readUserID] isReturnUpOneLevel:NO];
                        vc1.selectTableViewIndex = 1;
                        [[VCManger mainVC] pushVC:vc1 animate:YES];
                    }
                    
                }else{
                    if ([LMTextHTMLParser ImageArrayFromAttributedString:self.textView.attributedText].count > 0) {
                        weskSelf.isContentImage = YES;
                        [weskSelf initPostImageMessage];
                        [weskSelf setGetImageTokenRequest];
                    }else{
                        [weskSelf stopIndicatorLoading];
                        [weskSelf showSuccessTemporaryMes:@"发表成功,请等待审核!"];
                        if (self.isUserVC) {
                            [self.delegate refreshVC];
                            [[VCManger mainVC] dismissCurrentVC];
                        }else{
                            [[VCManger mainVC] dismissCurrentVC];
                            CMLVIPNewDetailVC *vc1 = [[CMLVIPNewDetailVC alloc] initWithNickName:[[DataManager lightData] readNickName]
                                                                                   currnetUserId:[[DataManager lightData] readUserID]
                                                                              isReturnUpOneLevel:NO];
                            vc1.selectTableViewIndex = 1;
                            [[VCManger mainVC] pushVC:vc1 animate:YES];
                        }
                    }
                }
            } failure:^{
                NSLog(@"失败");
                [self stopIndicatorLoadingWithShadow];
//                [weskSelf delegateTimeLine];会员大事记？
            }];
            
        }else if ([obj.retCode intValue] == 100101){
            [self stopIndicatorLoadingWithShadow];
            [self showReloadView];
        }else{
            [self stopIndicatorLoadingWithShadow];
            [self showFailTemporaryMes:obj.retMsg];
//            [self delegateTimeLine];
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
        [self stopIndicatorLoadingWithShadow];
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopIndicatorLoadingWithShadow];
    [self stopIndicatorLoading];
    [self showFailTemporaryMes:@"网络连接失败"];
    if ([self.currentApiName isEqualToString:GetToken]) {
        
//        [self delegateTimeLine];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    return YES;
}

- (void) initPostImageMessage{
    
    NSArray *imageArray;
    
    if (self.isContentImage) {
        
        [self.postImageMesArray removeAllObjects];
        
        [self.keysArray removeAllObjects];
        
        [self.tokensArray removeAllObjects];
        
        [self.upToNUImageDataArray removeAllObjects];
        
        imageArray = [LMTextHTMLParser ImageArrayFromAttributedString:self.textView.attributedText];
        
    }else{
        
        imageArray = @[self.textView.topImage];
    }

    for ( int i = 0; i < imageArray.count; i++) {
        
        UIImage *image = imageArray[i];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(image, 0.1);
        }else{
            data = UIImagePNGRepresentation(image);
        }
        
        /**压缩并获取大小*/
        
        NSPUIImageType imageType = NSPUIImageTypeFromData(data);
        
        NSInteger maxLength = 512000;
        
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
        if (imageType == NSPUIImageType_JPEG) {
            
            image = [image compressToByte:maxLength];
            
            NSData *uploaderData = UIImageJPEGRepresentation(image, 0.9);
            
            [imageDic setObject:@"jpg" forKey:@"imgType"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.width] forKey:@"imgWidth"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.height] forKey:@"imgHeight"];
            [imageDic setObject:[NSNumber numberWithInt:(int)uploaderData.length] forKey:@"fileSize"];
            
            
            [self.upToNUImageDataArray addObject:uploaderData];
        }else{
            
            NSData *uploaderData = UIImagePNGRepresentation(image);
            
            image = [image compressToByte:maxLength];
            
            uploaderData = UIImageJPEGRepresentation(image, 0.9);
            
            [imageDic setObject:@"png" forKey:@"imgType"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.width] forKey:@"imgWidth"];
            [imageDic setObject:[NSNumber numberWithFloat:image.size.height] forKey:@"imgHeight"];
            [imageDic setObject:[NSNumber numberWithInt:(int)uploaderData.length] forKey:@"fileSize"];
            
            [self.upToNUImageDataArray addObject:uploaderData];
            
        }
        
        [self.postImageMesArray addObject:imageDic];
        
    }
    
}

- (void) touchActivityTicketPriceBtn{
    
    if (self.currentType == 1) {
        
        CMLActivityTicketPriceVC *vc = [[CMLActivityTicketPriceVC alloc] init];
        if (self.obj.retData.totalAmountMin && self.obj.retData.memberLimitNum) {
            vc.costPrice = self.obj.retData.totalAmountMin;
            vc.costNumber = self.obj.retData.memberLimitNum;
        }
        vc.activityTicketPriceDelegate = self;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (self.currentType == 2){
      
        CMLGoodsVC *vc = [[CMLGoodsVC alloc] init];
        if (self.projectPrice && self.surplus_stock) {
            vc.costPrice = [NSNumber numberWithInt:self.projectPrice];
            vc.costNumber = [NSNumber numberWithInt:self.surplus_stock];
            vc.costFreight = [NSNumber numberWithInt:self.freight];
        }
        
        vc.goodsPriceDelegate = self;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (self.currentType == 3){
        
        CMLServePriceVC *vc = [[CMLServePriceVC alloc] init];
        vc.servePriceDelegate = self;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    

}

- (void) touchActivityTimeBtn{
    
    CMLActivityTimeVC *vc = [[CMLActivityTimeVC alloc] init];
    
    vc.startTime = self.activityStartTime;
    vc.endTime = self.activityEndTime;
    
    vc.activityTimeDelegate = self;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) outputTicketType:(NSString *) str number:(int) num price:(int) price{
    
    self.surplus_stock = num;
    if ([str isEqualToString:@"免费"]) {
        
        [_textView refreshPrice:@"免费"];
        self.projectPrice = 0;
    }else{
        
        [_textView refreshPrice:[NSString stringWithFormat:@"¥%d",price]];
        self.projectPrice = price;
    }
    
}

- (void) outputTicketPrice:(int) price andNum:(int) num{
    
    self.surplus_stock = num;
    self.projectPrice = price;
     [_textView refreshPrice:[NSString stringWithFormat:@"¥%d",price]];
}

- (void) outputgoodsPrice:(int) price andNum:(int) num andFreight:(int)price1{
    
    self.projectPrice = price;
    self.surplus_stock = num;
    self.freight = price1;
     [_textView refreshPrice:[NSString stringWithFormat:@"¥%d",price]];
}

- (void) outputActivityTime:(NSString *) start andEndTime:(NSString *) end{
    
    self.activityStartTime = start;
    self.activityEndTime = end;
    [_textView refresTime:start];
}



/*提取html中的imagURL*/
- (NSArray *)filterImageUrlFromHTML:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}

/**获取到的图片URL数组  替换一个个图片地址的null值*/
- (void)handlerAllAttechmentWith:(NSAttributedString *)attributedString withimagesArr:(NSArray*)imageUrl {
    
    NSMutableArray *attachmentArr=[NSMutableArray array];
    
    NSRange effectiveRange = NSMakeRange(0, 0);
    
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        
        if (attachment) {
            
            [attachmentArr addObject:attachment];
            
        }
        
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
        
    }
    
    if (attachmentArr.count == imageUrl.count) {
        
        for (int i = 0; i < attachmentArr.count; i++) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl[i]]];
            
            NSTextAttachment *att = attachmentArr[i];
            
            att.image = [UIImage imageWithData:data];
            
            att.userInfo = imageUrl[i];
            
        }
        
    }
    
}



@end
