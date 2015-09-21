//
//  AppDelegate.h
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
 #import <BaiduMapAPI/BMapKit.h>
#import "MapUtils.h"
#import <RongIMKit/RongIMKit.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "WXApi.h"
#import "GeTuiSdk.h"
#import "LanuchAdsManager.h"

#define UmengAppkey @"55272ee8fd98c5f4db000fab"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,GeTuiSdkDelegate>
{
    BMKMapManager* mapManager;
    CLLocationManager   *managerLocate;
    GeTuiSdk * geTui;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) UIView * launchView;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

