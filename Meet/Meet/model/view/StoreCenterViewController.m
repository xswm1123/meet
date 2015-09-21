//
//  StoreCenterViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoreCenterViewController.h"
#import "BuyGiftsAlertView.h"

@interface StoreCenterViewController ()<BuGiftAlertDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BaseSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet BaseView *VIPBG;
@property (weak, nonatomic) IBOutlet BaseView *BestBG;
@property (weak, nonatomic) IBOutlet BaseView *normalBG;
@property (weak, nonatomic) IBOutlet BaseView *EcoBG;
//data
@property (nonatomic,strong) NSArray * categorysArr;
@property (nonatomic,strong) NSArray * AllItemsArr;
@property (nonatomic,strong) UIView * mask;
@end

@implementation StoreCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCategory];
    
}
-(void)loadCategory{
    GetMallCategoryRequest * request =[[GetMallCategoryRequest alloc]init];
    [SystemAPI GetMallCategoryRequest:request success:^(GetMallCategoryResponse *response) {
        self.categorysArr = (NSArray *)response.data;
        for (int i =0; i<self.categorysArr.count; i++) {
            NSDictionary * dic =self.categorysArr[i];
            [self.segmentControl setTitle:[dic objectForKey:@"name"] forSegmentAtIndex:i];
        }
        [self getItemsById:0];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)getItemsById:(NSInteger)index{
    GetItemByIdRequest * request =[[GetItemByIdRequest alloc]init];
    NSDictionary * dic =[self.categorysArr objectAtIndex:index];
    NSString * categoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    request.categoryId=categoryId;
    [SystemAPI GetItemByIdRequest:request success:^(GetItemByIdResponse *response) {
        self.AllItemsArr = (NSArray *)response.data;
        [self clear];
        [self showGiftImages];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)clear{
    for ( UIView * view in self.VIPBG.subviews) {
        if (view.tag<100) {
             [view removeFromSuperview];
        }
    }
    for ( UIView * view in self.BestBG.subviews) {
        if (view.tag<100) {
            [view removeFromSuperview];
        }
    }
    for ( UIView * view in self.normalBG.subviews) {
        if (view.tag<100) {
            [view removeFromSuperview];
        }
    }
    for ( UIView * view in self.EcoBG.subviews) {
        if (view.tag<100) {
            [view removeFromSuperview];
        }
    }
    
}
//展示礼物图片
-(void)showGiftImages{
    CGFloat imageWidth=(DEVCE_WITH-50)/4;
    NSDictionary * vipImagesDic=[self.AllItemsArr objectAtIndex:0];
    NSDictionary * bestImagesDic=[self.AllItemsArr objectAtIndex:1];
    NSDictionary * normalImagesDic=[self.AllItemsArr objectAtIndex:2];
    NSDictionary * ecoImagesDic=[self.AllItemsArr objectAtIndex:3];
    NSArray * vipImagesArr =[vipImagesDic objectForKey:@"itemList"];
    NSArray * bestImagesArr =[bestImagesDic objectForKey:@"itemList"];
    NSArray * normalImagesArr =[normalImagesDic objectForKey:@"itemList"];
    NSArray * ecoImagesArr =[ecoImagesDic objectForKey:@"itemList"];
    //VIP
    CGFloat vipWidth=(DEVCE_WITH-60)/3;
    UIScrollView * Scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, DEVCE_WITH, 130)];
    Scroll.showsVerticalScrollIndicator=NO;
    Scroll.showsHorizontalScrollIndicator=NO;
    [self.VIPBG addSubview:Scroll];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<vipImagesArr.count; i++) {
            NSDictionary * dic =vipImagesArr[i];
            UIImageView * imv =[[UIImageView alloc]initWithFrame:CGRectMake(60+(vipWidth+10)*i, 0, vipWidth,90 )];
            imv.tag=i;
            imv.userInteractionEnabled=YES;
            UILabel * lb_title=[[UILabel alloc]initWithFrame:CGRectMake(60+(vipWidth+10)*i, 90, vipWidth, 20)];
            
            UILabel * lb_price=[[UILabel alloc]initWithFrame:CGRectMake(60+(vipWidth+10)*i, 110, vipWidth, 20)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]] placeholderImage:placeHolder];
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyVIPGift:)];
                [imv addGestureRecognizer:tap];
                [Scroll addSubview:imv];
                lb_title.textColor=[UIColor whiteColor];
                lb_title.font=[UIFont systemFontOfSize:15];
                lb_title.textAlignment=NSTextAlignmentCenter;
                lb_title.text=[dic objectForKey:@"title"];
                lb_title.adjustsFontSizeToFitWidth=YES;
                [Scroll addSubview:lb_title];
                lb_price.textColor=iconYellow;
                lb_price.font=[UIFont systemFontOfSize:13];
                lb_price.textAlignment=NSTextAlignmentCenter;
                lb_price.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
                lb_price.adjustsFontSizeToFitWidth=YES;
                [Scroll addSubview:lb_price];
                Scroll.contentSize=CGSizeMake(60+(vipWidth+10)*vipImagesArr.count, 130) ;
            });
        }
    });
    //奢华
    UIScrollView * VipScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, DEVCE_WITH, 110)];
    VipScroll.showsVerticalScrollIndicator=NO;
    VipScroll.showsHorizontalScrollIndicator=NO;
    [self.BestBG addSubview:VipScroll];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<bestImagesArr.count; i++) {
            NSDictionary * dic =bestImagesArr[i];
            UIImageView * imv =[[UIImageView alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 0, imageWidth,70 )];
            imv.tag=i;
            imv.userInteractionEnabled=YES;
            UILabel * lb_title=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 70, imageWidth, 20)];
            
            UILabel * lb_price=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 90, imageWidth, 20)];
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [imv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]] placeholderImage:placeHolder];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyBestGift:)];
            [imv addGestureRecognizer:tap];
            [VipScroll addSubview:imv];
            lb_title.textColor=[UIColor whiteColor];
            lb_title.font=[UIFont systemFontOfSize:15];
            lb_title.textAlignment=NSTextAlignmentCenter;
            lb_title.text=[dic objectForKey:@"title"];
            lb_title.adjustsFontSizeToFitWidth=YES;
            [VipScroll addSubview:lb_title];
            lb_price.textColor=iconYellow;
            lb_price.font=[UIFont systemFontOfSize:13];
            lb_price.textAlignment=NSTextAlignmentCenter;
            lb_price.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
            [VipScroll addSubview:lb_price];
            VipScroll.contentSize=CGSizeMake(10+(imageWidth+10)*bestImagesArr.count, 110) ;
        });
             }
    });
    //豪华
    UIScrollView * normalScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, DEVCE_WITH, 110)];
    normalScroll.showsVerticalScrollIndicator=NO;
    normalScroll.showsHorizontalScrollIndicator=NO;
    [self.normalBG addSubview:normalScroll];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<normalImagesArr.count; i++) {
            NSDictionary * dic =normalImagesArr[i];
            UIImageView * imv =[[UIImageView alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 0, imageWidth,70 )];
            imv.tag=i;
            imv.userInteractionEnabled=YES;
            UILabel * lb_title=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 70, imageWidth, 20)];
            
            UILabel * lb_price=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 90, imageWidth, 20)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]] placeholderImage:placeHolder];
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyNormalGift:)];
                [imv addGestureRecognizer:tap];
                [normalScroll addSubview:imv];
                lb_title.textColor=[UIColor whiteColor];
                lb_title.font=[UIFont systemFontOfSize:15];
                lb_title.textAlignment=NSTextAlignmentCenter;
                lb_title.text=[dic objectForKey:@"title"];
                [normalScroll addSubview:lb_title];
                lb_title.adjustsFontSizeToFitWidth=YES;
                lb_price.textColor=iconYellow;
                lb_price.font=[UIFont systemFontOfSize:13];
                lb_price.textAlignment=NSTextAlignmentCenter;
                lb_price.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
                [normalScroll addSubview:lb_price];
                normalScroll.contentSize=CGSizeMake(10+(imageWidth+10)*normalImagesArr.count, 110) ;
            });
        }
    });
    //经济
    UIScrollView * ecoScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, DEVCE_WITH, 110)];
    ecoScroll.showsVerticalScrollIndicator=NO;
    ecoScroll.showsHorizontalScrollIndicator=NO;
    [self.EcoBG addSubview:ecoScroll];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<ecoImagesArr.count; i++) {
            NSDictionary * dic =ecoImagesArr[i];
            UIImageView * imv =[[UIImageView alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 0, imageWidth,70 )];
            imv.tag=i;
            imv.userInteractionEnabled=YES;
            UILabel * lb_title=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 70, imageWidth, 20)];
            
            UILabel * lb_price=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 90, imageWidth, 20)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]] placeholderImage:placeHolder];
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyEcoGift:)];
                [imv addGestureRecognizer:tap];
                [ecoScroll addSubview:imv];
                lb_title.textColor=[UIColor whiteColor];
                lb_title.font=[UIFont systemFontOfSize:15];
                lb_title.textAlignment=NSTextAlignmentCenter;
                lb_title.text=[dic objectForKey:@"title"];
                [ecoScroll addSubview:lb_title];
                lb_title.adjustsFontSizeToFitWidth=YES;
                lb_price.textColor=iconYellow;
                lb_price.font=[UIFont systemFontOfSize:13];
                lb_price.textAlignment=NSTextAlignmentCenter;
                lb_price.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
                [ecoScroll addSubview:lb_price];
                ecoScroll.contentSize=CGSizeMake(10+(imageWidth+10)*ecoImagesArr.count, 110) ;
            });
        }
    });
}
- (IBAction)segmentValueChanged:(BaseSegmentControl*)sender {
    if (sender.selectedSegmentIndex==0) {
        [self getItemsById:0];
    }
    if (sender.selectedSegmentIndex==1) {
        [self getItemsById:1];
    }
    if (sender.selectedSegmentIndex==2) {
        [self getItemsById:2];
    }
    if (sender.selectedSegmentIndex==3) {
        [self getItemsById:3];
    }
    
}

- (IBAction)ReChargeGold:(id)sender {
    [self performSegueWithIdentifier:@"recharge" sender:nil];
}
/**
 *  购买礼物
 */
-(void)buyVIPGift:(UIGestureRecognizer*)tap{
    UIImageView * imageView=(UIImageView*)tap.view;
    NSDictionary * vipImagesDic=[self.AllItemsArr objectAtIndex:0];
    NSArray * vipImagesArr =[vipImagesDic objectForKey:@"itemList"];
    NSDictionary* dic=[vipImagesArr objectAtIndex:imageView.tag];
    NSString * type=[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.type];
    if ([type isEqualToString:@"2"]) {
        [self loadAlertViewWith:dic];
    }else{
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还不是会员，请前往会员中心升级成为会员才能购买哦！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [al show];
    }
    
}
-(void)buyBestGift:(UIGestureRecognizer*)tap{
    UIImageView * imageView=(UIImageView*)tap.view;
    NSDictionary * bestImagesDic=[self.AllItemsArr objectAtIndex:1];
    NSArray * bestImagesArr =[bestImagesDic objectForKey:@"itemList"];
    NSDictionary* dic=[bestImagesArr objectAtIndex:imageView.tag];
    [self loadAlertViewWith:dic];
}
-(void)buyNormalGift:(UIGestureRecognizer*)tap{
    UIImageView * imageView=(UIImageView*)tap.view;
    NSDictionary * normalImagesDic=[self.AllItemsArr objectAtIndex:2];
    NSArray * normalImagesArr =[normalImagesDic objectForKey:@"itemList"];
    NSDictionary* dic=[normalImagesArr objectAtIndex:imageView.tag];
    [self loadAlertViewWith:dic];
}
-(void)buyEcoGift:(UIGestureRecognizer*)tap{
    UIImageView * imageView=(UIImageView*)tap.view;
    NSDictionary * ecoImagesDic=[self.AllItemsArr objectAtIndex:3];
    NSArray * ecoImagesArr =[ecoImagesDic objectForKey:@"itemList"];
    NSDictionary* dic=[ecoImagesArr objectAtIndex:imageView.tag];
    [self loadAlertViewWith:dic];
}
-(void)buyAlertView:(BuyGiftsAlertView *)alertView clickedAtButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [alertView dismiss];
        [self.mask removeFromSuperview];
    }
    if (buttonIndex==1) {
        if ([alertView.giftPrice integerValue]>[[ShareValue shareInstance].userInfo.gold integerValue]) {
            UIAlertView * al =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您当前足额不足，请先充值再进行购买！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            al.tag=1000;
            [al show];
            [alertView dismiss];
            [self.mask removeFromSuperview];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            BuyItemByGoldRequest * request=[[BuyItemByGoldRequest alloc]init];
            request.itemId=alertView.itemId;
            request.num=alertView.buyCount;
            [SystemAPI BuyItemByGoldRequest:request success:^(BuyItemByGoldResponse *response) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [alertView dismiss];
                [self.mask removeFromSuperview];
                [MBProgressHUD showSuccess:response.message toView:self.view.window];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                [MBProgressHUD showError:desciption toView:self.view.window];
            }];
        }
    }
}
-(void)loadAlertViewWith:(NSDictionary*)dic{
    self.mask=[[UIView alloc]initWithFrame:self.view.window.bounds];
    self.mask.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss:)];
    [self.mask addGestureRecognizer:tap];
    [self.view addSubview:self.mask];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BuyGiftsAlertView"owner:self options:nil];
    BuyGiftsAlertView * view = [nib objectAtIndex:0];
    view.delegate=self;
    CGRect tmpFrame = [[UIScreen mainScreen] bounds];
    [view setCenter:CGPointMake(tmpFrame.size.width / 2, tmpFrame.size.height / 2)];
    [self.mask addSubview:view];
    view.currentGold=[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.gold];
    view.photoUrl=[dic objectForKey:@"picUrl"];
    view.giftName=[dic objectForKey:@"title"];
    view.giftPrice=[NSString stringWithFormat:@"%@",[dic objectForKey:@"gold"]];
    view.itemId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
}
-(void)miss:(UIGestureRecognizer*)tap{
    UIView * view=tap.view;
    [view removeFromSuperview];
}
@end
