//
//  BlackListCellTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/9/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BlackListCellTableViewCell.h"
#import "BaseViewController.h"
#import "ServerConfig.h"

@interface BlackListCellTableViewCell()

@end

@implementation BlackListCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
- (IBAction)cancelAction:(id)sender {
    [self.delegate cancelBlackList:self];
}

@end
