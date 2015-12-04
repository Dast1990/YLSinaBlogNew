//
//  YLMind.c
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//
/* 
aece6e0 HEAD@{8}: clone: from https://github.com/Dast1990/sinaBlogOC.git
 
V1.在tabBarC基础上显示了4个子控制器的界面。设置了pch文件，测试用的xib。设置了子控制器的leftBarButtonItem属性，待完善自定义导航控制器。
V2.写UIView分类，方直接.size,.x 等快速代码
V3. 统一所有导航控制器左上角和右上角的内容。
    自定义导航控制器，拦截（重写自带的方法）所有push出来的控制器（必须调用[super push方法]，才能显示tabBarC的四个子控制器）
    通过push方法中控制器参数，设置器左上角和右上角的内容(当导航控制器的子控制器数大于1时，才设置导航栏的左右item)
    隐藏tabbar（无效：[super push方法]位置不对,要放在最后）
V4.取消创建随机色（不合理），设置window颜色为白色。
V5在pct中增加了YLLOG(…) debug下取代NSLog的代码
V6.封装了UIBarButtonItem+Extension 分类文件，方便以后UIBarButtonItem类属性 的创建。
V7.向首页增加了左右item，点击item的方法暂时未实现（找朋友和扫二维码);
  在导航控制器的 +initialize 方法中 设置导航栏全局样式.
V8.在消息界面为导航栏右item设置文字，设置为不可用，并使之显示为亮灰色。
    切换界面回来（viewWillAppear重新设置了颜色为亮灰色）又变回了全局橘色，why?
     A:因为appearance设置会与tinitColor会冲突。 不设置tinitColor而在全局对象设置不可用状态颜色就好了！
V9.设置发现界面导航栏的搜索框



*/