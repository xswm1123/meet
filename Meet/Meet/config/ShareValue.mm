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
@end
