//
//  EmojDownloadTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/4.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "EmojDownloadTableViewCell.h"
#import "ServerConfig.h"

@implementation EmojDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.photoIV.layer.cornerRadius=5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)downloadAction:(id)sender {
    [self.delegate  DownloadFilesWithCell:self];
}

@end
