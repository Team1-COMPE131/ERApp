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

@interface ExpenseViewController : UIViewController {
    ASIFormDataRequest *datReq;
    NSMutableArray *expenses;
}
-(void)getExpenseReports;
-(void)startExpenseReport;
@end
