//
//  ReceiveGoldViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ReceiveGoldViewController.h"

@interface ReceiveGoldViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_canGetGoldToday;
@property (weak, nonatomic) IBOutlet UILabel *lb_continedLoginDays;
@property (weak, nonatomic) IBOutlet UILabel *lb_tuiguangCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_stillTuiguangCount;
@property (weak, nonatomic) IBOutlet UIView *shareBG;
@property (weak, nonatomic) IBOutlet UILabel *icon_QQ;
@property (weak, nonatomic) IBOutlet UILabel *icon_WeChat;
@property (weak, nonatomic) IBOutlet UILabel *icon_WeChatCircle;
@property (weak, nonatomic) IBOutlet UILabel *icon_Sina;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *arrowIcons;
@property (weak, nonatomic) IBOutlet BaseButton *btn_getEveryDay;
@property (weak, nonatomic) IBOutlet BaseButton *btn_10minsGet;
@property (weak, nonatomic) IBOutlet BaseButton *btn_30minsGet;
@property (weak, nonatomic) IBOutlet BaseButton *btn_60minsGet;
@property (weak, nonatomic) IBOutlet BaseButton *btn_120minsGet;
@property (nonatomic,strong) NSDictionary * infoDic;
@end

@implementation ReceiveGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
    if (![ShareValue shareInstance].goldNotis.count>0) {
        [self notiOnFire];
    }
}
-(void)initView{
    self.btn_10minsGet.enabled=[ShareValue shareInstance].is10Mins;
    self.btn_30minsGet.enabled=[ShareValue shareInstance].is30Mins;
    self.btn_60minsGet.enabled=[ShareValue shareInstance].is60Mins;
    self.btn_120minsGet.enabled=[ShareValue shareInstance].is120Mins;
    
    self.btn_getEveryDay.enabled=NO;
    self.shareBG.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.shareBG.layer.borderWidth=1;
    self.shareBG.layer.cornerRadius=5;
    self.icon_QQ.font=[UIFont fontWithName:iconFont size:34];
    self.icon_QQ.text=@"\U0000e62e";
    self.icon_QQ.textColor=iconBlue;
    self.icon_WeChat.font=[UIFont fontWithName:iconFont size:36];
    self.icon_WeChat.text=@"\U0000e62c";
    self.icon_WeChat.textColor=iconGreen;
    self.icon_WeChatCircle.font=[UIFont fontWithName:iconFont size:34];
    self.icon_WeChatCircle.text=@"\U0000e60d";
    self.icon_WeChatCircle.textColor=iconGreen;
    self.icon_Sina.font=[UIFont fontWithName:iconFont size:36];
    self.icon_Sina.text=@"\U0000e62f";
    self.icon_Sina.textColor=iconOrange;
    for (UILabel * lb in self.arrowIcons) {
        lb.font=[UIFont fontWithName:iconFont size:18];
        lb.textColor=[UIColor whiteColor];
        lb.text=@"\U0000e639";
    }
}
-(void)notiOnFire
{
    NSMutableArray * notisArr=[NSMutableArray array];
    if (IOS8_OR_LATER)
    {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"确定";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"取消";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        
        //4.注册推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    //    #endif
    int currentTime=[self utilTime];
    //10mins
            int timeInterval=[self intervalBetweenNow:currentTime withSignTime:0*60];
            UILocalNotification* Bnot=[[UILocalNotification alloc]init];
            [Bnot setRepeatInterval:0];
            Bnot.soundName=UILocalNotificationDefaultSoundName;
            Bnot.timeZone=[NSTimeZone defaultTimeZone];
            Bnot.alertBody=[NSString stringWithFormat:@"亲，可以领取金币啦！"];
            Bnot.alertAction=NSLocalizedString(@"现在就去领取金币!", nil);
            NSDictionary* dic=[NSDictionary dictionaryWithObject:@"10" forKey:@"min"];
            Bnot.userInfo=dic;
            Bnot.fireDate=[[NSDate new] dateByAddingTimeInterval:timeInterval];
            [[UIApplication sharedApplication]scheduleLocalNotification:Bnot];
    self.btn_10minsGet.enabled=YES;
    //30mins
    int timeInterval30=[self intervalBetweenNow:currentTime withSignTime:30*60];
    UILocalNotification* Bnot3=[[UILocalNotification alloc]init];
    [Bnot3 setRepeatInterval:0];
    Bnot3.soundName=UILocalNotificationDefaultSoundName;
    Bnot3.timeZone=[NSTimeZone defaultTimeZone];
    Bnot3.alertBody=[NSString stringWithFormat:@"亲，可以领取金币啦！"];
    Bnot3.alertAction=NSLocalizedString(@"现在就去领取金币!", nil);
    NSDictionary* dic3=[NSDictionary dictionaryWithObject:@"30" forKey:@"min"];
    Bnot3.userInfo=dic3;
    if (timeInterval30>0)
    {
        Bnot3.fireDate=[[NSDate new] dateByAddingTimeInterval:timeInterval30];
        [[UIApplication sharedApplication]scheduleLocalNotification:Bnot3];
    }
    //60mins
    int timeInterval6=[self intervalBetweenNow:currentTime withSignTime:60*60];
    UILocalNotification* Bnot6=[[UILocalNotification alloc]init];
    [Bnot6 setRepeatInterval:0];
    Bnot6.soundName=UILocalNotificationDefaultSoundName;
    Bnot6.timeZone=[NSTimeZone defaultTimeZone];
    Bnot6.alertBody=[NSString stringWithFormat:@"亲，可以领取金币啦！"];
    Bnot6.alertAction=NSLocalizedString(@"现在就去领取金币!", nil);
    NSDictionary* dic6=[NSDictionary dictionaryWithObject:@"60" forKey:@"min"];
    Bnot6.userInfo=dic6;
    if (timeInterval6>0)
    {
        Bnot6.fireDate=[[NSDate new] dateByAddingTimeInterval:timeInterval6];
        [[UIApplication sharedApplication]scheduleLocalNotification:Bnot6];
    }
    //120mins
    int timeInterval12=[self intervalBetweenNow:currentTime withSignTime:120*60];
    UILocalNotification* Bnot12=[[UILocalNotification alloc]init];
    [Bnot12 setRepeatInterval:0];
    Bnot12.soundName=UILocalNotificationDefaultSoundName;
    Bnot12.timeZone=[NSTimeZone defaultTimeZone];
    Bnot12.alertBody=[NSString stringWithFormat:@"亲，可以领取金币啦！"];
    Bnot12.alertAction=NSLocalizedString(@"现在就去领取金币!", nil);
    NSDictionary* dic12=[NSDictionary dictionaryWithObject:@"120" forKey:@"min"];
    Bnot12.userInfo=dic12;
    if (timeInterval12>0)
    {
        Bnot12.fireDate=[[NSDate new] dateByAddingTimeInterval:timeInterval12];
        [[UIApplication sharedApplication]scheduleLocalNotification:Bnot12];
    }
    [notisArr addObject:Bnot];
    [notisArr addObject:Bnot3];
    [notisArr addObject:Bnot6];
    [notisArr addObject:Bnot12];
    [ShareValue shareInstance].goldNotis=notisArr;
}
-(int)utilTime
{
    NSDate* date=[NSDate new];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [format stringFromDate:date];
    NSArray* times=[currentDateStr componentsSeparatedByString:@" "];
    NSString* time=[times lastObject];
    NSArray*mins=[time componentsSeparatedByString:@":"];
    NSString* finalTime=[NSString stringWithFormat:@"%@%@",[mins objectAtIndex:0],[mins objectAtIndex:1]];
    int timeInteral=[finalTime intValue];
    NSLog(@"%@",currentDateStr);
    NSLog(@"%d",timeInteral);
    return timeInteral;
}
- (int)intervalBetweenNow:(int)now withSignTime:(int)time {
//    int hour = time/60/60;
//    int min = time/60;
//    int second = (min)*60;
    return time;
}
-(void)loadData{
    /**
     *  获取领取金币相关信息
     *
     */
    GetGoldInfoRequest * request =[[GetGoldInfoRequest alloc]init];
    [SystemAPI GetGoldInfoRequest:request success:^(GetGoldInfoResponse *response) {
        self.infoDic=response.data;
        self.lb_canGetGoldToday.text=[NSString stringWithFormat:@"您今日可领取:%@金币",[response.data objectForKey:@"gold"]];
        self.lb_continedLoginDays.text=[NSString stringWithFormat:@"您已经连续登陆:%@天",[response.data objectForKey:@"continueLogin"]];
        BOOL isGet =[[response.data objectForKey:@"isGet"] boolValue];
        if (!isGet) {
            self.btn_getEveryDay.enabled=YES;
        }else{
            self.btn_getEveryDay.enabled=NO;
        }
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
//获取推广信息
    GetPromotionRequest * requests =[[GetPromotionRequest alloc]init];
    [SystemAPI GetPromotionRequest:requests success:^(id data) {
        int num=[[data objectForKey:@"data"] intValue];
        self.lb_tuiguangCount.text=[NSString stringWithFormat:@"已经推广%d人",num];
        self.lb_stillTuiguangCount.text=[NSString stringWithFormat:@"还需要%d人即可领取VIP",27-num];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    
}
- (IBAction)signGetGoldAction:(id)sender {
    if (![ShareValue shareInstance].userInfo.mobile.length>0) {
        [MBProgressHUD showError:@"请先绑定手机才能领取金币!" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GetGoldForEverydayRequest * request =[[GetGoldForEverydayRequest alloc]init];
    request.gold=[self.infoDic objectForKey:@"gold"];
    [SystemAPI GetGoldForEverydayRequest:request success:^(GetGoldForEverydayResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self loadData];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
//在线时长领取金币
- (IBAction)tenMinsGet:(id)sender {
    [self getGoldByOnlineTime];
    [ShareValue shareInstance].is10Mins=NO;
    self.btn_10minsGet.enabled=NO;
}
- (IBAction)thirtyMinsGet:(id)sender {
    [self getGoldByOnlineTime];
    [ShareValue shareInstance].is30Mins=NO;
    self.btn_30minsGet.enabled=NO;
}
- (IBAction)oneHourGet:(id)sender {
    [self getGoldByOnlineTime];
    [ShareValue shareInstance].is60Mins=NO;
    self.btn_60minsGet.enabled=NO;
}
- (IBAction)longMinsGet:(id)sender {
    [self getGoldByOnlineTime];
    [ShareValue shareInstance].is120Mins=NO;
    self.btn_120minsGet.enabled=NO;
    [ShareValue shareInstance].goldNotis=nil;
}
-(void)getGoldByOnlineTime{
    if (![ShareValue shareInstance].userInfo.mobile.length>0) {
        [MBProgressHUD showError:@"请先绑定手机才能领取金币!" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GetGoldByOnlineTimeRequest * request =[[GetGoldByOnlineTimeRequest alloc]init];
    NSString * type =[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.type];
    if ([type isEqualToString:@"2"]) {
         request.gold=@"55";
    }else{
         request.gold=@"50";
    }
    [SystemAPI GetGoldByOnlineTimeRequest:request success:^(GetGoldByOnlineTimeResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];

}
//分享
- (IBAction)shareQQ:(id)sender {
    [UMSocialData defaultData].extConfig.qqData.url = @"http://www.immet.cm";
    [UMSocialData defaultData].extConfig.qqData.title = @"相遇比陌陌更懂你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
             [self shareCallBackAction];
        }
    }];
}
- (IBAction)shareWeChat:(id)sender {
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.immet.cm";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"相遇比陌陌更懂你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
             [self shareCallBackAction];
        }
    }];
}
- (IBAction)shareWeChatCircle:(id)sender {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.immet.cm";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"相遇比陌陌更懂你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
             [self shareCallBackAction];
        }
    }];
    }
- (IBAction)shareSina:(id)sender {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [self shareCallBackAction];
        }
    }];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

/**
 *  分享回调
 */
-(void)shareCallBackAction{
    ShareCallBackRequest * request =[[ShareCallBackRequest alloc]init];
    [SystemAPI ShareCallBackRequest:request success:^(ShareCallBackResponse *response) {
        LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:response.data];
        [ShareValue shareInstance].userInfo=user;
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
@end
