//
//  CommemtListViC.m
//  camelliae2.0
//
//  Created by 张越 on 16/6/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CommemtListVC.h"
#import "VCManger.h"
#import "CommentTableVCell.h"
#import "CommentObj.h"
#import "MJRefresh.h"
#import "ActivityDefaultVC.h"

#define PageSize                         20

#define CommemtListVCBottomViewHeight    77
#define CommemtListVCLeftMargin          20
#define CommemtListVCRightMargin         30
#define CommemtListVCTextInputTopMargin    40
#define CommemtListVCTextInputLeftMargin   30
#define CommemtListVCTextInputBtnTopMargin 26


@interface CommemtListVC ()<NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,UITextViewDelegate>

/**资讯，活动，服务*/
@property (nonatomic,strong) NSNumber *objType;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,assign) BOOL isActivity;

@property (nonatomic,assign) BOOL isfromActivityBanner;


@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *commentInputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIButton *pushBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int dataCount;

@end

@implementation CommemtListVC

- (instancetype)initWithObjType:(NSNumber *) objType currentID:(NSNumber *) currentId isActivity:(BOOL) isActivity isfromActivityBanner:(BOOL) isfromActivityBanner{

    self = [super init];
    if (self) {
        
        self.objType = objType;
        self.currentID = currentId;
        self.isActivity = isActivity;
        self.isfromActivityBanner = isfromActivityBanner;
    }
    return self;
}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = @"评论";
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.delegate = self;
    [self.navBar setLeftBarItem];
    self.page = 1;
    
    if (self.isfromActivityBanner) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"详情" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
        button.titleLabel.font = KSystemFontSize13;
        [button sizeToFit];
        button.frame = CGRectMake(WIDTH - 20*Proportion - button.frame.size.width - 40*Proportion,
                                  self.navBar.frame.size.height/2.0 - button.frame.size.height/2.0,
                                  button.frame.size.width + 40*Proportion,
                                  button.frame.size.height);
        button.layer.cornerRadius = 4*Proportion;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor CMLYellowColor].CGColor;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(enterActivityDetailVC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    /*************************************/
    
    [self loadViews];
    
    [self loadData];
    
}

- (void) loadData{

    [self setCommenListRequest];
    
     [self startLoading];
}

- (void) loadViews{

    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT  - self.navBar.frame.size.height)
                                                      style:UITableViewStylePlain];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    /**上拉*/
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
//    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                               CGRectGetMaxY(self.mainTableView.frame),
//                                                               WIDTH,
//                                                               CommemtListVCBottomViewHeight*Proportion)];
//    [self.contentView addSubview:self.bottomView];
//    UILabel *leftlabel = [[UILabel alloc] init];
//    leftlabel.text = @"我想说些什么";
//    leftlabel.textColor = [UIColor CMLPromptGrayColor];
//    leftlabel.font = KSystemFontSize14;
//    [leftlabel sizeToFit];
//    leftlabel.frame = CGRectMake(CommemtListVCLeftMargin*Proportion + 10*Proportion,
//                                 CommemtListVCBottomViewHeight*Proportion/2.0 - leftlabel.frame.size.height/2.0,
//                                 leftlabel.frame.size.width,
//                                 leftlabel.frame.size.height);
//    [self.bottomView addSubview:leftlabel];
//    
//    CMLLine *lineOne = [[CMLLine alloc] init];
//    lineOne.startingPoint = CGPointMake(leftlabel.frame.origin.x - 10*Proportion, leftlabel.frame.origin.y);
//    lineOne.lineWidth = 1;
//    lineOne.lineLength = leftlabel.frame.size.height;
//    lineOne.LineColor = [UIColor CMLYellowColor];
//    lineOne.directionOfLine = VerticalLine;
//    [self.bottomView addSubview:lineOne];
//    
//    
//    UILabel *rightLabel = [[UILabel alloc] init];
//    rightLabel.text = @"发送";
//    rightLabel.textColor = [UIColor CMLYellowColor];
//    rightLabel.font = KSystemFontSize14;
//    [rightLabel sizeToFit];
//    rightLabel.frame = CGRectMake(WIDTH - CommemtListVCRightMargin*Proportion - rightLabel.frame.size.width,
//                                  CommemtListVCBottomViewHeight*Proportion/2.0 - rightLabel.frame.size.height/2.0,
//                                  rightLabel.frame.size.width,
//                                  rightLabel.frame.size.height);
//    [self.bottomView addSubview:rightLabel];
//    
//    CMLLine *linetwo = [[CMLLine alloc] init];
//    linetwo.lineLength = rightLabel.frame.size.height;
//    linetwo.lineWidth = 1;
//    linetwo.startingPoint = CGPointMake(rightLabel.frame.origin.x - CommemtListVCRightMargin*Proportion, rightLabel.frame.origin.y);
//    linetwo.LineColor = [UIColor CMLLineGrayColor];
//    linetwo.directionOfLine = VerticalLine;
//    [self.bottomView addSubview:linetwo];
//    
//    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                      0,
//                                                                      WIDTH,
//                                                                      self.bottomView.frame.size.height)];
//    [commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:commentBtn];
//    
//    CMLLine *linethree = [[CMLLine alloc] init];
//    linethree.lineLength = WIDTH - CommemtListVCLeftMargin*Proportion*2;
//    linethree.lineWidth = 0.5;
//    linethree.startingPoint = CGPointMake(CommemtListVCLeftMargin*Proportion, 0);
//    linethree.LineColor = [UIColor CMLPromptGrayColor];
//    linethree.directionOfLine = HorizontalLine;
//    [commentBtn addSubview:linethree];
//    
//    /*************************************/
//    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                               0,
//                                                               WIDTH,
//                                                               HEIGHT)];
//    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    self.shadowView.alpha = 0;
//    [self.contentView addSubview:self.shadowView];
//    
//    /**输入底板*/
//    self.commentInputView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                     HEIGHT,
//                                                                     WIDTH,
//                                                                     HEIGHT/4)];
//    self.commentInputView.backgroundColor = [UIColor CMLUserGrayColor];
//    [self.contentView addSubview:self.commentInputView];
    
    

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.dataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        CommentObj *commentObj = [CommentObj getBaseObjFrom:self.dataArray[indexPath.row]];
        CommentTableVCell *cell = [[CommentTableVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.userNickName = commentObj.userNickName;
        cell.pushTime = commentObj.postTimeStr;
        cell.pushContent = commentObj.comment;
        [cell refreshCurrentCell];
        return cell.currentRowHeight;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myCell";
    CommentTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CommentTableVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count > 0) {
        CommentObj *commentObj = [CommentObj getBaseObjFrom:self.dataArray[indexPath.row]];
        CommentTableVCell *commentCell = (CommentTableVCell *)cell;
        commentCell.userImageUrl = commentObj.userHeadImg;
        commentCell.userNickName = commentObj.userNickName;
        commentCell.pushTime = commentObj.postTimeStr;
        commentCell.pushContent = commentObj.comment;
        commentCell.userId = commentObj.userId;
        commentCell.recordId = commentObj.currentID;
        commentCell.isUserLike = commentObj.isUserLike;
        commentCell.num = commentObj.likeNum;
        [commentCell refreshCurrentCell];
   
    }
}

#pragma mark - showCommentView
- (void) showCommentView{

    [self setCommentTextView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

#pragma mark - NavigationBarProtocol
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) setCommentTextView{

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                                                 CommemtListVCTextInputTopMargin*Proportion,
                                                                 WIDTH - CommemtListVCTextInputLeftMargin*Proportion*2,
                                                                 200*Proportion)];
    self.textView.font = KSystemFontSize12;
    self.textView.textColor = [UIColor CMLBlackColor];
    self.textView.backgroundColor = [UIColor CMLWhiteColor];
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    [self.commentInputView addSubview:self.textView];
    
    self.pushBtn = [[UIButton alloc] init];
    [self.pushBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.pushBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.pushBtn.titleLabel.font = KSystemFontSize14;
    [self.pushBtn addTarget:self action:@selector(pushComment) forControlEvents:UIControlEventTouchUpInside];
    [self.pushBtn sizeToFit];
    self.pushBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) - self.pushBtn.frame.size.width,
                                    CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                    self.pushBtn.frame.size.width,
                                    self.pushBtn.frame.size.height);
    [self.commentInputView addSubview:self.pushBtn];
    
    
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = KSystemFontSize14;
    [self.cancelBtn addTarget:self action:@selector(cancelComment) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn sizeToFit];
    self.cancelBtn.frame = CGRectMake(CommemtListVCTextInputLeftMargin*Proportion,
                                      CGRectGetMaxY(self.textView.frame) + CommemtListVCTextInputBtnTopMargin*Proportion,
                                      self.cancelBtn.frame.size.width,
                                      self.cancelBtn.frame.size.height);
    [self.commentInputView addSubview:self.cancelBtn];
    
    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             self.commentInputView.frame.origin.y,
                                             self.commentInputView.frame.size.width,
                                             CGRectGetMaxY(self.cancelBtn.frame) + CommemtListVCTextInputBtnTopMargin*Proportion);
    [self.textView becomeFirstResponder];
    
    
}

- (void) removeCommentTextView{

    [self.textView removeFromSuperview];
    [self.pushBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
}

#pragma mark - keyboardWasShown
- (void) keyboardWasShown:(NSNotification *) noti{


    NSDictionary *info = [noti userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    
    CGSize keyboardSize = [value CGRectValue].size;

    self.commentInputView.frame = CGRectMake(self.commentInputView.frame.origin.x,
                                             HEIGHT -  (self.commentInputView.frame.size.height + keyboardSize.height),
                                             self.commentInputView.frame.size.width,
                                             self.commentInputView.frame.size.height);
    
}

#pragma mark - keyboardWillBeHidden
- (void) keyboardWillBeHidden:(NSNotification *) noti{

    self.commentInputView.frame = CGRectMake(0,
                                             HEIGHT,
                                             self.commentInputView.frame.size.width,
                                             self.commentInputView.frame.size.height);
    [self removeCommentTextView];
}

#pragma mark - pushComment
- (void) pushComment{

    if (self.textView.text.length > 0) {
        [self setPostCommentRequest];
    }else{
        [self showFailTemporaryMes:@"请输入评论内容"];
    }
}

- (void) cancelComment{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
    }];
    
    [self removeCommentTextView];
}

#pragma mark - 评论请求设置
- (void) setCommenListRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:self.objType forKey:@"objType"];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,self.objType,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:CommentList paraDic:paraDic delegate:delegate];
    self.currentApiName = CommentList;
    
//    if ([self.objType intValue] == 1) {
//     
//        [self commentEventWithRootType:@"资讯"];
//    }else if ([self.objType intValue] == 2){
//    
//        [self commentEventWithRootType:@"活动"];
//    }else{
//    
//        [self commentEventWithRootType:@"生活"];
//    }

    
}

#pragma mark - 发送评论的请求设置
- (void) setPostCommentRequest{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.currentID forKey:@"objId"];
    [paraDic setObject:self.objType forKey:@"objType"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:self.textView.text forKey:@"comment"];
    NSString *commentHash = [[NSString stringWithFormat:@"%@%@%@",self.textView.text,skey,reqTime] md5];
    [paraDic setObject:commentHash forKey:@"commentHash"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,self.objType,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:CommentPost paraDic:paraDic delegate:delegate];
    self.currentApiName = CommentPost;
    
    [self startIndicatorLoading];
    
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    if ([self.currentApiName isEqualToString:CommentList]) {
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];


        
        if ([obj.retCode intValue] == 0 && obj) {
            self.dataCount = [obj.retData.dataCount intValue];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
            }else{
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            [self.mainTableView reloadData];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{

            if (self.page > 1) {
                self.page -- ;
            }
        }
        
        /********/
        if ([obj.retCode intValue] == 200201 && obj) {
            self.mainTableView.tableFooterView = [self setCurrentFooterView];
            self.mainTableView.bounces = NO;
            self.mainTableView.bouncesZoom = NO;
        }else{
            self.mainTableView.bouncesZoom = YES;
            self.mainTableView.bounces = YES;
            self.mainTableView.tableFooterView = [[UIView alloc] init];
        }
        /************/
        /***********/
        [self removeCommentTextView];
        [UIView animateWithDuration:0.25 animations:^{
            self.shadowView.alpha = 0;
        }];
        
    }else if ([self.currentApiName isEqualToString:CommentPost]){
    
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0 && obj) {
            
            [self setCommenListRequest];
        }else if ([obj.retCode intValue] == 100101){
            
            [self stopLoading];
            [self showReloadView];
            
        }else{
            [self showFailTemporaryMes:@"发表失败"];
        }
    }
    
    /*****/
    [self.mainTableView.mj_footer endRefreshing];
    [self stopIndicatorLoading];
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    [self showFailTemporaryMes:@"网络链接失败"];
    if (self.page > 1) {
        self.page -- ;
    }
    
    /*****/
    [self.mainTableView.mj_footer endRefreshing];
    [self stopIndicatorLoading];
    [self stopLoading];
}



#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{

    if (self.textView.text.length > 0) {
        [self.pushBtn setTitleColor:[UIColor CMLYellowColor] forState:UIControlStateNormal];
    }else{
        [self.pushBtn setTitleColor:[UIColor CMLtextInputGrayColor] forState:UIControlStateNormal];
    }
    

}

#pragma mark - 设置footerView
- (UIView *) setCurrentFooterView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            WIDTH,
                                                            self.mainTableView.frame.size.height)];
    view.backgroundColor = [UIColor CMLUserGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NOCommentImg]];
    [imageView sizeToFit];
    imageView.frame = CGRectMake(view.frame.size.width/2.0 - imageView.frame.size.width/2.0,
                                 view.frame.size.height/2.0 - imageView.frame.size.height/2.0,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = KSystemFontSize14;
    label.text = @"做第一个发言的人";
    label.textColor = [UIColor CMLUserBlackColor];
    [label sizeToFit];
    label.frame = CGRectMake(view.frame.size.width/2.0 - label.frame.size.width/2.0,
                             CGRectGetMaxY(imageView.frame) + 40*Proportion,
                             label.frame.size.width,
                             label.frame.size.height);
    [view addSubview:label];
    
    return view;
}

- (void) loadMoreData{

    if (self.dataArray.count < self.dataCount) {
        
        if (self.dataArray.count%PageSize == 0) {
            
            self.page++;
            
            [self setCommenListRequest];
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void) scrollViewScrollToTop{

    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - enterActivityDetailVC
- (void) enterActivityDetailVC{

    /**活动详情*/
    ActivityDefaultVC *vc = [[ActivityDefaultVC alloc] initWithObjId:self.currentID];
    [[VCManger mainVC] pushVC:vc animate:YES];
}
@end
