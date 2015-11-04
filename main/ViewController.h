//
//  ViewController.h
//  ulearn2
//
//  Created by coretechmobile on 13. 5. 16..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#define kFilename @"data.sqlite3"
#define kDatakey @"Data"

@interface ViewController : UIViewController{
}

- (IBAction)closeClick:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *homebutton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *settingbutton;
@property (retain, nonatomic) IBOutlet UIToolbar *viewToolbar;
- (IBAction)click1:(id)sender;
- (IBAction)topBtnClick:(id)sender;


- (IBAction)quickMenu:(id)sender;

@end
