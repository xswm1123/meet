//
//  PostTextAndPictureViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/28.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "PostTextAndPictureViewController.h"

@interface PostTextAndPictureViewController ()<UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *messageBg;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *imageBg;
@property (strong, nonatomic)  UIImageView *btnBg;
@property (strong, nonatomic)  UILabel *lb_iconPlus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *send;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgHight;
@property (nonatomic,strong) NSMutableArray * postImages;
@property (nonatomic,strong) NSMutableArray * imageIVs;
@property (nonatomic,strong) NSMutableArray * imageUrls;
@property (nonatomic,assign) NSInteger  imageCount;
@end
#define imageWith ((DEVCE_WITH-50)/4)
@implementation PostTextAndPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.postImages=[NSMutableArray array];
    self.imageIVs=[NSMutableArray array];
    self.textView.placeholder=@"您的描述...";
    self.textView.delegate=self;
    self.cancel.tintColor=iconRed;
    self.send.tintColor=iconGreen;
    self.send.enabled=NO;
    self.lb_iconPlus=[[UILabel alloc]initWithFrame:CGRectMake(5, 15, imageWith-10, imageWith-10)];
    self.lb_iconPlus.font=[UIFont fontWithName:iconFont size:55];
    self.lb_iconPlus.textColor=[UIColor lightGrayColor];
    self.lb_iconPlus.textAlignment=NSTextAlignmentCenter;
    self.lb_iconPlus.text=@"\U0000e630";
    self.btnBg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 9, imageWith, imageWith)];
    self.btnBg.userInteractionEnabled=YES;
    self.btnBg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnBg.layer.borderWidth=1;
    [self.btnBg addSubview:self.lb_iconPlus];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
    [self.btnBg addGestureRecognizer:tap];
    [self.imageBg addSubview:self.btnBg];
    /**
     *  处理照片
     */
    if (self.images.count>0) {
        self.imageBgHight.constant=self.imageBgHight.constant+(imageWith+10)*((self.images.count+1)/4);
    }else{
        self.imageBgHight.constant=self.imageBgHight.constant+(imageWith+10)*(self.images.count/4);
    }
    [self updateViewConstraints];
    if (self.images.count>0) {
        for (int i=0; i<self.images.count; i++) {
           
        UIImageView * imv=[[UIImageView alloc]initWithImage:self.images[i]];
        imv.frame=CGRectMake(10+(imageWith+10)*(i%4),10+(imageWith+10)*(i/4),imageWith,imageWith);
        [self.imageBg addSubview:imv];
            int j=i+1;
        self.btnBg.frame=CGRectMake(10+(imageWith+10)*(j%4),10+(imageWith+10)*(j/4),imageWith,imageWith);
        [self.postImages addObject:imv.image];
        [self.imageIVs addObject:imv];
        imv.userInteractionEnabled=YES;
        UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [imv addGestureRecognizer:longPress];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubviewsBtns)];
        [imv addGestureRecognizer:tap];
        self.send.enabled=YES;
    }
    }
    if (self.image) {
            UIImageView * imv=[[UIImageView alloc]initWithImage:self.image];
            imv.frame=CGRectMake(10,10,imageWith,imageWith);
            [self.imageBg addSubview:imv];
            self.btnBg.frame=CGRectMake(10+(imageWith+10)*(1),10,imageWith,imageWith);
            [self.postImages addObject:imv.image];
            [self.imageIVs addObject:imv];
            imv.userInteractionEnabled=YES;
            UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [imv addGestureRecognizer:longPress];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubviewsBtns)];
            [imv addGestureRecognizer:tap];
            self.send.enabled=YES;
    }
}
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addPhoto:(id)sender {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9-self.imageIVs.count;
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
    self.send.enabled=YES;
    int m=self.imageIVs.count;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.image) {
            self.imageBgHight.constant=self.imageBgHight.constant+(imageWith+10)*((assets.count+1)/4);
        }else{
            self.imageBgHight.constant=self.imageBgHight.constant+(imageWith+10)*(assets.count/4);
        }
        [self updateViewConstraints];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            int j=0;
                j=i+m;
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10+(imageWith+10)*(j%4),10+(imageWith+10)*(j/4),imageWith,imageWith)];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [self.imageBg addSubview:imgview];
                [self.postImages addObject:tempImg];
                [self.imageIVs addObject:imgview];
                
                //添加删除长按手势
                imgview.userInteractionEnabled=YES;
                UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                [imgview addGestureRecognizer:longPress];
                
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSubviewsBtns)];
                [imgview addGestureRecognizer:tap];
                if (assets.count-1==i) {
                    if (self.imageIVs.count==9) {
                        self.btnBg.hidden=YES;
                    }else{
                        int k=self.imageIVs.count;
                        self.btnBg.frame=CGRectMake(10+(imageWith+10)*(k%4),10+(imageWith+10)*(k/4),imageWith,imageWith);
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
    if (self.imageIVs.count==9) {
        self.btnBg.hidden=YES;
    }else{
        self.btnBg.hidden=NO;
        int k=self.imageIVs.count;
        self.btnBg.frame=CGRectMake(10+(imageWith+10)*(k%4),10+(imageWith+10)*(k/4),imageWith,imageWith);
    }
    for (int i=0; i<self.imageIVs.count; i++) {
        UIImageView* iv=self.imageIVs[i];
        [UIView animateWithDuration:.4 animations:^{
            iv.frame=CGRectMake(10+(imageWith+10)*(i%4),10+(imageWith+10)*(i/4),imageWith,imageWith);
        }];
    }
}

- (IBAction)sendAction:(id)sender {
    /**
     先上传照片，如果有的话！
     */
    if (self.imageIVs.count>0) {
        self.imageUrls=[NSMutableArray array];
        self.imageCount=self.imageIVs.count;
        [self uploadPostImages];
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    }else{
        [self postMessage];
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    }

}
-(void)uploadPostImages{
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@IMG_%@",self.title,[formatter stringFromDate:now]];
    UIImageView * imv=self.imageIVs[self.imageCount-1];
    ImageInfo * details=[[ImageInfo alloc]initWithImage:imv.image];
    [X_BaseAPI uploadFile:details.fileData name:fileName fileName:details.fileName mimeType:details.mimeType Success:^(X_BaseHttpResponse * response) {
        NSArray * arr=(NSArray*)response.data;
        NSString* url=[arr firstObject];
        [self.imageUrls addObject:url];
        --self.imageCount;
        if (self.imageCount>0) {
            [self uploadPostImages];
            
        }else{
            [self postMessage];
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        
    } class:[UploadFilesResponse class]];
    

}
-(void)postMessage{
    PostFriendCircleRequest * request=[[PostFriendCircleRequest alloc]init];
    request.content=self.textView.text;
    NSString* urls=[[NSString alloc]init];
    for (int i =0 ; i<self.imageUrls.count; i++) {
        if (i==0) {
            urls=[urls stringByAppendingString:[self.imageUrls objectAtIndex:i]];
        }else{
            urls=[urls stringByAppendingString:[NSString stringWithFormat:@",%@",[self.imageUrls objectAtIndex:i]]];
        }
    }
    request.picUrl=urls;
    [SystemAPI PostFriendCircleRequest:request success:^(PostFriendCircleResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view.window];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view.window];
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length>0) {
        self.send.enabled=YES;
    }
    return YES;
}
@end
