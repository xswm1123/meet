//
//  HomeFilesTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "HomeFilesTableViewCell.h"
#import "ServerConfig.h"

@implementation HomeFilesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLevel:(NSInteger )level{
    _level=level;
    int queen =level/64;
    int sun =(level%64)/16;
    int moon =(level%16)/4;
    int star =level%4;
    NSString * le=[[NSString alloc]init];
    for (int i =0; i<queen; i++) {
        le=[le stringByAppendingString:@"\U0000e622"];
    }
    for (int i =0; i<sun; i++) {
        le=[le stringByAppendingString:@"\U0000e620"];
    }
    for (int i =0; i<moon; i++) {
        le=[le stringByAppendingString:@"\U0000e621"];
    }
    for (int i =0; i<star; i++) {
        le=[le stringByAppendingString:@"\U0000e623"];
    }

    self.desc.textAlignment=NSTextAlignmentLeft;
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(40, 6, 200, 18)];
    lb.font=[UIFont fontWithName:iconFont size:16];
    lb.text=le;//moon  621 sun 620
    lb.textColor=iconYellow;
    [self.desc addSubview:lb];
    
}
-(void)setType:(NSInteger)type{
    _type=type;
    UIImageView * im=[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 36, 18)];
    [self.desc addSubview:im];
    if (type==1) {
         im.image=[UIImage imageNamed:@"vip2.png"];
    }else{
        im.image=[UIImage imageNamed:@"vip1.png"];
    }
    
}
@end
