//
//  ExpenseViewController.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ExpenseViewController.h"
#import "Expense.h"
#import "SBJson.h"

@interface ExpenseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate> {
    ASIFormDataRequest *datReq;
    NSMutableArray *expenses;
    IBOutlet UITableView *table;
    UIRefreshControl *refresher;
    NSUserDefaults *defaults;
    IBOutlet UILabel *accountLabel;
}
@end
