//
//  YLHttpTool.m
//  YLSinaBlogNew
//
//  Created by LongMa on 16/2/5.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import "YLHttpTool.h"
#import <AFNetworking.h>
#import "YLAccountModel.h"
#import "YLAccountTool.h"


@implementation YLHttpTool

+ (void)GETOrPOST:(kHttpMethods)httpMethod url:(NSString *)URLString
       parameters:(id)parameters
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure{
    YLAccountModel *account = [YLAccountTool account];
    parameters[@"access_token"] = account.access_token;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (httpMethod == kGETMethod) {
        [mgr GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }else if (httpMethod == kPOSTMethod){
        //!!!: post授权请求，需要修正类型。
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [mgr POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
}



@end
