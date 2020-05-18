//
//  SearchVIPMemberView.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "SearchVIPMemberView.h"
#import "NetWorkTask.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "CMLSearchVIPVC.h"
#import "LoginUserObj.h"
#import "CMLVIPNewDetailVC.h"

#define SearchResultLeftMargin        30
#define SearchResultTopMargin         40
#define SearchResultTitleAndLineSpace 10
#define SearchResultBtnHeight         100
#define SearchResultMoreBtnTopMargin  60
#define SearchResultMoreBtnBottomMargin 40
#define SearchResultMoreBtnHeight     48
#define SearchResultImageWidthAndHeight 160

@interface SearchVIPMemberView ()

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) int dataCount;

@property (nonatomic,copy) NSString *searchStr;

@end

@implementation SearchVIPMemberView

- (instancetype) initWithDataArray:(NSArray *)array dataCount:(int) count andSearchStr:(NSString *) str{

    self = [super init];
    
    if (self) {
        
        self.dataArray = array;
        self.dataCount = count;
        self.searchStr = str;
        [self loadViews];
    }
    
    return self;
}

- (void)loadViews{
    
    UILabel *VIPMemberTile = [[UILabel alloc] init];
    VIPMemberTile.text = @"相关会员";
    VIPMemberTile.font = KSystemFontSize12;
    VIPMemberTile.textColor = [UIColor CMLtextInputGrayColor];
    [VIPMemberTile sizeToFit];
    VIPMemberTile.frame = CGRectMake(SearchResultLeftMargin*Proportion,
                                     SearchResultTopMargin*Proportion,
                                     VIPMemberTile.frame.size.width,
                                     VIPMemberTile.frame.size.height);
    [self addSubview:VIPMemberTile];
    
    CMLLine *VIPMemberLine = [[CMLLine alloc] init];
    VIPMemberLine.directionOfLine = VerticalLine;
    VIPMemberLine.lineWidth = 4*Proportion;
    VIPMemberLine.LineColor = [UIColor CMLYellowColor];
    VIPMemberLine.lineLength = VIPMemberTile.frame.size.height;
    VIPMemberLine.startingPoint = CGPointMake(VIPMemberTile.frame.origin.x - 10*Proportion,VIPMemberTile.frame.origin.y);
    [self addSubview:VIPMemberLine];
    
    CMLLine *spaceLine = [[CMLLine alloc] init];
    spaceLine.lineWidth = 1*Proportion;
    spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
    spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
    spaceLine.startingPoint = CGPointMake(SearchResultLeftMargin*Proportion,
                                          CGRectGetMaxY(VIPMemberTile.frame) + 30*Proportion);
    [self addSubview:spaceLine];
    
    int VIPMemberNum = 0;
//    if (self.dataCount > 3) {
//        VIPMemberNum = 3;
//    }else{
        VIPMemberNum = (int)self.dataArray.count;
//    }
    
    if (VIPMemberNum == 0) {
        
        self.currentHeight = 0;
        self.hidden = YES;
    }
    
    for (int i = 0; i < VIPMemberNum; i++) {
        
        LoginUserObj *obj = [LoginUserObj getBaseObjFrom:self.dataArray[i]];
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(SearchResultLeftMargin*Proportion,
                                                                               CGRectGetMaxY(VIPMemberTile.frame) + 60*Proportion + (100 +60)*Proportion*i,
                                                                               100*Proportion,
                                                                               100*Proportion)];
        userImage.layer.cornerRadius = 6*Proportion;
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        userImage.clipsToBounds = YES;
        userImage.userInteractionEnabled = YES;
        [self addSubview:userImage];
        [NetWorkTask setImageView:userImage WithURL:obj.gravatar placeholderImage:nil];
        
//        CMLLine *spaceLine = [[CMLLine alloc] init];
//        spaceLine.lineWidth = 1*Proportion;
//        spaceLine.LineColor = [UIColor CMLSerachLineGrayColor];
//        spaceLine.lineLength = WIDTH - SearchResultLeftMargin*Proportion*2;
//        spaceLine.startingPoint = CGPointMake(20*Proportion + CGRectGetMaxX(userImage.frame),
//                                              CGRectGetMaxY(userImage.frame) + 30*Proportion);
//        [self addSubview:spaceLine];
        
        UILabel *userName = [[UILabel alloc] init];
        userName.font = KSystemBoldFontSize14;
        userName.textColor = [UIColor CMLBlackColor];
        userName.text = obj.nickName;
        [userName sizeToFit];
        userName.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                    userImage.frame.origin.y,
                                    userName.frame.size.width,
                                    userName.frame.size.height);
        [self addSubview:userName];
        
        UILabel *positionLab = [[UILabel alloc] init];
        positionLab.font = KSystemFontSize12;
        positionLab.textColor = [UIColor CMLLineGrayColor];
        positionLab.text = obj.title;
        [positionLab sizeToFit];
        positionLab.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 20*Proportion,
                                       CGRectGetMaxY(userName.frame) + 10*Proportion,
                                       positionLab.frame.size.width,
                                       positionLab.frame.size.height);
        [self addSubview:positionLab];
        
        UILabel *lvlLabel = [[UILabel alloc] init];
        lvlLabel.font = KSystemFontSize10;
        lvlLabel.textAlignment = NSTextAlignmentCenter;
        lvlLabel.text = obj.memberVipGrade;
        lvlLabel.textColor = [UIColor getLvlColor:obj.memberLevel];
        lvlLabel.layer.borderColor = [UIColor getLvlColor:obj.memberLevel].CGColor;
        lvlLabel.layer.borderWidth = 1*Proportion;
        lvlLabel.layer.cornerRadius = 2*Proportion;
        lvlLabel.backgroundColor = [UIColor whiteColor];
        [lvlLabel sizeToFit];
        lvlLabel.layer.cornerRadius = 4*Proportion;
        lvlLabel.frame = CGRectMake(CGRectGetMaxX(userName.frame) + 10*Proportion,
                                    userName.center.y - 28*Proportion/2.0,
                                    lvlLabel.frame.size.width + 20*Proportion,
                                    28*Proportion);
        [self addSubview:lvlLabel];
        
        UILabel *VIPMessgae = [[UILabel alloc] init];
        VIPMessgae.font = KSystemFontSize10;
        VIPMessgae.textAlignment = NSTextAlignmentCenter;
        
        switch ([obj.memberPrivilegeLevel intValue]) {
            case 0:
                VIPMessgae.hidden = YES;
                break;
                
            case 1:
                VIPMessgae.hidden = YES;
                break;
                
            case 2:
                VIPMessgae.text = @"黛色特权";
                VIPMessgae.layer.borderColor = [UIColor CMLBlackPigmentColor].CGColor;
                VIPMessgae.textColor = [UIColor CMLBlackPigmentColor];
                break;
                
            case 3:
                VIPMessgae.text = @"金色特权";
                VIPMessgae.layer.borderColor = [UIColor CMLGoldColor].CGColor;
                VIPMessgae.textColor = [UIColor CMLGoldColor];
                break;
                
            case 4:
                VIPMessgae.hidden = YES;
                break;
                
            default:
                break;
        }
        
        VIPMessgae.layer.borderWidth = 1*Proportion;
        VIPMessgae.layer.cornerRadius = 2*Proportion;
        VIPMessgae.backgroundColor = [UIColor whiteColor];
        [VIPMessgae sizeToFit];
        VIPMessgae.layer.cornerRadius = 4*Proportion;
        VIPMessgae.frame = CGRectMake(CGRectGetMaxX(lvlLabel.frame) + 10*Proportion,
                                      userName.center.y - 28*Proportion/2.0,
                                      VIPMessgae.frame.size.width + 20*Proportion,
                                      28*Proportion);
        [self addSubview:VIPMessgae];
        
        UIButton *enterDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                              userImage.frame.origin.y,
                                                                              WIDTH,
                                                                              100*Proportion)];
        enterDetailBtn.backgroundColor = [UIColor clearColor];
        enterDetailBtn.tag = i + 1;
        [self addSubview:enterDetailBtn];
        [enterDetailBtn addTarget:self action:@selector(enterVIPDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NewPersonalCenterUserEnterVCImg]];
        [enterImage sizeToFit];
        enterImage.frame = CGRectMake(WIDTH - 30*Proportion - enterImage.frame.size.width,
                                      100*Proportion/2.0 - enterImage.frame.size.height/2.0,
                                      enterImage.frame.size.width,
                                      enterImage.frame.size.height);
        [enterDetailBtn addSubview:enterImage];
        
        if (i == (VIPMemberNum - 1)) {
            
//            if (self.dataCount > 3) {
//                
//                UIButton *VIPMemberMoreBtn = [[UIButton alloc] init];
//                [VIPMemberMoreBtn setTitle:@"查看更多相关会员" forState:UIControlStateNormal];
//                [VIPMemberMoreBtn setTitleColor:[UIColor CMLLineGrayColor] forState:UIControlStateNormal];
//                VIPMemberMoreBtn.titleLabel.font = KSystemFontSize12;
//                [VIPMemberMoreBtn sizeToFit];
//                [VIPMemberMoreBtn addTarget:self action:@selector(enterSearchListOfMember) forControlEvents:UIControlEventTouchUpInside];
//                VIPMemberMoreBtn.layer.cornerRadius = 4*Proportion;
//                VIPMemberMoreBtn.backgroundColor = [UIColor CMLNewGrayColor];
//                VIPMemberMoreBtn.frame = CGRectMake(WIDTH/2.0 - 232*Proportion/2.0,
//                                                    40*Proportion + CGRectGetMaxY(enterDetailBtn.frame),
//                                                    232*Proportion,
//                                                    SearchResultMoreBtnHeight*Proportion);
//                
//                [self addSubview:VIPMemberMoreBtn];
//                
//                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                              CGRectGetMaxY(VIPMemberMoreBtn.frame) + 40*Proportion,
//                                                                              WIDTH,
//                                                                              20*Proportion)];
//                bottomView.backgroundColor = [UIColor CMLUserGrayColor];
//                [self addSubview:bottomView];
//                
//                
//                self.currentHeight = CGRectGetMaxY(bottomView.frame);
//                
//            }else{
            
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              CGRectGetMaxY(enterDetailBtn.frame) + 40*Proportion,
                                                                              WIDTH,
                                                                              20*Proportion)];
                bottomView.backgroundColor = [UIColor CMLUserGrayColor];
                [self addSubview:bottomView];
                
                self.currentHeight = CGRectGetMaxY(bottomView.frame);
//            }
        }
    }
    
}

- (void) enterVIPDetailVC:(UIButton *) button{
    
    LoginUserObj *obj = [LoginUserObj getBaseObjFrom:self.dataArray[button.tag - 1]];
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:obj.nickName currnetUserId:obj.uid isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

//- (void) enterSearchListOfMember{
//    
//    CMLSearchVIPVC *vc = [[CMLSearchVIPVC alloc] init];
//    vc.currentTitle = self.searchStr;
//    vc.dataArray = self.dataArray;
//    [[VCManger mainVC] pushVC:vc animate:YES];
//}
@end
