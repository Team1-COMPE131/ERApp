//
//  ExpenseDetailViewController.m
//  ERApp
//
//  Created by Kevin Jung on 5/12/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "ExpenseDetailViewController.h"

@interface ExpenseDetailViewController () {
    UIImage *receipt;
}
-(void)dismiss:(id)sender;
-(void)edit:(id)sender;
@end

@implementation ExpenseDetailViewController

-(id)initWithExpense:(Expense *)ex {
    self = [self initWithNibName:@"ExpenseDetailViewController" bundle:nil];
    if (self) {
        expense = ex;
        receipt = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Expense Details"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
    [self.navigationItem setRightBarButtonItem:edit];
    if ((NSNull*)[expense receipt]!=[NSNull null]) {
        ASIHTTPRequest *req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[expense receipt]]];
        __unsafe_unretained ASIHTTPRequest *_imageReq = req;
        [req setCompletionBlock:^{
            if ([_imageReq responseStatusCode]==200) {
                receipt = [[UIImage alloc] initWithData:[_imageReq responseData]];
                [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                NSLog(@"Failure");
            }
        }];
        [req startAsynchronous];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

-(void)dismiss:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)edit:(id)sender {
    EditExpenseViewController *editView = [[EditExpenseViewController alloc] initWithExpense:expense withReceiptImage:receipt];
    [editView setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editView];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    else if (section==1) {
        return 4;
    }
    else if (section==2) {
        return 1;
    }
    else if (section==3) {
        return 1;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    for (UIImageView *im in cell.contentView.subviews) {
        if ([im tag]==900) {
            [im removeFromSuperview];
        }
    }
    
    for (UITextView *tx in cell.contentView.subviews) {
        if ([tx isKindOfClass:[UITextView class]]) {
            [tx removeFromSuperview];
        }
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"expense"];
            [cell.detailTextLabel setText:[expense vendor]];
        }
        else if (indexPath.row==1) {
            [cell.textLabel setText:@"amount"];
            NSLocale *locale = [NSLocale currentLocale];
            NSString *currency = [locale displayNameForKey:NSLocaleCurrencySymbol value:[expense currency]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%.2f %@", currency, [expense amount], [expense currency]]];
        }
    }
    else if(indexPath.section==1) {
        NSArray *split = [[expense time] componentsSeparatedByString:@" on "];
        if (indexPath.row==0) {
            [cell.textLabel setText:@"location"];
            [cell.detailTextLabel setText:[expense location]];
        }
        else if (indexPath.row==1) {
            [cell.textLabel setText:@"type"];
            [cell.detailTextLabel setText:[expense type]];
        }
        else if (indexPath.row==2) {
            [cell.textLabel setText:@"time"];
            [cell.detailTextLabel setText:[split objectAtIndex:0]];
        }
        else if (indexPath.row==3) {
            [cell.textLabel setText:@"date"];
            [cell.detailTextLabel setText:[split objectAtIndex:1]];
        }
    }
    else if(indexPath.section==2) {
        [cell.textLabel setText:@""];
        [cell.detailTextLabel setText:@""];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [imageView setTag:900];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        if (receipt!=nil) {
            [imageView setImage:receipt];
        }
        [cell.contentView addSubview:imageView];
    }
    else {
        [cell.textLabel setText:@""];
        [cell.detailTextLabel setText:@""];
        UITextView *note = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 300, 122)];
        [note setTextColor:[UIColor darkGrayColor]];
        [note setFont:[UIFont systemFontOfSize:16.0f]];
        [note setEditable:NO];
        if ((NSNull*)[expense note]!=[NSNull null]) {
            [note setText:[expense note]];
        }
        [cell.contentView addSubview:note];
    }
    
    return cell;
}

-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        return 320.0f;
    }
    else if(indexPath.section==3) {
        return 132.0f;
    }
    return 44.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==2) {
        return @"Expense Receipt";
    }
    else if (section==3) {
        return @"Notes";
    }
    return nil;
}

#pragma mark UpdateDelegate

-(void)expenseUpdatedWithExpense:(Expense *)ex andNewReceipt:(UIImage *)r {
    expense = ex;
    if (r!=nil) {
        receipt = r;
    }
    [table reloadData];
}

@end
