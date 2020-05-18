//
//  CMLBrandTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/11/27.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLBrandTableView.h"
#import "UIColor+SDExspand.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "BrandModuleObj.h"
#import "AllBrandInfoObj.h"
#import "CommonFont.h"
#import "CMLBrandModuleTVCell.h"
#import "CMLBrandVC.h"
#import "VCManger.h"

@interface CMLBrandTableView() <UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) NSMutableArray *sectionIndexsArray;

@property (nonatomic,strong) NSMutableDictionary *brandDataDic;

@property (nonatomic,copy) NSString *currentApiName;

@end


@implementation CMLBrandTableView

-(NSMutableDictionary *)brandDataDic{
    
    if (!_brandDataDic) {
        _brandDataDic = [NSMutableDictionary dictionary];
    }
    
    return _brandDataDic;
}

- (NSMutableArray *)sectionIndexsArray{
    
    if (!_sectionIndexsArray) {
        _sectionIndexsArray = [NSMutableArray array];
    }
    
    return _sectionIndexsArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.sectionIndexColor = [UIColor clearColor];
        self.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        self.sectionIndexBackgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = 150*Proportion;
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        self.tableFooterView = [[UIView alloc] init];
        
        [self loadData];
    }
    
    return self;
}

- (void) loadData{
    
    [self setBrandModuleRequest];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.brandDataDic valueForKey:self.sectionIndexsArray[section]]) {
        
        NSArray *tempArray = [self.brandDataDic objectForKey:self.sectionIndexsArray[section]];
        return tempArray.count;
        
    }else{
        
       return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"myCell";
    
    CMLBrandModuleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[CMLBrandModuleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if ([self.brandDataDic valueForKey:self.sectionIndexsArray[indexPath.section]]) {
        
        NSArray *tempArray = [self.brandDataDic objectForKey:self.sectionIndexsArray[indexPath.section]];
        
        BrandModuleObj *obj = [BrandModuleObj getBaseObjFrom:tempArray[indexPath.row]];
        [cell refreshCurrentCellWith:obj];
    
        if (indexPath.row == tempArray.count - 1) {
            [cell hiddenLine];
        }else{
            [cell showLine];
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *tempArray = [self.brandDataDic objectForKey:self.sectionIndexsArray[indexPath.section]];
    
    BrandModuleObj *obj = [BrandModuleObj getBaseObjFrom:tempArray[indexPath.row]];

    CMLBrandVC *vc = [[CMLBrandVC alloc] initWithImageUrl:obj.coverPic
                                             andDetailMes:obj.desc
                                             LogoImageUrl:obj.logoPic
                                                  brandID:obj.currentID];
    vc.goodsNum = obj.goodsCount;
    vc.serveNum = obj.projectCount;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.sectionIndexsArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*Proportion;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40*Proportion)];
    view.backgroundColor = [UIColor CMLWhiteColor];
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.font = KSystemRealBoldFontSize15;
    tempLabel.text = [NSString stringWithFormat:@"  %@",self.sectionIndexsArray[section]];
    tempLabel.textColor = [UIColor CMLBrownColor];
    tempLabel.textAlignment = NSTextAlignmentLeft;
    [tempLabel sizeToFit];
    tempLabel.backgroundColor = [[UIColor CMLUserGrayColor] colorWithAlphaComponent:0.5];
    tempLabel.frame = CGRectMake(25*Proportion,
                                 0,
                                 WIDTH - 25*Proportion - 25*Proportion,
                                 40*Proportion);
    [view addSubview:tempLabel];
    return view ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.sectionIndexsArray count];
}



- (void) setBrandModuleRequest{
    
//    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
//    delegate.delegate = self;
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//
//    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
//    [paraDic setObject:reqTime
//                forKey:@"reqTime"];
//    [paraDic setObject:[[DataManager lightData] readSkey]
//                forKey:@"skey"];
//    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,[[DataManager lightData] readSkey]]];
//    [paraDic setObject:hashToken forKey:@"hashToken"];
//
//
//    [NetWorkTask getRequestWithApiName:MailBrandModule
//                                 param:paraDic
//                              delegate:delegate];
//    self.currentApiName = MailBrandModule;
    
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
    
    [NetWorkTask getRequestWithApiName:ALlBrandList
                                 param:paraDic
                              delegate:delegate];
    self.currentApiName = ALlBrandList;
    
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ALlBrandList]) {
    
        BaseResultObj *obj = [BaseResultObj  getBaseObjFrom:responseResult];
    
        if ([obj.retCode intValue] == 0) {
            
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                BrandModuleObj *moduleObj = [BrandModuleObj getBaseObjFrom:obj.retData.dataList[i]];
                
                if ([self.brandDataDic objectForKey:[moduleObj.firstLetter uppercaseString]]) {
                  
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.brandDataDic valueForKey:[moduleObj.firstLetter uppercaseString]]];
                    [tempArray addObject:obj.retData.dataList[i]];
                    [self.brandDataDic setObject:tempArray forKey:[moduleObj.firstLetter uppercaseString]];
                    
                }else{
                    
                    NSArray *tempArray = [NSArray arrayWithObject:obj.retData.dataList[i]];
                    [self.brandDataDic setObject:tempArray forKey:[moduleObj.firstLetter uppercaseString]];
                }
                
            }
            self.sectionIndexsArray = [NSMutableArray arrayWithArray:[self.brandDataDic allKeys]];
            
            NSInteger inde =[self.sectionIndexsArray indexOfObject:@"#"];
            
            if (inde != NSNotFound) {
                
                [self.sectionIndexsArray removeObject:@"#"];
                
                for (int i = 0; i < self.sectionIndexsArray.count; ++i) {
                    
                    for (int j = 0; j < self.sectionIndexsArray.count-1; ++j) {
                        
                        if (self.sectionIndexsArray[j] > self.sectionIndexsArray[j+1]) {
                            
                            [self.sectionIndexsArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        }
                        
                    }
                }
                [self.sectionIndexsArray addObject:@"#"];
                
                
            }else{
             
                for (int i = 0; i < self.sectionIndexsArray.count; ++i) {
                    
                    for (int j = 0; j < self.sectionIndexsArray.count-1; ++j) {
                        
                        if (self.sectionIndexsArray[j] > self.sectionIndexsArray[j+1]) {
                            
                            [self.sectionIndexsArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        }
                        
                    }
                }
                
            }
            [self reloadData];
            
            self.tagHeight = 0;
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }
    
    [self.baseTableViewDlegate endRequesting];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate endRequesting];
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
}
@end
