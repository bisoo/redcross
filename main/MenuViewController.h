//
//  MenuViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "webViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>{
    NSArray * menuItemImgs;
}
@property (nonatomic, retain) NSArray *menuItemImgs;
@end
