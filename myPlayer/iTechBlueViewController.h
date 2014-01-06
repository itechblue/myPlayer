//
//  iTechBlueViewController.h
//  myPlayer
//
//  Created by Simon on 14-1-4.
//  Copyright (c) 2014年 itechblue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"

@interface iTechBlueViewController : UIViewController<VMediaPlayerDelegate>
{
	NSString* videoPath;
	VMediaPlayer       *mMPayer;
	BOOL didPrepared;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayOrPause;
- (IBAction)btnPlayOrPauseClick:(id)sender;
@end