//
//  YLStatus.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/14.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLUser;
@interface YLStatus : NSObject

#pragma mark -  ctl + shift + J：json转属性时，不能有中文，把中文去掉


/**
 *  字符串型微博id
 */
@property (nonatomic, copy) NSString *idstr;

/**
 *  微博信息内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  用户信息
 */
@property (nonatomic, strong) YLUser *user;

/**
 *  转发数
 */
@property (nonatomic, assign) NSInteger reposts_count;

/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments_count;


@end

