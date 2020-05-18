//
//  UILabel+CMLAdaptive.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/11.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "UILabel+CMLAdaptive.h"

@implementation UILabel (CMLAdaptive)

- (CGSize)sizeAdaptiveWithText:(NSString *)text textFont:(UIFont *)font textMaxSize:(CGSize)size textLineSpacing:(CGFloat)lineSpacing {
    
    self.text = text;
    self.font = font;
    
    //可变的属性文本
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    //设置段落样式 使用NSMutableParagraphStyle类
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;//文本对齐方式
    paragraphStyle.maximumLineHeight = 60;         //最大的行高
    paragraphStyle.lineSpacing = lineSpacing;      //行自定义行高度
    
    //给可变的属性字符串 添加段落格式
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    
    //将带有段落格式的可变的属性字符串给label.attributedText
    self.attributedText = attributedText;
    
    self.lineBreakMode = NSLineBreakByTruncatingTail;//label的换行模式
    self.numberOfLines = 0;// 设置行数，0表示没有限制
    
    CGSize maxSzie = size;//设置label的最大SIZE
    
    [self sizeToFit];
    CGSize labelSize = [self sizeThatFits:maxSzie];//最终自适应得到的label的尺寸。
    
    
    return labelSize;
    
}

@end
