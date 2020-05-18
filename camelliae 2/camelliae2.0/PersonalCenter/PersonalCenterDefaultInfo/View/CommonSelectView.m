//
//  CommonSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/2/28.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CommonSelectView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"

#define CurrentLabelLeftMargin         30
#define CurrentSelectImageLeftMargin   30

@interface CommonSelectView ()

@end

@implementation CommonSelectView

- (void) setContent:(NSString *) title{

    
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.font = KSystemFontSize12;
    currentLabel.textColor = [UIColor CMLtextInputGrayColor];
    currentLabel.text = title;
    currentLabel.userInteractionEnabled = YES;
    currentLabel.backgroundColor = [UIColor clearColor];
    [currentLabel sizeToFit];
    currentLabel.frame = CGRectMake(CurrentLabelLeftMargin*Proportion,
                                    self.frame.size.height/2.0 - currentLabel.frame.size.height/2.0,
                                    currentLabel.frame.size.width,
                                    currentLabel.frame.size.height);

    [self addSubview:currentLabel];
    
    
    /************/
    
    self.selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
    self.selectImage.userInteractionEnabled = YES;
    [self.selectImage sizeToFit];
    self.selectImage.frame = CGRectMake(WIDTH - self.selectImage.frame.size.width - CurrentSelectImageLeftMargin*Proportion,
                                   self.frame.size.height/2.0 - self.selectImage.frame.size.height/2.0,
                                   self.selectImage.frame.size.width,
                                   self.selectImage.frame.size.height);
    [self addSubview:self.selectImage];
}

@end
