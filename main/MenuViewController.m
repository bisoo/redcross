//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"
#import "CommonController.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;
@synthesize menuItemImgs;
- (void)awakeFromNib
{
    NSString *sessionChk = @"";
    NSString *idtextChk = @"";
    NSHTTPCookie *cookie;
    for(cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
        NSString *name =cookie.name;
        if([name isEqualToString:@"loginOK"]){
            sessionChk = cookie.value;
        }
        if([name isEqualToString:@"loginID"]){
            idtextChk = cookie.value;
        }
    }
    
    if ([sessionChk isEqualToString:@"ok"]) {
        self.menuItems = [NSArray arrayWithObjects:@"교육신청", @"교육안내", @"교육일정", @"공지사항", @"강의/설문", @"마이페이지", @"로그아웃", nil];
    }else{
        self.menuItems = [NSArray arrayWithObjects:@"교육신청", @"교육안내", @"교육일정", @"공지사항", @"강의/설문", @"마이페이지", @"로그인", nil];
    }
    self.menuItemImgs = [NSArray arrayWithObjects:@"01.png", @"04.png", @"05.png", @"08.png", @"03.png", @"07.png", @"06.png", nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.slidingViewController setAnchorRightRevealAmount:280.0f];
  self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:[self.menuItemImgs objectAtIndex:indexPath.row]];
    cell.imageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSInteger row = [indexPath row];
    NSString *value = [menuItems objectAtIndex:row];
    
    NSString *identifier = @"mainView";
    webViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    CommonController *comm = [[CommonController alloc]getInstance];
    
    if(row == 0){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduIntroduce2.do"];
    }else if(row == 1){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduIntroduce.do"];
    }else if(row == 2){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/education/eduScheduleList.do"];
    }else if(row == 3){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/notice/noticeList.do"];
    }else if(row == 4){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/survey/surveyStep1.do"];
    }else if(row == 5){
        view.resultUrl = [comm.contextPath stringByAppendingString:@"/mypage/mypageEduComplHistory.do"];
    }else{
        if ([value isEqualToString:@"로그인"]) {
            view.resultUrl = [comm.contextPath stringByAppendingString:@"/login/login.do"];
        }else{
            [comm setLogoutValue:@"LOGOUT"];
            view.resultUrl = [comm.contextPath stringByAppendingString:@"/logout.do"];
            
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for(cookie in [storage cookies]){
                [storage deleteCookie:cookie];
            }
        }
    }
    [self presentViewController:view animated:NO completion:nil];
    /*
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = view;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopView];
  }];
     */
}

@end
