//
//  YLOAuthViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/12/4.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLOAuthViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

#import "YLAccountModel.h"
#import "YLAccountTool.h"
#import <MJExtension.h>

#import "YLHttpTool.h"



@interface YLOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YLOAuthViewController

- (void)viewDidLoad{
    [super viewDidLoad];
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
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=http://www.baidu.com/",kAppKey];
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
}

#pragma mark -  代理方法
#pragma mark -  截取网络参数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    YLLOG(@"%s", __func__);
    YLLOG(@"%@", request);
    [SVProgressHUD showWithStatus:@"将要开始加载网络请求"];
    
    //!!!: 要熟练
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];;
    params[@"client_id"] =kAppKey;
    params[@"client_secret"] = kAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com/";
    NSString *postUrl = @"https://api.weibo.com/oauth2/access_token";
    
    //!!!:  最好在代码里写，需要新加提示的格式，如果改afn底层，别人按pod去更新时，别人afn的底层可是没改过的！ [NSSet setWithObjects:@"text/plain", nil];也可以。
    
    [YLHttpTool GETOrPOST:kPOSTMethod url:postUrl parameters:params success:^(id responseObject) {
        YLLOG(@"请求成功：%@", responseObject);
        
        //!!!: 不能用mj替换下一行，因为自定义转换内部有 授权时间的记录。不止是简单地转换模型。替换的话就没有授权时间了。
        //        YLAccountModel *accountModel = [YLAccountModel mj_objectWithKeyValues:responseObject];
        YLAccountModel *accountModel = [YLAccountModel accountModleWithDic:responseObject];
        [YLAccountTool storeAccount:accountModel];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window newFeatureJudgeAndSetRootViewController];
    } failure:^(NSError *error) {
        YLLOG(@"%@", error);
    }];
    
//    [mgr POST:postUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary*  _Nonnull responseObject) {//可以改系统的参数名（提高可读性）或参数类型（的确是某个类型时）
//        YLLOG(@"请求成功：%@", responseObject);
//        
//        //!!!: 不能用mj替换下一行，因为自定义转换内部有 授权时间的记录。不止是简单地转换模型。替换的话就没有授权时间了。
//        //        YLAccountModel *accountModel = [YLAccountModel mj_objectWithKeyValues:responseObject];
//        YLAccountModel *accountModel = [YLAccountModel accountModleWithDic:responseObject];
//        [YLAccountTool storeAccount:accountModel];
//        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window newFeatureJudgeAndSetRootViewController];
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        YLLOG(@"%@", error);
//    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    YLLOG(@"%s", __func__);
    [SVProgressHUD showInfoWithStatus:@"已经开始加载网页"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    YLLOG(@"%s", __func__);
    //    [SVProgressHUD showSuccessWithStatus:@"加载完成！"];
    [SVProgressHUD showImage:[UIImage imageNamed:@"compose_camerabutton_background_highlighted_os7"] status:@"加载完成-可以自定义图片啊！"];
    //下面这句并没有效果！
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    //    下面不用设置，默认有延迟消失时长
    [SVProgressHUD dismissWithDelay:10];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    YLLOG(@"%s", __func__);
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
    //    设置失败提示框  延迟消失时间
    [SVProgressHUD dismissWithDelay:2];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
