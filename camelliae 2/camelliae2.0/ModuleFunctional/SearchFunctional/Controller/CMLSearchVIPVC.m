//
//  CMLSearchVIPVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/1/10.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLSearchVIPVC.h"
#import "VCManger.h"
#import "LoginUserObj.h"
#import "SearchVIPMemberTVCell.h"
#import "CMLVIPNewDetailVC.h"

@interface CMLSearchVIPVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation CMLSearchVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = [NSString stringWithFormat:@"“%@”会员",self.currentTitle];
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.navBar setLeftBarItem];
    self.navBar.delegate = self;
    self.navBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navBar.layer.shadowOpacity = 0.05;
    self.navBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self loadViews];
}

- (void) loadViews{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame) + 20*Proportion,
                                                                       WIDTH,
                                                                       self.contentView.frame.size.height - self.navBar.frame.size.height - 20*Proportion - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.mainTableView.rowHeight = 140*Proportion;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myCell";
    
    SearchVIPMemberTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SearchVIPMemberTVCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.dataArray.count > 0) {
        LoginUserObj *obj = [LoginUserObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.userImageUrl = obj.gravatar;
        cell.nickName = obj.nickName;
        cell.lvl = obj.memberVipGrade;
        cell.memberLvl = obj.memberLevel;
        cell.vipGrade = obj.memberPrivilegeLevel;
        cell.position = obj.title;
        [cell refreshSearchCell];
    
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    LoginUserObj *obj = [LoginUserObj getBaseObjFrom:self.dataArray[indexPath.row]];
//    CMLVIPNewDetailVC *vc = [[CMLVIPNewDetailVC alloc] initWithNickName:obj.nickName currnetUserId:obj.uid isReturnUpOneLevel:YES];
//    [[VCManger mainVC] pushVC:vc animate:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}
@end
