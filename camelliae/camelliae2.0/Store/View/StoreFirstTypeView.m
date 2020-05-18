//
//  StoreFirstTypeView.m
//  camelliae2.0
//
//  Created by 张越 on 2018/5/24.
//  Copyright © 2018年 张越. All rights reserved.
//

#import "StoreFirstTypeView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NetConfig.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "ActivityTypeObj.h"


@interface StoreFirstTypeView()<NetWorkProtocol>

@property (nonatomic,strong) UIScrollView *bgScroolView;

@property (nonatomic,copy) NSString *currentApiName;

//@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) NSMutableArray *firstTypeDataArray;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,assign) int currentSelect;

@end

@implementation StoreFirstTypeView

- (NSMutableArray *)firstTypeDataArray{
    
    if (!_firstTypeDataArray) {
        _firstTypeDataArray = [NSMutableArray array];
    }
    return _firstTypeDataArray;
}

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (instancetype) initWithType:(NSNumber *) typeID{
    
    self = [super init];
    
    if (self) {
        
        self.firstSelectIndexID = [NSNumber numberWithInt:0];
        
        self.currentSelect = 0;
        self.frame = CGRectMake(0,
                                0,
                                WIDTH,
                                70*Proportion);
        
        self.bgScroolView = [[UIScrollView alloc] init];
        self.bgScroolView.showsVerticalScrollIndicator = NO;
        self.bgScroolView.showsHorizontalScrollIndicator = NO;
        self.bgScroolView.frame = CGRectMake(0,
                                             0,
                                             WIDTH,
                                             70*Proportion);
        self.bgScroolView.backgroundColor = [UIColor CMLWhiteColor];
        [self addSubview:self.bgScroolView];
        
        
//        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                   0,
//                                                                   32*Proportion,
//                                                                   4*Proportion)];
//        self.bottomLine.backgroundColor = [UIColor CMLNewYellowColor];
//        [self.bgScroolView addSubview:self.bottomLine];
        
        self.bgScroolView.hidden = YES;
        
        self.currentheight = 80*Proportion;
        
        
        if ([typeID intValue] == 7) {
            
            [self loadData];
            
        }else{
            
            [self loadBrandData];
        }

        
    }
    return self;
}

- (void) initViews{
    
    
    CGFloat currentWidth;
    if (WIDTH/self.firstTypeDataArray.count < 150*Proportion) {
        
        currentWidth = 150*Proportion;
    }else{
        
        currentWidth = WIDTH/self.firstTypeDataArray.count;
    }
    
    for (int i = 0; i < self.firstTypeDataArray.count; i++) {
       
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(currentWidth*i,
                                                                   0,
                                                                   currentWidth,
                                                                   70*Proportion)];
        btn.tag = i;
        btn.titleLabel.font = KSystemBoldFontSize13;
        [btn setTitleColor:[UIColor CMLBtnTitleNewGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateSelected];
        [self.bgScroolView addSubview:btn];
        
        [self.btnArray addObject:btn];
        
        if (i == self.currentSelect) {
            btn.selected = YES;
            btn.titleLabel.font = KSystemRealBoldFontSize13;
//            self.bottomLine.center = CGPointMake(btn.center.x,
//                                                 self.bgScroolView.frame.size.height - self.bottomLine.frame.size.height);
        }else{
            
            btn.selected = NO;
            btn.titleLabel.font = KSystemBoldFontSize13;
        }
        
        NSDictionary *tempDic = self.firstTypeDataArray[i];
        
        [btn setTitle:[tempDic objectForKey:@"name"] forState:UIControlStateNormal];
        NSLog(@"***%@",[tempDic objectForKey:@"name"]);
        if (i == self.firstTypeDataArray.count - 1) {
            
            self.bgScroolView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), self.bgScroolView.frame.size.height);
            
        }
        
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.bgScroolView.hidden = NO;
}

- (void) selectType:(UIButton *) btn{
    
    if (!btn.selected) {
       
        btn.selected = YES;
        self.currentSelect = (int)btn.tag;
        btn.titleLabel.font = KSystemRealBoldFontSize13;
        
//        __weak typeof(self) weakSelf = self;
//        [UIView animateWithDuration:0.3f animations:^{
        
//            weakSelf.bottomLine.center = CGPointMake(btn.center.x,
//                                                     self.bgScroolView.frame.size.height - self.bottomLine.frame.size.height/2.0);
//        }];

        
        NSDictionary *tempDic = self.firstTypeDataArray[btn.tag];
        NSLog(@"firstTypeDataArray %@", self.firstTypeDataArray);
        NSLog(@"tempDic %@", tempDic);
        self.firstSelectIndexID = [tempDic valueForKey:@"typeId"];
        [self.delegate refreshContentWith:[tempDic valueForKey:@"name"] andID:[tempDic valueForKey:@"typeId"]];
        
        for (int i = 0; i < self.btnArray.count; i++) {
            
            UIButton *tempBtn = self.btnArray[i];
            
            if (self.currentSelect != i) {
            
                tempBtn.selected = NO;
                tempBtn.titleLabel.font = KSystemBoldFontSize13;
            }else{
                
                
            }
        }
    }
}

//- (void) refreshCurrentViewsWithTag:(int) index{
//
//
//    if (self.currentSelect != index) {
//
//        UIButton *btn = [self.bgScroolView viewWithTag:index];
//        btn.selected = YES;
//        self.currentSelect = (int)btn.tag;
//        self.bottomLine.center = CGPointMake(btn.center.x,
//                                             self.bgScroolView.frame.size.height - self.bottomLine.frame.size.height/2.0);
//    }
//
//}

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
    [NetWorkTask getRequestWithApiName:GoodFristType
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = GoodFristType;
}

- (void) loadBrandData{
    
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
    [NetWorkTask getRequestWithApiName:BnradFristType
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = BnradFristType;
    
}
#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:GoodFristType]){
        
     
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                ActivityTypeObj *activityObj = [ActivityTypeObj getBaseObjFrom:obj.retData.dataList[i]];
                [tempDic setObject:activityObj.typeName forKey:@"name"];
                [tempDic setObject:activityObj.typeId forKey:@"typeId"];
                
                [self.firstTypeDataArray addObject:tempDic];
          
            }
            
            /*******/
            NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
            [firstDic setObject:@"推荐" forKey:@"name"];
            [firstDic setObject:[NSNumber numberWithInt:0] forKey:@"typeId"];
            [self.firstTypeDataArray insertObject:firstDic atIndex:0];
            /*********/
            
            [self initViews];
        
            
        }else{
            
            
        }
    }else if ([self.currentApiName isEqualToString:BnradFristType]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                ActivityTypeObj *activityObj = [ActivityTypeObj getBaseObjFrom:obj.retData.dataList[i]];
                [tempDic setObject:activityObj.typeName forKey:@"name"];
                [tempDic setObject:activityObj.typeId forKey:@"typeId"];
                
                [self.firstTypeDataArray addObject:tempDic];
                
            }
            
            /*******/
            NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
            [firstDic setObject:@"推荐" forKey:@"name"];
            [firstDic setObject:[NSNumber numberWithInt:0] forKey:@"typeId"];
            [self.firstTypeDataArray insertObject:firstDic atIndex:0];
            
            NSMutableDictionary *lastDic = [NSMutableDictionary dictionary];
            [lastDic setObject:@"A-Z" forKey:@"name"];
            [lastDic setObject:[NSNumber numberWithInt:100] forKey:@"typeId"];
            [self.firstTypeDataArray addObject:lastDic];
            /*********/
            
            [self initViews];
            
            
        }else{
            
            
        }
    }
}



- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    
}

@end
