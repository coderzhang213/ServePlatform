//
//  CMLShoppingCarTableView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/7.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLShoppingCarTableView.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "MJRefresh.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "MJRefresh.h"
#import "CMLServeObj.h"
#import "VCManger.h"
#import "CMLShoppingCarTVCell.h"
#import "ServeRecommedUserObj.h"
#import "CMLShoppingCarBrandObj.h"
#import "ShoppingCarFooterView.h"
#import "ShoppingCarOrderVC.h"
#import "PackDetailInfoObj.h"


@interface CMLShoppingCarTableView ()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CMLShoppingCarTVCellDelegate,ShoppingCarFooterViewDelegate, ShoppingCarOrderVCDelegate>

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) NSMutableArray *effectiveBrandArray;

@property (nonatomic,strong) NSMutableArray *invalidBrandArray;

@property (nonatomic,strong) NSMutableDictionary *selectDic;

@property (nonatomic,strong) NSMutableDictionary *singlePriceDic;

@property (nonatomic,strong) CMLShoppingCarBrandObj *deleleObj;

@property (nonatomic, strong) BaseResultObj *baseObj;

@property (nonatomic,strong) NSNumber *changeCarID;

@property (nonatomic,assign) BOOL ischangeNum;

@property (nonatomic,assign) int deleteSection;

@property (nonatomic,assign) int deleteRow;

@property (nonatomic,assign) BOOL isAdd;

@property (nonatomic,strong) ShoppingCarFooterView *currentFooterView;

@end

@implementation CMLShoppingCarTableView

-(NSMutableDictionary *)singlePriceDic{
    
    if (!_singlePriceDic) {
        _singlePriceDic = [NSMutableDictionary dictionary];
    }
    return _singlePriceDic;
}

-(NSMutableDictionary *)selectDic{
    
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}


- (NSMutableArray *)effectiveBrandArray{
    
    if (!_effectiveBrandArray) {
        _effectiveBrandArray = [NSMutableArray array];
    }
    return _effectiveBrandArray;
}

- (NSMutableArray *)invalidBrandArray{
    
    if (!_invalidBrandArray) {
        _invalidBrandArray = [NSMutableArray array];
    }
    return _invalidBrandArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor CMLWhiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)){
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
        [self loadData];
    }
    
    return self;
}


- (void) loadData{
    
    self.ischangeNum = NO;
    [self setShoppingCarList];
}



#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.invalidBrandArray.count == 0) {
        
        return 0.001;
    }else{
     
        if (section == 0) {
            
            return 0.001;
            
        }else{
            
            if (self.effectiveBrandArray.count + self.invalidBrandArray.count == 0) {
              
                 return 0.001;
            }else{
                
                 return 20*Proportion;
                
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.invalidBrandArray.count == 0) {
     
        if (section == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
            view.backgroundColor = [UIColor CMLNewGrayColor];
            return view ;
            
        }else{
            
            if (self.effectiveBrandArray.count + self.invalidBrandArray.count == 0) {
                
            
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
                view.backgroundColor = [UIColor CMLNewGrayColor];
                return view ;
                
            }else{
             
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20*Proportion)];
                view.backgroundColor = [UIColor CMLNewGrayColor];
                return view ;
                
            }
            
        }
        
    }else{
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        view.backgroundColor = [UIColor CMLNewGrayColor];
        return view ;
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.effectiveBrandArray.count;
        
    }else{
        
        return self.invalidBrandArray.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
     
        return 240*Proportion;
        
    }else{
        
        return 240*Proportion;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    
        if (self.effectiveBrandArray.count > 0) {
           
            static NSString *identifier = @"myCell1";
            
            CMLShoppingCarTVCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                cell = [[CMLShoppingCarTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            
            CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:self.effectiveBrandArray[indexPath.row]];
            
            if ([[self.selectDic valueForKey:[NSString stringWithFormat:@"%@",tempObj.carId]] intValue] == 1) {
                cell.isSelect = YES;
            }else{
                cell.isSelect = NO;
            }
            [cell refreshCurrentCellWith:tempObj withBaseObj:self.baseObj];
            
            return cell;
            
        }else{
            
            static NSString *identifier = @"myCell2";
            
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            return cell;
        }
    }else{
     

        if (self.invalidBrandArray.count > 0) {
            
            static NSString *identifier = @"myCell3";
            
            CMLShoppingCarTVCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[CMLShoppingCarTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:self.invalidBrandArray[indexPath.row]];
            cell.NoSelect = YES;
    
            [cell refreshCurrentCellWith:tempObj withBaseObj:self.baseObj];
            
            return cell;
            
        }else{
            
            static NSString *identifier = @"myCell2";
            
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        self.deleteRow = (int)indexPath.row;
        self.deleteSection = (int)indexPath.section;
        
        if (indexPath.section == 0) {
            
            self.deleleObj = [CMLShoppingCarBrandObj getBaseObjFrom:self.effectiveBrandArray[indexPath.row]];
            
        }else{
            self.deleleObj = [CMLShoppingCarBrandObj getBaseObjFrom:self.invalidBrandArray[indexPath.row]];
            
        }
        
        [self deleteCurrentBrand];
    }
    else{
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - request
- (void) setShoppingCarList {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask getRequestWithApiName:MailShoppingCarList
                                 param:paraDic
                              delegate:delegate];
    
    self.currentApiName = MailShoppingCarList;
}

- (void) deleteCurrentBrand{
    
    [self.baseTableViewDlegate startRequesting];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:self.deleleObj.carId
                forKey:@"objId"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.deleleObj.carId,
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:MailDeleteBrandOfShoppingCar
                                 paraDic:paraDic
                                delegate:delegate];
    
    self.currentApiName = MailDeleteBrandOfShoppingCar;
    
}

- (void) changeCurrentBrandStatus:(NSNumber *) status{
    
    [self.baseTableViewDlegate startRequesting];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime
                forKey:@"reqTime"];
    [paraDic setObject:[[DataManager lightData] readSkey]
                forKey:@"skey"];
    [paraDic setObject:self.changeCarID
                forKey:@"carId"];
    [paraDic setObject:status
                forKey:@"updateType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.changeCarID,
                                                           status,
                                                           reqTime,
                                                           [[DataManager lightData] readSkey]]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:MailUpdateBrandBuyMessage
                                 paraDic:paraDic
                                delegate:delegate];
    
    self.currentApiName = MailUpdateBrandBuyMessage;
    
}


#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:MailShoppingCarList]) {
        
        if (!self.currentFooterView) {
            
            self.currentFooterView = [[ShoppingCarFooterView alloc] init];
            self.currentFooterView.delegate = self;
            [self.superview addSubview:self.currentFooterView];
        }
        NSLog(@"%@", responseResult);
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        self.baseObj = obj;
        
        if ([obj.retCode intValue] == 0) {
            
            /**单价存储*/
            if ([self.singlePriceDic allValues].count == 0) {
                
                for (int i = 0; i < obj.retData.dataList.count; i++) {
                    
                    CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:obj.retData.dataList[i]];
                    
                    if ([tempObj.objType intValue] == 3) {
                        
                        if ([tempObj.packageInfo.payMode intValue] == 1) {
                            
                            [self.singlePriceDic setObject:tempObj.packageInfo.subscription forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                        }else{
                            
                            [self.singlePriceDic setObject:tempObj.packageInfo.totalAmount forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                        }
                        /*存在折扣时价格存储*/
                        if ([self.baseObj.retData.isEnjoyDiscount intValue] == 1) {
                            if (tempObj.projectInfo.is_discount) {
                                if ([tempObj.projectInfo.is_discount intValue] == 1) {
                                    if ([tempObj.packageInfo.discount intValue] != 0) {
                                        [self.singlePriceDic setObject:tempObj.packageInfo.discount forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }else if([tempObj.objType intValue] == 7){
                        
                        if ([tempObj.packageInfo.is_pre intValue] == 1) {
                       
                                [self.singlePriceDic setObject:tempObj.packageInfo.pre_price forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                        }else{
                            
                                [self.singlePriceDic setObject:tempObj.packageInfo.totalAmount forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                            
                        }
                        
                        /*存在折扣时价格存储*/
                        if ([self.baseObj.retData.isEnjoyDiscount intValue] == 1) {
                            if (tempObj.projectInfo.is_discount) {
                                if ([tempObj.projectInfo.is_discount intValue] == 1) {
                                    if ([tempObj.packageInfo.discount intValue] != 0) {
                                        [self.singlePriceDic setObject:tempObj.packageInfo.discount forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                                    }
                                }
                            }
                        }
                        
                        if ([tempObj.projectInfo.is_deposit intValue] == 1) {
                            
                            [self.singlePriceDic setObject:tempObj.projectInfo.deposit_money forKey:[NSString stringWithFormat:@"%@",tempObj.carId]];
                        }
                    }
                }
            }
                
            [self.invalidBrandArray removeAllObjects];
            [self.effectiveBrandArray removeAllObjects];
            
            /**可购买不可购买分类*/
            for (int i = 0; i < obj.retData.dataList.count; i++) {
                
                CMLShoppingCarBrandObj *tempObj = [CMLShoppingCarBrandObj getBaseObjFrom:obj.retData.dataList[i]];
                
                if ([tempObj.objType intValue] == 3) {
                    
                    if ([tempObj.projectInfo.sysOrderStatus intValue] == 1) {
                        

                        if ([tempObj.packageInfo.surplusStock intValue] > 0) {

                            if ([tempObj.goodNum intValue] > [tempObj.packageInfo.surplusStock intValue]) {
                               
                                [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                                
                            }else{
                                
                                [self.effectiveBrandArray addObject:obj.retData.dataList[i]];
                            }
                            
                        }else{
                            
                            [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                        }

    
                    }else{
                        
                        [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                    }
                }else if([tempObj.objType intValue] == 7){
                    
                    if ([tempObj.projectInfo.sysApplyStatus intValue] == 1) {
                        
                        if ([tempObj.packageInfo.surplusStock intValue] > 0) {
                            
                            if ([tempObj.goodNum intValue] > [tempObj.packageInfo.surplusStock intValue]) {
                                
                                [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                                
                            }else{
                                
                                [self.effectiveBrandArray addObject:obj.retData.dataList[i]];
                            }
                        }else{
                            
                            [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                        }
                        
                    }else{
                        
                        [self.invalidBrandArray addObject:obj.retData.dataList[i]];
                    }
                }
            }

//            if (self.ischangeNum) {
//
//                    for (int j = 0; j < self.effectiveBrandArray.count; j++) {
//
//                        CMLShoppingCarBrandObj *obj = [CMLShoppingCarBrandObj getBaseObjFrom:self.effectiveBrandArray[j]];
//
//                        if ([obj.carId intValue] == [self.changeCarID intValue]) {
//
//
//                            [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:j inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//
//                            [self refrshCurrentPrice];
//
//                        }
//                    }
//
//            }else{
            
                [self reloadData];
                
//            }
        
            if (self.effectiveBrandArray.count + self.invalidBrandArray.count == 0) {
                
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          WIDTH,
                                                                          CGRectGetHeight(self.frame) - 100 * Proportion - NavigationBarHeight + StatusBarHeight)];
                bgView.backgroundColor = [UIColor CMLWhiteColor];
                UIImageView *tempImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MailShoppingCarNoBrandImg]];
                [tempImage sizeToFit];
                tempImage.frame = CGRectMake(WIDTH/2.0 - tempImage.frame.size.width/2.0,
                                             bgView.frame.size.height/2.0 - tempImage.frame.size.height/2.0,
                                             tempImage.frame.size.width,
                                             tempImage.frame.size.height);
                [bgView addSubview:tempImage];
                
                UILabel *promLab = [[UILabel alloc] init];
                promLab.font = KSystemFontSize14;
                promLab.text = @"快去加点好东西吧";
                promLab.textColor = [UIColor CMLLineGrayColor];
                [promLab sizeToFit];
                promLab.frame = CGRectMake(WIDTH/2.0 - promLab.frame.size.width/2.0,
                                           CGRectGetMaxY(tempImage.frame) + 20*Proportion,
                                           promLab.frame.size.width,
                                           promLab.frame.size.height);
                [bgView addSubview:promLab];
                self.tableFooterView = bgView;
                
            }else{
                
                UIView *endView = [[UIView alloc] init];
                self.tableFooterView = endView;
            }
            
        }else{
            
            [self.baseTableViewDlegate endRequesting];
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        [self.baseTableViewDlegate endRequesting];
        
    }else if ([self.currentApiName isEqualToString:MailDeleteBrandOfShoppingCar]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            
            if (self.deleteSection == 0 ) {
            
                [self.effectiveBrandArray removeObjectAtIndex:self.deleteRow];
                
            }else{
                
                [self.invalidBrandArray removeObjectAtIndex:self.deleteRow];
            }
            
            [self reloadData];
        }else{
            
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
        
        [self.baseTableViewDlegate endRequesting];
    }else if([self.currentApiName isEqualToString:MailUpdateBrandBuyMessage]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            self.ischangeNum = YES;
        
            [self setShoppingCarList];
            
        }else{
            
            [self.baseTableViewDlegate endRequesting];
            [self.baseTableViewDlegate showFailActionMessage:obj.retMsg];
        }
    }
    
}


- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.baseTableViewDlegate endRequesting];
    [self.baseTableViewDlegate showFailActionMessage:@"网络连接失败"];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - CMLShoppingCarTVCellDelegate

- (void)changeBrandStatus:(BOOL) isSelect currentBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType{

    if (isSelect) {
        [self.selectDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%@",currentCarID]];

    }else{
        [self.currentFooterView changeAllSelectStatus];
        [self.selectDic removeObjectForKey:[NSString stringWithFormat:@"%@",currentCarID]];
    }
    
    [self refrshCurrentPrice];
}

- (void)addBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType{
    
    self.isAdd = YES;
    self.changeCarID = currentCarID;
    [self changeCurrentBrandStatus:[NSNumber numberWithInt:1]];
    [self.baseTableViewDlegate startRequesting];
    
}

- (void)reduceBrandID:(NSNumber *) currentID currentCarID:(NSNumber *) currentCarID currentObjID:(NSNumber *) objID currentObjType:(NSNumber *) objType{
    
    self.isAdd = NO;
    self.changeCarID = currentCarID;
    [self changeCurrentBrandStatus:[NSNumber numberWithInt:2]];
    [self.baseTableViewDlegate startRequesting];
    
}

#pragma mark - ShoppingCarFooterViewDelegate
- (void) selectAll{
    

    for (int i = 0 ; i < self.effectiveBrandArray.count; i++) {
        
        CMLShoppingCarBrandObj *obj = [CMLShoppingCarBrandObj getBaseObjFrom:self.effectiveBrandArray[i]];
        
        [self.selectDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%@",obj.carId]];
    }
    
    [self reloadData];
    [self refrshCurrentPrice];
    
}

- (void) cancelAll{
    
    [self.selectDic removeAllObjects];
    [self reloadData];
    [self refrshCurrentPrice];
}

- (void) buyAllBrand{
    
    if ([self.selectDic allKeys].count > 0) {
     
        ShoppingCarOrderVC *vc = [[ShoppingCarOrderVC alloc] init];
        vc.oderDelegate = (id)self;
        vc.sourceArray = self.effectiveBrandArray;
        vc.selectArray = [self.selectDic allKeys];
        vc.carOrderBaseObj = self.baseObj;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
        [self.baseTableViewDlegate showFailActionMessage:@"请选中商品"];
    }
    
}

- (void) refrshCurrentPrice{
    
    int totalMoney = 0;
    NSArray *selectBrandArray = [self.selectDic allKeys];
    
    if (selectBrandArray.count == 0) {
        
        [self.currentFooterView refreshCurrentWithTotalMoney:0];
        
    }else{
        
        for (int i = 0; i < selectBrandArray.count; i++) {
         
            for (int j = 0; i < self.effectiveBrandArray.count; j++) {
                
                CMLShoppingCarBrandObj *obj = [CMLShoppingCarBrandObj getBaseObjFrom:self.effectiveBrandArray[j]];
                
                if ([obj.carId intValue] == [selectBrandArray[i] intValue]) {
                    
                    totalMoney += [obj.goodNum intValue] * [[self.singlePriceDic valueForKey:[NSString stringWithFormat:@"%@",obj.carId]] intValue];
                    
                    break;
                }
            }
            
        }
        
        [self.currentFooterView refreshCurrentWithTotalMoney:totalMoney];
    }
}

//#pragma ShoppingCarOrderVCDelegate
//- (void)backToShoppingCar {
//
//
//
//}

@end
