//
//  SettingViewController.h
//  ulearn2
//
//  Created by coretechmobile on 13. 5. 22..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webViewController.h"
#define kFilename @"data.sqlite3"
#define kDatakey @"Data"
@interface SettingViewController : UITableViewController{
   
}
- (IBAction)loginpageMove:(id)sender;
- (IBAction)logoutChk:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *idText;
@property (retain, nonatomic) IBOutlet UIButton *logoutButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UISwitch *autoLoginChk;
- (IBAction)switchChanged:(id)sender;
- (NSString *)dataFilepath;
@end
