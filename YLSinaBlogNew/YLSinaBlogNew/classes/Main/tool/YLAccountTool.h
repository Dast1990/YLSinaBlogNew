//
//  YLAccountTool.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/10.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLAccountModel;

@interface YLAccountTool : NSObject
/**
 *  把模型存到沙盒
 *
 *  @param account 模型
 */
+ (void)storeAccount:(YLAccountModel *)account;

/**
 *  获取账户模型对象
 *
 *  @return 账户模型对象
 */
+ (YLAccountModel *)account;

@end
