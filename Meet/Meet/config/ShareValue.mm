//
//  ShareValue.m
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ShareValue.h"

#define SET_USER @"SET_USER"
#define SET_CURRENTLOCATION @"SET_CURRENTLOCATION"
#define SET_ADDRESS @"SET_ADDRESS"
#define SET_CITY @"SET_CITY"
#define SET_DETAILADDRESS @"SET_DETAILADDRESS"
#define SET_ALLCITYS @"SET_ALLCITYS"
#define SET_CITYID @"SET_CITYID"
#define SET_COVERURL @"SET_COVERURL"
#define SET_ISUSEDGESTUREPASSWORD @"SET_ISUSEDGESTUREPASSWORD"
#define SET_RCMUSER @"SET_RCMUSER"
#define SET_USERTOKEN @"SET_USERTOKEN"
#define SET_PASSWORD @"SET_PASSWORD"
#define SET_PROVINCE @"SET_PROVINCE"
#define SET_LASTVISIT @"SET_LASTVISIT"
#define SET_LASTDATE @"SET_LASTDATE"
#define SET_CIRCLEMESSAGE @"SET_CIRCLEMESSAGE"
#define SET_SYSTEMMESSAGE @"SET_SYSTEMMESSAGE"
#define SET_LASTVISITMESSAGE @"SET_LASTVISITMESSAGE"
#define SET_GOLDNOTIS @"SET_GOLDNOTIS"
#define SET_IS10MINS @"SET_IS10MINS"
#define SET_IS30MINS @"SET_IS30MINS"
#define SET_IS60MINS @"SET_IS60MINS"
#define SET_IS120MINS @"SET_IS120MINS"
#define SET_POSTMESSAGE @"SET_POSTMESSAGE"
#define SET_ISDOWNLOADQQ @"SET_ISDOWNLOADQQ"
#define SET_ISDOWNLOADMOMO @"SET_ISDOWNLOADMOMO"
#define SET_SESSION @"SET_SESSION"
#define SET_TIMEDIFF @"SET_TIMEDIFF"

static ShareValue * _shareValue;
@implementation ShareValue
/**
 *dispatch_once创建单例，保证代码只执行一次
 *
 *  @return 返回一个ShareValue单例
 */
+(ShareValue *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareValue=[[ShareValue alloc]init];
    });
    return _shareValue;
}
-(void)setUserInfo:(LMUserInfo *)userInfo{
    if (!userInfo) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_USER];
    }else{
        NSDictionary* dic=userInfo.lkDictionary;
        
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:SET_USER];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(LMUserInfo *)userInfo{
    NSDictionary * dic= [[NSUserDefaults standardUserDefaults]objectForKey:SET_USER];
    LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:dic];
     return user;
}
-(void)setCurrentLocation:(CLLocationCoordinate2D)currentLocation{
    if (currentLocation.latitude==0&currentLocation.longitude==0) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_CURRENTLOCATION];
    }else{
        double lat=currentLocation.latitude;
        double lon=currentLocation.longitude;
        [[NSUserDefaults standardUserDefaults]setDouble:lat forKey:@"lat"];
        [[NSUserDefaults standardUserDefaults]setDouble:lon forKey:@"lon"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(CLLocationCoordinate2D)currentLocation{
    CLLocationCoordinate2D coor;
    coor.latitude=[[NSUserDefaults standardUserDefaults] doubleForKey:@"lat"];
    coor.longitude=[[NSUserDefaults standardUserDefaults] doubleForKey:@"lon"];
    return coor;
}
-(void)setAddress:(NSString *)address{
    if (!address) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_ADDRESS];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:address forKey:SET_ADDRESS];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)address{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_ADDRESS];
}
-(void)setCity:(NSString *)city{
    if (!city) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_CITY];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:city forKey:SET_CITY];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)city{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_CITY];
}
-(void)setProvince:(NSString *)province{
    if (!province) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_PROVINCE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:province forKey:SET_PROVINCE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)province{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_PROVINCE];
}

-(void)setDetailAddress:(NSString *)detailAddress{
    if (!detailAddress) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_DETAILADDRESS];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:detailAddress forKey:SET_DETAILADDRESS];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)detailAddress{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_DETAILADDRESS];

}
-(void)setAllCitys:(NSArray *)allCitys{
    if (!allCitys) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_ALLCITYS];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:allCitys forKey:SET_ALLCITYS];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)allCitys{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_ALLCITYS];
}
-(NSString *)cityId{
    NSString * cityID=[[NSString alloc]init];
//    NSArray * arr=[self.city componentsSeparatedByString:@"市"];
//    NSString * cityName=[arr firstObject];
    NSArray * parr=[self.province componentsSeparatedByString:@"省"];
    NSString * provinceName=[parr firstObject];
    for (int i=0; i<self.allCitys.count; i++) {
        NSDictionary * dic=[self.allCitys objectAtIndex:i];
        NSArray * list=[dic objectForKey:@"list"];
        for (NSDictionary * cdic in list) {
            NSString * name=[cdic objectForKey:@"name"];
            if ([name isEqualToString:self.city]||[name isEqualToString:provinceName]) {
                cityID=[cdic objectForKey:@"id"];
                return cityID;
            }
        }
    }
    return cityID;
}
-(void)setCoverUrl:(NSString *)coverUrl{
    if (!coverUrl) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_COVERURL];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:coverUrl forKey:SET_COVERURL];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(NSString *)coverUrl{
     return [[NSUserDefaults standardUserDefaults]objectForKey:SET_COVERURL];
}
-(void)setIsUsedGesturePassword:(BOOL)isUsedGesturePassword{
    
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_COVERURL];
        NSString * isUsed;
    if (!isUsedGesturePassword) {
        isUsed=@"0";
    }
    if (isUsedGesturePassword) {
        isUsed=@"1";
    }
        [[NSUserDefaults standardUserDefaults]setObject:isUsed forKey:SET_ISUSEDGESTUREPASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isUsedGesturePassword{
    NSString * isUsed =[[NSUserDefaults standardUserDefaults]objectForKey:SET_ISUSEDGESTUREPASSWORD];
    if ([isUsed isEqualToString:@"0"]) {
        return NO;
    }
    if ([isUsed isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
//-(void)setRCUser:(RCUserInfo *)RCUser{
//    if (!RCUser) {
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_RCMUSER];
//    }else{
//        NSDictionary* dic=RCUser.lkDictionary;
//        
//        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:SET_RCMUSER];
//    }
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}
-(RCUserInfo *)RCUser{
//     NSDictionary * dic= [[NSUserDefaults standardUserDefaults]objectForKey:SET_RCMUSER];
//    RCUserInfo *  user= [[RCUserInfo alloc]initWithUserId:[dic objectForKey:@"userId"] name:[dic objectForKey:@"name"] portrait:[dic objectForKey:@"portraitUri"]];
    RCUserInfo * user=[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",self.userInfo.id] name:self.userInfo.nickname portrait:self.userInfo.avatar];
    return user;
}
-(void)setUserToken:(NSString *)userToken{
    if (!userToken) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_USERTOKEN];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:SET_USERTOKEN];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)userToken{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_USERTOKEN];
}
-(void)setPassword:(NSString *)password{
    if (!password) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_PASSWORD];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:password forKey:SET_PASSWORD];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)password{
     return [[NSUserDefaults standardUserDefaults]objectForKey:SET_PASSWORD];
}
-(NSString *)displayVersion{
    NSString *key = (NSString *)kCFBundleVersionKey;
    //加载程序中的info.plist
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[key];

    return currentVersionCode;
}
-(NSNumber *)lastVisitCount{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_LASTVISIT];
}
-(void)setLastVisitCount:(NSNumber *)lastVisitCount{
    if (!lastVisitCount) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_LASTVISIT];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:lastVisitCount forKey:SET_LASTVISIT];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setLastVisitDate:(NSString *)lastVisitDate{
    if (!lastVisitDate) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_LASTDATE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:lastVisitDate forKey:SET_LASTDATE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)lastVisitDate{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_LASTDATE];
}
/**
 *  未读消息处理
 */
-(void)setCircleMessage:(NSNumber *)circleMessage{
    if (!circleMessage) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_CIRCLEMESSAGE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:circleMessage forKey:SET_CIRCLEMESSAGE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber *)circleMessage{
     return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_CIRCLEMESSAGE];
}
-(void)setSystemMessage:(NSNumber *)systemMessage{
    if (!systemMessage) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_SYSTEMMESSAGE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:systemMessage forKey:SET_SYSTEMMESSAGE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber *)systemMessage{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_SYSTEMMESSAGE];
}
-(void)setLastVisitMessage:(NSNumber *)lastVisitMessage{
    if (!lastVisitMessage) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_LASTVISITMESSAGE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:lastVisitMessage forKey:SET_LASTVISITMESSAGE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSNumber *)lastVisitMessage{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_LASTVISITMESSAGE];
}
-(NSMutableArray *)goldNotis{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_GOLDNOTIS];
}
-(void)setGoldNotis:(NSMutableArray *)goldNotis{
    if (!goldNotis) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_GOLDNOTIS];
    }else{
        NSMutableArray * archiveArray=[NSMutableArray arrayWithCapacity:goldNotis.count];
        for (UILocalNotification *personObject in goldNotis) {
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:personObject];
            [archiveArray addObject:personEncodedObject];
        }
        [[NSUserDefaults standardUserDefaults]setObject:archiveArray forKey:SET_GOLDNOTIS];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setIs10Mins:(BOOL)is10Mins{
    NSString * isUsed;
    if (!is10Mins) {
        isUsed=@"0";
    }
    if (is10Mins) {
        isUsed=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isUsed forKey:SET_IS10MINS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)is10Mins{
    NSString * isUsed =[[NSUserDefaults standardUserDefaults]objectForKey:SET_IS10MINS];
    if ([isUsed isEqualToString:@"0"]) {
        return NO;
    }
    if ([isUsed isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(void)setIs30Mins:(BOOL)is30Mins{
    NSString * isUsed;
    if (!is30Mins) {
        isUsed=@"0";
    }
    if (is30Mins) {
        isUsed=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isUsed forKey:SET_IS30MINS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)is30Mins{
    NSString * isUsed =[[NSUserDefaults standardUserDefaults]objectForKey:SET_IS30MINS];
    if ([isUsed isEqualToString:@"0"]) {
        return NO;
    }
    if ([isUsed isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(void)setIs60Mins:(BOOL)is60Mins{
    NSString * isUsed;
    if (!is60Mins) {
        isUsed=@"0";
    }
    if (is60Mins) {
        isUsed=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isUsed forKey:SET_IS60MINS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)is60Mins{
    NSString * isUsed =[[NSUserDefaults standardUserDefaults]objectForKey:SET_IS60MINS];
    if ([isUsed isEqualToString:@"0"]) {
        return NO;
    }
    if ([isUsed isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

-(void)setIs120Mins:(BOOL)is120Mins{
    NSString * isUsed;
    if (!is120Mins) {
        isUsed=@"0";
    }
    if (is120Mins) {
        isUsed=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isUsed forKey:SET_IS120MINS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)is120Mins{
    NSString * isUsed =[[NSUserDefaults standardUserDefaults]objectForKey:SET_IS120MINS];
    if ([isUsed isEqualToString:@"0"]) {
        return NO;
    }
    if ([isUsed isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(void)setPostMessage:(NSDictionary *)postMessage{
    if (!postMessage) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_POSTMESSAGE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:postMessage forKey:SET_POSTMESSAGE];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary *)postMessage{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:SET_POSTMESSAGE];
}
-(void)setIsDownloadQQ:(BOOL)isDownloadQQ{
    NSString * isDown;
    if (!isDownloadQQ) {
        isDown=@"0";
    }
    if (isDownloadQQ) {
        isDown=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isDown forKey:SET_ISDOWNLOADQQ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isDownloadQQ{
    NSString * isDown =[[NSUserDefaults standardUserDefaults]objectForKey:SET_ISDOWNLOADQQ];
    if ([isDown isEqualToString:@"0"]) {
        return NO;
    }
    if ([isDown isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(void)setIsDownloadMOMO:(BOOL)isDownloadMOMO
{
    NSString * isDown;
    if (!isDownloadMOMO) {
        isDown=@"0";
    }
    if (isDownloadMOMO) {
        isDown=@"1";
    }
    [[NSUserDefaults standardUserDefaults]setObject:isDown forKey:SET_ISDOWNLOADMOMO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isDownloadMOMO{
    NSString * isDown =[[NSUserDefaults standardUserDefaults]objectForKey:SET_ISDOWNLOADMOMO];
    if ([isDown isEqualToString:@"0"]) {
        return NO;
    }
    if ([isDown isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(void)setSession:(NSString *)session{
    if (!session) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_SESSION];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:session forKey:SET_SESSION];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_SESSION];
}
-(NSNumber *)timeDiff{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_TIMEDIFF];
}
-(void)setTimeDiff:(NSNumber *)timeDiff{
    if (!timeDiff) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_TIMEDIFF];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:timeDiff forKey:SET_TIMEDIFF];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
