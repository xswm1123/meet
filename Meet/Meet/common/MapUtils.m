//
//  MapUtils.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/20.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MapUtils.h"
#import "BaseViewController.h"
static MapUtils * _Maputils;
@implementation MapUtils
+(MapUtils *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _Maputils = [[MapUtils alloc]init];
    });
    return _Maputils;
}
-(id)init{
    self = [super init];
    if (self) {
        self.locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
        self.geoCodesearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodesearch.delegate = self;
        self.locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        self.geoCoder=[[CLGeocoder alloc]init];
    }
    return self;
}
-(void)startLocationUpdate
{
//    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter=1;
            NSString *message = [NSString stringWithFormat:@" 我们需要采集您的定位信息,请在[设置]中打开定位服务,以确保定位准确性。"];
            // IOS8
            if (IOS8_OR_LATER)
            {
                if ([CLLocationManager authorizationStatus] < kCLAuthorizationStatusAuthorized)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag=300;
//                    [alert show];
                }
            }
            // IOS8以前
            else
            {
                if ([CLLocationManager authorizationStatus] < kCLAuthorizationStatusAuthorized)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=300;
//                    [alert show];
                }
            }
    [_locationManager startUpdatingLocation];
//    [_locationService startUserLocationService];
//    [[AppDelegate shareAppdelegate].managerLocate startMonitoringSignificantLocationChanges];
}
/**
 *  CLLocation Manager
 *
 *  @param manager
 *  @param locations
 */
-(void)stopLocationUpdate{
    [_locationManager stopUpdatingLocation];
}

#pragma CLLocation
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    CLLocation * location=[locations lastObject];
    if (location.horizontalAccuracy < 200 && location.horizontalAccuracy != -1){
        
        
        NSLog(@"latiude==%f,longtiude===%f",location.coordinate.latitude,location.coordinate.longitude);
       
        /**
         *  定位成功以后，转换经纬坐标，GEO反转
         */
        CLLocation * marsLocation=[self.locationManager.location locationMarsFromEarth];
        CLLocation * baiduLocation=[marsLocation locationBaiduFromMars];
//        [ShareValue shareInstance].currentLocation=baiduLocation.coordinate;
        [ShareValue shareInstance].currentLocation=marsLocation.coordinate;
         [self startGeoCodeSearch];
        ChangeCurrentLocationRequest * request=[[ChangeCurrentLocationRequest alloc]init];
        [SystemAPI ChangeCurrentLocationRequest:request success:^(ChangeCurrentLocationResponse *response) {
            NSLog(@"地址位置更新：%@",response.message);
        } fail:^(BOOL notReachable, NSString *desciption) {
            
        }];

        [self.geoCoder reverseGeocodeLocation: baiduLocation completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             //Get nearby address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //String to hold address
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSLog(@"我在：%@",locatedAt);
             [ShareValue shareInstance].city=placemark.locality;
         }];
    } else {
        [self.locationManager stopUpdatingLocation];	 //停止获取
        [NSThread sleepForTimeInterval:0.5]; //阻塞10秒
        [self.locationManager startUpdatingLocation];	//重新获取
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败！failure！~");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==300) {
        if (buttonIndex==1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        }
    }
    
    
}
-(void)startLocationUpdateForBackgroud
{
    [_locationService startUserLocationService];
    /**
     *  后台定位s
     */
//    [[AppDelegate shareAppdelegate].managerLocate startMonitoringSignificantLocationChanges];
}

-(void)startGeoCodeSearch{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = [ShareValue shareInstance].currentLocation;
    BOOL flag = [_geoCodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
     
    }
    
}


#pragma mark -
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_WILLUPDATE object:nil];
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"定位成功");
        [_locationService stopUserLocationService];
    
    [ShareValue shareInstance].currentLocation = userLocation.location.coordinate;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_UPDATERROR object:nil];
}


/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCodeZ
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error) {

    }else{
        /**
         *  详细地址
         */
        NSString * province=result.addressDetail.province;
        NSString * city=result.addressDetail.city;
        NSString * district=result.addressDetail.district;
        NSString * street=result.addressDetail.streetName;
        NSString * number=result.addressDetail.streetNumber;
        NSString * detalAddress= [NSString stringWithFormat:@"%@%@%@%@%@",province,city,district,street,number.length>0?number:@""];
        [ShareValue shareInstance].province=province;
        [ShareValue shareInstance].city=city;
        [ShareValue shareInstance].detailAddress =detalAddress;
        [ShareValue shareInstance].address=result.addressDetail.streetName;
        NSLog(@"address:%@,%@,%@,%@,%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber);
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_UPDATED object:[ShareValue shareInstance].address];
          }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CITY_UPDATED object:[ShareValue shareInstance].city];
}

@end
