//
//  BuyGiftsAlertView.m
//  Meet
//
//  Created by Anita Lee on 15/9/7.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BuyGiftsAlertView.h"
#import "ServerConfig.h"
#import "BaseViewController.h"


@interface BuyGiftsAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_currentGold;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_giftName;
@property (weak, nonatomic) IBOutlet UILabel *lb_giftPrice;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *addBTn;
@property (weak, nonatomic) IBOutlet UIButton *minsBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
@implementation BuyGiftsAlertView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)awakeFromNib{
    [self initView];
    
}
-(void)initView{
    self.layer.cornerRadius=5;
    self.clipsToBounds=YES;
    
}
-(void)setCurrentGold:(NSString *)currentGold{
    _currentGold=currentGold;
    self.lb_currentGold.text=[NSString stringWithFormat:@"您当前的金币:%@",currentGold];
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
-(NSString *)buyCount{
    return [NSString stringWithFormat:@"%@",self.lb_count.text];
}
-(void)setGiftName:(NSString *)giftName{
    _giftName=giftName;
    self.lb_giftName.text=giftName;
}
-(void)setGiftPrice:(NSString *)giftPrice{
    _giftPrice=giftPrice;
    self.lb_giftPrice.text=[NSString stringWithFormat:@"%@金币",giftPrice];
}
- (IBAction)minsAction:(id)sender {
    NSInteger count =[self.lb_count.text integerValue];
    if (count==1) {
        [MBProgressHUD showError:@"至少买一个哦！" toView:self.window];
    }else{
        self.lb_count.text=[NSString stringWithFormat:@"%d",count-1];
    }
}
- (IBAction)addAction:(id)sender {
    NSInteger count =[self.lb_count.text integerValue];
    self.lb_count.text=[NSString stringWithFormat:@"%d",count+1];
}
- (IBAction)cancelAction:(id)sender {
    [self.delegate buyAlertView:self clickedAtButtonIndex:0];
}
- (IBAction)confirmAction:(id)sender {
    [self.delegate buyAlertView:self clickedAtButtonIndex:1];
}
-(void)dismiss{
    [self removeFromSuperview];
}
@end
