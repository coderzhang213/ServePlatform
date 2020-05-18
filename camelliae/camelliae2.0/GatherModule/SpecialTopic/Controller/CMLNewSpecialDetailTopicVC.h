//
//  CMLSpecialTopicVC.h
//  camelliae2.0
//
//  Created by 张越 on 16/7/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@interface CMLNewSpecialDetailTopicVC : CMLBaseVC

- (instancetype)initWithImageUrl:(NSString *) imageUrl
                            name:(NSString *) name
                      shortTitle:(NSString *) shortTitle
                            desc:(NSString *) desc
                        viewLink:(NSString *) viewLink
                       currentId:(NSNumber *) currentID;

- (instancetype)initWithCurrentId:(NSNumber *)currentID;

@end
