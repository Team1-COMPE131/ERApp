//
//  ExpenseDetailViewController.h
//  ERApp
//
//  Created by Kevin Jung on 5/12/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"
#import "ASIHTTPRequest.h"
#import "EditExpenseViewController.h"

@interface ExpenseDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UpdateDelegate> {
    IBOutlet UITableView *table;
    Expense *expense;
}

-(id)initWithExpense:(Expense*)ex;

@end
