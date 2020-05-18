//
//  CMLServeSelectView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/22.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLServeSelectView.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetWorkTask.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "NSString+CMLExspand.h"
#import "DataManager.h"
#import "NetWorkDelegate.h"
#import "NetConfig.h"
#import "AppGroup.h"
#import "ActivityTypeObj.h"
#import "CMLSecondTypeObj.h"

@interface CMLServeSelectView ()<NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *firstTypeDataArray;

@property (nonatomic,strong) NSMutableDictionary *dataSourceDic;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableDictionary *secondSelecIndexDic;

@property (nonatomic,strong) NSMutableArray *firstTypeBtnArray;

@property (nonatomic,strong) NSMutableArray *secondTypeBgScrollViewArray;

//@property (nonatomic,strong) UIView *bottomLine;

@end

@implementation CMLServeSelectView

- (NSMutableDictionary *)secondSelecIndexDic{
    
    if (!_secondSelecIndexDic) {
        _secondSelecIndexDic = [NSMutableDictionary dictionary];
    }
    return _secondSelecIndexDic;
}

- (NSMutableArray *)firstTypeDataArray{
    
    if (!_firstTypeDataArray) {
        _firstTypeDataArray = [NSMutableArray array];
    }
    return _firstTypeDataArray;
}

- (NSMutableDictionary *)dataSourceDic{
    
    if (!_dataSourceDic) {
        _dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}

- (NSMutableArray *)firstTypeBtnArray{
    
    if (!_firstTypeBtnArray) {
        _firstTypeBtnArray = [NSMutableArray array];
    }
    return _firstTypeBtnArray;
}

- (NSMutableArray *)secondTypeBgScrollViewArray{
    
    if (!_secondTypeBgScrollViewArray) {
        _secondTypeBgScrollViewArray = [NSMutableArray array];
    }
    return _secondTypeBgScrollViewArray;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                70*Proportion);
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.currentHeight = 70*Proportion;
        
        self.firstSelectIndex = 0;
        
        
        [self loadData];
      
    }
    
    return self;
}

- (void) loadViews{
    
    for (int i = 0; i < self.firstTypeDataArray.count; i++) {
     
        UIScrollView *moduleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                        70*Proportion,
                                                                                        WIDTH,
                                                                                        140*Proportion)];
        moduleScrollView.backgroundColor = [UIColor CMLNewGrayColor];
        moduleScrollView.showsVerticalScrollIndicator = NO;
        moduleScrollView.showsHorizontalScrollIndicator = NO;
        moduleScrollView.userInteractionEnabled = YES;
        moduleScrollView.tag = self.firstTypeDataArray.count - i - 1;
        moduleScrollView.contentSize = CGSizeMake(WIDTH*2, 140*Proportion);
        [self addSubview:moduleScrollView];
        [self.secondTypeBgScrollViewArray addObject:moduleScrollView];
        
        if (i == 0) {
            
            moduleScrollView.frame = CGRectMake(0, 0, 0, 0);
            moduleScrollView.hidden = YES;
        }
        
    }
    

}

- (void) loadData{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
    
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:MailServeType
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MailServeType;
}

- (void) setSecondTypeRequest{

    NSMutableDictionary *tempDic = self.firstTypeDataArray[self.firstSelectIndex];

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];

    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];

    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:[tempDic valueForKey:@"typeId"]
                forKey:@"serveType"];

    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey],[tempDic valueForKey:@"typeId"]]];

    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:MailServeSecondType
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = MailServeSecondType;
}

- (void) loadFirstTypeBtn{
    
    for (int i = 0 ; i < self.firstTypeDataArray.count; i++) {
        
        NSDictionary *tempDic = self.firstTypeDataArray[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/self.firstTypeDataArray.count*i,
                                                                   0,
                                                                   WIDTH/self.firstTypeDataArray.count,
                                                                   70*Proportion)];
        btn.backgroundColor = [UIColor CMLWhiteColor];
        btn.tag = i;
        btn.titleLabel.font = KSystemBoldFontSize13;
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
        [btn setTitle:[tempDic valueForKey:@"name"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(refreshSecondType:) forControlEvents:UIControlEventTouchUpInside];
        [self.firstTypeBtnArray addObject:btn];
        if (i == 0) {
            btn.selected = YES;
            self.firstSelectIndex = 0;
            btn.titleLabel.font = KSystemRealBoldFontSize13;
//            self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                       0,
//                                                                       32*Proportion,
//                                                                       4*Proportion)];
//            self.bottomLine.backgroundColor = [UIColor CMLNewYellowColor];
//            [self addSubview:self.bottomLine];
//            self.bottomLine.center = CGPointMake(btn.center.x,
//                                                 CGRectGetMaxY(btn.frame) - self.bottomLine.frame.size.height);
        }
    }
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MailServeType]){
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            for (int i = 0; i < obj.retData.dataList.count; i++) {

                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                ActivityTypeObj *activityObj = [ActivityTypeObj getBaseObjFrom:obj.retData.dataList[i]];
                [tempDic setObject:activityObj.typeName forKey:@"name"];
                [tempDic setObject:activityObj.typeId forKey:@"typeId"];
                
                [self.firstTypeDataArray addObject:tempDic];
                [self.secondSelecIndexDic setObject:[NSNumber numberWithInt:0] forKey:activityObj.typeName];
            }
            
            /*******/
            NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
            [firstDic setObject:@"推荐" forKey:@"name"];
            [firstDic setObject:[NSNumber numberWithInt:0] forKey:@"typeId"];
            [self.firstTypeDataArray insertObject:firstDic atIndex:0];
            /*********/
            
            [self loadFirstTypeBtn];
            
            [self loadViews];
            
            [self loadSecondTypeBgViews];
            
        }else{
            

        }
    }else if ([self.currentApiName isEqualToString:MailServeSecondType]){
        
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            [self.dataSourceDic setObject:obj.retData.dataList forKey:[NSString stringWithFormat:@"%@",[self.firstTypeDataArray[self.firstSelectIndex] valueForKey:@"name"]]];
            
            [self loadSecondTypeBtns];
            
            [self setSelectID];
            
        }else{
            
        }
    }
}



- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    

}

- (void) refreshSecondType:(UIButton *) btn{

    self.firstSelectIndex = (int)btn.tag;
    if (!btn.selected) {
        
        btn.selected = YES;
        btn.titleLabel.font = KSystemRealBoldFontSize13;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f animations:^{
            
//            weakSelf.bottomLine.center = CGPointMake(btn.center.x,
//                                                     CGRectGetMaxY(btn.frame) - self.bottomLine.frame.size.height);
        }];
        
        for (int i = 0; i < self.firstTypeBtnArray.count; i++) {
            
            UIButton *tempbtn = self.firstTypeBtnArray[i];
            
            if (tempbtn.tag != btn.tag) {
                tempbtn.titleLabel.font = KSystemBoldFontSize13;
                tempbtn.selected = NO;
            }
        }
        
        [self loadSecondTypeBgViews];
    }
}

- (void) loadSecondTypeBgViews{
    
    if (self.firstSelectIndex == 0) {
        
        self.currentHeight = 70*Proportion;
        [self.delegate selectParentTypeID:[NSNumber numberWithInt:0] typeID:[NSNumber numberWithInt:0]];
        
    }else{
     
        self.currentHeight = 210*Proportion;
        UIScrollView *currentScrollView = self.secondTypeBgScrollViewArray[self.firstSelectIndex];
        [self bringSubviewToFront:currentScrollView];
//        [self bringSubviewToFront:self.bottomLine];
        
        NSArray *tempArray = [self.dataSourceDic objectForKey:[NSString stringWithFormat:@"%@",[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]]];
        
        if (tempArray.count == 0) {
            
            [self setSecondTypeRequest];
            
        }else{
            
            [self loadSecondTypeBtns];
            
            [self setSelectID];
        }
        
        
    }
    
}

- (void) loadSecondTypeBtns{

    UIScrollView *currentScrollView = self.secondTypeBgScrollViewArray[self.firstSelectIndex];
    [currentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];


    NSArray *tempArray = [self.dataSourceDic objectForKey:[NSString stringWithFormat:@"%@",[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]]];

    for (int i = 0; i < tempArray.count; i++) {

        CMLSecondTypeObj *tempObj = [CMLSecondTypeObj getBaseObjFrom:tempArray[i]];

        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion + (180*Proportion + 30*Proportion)*i,
                                                                             20*Proportion,
                                                                             180*Proportion,
                                                                             100*Proportion)];
        bgImage.contentMode = UIViewContentModeScaleAspectFill;
        bgImage.clipsToBounds =  YES;
        bgImage.userInteractionEnabled = YES;
        bgImage.backgroundColor = [UIColor CMLSerachLineGrayColor];
        bgImage.layer.cornerRadius = 6*Proportion;
        [currentScrollView addSubview:bgImage];
        [NetWorkTask setImageView:bgImage WithURL:tempObj.coverPic placeholderImage:nil];

        UIButton *btn = [[UIButton alloc] initWithFrame:bgImage.bounds];
        btn.backgroundColor = [UIColor CMLWhiteColor];
        btn.tag = i;
        btn .titleLabel.font = KSystemFontSize13;
        [btn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
        [btn setTitle:tempObj.typeName forState:UIControlStateNormal];
        [bgImage addSubview:btn];
        [btn addTarget:self action:@selector(secondTypeSelect:) forControlEvents:UIControlEventTouchUpInside];

        if (i == [[self.secondSelecIndexDic valueForKey:[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]] intValue]) {

            btn.selected = YES;
            btn.backgroundColor = [UIColor clearColor];
        }else{

            btn.selected = NO;
            btn.backgroundColor = [[UIColor CMLBlackColor] colorWithAlphaComponent:0.3];
        }

        if (i == tempArray.count - 1) {

            currentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(bgImage.frame) + 30*Proportion,
                                                       currentScrollView.frame.size.height);
        }
    }
}

- (void) secondTypeSelect:(UIButton *) btn{
    
    [self.secondSelecIndexDic setObject:[NSNumber numberWithInteger:btn.tag] forKey:[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]];
    
    [self loadSecondTypeBtns];

    [self setSelectID];

}

- (void) setSelectID{
    
    NSMutableDictionary *firstTempDic = self.firstTypeDataArray[self.firstSelectIndex];
    
    NSArray *secondTempArray = [self.dataSourceDic objectForKey:[NSString stringWithFormat:@"%@",[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]]];
    
    int  secondIndex = [[self.secondSelecIndexDic valueForKey:[self.firstTypeDataArray[self.firstSelectIndex] objectForKey:@"name"]] intValue];
    if (secondTempArray.count == 0) {
        
        self.currentHeight = 70*Proportion;
    
        [self.delegate selectParentTypeID:[firstTempDic valueForKey:@"typeId"] typeID:[NSNumber numberWithInt:0]];
        
    }else{
        
        CMLSecondTypeObj *tempObj = [CMLSecondTypeObj getBaseObjFrom:secondTempArray[secondIndex]];
        [self.delegate selectParentTypeID:[firstTempDic valueForKey:@"typeId"] typeID:tempObj.typeId];
    }
}
@end
