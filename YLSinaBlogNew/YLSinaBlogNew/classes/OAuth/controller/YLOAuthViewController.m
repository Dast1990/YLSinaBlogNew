//
//  YLOAuthViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/12/4.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLOAuthViewController.h"
#import <AFNetworking.h>

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
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2607741795&redirect_uri=http://www.baidu.com/"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

#pragma mark -  代理方法
#pragma mark -  截取网络参数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    YLLOG(@"%s", __func__);
    YLLOG(@"%@", request);
    
#warning 注意：要熟练
    //    1.获得url字符串
    NSString *urlString = request.URL.absoluteString;
    //    2.判断是否为回调地址（看是否包含 code=，后面跟的就是code数字）
    NSRange range = [urlString rangeOfString:@"code="];
    
    if (range.length) {//是回调地址，code有值
        //        截取code= 后面参数值
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [urlString substringFromIndex:fromIndex];
        
        //        用code换取accessToken
        [self getTokenByCode:code];
        return NO;
    }
    return YES;
}

- (void)getTokenByCode:(NSString *)code{
    YLLOG(@"%s", __func__);
    
    /*
     请求参数
     必选	类型及范围	说明
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code
     code	true	string	调用authorize获得的code值。
     redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    
    //    是字典，不是数组！
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];;
    dicM[@"client_id"] = @"2607741795";
    dicM[@"client_secret"] = @"3f6587eeeda669d2b1375c8285ecb75d";
    dicM[@"grant_type"] = @"authorization_code";
    dicM[@"code"] = code;
    dicM[@"redirect_uri"] = @"http://www.baidu.com/";
    
    //  AFN请求token,下面用 AFHTTPRequestOperationManager创建管理器，实现对应POST方法，修改底层接收格式。也行！
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager POST:@"https://api.weibo.com/oauth2/access_token" parameters:dicM success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLLOG(@"请求成功：%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YLLOG(@"请求失败：%@", error);
    }];
    
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

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
