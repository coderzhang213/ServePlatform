//
//  LMWordView.m
//  SimpleWord
//
//  Created by Chenly on 16/5/12.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMWordView.h"
#import <objc/runtime.h>
#import "UITextView+Placeholder.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NSDate+CMLExspand.h"
#import "CommonImg.h"


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


@interface LMWordView ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic,strong) UIImageView *currentUserImage;

@property (nonatomic,strong) UIImage *currentImage;


@end

@implementation LMWordView {
    UIView *_titleView;
//    UIImageView *self.surfacePlotImage;/*封面图*/
    UIButton *_changeBtn;
    UIView *_separatorLine;
    UIView *_separatorLine1;
    UIView *_separatorLine2;
    UIView *_spaceView;
    UIImageView *_bgImage;
    UIImageView *_back1Image;
    UIImageView *_back2Image;
    CGRect _frameCache;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setup];
    }
    return self;
}

- (void)setup {
    
    /*封面图*/
    self.surfacePlotImage = [[UIImageView alloc] init];
    
    if ([self.currentTag intValue] == 2) {
        self.surfacePlotImage.frame = CGRectMake(0,
                                                 0,
                                                 WIDTH,
                                                 WIDTH);
        /*处理图片尺寸-待扩展*/
        UIImage *sizeImage = [UIImage imageNamed:PushProjectTopBgImg];
        CGSize size = CGSizeMake(WIDTH, WIDTH);
        UIGraphicsBeginImageContext(size);
        [sizeImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        sizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.surfacePlotImage.image = sizeImage;
    }else {
        self.surfacePlotImage.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             450*Proportion);
        self.surfacePlotImage.image = [UIImage imageNamed:PushProjectTopBgImg];
    }
    
    self.surfacePlotImage.contentMode = UIViewContentModeScaleToFill;
    self.surfacePlotImage.clipsToBounds = YES;
    self.surfacePlotImage.contentMode = UIViewContentModeScaleAspectFill;
    self.surfacePlotImage.userInteractionEnabled = YES;
    
    [self addSubview:self.surfacePlotImage];
    
    _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:XuXianImg]];
    _bgImage.frame = CGRectInset(self.surfacePlotImage.frame, 20*Proportion, 20*Proportion);
    _bgImage.hidden = YES;
    _bgImage.userInteractionEnabled = YES;
    [self.surfacePlotImage addSubview:_bgImage];

    _changeBtn = [[UIButton alloc] initWithFrame:self.surfacePlotImage.bounds];
    _changeBtn.backgroundColor = [UIColor clearColor];
    if (self.topImage) {
        [_changeBtn setImage:[UIImage imageNamed:AlterProjectTopBtnImg] forState:UIControlStateNormal];
    }else {
        [_changeBtn setImage:[UIImage imageNamed:PushProjectTopBtnImg] forState:UIControlStateNormal];
    }
    
    [self.surfacePlotImage addSubview:_changeBtn];
    [_changeBtn addTarget:self action:@selector(changImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([self.currentTag intValue] == 1) {
        
        /*票种价格*/
        _ticketPriceLab = [[UILabel alloc] init];
        _ticketPriceLab.font = KSystemFontSize16;
        _ticketPriceLab.textAlignment = NSTextAlignmentLeft;
        _ticketPriceLab.text = @"票种价格";
        _ticketPriceLab.backgroundColor = [UIColor whiteColor];
        [_ticketPriceLab sizeToFit];
        
        /*编辑价格 >*/
        _back1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
        
        _ticketPriceBtn = [[UIButton alloc] init];
        _ticketPriceBtn.backgroundColor = [UIColor clearColor];
        [_ticketPriceBtn addTarget:self action:@selector(touchPriceBtn) forControlEvents:UIControlEventTouchUpInside];

        _separatorLine1 = [[UIView alloc] init];
        _separatorLine1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_ticketPriceBtn addSubview:_separatorLine1];

        _activityTimeLab = [[UILabel alloc] init];
        _activityTimeLab.font = KSystemFontSize16;
        _activityTimeLab.textAlignment = NSTextAlignmentLeft;
        _activityTimeLab.text = @"活动时间";
        _activityTimeLab.backgroundColor = [UIColor whiteColor];
        [_activityTimeLab sizeToFit];
        
        /*编辑时间 >*/
        _back2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];

        _activityTimeBtn = [[UIButton alloc] init];
        _activityTimeBtn.backgroundColor = [UIColor clearColor];
        [_activityTimeBtn addTarget:self action:@selector(touchActivityTimePriceBtn) forControlEvents:UIControlEventTouchUpInside];

        _separatorLine2 = [[UIView alloc] init];
        _separatorLine2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_activityTimeBtn addSubview:_separatorLine2];


        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor CMLUserGrayColor];
        

        _cityTextField = [[UITextField alloc] init];
        _cityTextField.textAlignment = NSTextAlignmentLeft;
        _cityTextField.font = KSystemFontSize16;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = KSystemFontSize16; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor CMLDarkOrangeColor]; // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入城市，例如上海/北京/广州" attributes:attrs]; // 初始化富文本占位字符串
        _cityTextField.attributedPlaceholder = attStr;
        _cityTextField.textColor = [UIColor CMLDarkOrangeColor];
        _cityTextField.placeholder = @"请输入城市，例如上海/北京/广州";
        
        _cityTextField.delegate = self;
        
        _titleTextField = [[UITextView alloc] init];
        _titleTextField.font = KSystemFontSize16;
        
//        _titleTextField.placeholder = @"请输入标题";
//        _titleTextField.placeholderColor = [UIColor CMLLineGrayColor];
        NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSForegroundColorAttributeName : [UIColor CMLLineGrayColor]}];
        _titleTextField.attributedPlaceholder = placeholderAtt;
        _titleTextField.delegate = self;
        _titleTextField.scrollEnabled = NO;

        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        [_titleTextField addSubview:_separatorLine];



        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleView];
        [_titleView addSubview:_ticketPriceLab];
        [_titleView addSubview:_back1Image];

        [_titleView addSubview:_ticketPriceBtn];
        [_titleView addSubview:_activityTimeLab];
        [_titleView addSubview:_back2Image];
        [_titleView addSubview:_activityTimeBtn];
        [_titleView addSubview:_spaceView];
        [_titleView addSubview:_cityTextField];
        [_titleView addSubview:_titleTextField];
        
    }else if ([self.currentTag intValue] == 0){

        _titleTextField = [[UITextView alloc] init];
        _titleTextField.font = KSystemFontSize16;
//        _titleTextField.placeholder = @"请输入项目名称";
//        _titleTextField.placeholderColor = [UIColor CMLLineGrayColor];
        NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入项目名称" attributes:@{NSForegroundColorAttributeName : [UIColor CMLLineGrayColor]}];
        _titleTextField.attributedPlaceholder = placeholderAtt;
        
        _titleTextField.delegate = self;
        _titleTextField.scrollEnabled = NO;
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        
        [_titleView addSubview:_titleTextField];
        [_titleView addSubview:_separatorLine];
        [self addSubview:_titleView];

        
    }else if([self.currentTag intValue] == 2){/*发商品*/
        
        _ticketPriceLab = [[UILabel alloc] init];
        _ticketPriceLab.font = KSystemFontSize16;
        _ticketPriceLab.textAlignment = NSTextAlignmentLeft;
        _ticketPriceLab.text = @"价格";
        _ticketPriceLab.backgroundColor = [UIColor whiteColor];
        [_ticketPriceLab sizeToFit];
        
        _back1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
        [_back1Image sizeToFit];
        
        _ticketPriceBtn = [[UIButton alloc] init];
        _ticketPriceBtn.backgroundColor = [UIColor clearColor];
        [_ticketPriceBtn addTarget:self action:@selector(touchPriceBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor CMLUserGrayColor];
        
        

        _titleTextField = [[UITextView alloc] init];
        _titleTextField.font = KSystemFontSize16;
//        _titleTextField.placeholder = @"请输入标题";
//        _titleTextField.placeholderColor = [UIColor CMLLineGrayColor];
        NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSForegroundColorAttributeName : [UIColor CMLLineGrayColor]}];
        _titleTextField.attributedPlaceholder = placeholderAtt;
        _titleTextField.delegate = self;
        _titleTextField.scrollEnabled = NO;
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        
        [_titleView addSubview:_ticketPriceLab];//价格label
        [_titleView addSubview:_back1Image];//跳转价格编辑icon
        [_titleView addSubview:_ticketPriceBtn];//跳转价格button
        [_titleView addSubview:_spaceView];//价格和输入标题中间的灰色条
        [_titleView addSubview:_titleTextField];//请输入标题
        [_titleTextField addSubview:_separatorLine];
        
        [self addSubview:_titleView];
        
    }else if ([self.currentTag intValue] == 3){
        
        _ticketPriceLab = [[UILabel alloc] init];
        _ticketPriceLab.font = KSystemFontSize16;
        _ticketPriceLab.textAlignment = NSTextAlignmentLeft;
        _ticketPriceLab.text = @"价格";
        _ticketPriceLab.backgroundColor = [UIColor whiteColor];
        [_ticketPriceLab sizeToFit];
        
        _back1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLUserViewBackImg]];
        [_back1Image sizeToFit];
        
        _ticketPriceBtn = [[UIButton alloc] init];
        _ticketPriceBtn.backgroundColor = [UIColor clearColor];
        [_ticketPriceBtn addTarget:self action:@selector(touchPriceBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _separatorLine1 = [[UIView alloc] init];
        _separatorLine1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_ticketPriceBtn addSubview:_separatorLine1];
        
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor CMLUserGrayColor];
        
        
        _cityTextField = [[UITextField alloc] init];
        _cityTextField.textAlignment = NSTextAlignmentLeft;
        _cityTextField.font = KSystemFontSize16;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = KSystemFontSize16; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor CMLDarkOrangeColor]; // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入城市，例如上海/北京/广州" attributes:attrs]; // 初始化富文本占位字符串
        _cityTextField.attributedPlaceholder = attStr;
        _cityTextField.textColor = [UIColor CMLDarkOrangeColor];
        
        _cityTextField.delegate = self;
        
        _titleTextField = [[UITextView alloc] init];
        _titleTextField.font = KSystemFontSize16;
        
//        _titleTextField.placeholder = @"请输入标题";
//        _titleTextField.placeholderColor = [UIColor CMLLineGrayColor];
        NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSForegroundColorAttributeName : [UIColor CMLLineGrayColor]}];
        _titleTextField.attributedPlaceholder = placeholderAtt;
        _titleTextField.delegate = self;
        _titleTextField.scrollEnabled = NO;
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        [_titleTextField addSubview:_separatorLine];
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleView];
        [_titleView addSubview:_ticketPriceLab];
        [_titleView addSubview:_back1Image];
        [_titleView addSubview:_ticketPriceBtn];
        [_titleView addSubview:_spaceView];
        [_titleView addSubview:_cityTextField];
        [_titleView addSubview:_titleTextField];
        
    }
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;    
    self.alwaysBounceVertical = YES;
    
    if ([self.currentTag intValue] == 1) {
        
        /*文本容器的边距（文字距文本容器）此处还跟placeholderLabel有关 优化时需要更改固定数据*/
        self.textContainerInset = UIEdgeInsetsMake(110*Proportion*4 + 20*Proportion*2 + 450*Proportion + 30*Proportion + 2,
                                                   30*Proportion,
                                                   30*Proportion,
                                                   30*Proportion);

    }else if ([self.currentTag intValue] == 0){
    
        self.textContainerInset = UIEdgeInsetsMake(100*Proportion + 450*Proportion + 30*Proportion,
                                                   30*Proportion,
                                                   30*Proportion,
                                                   30*Proportion);
        
    }else if([self.currentTag intValue] == 2){
        
        self.textContainerInset = UIEdgeInsetsMake(110*Proportion*2 + 20*Proportion*2 + WIDTH + 30*Proportion + 2,
                                                   30*Proportion,
                                                   30*Proportion,
                                                   30*Proportion);
    }else if ([self.currentTag intValue] == 3){
        
        self.textContainerInset = UIEdgeInsetsMake(110*Proportion*3 + 20*Proportion*2 + 450*Proportion + 30*Proportion + 2,
                                                   30*Proportion,
                                                   30*Proportion,
                                                   30*Proportion);
        
    }
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_frameCache, self.frame)) {
        CGRect rect = CGRectInset(self.bounds, 30*Proportion, 10*Proportion);

        if ([self.currentTag intValue] == 0) {
        
            rect.size.height = 100*Proportion;
            _titleView.frame = CGRectMake(30*Proportion,
                                          450*Proportion,
                                          rect.size.width,
                                          100*Proportion + 2);
            
            _titleTextField.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               _titleView.frame.size.height - 20*Proportion);
            
            _separatorLine.frame = CGRectMake(0,
                                              CGRectGetHeight(_titleView.bounds) - 1,
                                              _titleView.frame.size.width,
                                              1.f);
            
        }else if ([self.currentTag intValue] == 1){

            rect.size.height = 110*Proportion*4 + 20*Proportion*2;

            _titleView.frame = CGRectMake(30*Proportion,
                                          450*Proportion,
                                          rect.size.width,
                                          110*Proportion*4 + 20*Proportion*2 + 2);

            _ticketPriceLab.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            
            [_back1Image sizeToFit];
            _back1Image.frame = CGRectMake(_titleView.frame.size.width - 30*Proportion - _back1Image.frame.size.width,
                                           _ticketPriceLab.center.y - _back1Image.frame.size.height/2.0,
                                           _back1Image.frame.size.width,
                                           _back1Image.frame.size.height);

            
            _ticketPriceBtn.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            
            _separatorLine1.frame = CGRectMake(0,
                                               CGRectGetHeight(_ticketPriceBtn.frame) - 1,
                                               _titleView.frame.size.width,
                                               1.f);
      

            _activityTimeLab.frame = CGRectMake(0,
                                               CGRectGetMaxY(_ticketPriceLab.frame),
                                               _titleView.frame.size.width,
                                               110*Proportion);
            
            [_back2Image sizeToFit];
            _back2Image.frame = CGRectMake(_titleView.frame.size.width - 30*Proportion - _back2Image.frame.size.width,
                                           _activityTimeLab.center.y - _back2Image.frame.size.height/2.0,
                                           _back2Image.frame.size.width,
                                           _back2Image.frame.size.height);
           
            
            _activityTimeBtn.frame = CGRectMake(0,
                                               CGRectGetMaxY(_ticketPriceLab.frame),
                                               _titleView.frame.size.width,
                                               110*Proportion);
            _separatorLine2.frame = CGRectMake(0,
                                               CGRectGetHeight(_activityTimeBtn.frame) - 1,
                                               _titleView.frame.size.width,
                                               1.f);


            _cityTextField.frame = CGRectMake(0,
                                              CGRectGetMaxY(_activityTimeLab.frame),
                                              _titleView.frame.size.width,
                                              110*Proportion);
            
            _spaceView.frame = CGRectMake(-30*Proportion,
                                          CGRectGetMaxY(_cityTextField.frame),
                                          _titleView.frame.size.width + 60*Proportion,
                                          20*Proportion);

            _titleTextField.frame = CGRectMake(0,
                                               CGRectGetMaxY(_spaceView.frame) + 20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            _titleTextField.textAlignment = NSTextAlignmentLeft;

            _separatorLine.frame = CGRectMake(0,
                                              CGRectGetHeight(_cityTextField.frame) - 1,
                                              _titleView.frame.size.width,
                                              1.f);

        }else if ([self.currentTag intValue] == 2){
            
            rect.size.height = 110*Proportion*2 + 20*Proportion*2;
            
            _titleView.frame = CGRectMake(30*Proportion,
                                          self.surfacePlotImage.frame.size.height,
                                          rect.size.width,
                                          110*Proportion*2 + 20*Proportion*2 + 2);
            
            _ticketPriceLab.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            [_back1Image sizeToFit];
            _back1Image.frame = CGRectMake(_titleView.frame.size.width - 30*Proportion - _back1Image.frame.size.width,
                                           _ticketPriceLab.center.y - _back1Image.frame.size.height/2.0,
                                           _back1Image.frame.size.width,
                                           _back1Image.frame.size.height);
            
            _ticketPriceBtn.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            
            
            _spaceView.frame = CGRectMake(-30*Proportion,
                                          CGRectGetMaxY(_ticketPriceLab.frame),
                                          _titleView.frame.size.width + 60*Proportion,
                                          20*Proportion);
            
            _titleTextField.frame = CGRectMake(0,
                                               CGRectGetMaxY(_spaceView.frame) + 20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            _titleTextField.textAlignment = NSTextAlignmentLeft;
            
            _separatorLine.frame = CGRectMake(0,
                                              CGRectGetHeight(_titleTextField.frame) - 1,
                                              _titleView.frame.size.width,
                                              1.f);
            
        }else if ([self.currentTag intValue] == 3){
            
            rect.size.height = 110*Proportion*3 + 20*Proportion*2;
            
            _titleView.frame = CGRectMake(30*Proportion,
                                          450*Proportion,
                                          rect.size.width,
                                          110*Proportion*3 + 20*Proportion*2 + 2);
            
            _ticketPriceLab.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            [_back1Image sizeToFit];
            _back1Image.frame = CGRectMake(_titleView.frame.size.width - 30*Proportion - _back1Image.frame.size.width,
                                           _ticketPriceLab.center.y - _back1Image.frame.size.height/2.0,
                                           _back1Image.frame.size.width,
                                           _back1Image.frame.size.height);
            
            
            _ticketPriceBtn.frame = CGRectMake(0,
                                               20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            
            _separatorLine1.frame = CGRectMake(0,
                                               CGRectGetHeight(_ticketPriceBtn.frame) - 1,
                                               _titleView.frame.size.width,
                                               1.f);
            
            
            _cityTextField.frame = CGRectMake(0,
                                              CGRectGetMaxY(_ticketPriceLab.frame),
                                              _titleView.frame.size.width,
                                              110*Proportion);
            
            _spaceView.frame = CGRectMake(-30*Proportion,
                                          CGRectGetMaxY(_cityTextField.frame),
                                          _titleView.frame.size.width + 60*Proportion,
                                          20*Proportion);
            
            _titleTextField.frame = CGRectMake(0,
                                               CGRectGetMaxY(_spaceView.frame) + 20*Proportion,
                                               _titleView.frame.size.width,
                                               110*Proportion);
            _titleTextField.textAlignment = NSTextAlignmentLeft;
            
            _separatorLine.frame = CGRectMake(0,
                                              CGRectGetHeight(_cityTextField.frame) - 1,
                                              _titleView.frame.size.width,
                                              1.f);
            
        }
        
        _frameCache = self.frame;
    }
    
    /*编辑：票种价格和时间*/
    if (self.obj.retData.actBeginTime) {
    
        [self.beginTime sizeToFit];
        self.beginTime.frame = CGRectMake(_titleView.frame.size.width - 40*Proportion - self.beginTime.frame.size.width - _back2Image.frame.size.width,
                                          _activityTimeLab.frame.origin.y,
                                          self.beginTime.frame.size.width,
                                          110*Proportion);
        [_titleView addSubview:self.beginTime];
    }

    
    if (self.obj.retData.totalAmountMin) {
        
        [self.tempPrice sizeToFit];
        self.tempPrice.frame = CGRectMake(_titleView.frame.size.width - 40*Proportion - self.tempPrice.frame.size.width - _back1Image.frame.size.width,
                                          _ticketPriceLab.frame.origin.y,
                                          self.tempPrice.frame.size.width,
                                          110*Proportion);
        [_titleView addSubview:self.tempPrice];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    if (self.titleTextField) {
        if (self.titleTextField.text.length > 0) {
            
            self.titleTextField.font = KSystemRealBoldFontSize16;
        }else{
            
            self.titleTextField.font = KSystemFontSize16;
        }
        CGRect frame = self.titleTextField.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.titleTextField sizeThatFits:constraintSize];
        
        
        self.titleTextField.frame = CGRectMake(frame.origin.x,
                                               frame.origin.y,
                                               frame.size.width,
                                               size.height);
        CGRect rect = self.titleTextField.frame;
        
        
        [self refreshTitleViewRect:rect];
        
        self.topTitle = self.titleTextField.text;
    }
    
}

- (void) refreshTitleViewRect:(CGRect) rect{
    
    if ([self.currentTag intValue]== 1) {
        
        _titleView.frame = CGRectMake(_titleView.frame.origin.x,
                                      _titleView.frame.origin.y,
                                      _titleView.frame.size.width,
                                      CGRectGetMaxY(rect));
        
        _separatorLine.frame = CGRectMake(0,
                                          CGRectGetHeight(_titleTextField.frame) - 1,
                                          _titleView.frame.size.width,
                                          1.f);
        
    }else if([self.currentTag integerValue] == 0){
        
        _titleView.frame = CGRectMake(_titleView.frame.origin.x,
                                      _titleView.frame.origin.y,
                                      _titleView.frame.size.width,
                                      CGRectGetMaxY(rect) + 20*Proportion);
        
        _separatorLine.frame = CGRectMake(_separatorLine.frame.origin.x,
                                          _titleView.bounds.size.height - 1,
                                          _separatorLine.frame.size.width,
                                          1);
    }else if([self.currentTag intValue] == 2){
        
        _titleView.frame = CGRectMake(_titleView.frame.origin.x,
                                      _titleView.frame.origin.y,
                                      _titleView.frame.size.width,
                                      CGRectGetMaxY(rect));
        
        _separatorLine.frame = CGRectMake(0,
                                          CGRectGetHeight(_titleTextField.frame) - 1,
                                          _titleView.frame.size.width,
                                          1.f);
        
    }else if([self.currentTag intValue] == 3){
        
        _titleView.frame = CGRectMake(_titleView.frame.origin.x,
                                      _titleView.frame.origin.y,
                                      _titleView.frame.size.width,
                                      CGRectGetMaxY(rect));
        
        _separatorLine.frame = CGRectMake(0,
                                          CGRectGetHeight(_titleTextField.frame) - 1,
                                          _titleView.frame.size.width,
                                          1.f);
        
    }


    
    self.textContainerInset = UIEdgeInsetsMake(CGRectGetMaxY(_titleView.frame) + 30*Proportion,
                                               30*Proportion,
                                               30*Proportion,
                                               30*Proportion);
}

#pragma mark - 修改头图
- (void) changImage{
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        //        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self viewController] presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [[self viewController]presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [[self viewController] presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    CGFloat compression = 1;
    NSInteger maxLength = 512000;
    CGFloat max = 1;
    CGFloat min = 0;
//当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(image, compression);
        if (imageData.length > maxLength) {
            
            for (NSInteger i = 0; i < 6; i++) {
                compression = (max + min) / 2;
                imageData = UIImageJPEGRepresentation(image, compression);
                if (imageData.length < maxLength * 0.9) {
                    min = compression;
                }else if (imageData.length > maxLength) {
                    max = compression;
                }
            }
        }
        UIImage *degradedImage = [UIImage imageWithData:imageData];
    
        self.surfacePlotImage.image = degradedImage;
        
        self.topImage = degradedImage;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [_changeBtn setImage:[UIImage imageNamed:AlterProjectTopBtnImg] forState:UIControlStateNormal];
            
            _bgImage.hidden = NO;
        }];
    
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

- (void) touchPriceBtn{
    
    [self.wordViewDelegate touchActivityTicketPriceBtn];
}

- (void) touchActivityTimePriceBtn{
    
    [self.wordViewDelegate touchActivityTimeBtn];
}

- (void) refreshPrice:(NSString *) str{

    self.tempPrice.text = str;
    [self.tempPrice sizeToFit];
    self.tempPrice.frame = CGRectMake(_titleView.frame.size.width - 40*Proportion - self.tempPrice.frame.size.width - _back1Image.frame.size.width,
                                      _ticketPriceLab.frame.origin.y,
                                      self.tempPrice.frame.size.width,
                                      110*Proportion);
    [_titleView addSubview:self.tempPrice];
    

}

- (void) refresTime:(NSString *) startTimeStr{

    self.beginTime.text = startTimeStr;
    [self.beginTime sizeToFit];
    self.beginTime.frame = CGRectMake(_titleView.frame.size.width - 40*Proportion - self.beginTime.frame.size.width - _back2Image.frame.size.width,
                                      _activityTimeLab.frame.origin.y,
                                      self.beginTime.frame.size.width,
                                      110*Proportion);
    [_titleView addSubview:self.beginTime];

}

- (UILabel *)tempPrice {
    
    if (!_tempPrice) {
        _tempPrice = [[UILabel alloc] init];
        _tempPrice.backgroundColor = [UIColor clearColor];
        _tempPrice.font = KSystemFontSize14;
        _tempPrice.textColor = [UIColor CMLBrownColor];
        _tempPrice.userInteractionEnabled = YES;
    }
    return _tempPrice;
}

- (UILabel *)beginTime {
    
    if (!_beginTime) {
        _beginTime = [[UILabel alloc] init];
        _beginTime.backgroundColor = [UIColor clearColor];
        _beginTime.font = KSystemFontSize14;
        _beginTime.textColor = [UIColor CMLBrownColor];
        _beginTime.userInteractionEnabled = YES;
    }
    return _beginTime;
}

@end
