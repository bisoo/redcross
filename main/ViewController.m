//
//  ViewController.m
//  ulearn2
//
//  Created by coretechmobile on 13. 5. 16..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import "ViewController.h"
#import "CommonController.h"
#import "HTTPRequest.h"
#import <sqlite3.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {

    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
    [_mainView release];
    [_viewToolbar release];
    [_topView release];
    [_homebutton release];
    [_settingbutton release];
    [super dealloc];
}
- (IBAction)click1:(id)sender {
    
    webViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    CommonController *comm = [[CommonController alloc]getInstance];
    
    if([sender tag]==1){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduIntroduce2.do"];
    }else if([sender tag]==2){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduIntroduce.do"];
    }else if([sender tag]==3){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduScheduleList.do"];
    }else if([sender tag]==4){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/notice/noticeList.do"];
    }else if([sender tag]==5){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/survey/surveyStep1.do"];
    }else if([sender tag]==6){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/mypage/mypageEduComplHistory.do"];
    }
   
    [self presentViewController:view animated:NO completion:nil];
}

- (IBAction)topBtnClick:(id)sender {
    webViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    CommonController *comm = [[CommonController alloc]getInstance];
    if([sender tag]==1){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/notice/noticeList.do"];
    }else if([sender tag]==2){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduIntroduce.do"];
    }else if([sender tag]==3){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/mypage/mypageEduComplHistory.do"];
    }else if([sender tag]==4){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/survey/surveyStep1.do"];
    }
    
    [self presentViewController:view animated:NO completion:nil];
}

- (IBAction)quickMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
