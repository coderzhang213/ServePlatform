//
//  LMTextHTMLParser.h
//  SimpleWord
//
//  Created by Chenly on 16/6/27.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMTextHTMLParser : NSObject

+ (NSString *)HTMLFromAttributedString:(NSAttributedString *)attributedString;

+ (NSArray *) ImageArrayFromAttributedString:(NSAttributedString *)attributedString;

+ (NSString *)HTMLWithContent:(NSString *)content font:(UIFont *)font underline:(BOOL)underline color:(NSString *)color;

@end
