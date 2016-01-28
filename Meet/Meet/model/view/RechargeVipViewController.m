//
//  RechargeVipViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/9.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RechargeVipViewController.h"
#import <StoreKit/StoreKit.h>

@interface RechargeVipViewController ()<UIActionSheetDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wePayBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;
@property (weak, nonatomic) IBOutlet UILabel *lb_ID;
@property (weak, nonatomic) IBOutlet UIView *countBG;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIButton *minsBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (nonatomic,assign) double money;
@property (nonatomic,strong) NSMutableArray * types;
@property (nonatomic,assign) NSInteger golds;
@property (nonatomic,assign) BOOL canUpdate;
@property (nonatomic,assign) NSInteger  typeIndex;
@end

@implementation RechargeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canUpdate=NO;
    if (![WXApi isWXAppInstalled]) {
        self.aliPayBtn.hidden=YES;
        self.wePayBtn.hidden=YES;
    }
    //添加内支付监听
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self initView];
    self.typeIndex=0;
    [self loadVIPTypes];
}
-(void)loadVIPTypes{
    GetVIPTypesRequest * request =[[GetVIPTypesRequest alloc]init];
    [SystemAPI GetVIPTypesRequest:request success:^(GetVIPTypesResponse *response) {
        self.types=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self configData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)configData{
    //data
    
    self.lb_ID.text=[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.meetid];
    NSDictionary * dic =[self.types objectAtIndex:0];
    self.money=[dic[@"price"] doubleValue];
    self.golds=[dic[@"gold"] integerValue];
    NSString * moneys=[NSString stringWithFormat:@"%.2f",self.money];
    NSString * gold=[NSString stringWithFormat:@"%ld",(long)self.golds];
    NSMutableAttributedString * mn=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元,赠送%@金币",moneys,gold]];
    [mn addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:iconYellow} range:NSMakeRange(0, moneys.length)];
    [mn addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(moneys.length,mn.length-moneys.length)];
    self.lb_money.attributedText=mn;
    self.lb_type.text=dic[@"description"];
}
-(void)initView{
    self.lb_icon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_icon.text=@"\U0000e637";
    self.countBG.layer.cornerRadius=5;
    self.aliPayBtn.layer.cornerRadius=8;
    self.aliPayBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.aliPayBtn.layer.borderWidth=2;
    self.aliPayBtn.selected=YES;
    [self.aliPayBtn setBackgroundColor:cellColor];
    NSString  * aliIcon=@"\U0000e62c";
    NSString * aliStr=@"\U0000e62c微信支付";
    NSMutableAttributedString * ali=[[NSMutableAttributedString alloc]initWithString:aliStr];
    [ali addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:36],NSForegroundColorAttributeName:iconGreen} range:NSMakeRange(0, aliIcon.length)];
    [ali addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(aliIcon.length, aliStr.length-aliIcon.length)];
    [self.aliPayBtn setAttributedTitle:ali forState:UIControlStateNormal];
    
    self.wePayBtn.layer.cornerRadius=8;
    self.wePayBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.wePayBtn.layer.borderWidth=2;
    NSString  * weIcon=@"\U0000e62d";
    NSString * weStr=@"\U0000e62d支付宝支付";
    NSMutableAttributedString * we=[[NSMutableAttributedString alloc]initWithString:weStr];
    [we addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:36],NSForegroundColorAttributeName:iconBlue} range:NSMakeRange(0, weIcon.length)];
    [we addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(weIcon.length, weStr.length-weIcon.length)];
    [self.wePayBtn setAttributedTitle:we forState:UIControlStateNormal];
}
-(void)setMoneyText:(double)money WithGold:(NSInteger)golds{
    NSString * moneys=[NSString stringWithFormat:@"%.2f",money];
    NSString * gold=[NSString stringWithFormat:@"%ld",(long)golds];
    NSMutableAttributedString * mn=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元,赠送%@金币",moneys,gold]];
    [mn addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:iconYellow} range:NSMakeRange(0, moneys.length)];
    [mn addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(moneys.length,mn.length-moneys.length)];
    self.lb_money.attributedText=mn;
}
- (IBAction)chooseTypes:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        UIActionSheet * al=[[UIActionSheet alloc]initWithTitle:@"请选择充值套餐" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"3个月VIP",nil];
        [al showInView:self.view.window];
        return;
    }
    
    UIActionSheet * al=[[UIActionSheet alloc]initWithTitle:@"请选择充值套餐" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary * dic in self.types) {
        [al addButtonWithTitle:dic[@"description"]];
    }
    al.cancelButtonIndex=0;
    [al showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=0) {
        if (buttonIndex==1) {
            if (![WXApi isWXAppInstalled]) {
                return;
            }
        }
        if (buttonIndex==2) {
            if (![WXApi isWXAppInstalled]) {
            }
        }
        NSDictionary * dic   =[self.types objectAtIndex:buttonIndex-1];
        self.typeIndex=buttonIndex-1;
        self.lb_type.text=dic[@"description"];
        self.money=[dic[@"price"] doubleValue];
        [self setMoneyText:[dic[@"price"] doubleValue] WithGold:[dic[@"gold"] integerValue]];
    }
}
- (IBAction)minsAction:(id)sender {
    if ([self.lb_count.text integerValue]==1) {
        [MBProgressHUD showError:@"不能再减少啦！" toView:self.view];
    }else{
        NSInteger count =[self.lb_count.text integerValue];
        self.lb_count.text=[NSString stringWithFormat:@"%d",count-1];
        self.money=[self.lb_count.text integerValue]*10;
//        [self setMoneyText:self.money];
        
    }
}
- (IBAction)addAction:(id)sender {
//    NSInteger count =[self.lb_count.text integerValue];
//    self.lb_count.text=[NSString stringWithFormat:@"%d",count+1];
    self.money=[self.lb_count.text integerValue]*10;
//    [self setMoneyText:self.money];
}

- (IBAction)alipayAction:(id)sender {
    self.aliPayBtn.selected=YES;
    [self.aliPayBtn setBackgroundColor:cellColor];
    self.wePayBtn.selected=NO;
    [self.wePayBtn setBackgroundColor:[UIColor clearColor]];
}
- (IBAction)wePayAction:(id)sender {
    self.wePayBtn.selected=YES;
    [self.wePayBtn setBackgroundColor:cellColor];
    self.aliPayBtn.selected=NO;
    [self.aliPayBtn setBackgroundColor:[UIColor clearColor]];
}
- (IBAction)buyAction:(id)sender {
    self.canUpdate=YES;
    if (![WXApi isWXAppInstalled]) {
        [self payWithInPurse];
        return;
    }else{
        self.canUpdate=NO;
    }
    //微信支付
    if ([self.aliPayBtn isSelected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CreatePayOrderRequest * request=[[CreatePayOrderRequest alloc]init];
        request.payType=2;
        request.tradeType=2;
        NSDictionary * dic =[self.types objectAtIndex:self.typeIndex];
        request.vipPriceId=[dic[@"id"] integerValue];
        request.month=[dic[@"month"] integerValue];
        request.gold=[dic[@"gold"] integerValue];
        request.price=[dic[@"price"] doubleValue];
        [SystemAPI CreatePayOrderRequest:request success:^(CreatePayOrderResponse *response) {
            NSDictionary * dic=response.data;
            NSString * tradeID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            [self rechargeWithWeChatWith:tradeID];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
    //支付宝支付
    if ([self.wePayBtn isSelected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CreatePayOrderRequest * request=[[CreatePayOrderRequest alloc]init];
        request.payType=1;
        request.tradeType=2;
        NSDictionary * dic =[self.types objectAtIndex:self.typeIndex];
        request.vipPriceId=[dic[@"id"] integerValue];
        request.month=[dic[@"month"] integerValue];
        request.gold=[dic[@"gold"] integerValue];
        request.price=[dic[@"price"] doubleValue];
        [SystemAPI CreatePayOrderRequest:request success:^(CreatePayOrderResponse *response) {
            NSDictionary * dic=response.data;
            NSString * tradeID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            [self rechargeWithAlipayWith:tradeID];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
        
    }
}
-(void)rechargeWithAlipayWith:(NSString *)ID{
    NSString *partner = @"2088811340875601";
    NSString *seller = @"immet@vip.163.com";
    NSString * privateKey=@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANG/yGnfjzVsy2GLeZt3Yn2fZEs9NNtNeJXzhBRRq8Gr+YEnGHfs5yBSqBdbWe4V6wRuiG5FR3i9r1ewyuE2gFyzRQdTZOSdVnaMMrw33EEQID3vKWKUrx1QM/0+7PxQ6jR2AOgWRvTV407PWnYoEGkEYNutqlh4SZK9vDgRA/+xAgMBAAECgYAQ3dEp4lZLv4HjSCnxPHppC6Yu/q7/a41k0X4vfBnJqyCXKCOpkR1M1hi6OBhVMuIBKzpBU8TZirdM3+SQk6dip5bDDlrAJ7p/GzR5zLNeCvFjIm/MAFC5fgkkQBQhsDrlx6wIq5XJFqD3rdQ1CBCQ9ag1WeY55uE2MgwU0Qsp+QJBAPduM1+/gs/27EA3BNJlxQoYiTnfr5b+KrzCAETj3NFuj1c5IdOSc2Lhs4xzsDShphpWiwXcZGW/n00u8V1poeMCQQDZA3zAKfjaXDJKQTrJxBL8PsnMjz1t9zLzsZwm/86+5VkFbqr6mExiGUwK2WvgUBuzrLUCkQw1wGbk7bU1NPxbAkAz9R4wowSTKyTdLzCCBgDkZ9aZIpG6wVC0JoDr9nVuPSs4g7TIut4kC4UqnziHNNKugTHcXzVt8FlBWfQxS3dFAkEAlX1CfTksdHbYKbB/Z6eKkHpMFn6BiXOkhJxPfcnvSC7CwOw4GYG59EWKzVpyZkWon3+T/R2ftJNCDeb1UZ6bSwJBANlKbM/8TEEQZu7I7u0jhaY3S4ac4LBgSUNAFkXPWyZgKeOe2U7M8QDMvkahl77frH7loanmfQQMwx+JGrpX3yE=";
    Order * myOrder=[[Order alloc]init];
    myOrder.partner = partner;
    myOrder.seller = seller;
    myOrder.tradeNO = ID; //订单ID（由商家自行制定）
    myOrder.productName = @"相遇会员充值"; //商品标题
    myOrder.productDescription =@"会员"; //商品描述
    myOrder.amount = [NSString stringWithFormat:@"%.2f",self.money]; //商品价格
    myOrder.notifyURL =  @"http://xy.immet.cm/xy/rest/pay/alipay_notify"; //回调URL
    myOrder.service = @"mobile.securitypay.pay";
    myOrder.paymentType = @"1";
    myOrder.inputCharset = @"utf-8";
    myOrder.itBPay = @"30m";
    myOrder.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alimeet";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [myOrder description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
     BOOL flag =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alimeet:"]];
    if (flag) {
        NSLog(@"can open the url nice!");
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSString * code=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
                NSLog(@"code:%@",code);
            }];
        }
    }else{
        NSLog(@"can not open the url nice!");
    }
}
//微信预支付
-(void)rechargeWithWeChatWith:(NSString*)tradeId{
    CreateWeChatPrePayRequest * request=[[CreateWeChatPrePayRequest alloc]init];
    request.orderId=tradeId;
    request.product_name=@"相遇会员充值";
    request.order_price=self.money;
    [SystemAPI CreateWeChatPrePayRequest:request success:^(CreateWeChatPrePayResponse *response) {
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [response.data objectForKey:@"appid"];
        req.partnerId           = [response.data objectForKey:@"partnerid"];
        req.prepayId            = [response.data objectForKey:@"prepayid"];
        req.nonceStr            = [response.data objectForKey:@"noncestr"];
        NSMutableString *stamp  = [response.data objectForKey:@"timestamp"];
        req.timeStamp           = stamp.intValue;
        req.package             = [response.data objectForKey:@"package"];
        req.sign                = [response.data objectForKey:@"sign"];
//        if (![WXApi isWXAppInstalled]) {
             [WXApi sendReq:req];
//            NSLog(@"isWXAppInstalled");
//        }else{
//            NSLog(@"isWXAppInstalled NOT");
//            [self payWithInPurse];
//        }
       
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
-(void)payWithInPurse{
    NSString *product=@"com.immet.meets_VIPM";
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:product];
    }else{
        NSLog(@"不允许程序内付费");
    }
}
//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
//    NSArray *product = [[NSArray alloc] initWithObjects:type];
    
    NSSet *nsset = [NSSet setWithArray:@[type]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:@"com.immet.meets_VIPM"]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                if (self.canUpdate) {
                    [self updateVIPInfo];
                }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败：%@",tran.error);
                
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
//内购接口
-(void)updateVIPInfo{
    IAPPurchaseRequest * request =[[IAPPurchaseRequest alloc]init];
    request.month=@"3";
    request.gold=@"30000";
    [SystemAPI IAPPurchaseRequest:request success:^(IAPPurchaseResponse *response) {
        [self updatePersonalInfo];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
@end
