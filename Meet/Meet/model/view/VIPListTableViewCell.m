//
//  VIPListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/5.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VIPListTableViewCell.h"
#import "ServerConfig.h"

@implementation VIPListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
