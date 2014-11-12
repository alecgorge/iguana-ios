//
//  PhishNetSignInViewController.m
//  PhishOD
//
//  Created by Alec Gorge on 7/31/14.
//  Copyright (c) 2014 Alec Gorge. All rights reserved.
//

#import "IGSignUpViewController.h"

@interface IGSignUpViewController () <UITextFieldDelegate>

@property (nonatomic) UITextField *uiUsername;
@property (nonatomic) UITextField *uiPassword;

@end

@implementation IGSignUpViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sign up for Relisten.net";
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"cell"];
    
    UIBarButtonItem *dismiss = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                           target:self
                                                                           action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = dismiss;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor yellowColor];
    self.tableView.backgroundColor = IG_COLOR_TABLE_BG;
    self.tableView.separatorColor = IG_COLOR_TABLE_SEP;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)dismiss {
    [self.delegate dismissTappedInSignUpViewController:self];
}

- (void)signIn {
    [self.delegate signUpViewController:self
               tappedSignUpWithUsername:self.uiUsername.text
                            andPassword:self.uiPassword.text];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.uiUsername) {
        [self.uiPassword becomeFirstResponder];
    }
    else if(textField == self.uiPassword) {
        [self.uiPassword resignFirstResponder];
        [self signIn];
    }
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Username";
            
            self.uiUsername = [UITextField.alloc initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width / 1.75, 30.f)];
            
            self.uiUsername.placeholder = @"me@example.com";
            self.uiUsername.keyboardType = UIKeyboardTypeDefault;
            self.uiUsername.tintColor = [UIColor whiteColor];
            self.uiUsername.textColor = [UIColor whiteColor];
            self.uiUsername.autocorrectionType = UITextAutocorrectionTypeNo;
            self.uiUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.uiUsername.returnKeyType = UIReturnKeyNext;
            self.uiUsername.delegate = self;
            [self.uiUsername setValue:[UIColor colorWithRed:0.525 green:0.546 blue:0.598 alpha:0.590]
                           forKeyPath:@"_placeholderLabel.textColor"];
            
            cell.accessoryView = self.uiUsername;
        }
        else if(indexPath.row == 1) {
            cell.textLabel.text = @"Password";
            
            self.uiPassword = [UITextField.alloc initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width / 1.75, 30.f)];
            
            self.uiPassword.placeholder = @"••••••••••";
            self.uiPassword.keyboardType = UIKeyboardTypeEmailAddress;
            self.uiPassword.tintColor = [UIColor whiteColor];
            self.uiPassword.textColor = [UIColor whiteColor];
            self.uiPassword.autocorrectionType = UITextAutocorrectionTypeNo;
            self.uiPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.uiPassword.secureTextEntry = YES;
            self.uiPassword.returnKeyType = UIReturnKeyDone;
            self.uiPassword.delegate = self;
            [self.uiPassword setValue:[UIColor colorWithRed:0.525 green:0.546 blue:0.598 alpha:0.590]
                           forKeyPath:@"_placeholderLabel.textColor"];
            
            cell.accessoryView = self.uiPassword;
        }
    }
    else {
        cell.textLabel.text = @"Sign Up";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = IG_COLOR_TABLE_BUTTON_BG;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if(self.uiUsername.text.length > 0 && self.uiPassword.text.length > 0) {
            [self signIn];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return @"Your Relisten.net account will allow you to create and share playlists, favorite tracks, shows and venues.";
    }
    
    return nil;
}

@end
