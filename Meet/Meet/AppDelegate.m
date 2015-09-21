//
//  AppDelegate.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerConfig.h"
#import "ShareValue.h"
#import "BaseViewController.h"
#import "GesturePasswordController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"
#import "payRequsestHandler.h"
#import "BaiduMobStat.h"

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize launchView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //umeng
    [self addThirdPart];
    //baidu analyse
    [self startBaiduMobStat];
    /**
     *  地图定位授权
     */
    [self getLocateAuthorization];
    
    /**
     加载第三方SDK
     */
    [self loadThirdPart];
    /**
     去掉空cell底部的分割线
     */
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [[UITableView appearance] setTableFooterView:view];
    /**
     *  获取城市列表保存
     */
    [self getAllCitysList];
    //初始化融云SDK，
    [[RCIM sharedRCIM] initWithAppKey:RIM_KEY ];
    //设置会话列表头像和会话界面头像
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
//    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    [RCIM sharedRCIM].globalNavigationBarTintColor=iconRed;
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    
    //设置用户信息源和群组信息源
//    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
//    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    /**
     *  处理登录授权相关的信息
     */
    /**
     *  判断是否登录
     */
    if ([ShareValue shareInstance].userInfo.mobile.length>0) {
        //不管token如何  只要是登录过的，直接启动默认页面
            UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController=sb.instantiateInitialViewController;
            /**
             *  开启手势密码
             */
            [self launchGesturePassword];
        [RCIMClient sharedRCIMClient].currentUserInfo = [ShareValue shareInstance].RCUser;
        [[RCIM sharedRCIM] connectWithToken:[ShareValue shareInstance].userInfo.rongToken
                                    success:^(NSString *userId) {
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                            self.window.rootViewController=sb.instantiateInitialViewController;
//                                            /**
//                                             *  开启手势密码
//                                             */
//                                            [self launchGesturePassword];
//                                        });
                                        [[RCIM sharedRCIM]
                                         refreshUserInfoCache:[ShareValue shareInstance].RCUser
                                         withUserId:[ShareValue shareInstance].RCUser.userId];
                                        //登陆demoserver成功之后才能调demo 的接口
                                        [RCDDataSource syncGroups];
                                        [RCDDataSource syncFriendList:^(NSMutableArray * result) {
                                            
                                        }];
                                        
                                        [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
                                            for (NSString *userID in blockUserIds) {
                                                
                                                // 暂不取用户信息，界面展示的时候在获取
                                                RCUserInfo*userInfo = [[RCUserInfo alloc]init];
                                                userInfo.userId = userID;
                                                userInfo.portraitUri = nil;
                                                userInfo.name = nil;
                                                [[RCDataBaseManager shareInstance] insertBlackListToDB:userInfo];
                                            }
                                            
                                        } error:^(RCErrorCode status) {
                                            NSLog(@"同步黑名单失败，status = %ld",(long)status);
                                        }];
                                        //设置当前的用户信息
                                        
                                        //同步群组
                                        //调用connectWithToken时数据库会同步打开，不用再等到block返回之后再访问数据库，因此不需要这里刷新
                                        //这里仅保证之前已经成功登陆过，如果第一次登陆必须等block 返回之后才操作数据
                                        }
                                      error:^(RCConnectErrorCode status) {
                                          [RCIMClient sharedRCIMClient].currentUserInfo = [ShareValue shareInstance].RCUser;
//                                          [RCDDataSource syncGroups];
                                          NSLog(@"connect error %ld", (long)status);
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                              self.window.rootViewController=sb.instantiateInitialViewController;
//                                              /**
//                                               *  开启手势密码
//                                               */
//                                              [self launchGesturePassword];
//                                          });
                                      }
                             tokenIncorrect:^{
                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                     UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                                     self.window.rootViewController=sb.instantiateInitialViewController;
//                                     /**
//                                      *  开启手势密码
//                                      */
//                                     [self launchGesturePassword];
                                     UIAlertView *alertView =
                                     [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Token已过期，请重新登录"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                                     ;
                                     [alertView show];
                                 });
                             }];
    }else{
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.window.rootViewController=sb.instantiateInitialViewController;
        /**
         *  开启手势密码
         */
        [self launchGesturePassword];
    }
    /**
     *  处理通知和消息
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [self.window makeKeyAndVisible];
    /**
     *  加载广告
     */
        [self loadLanuchImageFromDoc];
    return YES;
}
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    // [3]:向个推服务器注册deviceToken
    
    [GeTuiSdk registerDeviceToken:token];
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error

{
    
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    
    [GeTuiSdk registerDeviceToken:@""];
    
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}


-(void)loadThirdPart{
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:BaiduMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
-(void)getAllCitysList{
    //开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GetAllCitysRequest * request=[[GetAllCitysRequest alloc]init];
        [SystemAPI GetAllCitysRequest:request success:^(GetAllCitysResponse *response) {
            [ShareValue shareInstance].allCitys=(NSArray*)response.data;
        } fail:^(BOOL notReachable, NSString *desciption) {
            
        }];
    });
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
    // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];

}
- (void)redirectNSlogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        [self.window.rootViewController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
            [self.window.rootViewController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Token已过期，请重新登录"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
            ;
            [alertView show];
        });
    }else if (status==ConnectionStatus_Unconnected){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的当前网络状态不佳，请重新连接或登录相遇！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
        NSLog(@"onRCIMReceiveMessage");
        NSLog(@"RCMessage:%@",message.content);
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    NSNumber  * num=[NSNumber numberWithInt:count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unread" object:num];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
-(void)addThirdPart{
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxe00f626e25bd0b41" appSecret:@"40eb9f3c30cf2f3676b675e9521d9007" url:@"http:www.immet.cm"];
    //    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"1104258257" appKey:@"beHPi4p5oFxRPsAK " url:@"http:www.immet.cm"];
     [UMSocialQQHandler setQQWithAppId:@"1104785801" appKey:@"QKYDNiGyyyirzWsk " url:@"http:www.immet.cm"];
    //个推
    [GeTuiSdk startSdkWithAppId:GeTui_kAppId appKey:GeTui_kAppKey appSecret:GeTui_kAppSecret delegate:self error:nil];
    
    //[1-2]:设置是否后台运行开关
    
    [GeTuiSdk runBackgroundEnable:YES];
    
    //[1-3]:设置地理围栏功能，开启LBS定位服务和是否允许SDK 弹出用户定位请求，请求NSLocationAlwaysUsageDescription权限,如果UserVerify设置为NO，需第三方负责提示用户定位授权。
    
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    //注册微信
    [WXApi registerApp:WeiChatKey withDescription:@"demo 2.0"];
}
#pragma  注册远程推送
- (void)registerRemoteNotification
{
    // IOS8
    if(IOS8_OR_LATER)
    {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
        
    }
    // IOS7与之前版本
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
#pragma 个推代理
//注册成功后，得到CID
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId  // SDK 返回clientid

{
    
    // [4-EXT-1]: 个推SDK已注册，返回clientId

    NSLog(@"GeTuiSdkDidRegisterClient:%@",clientId);
//        [GeTuiSdk registerDeviceToken:_deviceToken];
    
}
-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId

{
    
    // [4]: 收到个推消息
    
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
    
    NSString *payloadMsg = nil;
    
    if (payload) {
        
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                      
                                              length:payload.length
                      
                                            encoding:NSUTF8StringEncoding];
        
    }
    NSLog(@"payloadMsg:%@",payloadMsg);
}
//失败后
 - (void) GeTuiSdkDidOccurError:(NSError *)error{
    NSLog(@"GeTuiError:%@",error);
}
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    
    // [4-EXT]:发送上行消息结果反馈
    
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"record:%@",record);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService  applicationDidBecomeActive];
    application.applicationIconBadgeNumber = 0;
    /**
     *  开启定位
     *
     */
    [[MapUtils shareInstance]startLocationUpdate];
    /**
     *  开启手势密码
     */
    [self launchGesturePassword];
    //更新个人信息
    [self updatePersonalInfo];
    [self loadLastVisitCount];
}
-(void)loadLastVisitCount{
    GetLastVisitUsersRequest * request=[[GetLastVisitUsersRequest alloc]init];
    [SystemAPI GetLastVisitUsersRequest:request
                                success:^(GetLastVisitUsersResponse *response) {
                                    NSArray * arr =[NSArray arrayWithArray:(NSArray*)response.data];
                                    NSNumber * num=[NSNumber numberWithInteger:arr.count];
                                    [ShareValue shareInstance].lastVisitCount=num;
                                } fail:^(BOOL notReachable, NSString *desciption) {
                                    
                                }];

}
-(void)updatePersonalInfo{
    GetPersonalInfoRequest * request =[[GetPersonalInfoRequest alloc]init];
    request.memberId=[ShareValue shareInstance].userInfo.id;
    [SystemAPI GetPersonalInfoRequest:request
                              success:^(GetPersonalInfoResponse *response) {
                                  LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:response.data];
                                  [ShareValue shareInstance].userInfo=user;
                              } fail:^(BOOL notReachable, NSString *desciption) {
                                  NSLog(@"更新个人信息失败!");
                              }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

-(void)launchGesturePassword{
    if ([ShareValue shareInstance].isUsedGesturePassword) {
        GesturePasswordController * vc =[[GesturePasswordController alloc]init];
        vc.flag=1;
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "X.Meet" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Meet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Meet.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
/**
 *  定位授权
 */
-(void)getLocateAuthorization
{
    if (IOS8_OR_LATER && managerLocate==nil)
    {
        managerLocate=[[CLLocationManager alloc]init];
        [managerLocate requestWhenInUseAuthorization];
    }
    managerLocate.pausesLocationUpdatesAutomatically=NO;
}
/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
     */
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.adid=[ShareValue shareInstance].userInfo.mobile;
    [statTracker startWithAppId:BaiDu_statistics]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}
-(void)loadLanuchImageFromDoc{
//    launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
////    _launchView=[[UIView alloc]init];
//    launchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        imageV.image=[UIImage imageNamed:@"advert.jpg"];
//    [launchView addSubview:imageV];
//    [self.window addSubview:launchView];
//    [self.window bringSubviewToFront:launchView];
//    [NSThread sleepForTimeInterval:5.0];
//     [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
    [[LanuchAdsManager defaultMonitor] showAdAtPath:nil
                             onView:self.window.rootViewController.view
                       timeInterval:30.
                   detailParameters:@{}];
}
#pragma mark - 移除广告View
-(void)removeADView
{
    [launchView removeFromSuperview];
}
@end