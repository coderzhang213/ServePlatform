//
//  LikeTimeLineView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/9/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "LikeTimeLineView.h"
#import "BaseResultObj.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UserLikeListObj.h"
#import "UserLikeObj.h"

@interface LikeTimeLineView ()

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation LikeTimeLineView


- (instancetype)initWithObj:(BaseResultObj *) obj{

    self = [super init];
    if (self) {
        
        self.obj = obj;
        
        [self loadViews];
        
        
    }
    
    return self;
}

- (void) loadViews{

    if ([[self.obj.retData.likeUserHeadList valueForKey:@"dataCount"] integerValue] == 0) {
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       0,
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
        topLineView.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:topLineView];
        
        UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DetailMessageLikeImg]];
        [topImage sizeToFit];
        topImage.frame = CGRectMake(WIDTH/2.0 - topImage.frame.size.width/2.0,
                                    30*Proportion,
                                    topImage.frame.size.width,
                                    topImage.frame.size.height);
        [self addSubview:topImage];
        
        if ([self.obj.retData.isUserLike intValue] == 1) {
            
            topImage.image = [UIImage imageNamed:DetailMessageLikedImg];
        }
        
        UILabel *promLab = [[UILabel alloc] init];
        promLab.font =KSystemFontSize12;
        promLab.text = @"赞";
        promLab.textColor = [UIColor CMLUserBlackColor];
        [promLab sizeToFit];
        promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                   CGRectGetMaxY(topImage.frame) + 10*Proportion,
                                   promLab.frame.size.width,
                                   promLab.frame.size.height);
        [self addSubview:promLab];
        
        UILabel *promLabTwo = [[UILabel alloc] init];
        promLabTwo.font =KSystemFontSize12;
        promLabTwo.text = @"快来给她点个赞吧！";
        promLabTwo.textColor = [UIColor CMLUserBlackColor];
        [promLabTwo sizeToFit];
        promLabTwo.frame = CGRectMake(WIDTH/2.0 - promLabTwo.frame.size.width/2.0,
                                   CGRectGetMaxY(promLab.frame) + 30*Proportion,
                                   promLabTwo.frame.size.width,
                                   promLabTwo.frame.size.height);
        [self addSubview:promLabTwo];
        self.currentHeight = 220*Proportion;
        
    }else{
    
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                       0,
                                                                       WIDTH - 30*Proportion*2,
                                                                       1*Proportion)];
        topLineView.backgroundColor = [UIColor CMLNewGrayColor];
        [self addSubview:topLineView];
        
        UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DetailMessageLikeImg]];
        [topImage sizeToFit];
        topImage.frame = CGRectMake(WIDTH/2.0 - topImage.frame.size.width/2.0,
                                    30*Proportion,
                                    topImage.frame.size.width,
                                    topImage.frame.size.height);
        [self addSubview:topImage];
        
        if ([self.obj.retData.isUserLike intValue] == 1) {
            
            topImage.image = [UIImage imageNamed:DetailMessageLikedImg];
        }
        
        UILabel *promLab = [[UILabel alloc] init];
        promLab.font =KSystemFontSize12;
        promLab.text = @"赞";
        promLab.textColor = [UIColor CMLUserBlackColor];
        [promLab sizeToFit];
        promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                   CGRectGetMaxY(topImage.frame) + 10*Proportion,
                                   promLab.frame.size.width,
                                   promLab.frame.size.height);
        [self addSubview:promLab];
        
        [self loadUserViews:promLab];
        
    }
}

- (void) loadUserViews:(UILabel *) promLab{
    
    CGFloat leftMargin = (WIDTH - self.obj.retData.likeUserHeadList.dataList.count*10*Proportion - (self.obj.retData.likeUserHeadList.dataList.count + 1)*60*Proportion)/2.0;
    int dataCount = (int)self.obj.retData.likeUserHeadList.dataList.count + 1;
    

    for (int i = 0; i < dataCount; i++) {
        
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin + (60*Proportion + 10*Proportion)*i,
                                                                               CGRectGetMaxY(promLab.frame) + 30*Proportion,
                                                                               60*Proportion,
                                                                               60*Proportion)];
        userImage.layer.cornerRadius = 60*Proportion/2.0;
        userImage.clipsToBounds = YES;
        [self addSubview:userImage];

        
  
        if (i == dataCount - 1) {
          
            userImage.backgroundColor =[UIColor CMLBlackColor];
            
            UILabel *numLab = [[UILabel alloc] init];
            numLab.textColor = [UIColor CMLWhiteColor];
            numLab.text = [NSString stringWithFormat:@"%@",self.obj.retData.likeUserHeadList.dataCount];
            numLab.font = KSystemFontSize13;
            numLab.backgroundColor = [UIColor clearColor];
            [numLab sizeToFit];
            numLab.frame = CGRectMake(userImage.frame.size.width/2.0 - numLab.frame.size.width/2.0,
                                      userImage.frame.size.height/2.0 - numLab.frame.size.height/2.0,
                                      numLab.frame.size.width,
                                      numLab.frame.size.height);
            [userImage addSubview:numLab];
        
            self.currentHeight = CGRectGetMaxY(userImage.frame) + 50*Proportion;
            
        }else{
        
            NSArray *ary = self.obj.retData.likeUserHeadList.dataList;
            UserLikeObj *obj = [UserLikeObj getBaseObjFrom:ary[i]];
            [NetWorkTask setImageView:userImage WithURL:obj.gravatar placeholderImage:nil];
        }

            
    }
}

@end
