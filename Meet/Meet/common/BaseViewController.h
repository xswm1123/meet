//
//  BaseViewController.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilTools.h"
#import "ServerConfig.h"
#import "ShareValue.h"
#import "AppDelegate.h"
#import "CustomerControlButton.h"
#import "LeveyPopListView.h"
#import "X_BaseAPI.h"
#import "SystemAPI.h"
#import "SystemHttpResquest.h"
#import "SystemHttpResponse.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ZYQAssetPickerController.h"
#import "MWPhotoBrowser.h"
#import "MJRefresh.h"
#import "BaseView.h"
#import "BaseButton.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KxMenu.h"
#import <RongIMKit/RongIMKit.h>
#import "UIPlaceHolderTextView.h"
#import "BaseSegmentControl.h"
#import <AVFoundation/AVFoundation.h>
#import "PECropViewController.h"
#import "RootNavigationViewController.h"
//支付
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
//umeng
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#define NUMBERS @"0123456789.\n"
// production
#define kAppId           @"BnpPPhUpyg9DZWgGR9pqF7"
#define kAppKey          @"Ew5InGPblV8HK328hOnLY"
#define kAppSecret       @"y4uj2XjPCEAVw6b2ATL9H8"
#define UmengAppkey @"55272ee8fd98c5f4db000fab"
@interface BaseViewController : UIViewController<UITextFieldDelegate>
-(void)updatePersonalInfo;
@end
