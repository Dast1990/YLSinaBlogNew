//
//  YLAccountModel.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/9.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLAccountModel : NSObject<NSCoding>
/*
 <key>access_token</key>
	<string>2.00K91aWFXloTqC852c6f2d000XVg9C</string>
	<key>expires_in</key>
	<integer>157679999</integer>
	<key>remind_in</key>
	<string>157679999</string>
	<key>uid</key>
	<string>5062165346</string>
 </dict>
 */
/**
 *  令牌
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  过期时间
 */
@property (nonatomic, strong) NSNumber *expires_in;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  账户授权时间
 */
@property (nonatomic, strong) NSDate *timeOfAccountAutho;

/**
 *  需要查询的用户昵称
 */
@property (nonatomic, copy) NSString *name;

+ (instancetype)accountModleWithDic:(NSDictionary *)dic;

@end
