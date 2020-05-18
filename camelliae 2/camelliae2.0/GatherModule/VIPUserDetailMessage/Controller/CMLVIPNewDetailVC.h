//
//  CMLV3PersonalHomepageVC.h
//  camelliae2.0
//
//  Created by 张越 on 2017/9/21.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

@protocol CMLVIPNewDetailDlegate <NSObject>

@optional

- (void) refreshCurrentViewController;

@end

@interface CMLVIPNewDetailVC : CMLBaseVC

/****/

- (instancetype)initWithNickName:(NSString *) nickName
                   currnetUserId:(NSNumber *) userId
              isReturnUpOneLevel:(BOOL) isReturnUpOneLevel;

@property (nonatomic,assign) int selectTableViewIndex;

@property (nonatomic,weak) id<CMLVIPNewDetailDlegate> delegate;

@end
