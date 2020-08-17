//
//  DyVideoCompression.h
//  Shaolin
//
//  Created syqaxldy on 2019/10/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DyAVAssetExportSession.h"
typedef enum DYVideoResolution{
    DY_VIDEO_RESOLUTION_LOW,           // 352 * 288
    DY_VIDEO_RESOLUTION_MEDIUM,        // 480 * 360
    DY_VIDEO_RESOLUTION_HIGH,          // 640 * 480
    DY_VIDEO_RESOLUTION_SUPER,         // 960 * 540
    DY_VIDEO_RESOLUTION_SUPER_HIGH,    // 1280 * 720
}DYVideoResolution;

typedef enum DYVideoBitRate{
    DY_VIDEO_BITRATE_LOW,           // （width * height * 3）/ 4
    DY_VIDEO_BITRATE_MEDIUM,        // （width * height * 3）/ 2
    DY_VIDEO_BITRATE_HIGH,          // （width * height * 2)
    DY_VIDEO_BITRATE_SUPER,         // （width * height * 3)
    DY_VIDEO_BITRATE_SUPER_HIGH,    // （width * height * 3）* 2
}DYVideoBitRate;

typedef struct DYVideoConfigurations{
    /* indicates the interval which the video composition, when enabled, should render composed video frames */
    int fps; // (0~30)
    DYVideoBitRate videoBitRate; /* bits per second, H.264 only */
    DYVideoResolution videoResolution;    // resolution
    
}DYVideoConfigurations;


typedef enum DYAudioSampleRate{
    ///  8KHz
    DYAudioSampleRate_8000Hz  = 8000,
    ///  11KHz
    DYAudioSampleRate_11025Hz = 11025,
    ///  16KHz
    DYAudioSampleRate_16000Hz = 16000,
    ///  22KHz
    DYAudioSampleRate_22050Hz = 22050,
    ///  32KHz
    DYAudioSampleRate_32000Hz = 32000,
    ///  44.1KHz
    DYAudioSampleRate_44100Hz = 44100,
    ///  48KHz
    DYAudioSampleRate_48000Hz = 48000
}DYAudioSampleRate;

typedef enum DYAudioBitRate {
    /// 32Kbps
    DYAudioBitRate_32Kbps = 32000,
    /// 64Kbps
    DYAudioBitRate_64Kbps = 64000,
    /// 96Kbps
    DYAudioBitRate_96Kbps = 96000,
    /// 128Kbps
    DYAudioBitRate_128Kbps = 128000,
    /// 192Kbps
    DYAudioBitRate_192Kbps = 192000,
    //  224kbps
    DYAudioBitRate_224Kbps = 224000
    
}DYAudioBitRate;

typedef struct DYAudioConfigurations{
    DYAudioSampleRate samplerate;
    DYAudioBitRate bitrate;
    int numOfChannels; //(1~2)
    int frameSize; /* value is an integer, one of: 8, 16, 24, 32 */
}DYAudioConfigurations;


typedef enum DYVideoCompressionState{
    DY_VIDEO_STATE_FAILURE,
    DY_VIDEO_STATE_SUCCESS
}DYVideoCompressionState;



@interface DyVideoCompression : DyAVAssetExportSession
/**
 * The URL of the export session’s output.
 *
 * You can observe this property using key-value observing.
 */
@property (nonatomic, copy) NSURL *exportURL;
/**
 * The URL of the writer session’s input.
 *
 * You can observe this property using key-value observing.
 */
@property (nonatomic, copy) NSURL *inputURL;

/**
 * The settings used for encoding the video track.
 */
@property (nonatomic, assign) DYVideoConfigurations videoConfigurations;
/**
 * The settings used for encoding the audio track.
 */
@property (nonatomic, assign) DYAudioConfigurations audioConfigurations;

- (void)startCompressionWithCompletionHandler:(void (^)(DYVideoCompressionState State))handler;


@end


