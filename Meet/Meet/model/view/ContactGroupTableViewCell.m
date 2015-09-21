//
//  ContactGroupTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ContactGroupTableViewCell.h"
#import "ServerConfig.h"

@implementation ContactGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.iconBg.backgroundColor=NAVI_COLOR;
    self.lb_icon.font=[UIFont fontWithName:iconFont size:45];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
