//
//  LMUserInfo.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "LMUserInfo.h"

@implementation LMUserInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.id = dictionary[@"id"];
        _meetid=dictionary[@"meetid"];
         _mobile=dictionary[@"mobile"];
         _recommendId=dictionary[@"recommendId"];
         _letter=dictionary[@"letter"];
         _avatar=dictionary[@"avatar"];
         _video=dictionary[@"video"];
         _videoPic=dictionary[@"videoPic"];
         _circlePic=dictionary[@"circlePic"];
         _nickname=dictionary[@"nickname"];
         _birthday=dictionary[@"birthday"];
         _constellation=dictionary[@"constellation"];
        _age=dictionary[@"age"];
         _address=dictionary[@"address"];
         _sex=dictionary[@"sex"];
         _sign=dictionary[@"sign"];
         _affection=dictionary[@"affection"];
         _appearance=dictionary[@"appearance"];
         _profession=dictionary[@"profession"];
         _hobby=dictionary[@"hobby"];
         _type=dictionary[@"type"];
        _expired=dictionary[@"expired"];
         _isStore=[dictionary[@"isStore"] boolValue];
        _gold=dictionary[@"gold"];
        _meili=dictionary[@"meili"];
        _level=dictionary[@"level"];
        _onlineTime=dictionary[@"onlineTime"];
        _totalPay=dictionary[@"totalPay"];
        _groupNum=dictionary[@"groupNum"];
        _lng=[dictionary[@"lng"]doubleValue];
        _lat=[dictionary[@"lat"]doubleValue];
        _zanNum=dictionary[@"zanNum"];
        _rongToken=dictionary[@"rongToken"];
        _isReceivedVip=[dictionary[@"isReceivedVip"]boolValue];
        _continueLoginCount=dictionary[@"continueLoginCount"];
        _token=dictionary[@"token"];
        _weixinOpenid=dictionary[@"weixinOpenid"];
        _qqOpenid=dictionary[@"qqOpenid"];
        _isShare=[dictionary[@"isShare"]boolValue];
    }
    return self;
}
@end
