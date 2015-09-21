//
//  CreateGroupViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "ExchangeCityViewController.h"

@interface CreateGroupViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,SelectCityDelegate,ZYQAssetPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (strong, nonatomic)  UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_groupCount;
@property (weak, nonatomic) IBOutlet UIButton *VIPBtn;
@property (weak, nonatomic) IBOutlet UITextView *tv_desc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BaseView *tagsBg;
@property (nonatomic,strong) UIImage * photoImage;
@property (nonatomic,strong) NSDictionary * cityInfo;
/**
 *  pick
 */
@property (nonatomic,strong)  UIView * pickerBG;
@property (nonatomic,strong) UIPickerView* picker;
@property (nonatomic,copy) NSString * pickTempValue;
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
//tags
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,strong) NSMutableArray * tagsBtn;
//photo
@property (nonatomic,strong) NSMutableArray * postImages;
@property (nonatomic,strong) NSMutableArray * imageIVs;
@property (nonatomic,strong) NSMutableArray * imageUrls;
@property (nonatomic,assign) NSInteger  imageCount;
@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self getTags];
}
-(void)getTags{
    GetGroupTagsRequest * reqeust =[[ GetGroupTagsRequest alloc]init];
    [SystemAPI GetGroupTagsRequest:reqeust success:^(GetGroupTagsResponse *response) {
        self.tags=[(NSArray *)response.data copy];
        [self configTags];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
-(void)configTags{
    self.tagsBtn=[NSMutableArray array];
    CGFloat btnWidth=(DEVCE_WITH-72)/4;
    for (int i =0; i<self.tags.count; i++) {
        NSDictionary * dic =[self.tags objectAtIndex:i];
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(30+((btnWidth+4)*(i%4)), 35+((30+10)*(i/4)), btnWidth, 30)];
        btn.clipsToBounds=YES;
        btn.layer.cornerRadius=5;
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        btn.tag=[[dic objectForKey:@"id"] integerValue];
        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagsBtn addObject:btn];
        [self.tagsBg addSubview:btn];
        
    }
}
-(void)chooseTag:(UIButton*) btn{
    btn.selected=YES;
    [btn setBackgroundColor:TempleColor];
    for (UIButton * tagBtn in self.tagsBtn) {
        if (btn.tag!=tagBtn.tag) {
            tagBtn.selected=NO;
            [tagBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}
-(void)initView{
    NSAttributedString * str=[[NSAttributedString alloc]initWithString:@"\U0000e630" attributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:60],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.photoBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 80, 80)];
    [self.photoBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.photoBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 10, 10, 10)];
    self.photoBtn.layer.cornerRadius=5;
    self.photoBtn.clipsToBounds=YES;
    self.photoBtn.backgroundColor=[UIColor whiteColor];
    [self.photoBtn addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageScroll addSubview:self.photoBtn];
    self.imageScroll.showsHorizontalScrollIndicator=NO;
    self.imageScroll.backgroundColor=[UIColor clearColor];
    self.imageIVs=[NSMutableArray array];
    self.postImages=[NSMutableArray array];
    /**
     *  pick
     */
    self.pickerBG=[[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVCE_WITH, 250)];
    self.pickerBG.backgroundColor=NAVI_COLOR;
    [self.view addSubview:self.pickerBG];
    self.picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, DEVCE_WITH, 210)];
    self.picker.delegate=self;
    self.picker.dataSource=self;
    self.picker.backgroundColor=[UIColor whiteColor];
    [self.pickerBG addSubview:self.picker];
    UIButton* cancel =[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(dismissPickerAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBG addSubview:cancel];
    UIButton* confirm =[[UIButton alloc]initWithFrame:CGRectMake(DEVCE_WITH-70, 0, 60, 40)];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setBackgroundColor:[UIColor clearColor]];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [confirm addTarget:self action:@selector(confirmTheName) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBG addSubview:confirm];
    [self getPickerData];

}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}
-(void)confirmTheName{
    self.lb_address.text=[NSString stringWithFormat:@"%@ %@ %@",[self.provinceArray objectAtIndex:[self.picker selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.picker selectedRowInComponent:1]] ,[self.townArray objectAtIndex:[self.picker selectedRowInComponent:2]]];
    [self dismissPickerAnimation];
}
/**
 *  呼出picker动画
 */
-(void)showPickerAnimation{
    CGRect frame=self.pickerBG.frame;
    frame.origin.y=DEVICE_HEIGHT- frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBG.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  pick消失动画
 */
-(void)dismissPickerAnimation{
    CGRect frame=self.pickerBG.frame;
    frame.origin.y=DEVICE_HEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBG.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)choosePhoto:(id)sender {
//    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相机选择", nil];
//    
//    [as showInView:self.view.window];
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
#define imageWith ((DEVCE_WITH-50)/4)
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
                [self.imageScroll addSubview:imgview];
                [self.postImages addObject:tempImg];
                [self.imageIVs addObject:imgview];
                 self.imageScroll.contentSize=CGSizeMake(10+(imageWith+10)*(self.imageIVs.count)+90, 90);
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    /**
     *  photo
     */
    UIImagePickerController * imagePick=[[UIImagePickerController alloc]init];
    imagePick.delegate=self;
    if (buttonIndex==0) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController: imagePick animated:YES completion:NULL];
    }
    if (buttonIndex==1) {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController: imagePick animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photoBtn setImage:image forState:UIControlStateNormal];
    self.photoImage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)chooseAddress:(id)sender {
    [self performSegueWithIdentifier:@"city" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"city"]) {
        ExchangeCityViewController * vc=segue.destinationViewController;
        vc.delegate=self;
    }
}
-(void)getCityName:(NSDictionary *)city{
    self.cityInfo=[city copy];
    self.lb_address.text=[city objectForKey:@"name"];
}
- (IBAction)beTheVIP:(id)sender {
    
}
- (IBAction)createGroupAction:(id)sender {
    if ([self isReadyToSubmmit]) {
        self.imageUrls=[NSMutableArray array];
        self.imageCount=self.imageIVs.count;
        [self uploadPostImages];
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    }
}
-(void)uploadPostImages{
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@IMG_%@",self.title,[formatter stringFromDate:now]];
    UIImageView * imv=self.imageIVs[self.imageCount-1];
    UIImage * upImage=[ImageInfo makeThumbnailFromImage:imv.image scale:0.5];
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
    CreateGroupRequest * request =[[CreateGroupRequest alloc]init];
    request.name=self.tf_name.text;
    NSString* urls=[[NSString alloc]init];
    for (int i =0 ; i<self.imageUrls.count; i++) {
        if (i==0) {
            urls=[urls stringByAppendingString:[self.imageUrls objectAtIndex:i]];
        }else{
            urls=[urls stringByAppendingString:[NSString stringWithFormat:@",%@",[self.imageUrls objectAtIndex:i]]];
        }
    }

    request.picUrl=urls;
    request.areaId=[NSString stringWithFormat:@"%@",[self.cityInfo objectForKey:@"id"]];
    request.maxNum=@"50";
//    request.description=self.tv_desc.text;
    NSString * tagId;
    for (UIButton * btn in self.tagsBtn) {
        if ([btn isSelected]) {
            tagId=[NSString stringWithFormat:@"%d",(int)btn.tag];
        }
    }
    request.categoryId=tagId;
    [SystemAPI  CreateGroupRequest:request success:^(CreateGroupResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view.window];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view.window];
    }];
    

}
-(BOOL)isReadyToSubmmit{
    if (self.tf_name.text.length==0) {
        [MBProgressHUD showError:@"请输入群组名称！" toView:self.view.window];
        return NO;
    }
  
    if (self.lb_address.text.length==0) {
        [MBProgressHUD showError:@"请选择地区！" toView:self.view.window];
        return NO;
    }
    if (self.imageIVs.count==0) {
        [MBProgressHUD showError:@"请选择头像！" toView:self.view.window];
        return NO;
    }
    BOOL isTag=NO;
    for (UIButton * btn in self.tagsBtn) {
        if ([btn isSelected]) {
            isTag=YES;
        }
    }
    if (!isTag) {
        [MBProgressHUD showError:@"请选择标签！" toView:self.view.window];
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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
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
        self.distanceToBtn.constant=35+keyboardFrame.size.height-distance;
        self.scrollView.contentOffset=CGPointMake(0, keyboardFrame.size.height);
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
        self.distanceToBtn.constant=35;
        self.scrollView.contentOffset=CGPointMake(0, 0);
        
        [self updateViewConstraints];
    } completion:nil];
}

@end
