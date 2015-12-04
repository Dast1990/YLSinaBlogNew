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

@interface YLHomeTableViewController ()<YLPullDownViewDelegate>

@property (nonatomic, strong) UIButton *titleViewByBtn;
@end

@implementation YLHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpItems];
    [self setUpTitleView];
}


- (void)setUpTitleView{
    //    设置导航栏中心视图
    self.titleViewByBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.titleViewByBtn.width = 250;
    self.titleViewByBtn.height = 40;
    [self.titleViewByBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.titleViewByBtn setTitle:@"首页-文字可变" forState:(UIControlStateNormal)];
    [self.titleViewByBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:(UIControlStateSelected)];
    [self.titleViewByBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:(UIControlStateNormal)];
    //  文字距离右边偏移距离为按钮中图片的长度
    self.titleViewByBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.titleViewByBtn.imageView.width);
#warning 注意：
    //  距离左边偏移量，应该是文字长度（计算文字长度的方法  收集到文件夹里） + 想要的文字和图片距离
    self.titleViewByBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 186, 0, 0);
    
    [self.titleViewByBtn addTarget:self action:@selector(pullDownViewCreation) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.titleView = self.titleViewByBtn;
}

#pragma mark - 点击titleView按钮，创建下拉视图(待抽取)
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

#pragma mark -  下拉试图代理方法
- (void)pulldownMenuDidDismiss:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = NO;
}

- (void)pulldownMenuDidShow:(YLPullDownView *)menu{
    self.titleViewByBtn.selected = YES;
}


- (void)setUpItems{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self selector:@selector(leftBtnDidClick) normalImgName:@"navigationbar_friendsearch" highlightedImgName:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTarget:self selector:@selector(rightBtnDidClick) normalImgName:@"navigationbar_pop" highlightedImgName:@"navigationbar_pop_highlighted"];
}

- (void)leftBtnDidClick{
    YLLOG(@"%s", __func__);
}

- (void)rightBtnDidClick{
    YLLOG(@"%s", __func__);
}




@end