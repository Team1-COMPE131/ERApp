//
//  AddExpenseViewController.h
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "OptionSelectorViewController.h"

@interface AddExpenseViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,SelectDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    ASIFormDataRequest *datReq;
    IBOutlet UITableView *table;
}

@end
