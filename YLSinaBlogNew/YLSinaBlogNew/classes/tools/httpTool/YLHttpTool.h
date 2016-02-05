//
//  YLHttpTool.h
//  YLSinaBlogNew
//
//  Created by LongMa on 16/2/5.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum  {
    kGETMethod = 0,
    kPOSTMethod = 1
}kHttpMethods;

@interface YLHttpTool : NSObject
+ (void)GETOrPOST:(kHttpMethods)httpMethod url:(NSString *)URLString
       parameters:(id)parameters
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;

@end
