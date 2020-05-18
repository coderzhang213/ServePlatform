//
//  CMLNewPersonalMemberCardView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/7/15.
//  Copyright © 2019 卡枚连. All rights reserved.
//

#import "CMLNewPersonalMemberCardView.h"
#import "CMLPCMemberCardModel.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "SVProgressHUD.h"
#import "BaseResultObj.h"
#import "RetDataObj.h"
#import "LoginUserObj.h"

@interface CMLNewPersonalMemberCardView ()<NetWorkProtocol>

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImageView *enterIcon;

@property (nonatomic, strong) UILabel *iconLabel;

@property (nonatomic, strong) UILabel *memberLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, strong) BaseResultObj *obj;

@property (nonatomic, strong) BaseResultObj *userBaseObj;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) UIImage *vImage;

@end

@implementation CMLNewPersonalMemberCardView

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withObj:(BaseResultObj *)obj withCoverImage:(UIImage *)coverImage vImage:(UIImage *)vImage {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.userBaseObj = obj;
        self.coverImage = coverImage;
        self.vImage = vImage;
        [self loadData];
        [self loadViews];
    }
    return self;
    
}

- (void)loadViews {
    
    self.mainImageView.image = self.coverImage;//[UIImage imageNamed:CMLNewPersonalLvl1Card];
    [self addSubview:self.mainImageView];
    
    /*会员icon*/
    [self.iconImageView setImage:[UIImage imageNamed:CMLNewPersonalLvl11PartnerIcon]];
    [self.iconImageView sizeToFit];
    self.iconImageView.frame = CGRectMake(40 * Proportion, 40 * Proportion - 10 * Proportion, self.iconImageView.frame.size.width, self.iconImageView.frame.size.height);
    self.iconImageView.image = self.vImage;
    [self.mainImageView addSubview:self.iconImageView];
    
    /*会员icon名称*/
    self.iconLabel.text = self.userBaseObj.retData.user.roleName;
    [self.iconLabel sizeToFit];
    self.iconLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10 * Proportion,
                                      CGRectGetMidY(self.iconImageView.frame) - CGRectGetHeight(self.iconLabel.frame)/2.0 + 5 * Proportion,
                                      CGRectGetWidth(self.iconLabel.frame)*2,
                                      CGRectGetHeight(self.iconLabel.frame));
    [self.mainImageView addSubview:self.iconLabel];
    
    /*会员名称*/
    self.memberLabel.text = self.userBaseObj.retData.user.roleName;
    [self.memberLabel sizeToFit];
    self.memberLabel.frame = CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5 * Proportion,
                                        CGRectGetMaxY(self.iconImageView.frame) + 30 * Proportion,
                                        CGRectGetWidth(self.memberLabel.frame)*2,
                                        CGRectGetHeight(self.memberLabel.frame));
    [self.mainImageView addSubview:self.memberLabel];
    
    /*会员权益num*/
    [self.contentLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5 * Proportion, CGRectGetMaxY(self.memberLabel.frame) + 10 * Proportion, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame));
    [self.mainImageView addSubview:self.contentLabel];
    NSString *contentString = [NSString stringWithFormat:@"专属 %@ 项权益", self.userBaseObj.retData.user.equityCount];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"BanglaSangamMN" size:16], NSForegroundColorAttributeName:[UIColor CMLWhiteColor]};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attString setAttributes:attributes range:NSMakeRange(3, 1)];
    self.contentLabel.attributedText = attString;
    [self.contentLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5 * Proportion, CGRectGetMaxY(self.memberLabel.frame) - 0 * Proportion, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame));
    
    /*会员中心button*/
    if ([[[DataManager lightData] readRoleId] intValue] > 6) {
        self.enterButton.frame = CGRectMake(self.frame.size.width - 44 * Proportion - self.enterButton.frame.size.width,
                                            30 * Proportion,
                                            self.enterButton.frame.size.width,
                                            self.enterButton.frame.size.height);
    }
    [self.mainImageView addSubview:self.enterButton];

}

- (void)refreshData {

//    [NetWorkTask setImageView:self.mainImageView WithURL:self.userBaseObj.retData.user.coverUrl placeholderImage:nil];
//    [NetWorkTask setImageView:self.iconImageView WithURL:self.userBaseObj.retData.user.vUrl placeholderImage:nil];
    
    NSInteger roleId = [[[DataManager lightData] readRoleId] integerValue];
    for (int i = 0; i < self.dataArray.count; i++) {
        CMLPCMemberCardModel *cardModel = [CMLPCMemberCardModel getBaseObjFrom:self.dataArray[i]];
        if ([cardModel.role_id integerValue] == 6) {
            /*6:5年黛色权益和黛色年卡一样*/
            cardModel.role_id = [NSNumber numberWithInteger:5];
        }
        if ([cardModel.role_id integerValue] == roleId) {
            self.iconLabel.text = [NSString stringWithFormat:@"%@", cardModel.group_name];
            self.memberLabel.text = [NSString stringWithFormat:@"%@", cardModel.group_name];
            self.contentLabel.text = [NSString stringWithFormat:@"专属 %@ 项权益", cardModel.equityCount];
        }
    }
    [self.iconLabel sizeToFit];
    self.iconLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10 * Proportion,
                                      CGRectGetMidY(self.iconImageView.frame) - CGRectGetHeight(self.iconLabel.frame)/2.0 + 5 * Proportion,
                                      CGRectGetWidth(self.iconLabel.frame) * 2,
                                      CGRectGetHeight(self.iconLabel.frame));
    [self.memberLabel sizeToFit];
    self.memberLabel.frame = CGRectMake(CGRectGetMinX(self.iconImageView.frame) + 5 * Proportion,
                                        CGRectGetMaxY(self.iconImageView.frame) + 30 * Proportion,
                                        CGRectGetWidth(self.memberLabel.frame)*2,
                                        CGRectGetHeight(self.memberLabel.frame));
}

- (void)loadData {
    [self setMemberCardMessageRequest];
}

- (void)setMemberCardMessageRequest {
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [NetWorkTask getRequestWithApiName:MemberRoleList param:paraDic delegate:delegate];
    
}

- (void)requestSucceedBack:(id)responseResult withApiName:(NSString *)apiName {
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    NSLog(@"responseResult %@", responseResult);
    if ([obj.retCode intValue] == 0) {
        self.obj = obj;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:obj.retData.dataList];
//        [self refreshData];
    }else {
        [SVProgressHUD showErrorWithStatus:obj.retMsg];
    }
    
}

- (void)requestFailBack:(id)errorResult withApiName:(NSString *)apiName {
    NSLog(@"%@", errorResult);
    [SVProgressHUD showErrorWithStatus:@"网络好像有问题~"];
}

/****/
- (UIImageView *)mainImageView {
    
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.clipsToBounds = YES;
        _mainImageView.backgroundColor = [UIColor clearColor];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UIImageView *)iconImageView {

    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

- (UIButton *)enterButton {
    
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        _enterButton.backgroundColor = [UIColor clearColor];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [_enterButton setTitleColor:[UIColor CMLBlackColor] forState:UIControlStateNormal];
        NSString *titleString = @"会员中心";
        CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}].width;
        [_enterButton setTitle:titleString forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[UIImage imageNamed:CMLNewPersonalMemberEnterBgImg] forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:CMLNewPersonalMemberEnterIcon];
        [_enterButton setImage:image forState:UIControlStateNormal];
        _enterButton.adjustsImageWhenHighlighted = NO;
        [_enterButton sizeToFit];
        [_enterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(image.size.width + 2*Proportion), 0, image.size.width + 2*Proportion)];
        [_enterButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth + 4 * Proportion, 0, -(titleWidth + 4 * Proportion))];
        _enterButton.frame = CGRectMake(self.frame.size.width - 40 * Proportion - _enterButton.frame.size.width,
                                        CGRectGetMidY(self.iconLabel.frame) - _enterButton.frame.size.height/2.0,
                                        _enterButton.frame.size.width,
                                        _enterButton.frame.size.height);
        [_enterButton addTarget:self action:@selector(enterMemberCenter) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _enterButton;
}

- (UILabel *)iconLabel {
    
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] init];
        _iconLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _iconLabel.text = @" ";
        _iconLabel.textColor = [UIColor CMLWhiteColor];
        _iconLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _iconLabel;
}

- (UILabel *)memberLabel {
    
    if (!_memberLabel) {
        _memberLabel = [[UILabel alloc] init];
        _memberLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        _memberLabel.text = @" ";
        _memberLabel.textColor = [UIColor CMLWhiteColor];
        _memberLabel.backgroundColor = [UIColor clearColor];
    }
    return _memberLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _contentLabel.text = @"专属    项权益";
        _contentLabel.textColor = [UIColor CMLWhiteColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont fontWithName:@"BanglaSangamMN" size:14];
        _numberLabel.text = @"4";
        _numberLabel.textColor = [UIColor CMLWhiteColor];
        _numberLabel.backgroundColor = [UIColor clearColor];
    }
    return _numberLabel;
}

- (void)enterMemberCenter {
    
    [self.delegate enterMemberCenterOfCardViewWithRoleObj:self.obj];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
