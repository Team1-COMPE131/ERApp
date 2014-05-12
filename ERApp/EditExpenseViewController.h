//
//  EditExpenseViewController.h
//  ERApp
//
//  Created by Kevin Jung on 5/12/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Expense.h"
#import "OptionSelectorViewController.h"
#import "UIImage+Scale.h"
#import "UpdateDelegate.h"

@interface EditExpenseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,UITextViewDelegate,SelectDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    IBOutlet UITableView *table;
    ASIFormDataRequest *datReq;
    Expense *expense;
    __weak id<UpdateDelegate>delegate;
}

-(id)initWithExpense:(Expense*)ex withReceiptImage:(UIImage*)r;
@property (nonatomic,weak) id<UpdateDelegate>delegate;
@end
