//
//  MapUtils.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/20.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
#import "ServerConfig.h"
#import "ShareValue.h"
#import "CLLocation+YCLocation.h"

#define NOTIFICATION_LOCATION_WILLUPDATE @"NOTIFICATION_LOCATION_WILLUPDATE"
#define NOTIFICATION_LOCATION_UPDATED @"NOTIFICATION_LOCATION_UPDATED"
#define NOTIFICATION_LOCATION_UPDATERROR @"NOTIFICATION_LOCATION_UPDATERROR"
#define NOTIFICATION_ADDRESS_UPDATED @"NOTIFICATION_ADDRESS_UPDATED"
#define NOTIFICATION_ADDRESS_UPDATEERROR @"NOTIFICATION_ADDRESS_UPDATEERROR"


@interface MapUtils : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) BMKLocationService *locationService;
@property(nonatomic,strong) BMKGeoCodeSearch *geoCodesearch;
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,strong) CLGeocoder  * geoCoder;

+(MapUtils *)shareInstance;

-(void)startLocationUpdate;//开始定位
-(void)startGeoCodeSearch;//开始反编码

-(void)startLocationUpdateForBackgroud;//开始定位
-(void)stopLocationUpdate;//开始定位
@end
