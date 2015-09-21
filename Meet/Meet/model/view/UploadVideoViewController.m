//
//  UploadVideoViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/7.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "UploadVideoViewController.h"

@interface UploadVideoViewController ()<UITextViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textField;
@property (weak, nonatomic) IBOutlet UIView *videoBG;
//video play
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) NSString *videoPath;//视频播放地址
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@end
// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation UploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.placeholder=@"请输入视频的标题";
    self.textField.delegate=self;
}
- (IBAction)sendAction:(id)sender {
    NSLog(@"path:%@",self.videoPath);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.tag=1000;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"正在处理...";
    HUD.detailsLabelText=[NSString stringWithFormat:@"0%%"];
    [self getVideoRotate:^(BOOL flag) {
        if (flag) {
            [self upload];
        }
    }];
}
- (IBAction)joinAction:(id)sender {
    if ([self.joinButton isSelected]) {
        self.joinButton.selected=NO;
    }else{
        self.joinButton.selected=YES;
    }
}
-(void)upload{
    //初始化进度条
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
    UploadVideoRequest * request =[[UploadVideoRequest alloc]init];
    request.title=self.textField.text;
    if ([self.joinButton isSelected]) {
        request.categoryId=@"1";
    }
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSData * fileData=[NSData dataWithContentsOfFile:self.videoPath];
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *name = [NSString stringWithFormat:@"VIDEO_%@",[formatter stringFromDate:now]];
    NSString * fileName=[NSString stringWithFormat:@"%@.mp4",name];
    AFHTTPRequestOperation* op=[manager POST:UploadVideo parameters:request.lkDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData :fileData name:name fileName:fileName mimeType:@"video/mpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"message:%@",[responseObject objectForKey:@"message"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"message:%@",error.description);
    }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"progress:%.2f",(double)bytesWritten/totalBytesWritten);
        CGFloat precent = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
        HUD.progress = precent;
        HUD.detailsLabelText=[NSString stringWithFormat:@"%.2f%%",precent*100];
        if (precent==1.0000) {
            HUD.labelText = @"正在处理...";
        }else{
            HUD.labelText = @"正在上传...";
        }
    }];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:[responseObject objectForKey:@"message"] toView:ShareAppDelegate.window];
        NSLog(@"message:%@",[responseObject objectForKey:@"message"]);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:error.description toView:self.view];
    }];
    [op start];
}
//video
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpVideoPlayController];
}
-(void)setUpVideoPlayController{
    _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:self.url];
    _moviePlayer.controlStyle=MPMovieControlStyleNone;
    _moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
    _moviePlayer.view.frame=CGRectMake(0, 0, self.videoBG.frame.size.width, self.videoBG.frame.size.height);
    
    [self.videoBG addSubview:_moviePlayer.view];
    [_moviePlayer prepareToPlay];
    [_moviePlayer play];
//    NSDate *now = [NSDate new];
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyMMddHHmmss"];
//    NSString *name = [NSString stringWithFormat:@"VIDEO_%@",[formatter stringFromDate:now]];
    NSString * fileName=[NSString stringWithFormat:@"%@.mp4",@"test"];
    [self videoWithUrl:self.url withFileName:fileName];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.moviePlayer stop];
    self.moviePlayer=nil;
}
// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                [rep orientation];
                NSString * videoPath = [KCachesPath stringByAppendingPathComponent:fileName];
                self.videoPath=videoPath;
                char const *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 1024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
            } failureBlock:nil];
        }
    });
}
-(BOOL) isVideoPortrait:(AVAsset *)asset{
    BOOL isPortrait = FALSE;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = FALSE;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = FALSE;
        }
    }
    return isPortrait;
}
-(AVMutableVideoComposition *) getVideoComposition:(AVAsset *)asset composition:( AVMutableComposition*)composition{
    BOOL isPortrait_ = [self isVideoPortrait:asset];
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    
    AVMutableVideoCompositionLayerInstruction *layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    CGAffineTransform transform = videoTrack.preferredTransform;
    [layerInst setTransform:transform atTime:kCMTimeZero];
    
    
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];

    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    
    CGSize videoSize = videoTrack.naturalSize;
    if(isPortrait_) {
        NSLog(@"video is portrait ");
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMake(1,30);
    videoComposition.renderScale = 1.0;
    return videoComposition;
}
-(void)getVideoRotate:(void(^)(BOOL flag))block{
    CGAffineTransform rotateTranslate;
    CGSize renderSize;
    AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:self.url options:nil];
    AVAssetTrack *sourceVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *sourceAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVMutableComposition* composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:sourceVideoTrack
                                    atTime:kCMTimeZero error:nil];
    [compositionVideoTrack setPreferredTransform:sourceVideoTrack.preferredTransform];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:sourceAudioTrack
                                    atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    [layerInstruction setTransform:rotateTranslate atTime:kCMTimeZero];
    renderSize = sourceVideoTrack.naturalSize;
    AVMutableVideoComposition *videoComposition=[self getVideoComposition:videoAsset composition:composition];
    
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                          presetName:AVAssetExportPresetMediumQuality];
    NSURL * exportUrl = [NSURL fileURLWithPath:self.videoPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    }
    
    assetExport.outputFileType = AVFileTypeMPEG4;
    assetExport.outputURL = exportUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = videoComposition;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
//         switch (assetExport.status)
//         {
//             case AVAssetExportSessionStatusCompleted:
//                 //                export complete
//                 NSLog(@"Export Complete");
//                 [self upload];
//                 break;
//             case AVAssetExportSessionStatusFailed:
//                 NSLog(@"Export Failed");
//                 NSLog(@"ExportSessionError: %@", [assetExport.error localizedDescription]);
//                 //                export error (see exportSession.error)
//                 break;
//             case AVAssetExportSessionStatusCancelled:
//                 NSLog(@"Export Failed");
//                 NSLog(@"ExportSessionError: %@", [assetExport.error localizedDescription]);
//                 //                export cancelled
//                 break;
//         }
         if (assetExport.status==AVAssetExportSessionStatusCompleted) {
             block(YES);
         }else{
             block(NO);
         }
     }];
}
#pragma textView代理，用于收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
