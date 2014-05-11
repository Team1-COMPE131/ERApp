//
//  SignupViewController.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AccountTypeViewController.h"
#import "SBJson.h"

@interface SignupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate, UITextFieldDelegate,AccountTypeDelegate> {
    BOOL dismissFlag;
    NSInteger accountType;
    IBOutlet UITableView *table;
    ASIFormDataRequest *datReq;
    UITextField *fname;
    UITextField *lname;
    UITextField *email;
    UITextField *pass;
    UITextField *passconf;
    UITextField *company;
    BOOL kbDismiss;
}

@end
