//
//  LoginViewController.m
//  ERApp
//
//  Created by Kevin Jung on 3/13/14.
//  Copyright (c) 2014 Kevin Jung. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    UITextField *username;
    UITextField *password;
    BOOL loggingIn;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"ERApp Login"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *signup = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleBordered target:self action:@selector(signup)];
    [self.navigationItem setLeftBarButtonItem:signup];
    username = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [username setDelegate:self];
    [username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [username setAutocorrectionType:UITextAutocorrectionTypeNo];
    [username setKeyboardType:UIKeyboardTypeDefault];
    [username setTextColor:[UIColor darkGrayColor]];
    [username setReturnKeyType:UIReturnKeyNext];
    [username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [username setPlaceholder:@"Email"];
    [username setKeyboardType:UIKeyboardTypeEmailAddress];
    password = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 305, 44)];
    [password setDelegate:self];
    [password setSecureTextEntry:YES];
    [password setTextColor:[UIColor darkGrayColor]];
    [password setReturnKeyType:UIReturnKeyDone];
    [password setPlaceholder:@"Password"];
    loggingIn = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Methods

-(void)login {
    
}

-(void)signup {
    SignupViewController *sView = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    UINavigationController *snView = [[UINavigationController alloc] initWithRootViewController:sView];
    [self.navigationController presentViewController:snView animated:YES completion:nil];
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row==0) {
            [cell.contentView addSubview:username];
        }
        else {
            [cell.contentView addSubview:password];
        }
    }
    else {
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        if (loggingIn) {
            [[[tableView cellForRowAtIndexPath:indexPath] textLabel] setTextColor:[UIColor grayColor]];
            [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else {
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            [cell.textLabel setText:@"Sign In"];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1 && !loggingIn) {
        [username resignFirstResponder];
        [password resignFirstResponder];
        if (username.text.length==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials" message:@"You've provided an invalid username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if (password.text.length==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials" message:@"You've provided an invalid password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        loggingIn = YES;
        [username setEnabled:NO];
        [password setEnabled:NO];
        [[[tableView cellForRowAtIndexPath:indexPath] textLabel] setTextColor:[UIColor grayColor]];
        [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSURL *url = [[NSURL alloc] initWithString:@"http://server2.kevjung.com:3000/login"];
        datReq = [[ASIFormDataRequest alloc] initWithURL:url];
        [datReq setDelegate:self];
        [datReq setPostValue:username.text forKey:@"Username"];
        [datReq setPostValue:password.text forKey:@"Password"];
        [datReq startAsynchronous];
    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==username) {
        [password becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark ASIHTTPRequest

-(void)requestFinished:(ASIHTTPRequest *)request {
    loggingIn = NO;
    [username setEnabled:YES];
    [password setEnabled:YES];
    [[[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textLabel] setTextColor:[UIColor blackColor]];
    [[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setSelectionStyle:UITableViewCellSelectionStyleDefault];
    NSLog(@"%@", request.responseString);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *resp = [parser objectWithString:request.responseString];
    if ([resp objectForKey:@"Error"]!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Log In" message:[resp objectForKey:@"Error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
    }
    datReq = nil;
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    loggingIn = NO;
    [username setEnabled:YES];
    [password setEnabled:YES];
    [[[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textLabel] setTextColor:[UIColor blackColor]];
    [[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Log In" message:@"Please make sure you are connected to a network." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    datReq = nil;
}

@end
