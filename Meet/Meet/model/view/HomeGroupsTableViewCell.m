//
//  HomeGroupsTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "HomeGroupsTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation HomeGroupsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)joinAction:(id)sender {
    [self.delegate joinGroup:self];
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.groupPhoto sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
-(void)setGroupId:(NSString *)groupId{
    _groupId=groupId;
    
}
@end
