//
//  SettingViewController.m
//  ulearn2
//
//  Created by coretechmobile on 13. 5. 22..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonController.h"
#import <sqlite3.h>
@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize idText;
@synthesize loginButton;
@synthesize logoutButton;
@synthesize autoLoginChk;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        idText.text = idtextChk;
        logoutButton.hidden = NO;
        loginButton.hidden = YES;
        
    }else{
        logoutButton.hidden = YES;
        loginButton.hidden = NO;
    }
    
    sqlite3 *database;
    
    if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *query = @"SELECT row,LOGINYN FROM LOGIN_SETTING";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *loginyndata = (char *)sqlite3_column_text(stmt, 1);
            
            NSString *loginynValue = [[NSString alloc] initWithUTF8String:loginyndata];
           
            if([loginynValue isEqualToString:@"Y"]){
                [autoLoginChk setOn:YES];
            }else{
                [autoLoginChk setOn:NO];
            }    
        }
    }

    sqlite3_close(database);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginpageMove:(id)sender {
    webViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    CommonController *comm = [[CommonController alloc]getInstance];

    view.resultUrl = [comm.contextPath stringByAppendingString:@"/login/login.do"];
    
    [self presentViewController:view animated:NO completion:nil];
}

- (IBAction)logoutChk:(id)sender {
    webViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    CommonController *comm = [[CommonController alloc]getInstance];
    [comm setLogoutValue:@"LOGOUT"];
    view.resultUrl = [comm.contextPath stringByAppendingString:@"/logout.do"];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
     
    [self presentViewController:view animated:NO completion:nil];
}
- (void)dealloc {
    [idText release];
    [logoutButton release];
    [loginButton release];
    [autoLoginChk release];
    [super dealloc];
}



- (IBAction)switchChanged:(id)sender {
    NSString *loginchk = @"";
    
    if(autoLoginChk.on){
        loginchk = @"Y";
    }else{
        loginchk = @"N";
    }
       
    sqlite3 *database;

    if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }

    char *errorMsg;
    
    NSString *rowValue = @"";
    NSString *loginidValue = @"";
    NSString *loginpwdValue = @"";
    NSString *loginynValue = @"";
    NSString *query = @"SELECT row,USER_ID,USER_PWD,LOGINYN, FROM LOGIN_SETTING";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int row = sqlite3_column_int(stmt, 0);
            char *userIDdata = (char *)sqlite3_column_text(stmt, 1);
            char *userPWDdata = (char *)sqlite3_column_text(stmt, 2);
            char *loginyndata = (char *)sqlite3_column_text(stmt, 3);
            
            rowValue = [[NSString alloc]initWithFormat:@"%d",row];
            loginidValue = [[NSString alloc] initWithUTF8String:userIDdata];
            loginpwdValue = [[NSString alloc] initWithUTF8String:userPWDdata];
            loginynValue = [[NSString alloc] initWithUTF8String:loginyndata];
        }
    }
    sqlite3_finalize(stmt);

    NSString *query2 = @"DELETE FROM LOGIN_SETTING;";
    
    if(sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Error delete table: %s",errorMsg);
    }
    sqlite3_finalize(stmt);
    
    NSString *query3 = @"INSERT OR REPLACE INTO LOGIN_SETTING (row,USER_ID,USER_PWD,LOGINYN) VALUES (?,?,?,?);";
    
    
    if(sqlite3_prepare_v2(database, [query3 UTF8String], -1, &stmt, nil) == SQLITE_OK){
        int i = 1;
        NSString *n1 = loginidValue;
        NSString *n2 = loginpwdValue;
        NSString *n3 = loginchk;
        sqlite3_bind_int(stmt, 1, i);
        sqlite3_bind_text(stmt, 2, [n1 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [n2 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [n3 UTF8String], -1, NULL);
    }
    
    if(sqlite3_step(stmt) != SQLITE_DONE){
        NSAssert1(0, @"Error insert LOGIN_SETTING table : %s", errorMsg);
    }
    sqlite3_finalize(stmt);        
    sqlite3_close(database);

    [rowValue release];
    [loginidValue release];
    [loginpwdValue release];
    [loginynValue release];
}
@end
