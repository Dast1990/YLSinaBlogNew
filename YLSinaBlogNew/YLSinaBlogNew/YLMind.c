//
//  YLMind.c
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//
/*
 一、UI
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
 ？设置搜索框点击时弹出键盘，按enter退出键盘设置
V10.设置首页下拉菜单
V11.添加发布微博加号按钮和点击事件。
?待做点击后发表微博的界面
 ps：AFN更改为2.6.3了，3beta不好用；git clone前不需要git init
V12.完成了新特性界面
V13. 待做跳转到新特性界面的条件判断，以及点击“开始微博”后的跳转
 
 ？整合访客视图到本工程？最后再完善！
    由于架构不同，目前思路是：新建一个访客视图view。在每个页面viewDidLoad的setUpUI时，根据是否登陆（doc中account.plist），设置不同的view。（ps：在appDelegate中直接把main设置为根控制器，授权界面显示交给访客视图中登陆按钮的响应事件）
 
 二、网络请求之后
V14.授权控制器获取accessToken部分实现。
V15.需求：先判断是否之前已登录（doc，account模型）
    是：判断是否需要显示新特性界面；
    否，加载授权界面，登录成功时：保存账号（转为模型）到doc，再判断是否需要加载新特性界面。
V16.封装了window分类(根控制器切换)： 判断是否需要显示新特性界面并根据判断分别设置合适的根控制器
    封装了account工具类：存取账号信息。
V17.
     1.修正了accountTool类方法参数
     2.对令牌有效期过期时间做了判断，并把用户授权时间存入了沙盒。
     3.在首页导航栏显示了用户名并把用户名增加到了account模型，存到了沙盒。
 V18.自定义button，实现了titleView按钮的文字和图片的自动布局
    AFN请求最新微博数据  text内容  显示在首页。
 

*/