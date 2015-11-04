//
//  webViewController.h
//  educt
//
//  Created by coretechmobile on 13. 6. 18..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialSlidingViewController.h"
#define kFilename @"data.sqlite3"
#define kDatakey @"Data"
@interface webViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *main;
    NSString *resultUrl;

    
}
@property (retain, nonatomic) IBOutlet UIToolbar *webToolbar;
@property (readwrite,assign) NSString *resultUrl;
@end
