//
//  YLMainTabbarController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLMainTabbarController.h"
#import "YLHomeTableViewController.h"
#import "YLMessageTableViewController.h"
#import "YLDiscoverTableViewController.h"
#import "YLProfileTableViewController.h"
#import "YLNavigationViewController.h"
#import "YLTabBar.h"

@interface YLMainTabbarController ()<YLTabBarDelegate>

@end

@implementation YLMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    添加子控制器
    [self addChildController:[[YLHomeTableViewController alloc] init]
                   WithTitle:@"首页"
             normalImageName:@"tabbar_home"
               selectedImage:@"tabbar_home_highlighted"];
    [self addChildController:[[YLMessageTableViewController alloc] init]
                   WithTitle:@"信息"
             normalImageName:@"tabbar_message_center"
               selectedImage:@"tabbar_message_center_highlighted"];
    [self addChildController:[[YLDiscoverTableViewController alloc] init]
                   WithTitle:@"发现"
             normalImageName:@"tabbar_discover"
               selectedImage:@"tabbar_discover_highlighted"];
    [self addChildController:[[YLProfileTableViewController alloc] init]
                   WithTitle:@"我"
             normalImageName:@"tabbar_profile"
               selectedImage:@"tabbar_profile_highlighted"];
    
    YLLOG(@"%@", self.tabBar);
    //    kvc实现：自定义tabbar替换系统tabbar
    YLTabBar *ylTabbar = [YLTabBar tabBar];
    [self setValue:ylTabbar forKeyPath:@"tabBar"];
    YLLOG(@"%@", ylTabbar);
    
    ylTabbar.myDelegate = self;
}

#pragma mark -  modal出发表说说控制器
- (void)tabBarAddBtnDidClick:(YLTabBar *)tabBar{
    UIViewController *releaseMicroBlogVC = [[UIViewController alloc] init];
    releaseMicroBlogVC.view.backgroundColor = [UIColor brownColor];
    [self presentViewController:releaseMicroBlogVC animated:YES completion:^{
         YLLOG(@"%s",__func__);
    }];
}


- (void)addChildController:(UIViewController *)childVC
                 WithTitle:(NSString *)title
           normalImageName:(NSString *)normalImg
             selectedImage:(NSString *)selectedImage{
    
    YLLOG(@"%@", self.tabBar);
    childVC.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:normalImg]
                                imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]
                                        imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    //    文字非系统渲染，不是设置self.tabBarItem
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:(UIControlStateSelected)];
    YLNavigationViewController *nav = [[YLNavigationViewController alloc] initWithRootViewController:childVC];
    
    //  创建随机色时会调用对用控制器的viewDidLoad方法，导致一下子就创建了 4 个view，这不合理，因为用户很可能就用一个home主页，不点其他页面，内存没必要提前去加载这些视图，即：没必要提前创建未显示的view。所以，不要创建随机色。
    //    childVC.view.backgroundColor = YLRandomColor;
    [self addChildViewController:nav];
}



@end
