//
//  SystemMessageTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/9/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SystemMessageTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@interface SystemMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UIButton *btn_refuse;
@property (weak, nonatomic) IBOutlet UIButton *btn_black;

@end
@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    [self.btn_agree setTitleColor:iconGreen forState:UIControlStateNormal];
    self.btn_agree.layer.cornerRadius=5;
    self.btn_agree.layer.borderColor=iconGreen.CGColor;
    self.btn_agree.layer.borderWidth=1;
    
    [self.btn_refuse setTitleColor:iconOrange forState:UIControlStateNormal];
    self.btn_refuse.layer.cornerRadius=5;
    self.btn_refuse.layer.borderColor=iconOrange.CGColor;
    self.btn_refuse.layer.borderWidth=1;
    
    [self.btn_black setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btn_black.layer.cornerRadius=5;
    self.btn_black.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btn_black.layer.borderWidth=1;
    
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)agreeAction:(id)sender {
    [self.delegate agreeWithCell:self];
}
- (IBAction)refuseAction:(id)sender {
    [self.delegate refuseWithCell:self];
}
- (IBAction)blackAction:(id)sender {
    [self.delegate addBlackListWithCell:self];
}

@end
