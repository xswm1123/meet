//
//  HomeFilesTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFilesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *marks;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (nonatomic,assign) NSInteger  level;
@property (nonatomic,assign) NSInteger type;
@end
