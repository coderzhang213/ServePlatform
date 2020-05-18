//
//  CMLWriteVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/9/7.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
@protocol WriteDelegate <NSObject>

- (void) refreshVIPDetailVC;

@end


@interface CMLWriteVC : CMLBaseVC

- (instancetype)initWithPublishDate:(NSNumber *) publishDate tempTimeLine:(NSString *) tempTimeLine;

- (instancetype)initWithTopic:(NSString *) topic TopicID:(NSNumber *) currentID;

@property (nonatomic,assign) BOOL isDismissPop;

@property (nonatomic,weak) id<WriteDelegate> delegate;

- (void) refreshViews;
@end
