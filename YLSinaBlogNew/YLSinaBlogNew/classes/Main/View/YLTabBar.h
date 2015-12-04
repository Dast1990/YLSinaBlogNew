//
//  YLTabBar.h
//  YLSinaBlog
//
//  Created by LongMa on 15/12/4.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLTabBar;
@protocol  YLTabBarDelegate <UITabBarDelegate>

@optional

/**
 *  加号按钮被点击
 *
 *  @param tabBar
 */
- (void)tabBarAddBtnDidClick:(YLTabBar *)tabBar;

@end

@interface YLTabBar : UITabBar

/**
 *  加号按钮
 */
@property (nonatomic, weak) UIButton *addButton;

/**
 *  自定义代理属性，不能用delegate，与父类代理属性同名，会报警告。
 */
@property (nonatomic, weak) id<YLTabBarDelegate> myDelegate;

/**
 *  类方法：创建自带加号按钮的对象
 *
 *  @return 自定义的tabbar对象
 */
+ (instancetype)tabBar;

@end
