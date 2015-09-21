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
}
-(void)initView{
    self.btn_10minsGet.enabled=NO;
    self.btn_30minsGet.enabled=NO;
    self.btn_60minsGet.enabled=NO;
    self.btn_120minsGet.enabled=NO;
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
    [SystemAPI GetPromotionRequest:requests success:^(GetPromotionResponse *response) {
        int num=(int)response.data;
        self.lb_tuiguangCount.text=[NSString stringWithFormat:@"已经推广%d人",num];
        self.lb_stillTuiguangCount.text=[NSString stringWithFormat:@"还需要%d人即可领取VIP",27-num];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    
}
- (IBAction)signGetGoldAction:(id)sender {
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
    self.btn_10minsGet.enabled=NO;
}
- (IBAction)thirtyMinsGet:(id)sender {
    [self getGoldByOnlineTime];
    self.btn_30minsGet.enabled=NO;
}
- (IBAction)oneHourGet:(id)sender {
    [self getGoldByOnlineTime];
    self.btn_60minsGet.enabled=NO;
}
- (IBAction)longMinsGet:(id)sender {
    [self getGoldByOnlineTime];
    self.btn_120minsGet.enabled=NO;
}
-(void)getGoldByOnlineTime{
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
        }
    }];
}
- (IBAction)shareWeChat:(id)sender {
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.immet.cm";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"相遇比陌陌更懂你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (IBAction)shareWeChatCircle:(id)sender {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.immet.cm";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"相遇比陌陌更懂你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    }
- (IBAction)shareSina:(id)sender {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:UmengShareContent image:[UIImage imageNamed:@"icon_180.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}


@end
