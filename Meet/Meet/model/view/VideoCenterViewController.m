//
//  VideoCenterViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VideoCenterViewController.h"
#import "BaseView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadVideoViewController.h"

@interface VideoCenterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet BaseView *videoBG;
@property (weak, nonatomic) IBOutlet BaseView *uploadBG;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconVideo;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconUpload;
@property (strong ,nonatomic) AVPlayer *player;//播放器，用于录制完视频后播放视频
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSString * videoUrl;
@property (nonatomic,assign) BOOL isRecord;
@end

@implementation VideoCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb_iconVideo.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconVideo.text=@"\U0000e610";
    self.lb_iconVideo.textColor=iconRed;
    self.lb_iconUpload.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconUpload.text=@"\U0000e60c";
    self.lb_iconUpload.textColor=iconGreen;
}
- (IBAction)takeVideo:(UITapGestureRecognizer *)sender {
    NSLog(@"takeVideo");
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
- (IBAction)uploadVideo:(id)sender {
    NSLog(@"uploadVideo");
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.assetsFilter = [ALAssetsFilter allVideos];
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
    ALAsset * sset=[assets objectAtIndex:0];
    NSURL * videoUrl=sset.defaultRepresentation.url;
     [self performSegueWithIdentifier:@"upload" sender:videoUrl];
}
//video
// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

// 检查摄像头是否支持录像
- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
            _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;//wifi
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            _imagePicker.videoMaximumDuration=300.0;
            _imagePicker.allowsEditing=YES;//允许编辑
        
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}
#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
        if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
            NSLog(@"video...");
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSString *urlStr=[url path];
            self.videoUrl=urlStr;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        [self performSegueWithIdentifier:@"upload" sender:url];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"upload"]) {
        UploadVideoViewController * vc=segue.destinationViewController;
        vc.url=sender;
    }
}
@end
