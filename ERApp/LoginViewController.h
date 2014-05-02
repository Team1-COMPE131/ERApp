//
//  LoginViewController.h
//  ERApp
//
//  Created by Kevin Jung on 3/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SignupViewController.h"
#import "ExpenseViewController.h"

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate> {
    IBOutlet UITableView *table;
    ASIFormDataRequest *datReq;
}

-(void)login;
-(void)signup;

@end
