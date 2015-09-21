//
//  FriendCircleHeaderView.m
//  Meet
//
//  Created by Anita Lee on 15/8/13.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "FriendCircleHeaderView.h"
#import "ServerConfig.h"
#import "BaseViewController.h"


@interface FriendCircleHeaderView()
@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UIImageView *photoImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@end

@implementation FriendCircleHeaderView
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage=backgroundImage;
    _headImageView.image=backgroundImage;
}
-(void)setPhotoIV:(UIImage *)photoIV{
    _photoIV=photoIV;
    _photoImageView.image=photoIV;
}
-(void)setName:(NSString *)name{
    _name=name;
    _nameLabel.text=name;
}
-(void)setCoverImageUrl:(NSString *)coverImageUrl{
    _coverImageUrl=coverImageUrl;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:coverImageUrl] placeholderImage:circlePlaceHolder];
}
-(void)setPhotoIVUrl:(NSString *)photoIVUrl{
    _photoIVUrl=photoIVUrl;
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:photoIVUrl] placeholderImage:placeHolder];
}
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
    self.backgroundColor=NAVI_COLOR;
    
    CGRect frame=CGRectMake(0, 0, DEVCE_WITH, DEVCE_WITH+25);
    self.frame=frame;
    self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-25)];
    self.headImageView.backgroundColor=[UIColor clearColor];
    self.headImageView.image=placeHolder;
    self.headImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer  * tap_cover=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBackCover)];
    [self.headImageView addGestureRecognizer:tap_cover];
    [self addSubview:self.headImageView];
    
    self.photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-8-80, frame.size.height-80, 80, 80)];
    self.photoImageView.backgroundColor=[UIColor clearColor];
    self.photoImageView.image=placeHolder;
    self.photoImageView.layer.cornerRadius=5;
    self.photoImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.photoImageView.layer.borderWidth=1.5;
    self.photoImageView.clipsToBounds=YES;
    self.photoImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap_showMyCircle=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyCircle)];
    [self.photoImageView addGestureRecognizer:tap_showMyCircle];
    [self addSubview:self.photoImageView];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, frame.size.height-25, frame.size.width-8*3-80, 25)];
    self.nameLabel.font=[UIFont systemFontOfSize:18];
    self.nameLabel.textColor=[UIColor whiteColor];
    self.nameLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:self.nameLabel];
}
-(void)changeBackCover{
    if (self.delegate) {
        [self.delegate changeHeaderViewBackView:self];
    }
}
-(void)showMyCircle{
    if (self.delegate) {
        [self.delegate showMyFriendCircleVC];
    }
}


@end
