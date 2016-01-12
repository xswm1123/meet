//
//  StoreManagerViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoreManagerViewController.h"
#import "ExchangeCityViewController.h"
#import "ChooseAddressViewController.h"

@interface StoreManagerViewController ()<UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,SelectCityDelegate,UIActionSheetDelegate,ChooseAddressDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UIScrollView *imageBGScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_storeType;

@property (weak, nonatomic) IBOutlet UITextField *tf_avaregCost;
@property (weak, nonatomic) IBOutlet UILabel *lb_detailAddress;
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_detailAddress;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *tv_desc;
@property (weak, nonatomic) IBOutlet BaseButton *doneBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_icons;

@property (strong, nonatomic)  UIButton *photoBtn;
@property (nonatomic,strong) NSDictionary * infoDic;
@property (nonatomic,strong) NSDictionary * cityDic;
@property (nonatomic,strong) NSMutableArray * storeCategory;
//photo
@property (nonatomic,strong) NSMutableArray * postImages;
@property (nonatomic,strong) NSMutableArray * imageIVs;
@property (nonatomic,strong) NSMutableArray * imageUrls;
@property (nonatomic,assign) NSInteger  imageCount;

@property (nonatomic,strong) NSArray * picUrls;
@end
#define imageWith ((DEVCE_WITH-50)/4)
@implementation StoreManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    for (UILabel * la in self.lb_icons) {
        la.font=[UIFont fontWithName:iconFont size:18];
        la.text=@"\U0000e639";
    }
    self.tv_desc.placeholder=@"请输入商家描述...";
    self.lb_detailAddress.adjustsFontSizeToFitWidth=YES;
    
    NSAttributedString * str=[[NSAttributedString alloc]initWithString:@"\U0000e630" attributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:60],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.photoBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 80, 80)];
    [self.photoBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.photoBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 10, 10, 10)];
    self.photoBtn.layer.cornerRadius=5;
    self.photoBtn.clipsToBounds=YES;
    self.photoBtn.backgroundColor=[UIColor whiteColor];
    [self.photoBtn addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBGScrollView addSubview:self.photoBtn];
    self.imageBGScrollView.showsHorizontalScrollIndicator=NO;
    self.imageBGScrollView.backgroundColor=[UIColor clearColor];
    self.imageIVs=[NSMutableArray array];
    self.postImages=[NSMutableArray array];
    [self loadDetailsData];
    [self getStoreCategoryList];
}
-(void)loadDetailsData{
    GetMyStoreDetailsRequest * request  =[[GetMyStoreDetailsRequest alloc]init];
    [SystemAPI GetMyStoreDetailsRequest:request success:^(GetMyStoreDetailsResponse *response) {
        self.infoDic=[NSDictionary dictionaryWithDictionary:response.data];
        NSString * urls =[response.data objectForKey:@"picUrl"];
        self.picUrls=[NSArray arrayWithArray:[urls componentsSeparatedByString:@","]];
        [self configData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)configData{
    self.tf_name.text=[self.infoDic objectForKey:@"title"];
    self.lb_address.text=[self.infoDic objectForKey:@"areaName"];
    self.lb_storeType.text=[self.infoDic objectForKey:@"categoryName"];
    self.tf_avaregCost.text=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"price"]];
    self.tf_phoneNumber.text=[self.infoDic objectForKey:@"phone"];
    self.lb_detailAddress.text=[self.infoDic objectForKey:@"address"];
    self.tv_desc.text=[self.infoDic objectForKey:@"description"];
    [self showAlPictures];
}
-(void)showAlPictures{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<self.picUrls.count; i++) {
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10+(imageWith+10)*(i),5,imageWith,80)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview sd_setImageWithURL:[NSURL URLWithString:self.picUrls[i]] placeholderImage:placeHolder];
                [self.imageBGScrollView addSubview:imgview];
                [self.postImages addObject:imgview.image];
                [self.imageIVs addObject:imgview];
                self.imageBGScrollView.contentSize=CGSizeMake(10+(imageWith+10)*(self.imageIVs.count)+90, 90);
                //添加删除长按手势
                imgview.userInteractionEnabled=YES;
                UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                [imgview addGestureRecognizer:longPress];
                
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubviewsBtns)];
                [imgview addGestureRecognizer:tap];
                if (self.picUrls.count-1==i) {
                    if (self.imageIVs.count==30) {
                        self.photoBtn.hidden=YES;
                    }else{
                        self.photoBtn.hidden=NO;
                        NSInteger k=self.imageIVs.count;
                        self.photoBtn.frame=CGRectMake(10+(imageWith+10)*(k),5,80,80);
                    }
                    
                }
            });
        }
    });

}
/**
 *  获得商家类目
 *
 */
-(void)getStoreCategoryList{
    GetStoreCatagoryRequest * request = [[GetStoreCatagoryRequest alloc]init];
    [SystemAPI GetStoreCatagoryRequest:request success:^(GetStoreCatagoryResponse *response) {
        self.storeCategory=[NSMutableArray arrayWithArray:(NSArray*)response.data];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
/**
 *  选择地址
 *
 *  @param sender
 */
- (IBAction)chooseAddress:(id)sender {
    [self performSegueWithIdentifier:@"address" sender:nil];
}
#pragma chooseAddressDelegate
-(void)getAddressFromMap:(NSString *)address{
    self.lb_detailAddress.text=address;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"address"]) {
        ChooseAddressViewController * vc=[segue destinationViewController];
        vc.delegate=self;
    }
}
- (IBAction)chooseCity:(id)sender {
    UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExchangeCityViewController * vc=[sb instantiateViewControllerWithIdentifier:@"ExchangeCityViewController"];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getCityName:(NSDictionary *)city{
    self.cityDic =[NSDictionary dictionaryWithDictionary:city];
    self.lb_address.text=[city objectForKey:@"name"];
}
- (IBAction)chooseType:(id)sender {
    UIActionSheet * al=[[UIActionSheet alloc]initWithTitle:@"请选择行业" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[self.storeCategory[0] objectForKey:@"name" ],[self.storeCategory[1] objectForKey:@"name" ],[self.storeCategory[2] objectForKey:@"name" ],[self.storeCategory[3] objectForKey:@"name" ], nil];
    al.tag=500;
    [al showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==500) {
        if (buttonIndex!=self.storeCategory.count) {
            NSDictionary * dic =[self.storeCategory objectAtIndex:buttonIndex];
            self.lb_storeType.text=[dic objectForKey:@"name"];
            self.lb_storeType.tag=[[dic objectForKey:@"id"] integerValue];
        }
    }
}
- (void)choosePhoto:(id)sender {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 30-self.imageIVs.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSInteger m=self.imageIVs.count;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            NSInteger j=0;
            j=i+m;
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10+(imageWith+10)*(j),5,imageWith,80)];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [self.imageBGScrollView addSubview:imgview];
                [self.postImages addObject:tempImg];
                [self.imageIVs addObject:imgview];
                self.imageBGScrollView.contentSize=CGSizeMake(10+(imageWith+10)*(self.imageIVs.count)+90, 90);
                //添加删除长按手势
                imgview.userInteractionEnabled=YES;
                UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                [imgview addGestureRecognizer:longPress];
                
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubviewsBtns)];
                [imgview addGestureRecognizer:tap];
                if (assets.count-1==i) {
                    if (self.imageIVs.count==30) {
                        self.photoBtn.hidden=YES;
                    }else{
                        self.photoBtn.hidden=NO;
                        NSInteger k=self.imageIVs.count;
                        self.photoBtn.frame=CGRectMake(10+(imageWith+10)*(k),5,80,80);
                    }
                    
                }
            });
        }
    });
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    //    UIImageView* iv=(UIImageView*)longPress.view;
    //    CGPoint p=[longPress locationInView:iv];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
            
        case UIGestureRecognizerStateEnded:
            for (UIImageView * imv in self.imageIVs) {
                UIButton* bt=[[UIButton alloc]initWithFrame:CGRectMake(-5, -5, 20, 20)];
                [bt setTitle:@"-" forState:UIControlStateNormal];
                [bt setTintColor:TempleColor];
                [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                bt.layer.cornerRadius=10;
                bt.backgroundColor=[UIColor redColor];
                bt.layer.borderColor=[UIColor redColor].CGColor;
                bt.layer.borderWidth=1;
                [imv addSubview:bt];
                imv.userInteractionEnabled=YES;
                [bt addTarget:self action:@selector(deleteBt:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
            
        default:
            break;
    }
    
}
-(void)removeSubviewsBtns{
    for (UIImageView * imv in self.imageIVs) {
        [imv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}
-(void)deleteBt:(UIButton*)bt{
    [bt.superview removeFromSuperview];
    [self.imageIVs removeObject:bt.superview];
    if (self.imageIVs.count==30) {
        self.photoBtn.hidden=YES;
    }else{
        self.photoBtn.hidden=NO;
        NSInteger k=self.imageIVs.count;
        self.photoBtn.frame=CGRectMake(10+(imageWith+10)*(k),5,imageWith,80);
    }
    for (int i=0; i<self.imageIVs.count; i++) {
        UIImageView* iv=self.imageIVs[i];
        [UIView animateWithDuration:.4 animations:^{
            iv.frame=CGRectMake(10+(imageWith+10)*(i),5,imageWith,80);
        }];
    }
}

- (IBAction)doneAction:(id)sender {
    if ([self isReadyToSubmmit]) {
        self.imageUrls=[NSMutableArray array];
        self.imageCount=self.imageIVs.count;
        [self uploadPostImages];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
-(void)uploadPostImages{
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@IMG_%@",self.title,[formatter stringFromDate:now]];
    UIImageView * imv=self.imageIVs[self.imageCount-1];
    UIImage * upImage=[ImageInfo makeThumbnailFromImage:imv.image scale:1.0];
    ImageInfo * details=[[ImageInfo alloc]initWithImage:upImage];
    [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
        NSArray * arr=(NSArray*)response.data;
        NSString* url=[arr firstObject];
        [self.imageUrls addObject:url];
        --self.imageCount;
        if (self.imageCount>0) {
            [self uploadPostImages];
        }else{
            [self createGroup];
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        
    } class:[UploadFilesResponse class]];
}
-(void)createGroup{
    /**
     创建
     */
    CreateMyStoreRequest * request =[[CreateMyStoreRequest alloc]init];
    NSString* urls=[[NSString alloc]init];
    for (int i =0 ; i<self.imageUrls.count; i++) {
        if (i==0) {
            urls=[urls stringByAppendingString:[self.imageUrls objectAtIndex:i]];
        }else{
            urls=[urls stringByAppendingString:[NSString stringWithFormat:@",%@",[self.imageUrls objectAtIndex:i]]];
        }
    }
//    request.id=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
    if (self.infoDic) {
        request.storeId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"storeId"]];
    }
    if (self.infoDic) {
        request.areaId=[NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"areaId"]];
    }else{
        request.areaId=[NSString stringWithFormat:@"%@",[self.cityDic objectForKey:@"id"]];
    }
    request.title=self.tf_name.text;
    request.phone=self.tf_phoneNumber.text;
    if (self.infoDic) {
        request.categoryId=[[self.infoDic objectForKey:@"categoryId"] integerValue];
    }else{
        request.categoryId=self.lb_storeType.tag;
    }
    request.price=[self.tf_avaregCost.text doubleValue];
    request.address=self.lb_detailAddress.text;
    request.desc=self.tv_desc.text;
    request.picUrl=urls;
    [SystemAPI CreateMyStoreRequest:request success:^(CreateMyStoreResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
-(BOOL)isReadyToSubmmit{
    if (self.tf_name.text.length==0) {
        [MBProgressHUD showError:@"请输入商家名称！" toView:self.view.window];
        return NO;
    }
    
    if ([self.lb_address.text isEqualToString:@"请选择商家地址"]) {
        [MBProgressHUD showError:@"请选择地区！" toView:self.view.window];
        return NO;
    }
    if (self.imageIVs.count==0) {
        [MBProgressHUD showError:@"请选择商家图片！" toView:self.view.window];
        return NO;
    }
    if (self.tf_avaregCost.text.length==0) {
        [MBProgressHUD showError:@"请输入人均消费！" toView:self.view.window];
        return NO;
    }
    if ([self.lb_detailAddress.text isEqualToString:@"请选择商家详细地址"]) {
        [MBProgressHUD showError:@"请选择商家详细地址！" toView:self.view.window];
        return NO;
    }
    if (self.tf_phoneNumber.text.length==0) {
        [MBProgressHUD showError:@"请输入商家电话！" toView:self.view.window];
        return NO;
    }
    if ([self.lb_storeType.text isEqualToString:@"请选择商家行业"]) {
        [MBProgressHUD showError:@"请选择商家行业！" toView:self.view.window];
        return NO;
    }
    if (self.tv_desc.text.length==0) {
        [MBProgressHUD showError:@"请输入商家描述！" toView:self.view.window];
        return NO;
    }
   
    return YES;
}

#pragma textView代理，用于收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma 监听键盘
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
//    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame;
    CGFloat distance;
    CGFloat yLocation=0;
    if (keyboardFrame.origin.y<self.tv_desc.frame.origin.y+self.tv_desc.frame.size.height) {
        distance=self.tv_desc.frame.origin.y+self.tv_desc.frame.size.height-keyboardFrame.origin.y;
    }
    frame=CGRectMake(0, yLocation, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
       
        [self updateViewConstraints];
    } completion:^(BOOL bl){
    }];
}
- (void)keyboardDisappear:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - self.bottomLayoutGuide.length;
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        
        [self updateViewConstraints];
    } completion:nil];
}



@end
