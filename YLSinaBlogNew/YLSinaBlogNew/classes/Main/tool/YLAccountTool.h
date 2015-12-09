//
//  YLAccountTool.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/10.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLAccountTool : NSObject
/**
 *  账户字典转模型后，存入到doc
 *
 *  @param dic 账户字典
 */
+ (void)storeAccountWithDic:(NSDictionary *)dic;
/**
 *  获取账户信息
 *
 *  @return 账户对象
 */
+ (instancetype)account;

@end
