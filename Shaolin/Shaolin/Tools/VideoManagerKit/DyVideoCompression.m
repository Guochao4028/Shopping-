//
//  DyVideoCompression.m
//  Shaolin
//
//  Created by syqaxldy on 2019/10/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "DyVideoCompression.h"
#import <UIKit/UIKit.h>
@interface DyVideoCompression()
@property (nonatomic,assign) NSInteger width;
@property (nonatomic,assign) NSInteger height;
@end
@implementation DyVideoCompression
- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioConfigurations.samplerate = DYAudioSampleRate_11025Hz;
        _audioConfigurations.bitrate = DYAudioBitRate_32Kbps;
        _audioConfigurations.numOfChannels = 1;
        _audioConfigurations.frameSize = 8;
        
        _videoConfigurations.fps = 15;
        _videoConfigurations.videoBitRate = DY_VIDEO_BITRATE_LOW;
        _videoConfigurations.videoResolution =  DY_VIDEO_RESOLUTION_SUPER;
    }
    return self;
}

- (void)startCompressionWithCompletionHandler:(void (^)(DYVideoCompressionState State))handler
{
    NSParameterAssert(handler != nil);
    
    NSParameterAssert(self.inputURL != nil);
    
    NSParameterAssert(self.exportURL != nil);
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.inputURL options:nil];
   
   
   
    AVAssetTrack *videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    float videoBitRate = [videoTrack estimatedDataRate];
    float configurationsBitRate = [self getVideoConfigurationsBitRate];
    
    
    
    
    self.asset = avAsset;
    self.outputURL = self.exportURL;
    self.outputFileType = AVFileTypeMPEG4;
    self.shouldOptimizeForNetworkUse = YES;
    AVAsset *newAsset = [AVAsset assetWithURL:self.inputURL];
    NSArray *tracks = [newAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *newVideoTrack = tracks[0];
    CGSize videoSize = CGSizeApplyAffineTransform(newVideoTrack.naturalSize, newVideoTrack.preferredTransform);
    videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
    NSLog(@"宽%f --- 高%f",videoSize.width,videoSize.height);
    NSInteger videoWidth = videoSize.width;
    NSInteger videoHeight = videoSize.height;
    NSMutableDictionary *videoParameter = [NSMutableDictionary dictionary];
    [videoParameter setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
   
    [videoParameter setObject:@(videoHeight) forKey:AVVideoHeightKey];
    [videoParameter setObject:@(videoWidth) forKey:AVVideoWidthKey];
      
    
   
   
   
    
    NSMutableDictionary *propertiesParameter = [NSMutableDictionary dictionary];
    [propertiesParameter setObject:@(self.videoConfigurations.fps) forKey:AVVideoAverageNonDroppableFrameRateKey];
    [propertiesParameter setObject:AVVideoProfileLevelH264MainAutoLevel forKey:AVVideoProfileLevelKey];
    if (videoBitRate > configurationsBitRate) {
        [propertiesParameter setObject:@(configurationsBitRate) forKey:AVVideoAverageBitRateKey];
    }
    [videoParameter setObject:propertiesParameter forKey:AVVideoCompressionPropertiesKey];
    self.videoSettings = videoParameter;
    
    
    
    
    NSMutableDictionary *audioParameter = [NSMutableDictionary dictionary];
    [audioParameter setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    [audioParameter setObject:@(self.audioConfigurations.numOfChannels) forKey:AVNumberOfChannelsKey];
    [audioParameter setObject:@(self.audioConfigurations.samplerate) forKey:AVSampleRateKey];
    NSInteger bitrate = self.audioConfigurations.bitrate;
    [audioParameter setObject:@(bitrate) forKey:AVEncoderBitRateKey];

    self.audioSettings = audioParameter;
    
    
    [self exportAsynchronouslyWithCompletionHandler:^{
        if ([self status] == AVAssetExportSessionStatusCompleted) {
            
            handler(DY_VIDEO_STATE_SUCCESS);
            // 成功
        }else if(self.status == AVAssetExportSessionStatusExporting){
            
        }else{
            handler(DY_VIDEO_STATE_FAILURE);
            // 失败
        }
    }];
}


- (float)getVideoConfigurationsBitRate
{
    float bitRate = 0;
    switch (self.videoConfigurations.videoResolution) {
        case DY_VIDEO_RESOLUTION_LOW:
            self.height = 352;
            self.width = 288;
            switch (self.videoConfigurations.videoBitRate) {
                case DY_VIDEO_BITRATE_LOW:
                    bitRate =(352 * 288 * 3)/4;
                    break;
                case DY_VIDEO_BITRATE_MEDIUM:
                    
                    bitRate =(352 * 288 * 3)/2;
                    
                    break;
                case DY_VIDEO_BITRATE_HIGH:
                    bitRate =(352 * 288 * 2);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER:
                    bitRate =(352 * 288 * 3);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER_HIGH:
                    bitRate =(352 * 288 * 3) * 2;
                    
                    break;
                default:
                    break;
            }
            
            
            
            break;
        case DY_VIDEO_RESOLUTION_MEDIUM:
            self.height = 480;
            self.width = 360;
            switch (self.videoConfigurations.videoBitRate) {
                case DY_VIDEO_BITRATE_LOW:
                    bitRate =(480 * 360 * 3)/4;
                    break;
                case DY_VIDEO_BITRATE_MEDIUM:
                    bitRate =(480 * 360 * 3)/2;
                    
                    break;
                case DY_VIDEO_BITRATE_HIGH:
                    bitRate =(480 * 360 * 2);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER:
                    bitRate =(480 * 360 * 3);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER_HIGH:
                    bitRate =(480 * 360 * 3) * 2;
                    break;
                default:
                    break;
            }
            
            break;
        case DY_VIDEO_RESOLUTION_HIGH:
            self.height = 640;
            self.width = 480;
            switch (self.videoConfigurations.videoBitRate) {
                case DY_VIDEO_BITRATE_LOW:
                    bitRate =(640 * 480 * 3)/4;
                    break;
                case DY_VIDEO_BITRATE_MEDIUM:
                    bitRate =(640 * 480 * 3)/2;
                    
                    break;
                case DY_VIDEO_BITRATE_HIGH:
                    bitRate =(640 * 480 * 2);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER:
                    bitRate =(640 * 480 * 3);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER_HIGH:
                    bitRate =(640 * 480 * 3) * 2;
                    break;
                default:
                    break;
            }
            
            break;
        case DY_VIDEO_RESOLUTION_SUPER:
            self.height = 960;
            self.width = 540;
            switch (self.videoConfigurations.videoBitRate) {
                case DY_VIDEO_BITRATE_LOW:
                    bitRate =(960 * 540 * 3)/4;
                    break;
                case DY_VIDEO_BITRATE_MEDIUM:
                    bitRate =(960 * 540 * 3)/2;
                    
                    break;
                case DY_VIDEO_BITRATE_HIGH:
                    bitRate =(960 * 540 * 2);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER:
                    bitRate =(960 * 540 * 3);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER_HIGH:
                    bitRate =(960 * 540 * 3) * 2;
                    break;
                default:
                    break;
            }
            
            break;
        case DY_VIDEO_RESOLUTION_SUPER_HIGH:
            self.height = 1280;
            self.width = 720;
            switch (self.videoConfigurations.videoBitRate) {
                case DY_VIDEO_BITRATE_LOW:
                    bitRate =(1280 * 720 * 3)/4;
                    break;
                case DY_VIDEO_BITRATE_MEDIUM:
                    bitRate =(1280 * 720 * 3)/2;
                    
                    break;
                case DY_VIDEO_BITRATE_HIGH:
                    bitRate =(1280 * 720 * 2);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER:
                    bitRate =(1280 * 720 * 3);
                    
                    break;
                case DY_VIDEO_BITRATE_SUPER_HIGH:
                    bitRate =(1280 * 720 * 3) * 2;
                    break;
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    
    
    
    return bitRate;
}
@end
