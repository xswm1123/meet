//
//  LMUserInfo.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUserInfo : NSObject
@property(nonatomic,strong) NSString * id;//用户ID
@property(nonatomic,strong) NSString * meetid;//相遇ID
@property(nonatomic,strong) NSString * mobile;//手机号码
@property(nonatomic,strong) NSString * recommendId;//推荐人ID
@property(nonatomic,strong) NSString * letter;//昵称首字母
@property(nonatomic,strong) NSString * avatar;//头像
@property(nonatomic,strong) NSString * video;//视频介绍
@property(nonatomic,strong) NSString * videoPic;//视频介绍截图
@property(nonatomic,strong) NSString * circlePic;//朋友圈封面
@property(nonatomic,strong) NSString * nickname;//昵称
@property(nonatomic,strong) NSString * birthday;//生日
@property(nonatomic,strong) NSString * constellation;//星座
@property(nonatomic,strong) NSString * age;//年龄
@property(nonatomic,strong) NSString * address;//所在地
@property(nonatomic,strong) NSString * sex;//性别：1、男2、女
@property(nonatomic,strong) NSString * sign;//个性签名
@property(nonatomic,strong) NSString * affection;//情感状态
@property(nonatomic,strong) NSString * appearance;//外貌特征
@property(nonatomic,strong) NSString * profession;//从事职业
@property(nonatomic,strong) NSString * hobby;//兴趣爱好
@property(nonatomic,strong) NSString * type;//用户类型：1、普通用户2、VIP
@property(nonatomic,strong) NSString * expired;//会员到期日期
@property(nonatomic,assign) BOOL isStore;//是否商家
@property(nonatomic,strong) NSString * gold;//金币数量
@property(nonatomic,strong) NSString * meili;//魅力值
@property(nonatomic,strong) NSString * level;//用户等级
@property(nonatomic,strong) NSString * onlineTime;//在线时长（小时）
@property(nonatomic,strong) NSString * totalPay;//总消费
@property(nonatomic,strong) NSString * groupNum;//可创建的群组数量
@property(nonatomic,assign) double lng;//经度
@property(nonatomic,assign) double lat;//纬度
@property(nonatomic,strong) NSString * zanNum;//被点赞的次数
@property(nonatomic,strong) NSString * rongToken;//连接融云的token
@property(nonatomic,assign) BOOL  isReceivedVip;//是否领取过vip
@property(nonatomic,strong) NSString * continueLoginCount;//连续登录天数
@property(nonatomic,strong) NSString * token;//
@property(nonatomic,strong) NSString * weixinOpenid;//
@property(nonatomic,strong) NSString * qqOpenid;//
@property(nonatomic,assign) BOOL isShare;//是否分享过

-(instancetype)initWithDictionary:(NSDictionary*) dictionary;
@end
