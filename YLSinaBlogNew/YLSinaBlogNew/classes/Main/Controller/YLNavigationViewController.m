//
//  YLNavigationViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.

#import "YLNavigationViewController.h"
#import "YLTabBar.h"

@interface YLNavigationViewController ()

@end

@implementation YLNavigationViewController

//// 当 第一次 加载 这个类的时候调用（main函数方法之前调用），只会调用一次。使用#import "" 就会触发方法调用。
//+ (void)load{
//    YLLOG(@"%s", __func__);
//}

// 当 第一次 使用 该类或者该类的子类时调用（main方法执行之后调用），比 写在viewDidLoad方法中写 要好。
/*
 2015-11-30 10:52:58.577 YLSinaBlog[41443:1943909] +[YLNavigationViewController initialize]
 2015-11-30 10:52:58.618 YLSinaBlog[41443:1943909] -[YLNavigationViewController viewDidLoad]
 2015-11-30 10:52:58.691 YLSinaBlog[41443:1943909] -[YLNavigationViewController viewDidLoad]
 2015-11-30 10:52:58.707 YLSinaBlog[41443:1943909] -[YLNavigationViewController viewDidLoad]
 2015-11-30 10:52:58.727 YLSinaBlog[41443:1943909] -[YLNavigationViewController viewDidLoad]
 */
+ (void)initialize{
    YLLOG(@"%s", __func__);
    if (self == [YLNavigationViewController class]){ //如果子类没有实现该方法，那么子类调用这个方法时不满足if条件
        [self setUpAppearance];
    }
}

+ (void)setUpAppearance{
    UIBarButtonItem *btnItem = [UIBarButtonItem appearance];
    [btnItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]
                                      , NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:(UIControlStateNormal)];
    
    
    /*
     Note for iOS7: On iOS7 the tintColor property has moved to UIView, and now has special inherited behavior described in UIView.h.
     This inherited behavior can conflict with the appearance proxy, and therefore tintColor is now disallowed with the appearance proxy.
     所以想设置item的不可选状态的颜色，必须在全局对象这设置，不能私自在子控制器中设置，会冲突！
     */
    [btnItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                      , NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:(UIControlStateDisabled)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.viewControllers.count > 0){
        //        注意：让被push的控制器hidesBottomBarWhenPushed，不是让导航控制器hidesBottomBarWhenPushed
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self selector:@selector(backBtnDidClick) normalImgName:@"compose_emoticonbutton_background" highlightedImgName:@"compose_emoticonbutton_background_highlighted"];
        
        
        viewController.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTarget:self selector:@selector(homeBtnDidClick) normalImgName:@"tabbar_home" highlightedImgName:@"tabbar_home_highlighted"];
    }
    //    拦截了push方法而没有调用父类push方法，会导致tabBarcontroller的四个子控制器没法push出来！
    //    注意：必须放在hidesBottomBarWhenPushed代码后面（if条件改为 > 0），因为先push的话，已经把tabbar展示出来了！
    [super pushViewController:viewController animated:YES];
}


- (void)backBtnDidClick{
    //    这里要用self，不是self.navigationController。self就是导航控制器，再拿他所在的导航控制器，啥也没有，是nil。此时点击back item，会执行back方法，但是pop方法不会响应nil（ps：nil调用任何方法不会报错）。
    [self popViewControllerAnimated:YES];
}

- (void)homeBtnDidClick{
    NSArray *popsArr = [self popToRootViewControllerAnimated:YES];
    //    [self setValue:[YLTabBar tabBar] forKeyPath:@"tabBar"];
    YLLOG(@"%@", popsArr);
}

@end
