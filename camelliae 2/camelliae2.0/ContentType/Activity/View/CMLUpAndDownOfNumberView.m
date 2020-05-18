//
//  CMLUpAndDownOfNumberView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/5/9.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLUpAndDownOfNumberView.h"
#import "PackDetailInfoObj.h"
#import "PackageInfoObj.h"

@interface CMLUpAndDownOfNumberView ()

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) UIImageView *subtractImageView;

@property (nonatomic, strong) UIImageView *numberImageView;

@property (nonatomic, strong) UIImageView *addImageView;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, assign) int number;

@property (nonatomic, strong) NSNumber *type;

@end

@implementation CMLUpAndDownOfNumberView

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj withType:(NSNumber *)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.obj = obj;
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        self.number = 1;
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    /*减*/
    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    subtractButton.backgroundColor = [UIColor clearColor];
    subtractButton.frame = self.subtractImageView.bounds;
    [subtractButton setTitle:@"－" forState:UIControlStateNormal];
    subtractButton.titleLabel.font = KSystemFontSize12;
    [subtractButton setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [subtractButton addTarget:self action:@selector(subtractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.subtractImageView addSubview:subtractButton];
    [self addSubview:self.subtractImageView];
    
    /*数量*/
    [self addSubview:self.numberImageView];
    [self.numberImageView addSubview:self.numLabel];
    
    /*加*/
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = self.subtractImageView.bounds;
    [addButton setTitle:@"＋" forState:UIControlStateNormal];
    addButton.titleLabel.font = KSystemFontSize13;
    [addButton setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageView addSubview:addButton];
    [self addSubview:self.addImageView];

}

/*减*/
- (void)subtractButtonClicked {
    
    self.number--;
    if (self.number < 1) {
        self.number = 1;
    }
    [self.delegate confirmNumber:self.number];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
    
}
//PackDetailInfoObj *detailObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[[self.obj.retData.packageInfo.dataCount intValue] - 1 - i]];
/*加*/
- (void)addButtonClicked {
    PackDetailInfoObj *packDetailInfoObj = [PackDetailInfoObj getBaseObjFrom:self.obj.retData.packageInfo.dataList[[self.type intValue]]];
    self.number++;
    if (self.number > [packDetailInfoObj.surplusStock intValue]) {
        self.number = [packDetailInfoObj.surplusStock intValue];
    }
    [self.delegate confirmNumber:self.number];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
    
}

#pragma mark 懒加载
- (UIImageView *)subtractImageView {
    
    if (!_subtractImageView) {
        _subtractImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1.5,
                                                                           1.5,
                                                                           CGRectGetHeight(self.frame) - 3,
                                                                           CGRectGetHeight(self.frame) - 3)];
        _subtractImageView.userInteractionEnabled = YES;
        _subtractImageView.backgroundColor = [UIColor clearColor];
        _subtractImageView.layer.borderColor = [UIColor CMLGray1Color].CGColor;
        _subtractImageView.layer.borderWidth = 1.2 * Proportion;
        _subtractImageView.layer.cornerRadius = 2 * Proportion;
        _subtractImageView.clipsToBounds = YES;
        
    }
    return _subtractImageView;
}

- (UIImageView *)numberImageView {
    
    if (!_numberImageView) {
        _numberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - (CGRectGetHeight(self.frame) - 3)/2, 1.5, CGRectGetHeight(self.frame) - 3, CGRectGetHeight(self.frame) - 3)];
        _numberImageView.backgroundColor = [UIColor clearColor];
        _numberImageView.layer.borderColor = [UIColor CMLGray1Color].CGColor;
        _numberImageView.layer.borderWidth = 1.2 * Proportion;
        _numberImageView.layer.cornerRadius = 2 * Proportion;
        _numberImageView.clipsToBounds = YES;
    }
    return _numberImageView;
}

- (UIImageView *)addImageView {
    
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - (CGRectGetHeight(self.frame) - 3) - 1.5, 1.5, CGRectGetHeight(self.frame) - 3, CGRectGetHeight(self.frame) - 3)];
        _addImageView.userInteractionEnabled = YES;
        _addImageView.backgroundColor = [UIColor clearColor];
        _addImageView.layer.borderColor = [UIColor CMLGray1Color].CGColor;
        _addImageView.layer.borderWidth = 1.2 * Proportion;
        _addImageView.layer.cornerRadius = 2 * Proportion;
        _addImageView.clipsToBounds = YES;
    }
    return _addImageView;
    
}

- (UILabel *)numLabel {
    
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.numberImageView.frame), CGRectGetWidth(self.numberImageView.frame))];
        _numLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor CMLBlackColor];
        [_numLabel setFont:KSystemFontSize13];
    }
    return _numLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
