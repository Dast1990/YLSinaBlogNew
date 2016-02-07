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

/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/**
 *  转发数
 */
@property (nonatomic, assign) NSInteger reposts_count;

/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments_count;

/** 微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。 */
@property (nonatomic, strong) NSArray *pic_urls;


@end

