//
//  CMLExpressListVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/12/14.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLExpressListVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "CMLOrderObj.h"
#import "CMLOrderListObj.h"
#import "CMLOrderTransitObj.h"
#import "CMLGoodsOrderObj.h"
#import "CMLCommenOrderObj.h"
#import "NetWorkTask.h"
#import "WebViewLinkVC.h"
#import "VCManger.h"

@interface CMLExpressListVC ()<NavigationBarProtocol>

@property (nonatomic,strong) CMLOrderListObj *obj;

@property (nonatomic,strong) NSMutableDictionary *sourceDic;

@property (nonatomic,strong) NSArray *tagArray;

@end

@implementation CMLExpressListVC

-(NSMutableDictionary *)sourceDic{
    
    if (!_sourceDic) {
        _sourceDic = [NSMutableDictionary dictionary];
    }
    return _sourceDic;
}

- (instancetype)initWith:(CMLOrderListObj *) obj{
    
    self = [super init];
    
    if (self) {
        
        self.obj = obj;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.titleContent = @"查看物流";
    self.navBar.delegate = self;
    
    [self loadData];
    
    [self loadViews];
}

- (void) loadData{
    
    for (int i = 0; i < self.obj.goodsOrderInfo.dataList.count; i++) {
        
        CMLGoodsOrderObj *obj = [CMLGoodsOrderObj getBaseObjFrom:self.obj.goodsOrderInfo.dataList[i]];
     
        if ([obj.orderInfo.expressStatus intValue] == 1) {
            
            if ([self.sourceDic valueForKey:obj.orderInfo.expressUrl]) {
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self.sourceDic valueForKey:obj.orderInfo.expressUrl]];
//                if ([[tempDic valueForKey:@"imageUrl"] isEqualToString:obj.coverPicThumb]) {
                
                    
                    int num = [[tempDic valueForKey:@"num"] intValue];
                    [tempDic setObject:[NSString stringWithFormat:@"%d",num + 1] forKey:@"num"];
                    [self.sourceDic setObject:tempDic forKey:obj.orderInfo.expressUrl];
                    
//                }
            }else{
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                
                [tempDic setObject:@"1" forKey:@"num"];
                [tempDic setObject:obj.coverPicThumb forKey:@"imageUrl"];
                [tempDic setObject:obj.brandName forKey:@"brandName"];
                [tempDic setObject:obj.orderInfo.courierName forKey:@"courierName"];
                [tempDic setObject:obj.orderInfo.expressSingle forKey:@"expressSingle"];
                [self.sourceDic setObject:tempDic forKey:obj.orderInfo.expressUrl];
                
       
            }
        }
    }
}

- (void) loadViews{
    
    
    self.tagArray = [self.sourceDic allKeys];
    
    for (int i = 0; i < [self.sourceDic allValues].count; i++) {
        
        NSDictionary *tempDic = [self.sourceDic valueForKey:self.tagArray[i]];
        
        UIView *moduleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      (160*Proportion + 74*Proportion + 40*Proportion)*i + self.navBar.frame.size.height,
                                                                      WIDTH,
                                                                      160*Proportion + 74*Proportion + 40*Proportion)];
        moduleView.backgroundColor = [UIColor CMLWhiteColor];
        [self.contentView addSubview:moduleView];
        
        UILabel *promName = [[UILabel alloc] init];
        promName.text = [NSString stringWithFormat:@"包裹%d",i+1];
        promName.font = KSystemFontSize12;
        promName.textColor = [UIColor CMLLineGrayColor];
        [promName sizeToFit];
        promName.frame = CGRectMake(30*Proportion,
                                    74*Proportion/2.0 - promName.frame.size.height/2.0,
                                    promName.frame.size.width,
                                    promName.frame.size.height);
        [moduleView addSubview:promName];
        
        UIImageView *moduleImage = [[UIImageView alloc] initWithFrame:CGRectMake(30*Proportion, 74*Proportion, 160*Proportion, 160*Proportion)];
        moduleImage.backgroundColor = [UIColor CMLNewGrayColor];
        moduleImage.contentMode = UIViewContentModeScaleAspectFill;
        moduleImage.layer.borderWidth = 1*Proportion;
        moduleImage.layer.borderColor = [UIColor CMLSerachLineGrayColor].CGColor;
        moduleImage.clipsToBounds = YES;
        [moduleView addSubview:moduleImage];
        [NetWorkTask setImageView:moduleImage WithURL:[tempDic valueForKey:@"imageUrl"] placeholderImage:nil];
        
        UILabel *moduleTitleLab = [[UILabel alloc] init];
        moduleTitleLab.numberOfLines = 2;
        moduleTitleLab.font = KSystemFontSize13;
        moduleTitleLab.text = [tempDic valueForKey:@"brandName"];
        moduleTitleLab.textAlignment = NSTextAlignmentLeft;
        [moduleTitleLab sizeToFit];
        if (moduleTitleLab.frame.size.width > WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion) {
            
            moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                              moduleImage.frame.origin.y,
                                              WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                              moduleTitleLab.frame.size.height*2);
        }else{
            
            moduleTitleLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                              moduleImage.frame.origin.y,
                                              WIDTH - 30*Proportion - 30*Proportion - 20*Proportion - 160*Proportion,
                                              moduleTitleLab.frame.size.height);
            
        }
        [moduleView addSubview:moduleTitleLab];
        
        if ([[tempDic valueForKey:@"num"] intValue] > 1) {
            
            UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(0,moduleImage.frame.size.height - 30*Proportion, 160*Proportion, 30*Proportion)];
            numLab.backgroundColor = [UIColor CMLBlackColor];
            numLab.font = KSystemFontSize9;
            numLab.textColor = [UIColor CMLWhiteColor];
            numLab.textAlignment = NSTextAlignmentCenter;
            numLab.text = [NSString stringWithFormat:@"共%@件商品",[tempDic valueForKey:@"num"]];
            [moduleImage addSubview:numLab];
        }
        UILabel *expressNameLab = [[UILabel alloc] init];
        expressNameLab.font = KSystemFontSize12;
        expressNameLab.textColor = [UIColor CMLLineGrayColor];
        expressNameLab.text = [NSString stringWithFormat:@"%@：%@",[tempDic valueForKey:@"courierName"],[tempDic valueForKey:@"expressSingle"]];
        [expressNameLab sizeToFit];
        expressNameLab.frame = CGRectMake(CGRectGetMaxX(moduleImage.frame) + 20*Proportion,
                                          CGRectGetMaxY(moduleImage.frame) - expressNameLab.frame.size.height,
                                          expressNameLab.frame.size.width,
                                          expressNameLab.frame.size.height);
        [moduleView addSubview:expressNameLab];
        
        UIView *endLine = [[UIView alloc] initWithFrame:CGRectMake(30*Proportion,
                                                                   moduleView.frame.size.height - 2*Proportion,
                                                                   WIDTH - 30*Proportion,
                                                                   1*Proportion)];
        endLine.backgroundColor = [UIColor CMLSerachLineGrayColor];
        [moduleView addSubview:endLine];
        
        UIButton *enterBtn = [[UIButton alloc] initWithFrame:moduleView.bounds];
        enterBtn.backgroundColor = [UIColor clearColor];
        [moduleView addSubview:enterBtn];
        enterBtn.tag = i;
        [enterBtn addTarget:self action:@selector(enterExpressDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void) enterExpressDetail:(UIButton *) btn{
    
    WebViewLinkVC *vc = [[WebViewLinkVC alloc] init];
    vc.isShare = [NSNumber numberWithInt:2];
    vc.url = self.tagArray[btn.tag];
    vc.name = @"快递信息";
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}
@end
