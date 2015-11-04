//
//  webViewController.m
//  educt
//
//  Created by coretechmobile on 13. 6. 18..
//  Copyright (c) 2013년  core technology. All rights reserved.
//

#import "webViewController.h"
#import "HTTPRequest.h"
#import "CommonController.h"
#import <sqlite3.h>
@interface webViewController ()

@end

@implementation webViewController
@synthesize resultUrl;
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    main.delegate = self;
    
    sqlite3 *database;
    
    if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *errorMsg;
    
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS LOGIN_SETTING(row INTEGER PRIMART KEY ,USER_ID TEXT,USER_PWD TEXT,LOGINYN TEXT)";
    
    if(sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s",errorMsg);
    }
    
    NSString *rowValue = @"";
    NSString *loginidValue = @"";
    NSString *loginpwdValue = @"";
    NSString *loginynValue = @"";
    NSString *query = @"SELECT row,USER_ID,USER_PWD,LOGINYN FROM LOGIN_SETTING";
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
    
    sqlite3_close(database);

    NSString *value1 = @"";
    NSHTTPCookie *cookie;
    for(cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
        if([cookie.name isEqualToString:@"loginOK"]){
            value1 = cookie.value;
        }//if
        
    }//for

    CommonController *comm = [[CommonController alloc]getInstance];
    //자동로그인 구성
    if([loginynValue isEqualToString:@"Y"]){
        if(![loginidValue isEqualToString:@""]){
            if (![comm.logoutValue isEqualToString:@"LOGOUT"]) {
                if ([value1 isEqualToString:@""]) {
                    resultUrl = [comm.contextPath stringByAppendingString:[NSString stringWithFormat:@"/loginProc.do?loginId=%@&loginPw=%@",loginidValue,loginpwdValue]];
                }
            }
        }
    }

    NSURL *url = [NSURL URLWithString:resultUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [main loadRequest:request];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//특정 Request 캐치하기
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = [[request URL]absoluteString];

    NSString *value1 = @"";
    NSString *value2 = @"";
    NSString *value3 = @"";
    
    CommonController *comm = [[CommonController alloc]getInstance];
    NSString *serverUrl_1 = [comm.contextPath stringByAppendingString:@"/logout.do"];
    NSString *serverUrl_2 = [comm.contextPath stringByAppendingString:@"/main.do"];
    
    if([url isEqualToString:serverUrl_1]){
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for(cookie in [storage cookies]){
            [storage deleteCookie:cookie];
        }//for
    }//if
    
    if([url isEqualToString:serverUrl_2]){
        NSHTTPCookie *cookie;
        for(cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
            if([cookie.name isEqualToString:@"loginOK"]){
                value1 = cookie.value;
            }//if
            
            if([cookie.name isEqualToString:@"loginID"]){
                value2 = cookie.value;
            }//if
            
            if([cookie.name isEqualToString:@"loginPW"]){
                value3 = [self _escapedString:cookie.value];
            }//if
        }//for
        
        sqlite3 *database;
        
        if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
            sqlite3_close(database);
            NSAssert(0, @"Failed to open database");
        }//if
        
        char *errorMsg;
        
        NSString *rowValue = @"";
        NSString *loginidValue = @"";
        NSString *loginpwdValue = @"";
        NSString *loginynValue = @"";
        NSString *query = @"SELECT row,USER_ID,USER_PWD,LOGINYN FROM LOGIN_SETTING";
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
                
            }//while
        }//if
        
        if ([loginynValue isEqualToString:@"Y"]) {
            
            if(![value2 isEqualToString:@""]){
                NSString *query2 = @"DELETE FROM LOGIN_SETTING;";
                
                if(sqlite3_exec(database, [query2 UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
                    sqlite3_close(database);
                    NSAssert(0, @"Error delete table: %s",errorMsg);
                }//if
                
                NSString *query3 = @"INSERT OR REPLACE INTO LOGIN_SETTING (row,USER_ID,USER_PWD,LOGINYN) VALUES (?,?,?,?);";
                
                if(sqlite3_prepare_v2(database, [query3 UTF8String], -1, &stmt, nil) == SQLITE_OK){
                    int i = 1;
                    NSString *n1 = value2;
                    NSString *n2 = value3;
                    NSString *n3 = loginynValue;
                    sqlite3_bind_int(stmt, 1, i);
                    sqlite3_bind_text(stmt, 2, [n1 UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 3, [n2 UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 4, [n3 UTF8String], -1, NULL);
                }//if
                
                if(sqlite3_step(stmt) != SQLITE_DONE){
                    NSAssert1(0, @"Error insert LOGIN_SETTING table : %s", errorMsg);
                }//if
                sqlite3_finalize(stmt);
                sqlite3_close(database);
                
                [rowValue release];
                [loginidValue release];
                [loginpwdValue release];
                [loginynValue release];
            }//if
        }//if
    }//if
    
    return YES; //YES = 그대로 진행
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *addr = [[main.request URL]absoluteString];
    CommonController *comm = [[CommonController alloc]getInstance];
    NSString *serverUrl_2 = [comm.contextPath stringByAppendingString:@"/main.do"];
    
    NSMutableString *escaped =  [[NSMutableString alloc]initWithString:addr];
    NSRange range = [escaped rangeOfString:serverUrl_2];
    if (range.location != NSNotFound) {
        NSString *identifier = @"initai";
        InitialSlidingViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self presentViewController:view animated:NO completion:nil];
    }
}

- (NSString*)_escapedString:(NSString*)string

{
    if( string == nil ) {
        return @"";
    }
    
    NSMutableString *escaped =  [[NSMutableString alloc]initWithString:string];
    
    NSString *search = @"%2B";
    NSString *replace = @"+";
    NSRange range = [escaped rangeOfString:search];
    if (range.location != NSNotFound) {
        [escaped replaceCharactersInRange:range withString:replace];
    }
    
    return escaped;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay{
    
}

- (void)dealloc {
    [_webToolbar release];
    [super dealloc];
}
@end
