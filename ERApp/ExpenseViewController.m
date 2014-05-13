//
//  ExpenseViewController.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "ExpenseViewController.h"
#import "AddExpenseViewController.h"
#import "ExpenseDetailViewController.h"

@interface ExpenseViewController ()
-(void)refresh:(id)sender;
-(void)addExpenseReport;
-(IBAction)logout:(id)sender;
-(void)edit:(id)sender;
-(void)cancelEdit:(id)sender;
-(NSString*)shortendDay:(NSString*)longString;
-(IBAction)reports:(id)sender;
-(IBAction)filterSelector:(id)sender;
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
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Reports" style:UIBarButtonItemStylePlain target:self action:@selector(reports:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)]]];
    downAlert = [[UIAlertView alloc] initWithTitle:@"Downloading Report..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    if (filterSeg.selectedSegmentIndex==0) {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/expenses"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq startAsynchronous];
    }
    else {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/showExpense"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq setPostValue:[NSNumber numberWithLong:filterSeg.selectedSegmentIndex-1] forKey:@"filter"];
        [datReq startAsynchronous];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:YES];
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
    
    for (UIView *v in cell.contentView.subviews) {
        if ([v isKindOfClass:[UIView class]] && [v tag]==300) {
            [v removeFromSuperview];
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Expense *e = [expenses objectAtIndex:indexPath.row];
    [cell.textLabel setText:[e vendor]];
    [cell.detailTextLabel setText:[e time]];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *currency = [locale displayNameForKey:NSLocaleCurrencySymbol value:[e currency]];
    [amount setText:[NSString stringWithFormat:@"%@%.2f", currency, [e amount]]];
    
    if ([e amount]>1000.0f && [[e currency] isEqualToString:@"USD"]) {
        [amount setTextColor:[UIColor colorWithRed:255/255.0f green:136/255.0f blue:0.0f alpha:1.0f]];
        UIView *flag = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 1.5, 46)];
        [flag setTag:300];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = flag.bounds;
        if ((NSNull*)e.receipt==[NSNull null]) {
            gradient.colors = @[(id)[[UIColor colorWithRed:255/255.0f green:247/255.0f blue:0.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:255/255.0f green:106/255.0f blue:0.0f alpha:1.0f] CGColor]];
        }
        else {
            gradient.colors = @[(id)[[UIColor colorWithRed:255/255.0f green:136/255.0f blue:0.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:255/255.0f green:106/255.0f blue:0.0f alpha:1.0f] CGColor]];
        }
        [flag.layer insertSublayer:gradient atIndex:0];
        [cell.contentView addSubview:flag];
    }
    else if ((NSNull*)e.receipt==[NSNull null]) {
        [amount setTextColor:[UIColor colorWithRed:0 green:160/255.0f blue:25/255.0f alpha:1.0f]];
        UIView *flag = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 1.5, 46)];
        [flag setTag:300];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = flag.bounds;
        if ([e amount]>1000.0f && [[e currency] isEqualToString:@"USD"]) {
            [amount setTextColor:[UIColor colorWithRed:255/255.0f green:136/255.0f blue:0.0f alpha:1.0f]];
            gradient.colors = @[(id)[[UIColor colorWithRed:255/255.0f green:247/255.0f blue:0.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:255/255.0f green:106/255.0f blue:0.0f alpha:1.0f] CGColor]];
        }
        else {
            gradient.colors = @[(id)[[UIColor colorWithRed:255/255.0f green:247/255.0f blue:0.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:222/255.0f green:215/255.0f blue:27.0/255.0f alpha:1.0f] CGColor]];
        }
        [flag.layer insertSublayer:gradient atIndex:0];
        [cell.contentView addSubview:flag];
    }
    else {
        [amount setTextColor:[UIColor colorWithRed:0 green:160/255.0f blue:25/255.0f alpha:1.0f]];
    }
    
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
    if (tableView.isEditing) {
        [amount setFrame:CGRectMake(225, 0, 55, 56)];
    }
    else [amount setFrame:CGRectMake(225, 0, 65, 56)];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExpenseDetailViewController *detailView = [[ExpenseDetailViewController alloc] initWithExpense:[expenses objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailView animated:YES];
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
    if (filterSeg.selectedSegmentIndex==0) {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/expenses"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq startAsynchronous];
    }
    else {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/showExpense"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq setPostValue:[NSNumber numberWithLong:filterSeg.selectedSegmentIndex-1] forKey:@"filter"];
        [datReq startAsynchronous];
    }
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

-(NSString*)shortendDay:(NSString*)longString {
    NSArray *longDay = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    NSArray *shortDay = @[@"Mon",@"Tues",@"Wed",@"Thurs",@"Fri",@"Sat",@"Sun"];
    for (int i=0; i<[longDay count]; i++) {
        longString = [longString stringByReplacingOccurrencesOfString:[longDay objectAtIndex:i] withString:[shortDay objectAtIndex:i]];
        
    }
    return longString;
}

-(IBAction)reports:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Download Expense Reports" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"All", @"This Year", @"This Month", @"This Week", nil];
    [action showFromToolbar:self.navigationController.toolbar];
}

-(IBAction)filterSelector:(id)sender {
    long sel = [(UISegmentedControl*)sender selectedSegmentIndex];
    if (datReq!=nil) {
        [datReq cancel];
        datReq = nil;
    }
    if (sel==0) {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/expenses"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq startAsynchronous];
    }
    else {
        datReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/showExpense"]];
        [datReq setDelegate:self];
        [datReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [datReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        [datReq setPostValue:[NSNumber numberWithLong:(sel-1)] forKey:@"filter"];
        [datReq startAsynchronous];
    }
}

#pragma mark ASIHTTPRequest

-(void)requestFinished:(ASIHTTPRequest *)request {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *resp = [parser objectWithString:request.responseString];
    if (resp==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Load" message:@"An error occurred while reading expense data." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [expenses removeAllObjects];
        for (NSDictionary *exp in resp) {
            Expense *expense = [[Expense alloc] initWithID:[exp objectForKey:@"expenseId"] vendor:[exp objectForKey:@"vendor"] location:[exp objectForKey:@"location"] type:[exp objectForKey:@"type"] amount:[[exp objectForKey:@"amount"] doubleValue] currency:[exp objectForKey:@"currency"] time:[self shortendDay:[exp objectForKey:@"time"]] receipt:[exp objectForKey:@"receipt"] note:[exp objectForKey:@"note"]];
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

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex!=4) {
        [downAlert show];
        ASIFormDataRequest *csvReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://server2.kevjung.com:3000/getcsv"]];
        [csvReq setPostValue:[defaults objectForKey:@"id"] forKey:@"id"];
        [csvReq setPostValue:[defaults objectForKey:@"isCorp"] forKey:@"isCorp"];
        if (buttonIndex==0) {
            [csvReq setPostValue:[NSNumber numberWithInt:3] forKey:@"filter"];
        }
        else if (buttonIndex==1) {
            [csvReq setPostValue:[NSNumber numberWithInt:0] forKey:@"filter"];
        }
        else if (buttonIndex==2) {
            [csvReq setPostValue:[NSNumber numberWithInt:1] forKey:@"filter"];
        }
        else if (buttonIndex==3) {
            [csvReq setPostValue:[NSNumber numberWithInt:2] forKey:@"filter"];
        }
        [csvReq setDownloadDestinationPath:[RESOURCES_DIR stringByAppendingPathComponent:@"report.csv"]];
        __unsafe_unretained ASIFormDataRequest *_csvReq = csvReq;
        [csvReq setCompletionBlock:^{
            [downAlert dismissWithClickedButtonIndex:0 animated:YES];
            if ([_csvReq responseStatusCode]==200) {
                NSArray *activityItems = @[[NSURL fileURLWithPath:[RESOURCES_DIR stringByAppendingPathComponent:@"report.csv"]]];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact];
                [self.navigationController presentViewController:activityVC animated:TRUE completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Download Report" message:@"An error occurred while downloading Expense Report. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        [csvReq startAsynchronous];
    }
}

@end
