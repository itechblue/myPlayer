//
//  iTechBlueViewController.m
//  myPlayer
//
//  Created by Simon on 14-1-4.
//  Copyright (c) 2014年 itechblue. All rights reserved.
//

#import "iTechBlueViewController.h"

@interface iTechBlueViewController ()

@end

@implementation iTechBlueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	videoPath = [self findVideoInDocuments];
	if(videoPath)
	{
		_lblTitle.text = [videoPath lastPathComponent];
		[self initPlayer];
	}
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(videoPath)
	{
		[self prepareVideo];
	}
}

#pragma mark - 检查视频文件
-(NSString*)findVideoInDocuments
{
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSFileManager *fileMg = [[NSFileManager alloc] init];

	//遍历Documents下的文件，找到视频文件就返回它的全路径
	NSArray *subPaths = [fileMg contentsOfDirectoryAtPath:documentsDirectory error:nil];
	if (subPaths) {
		for (NSString *subPath in subPaths) {
            if ( [self isMediaFile:[subPath pathExtension]]) {
				NSString *path = [documentsDirectory stringByAppendingPathComponent:subPath];
				return path;
			}
		}
	}
	return nil;
}

-(BOOL)isMediaFile:(NSString*)pathExtension
{
	//可用格式
	/*
	 ".M1V", ".MP2", ".MPE", ".MPG", ".WMAA",
	 ".MPEG", ".MP4", ".M4V", ".3GP", ".3GPP", ".3G2", ".3GPP2", ".MKV",
	 ".WEBM", ".MTS", ".TS", ".TP", ".WMV", ".ASF", ".ASX", ".FLV",
	 ".MOV", ".QT", ".RM", ".RMVB", ".VOB", ".DAT", ".AVI", ".OGV",
	 ".OGG", ".VIV", ".VIVO", ".WTV", ".AVS", ".SWF", ".YUV"
	 */
	
	//简单粗暴地判断是否为视频格式，这里先试6个
	NSString*ext = [pathExtension uppercaseString];
	if([ext isEqualToString:@"MP4"])
	{
		return YES;
	}
	else if([ext isEqualToString:@"MOV"])
	{
		return YES;
	}
	else if([ext isEqualToString:@"RMVB"])
	{
		return YES;
	}
	else if([ext isEqualToString:@"MKV"])
	{
		return YES;
	}
	else if([ext isEqualToString:@"FLV"])
	{
		return YES;
	}
	else if([ext isEqualToString:@"TS"])
	{
		return YES;
	}

	return NO;
}

#pragma mark - 播放器相关
-(void)initPlayer
{
	if (!mMPayer) {
		mMPayer = [VMediaPlayer sharedInstance];
		[mMPayer setupPlayerWithCarrierView:self.playerView withDelegate:self];
	}
}

-(void)prepareVideo
{
	if(videoPath)
	{
		[UIApplication sharedApplication].idleTimerDisabled = YES;//播放时不要锁屏
		NSURL* videoURL = [NSURL fileURLWithPath:videoPath];
		[mMPayer setDataSource:videoURL];
		[mMPayer prepareAsync];
	}
}

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
	//显示“暂停”两字
	_btnPlayOrPause.selected = YES;
	didPrepared = YES;
    [player start];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
	_btnPlayOrPause.selected = NO;
	[player reset];
	didPrepared = NO;
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"VMediaPlayer Error: %@", arg);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPlayOrPauseClick:(id)sender {
	if(videoPath)
	{
		BOOL isPlaying = [mMPayer isPlaying];
		if (isPlaying) {
			[mMPayer pause];
			_btnPlayOrPause.selected = NO;
		} else {
			if(didPrepared)
				[mMPayer start];
			else
				[self prepareVideo];
			_btnPlayOrPause.selected = YES;
		}
	}
}
@end
