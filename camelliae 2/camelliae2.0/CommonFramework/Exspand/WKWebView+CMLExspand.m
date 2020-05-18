//
//  WKWebView+CMLExspand.m
//  camelliae2.0
//
//  Created by 张越 on 16/9/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "WKWebView+CMLExspand.h"
#import <objc/runtime.h>
#import "CMLVIPNewsImageShowVC.h"
#import "VCManger.h"

static char imgUrlArrayKey;


@implementation WKWebView (CMLExspand)

- (void)setMethod:(NSArray *)imgUrlArray{

    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}


-(void)getImageUrlByJS:(WKWebView *)wkWebView
{
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    static NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt!=''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt!=''){\
    imgUrlStr +='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt!=''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    //用js获取全部图片

    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {

    }];
    NSString *js2=@"getImages()";
    __block NSArray *array;
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {

        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }

        NSMutableString *newResurlt = [NSMutableString stringWithFormat:@"%@",resurlt];
        NSString *str = [newResurlt stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"];
        array=[str componentsSeparatedByString:@"#"];
        [wkWebView setMethod:array];
        
    }];
    

}

-(BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"%@", requestString);
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        NSLog(@"image url------%@", imageUrl);
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        
        
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {

            if([imageUrl isEqualToString:imgUrlArr[i]]){
                index=i;
                break;
            }
        }
        
        CMLVIPNewsImageShowVC *vc = [[CMLVIPNewsImageShowVC alloc] initWithTag:(int) index andImagesArray:imgUrlArr];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        return NO;
    }
    return YES;
}

@end
