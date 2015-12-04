//
//  YLOAuthViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/12/4.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLOAuthViewController.h"
//#import <AFNetworking.h>

@interface YLOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YLOAuthViewController

- (void)viewDidLoad{
    YLLOG(@"%s", __func__);
    UIWebView *webView = [[UIWebView alloc] init];
    
    webView.frame = self.view.bounds;
//只有拖动到头时，才可以看到背景色
    webView.backgroundColor = [UIColor orangeColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [self webViewOperation];
}


- (void)webViewOperation{
//    https://api.weibo.com/oauth2/authorize?client_id=1773885185&redirect_uri=http://www.baidu.com/
//    http://www.baidu.com/
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2607741795&redirect_uri=http://www.baidu.com/"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

#pragma mark -  代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    YLLOG(@"%s", __func__);
    YLLOG(@"%@", request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    YLLOG(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    YLLOG(@"%s", __func__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    YLLOG(@"%s", __func__); 
}



@end
