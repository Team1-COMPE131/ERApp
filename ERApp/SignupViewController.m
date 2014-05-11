//
//  SignupViewController.m
//  ERApp
//
//  Created by Kevin Jung on 4/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
-(void)resignKeyboard;
-(void)dismiss;
-(BOOL)verifyInfo;
-(void)signup;
@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"ERApp Sign Up"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [self.navigationItem setLeftBarButtonItem:dismiss];
    dismissFlag = NO;
    accountType = 0;
    fname = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [fname setAutocorrectionType:UITextAutocorrectionTypeNo];
    [fname setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [fname setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [fname setReturnKeyType:UIReturnKeyNext];
    [fname setTextColor:[UIColor darkGrayColor]];
    [fname setClearButtonMode:UITextFieldViewModeWhileEditing];
    [fname setPlaceholder:@"First Name"];
    [fname setDelegate:self];
    lname = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [lname setAutocorrectionType:UITextAutocorrectionTypeNo];
    [lname setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [lname setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [lname setReturnKeyType:UIReturnKeyNext];
    [lname setTextColor:[UIColor darkGrayColor]];
    [lname setClearButtonMode:UITextFieldViewModeWhileEditing];
    [lname setPlaceholder:@"Last Name"];
    [lname setDelegate:self];
    email = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setReturnKeyType:UIReturnKeyNext];
    [email setTextColor:[UIColor darkGrayColor]];
    [email setClearButtonMode:UITextFieldViewModeWhileEditing];
    [email setPlaceholder:@"Email"];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setDelegate:self];
    pass = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [pass setSecureTextEntry:YES];
    [pass setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [pass setTextColor:[UIColor darkGrayColor]];
    [pass setReturnKeyType:UIReturnKeyNext];
    [pass setPlaceholder:@"Password"];
    [pass setDelegate:self];
    passconf = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [passconf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passconf setSecureTextEntry:YES];
    [passconf setTextColor:[UIColor darkGrayColor]];
    [passconf setReturnKeyType:UIReturnKeyDone];
    [passconf setPlaceholder:@"Confirm Password"];
    [passconf setDelegate:self];
    company = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [company setAutocorrectionType:UITextAutocorrectionTypeNo];
    [company setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [company setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [company setReturnKeyType:UIReturnKeyDone];
    [company setPlaceholder:@"Company Name"];
    [company setDelegate:self];
    kbDismiss = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (dismissFlag) {
        [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
        if (accountType==0) {
            if ([table numberOfRowsInSection:2]==2) {
                [table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else {
            if ([table numberOfRowsInSection:2]==1) {
                [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (dismissFlag) {
        dismissFlag = NO;
    }
    else {
        [fname becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) {
        return 2;
    }
    else if(section==1) {
        return 3;
    }
    else if(section==2)  {
        if (accountType==0) {
            return 1;
        }
        else return 2;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    for (UITextField *tx in cell.contentView.subviews) {
        if ([tx isKindOfClass:[UITextField class]]) {
            [tx removeFromSuperview];
        }
    }
    [cell.textLabel setText:@""];
    if (indexPath.section==0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentNatural];
        if (indexPath.row==0) {
            [cell.contentView addSubview:fname];
        }
        else if (indexPath.row==1) {
            [cell.contentView addSubview:lname];
        }
    }
    else if(indexPath.section==1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentNatural];
        if (indexPath.row==0) {
            [cell.contentView addSubview:email];
        }
        else if (indexPath.row==1) {
            [cell.contentView addSubview:pass];
        }
        else if (indexPath.row==2) {
            [cell.contentView addSubview:passconf];
        }
    }
    else if(indexPath.section==2) {
        [cell.textLabel setTextAlignment:NSTextAlignmentNatural];
        if (indexPath.row==0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            if (accountType==0) {
                [cell.textLabel setText:@"Individual Account"];
            }
            else {
                [cell.textLabel setText:@"Corporate Account"];
            }
        }
        else if(indexPath.row==1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.contentView addSubview:company];
        }
    }
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:@"Sign Up"];
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return @"PERSONAL INFORMATION";
    }
    else if (section==1) {
        return @"ACCOUNT INFORMATION";
    }
    else if (section==2) {
        return @"ACCOUNT TYPE";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2 && indexPath.row==0) {
        dismissFlag = YES;
        AccountTypeViewController *typeView = [[AccountTypeViewController alloc] initWithType:accountType];
        [typeView setTitle:@"Select Account Type"];
        [typeView setDelegate:self];
        [self resignKeyboard];
        [self.navigationController pushViewController:typeView animated:YES];
    }
    else if(indexPath.section==3 && indexPath.row==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self signup];
    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==passconf) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (SCREEN_IS_4_INCH) {
            [table setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else {
            [table setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [UIView commitAnimations];
        [passconf resignFirstResponder];
        return YES;
    }
    else if (textField==company) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (SCREEN_IS_4_INCH) {
            [table setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else {
            [table setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [UIView commitAnimations];
        [company resignFirstResponder];
        return YES;
    }
    
    BOOL scrollRequired = NO;
    NSArray *visible = [table visibleCells];
    NSIndexPath *indexPath;
    if (textField==fname) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        scrollRequired = ![visible containsObject:[table cellForRowAtIndexPath:indexPath]];
    }
    else if(textField==lname) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        scrollRequired = ![visible containsObject:[table cellForRowAtIndexPath:indexPath]];
    }
    else if(textField==email) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        scrollRequired = ![visible containsObject:[table cellForRowAtIndexPath:indexPath]];
    }
    else if(textField==pass) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        scrollRequired = ![visible containsObject:[table cellForRowAtIndexPath:indexPath]];
    }
    /*
    else if(textField==pass) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        scrollRequired = ![visible containsObject:[table cellForRowAtIndexPath:indexPath]];
    }*/
    
    if (scrollRequired) {
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if(textField==fname)[lname becomeFirstResponder];
            else if(textField==lname)[email becomeFirstResponder];
            else if(textField==email)[pass becomeFirstResponder];
            else if(textField==pass)[passconf becomeFirstResponder];
            //else if(textField==pass)[passVerify becomeFirstResponder];
        });
    }
    else {
        if(textField==fname)[lname becomeFirstResponder];
        else if(textField==lname)[email becomeFirstResponder];
        else if(textField==email)[pass becomeFirstResponder];
        else if(textField==pass)[passconf becomeFirstResponder];
        /*else if(textField==pass)[passVerify becomeFirstResponder];
        else {
            kbDismiss = YES;
            [textField resignFirstResponder];
            [self signup];
        }*/
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (SCREEN_IS_4_INCH) {
        [table setFrame:CGRectMake(0, 0, 320, 568-UIKEYBOARD_SIZE)];
    }
    else {
        [table setFrame:CGRectMake(0, 0, 320, 480-UIKEYBOARD_SIZE)];
    }
    [UIView commitAnimations];
    NSIndexPath *indexPath;
    if(textField==fname)indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    else if(textField==lname)indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    else if(textField==email)indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    else if(textField==pass)indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    else if(textField==passconf)indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    else if(textField==company)indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (kbDismiss) {
        kbDismiss = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.3];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (SCREEN_IS_4_INCH) {
            [table setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else {
            [table setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [UIView commitAnimations];
    }
}

#pragma mark Private Method

-(void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)verifyInfo {
    BOOL stop = NO;
    NSString *alert;
    if (fname.text.length==0 && !stop) {
        stop = YES;
        alert = @"Please provide your First Name.";
    }
    if (lname.text.length==0 && !stop) {
        stop = YES;
        alert = @"Please provide your Last Name.";
    }
    if (email.text.length==0 && !stop) {
        stop = YES;
        alert = @"Please provide a valid Email.";
    }
    if (pass.text.length<5 && !stop) {
        stop = YES;
        alert = @"Your password must be at least 5 characters long.";
    }
    if ([passconf.text isEqualToString:pass.text] && !stop) {
        stop = YES;
        alert = @"Your password does not match your confirmation password.";
    }
    if (accountType==1&&company.text.length==0&&!stop) {
        stop = YES;
        alert = @"Please provide a Company Name.";
    }
    if (stop) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Cannot Sign Up" message:alert delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [a show];
        return NO;
    }
    return YES;
}

-(void)signup {
    if([self verifyInfo]) {
        
    }
}

#pragma mark Private Method

-(void)resignKeyboard {
    kbDismiss = YES;
    if ([fname isEditing]) {
        [fname resignFirstResponder];
    }
    else if ([lname isEditing]) {
        [lname resignFirstResponder];
    }
    else if ([email isEditing]) {
        [email resignFirstResponder];
    }
    else if ([pass isEditing]) {
        [pass resignFirstResponder];
    }
    else if ([passconf isEditing]) {
        [passconf resignFirstResponder];
    }
    else if ([company isEditing]) {
        [company resignFirstResponder];
    }
}

#pragma mark AccountTypeDelegate

-(void)accountTypeSelected:(NSInteger)type {
    accountType = type;
    UITableViewCell *cell = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]];
    if (accountType==0) {
        [cell.textLabel setText:@"Individual Account"];
    }
    else {
        [cell.textLabel setText:@"Corporate Account"];
    }
}

@end
