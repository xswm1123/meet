//
//  GiveGiftAlertView.m
//  Meet
//
//  Created by Anita Lee on 15/9/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "GiveGiftAlertView.h"
#import "BaseViewController.h"
@interface GiveGiftAlertView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation GiveGiftAlertView
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
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
}
-(void)setData:(NSArray *)data{
    _data=data;
    CGFloat imageWidth = ([UIScreen mainScreen].bounds.size.width-50)/4;
    if (data.count>0) {
    for (int i=0; i<data.count; i++) {
        NSDictionary * dic =data[i];
        UIImageView * imv=[[UIImageView alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, 0, imageWidth, imageWidth)];
        imv.userInteractionEnabled=YES;
        imv.tag=i;
        [imv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]]]];
        UILabel * name=[[UILabel alloc]initWithFrame:CGRectMake(10+(imageWidth+10)*i, imageWidth, imageWidth, 20)];
        name.textAlignment=NSTextAlignmentCenter;
        name.text=[dic objectForKey:@"itemName"];
        name.font=[UIFont systemFontOfSize:15.0];
        name.textColor=iconYellow;
        name.adjustsFontSizeToFitWidth=YES;
        [self.scrollView addSubview:name];
        [self.scrollView addSubview:imv];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(send:)];
        [imv addGestureRecognizer:tap];
    }
    self.scrollView.contentSize=CGSizeMake(10+(imageWidth+10)*data.count, 163);
    }else{
        UILabel * mark=[[UILabel alloc]initWithFrame:CGRectMake(0,20, imageWidth*4+50, 80)];
        mark.textAlignment=NSTextAlignmentCenter;
        mark.textColor=[UIColor lightGrayColor];
        mark.adjustsFontSizeToFitWidth=YES;
        mark.numberOfLines=0;
        mark.text=@"你还没有可以送给别人的礼物哦，快去商城中心购买你需要的礼物吧:）";
        [self addSubview:mark];
        BaseButton * button =[[BaseButton alloc]initWithFrame:CGRectMake(DEVCE_WITH/3, 90, DEVCE_WITH/3, 32)];
        [button setTitle:@"前往商城" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goMarket) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
-(void)send:(UIGestureRecognizer*)tap{
    UIImageView * imageView=(UIImageView*)tap.view;
    NSDictionary * dic =[self.data objectAtIndex:imageView.tag];
    [self.delegate giveGift:self withGiftInfo:dic];
}
-(void)goMarket{
    [self.delegate moveToMarketCenter];
}
@end
