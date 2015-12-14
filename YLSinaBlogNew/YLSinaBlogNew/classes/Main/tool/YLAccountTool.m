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

+ (void)storeAccount:(YLAccountModel *)account{
    //        存account信息
    [NSKeyedArchiver archiveRootObject:account toFile:YLAccountPath];
}

+ (YLAccountModel *)account{
    YLAccountModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:YLAccountPath];
    
//    没有过期就返回model，否则，返回nil
    long long expires_in = [model.expires_in longLongValue];
    NSDate *exprireEndTime = [model.timeOfAccountAutho dateByAddingTimeInterval:expires_in];
    NSDate *timeOfNow = [NSDate date];
    NSComparisonResult result = [timeOfNow compare: exprireEndTime];
//    YLLOG(@"%@, %@", timeOfNow, exprireEndTime);
    
//    注意条件判断，只有当 timeOfNow 小于 exprireEndTime（升序）时，才返回模型。也就是说 当不为 升序 时，就返回nil
    if (result != NSOrderedAscending) {
        return  nil;
    }
    return model;

}

@end
