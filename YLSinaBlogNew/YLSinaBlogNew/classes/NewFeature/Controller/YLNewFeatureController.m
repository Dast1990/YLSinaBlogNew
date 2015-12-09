//
//  YLNewFeatureController.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/6.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLNewFeatureController.h"
#import "YLMainTabbarController.h"

#define numberOfNewFeaturePages 4

@interface YLNewFeatureController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageC;
@property (nonatomic, weak) UIButton *isShareBtn;
@property (nonatomic, weak) UIButton *jumpBtn;

@end

@implementation YLNewFeatureController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark -  创建设置新特性图片
- (void)setUpUI{
    [self setUpScrollView];
    [self setUpPageControl];
}

#pragma mark -  设置ScrollView
- (void)setUpScrollView{
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    //    scrollV.frame 必须设置，跟设置contentSize是两码事！不然屏幕显示不出来scrollV
    scrollV.frame = self.view.bounds;
    scrollV.delegate = self;
    scrollV.contentSize = CGSizeMake(YLSCREEN_WIDTH * numberOfNewFeaturePages, 0);
    scrollV.bounces = NO;
    scrollV.backgroundColor = [UIColor yellowColor];
    scrollV.pagingEnabled = YES;
    
    for (int i = 0; i < numberOfNewFeaturePages; ++i) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.userInteractionEnabled = YES;
        imgV.frame = scrollV.bounds;
        //        必须放在上一句下面，不然x坐标会被覆盖掉，仍然为0，导致所有图片在同一坐标（0，0）而只显示一张
        imgV.x = i * scrollV.width;
        NSString *imgName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imgV.image = [UIImage imageNamed:imgName];
        
        [scrollV addSubview:imgV];
        if (numberOfNewFeaturePages - 1 == i) {
            [self setUpJumpButtonInImageView:imgV];
        }
    }
    [self.view addSubview:scrollV];
}

#pragma mark - 设置pageControl
- (void)setUpPageControl{
    UIPageControl *pageC = [[UIPageControl alloc] init];
    pageC.centerX = self.view.centerX;
    pageC.centerY = self.view.height * 0.9;
    //    UIPageControl不设置页数，就无法显示。
    pageC.numberOfPages = numberOfNewFeaturePages;
    pageC.pageIndicatorTintColor = YLRGBA(200, 200, 200, 0.9);
    pageC.currentPageIndicatorTintColor = [UIColor greenColor];
    
    [self.view addSubview:pageC];
    self.pageC = pageC;
}

- (void)setUpJumpButtonInImageView:(UIImageView *)imgV{
    UIButton *isShareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    isShareBtn.width = 200;
    isShareBtn.height = 30;
    
    //   不能用下面这种！因为imgV的center.x是相对于父控件scrollView的，是一个很大的值
    //    isShareBtn.centerX = imgV.centerX;
    isShareBtn.centerX = imgV.width * 0.5;
    isShareBtn.centerY = imgV.height * 0.7;
    [isShareBtn setTitle:@"分享给大家" forState:(UIControlStateNormal)];
    [isShareBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    isShareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    isShareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    //    #warning 注意：问题出现这！左上角坐标保持不变，根据内容改变控件大小！
    //    即使一开始坐标的确定是根据你设置的center.x确定的，也是一样的！这不是我想要的效果！想要中心与始终在屏幕中心。所以注释掉下面这句。
    //    [isShareBtn sizeToFit];
    //    宏参数，必须是对象：@"图片名"
    [isShareBtn setImage:YLIMAGE(@"new_feature_share_false") forState:(UIControlStateNormal)];
    [isShareBtn setImage:YLIMAGE(@"new_feature_share_true") forState:(UIControlStateSelected)];
    [isShareBtn addTarget:self action:@selector(isShareBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [imgV addSubview:isShareBtn];
    self.isShareBtn = isShareBtn;
    
    UIButton *jumpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    jumpBtn.width = 200;
    jumpBtn.height = 30;
    jumpBtn.centerX = imgV.width * 0.5;
    jumpBtn.centerY = imgV.height * 0.7 + isShareBtn.height + 20;
    [jumpBtn setTitle:@"开始微博" forState:(UIControlStateNormal)];
    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [jumpBtn setBackgroundImage:YLIMAGE(@"new_feature_finish_button") forState:(UIControlStateNormal)];
    [jumpBtn setBackgroundImage:YLIMAGE(@"new_feature_finish_button_highlighted") forState:(UIControlStateHighlighted)];
    [jumpBtn addTarget:self action:@selector(jumpBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    [imgV addSubview:jumpBtn];
    self.jumpBtn = jumpBtn;
}

- (void)isShareBtnDidClick{
    self.isShareBtn.selected = ! self.isShareBtn.isSelected;
}

- (void)jumpBtnDidClick{
#warning 注意：//    若已勾选分享按钮，跳到已登录界面前，自动生成包含新特性内容的写说说界面
    [UIApplication sharedApplication].keyWindow.rootViewController = [[YLMainTabbarController alloc] init];
    //    为了显示动画效果，必须把self.view(self:YLNewFeatureController，到本方法结束才会被销毁？不是没有强引用会被立即销毁吗？，所以方法里还可用)添加到现在显示的根控制器（MainVC）的视图    或  keyWindow  上。
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    CGRect destiFrame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
    
    YLLOG(@"%@",NSStringFromCGRect(self.view.frame));
    [UIView animateWithDuration:2 animations:^{
        self.view.frame = destiFrame;
    } completion:^(BOOL finished) {
        //               completion是异步回调
        YLLOG(@"动画完毕");
        //       YLLOG(@"%@",self.view);
    }];
}

- (void)dealloc{
    YLLOG(@"新特性控制器挂了");
}

#pragma mark -  代理方法，设置页码指示器当前页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger currentPage = (int)(offsetX / YLSCREEN_WIDTH + 0.5);
    self.pageC.currentPage= currentPage;
}

@end
