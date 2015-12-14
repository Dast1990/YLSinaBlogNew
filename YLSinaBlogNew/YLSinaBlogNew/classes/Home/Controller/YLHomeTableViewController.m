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
@end

@implementation YLHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

#pragma mark -  UI
- (void)setUpUI{
    [self setUpItems];
    [self setUpTitleView];
    
    [self getNewBlog];
}

- (void)setUpTitleView{
    
    [self getUserName];
    [self.titleViewByBtn setTitle:self.accountModel.name ? self.accountModel.name :@"首页" forState:(UIControlStateNormal)];
    
    [self.titleViewByBtn addTarget:self action:@selector(pullDownViewCreation) forControlEvents:(UIControlEventTouchUpInside)];
    
#pragma mark -   如果不强制布局一次，会出现bug！重写setFrame或在YLButton的initwithframe方法中加句self.imageView也可以！
    //    force the layout of subviews before drawing.
    //    [self.titleViewByBtn layoutIfNeeded];
    ////    下轮绘图时才有效。对本例无用
    //    [self.titleViewByBtn setNeedsLayout];
    
    self.navigationItem.titleView = self.titleViewByBtn;
//    YLLOG(@"%@", self.navigationItem.titleView);
}

- (void)setUpItems{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self selector:@selector(leftBtnDidClick) normalImgName:@"navigationbar_friendsearch" highlightedImgName:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTarget:self selector:@selector(rightBtnDidClick) normalImgName:@"navigationbar_pop" highlightedImgName:@"navigationbar_pop_highlighted"];
}

#pragma mark -  网络
- (void)getUserName{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    /*access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     
     screen_name	false	string	需要查询的用户昵称。
     */
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    dicM[@"access_token"] = self.accountModel.access_token;
    dicM[@"uid"] = self.accountModel.uid;
    
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:dicM success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *  _Nonnull responseObject) {
        self.accountModel.name = responseObject[@"name"];
        //        name 存到沙盒
        [YLAccountTool storeAccount:self.accountModel];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取用户名失败"];
        YLLOG(@"%@", error);
    }];
}

- (void)getNewBlog{
    /*
     必选	类型及范围	说明
     source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     count	false	int	单页返回的记录条数，默认为50。
     page	false	int	返回结果的页码，默认为1。
     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    dicM[@"access_token"] = self.accountModel.access_token;
    NSLog(@"%@",self.accountModel.access_token);
    //https ://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00K91aWFXloTqC852c6f2d000XVg9C
    #warning:总是显示19条！why？
//    默认刷新20条
//    dicM[@"count"] = @20;
    
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:dicM success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *  _Nonnull responseObject) {
        //        写入失败， 字典中 存在不符合 write方法类型 的数据导致。
        //        BOOL result =  [responseObject writeToFile:filePath atomically:YES];
        #pragma mark - responseObject,后面跟上  [@"statuses"] ，取到的才是  用户模型数组！
        self.Statuses = [YLStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
#pragma mark -本来没数据，不刷新，怎么显示新数据？!
        [self.tableView reloadData];
//        YLLOG(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取微博失败"];
        YLLOG(@"%@", error);
    }];
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

#pragma mark -  代理方法
- (void)pulldownMenuDidDismiss:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = NO;
}

- (void)pulldownMenuDidShow:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = YES;
}


#pragma mark -数据源3方法
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    
    //2.获取模型
    YLStatus *status = self.Statuses[indexPath.row];
    YLUser *user = status.user;
    
    //3.为cell赋值
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = status.text;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    //4.返回cell
    return  cell;
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



@end