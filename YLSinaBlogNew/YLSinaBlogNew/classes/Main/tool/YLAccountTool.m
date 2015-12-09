//
//  YLAccountTool.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/10.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLAccountTool.h"
#import "YLAccountModel.h"

#define YLAccountPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"account.plist"]

@implementation YLAccountTool

+ (void)storeAccountWithDic:(NSDictionary *)dic{
    //        存account信息
    YLAccountModel *accountModel = [YLAccountModel accountModleWithDic:dic];
    [NSKeyedArchiver archiveRootObject:accountModel toFile:YLAccountPath];
}

+ (instancetype)account{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YLAccountPath];
}

@end
