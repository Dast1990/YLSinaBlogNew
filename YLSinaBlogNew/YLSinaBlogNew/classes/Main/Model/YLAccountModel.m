//
//  YLAccountModel.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/9.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLAccountModel.h"

@implementation YLAccountModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.timeOfAccountAutho = [NSDate date];
        self.access_token = dic[@"access_token"];
        self.expires_in = dic[@"expires_in"];
        self.uid = dic[@"uid"];
    }
    return self;
}

+ (instancetype)accountModleWithDic:(NSDictionary *)dic{
    
    return [[self alloc] initWithDic:dic];
    
}

#pragma mark -  编码和解码
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject: _access_token forKey:@"access_token"];
    [encoder encodeObject: _expires_in forKey:@"expires_in"];
    [encoder encodeObject: _uid forKey:@"uid"];
    [encoder encodeObject: _timeOfAccountAutho forKey:@"timeOfAccountAutho"];
    [encoder encodeObject: _name forKey:@"name"];
    
}


- (instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        _access_token = [decoder decodeObjectForKey:@"access_token"];
        _expires_in = [decoder decodeObjectForKey:@"expires_in"];
        _uid = [decoder decodeObjectForKey:@"uid"];
        _timeOfAccountAutho = [decoder decodeObjectForKey:@"timeOfAccountAutho"];
        _name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
    
}

@end
