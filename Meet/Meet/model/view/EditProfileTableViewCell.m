//
//  EditProfileTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "EditProfileTableViewCell.h"
#import "ServerConfig.h"

@implementation EditProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
