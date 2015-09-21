//
//  MyVideosTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/9/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MyVideosTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"
@interface MyVideosTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;

@end
@implementation MyVideosTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.photoIV.layer.cornerRadius=5;
    self.photoIV.clipsToBounds=YES;
}
-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic=infoDic;
    self.lb_name.text=[infoDic objectForKey:@"title"];
    self.lb_date.text=[infoDic objectForKey:@"created"];
    self.lb_desc.text=[NSString stringWithFormat:@"观看次数:%@ 评论次数:%@",[infoDic objectForKey:@"viewCount"],[infoDic objectForKey:@"commentCount"]];
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"picUrl"]]] placeholderImage:placeHolder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
