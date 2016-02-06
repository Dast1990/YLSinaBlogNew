//
//  YLHomeTableViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLHomeTableViewController.h"
#import "YLMessageTableViewController.h"
#import "YLPullDownView.h"
#import <AFNetworking.h>
#import "YLAccountModel.h"
#import "YLAccountTool.h"
#import <SVProgressHUD.h>
#import "YLButton.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "YLStatus.h"
#import "YLUser.h"
#import "YLLoadMoreFooterView.h"

#import <Masonry.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "YLTableViewCell.h"
#define kHomeVCellReuseID @"homeVCell"

#import "YLHttpTool.h"

@interface YLHomeTableViewController ()<YLPullDownViewDelegate>

/**
 *  导航栏标题视图
 */
@property (nonatomic, strong) YLButton *titleViewByBtn;

/**
 *  账号模型
 */
@property (nonatomic, strong) YLAccountModel *accountModel;

/**
 *  微博模型 数组
 */
@property (nonatomic, strong) NSMutableArray *Statuses;

/**
 *  下拉刷新控件
 */
@property (nonatomic, weak) UIRefreshControl *refreshC;

/**
 *  微博更新数通知条幅
 */
@property (nonatomic, weak) UILabel *noticeLbl;

/** 加载更多视图 */
@property (nonatomic, strong) YLLoadMoreFooterView *loadMoreFooterView;

@end

@implementation YLHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 初始化控件 */
    [self setUpUI];
    
    /** 获取未读数 */
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(getUnreadMsges)
                                                    userInfo:nil
                                                     repeats:YES];
    //???:mainRunLoop，与currentrunloop区别
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //!!!:    记忆方法：cs-腾讯Q咦
    
    /** 注册cell */
    [self.tableView registerNib:[UINib nibWithNibName:@"YLTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kHomeVCellReuseID];
    
    /** 预估行高，在使用fd框架时，也要写，同样会减少行高计算次数！ */
    self.tableView.estimatedRowHeight = 200;
}
#pragma mark -  初始化控件
- (void)setUpUI{
    [self setUpItems];
    [self setUpTitleView];
    [self pullDownToRefreshBlogs];
    [self setUpLoadMoreView];
}

/** 设置导航条 */
- (void)setUpItems{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self selector:@selector(leftBtnDidClick) normalImgName:@"navigationbar_friendsearch" highlightedImgName:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTarget:self selector:@selector(rightBtnDidClick) normalImgName:@"navigationbar_pop" highlightedImgName:@"navigationbar_pop_highlighted"];
}

/** 设置标题 */
- (void)setUpTitleView{
    
    [self getUserName];
    [self.titleViewByBtn setTitle:self.accountModel.name ? self.accountModel.name
                                 :@"首页" forState:(UIControlStateNormal)];
    
    [self.titleViewByBtn addTarget:self action:@selector(pullDownViewCreation) forControlEvents:(UIControlEventTouchUpInside)];
    
    //!!!:   如果不强制布局一次，会出现bug！重写setFrame或在YLButton的initwithframe方法中加句self.imageView也可以！
    //    force the layout of subviews before drawing.
    //    [self.titleViewByBtn layoutIfNeeded];
    ////    下轮绘图时才有效。对本例无用
    //    [self.titleViewByBtn setNeedsLayout];
    
    self.navigationItem.titleView = self.titleViewByBtn;
    //    YLLOG(@"%@", self.navigationItem.titleView);
}

/** 下拉刷新 */
- (void)pullDownToRefreshBlogs{
    [self.refreshC addTarget:self action:@selector(loadNewStatuses) forControlEvents:UIControlEventValueChanged];
    
    /** 马上进入刷新状态，但是不会触发 ValueChanged 事件，下面自己调 */
    [self.refreshC beginRefreshing];
    
    [self loadNewStatuses];
}

/** 上拉加载更多 */
- (void)setUpLoadMoreView{
    self.loadMoreFooterView.hidden = YES;
    self.tableView.tableFooterView = self.loadMoreFooterView;
}

#pragma mark - 点击titleView按钮，创建下拉视图
- (void)pullDownViewCreation{
    //    创建
    YLPullDownView *menu = [YLPullDownView menu];
    
    //    添加显示内容
    YLMessageTableViewController *contentViewController = [[YLMessageTableViewController alloc] init];
    contentViewController.view.x = 10;
    contentViewController.view.y = 10;
    contentViewController.view.width = 200;
    contentViewController.view.height = 250;
    
    //    只有传递控制器，才会显示内容！只传递contentViewController.view，怎么可能显示内容嘛！
    menu.contentController = contentViewController;
    menu.delegate = self;
    
    //    显示
    [menu showFrom:self.navigationItem.titleView];
}

#pragma mark -  网络
/** 获取未读数 */
- (void)getUnreadMsges{
    YLLOG(@"1");
    
    YLAccountModel *account = [YLAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = account.uid;
    //    params[@"access_token"] = account.access_token;//每个get都要设置，于是封装到tool的get方法里了。
    NSString *urlString = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    
    [YLHttpTool GETOrPOST:kGETMethod url:urlString parameters:params success:^(id responseObject) {
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            //???: app上并没显示
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSError *error) {
        YLLOG(@"请求失败：%@",error);
    }];
    return;
}

- (void)pullUpToLoadMoreBlogs{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    
    if (self.Statuses.lastObject) {
        NSString *idTemp     = [self.Statuses.lastObject idstr];
        YLLOG(@"idTemp = %@",idTemp);
        
        //!!!: idTemp = 3938091960576445   idTempSub1 = 3938091960576444，服务器返回的数字一般很大，用longlongValue转，intValue范围太小，会出错。
        NSNumber *idTempSub1 = @(idTemp.longLongValue - 1);//-1，为了不再获得当前最后一条微博。
        params[@"max_id"]      = idTempSub1;
        YLLOG(@"idTempSub1 = %@",idTempSub1);
    }
    NSString *url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
    
    [YLHttpTool GETOrPOST:kGETMethod url:url parameters:params success:^(id responseObject) {
        //!!!: responseObject,后面跟上  [@"statuses"] ，取到的才是  用户模型数组！
        NSMutableArray *newStatuses  = [YLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        //        NSRange range = NSMakeRange(0, newStatuses.count);
        //        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.Statuses addObjectsFromArray:newStatuses];
        
        [self.tableView reloadData];
        self.loadMoreFooterView.loading = NO;//!!!: 必须在本次数据请求结束后设置为no，否则再次上拉刷新无效。
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取微博失败,请检查网络连接"];
        [self.refreshC endRefreshing];
        //        [self showResultWithNumberOfRefreshedBlogs:0];
        self.loadMoreFooterView.loading = NO;//!!!: 必须在本次数据请求结束后设置为no，否则再次上拉刷新无效。
        YLLOG(@"%@", error);
    }];
}

/** 加载最新微博 */
- (void)loadNewStatuses{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    if (self.Statuses.firstObject) {
        dicM[@"since_id"]     = [self.Statuses.firstObject idstr];
    }
    [YLHttpTool GETOrPOST:kGETMethod url:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:dicM success:^(id responseObject) {
        YLLOG(@"%@",responseObject);
        NSMutableArray *newStatuses  = [YLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.Statuses insertObjects:newStatuses atIndexes:indexSet];
        
        [self.tableView reloadData];
        [self.refreshC endRefreshing];
        [self showResultWithNumberOfRefreshedBlogs:newStatuses.count];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取微博失败"];
        [self.refreshC endRefreshing];
        YLLOG(@"%@", error);
    }];
    
}

- (void)showResultWithNumberOfRefreshedBlogs:(NSUInteger)numberOfRefreshedBlogs {
    /** 刷新成功，清空图标数字 */
    self.tabBarItem.badgeValue = nil;
    
    self.noticeLbl.text = numberOfRefreshedBlogs == 0
    ? @"没有新微博。"
    : [NSString stringWithFormat:@"%zd条新微博。", numberOfRefreshedBlogs]; ;
    
    [UIView animateWithDuration:0.5  delay:0.5 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.noticeLbl.height = self.navigationController.navigationBar.height;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.noticeLbl.height = 0;
        } completion:^(BOOL finished){
            [self.noticeLbl removeFromSuperview];
        }];
    }];
}

- (void)getUserName{
    /*access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     */
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    dicM[@"uid"] = self.accountModel.uid;
    
    [YLHttpTool GETOrPOST:kGETMethod url:@"https://api.weibo.com/2/users/show.json" parameters:dicM success:^(id responseObject) {
        self.accountModel.name = responseObject[@"name"];
        //        name 存到沙盒
        [YLAccountTool storeAccount:self.accountModel];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取用户名失败"];
        YLLOG(@"%@", error);
    }];
}

#pragma mark -  自定义下拉视图 代理方法
- (void)pulldownMenuDidDismiss:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = NO;
}

- (void)pulldownMenuDidShow:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = YES; 
}

#pragma mark -  scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    //!!!: tabbar会缩小scrollview的高度（高度比618大时),scrollView.frame == {0, 0}, {375, 618},(667- 618 = 49)
    CGFloat differ = scrollView.contentSize.height - scrollView.height;
    
    //    /** {{0, 0}, {375, 618}}:667- 618 = 49,tabbar的高度。
    //     可见：tabbar会缩小scrollview的高度（高度比618大时）；导航栏会且只会影响scrollview的offset属性 */
    //    YLLOG(@"%@", NSStringFromCGRect(self.tableView.frame));
    //    YLLOG(@"%@", NSStringFromCGRect(scrollView.frame));
    //    
    //    /** 20*44 + 44 = 924 */
    //    YLLOG(@"scrollView.contentSize.height = %f", (scrollView.contentSize.height));
    //    
    //    /** 有导航栏时，默认是 -64，自动向下偏移了 */
    YLLOG(@"scrollView.contentOffset.y = %f", scrollView.contentOffset.y);
    //
    //    YLLOG(@"self.tabBarController.tabBar.height = %f", self.tabBarController.tabBar.height);// 49
    YLLOG(@"differ = %f", differ);// 306
    
    /** 当没有数据显示(此时scrollView.contentSize.height = footerView高度 < scrollView.height)，return； */
    if (differ < 0) {
        return;
    }
    
    /** 当微博数组有值时，设置加载更多视图可见 */
    if (self.Statuses.count > 0) {// differ 应该减去 加载更多视图 的高度
        self.tableView.tableFooterView.hidden = NO;
    }
    
    /** 当上拉到 加载更多视图 偏离tabbar 44距离时，就加载更多。 */
    if (contentOffsetY > differ + 44 && !self.loadMoreFooterView.isLoading) {
        YLLOG(@"load more");
        [self pullUpToLoadMoreBlogs];
        self.loadMoreFooterView.loading = YES;
    }
}


#pragma mark tableView数据源3方法
//确定组的数量，如果不实现默认为1组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

//确定组中一共有几行数据
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.Statuses.count;
}

//创建每一行显示的cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    /*
          dequeueReusableCellWithIdentifier:  forIndexPath: iOS6.0推出，为了方便程序员直接从sb中创建cell
          > 根据指定标示符去缓存池中找cell
              > 如果没有找到，则会查看是否已经注册了一个cell,如果没有注册cell,
                     >则根据标示符去sb里面找对应写了相同重用标记的cell，如果没有找到，直接崩溃。
     */
    YLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeVCellReuseID forIndexPath:indexPath];
    
    //2.获取模型
    YLStatus *status = self.Statuses[indexPath.row];
    
    //3.为cell赋值
    cell.status = status;
    
    //4.返回cell
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kHomeVCellReuseID cacheByIndexPath:indexPath configuration:^(YLTableViewCell* cell) {
        
        //!!!: 直接配置cell，别dequeue，会崩溃。
        //        cell = [tableView dequeueReusableCellWithIdentifier:kHomeVCellReuseID forIndexPath:indexPath];
        
        //2.获取模型
        YLStatus *status = self.Statuses[indexPath.row];
        
        //3.为cell赋值
        cell.status = status;
    }];
}

#pragma mark -  事件
- (void)leftBtnDidClick{
    YLLOG(@"%s", __func__);
}

- (void)rightBtnDidClick{
    YLLOG(@"%s", __func__);
}

#pragma mark -  懒加载
- (YLButton *)titleViewByBtn{
    if (! _titleViewByBtn) {
        _titleViewByBtn = [[YLButton alloc] init];
    }
    return  _titleViewByBtn;
}


- (YLAccountModel *)accountModel{
    if (nil == _accountModel) {
        _accountModel = [YLAccountTool account];
    }
    return  _accountModel;
}

- (NSArray *)Statuses
{
    if (!_Statuses){
        _Statuses = [NSMutableArray array];
    }
    return _Statuses;
}

- (UIRefreshControl *)refreshC
{
    if (!_refreshC){
        UIRefreshControl *refreshC = [[UIRefreshControl alloc] init];
        [self.tableView addSubview:refreshC];
        _refreshC = refreshC;
    }
    return _refreshC;
}

- (UILabel *)noticeLbl
{
    if (!_noticeLbl){
        UILabel *noticeLbl = [[UILabel alloc] init];
        noticeLbl.backgroundColor = [UIColor yellowColor];
        noticeLbl.textAlignment = NSTextAlignmentCenter;
        CGFloat x = 0;
        CGFloat width = YLSCREEN_WIDTH;
        CGFloat height = 0;
        
        CGFloat y = self.navigationController.navigationBar.height + 20;
        
        noticeLbl.frame = CGRectMake(x , y, width, height);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:noticeLbl];
        //        [self.navigationController.view insertSubview:noticeLbl belowSubview:self.navigationController.navigationBar];
        
        _noticeLbl = noticeLbl;
    }
    return _noticeLbl;
}


- (YLLoadMoreFooterView *)loadMoreFooterView
{
    if (!_loadMoreFooterView){
        _loadMoreFooterView = [YLLoadMoreFooterView footerView];
        _loadMoreFooterView.width = self.view.width;
    }
    return _loadMoreFooterView;
}



@end