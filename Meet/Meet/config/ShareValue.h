//
//  ShareValue.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUserInfo.h"
#import "NSDictionary+XNSDictionaryToNSObject.h"
#import <MapKit/MapKit.h>
#import <RongIMKit/RongIMKit.h>
/**
 *  用来存取应用使用的临时或者长久的变量或数据
 */
@interface ShareValue : NSObject
/**
 *  创建单例
 *
 *  @return 返回一个ShareValue单例
 */
+(ShareValue*)shareInstance;
@property(nonatomic,strong) LMUserInfo * userInfo;//用户
@property (nonatomic,strong) NSString * coverUrl;//朋友圈封面地址
@property(nonatomic,assign) CLLocationCoordinate2D currentLocation;//当前经纬度
@property(nonatomic,strong) NSString *address;//当前地址
@property(nonatomic,strong) NSString * detailAddress;//当前详细地址
@property(nonatomic,strong) NSString *city;//当前城市
@property(nonatomic,strong) NSString * province;//当前省份
@property(nonatomic,strong) NSArray * allCitys;//所有城市列表
@property(nonatomic,strong,readonly) NSString * cityId;//当前城市ID
@property(nonatomic,assign) BOOL isUsedGesturePassword;//是否使用手势密码
@property(nonatomic,strong) NSString * displayVersion;//当前版本
@property(nonatomic,strong) NSNumber * lastVisitCount;//最近来访人数
@property(nonatomic,strong) NSString * lastVisitDate;//最近来访时间
@property(nonatomic,strong) NSNumber * circleMessage;//好友圈消息个数数组
@property(nonatomic,strong) NSNumber * systemMessage;//系统消息个数数组
@property(nonatomic,strong) NSNumber * lastVisitMessage;//最近访客个数数组
@property(nonatomic,strong) NSDictionary * postMessage;//最新发的朋友圈
@property(nonatomic,strong) NSMutableArray * goldNotis;//领取金币通知
@property(nonatomic,assign) BOOL is10Mins;
@property(nonatomic,assign) BOOL is30Mins;
@property(nonatomic,assign) BOOL is60Mins;
@property(nonatomic,assign) BOOL is120Mins;
@property(nonatomic,assign) BOOL isDownloadQQ;
@property(nonatomic,assign) BOOL isDownloadMOMO;
@property(nonatomic,strong) NSString * session;
@property(nonatomic,strong) NSNumber * timeDiff;//
/**
 *  融云信息
 */
@property(nonatomic,strong) RCUserInfo *RCUser;//用户信息
@property(nonatomic,copy) NSString * userToken;//用户的token
@property(nonatomic,copy) NSString * password;//用户密码
@end
