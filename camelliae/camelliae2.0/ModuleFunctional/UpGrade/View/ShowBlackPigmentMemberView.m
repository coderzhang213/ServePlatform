//
//  ShowBlackPigmentMemberView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/6.
//  Copyright © 2019 张越. All rights reserved.
//

#import "ShowBlackPigmentMemberView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "CMLLine.h"
#import "ShowBlackPigmentMembersPickView.h"
#import "ShowAgreementView.h"

@interface ShowBlackPigmentMemberView ()

@property (nonatomic, strong) UIImageView *bgImageView;



@end

@implementation ShowBlackPigmentMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor CMLF1F1F1Color];
        self.frame = frame;
        self.layer.cornerRadius = 8 * Proportion;
        self.clipsToBounds = YES;
//        [self loadBlackPigmentMemberView];
    }
    return self;
}

@end
