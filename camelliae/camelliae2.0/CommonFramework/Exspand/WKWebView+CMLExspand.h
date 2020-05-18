//
//  WKWebView+CMLExspand.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (CMLExspand)

-(void)getImageUrlByJS:(WKWebView *)wkWebView;

-(BOOL)showBigImage:(NSURLRequest *)request;


@end
