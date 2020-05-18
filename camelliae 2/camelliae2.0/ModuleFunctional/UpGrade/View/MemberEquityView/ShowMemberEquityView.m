//
//  ShowMemberEquityView.m
//  camelliae2.0
//
//  Created by 孙志泽 on 2019/3/7.
//  Copyright © 2019 张越. All rights reserved.
//

#import "ShowMemberEquityView.h"
#import "MemberEquityDetailView.h"
#import "CMLPCMemberCardModel.h"
#import "CMLMemberEquityCell.h"
#import "CMLEquityModel.h"

static NSString *const idetifier = @"memberEquityCell";

@interface ShowMemberEquityView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CMLPCMemberCardModel *roleCardModel;

@property (nonatomic, strong) UIImageView *equityView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShowMemberEquityView

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withRoleCardModel:(CMLPCMemberCardModel *)roleCardModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.roleCardModel = roleCardModel;
        if ([self.roleCardModel.role_id intValue] == 6) {
            self.roleCardModel.role_id = [NSNumber numberWithInteger:5];
        }
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    
    /*******/
    
    /*0会员专属权益*/
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8 * Proportion;
    self.clipsToBounds = YES;
    
    /*0会员专属权益*/
    self.equityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLEquityTitleNoSelectImg]];
    self.equityView.contentMode = UIViewContentModeScaleAspectFill;
    self.equityView.backgroundColor = [UIColor clearColor];
    [self.equityView sizeToFit];
    self.equityView.frame = CGRectMake(self.frame.size.width/2 - self.equityView.frame.size.width/2,
                                  41 * Proportion,
                                  self.equityView.frame.size.width,
                                  self.equityView.frame.size.height);
    [self addSubview:self.equityView];
    NSInteger roleId = [[[DataManager lightData] readRoleId] integerValue];
    if (roleId == 6) {
        roleId = 5;
    }
    if ([self.roleCardModel.role_id intValue] == roleId) {
        self.equityView.image = [UIImage imageNamed:CMLEquityTitleSelectImg];
        [self.equityView sizeToFit];
        self.equityView.frame = CGRectMake(self.frame.size.width/2 - self.equityView.frame.size.width/2,
                                           41 * Proportion,
                                           self.equityView.frame.size.width,
                                           self.equityView.frame.size.height);
    }
    
    if ([self.roleCardModel.role_id intValue] == 5 || [self.roleCardModel.role_id intValue] == 6) {
        
        if (self.roleCardModel.equity.count > 0) {
            [self loadMemberEquityView];
        }else {
            [self loadDarkMemberEquityView];
        }
    }else {
        [self loadMemberEquityView];
    }
    
}

- (void)loadMemberEquityView {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             121 * Proportion,
                                                                             CGRectGetWidth(self.frame),
                                                                             CGRectGetHeight(self.frame) - 121 * Proportion - 150 * Proportion)
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[CMLMemberEquityCell class] forCellWithReuseIdentifier:idetifier];
    self.collectionView.backgroundColor = [UIColor CMLWhiteColor];
    [self addSubview:self.collectionView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.roleCardModel.equity.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.frame.size.width/3 - 18 * Proportion * 3, 150 * Proportion);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 32*Proportion, 0 * Proportion, 32 * Proportion);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMLMemberEquityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    CMLEquityModel *equityModel = [CMLEquityModel getBaseObjFrom:self.roleCardModel.equity[indexPath.row]];
    [cell refreshCurrentCellWith:equityModel];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.roleCardModel.role_id intValue] == 5 || [self.roleCardModel.role_id intValue] == 6) {
        [self.delegate showMemberEquityViewButtonClickedDelegateWith:(int)indexPath.row + 1];
    }
    
}


- (void)loadDarkMemberEquityView {
    
    
    /*2共享商城系统-图标*/
    UIImageView *shareMall = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLShareMallNoSelectImg]];
    shareMall.backgroundColor = [UIColor clearColor];
    [shareMall sizeToFit];
    shareMall.frame = CGRectMake(self.frame.size.width/2 - shareMall.frame.size.width/2,
                                 121 * Proportion,
                                 shareMall.frame.size.width,
                                 shareMall.frame.size.height);
    [self addSubview:shareMall];
    
    /*2共享商城系统-title*/
    UILabel *shareTitle = [[UILabel alloc] init];
    shareTitle.text = @"共享商城系统";
    shareTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];//KSystemRealMediumFontSize13;
    shareTitle.backgroundColor = [UIColor clearColor];
    [shareTitle sizeToFit];
    shareTitle.frame = CGRectMake(self.frame.size.width/2 - shareTitle.frame.size.width/2,
                                  CGRectGetMaxY(shareMall.frame) + 18 * Proportion,
                                  shareTitle.frame.size.width,
                                  shareTitle.frame.size.height);
    [self addSubview:shareTitle];
    /*2共享商城系统-intro*/
    UILabel *shareIntro = [[UILabel alloc] init];
    shareIntro.text = @"4大系统使用";
    shareIntro.font = KSystemFontSize9;
    shareIntro.textColor = [UIColor CMLGray979797Color];
    [shareIntro sizeToFit];
    shareIntro.frame = CGRectMake(self.frame.size.width/2 - shareIntro.frame.size.width/2,
                                  CGRectGetMaxY(shareTitle.frame),
                                  shareIntro.frame.size.width,
                                  shareIntro.frame.size.height);
    [self addSubview:shareIntro];
    
    /*2共享商城系统-button*/
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(shareTitle.frame),
                                                                       CGRectGetMinY(shareMall.frame),
                                                                       CGRectGetWidth(shareTitle.frame),
                                                                       CGRectGetMaxY(shareIntro.frame) - CGRectGetMinY(shareMall.frame))];
    shareButton.backgroundColor = [UIColor clearColor];
    shareButton.tag = 2;
    [self addSubview:shareButton];
    [shareButton addTarget:self action:@selector(showMemberEquityViewButtonClickedWith:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat gap = (self.frame.size.width - 3 * shareMall.frame.size.width)/10;
    /*1定制入会礼-图标*/
    UIImageView *customGift = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLCustomGiftNoSelectImg]];
    customGift.backgroundColor = [UIColor clearColor];
    [customGift sizeToFit];
    customGift.frame = CGRectMake(2 * gap,
                                  shareMall.frame.origin.y,
                                  customGift.frame.size.width,
                                  customGift.frame.size.height);
    [self addSubview:customGift];
    /*1定制入会礼-title*/
    UILabel *customTitle = [[UILabel alloc] init];
    customTitle.text = @"定制入会礼";
    customTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];//KSystemRealMediumFontSize13;
    customTitle.backgroundColor = [UIColor clearColor];
    [customTitle sizeToFit];
    customTitle.frame = CGRectMake(customGift.center.x - customTitle.frame.size.width/2,
                                   CGRectGetMaxY(customGift.frame) + 18 * Proportion,
                                   customTitle.frame.size.width,
                                   customTitle.frame.size.height);
    [self addSubview:customTitle];
    /*1定制入会礼-intro*/
    UILabel *customIntro = [[UILabel alloc] init];
    customIntro.text = @"超值享受";
    customIntro.font = KSystemFontSize9;
    customIntro.textColor = [UIColor CMLGray979797Color];
    [customIntro sizeToFit];
    customIntro.frame = CGRectMake(customGift.center.x - customIntro.frame.size.width/2,
                                   CGRectGetMaxY(customTitle.frame),
                                   customIntro.frame.size.width,
                                   customIntro.frame.size.height);
    [self addSubview:customIntro];
    
    /*1定制入会礼-button*/
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(customTitle.frame),
                                                                       CGRectGetMinY(customGift.frame),
                                                                       CGRectGetWidth(customTitle.frame),
                                                                       CGRectGetMaxY(customIntro.frame) - CGRectGetMinY(customGift.frame))];
    customButton.backgroundColor = [UIColor clearColor];
    customButton.tag = 1;
    [self addSubview:customButton];
    [customButton addTarget:self action:@selector(showMemberEquityViewButtonClickedWith:) forControlEvents:UIControlEventTouchUpInside];
    
    /*3品牌折扣卡-图标*/
    UIImageView *discountCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLDiscountCardNoSelectImg]];
    discountCard.backgroundColor = [UIColor clearColor];
    [discountCard sizeToFit];
    discountCard.frame = CGRectMake(CGRectGetWidth(self.frame) - 2 * gap - CGRectGetWidth(discountCard.frame),
                                  shareMall.frame.origin.y,
                                  discountCard.frame.size.width,
                                  discountCard.frame.size.height);
    [self addSubview:discountCard];
    /*3品牌折扣卡-title*/
    UILabel *discountTitle = [[UILabel alloc] init];
    discountTitle.text = @"品牌折扣卡";
    discountTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];//KSystemRealMediumFontSize13;
    discountTitle.backgroundColor = [UIColor clearColor];
    [discountTitle sizeToFit];
    discountTitle.frame = CGRectMake(discountCard.center.x - discountTitle.frame.size.width/2,
                                   CGRectGetMaxY(discountCard.frame) + 18 * Proportion,
                                   discountTitle.frame.size.width,
                                   discountTitle.frame.size.height);
    [self addSubview:discountTitle];
    /*3品牌折扣卡-intro*/
    UILabel *discountIntro = [[UILabel alloc] init];
    discountIntro.text = @"3-9折不等";
    discountIntro.font = KSystemFontSize9;
    discountIntro.textColor = [UIColor CMLGray979797Color];
    [discountIntro sizeToFit];
    discountIntro.frame = CGRectMake(discountCard.center.x - discountIntro.frame.size.width/2,
                                   CGRectGetMaxY(discountTitle.frame),
                                   discountIntro.frame.size.width,
                                   discountIntro.frame.size.height);
    [self addSubview:discountIntro];
    
    /*3品牌折扣卡-button*/
    UIButton *discountButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(discountTitle.frame),
                                                                       CGRectGetMinY(discountCard.frame),
                                                                       CGRectGetWidth(discountTitle.frame),
                                                                       CGRectGetMaxY(discountIntro.frame) - CGRectGetMinY(discountCard.frame))];
    discountButton.backgroundColor = [UIColor clearColor];
    discountButton.tag = 3;
    [self addSubview:discountButton];
    [discountButton addTarget:self action:@selector(showMemberEquityViewButtonClickedWith:) forControlEvents:UIControlEventTouchUpInside];
    
    /*5VIP管家预约-图标*/
    UIImageView *vipOrder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLVIPHousekeeperNoSelectImg]];
    vipOrder.backgroundColor = [UIColor clearColor];
    [vipOrder sizeToFit];
    vipOrder.frame = CGRectMake(self.frame.size.width/2 - vipOrder.frame.size.width/2,
                                 290 * Proportion,
                                 vipOrder.frame.size.width,
                                 vipOrder.frame.size.height);
    [self addSubview:vipOrder];
    /*5VIP管家预约-title*/
    UILabel *vipOrderTitle = [[UILabel alloc] init];
    vipOrderTitle.text = @"VIP管家预约";
    vipOrderTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];//KSystemRealMediumFontSize13;
    vipOrderTitle.backgroundColor = [UIColor clearColor];
    [vipOrderTitle sizeToFit];
    vipOrderTitle.frame = CGRectMake(self.frame.size.width/2 - vipOrderTitle.frame.size.width/2,
                                  CGRectGetMaxY(vipOrder.frame) + 18 * Proportion,
                                  vipOrderTitle.frame.size.width,
                                  vipOrderTitle.frame.size.height);
    [self addSubview:vipOrderTitle];
    /*5VIP管家预约-intro*/
    UILabel *vipOrderIntro = [[UILabel alloc] init];
    vipOrderIntro.text = @"3次/年";
    vipOrderIntro.font = KSystemFontSize9;
    vipOrderIntro.textColor = [UIColor CMLGray979797Color];
    [vipOrderIntro sizeToFit];
    vipOrderIntro.frame = CGRectMake(self.frame.size.width/2 - vipOrderIntro.frame.size.width/2,
                                  CGRectGetMaxY(vipOrderTitle.frame),
                                  vipOrderIntro.frame.size.width,
                                  vipOrderIntro.frame.size.height);
    [self addSubview:vipOrderIntro];
    
    /*5VIP管家预约-button*/
    UIButton *vipOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(vipOrderTitle.frame),
                                                                       CGRectGetMinY(vipOrder.frame),
                                                                       CGRectGetWidth(vipOrderTitle.frame),
                                                                       CGRectGetMaxY(vipOrderIntro.frame) - CGRectGetMinY(vipOrder.frame))];
    vipOrderButton.backgroundColor = [UIColor clearColor];
    vipOrderButton.tag = 5;
    [self addSubview:vipOrderButton];
    [vipOrderButton addTarget:self action:@selector(showMemberEquityViewButtonClickedWith:) forControlEvents:UIControlEventTouchUpInside];
    
    /*4时尚沙龙-图标*/
    UIImageView *fashionSalon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CMLFashionSalonNoSelectImg]];
    fashionSalon.backgroundColor = [UIColor clearColor];
    [fashionSalon sizeToFit];
    fashionSalon.frame = CGRectMake(2 * gap,
                                  vipOrder.frame.origin.y,
                                  fashionSalon.frame.size.width,
                                  fashionSalon.frame.size.height);
    [self addSubview:fashionSalon];
    /*4时尚沙龙-title*/
    UILabel *salonTitle = [[UILabel alloc] init];
    salonTitle.text = @"时尚艺术沙龙";
    salonTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];//KSystemRealMediumFontSize13;
    salonTitle.backgroundColor = [UIColor clearColor];
    [salonTitle sizeToFit];
    salonTitle.frame = CGRectMake(fashionSalon.center.x - salonTitle.frame.size.width/2,
                                   CGRectGetMaxY(fashionSalon.frame) + 18 * Proportion,
                                   salonTitle.frame.size.width,
                                   salonTitle.frame.size.height);
    [self addSubview:salonTitle];
    /*4时尚沙龙-intro*/
    UILabel *salonIntro = [[UILabel alloc] init];
    salonIntro.text = @"8次/年";
    salonIntro.font = KSystemFontSize9;
    salonIntro.textColor = [UIColor CMLGray979797Color];
    [salonIntro sizeToFit];
    salonIntro.frame = CGRectMake(fashionSalon.center.x - salonIntro.frame.size.width/2,
                                   CGRectGetMaxY(salonTitle.frame),
                                   salonIntro.frame.size.width,
                                   salonIntro.frame.size.height);
    [self addSubview:salonIntro];
    
    /*4时尚沙龙-button*/
    UIButton *salonButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(salonTitle.frame),
                                                                       CGRectGetMinY(fashionSalon.frame),
                                                                       CGRectGetWidth(salonTitle.frame),
                                                                       CGRectGetMaxY(salonIntro.frame) - CGRectGetMinY(fashionSalon.frame))];
    salonButton.backgroundColor = [UIColor clearColor];
    salonButton.tag = 4;
    [self addSubview:salonButton];
    [salonButton addTarget:self action:@selector(showMemberEquityViewButtonClickedWith:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[DataManager lightData] readUserLevel] intValue] == 2 && [[[DataManager lightData] readUserLevel] intValue] != 1) {
        
        self.equityView.image = [UIImage imageNamed:CMLEquityTitleSelectImg];
        shareMall.image = [UIImage imageNamed:CMLShareMallSelectImg];
        customGift.image = [UIImage imageNamed:CMLCustomGiftSelectImg];
        discountCard.image = [UIImage imageNamed:CMLDiscountCardSelectImg];
        fashionSalon.image = [UIImage imageNamed:CMLFashionSalonSelectImg];
        vipOrder.image = [UIImage imageNamed:CMLVIPHousekeeperSelectImg];
    }
    
}

- (void)showMemberEquityViewButtonClickedWith:(UIButton *)button {
    
    [self.delegate showMemberEquityViewButtonClickedDelegateWith:(int)button.tag];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
