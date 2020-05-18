//
//  CMLUserTopicVC.m
//  camelliae2.0
//
//  Created by 张越 on 2017/10/31.
//  Copyright © 2017年 张越. All rights reserved.
//

#import "CMLUserTopicVC.h"
#import "VCManger.h"
#import "CMLNewVipUseTimeLineTVCell.h"
#import "MJRefresh.h"
#import "CMLWriteVC.h"
#import "CMLTimeLineDetailMessageVC.h"

#define PageSize 10

@interface CMLUserTopicVC ()<NetWorkProtocol,NavigationBarProtocol,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WriteDelegate>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *heightDic;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UIWebView *detailView;

@property (nonatomic,strong) UIView *TableViewheaderViewbgView;

@property (nonatomic,strong) UILabel *numLab;

@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation CMLUserTopicVC

- (instancetype)initWithObj:(NSNumber *) objID{
    
    self = [super init];
    
    if (self) {
        
        self.currentID = objID;
     
    }
    
    return self;
}


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDic{
    
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    
    return _heightDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.titleColor = [UIColor CMLBlackColor];
    self.navBar.delegate = self;
    self.navBar.backgroundColor = [UIColor CMLWhiteColor];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor CMLBlackColor];
    self.titleLab.backgroundColor = [UIColor CMLWhiteColor];
    self.titleLab.font = KSystemBoldFontSize17;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    
    [self.navBar addSubview:self.titleLab];
    [self.navBar setLeftBarItem];
    self.page = 1;
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - NavigationBarHeight,
                                                                    StatusBarHeight,
                                                                    NavigationBarHeight,
                                                                    NavigationBarHeight)];
    [shareBtn setImage:[UIImage imageNamed:DetailMessageShareImg] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor whiteColor];
    [self.navBar addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(showDetailShareMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadViews];
    
    [self setTopicDetailRequest];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
}

- (void) loadViews{

    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       WIDTH,
                                                                       HEIGHT - self.navBar.frame.size.height - 80*Proportion - SafeAreaBottomHeight)
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor CMLWhiteColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)){
        self.mainTableView.estimatedRowHeight = 0;
        self.mainTableView.estimatedSectionHeaderHeight = 0;
        self.mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:self.mainTableView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullRefreshOfHeader)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableView.mj_header = header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreData)];
    
    
    UIButton *wirtebtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    HEIGHT - 80*Proportion - SafeAreaBottomHeight,
                                                                    WIDTH,
                                                                    80*Proportion)];
    wirtebtn.titleLabel.font = KSystemRealBoldFontSize15;
    [wirtebtn setTitle:@"我要参与" forState:UIControlStateNormal];
    [wirtebtn setTitleColor:[UIColor CMLWhiteColor] forState:UIControlStateNormal];
    wirtebtn.backgroundColor = [UIColor CMLGreeenColor];
    [self.contentView addSubview:wirtebtn];
    [wirtebtn addTarget:self action:@selector(enterWriteVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) loadTableViewHeaderView{
    
    self.TableViewheaderViewbgView = [[UIView alloc] init];
    self.TableViewheaderViewbgView.backgroundColor = [UIColor CMLWhiteColor];
    
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          WIDTH,
                                                                          360*Proportion)];
    topImage.contentMode = UIViewContentModeScaleAspectFill;
    topImage.clipsToBounds = YES;
    [NetWorkTask setImageView:topImage WithURL:self.obj.retData.coverPic placeholderImage:nil];
    [self.TableViewheaderViewbgView addSubview:topImage];
    
    self.detailView = [[UIWebView alloc] init];
    
    self.detailView.delegate = self;
    self.detailView.frame = CGRectMake(0,
                                       CGRectGetMaxY(topImage.frame) + 50*Proportion,
                                       WIDTH,
                                       400);
    self.detailView.scrollView.scrollEnabled = NO;
    [self.detailView loadHTMLString:self.obj.retData.content baseURL:nil];
    [self.TableViewheaderViewbgView addSubview:self.detailView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",WIDTH - 20*Proportion*2];
    
    //添加JS
    [self.detailView stringByEvaluatingJavaScriptFromString:script];
    
    //添加调用JS执行的语句
    [self.detailView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.fontSize= '13px'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str];
    
    
    NSString *str2 = @"document.getElementsByTagName('body')[0].style.color='#333333'";
    [self.detailView stringByEvaluatingJavaScriptFromString:str2];
    CGFloat height = [[self.detailView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.detailView.frame = CGRectMake(webView.frame.origin.x,
                                       webView.frame.origin.y,
                                       WIDTH,
                                       height);
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.detailView.frame),
                                                                 WIDTH,
                                                                 20*Proportion)];
    spaceView.backgroundColor = [UIColor CMLNewGrayColor];
    [self.TableViewheaderViewbgView addSubview:spaceView];
    
    UIView *commentNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(spaceView.frame),
                                                                        WIDTH,
                                                                        86*Proportion)];
    commentNumBgView.backgroundColor = [UIColor CMLWhiteColor];
    [self.TableViewheaderViewbgView addSubview:commentNumBgView];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.text = [NSString stringWithFormat:@"参与动态（%@）",self.dataCount];
    self.numLab.font = KSystemFontSize13;
    [self.numLab sizeToFit];
    self.numLab.frame = CGRectMake(20*Proportion,
                                   86*Proportion/2.0 - self.numLab.frame.size.height/2.0,
                                   self.numLab.frame.size.width,
                                   self.numLab.frame.size.height);
    [commentNumBgView addSubview:self.numLab];
    
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.lineWidth = 1;
    bottomLine.startingPoint =CGPointMake(0, CGRectGetHeight(commentNumBgView.frame) - 1);
    bottomLine.lineLength = WIDTH;
    bottomLine.LineColor = [UIColor CMLNewGrayColor];
    [commentNumBgView addSubview:bottomLine];
    
    
    self.TableViewheaderViewbgView.frame = CGRectMake(0,
                                                      0,
                                                      WIDTH,
                                                      CGRectGetMaxY(commentNumBgView.frame));
    
    self.mainTableView.tableHeaderView = self.TableViewheaderViewbgView;
    
    if (self.dataArray.count == 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  WIDTH,
                                                                  100*Proportion)];
        UILabel *showlab = [[UILabel alloc] initWithFrame:bgView.bounds];
        showlab.text = @"暂无评论";
        showlab.textColor = [UIColor CMLtextInputGrayColor];
        showlab.font = KSystemFontSize13;
        showlab.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:showlab];
        self.mainTableView.tableFooterView = bgView;
    }
    
     [self stopLoading];
}


- (void) setTopicDetailRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.currentID forKey:@"objId"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:TopicDetailMessage param:paraDic delegate:delegate];
    self.currentApiName = TopicDetailMessage;
    [self startLoading];
    
}

- (void) setCommentListRequest{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:self.currentID forKey:@"themeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey,self.currentID]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask getRequestWithApiName:CommentListByTopicDetail param:paraDic delegate:delegate];
    self.currentApiName = CommentListByTopicDetail;
}


#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:TopicDetailMessage]) {
        
        self.obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([self.obj.retCode intValue] == 0) {
            
            [NSThread detachNewThreadSelector:@selector(setActivityShareMes) toTarget:self withObject:nil];
            
            [self loadTableViewHeaderView];
            
            [self setCommentListRequest];
            
        }else{
            
            [self showFailTemporaryMes:self.obj.retMsg];
            [self stopLoading];
        }
        
    }else if ([self.currentApiName isEqualToString:CommentListByTopicDetail]){
        
        BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        if ([obj.retCode intValue] == 0) {
            
            
            self.dataCount = obj.retData.dataCount;
            self.titleLab.text = [NSString stringWithFormat:@"%@人参与话题",self.dataCount];
            [self.titleLab sizeToFit];
            self.titleLab.frame = CGRectMake(WIDTH/2.0 - self.titleLab.frame.size.width/2.0,
                                             StatusBarHeight + NavigationBarHeight/2.0 - self.titleLab.frame.size.height/2.0,
                                             self.titleLab.frame.size.width,
                                             self.titleLab.frame.size.height);
            
            if (self.page == 1) {
                
                /***************/
                self.numLab.text = [NSString stringWithFormat:@"参与动态（%@）",self.dataCount];
                [self.numLab sizeToFit];
                self.numLab.frame = CGRectMake(20*Proportion,
                                               86*Proportion/2.0 - self.numLab.frame.size.height/2.0,
                                               self.numLab.frame.size.width,
                                               self.numLab.frame.size.height);
                /******************/
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:obj.retData.dataList];
      
                
            }else{
                
                [self.dataArray addObjectsFromArray:obj.retData.dataList];
            }
            
            if (self.dataArray.count > 0) {
                
              self.mainTableView.tableFooterView = [[UIView alloc] init];
            }
            
            [self.mainTableView reloadData];
           
            
        }else{
            
            [self showFailTemporaryMes:obj.retMsg];
            
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    [self stopLoading];
    if ([self.currentApiName isEqualToString:CommentListByTopicDetail]) {
        
        self.page --;
    }
    
    [self showFailTemporaryMes:@"网络连接失败"];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.dataArray.count > 0) {
        
        return self.dataArray.count;
        
    }else{
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.heightDic objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        
        NSNumber *cellHeight = [self.heightDic objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        
        return [cellHeight floatValue];
        
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        
        
        static NSString *identifier = @"myCell";
        CMLNewVipUseTimeLineTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CMLNewVipUseTimeLineTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self drawTimeLineCell:cell withIndexPath:indexPath];
        return cell;
    }else{
        
        static NSString *identifier = @"myCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}

- (void)drawTimeLineCell:(CMLNewVipUseTimeLineTVCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        
        [cell clear];
        
        RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        __weak typeof(self) weakSelf = self;
        cell.isAllReport = YES;
        cell.deleteTimeLine = ^(NSNumber *timeLineId){
            
            [weakSelf setAlterViewWithTimeLineId:timeLineId];
            
        };
        
        [cell refreshCurrentCellWith:obj atIndexPath:indexPath];
    }
    
    [self.heightDic setObject:[NSNumber numberWithFloat:cell.currentCellHeight]
                               forKey:[NSNumber numberWithInteger:indexPath.row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
        RecommendTimeLineObj *obj = [RecommendTimeLineObj getBaseObjFrom:self.dataArray[indexPath.row]];
        CMLTimeLineDetailMessageVC *vc = [[CMLTimeLineDetailMessageVC alloc] initWithObj:obj.recordId];
        vc.cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - loadMoreData
- (void) loadMoreData{
    
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setCommentListRequest];
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
}

#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self setCommentListRequest];
    
}

- (void) setAlterViewWithTimeLineId:(NSNumber *) timeLineId{
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认举报该内容"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
    alterView.tag = [timeLineId integerValue];
    alterView.delegate=  self;
    [self.view addSubview:alterView];
    [alterView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self showAlterViewWithText:@"举报成功，工作人员会尽快处理"];
    }
    
}

- (void) showDetailShareMessage{
    
    [self showCurrentVCShareView];
    
}

- (void) setActivityShareMes{
    
    NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
    UIImage *image = [UIImage imageWithData:imageNata];
    self.baseShareLink = self.obj.retData.shareUrl;
    self.baseShareImage = image;
    self.baseShareContent = self.obj.retData.desc;
    self.baseShareTitle = [NSString stringWithFormat:@"卡枚连话题%@，一起来加入吧！",self.obj.retData.title];
    
    self.shareSuccessBlock = ^(){
        
        
    };
    
    self.sharesErrorBlock = ^(){
        
    };
    
}

- (void) enterWriteVC{
    
    CMLWriteVC *vc = [[CMLWriteVC alloc] initWithTopic:self.obj.retData.title TopicID:self.currentID];
    vc.delegate = self;
    vc.isDismissPop = YES;
    [[VCManger mainVC] pushVC:vc animate:YES];
}

- (void) refreshVIPDetailVC{

    [self.mainTableView.mj_header beginRefreshing];
}
@end
