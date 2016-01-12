//
//  RootViewController.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RootViewController.h"
#import "ServerConfig.h"
#import <RongIMKit/RongIMKit.h>
#import "ShareValue.h"
#import "BaseViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.translucent=NO;
    self.tabBar.tintColor=[UIColor colorWithRed:201/255.0 green:32/255.0 blue:115/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:201/255.0 green:32/255.0 blue:115/255.0 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self addMiddleBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadCountChanged:) name:@"unread" object:nil];
    //未读消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadCountChanged:) name:NOTIFICATION_UNREAD_CIRCLEMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadCountChanged:) name:NOTIFICATION_UNREAD_LASTVISITMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadCountChanged:) name:NOTIFICATION_UNREAD_SYSTEMMESSAGE object:nil];
    
}
-(void)addMiddleBtn{
    CGRect bounds = self.tabBar.bounds;
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(bounds.size.width/2-25,0, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"tab_middle2.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btn];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 1)];
    view.backgroundColor=[UIColor colorWithRed:201/255.0 green:32/255.0 blue:115/255.0 alpha:1.0];
    [self.tabBar insertSubview:view atIndex:0];

    
}
-(void)goNext:(UIButton*)sender{
    self.selectedIndex=2;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITabBarItem * item1=[self.tabBar.items objectAtIndex:0];
    [item1 setImage:[[UIImage imageNamed:@"tab_home.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * item2=[self.tabBar.items objectAtIndex:1];
    [item2 setImage:[[UIImage imageNamed:@"icon_near.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * item4=[self.tabBar.items objectAtIndex:3];
    [item4 setImage:[[UIImage imageNamed:@"tab_discovery.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * item5=[self.tabBar.items objectAtIndex:4];
    [item5 setImage:[[UIImage imageNamed:@"icon_message.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
/**
 *  更新左上角未读消息数
 */
-(void)unreadCountChanged:(NSNotification*)noti{
//    NSNumber * num =noti.object;
    [self notifyUpdateUnreadMessageCount];
}
- (void)notifyUpdateUnreadMessageCount {
    //消息
    //IM消息未读
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    //系统消息
    int messageCount =0;
    int systemMessageCount=[[ShareValue shareInstance].systemMessage intValue];
    messageCount =count+systemMessageCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITabBarItem * item =[__weakself.tabBar.items objectAtIndex:4];
        if (messageCount==0) {
             item.badgeValue=nil;
        }else{
             item.badgeValue=[NSString stringWithFormat:@"%d",messageCount];
        }
       
    });
    //发现
    //好友圈
    //最近访客
    GetNearlyVisitCountRequest * request =[[GetNearlyVisitCountRequest alloc]init];
    request.created=[ShareValue shareInstance].lastVisitDate;
    [SystemAPI GetNearlyVisitCountRequest:request success:^(id data) {
        int discoveryCount=0;
        int circleMessageCount =[[ShareValue shareInstance].circleMessage intValue];
        NSDictionary * dic =(NSDictionary*)data;
        NSString * str=[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
        int lastVisitCount =[str integerValue];
        discoveryCount=lastVisitCount+circleMessageCount+[[ShareValue shareInstance].lastVisitMessage intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            UITabBarItem * item =[__weakself.tabBar.items objectAtIndex:3];
            if (discoveryCount==0) {
                item.badgeValue=nil;
            }else{
                item.badgeValue=[NSString stringWithFormat:@"%d",discoveryCount];
            }
            
        });
        [UIApplication sharedApplication].applicationIconBadgeNumber=messageCount+discoveryCount;
        //created
    } fail:^(BOOL notReachable, NSString *desciption) {
       
    }];
    
}

@end
