//
//  ExpenseViewController.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "ExpenseViewController.h"
#import "AddExpenseViewController.h"

@interface ExpenseViewController ()
-(void)refresh:(id)sender;
-(void)addExpenseReport;
-(IBAction)logout:(id)sender;
-(void)edit:(id)sender;
-(void)cancelEdit:(id)sender;
@end

@implementation ExpenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"isCorp"] boolValue]) {
            [self.navigationItem setTitle:@"Company Expenses"];
        }
        else {
            [self.navigationItem setTitle:@"Your Expenses"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    refresher = [[UIRefreshControl alloc] init];
    [refresher addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refresher];
    expenses = [[NSMutableArray alloc] init];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
    [self.navigationItem setLeftBarButtonItem:edit];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addExpenseReport)];
    [self.navigationItem setRightBarButtonItem:add];
    [accountLabel setText:[NSString stringWithFormat:@"Account: %@", [defaults objectForKey:@"username"]]];
}

-(void)viewWillAppear:(BOOL)animated {
    datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/expenses"]];
    [datReq setDelegate:self];
    [datReq setTimeOutSeconds:0];
    [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
    [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
    [datReq startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [expenses count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ExpenseRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(225, 0, 65, 56)];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
        [lab setTextColor:[UIColor colorWithRed:0 green:160/255.0f blue:25/255.0f alpha:1.0f]];
        [lab setMinimumScaleFactor:10/lab.font.pointSize];
        [lab setNumberOfLines:1];
        [lab setAdjustsFontSizeToFitWidth:YES];
        [lab setTag:200];
        [cell.contentView addSubview:lab];
    }
    UILabel *amount;
    for (UILabel *label in cell.contentView.subviews) {
        if ([label isKindOfClass:[UILabel class]] && [label tag]==200) {
            amount = label;
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Expense *e = [expenses objectAtIndex:indexPath.row];
    [cell.textLabel setText:[e vendor]];
    [cell.detailTextLabel setText:[e time]];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *currency = [locale displayNameForKey:NSLocaleCurrencySymbol value:[e currency]];
    [amount setText:[NSString stringWithFormat:@"%@%.2f", currency, [e amount]]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *amount;
    for (UILabel *label in cell.contentView.subviews) {
        if ([label isKindOfClass:[UILabel class]] && [label tag]==200) {
            amount = label;
        }
    }
    [amount setFrame:CGRectMake(225, 0, 65, 56)];
    
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ASIFormDataRequest *datReqs = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/deleteExpense"]];
    [datReqs setPostValue:[[expenses objectAtIndex:indexPath.row] expenseID] forKey:@"expenseId"];
    [datReqs setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
    [datReqs setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
    __unsafe_unretained ASIFormDataRequest *tpReq = datReqs;
    [datReqs setCompletionBlock:^{
        if([tpReq responseStatusCode]==200) {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *resp = [parser objectWithString:tpReq.responseString];
            if ([[resp objectForKey:@"Message"] isEqualToString:@"Success"]) {
                [expenses removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                if ([expenses count]==0) {
                    [self cancelEdit:nil];
                }
            }
            else if([resp objectForKey:@"Error"]!=nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Delete" message:[resp objectForKey:@"Error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self cancelEdit:nil];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"Please make sure you are connected to a network." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    [datReqs startAsynchronous];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Expense *expense = [expenses objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [imageView setImage:[expense receipt]];
    [imageView setBackgroundColor:[UIColor blackColor]];
}

#pragma mark AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==100 && buttonIndex==1) {
        [defaults removeObjectForKey:@"isLoggedIn"];
        [defaults synchronize];
        [self.navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Private Methods

-(void)refresh:(id)sender {
    if ([table isEditing]) {
        [self cancelEdit:nil];
    }
    datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/expenses"]];
    [datReq setDelegate:self];
    [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
    [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
    [datReq startAsynchronous];
}

-(void)addExpenseReport {
    AddExpenseViewController *addView = [[AddExpenseViewController alloc] initWithNibName:@"AddExpenseViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addView];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

-(IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:100];
    [alert show];
}

-(void)edit:(id)sender {
    [table setEditing:YES animated:YES];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelEdit:)];
    [self.navigationItem setLeftBarButtonItem:cancel animated:YES];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

-(void)cancelEdit:(id)sender {
    [table setEditing:NO animated:YES];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
    [self.navigationItem setLeftBarButtonItem:edit animated:YES];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addExpenseReport)];
    [self.navigationItem setRightBarButtonItem:add animated:YES];
}

#pragma mark ASIHTTPRequest

-(void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"%@", request.responseString);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *resp = [parser objectWithString:request.responseString];
    if (resp==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Load" message:@"An error occurred while reading expense data." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [expenses removeAllObjects];
        for (NSDictionary *exp in resp) {
            Expense *expense = [[Expense alloc] initWithID:[exp objectForKey:@"expenseId"] vendor:[exp objectForKey:@"vendor"] location:[exp objectForKey:@"location"] type:[exp objectForKey:@"type"] amount:[[exp objectForKey:@"amount"] doubleValue] currency:[exp objectForKey:@"currency"] time:[exp objectForKey:@"time"] receipt:nil note:[exp objectForKey:@"note"]];
            [expenses addObject:expense];
        }
        [table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    datReq = nil;
    if (refresher.refreshing) {
        [refresher endRefreshing];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect" message:@"Please make sure you are connected to a network." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    datReq = nil;
    if (refresher.refreshing) {
        [refresher endRefreshing];
    }
}

@end
