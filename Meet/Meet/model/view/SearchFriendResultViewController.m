//
//  SearchFriendResultViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SearchFriendResultViewController.h"
#import   "PersonalHomePageViewController.h"

@interface SearchFriendResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_nameAndSex;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@end

@implementation SearchFriendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    NSString * sex=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"sex"]];
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"avatar"]] placeholderImage:placeHolder];
    self.lb_address.text=[self.infoDic objectForKey:@"address"];
    self.lb_nameAndSex.text=[self.infoDic objectForKey:@"nickname"];
    self.lb_nameAndSex.font=[UIFont fontWithName:iconFont size:18];
    NSString * names;
    if ([sex isEqualToString:@"1"]) {
        names=[NSString stringWithFormat:@"%@%@",self.lb_nameAndSex.text,@"\U0000e617"];
        NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, self.lb_nameAndSex.text.length)];
        [str addAttribute:NSForegroundColorAttributeName value:iconBlue range:NSMakeRange(self.lb_nameAndSex.text.length, str.length-self.lb_nameAndSex.text.length)];
        self.lb_nameAndSex.attributedText=str;
    }else{
        names=[NSString stringWithFormat:@"%@%@",self.lb_nameAndSex.text,@"\U0000e616"];
        NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, self.lb_nameAndSex.text.length)];
        [str addAttribute:NSForegroundColorAttributeName value:iconRed range:NSMakeRange(self.lb_nameAndSex.text.length, str.length-self.lb_nameAndSex.text.length)];
        self.lb_nameAndSex.attributedText=str;
    }
}
- (IBAction)showHomePage:(id)sender {
    [self performSegueWithIdentifier:@"homePage" sender:[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"memberId"]]];
}
- (IBAction)addFriednAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SendFriendRstRequest * request =[[SendFriendRstRequest alloc]init];
    request.friendId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"memberId"]];
    [SystemAPI SendFriendRstRequest:request success:^(SendFriendRstResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"homePage"]) {
        PersonalHomePageViewController * vc=segue.destinationViewController;
        vc.memberId=sender;
    }
}

@end
