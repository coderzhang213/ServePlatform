//
//  ShowAgreementView.m
//  camelliae2.0
//
//  Created by 卡枚连 on 2019/3/8.
//  Copyright © 2019 张越. All rights reserved.
//

#import "ShowAgreementView.h"
#import "UpGradeVC.h"
#import "CMLMyWithdrawalViewController.h"
#import "VCManger.h"

@interface ShowAgreementView ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *agreementChooseButton;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *agreementString;

@end

@implementation ShowAgreementView

- (instancetype)initWithFrame:(CGRect)frame withType:(UIButton *)button {
    
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10 * Proportion;
        self.clipsToBounds = YES;
        self.isSelected = YES;
        [self loadViewWithType:button];
    }
    return self;
    
}


- (void)loadViewWithType:(UIButton *)button {
    
    UILabel *title = [[UILabel alloc] init];
    if (button.tag == 3) {
        title.text = @"粉金会员服务协议";
    }else if (button.tag == 5) {
        title.text = @"黛色会员服务协议";
    }
    
    title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [title sizeToFit];
    title.frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetWidth(title.frame)/2,
                             52 * Proportion,
                             CGRectGetWidth(title.frame),
                             CGRectGetHeight(title.frame));
    [self addSubview:title];
    
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setImage:[UIImage imageNamed:CMLConfirmButtonNoSelectImg] forState:UIControlStateNormal];
    [self.confirmButton sizeToFit];
    self.confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.confirmButton.frame)/2,
                                          CGRectGetHeight(self.frame) - 42 * Proportion - CGRectGetHeight(self.confirmButton.frame),
                                          CGRectGetWidth(self.confirmButton.frame),
                                          CGRectGetHeight(self.confirmButton.frame));
    NSLog(@"self.confirmButton.frame.size.height = %f", self.confirmButton.frame.size.height);
    [self addSubview:self.confirmButton];
    self.confirmButton.tag = button.tag;
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createFristAgreementViewWithType:button];
    
}

- (void)createFristAgreementViewWithType:(UIButton *)button {
    
    NSString *thirdAgreement = @"· 首部及导言\n\
    1.欢迎您使用卡枚连会员服务!\n\
    2.本协议是您与上海丽亿商贸有限公司(本协议中可简称“卡枚连”)之间关于您使用和享受 卡枚连 APP 平台所提供的各种活动资讯和会员服务(以下简称“本服务”)所订立的协议。为 使用本服务，您应当阅读并遵守《卡枚连会员服务协议》(以下简称“本协议”)。请您务必审 慎阅读、充分理解各条款内容，除非您已阅读并接受本协议所有条款，否则您无权使用本服务， 卡枚连 APP 平台将依据以下条件和条款为您提供服务。\n\
    3.您对卡枚连服务的任何购买或接受赠与、登录或查看卡枚连 APP 等任何行为，即视为您 已阅读并同意本协议的内容。\n\
    4.如果您未满 18 周岁，请在法定监护人的陪同下阅读本协议,未成年人行使和履行本协议项 下的权利和义务视为已获得了法定监护人的认可，您在享受卡枚连会员服务时必须完全、严格遵守本服务协议条款。\n\
· 本服务内容\n\
    1. 服务说明\n\
    1.1 卡枚连会员服务涉及的产品所有权以及相关软件知识产权归卡枚连所有。所提供 的服务将按照本服务条款严格执行。卡枚连会员在享受任何单项服务时，应当受本协议的约 束。\n\
    1.2 卡枚连享有对卡枚连会员网上一切活动的监督、提示、检查的权利，如卡枚连会 员的行为违反有关法律法规或违反本协议条款的约定，卡枚连享有要求其纠正及追究其责任 等权利。\n\
    1.3 用户成为卡枚连会员时，须阅读并确认接受相关的服务条款和使用方法。卡枚连 在此声明:从未授权任何第三方单位或个人销售、转让卡枚连会员资格，任何未经授权销售卡 枚连会员的行为属于非法销售行为，卡枚连有权追究其法律责任。\n\
    2. 服务内容\n\
    2.1 本服务按黛色、金色等会员等级为会员提供相应的服务，卡枚连针对不同等级的会员分别收取不同的会员服务费用，各类会员亦有权享受规格不同的会员服务。您申请的服务类 型为:黛色会员五年卡，需一次性向卡枚连支付相应会员服务费，共计为人民币 38000 元。 （大写人民币:叁万捌仟元整)。会员支付会员服务费后，卡枚连即开通所有会员服务，因此所 有会员费用一经收取将不予退还。\n\
    2.2 卡枚连黛色会员年卡使用期限为:会员缴纳会费之日起的五年内(按365天*5计算)。 如到期不续费或升级会员卡，则黛色会员将自动降为粉色会员。\n\
    2.3 成为卡枚连会员后，卡枚连会员有权利不接受服务，但不具有要求退还卡枚连会员 服务费的权利。\n\
    2.4 卡枚连会员有权基于自身业务发展需要变更会员标准，卡枚连将给予升级会员方 面的不同资费优惠，具体优惠政策以双方协商为准。\n\
    2.5 卡枚连仅提供相关的 APP 服务，其它与相关网络服务有关的设备(如个人电脑、 手机、及其他与接入互联网或移动网有关的装置)添置、享受网络服务所需的费用(如为接入 互联网而支付的电话费及上网费、为使用移动网而支付的手机费)、以及参加线下活动所需 要各类费用等均应由卡枚连会员自行负担。\n\
    2.6 卡枚连会员在享受卡枚连服务的过程中有义务承担自有财物的保管责任，并自 行负责自身的生命健康安全事宜等。\n\
· 卡枚连会员权限及服务限制\n\
    1. 卡枚连会员可享5年40次黛色专属活动，无限次优先参加粉色活动，享受卡枚连合作 品牌的独家折扣，有权享受卡枚连组织的线下活动服务(具体不同等级会员的服务内容见 附件)。2. 您在购买卡枚连会员后可享受的全部权益以官方网站公布的会员权益为准，卡枚连有 权基于自身业务发展需要变更全部或部分会员权益。就前述权益调整将在相应服务页面进行 通知或公告。\n\
    3. 卡枚连会员服务仅限于申请账号自行使用，禁止将会员服务赠与、借用、租用、转让 或售卖，一旦发现上述禁止行为，卡枚连有权在未经通知的情况下取消转让账户、受让账户 的卡枚连会员服务资格，由此带来的损失由卡枚连会员自行承担。\n\
    4. 若卡枚连会员的行为持续违反本协议或违反国家相关法律法规，或者卡枚连有合理的 理由认为卡枚连会员行为有损他人的声誉及利益，卡枚连有权取消该卡枚连的会员资格而无 须给予任何补偿。\n\
    5. 卡枚连会员不得以盗窃、利用系统漏洞等非法途径以及在未获授权的非法销售卡枚连 会员的网站上获取或购买卡枚连会员服务，否则有权取消卡枚连会员的服务资格。有此引发 的问题由卡枚连会员自行承担，不负任何责任。\n\
    6. 任何卡枚连会员不得使用带有非法、淫秽、污辱或人身攻击的含义污辱或人身攻击的昵称，一经发现，有权取消其卡枚连会员资格而无需给予任何补偿和退费。被取消卡枚连 会员资格的卡枚连会员，不能再参加由卡枚连组织的活动、并不可再享有由卡枚连提供的 各项优惠及服务，即不再享有卡枚连会员权利。\n\
    7. 卡枚连会员不得利用卡枚连的名义违法乱纪，否则因此导致的一切责任和后果均由卡 枚连会员处理并承担，因此给卡枚连造成的经济损失由卡枚连会员负责赔偿。\n\
    8. 卡枚连会员明确了解并同意，基于第三方会员或卡枚连合作商的各类行为或各类活动 等所造成的各类损失(包括但不限于利润、信誉、应用、数据损失或其他无形损失)，卡枚 连不承担任何直接、间接、特别、衍生性或惩罚性赔偿责任。\n\
    9. 卡枚连对于任何第三方提供的产品或服务质量、经营合法性等不承担任何责任，因此 所产生的所有法律责任及后果(包括但不限于客户的投诉、客户的各类损失、客户的人身权 利、行政机关的各类行政处罚等)均由第三方自行处理和承担。\n\
    10. 卡枚连对于任何第三方提供的产品价格不承担任何责任，具体服务和价格以会员消 费时第三方的公示为准，最终解释权归第三方。\n\
    11. 卡枚连会员在使用所提供的服务时，如遭受任何人身或财务的损失、损害或伤害， 不论原因如何，卡枚连均不负责任。由于卡枚连会员的个人密码泄露或与他人共享注册帐户， 由 此导致的任何个人资料泄露，卡枚连不负任何责任。\n\
· 服务的中断和终止\n\
    1. 因发生不可抗拒的事由，导致卡枚连会员服务无法正常开展的，卡枚连会及时通知卡 枚连会员，但不承担由此对卡枚连会员造成的任何损失并不退还卡枚连会员服务费。\n\
    2. 卡枚连有权根据具体情况的变化及公司发展的需要对本协议中的部分内容或者会员的 各项权益等进行调整和修改，卡枚连会员如果不同意条款的修改，可主动向提出终止卡枚连 会员服务，但不退还已支付的会员服务费用;如果卡枚连会员继续享用卡枚连会员服务，则视 为卡枚连会员已经接受条款的修改。\n\
    3. 如卡枚连会员违反或被视为违反本服务条款中的内容，卡枚连有权在不通知卡枚连会 员的情况下立即终止其已购买的所有服务，以及取消其卡枚连会员账户和使用权限，但不退 还任何已缴纳的卡枚连会员服务费用。\n\
    4. 卡枚连未行使或延迟行使其在本协议项下的权利并不构成对上述权利的放弃，而单一 或部分行使本协议项下的任何权利并不排斥其任何其它权利的行使。卡枚连随时有权要求卡 枚连会员继续履行义务并承担相应的违约责任。\n\
· 法律的适用和管辖\n\
    1.本服务条款的生效、履行、解释及争议的解决均适用中华人民共和国法律，本服务部分条 款因与中华人民共和国现行法律相抵触而导致该部分无效的，不影响其他部分的效力。双方仍 需继续履行有效条款。\n\
    2.如就本协议内容或其执行发生任何争议，应尽量友好协商解决；协商不成时，则争议各方 一致同意均可向本公司所在地的上海市徐汇区人民法院提起诉讼。\n\
· 其他\n\
    1. 协议有效期:从卡枚连会员受本协议约束或使用卡枚连 APP 平台起至注销卡枚连会员 APP 个人账户信息之日止。\n\
    2. 使用卡枚连 APP 平台即表示接受卡枚连 APP 平台服务协议及其所有附件。\n\
    3. 本协议的最终解释权归卡枚连所有。\n\
    \n\
                            上海丽亿商贸有限公司\n\
    \n\
    以上信息已全部阅读并同意接受本协议提供的服务与约束!";
    
    NSString *secondAgreement = @"· 首部及导言\n\
    1. 欢迎您使用卡枚连会员服务!\n\
    2.本协议是您与上海丽亿商贸有限公司(本协议中可简称“卡枚连”)之间关于您使用和享受 卡枚连 APP 平台所提供的各种活动资讯和会员服务(以下简称“本服务”)所订立的协议。为 使用本服务，您应当阅读并遵守《卡枚连会员服务协议》(以下简称“本协议”)。请您务必审 慎阅读、充分理解各条款内容，除非您已阅读并接受本协议所有条款，否则您无权使用本服务， 卡枚连 APP 平台将依据以下条件和条款为您提供服务。\n\
    3.您对卡枚连服务的任何购买或接受赠与、登录或查看卡枚连 APP 等任何行为，即视为您 已阅读并同意本协议的内容。\n\
    4 如果您未满 18 周岁，请在法定监护人的陪同下阅读本协议,未成年人行使和履行本协议项 下的权利和义务视为已获得了法定监护人的认可，您在享受卡枚连会员服务时必须完全、严格遵守本服务协议条款。\n\
· 本服务内容\n\
    1. 服务说明\n\
    1.1 卡枚连会员服务涉及的产品所有权以及相关软件知识产权归卡枚连所有。所提供的服务将按照本服务条款严格执行。卡枚连会员在享受任何单项服务时，应当受本协议的约束。\n\
    1.2 卡枚连享有对卡枚连会员网上一切活动的监督、提示、检查的权利，如卡枚连会员的行为违反有关法律法规或违反本协议条款的约定，卡枚连享有要求其纠正及追究其责任等权利。\n\
    1.3 用户成为卡枚连会员时，须阅读并确认接受相关的服务条款和使用方法。卡枚连在此声明:从未授权任何第三方单位或个人销售、转让卡枚连会员资格，任何未经授权销售卡枚连会员的行为属于非法销售行为，卡枚连有权追究其法律责任。\n\
    2. 服务内容\n\
    2.1 本服务按黛色、金色等会员等级为会员提供相应的服务，卡枚连针对不同等级的会员分别收取不同的会员服务费用，各类会员亦有权享受规格不同的会员服务。您申请的服务类型为:黛色会员年卡，需一次性向卡枚连支付相应会员服务费，共计为人民币 9800 元(大写人民币:玖仟捌佰元整)。因会员支付会员服务费后，卡枚连即开通所有会员服务，因此所有会员费用一经收取将不予退还。\n\
    2.1 卡枚连黛色会员年卡使用期限为:会员缴纳会费之日起的一年内(按365天计算)。 如到期不续费或升级会员卡，则黛色会员年卡将自动降为粉色会员。\n\
    2.2 黛色会员体验卡:使用期限为缴费之日起三个月内(按90天计算)。会员缴费之日起，卡枚连即为体验卡会员开通为期三个月的会员服务，因此体验卡费用一经收取，不予退还。在体验卡到期前，会员可选择补足黛色会员卡年卡的费用，即可自动升 级为黛色会员年卡，享受年卡所有服务。\n\
    2.3 卡枚连会员账号所有权归卡枚连所有，卡枚连会员拥有账号的有限使用权。 \n\
    2.4 成为卡枚连会员后，卡枚连会员有权利不接受服务，但不具有要求退还卡枚连会员服务费的权利。\n\
    2.5 卡枚连会员有权基于自身业务发展需要变更会员标准，卡枚连将给予升级会员方 面的不同资费优惠，具体优惠政策以双方协商为准。\n\
    2.6 卡枚连仅提供相关的 APP 服务，其它与相关网络服务有关的设备(如个人电脑、手机、及其他与接入互联网或移动网有关的装置)添置、享受网络服务所需的费用(如为接 入互联网而支付的电话费及上网费、为使用移动网而支付的手机费)、以及参加线下活动所 需要各类费用等均应由卡枚连会员自行负担。\n\
    2.7 卡枚连会员在享受卡枚连服务的过程中有义务承担自有财物的保管责任，并自行 负责自身的生命健康安全事宜等。\n\
· 卡枚连会员权限及服务限制\n\
    1. 卡枚连会员可享1年8次黛色专属活动，无限次优先参加粉色活动，享受卡枚连合作品牌的独家折扣，有权享受卡枚连组织的线下活动服务(具体不同等级会员的服务内容见附件)。\n\
    2. 您在购买卡枚连会员后可享受的全部权益以官方网站公布的会员权益为准，卡枚连有权基于自身业务发展需要变更全部或部分会员权益。就前述权益调整将在相应服务页面进行通知或公告。\n\
    3. 卡枚连会员服务仅限于申请账号自行使用，禁止将会员服务赠与、借用、租用、转让或售卖，一旦发现上述禁止行为，卡枚连有权在未经通知的情况下取消转让账户、受让账户的卡枚连会员服务资格，由此带来的损失由卡枚连会员自行承担。\n\
    4. 若卡枚连会员的行为持续违反本协议或违反国家相关法律法规，或者卡枚连有合理的理由认为卡枚连会员行为有损他人的声誉及利益，卡枚连有权取消该卡枚连的会员资格而无须给予任何补偿。\n\
    5. 卡枚连会员不得以盗窃、利用系统漏洞等非法途径以及在未获授权的非法销售卡枚连会员的网站上获取或购买卡枚连会员服务，否则有权取消卡枚连会员的服务资格。有此引发的问题由卡枚连会员自行承担，不负任何责任。\n\
    6. 任何卡枚连会员不得使用带有非法、淫秽、污辱或人身攻击的含义污辱或人身攻击的昵称，一经发现，有权取消其卡枚连会员资格而无需给予任何补偿和退费。被取消卡枚连会员资格的卡枚连会员，不能再参加由卡枚连组织的活动、并不可再享有由卡枚连提供的各项优惠及服务，即不再享有卡枚连会员权利。\n\
    7. 卡枚连会员不得利用卡枚连的名义违法乱纪，否则因此导致的一切责任和后果均由卡枚连会员处理并承担，因此给卡枚连造成的经济损失由卡枚连会员负责赔偿。\n\
    8. 卡枚连会员明确了解并同意，基于第三方会员或卡枚连合作商的各类行为或各类活动等所造成的各类损失(包括但不限于利润、信誉、应用、数据损失或其他无形损失)，卡枚 连不承担任何直接、间接、特别、衍生性或惩罚性赔偿责任。\n\
    9. 卡枚连对于任何第三方提供的产品或服务质量、经营合法性等不承担任何责任，因此所产生的所有法律责任及后果(包括但不限于客户的投诉、客户的各类损失、客户的人身权 利、行政机关的各类行政处罚等)均由第三方自行处理和承担。\n\
    10. 卡枚连对于任何第三方提供的产品价格不承担任何责任，具体服务和价格以会员消费 时第三方的公示为准，最终解释权归第三方。\n\
    11. 卡枚连会员在使用所提供的服务时，如遭受任何人身或财务的损失、损害或伤害， 不论原因如何，卡枚连均不负责任。由于卡枚连会员的个人密码泄露或与他人共享注册帐户， 由 此导致的任何个人资料泄露，卡枚连不负任何责任。\n\
· 服务的中断和终止\n\
    1. 因发生不可抗拒的事由，导致卡枚连会员服务无法正常开展的，卡枚连会及时通知卡 枚连会员，但不承担由此对卡枚连会员造成的任何损失并不退还卡枚连会员服务费。\n\
    2. 卡枚连有权根据具体情况的变化及公司发展的需要对本协议中的部分内容或者会员的 各项权益等进行调整和修改，卡枚连会员如果不同意条款的修改，可主动向提出终止卡枚连 会员服务，但不退还已支付的会员服务费用;如果卡枚连会员继续享用卡枚连会员服务，则视 为卡枚连会员已经接受条款的修改。\n\
    3. 如卡枚连会员违反或被视为违反本服务条款中的内容，卡枚连有权在不通知卡枚连会 员的情况下立即终止其已购买的所有服务，以及取消其卡枚连会员账户和使用权限，但不退 还任何已缴纳的卡枚连会员服务费用。\n\
    4. 卡枚连未行使或延迟行使其在本协议项下的权利并不构成对上述权利的放弃，而单一 或部分行使本协议项下的任何权利并不排斥其任何其它权利的行使。卡枚连随时有权要求卡 枚连会员继续履行义务并承担相应的违约责任。\n\
· 法律的适用和管辖\n\
    1. 本服务条款的生效、履行、解释及争议的解决均适用中华人民共和国法律，本服务部 分条款因与中华人民共和国现行法律相抵触而导致该部分无效的，不影响其他部分的效力。双 方仍需继续履行有效条款。\n\
    2. 如就本协议内容或其执行发生任何争议，应尽量友好协商解决;协商不成时，则争议 各方一致同意均可向本公司所在地的上海市徐汇区人民法院提起诉讼。\n\
· 其他\n\
    1. 协议有效期:从卡枚连会员受本协议约束或使用卡枚连 APP 平台起至注销卡枚连会员 APP 个人账户信息之日止。\n\
    2. 使用卡枚连 APP 平台即表示接受卡枚连 APP 平台服务协议及其所有附件。\n\
    3. 本协议的最终解释权归卡枚连所有。\n\
    \n\
                        上海丽亿商贸有限公司\n\
    \n\
    以上信息已全部阅读并同意接受本协议提供的服务与约束!";
    
    NSString *firstAgreement = @"卡枚连会员服务协议\n\
    \n\
    1.欢迎您使用卡枚连会员服务！\n\
    2.本协议是您与上海丽亿商贸有限公司（本协议中可简称“卡枚连”）之间关于您使用和享受卡枚连 APP 平台所提供的各种活动资讯和会员服务（以下简称“本服务”）所订立的协议。为使用本服务，您应当阅读并遵守《卡枚连会员服务协议》（以下简称“本协议” ）。请您务必审慎阅读、充分理解各条款内容，除非您已阅读并接受本协议所有条款，否则您无权使用本服务，卡枚连 APP 平台将依据以下条件和条款为您提供服务。\n\
    3.您对卡枚连服务的任何购买或接受赠与、登录或查看卡枚连 APP 等任何行为，即视为您已阅读并同意本协议的内容。\n\
    4.如果您未满18周岁，请在法定监护人的陪同下阅读本协议,未成年人行使和履行本协议项下的权利和义务视为已获得了法定监护人的认可，您在享受卡枚连会员服务时必须完全、严格遵守本服务协议条款。\n\
    \n\
    【本服务内容】\n\
    1.服务说明\n\
    1.1卡枚连会员服务涉及的产品所有权以及相关软件知识产权归卡枚连所有。所提供的服务将按照本服务条款严格执行。卡枚连会员在享受任何单项服务时，应当受本协议的约束。\n\
    1.2卡枚连享有对卡枚连会员网上一切活动的监督、提示、检查的权利，如卡枚连会员的行为违反有关法律法规或违反本协议条款的约定，卡枚连享有要求其纠正及追究其责任等权利。\n\
    1.3用户成为卡枚连会员时，须阅读并确认接受相关的服务条款和使用方法。卡枚连在此声明：从未授权任何第三方单位或个人销售、转让卡枚连会员资格，任何未经授权销售卡枚连会员的行为属于非法销售行为，卡枚连有权追究其法律责任。\n\
    2.服务内容\n\
    2.1本服务按粉金、黛色、金色等会员等级为会员提供相应的服务，卡枚连针对不同等级的会员分别收取不同的会员服务费用，各类会员亦有权享受规格不同的会员服务。您申请的服务类型为： 粉金会员年卡需一次性向卡枚连支付相应会员服务费，共计为人民币 500元（大写人民币：伍佰元整）。因会员支付会员服务费后，卡枚连即开通所有会员服务，因此\n\
    所有会员费用一经收取将不予退还。\n\
    2.1卡枚连粉金会员年卡使用期限为：会员缴纳会费之日起的一年内（按365天计算）。如到期\n\
    不续费或升级会员卡，则粉金会员年卡将自动降为粉色会员。\n\
    2.2收款方式：银行转账/微信/支付宝均认可，缴纳会费后升级账户\n\
    收款信息：\n\
    公司名称：上海丽亿商贸有限公司  91 310 104 3208 91770 H\n\
    开户行及账号：中国银行上海宜山路支行4416 6785 8776\n\
    2.3卡枚连会员账号所有权归卡枚连所有，卡枚连会员拥有账号的有限使用权。\n\
    2.4成为卡枚连会员后，卡枚连会员有权利不接受服务，但不具有要求退还卡枚连会员服务费的权利。\n\
    2.5卡枚连会员有权基于自身业务发展需要变更会员标准，卡枚连将给予升级会员方面的不同资费优惠，具体优惠政策以双方协商为准。\n\
    2.6卡枚连仅提供相关的 APP 服务，其它与相关网络服务有关的设备（如个人电脑、手机、及其他与接入互联网或移动网有关的装置）添置、享受网络服务所需的费用（如为接入互联网而支付的电话费及上网费、为使用移动网而支付的手机费）、以及参加线下活动所需要各类费用等均应由卡枚连会员自行负担。\n\
    2.7卡枚连会员在享受卡枚连服务的过程中有义务承担自有财物的保管责任，并自行负责自身的生命健康安全事宜等。\n\
    \n\
    【卡枚连粉金会员权限及服务限制】\n\
    1.卡枚连粉金会员可享卡枚连商城奢侈品5折起折扣价，无限次优先参加粉色活动，享受分享链接返利服务，独享300元抵用券，有权享受一次卡枚连组织的官方活动服务（具体不同等级会员的服务内容见附件）。\n\
    2.您在购买卡枚连会员后可享受的全部权益以官方网站公布的会员权益为准，卡枚连有权基于自身业务发展需要变更全部或部分会员权益。就前述权益调整将在相应服务页面进行通知或公告。\n\
    3.卡枚连会员服务仅限于申请账号自行使用，禁止将会员服务赠与、借用、租用、转让或售卖，一旦发现上述禁止行为，卡枚连有权在未经通知的情况下取消转让账户、受让账户的卡枚连会员服务资格，由此带来的损失由卡枚连会员自行承担。\n\
    4.若卡枚连会员的行为持续违反本协议或违反国家相关法律法规，或者卡枚连有合理的理由认为卡枚连会员行为有损他人的声誉及利益，卡枚连有权取消该卡枚连的会员资格而无须给予任何补偿。\n\
    5.卡枚连会员不得以盗窃、利用系统漏洞等非法途径以及在未获授权的非法销售卡枚连会员的网站上获取或购买卡枚连会员服务，否则有权取消卡枚连会员的服务资格。有此引发的问题由卡枚连会员自行承担，不负任何责任。\n\
    6.任何卡枚连会员不得使用带有非法、淫秽、污辱或人身攻击的含义污辱或人身攻击的呢称，一经发现，有权取消其卡枚连会员资格而无需给予任何补偿和退费。被取消卡枚连会员资格的卡枚连会员，不能再参加由卡枚连组织的活动、并不可再享有由卡枚连提供的各项优惠及服务，即不再享有卡枚连会员权利。\n\
    7.卡枚连会员不得利用卡枚连的名义违法乱纪，否则因此导致的一切责任和后果均由卡枚连会员处理并承担，因此给卡枚连造成的经济损失由卡枚连会员负责赔偿。\n\
    8.卡枚连会员明确了解并同意，基于第三方会员或卡枚连合作商的各类行为或各类活动等所造成的各类损失（包括但不限于利润、信誉、应用、数据损失或其他无形损失），卡枚连不承担任何直接、间接、特别、衍生性或惩罚性赔偿责任。\n\
    9.卡枚连对于任何第三方提供的产品或服务质量、经营合法性等不承担任何责任，因此所产生的所有法律责任及后果（包括但不限于客户的投诉、客户的各类损失、客户的人身权利、行政机关的各类行政处罚等）均由第三方自行处理和承担。\n\
    10.卡枚连对于任何第三方提供的产品价格不承担任何责任，具体服务和价格以会员消费时第三方的公示为准，最终解释权归第三方。\n\
    11.卡枚连会员在使用所提供的服务时，如遭受任何人身或财务的损失、损害或伤害， 不论原因如何，卡枚连均不负责任。由于卡枚连会员的个人密码泄露或与他人共享注册帐户， 由此导致的任何个人资料泄露，卡枚连不负任何责任。\n\
    \n\
    【服务的中断和终止】\n\
    1.因发生不可抗拒的事由，导致卡枚连会员服务无法正常开展的，卡枚连会及时通知卡枚连会员，但不承担由此对卡枚连会员造成的任何损失并不退还卡枚连会员服务费。\n\
    2.卡枚连有权根据具体情况的变化及公司发展的需要对本协议中的部分内容或者会员的各项权益等进行调整和修改，卡枚连会员如果不同意条款的修改，可主动向提出终止卡枚连会员服务，但不退还已支付的会员服务费用；如果卡枚连会员继续享用卡枚连会员服务，则视为卡枚连会员已经接受条款的修改。\n\
    3.如卡枚连会员违反或被视为违反本服务条款中的内容，卡枚连有权在不通知卡枚连会员的情况下立即终止其已购买的所有服务，以及取消其卡枚连会员账户和使用权限，但不退还任何已缴纳的卡枚连会员服务费用。\n\
    4.卡枚连未行使或延迟行使其在本协议项下的权利并不构成对上述权利的放弃，而单一或部分行使本协议项下的任何权利并不排斥其任何其它权利的行使。卡枚连随时有权要求卡枚连会员继续履行义务并承担相应的违约责任。\n\
    \n\
    【法律的适用和管辖】\n\
    1.本服务条款的生效、履行、解释及争议的解决均适用中华人民共和国法律，本服务部分条款因与中华人民共和国现行法律相抵触而导致该部分无效的，不影响其他部分的效力。双方仍需继续履行有效条款。\n\
    2.如就本协议内容或其执行发生任何争议，应尽量友好协商解决；协商不成时，则争议各方一致同意均可向本公司所在地的上海市徐汇区人民法院提起诉讼。\n\
    \n\
    【其他】\n\
    1.协议有效期：从卡枚连会员受本协议约束或使用卡枚连 APP 平台起至注销卡枚连会员\n\
    APP 个人账户信息之日止。\n\
    2.使用卡枚连 APP 平台即表示接受卡枚连 APP 平台服务协议及其所有附件。\n\
    3.本协议的最终解释权归卡枚连所有。\n\
    \n\
    \n\
    上海丽亿商贸有限公司\n\
    \n\
    以上信息已全部阅读并同意接受本协议提供的服务与约束！";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(48 * Proportion,
                                                                         134 * Proportion,
                                                                         CGRectGetWidth(self.frame) - 2 * 48 * Proportion,
                                                                         CGRectGetMinY(self.confirmButton.frame) - 80 * Proportion - 134 * Proportion)];


    textView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [textView setTextColor:[UIColor CML7B7B7BColor]];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.scrollEnabled = YES;
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.editable = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor CML7B7B7BColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSDictionary *attributes2 = @{
                                  NSBaselineOffsetAttributeName:[NSNumber numberWithInt:- 20 * Proportion],
                                 NSForegroundColorAttributeName:[UIColor CMLE5C48AColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:40 weight:UIFontWeightRegular],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    if ((int)button.tag == 3) {/*粉金*/
        self.agreementString = firstAgreement;
    }else if ((int)button.tag == 5) {
        self.agreementString = secondAgreement;
    }else if ((int)button.tag == 6) {
        self.agreementString = thirdAgreement;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.agreementString attributes:attributes];
    
    NSString *temp = nil;
    
    for(int i = 0; i < [self.agreementString length]; i++)
    {
        temp = [self.agreementString substringWithRange:NSMakeRange(i,1)];
        if ([temp isEqualToString:@"·"]) {
            
            NSRange range = NSMakeRange(i, 1);
            [attributedString addAttributes:attributes2 range:range];
            
        }
        
    }
    
    textView.attributedText = attributedString;

    [self addSubview:textView];
    
    /*勾选圈*/
    self.agreementChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreementChooseButton setImage:[UIImage imageNamed:CMLCheckButtonNoSelectImg] forState:UIControlStateNormal];
    [self.agreementChooseButton setImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
//    [self.agreementChooseButton setBackgroundImage:[UIImage imageNamed:CMLCheckButtonNoSelectImg] forState:UIControlStateNormal];
//    [self.agreementChooseButton setBackgroundImage:[UIImage imageNamed:CMLCheckButtonSelectImg] forState:UIControlStateSelected];
    [self.agreementChooseButton sizeToFit];
    
    /**/
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.text = @"点击立即升级会员表示您已经同意遵守本协议";
    introLabel.font = KSystemBoldFontSize11;
    introLabel.textColor = [UIColor CML7C7C7CColor];
    [introLabel sizeToFit];
    
    self.agreementChooseButton.frame = CGRectMake(CGRectGetMinX(textView.frame) + 24*Proportion,
                                                  CGRectGetMinY(self.confirmButton.frame) - CGRectGetHeight(self.agreementChooseButton.frame),
                                                  CGRectGetWidth(self.agreementChooseButton.frame),
                                                  CGRectGetHeight(self.agreementChooseButton.frame));
    [self addSubview:self.agreementChooseButton];
    [self.agreementChooseButton addTarget:self action:@selector(agreementChooseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    introLabel.frame = CGRectMake(CGRectGetMaxX(self.agreementChooseButton.frame) + 8*Proportion, CGRectGetMidY(self.agreementChooseButton.frame) - CGRectGetHeight(introLabel.frame)/2, CGRectGetWidth(introLabel.frame), CGRectGetHeight(introLabel.frame));
    [self addSubview:introLabel];
    
}

- (void)agreementChooseButtonClicked {
    
    if (self.isSelected) {
        self.agreementChooseButton.selected = YES;
        self.isSelected = NO;
        [self.confirmButton setImage:[UIImage imageNamed:CMLConfirmButtonSelectImg] forState:UIControlStateNormal];
    }else {
        self.agreementChooseButton.selected = NO;
        self.isSelected = YES;
        [self.confirmButton setImage:[UIImage imageNamed:CMLConfirmButtonNoSelectImg] forState:UIControlStateNormal];
    }
    
}

- (void)confirmButtonClicked:(UIButton *)button {
    
    if (self.agreementChooseButton.selected == NO) {
        return;
    }
    [self.delegate confirmAgreementWith:button];
    
}

@end
