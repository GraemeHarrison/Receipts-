//
//  InputViewController.m
//  Receipts++
//
//  Created by Graeme Harrison on 2016-02-04.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "InputViewController.h"
#import "AppDelegate.h"
#import "Receipt.h"
#import "Tag.h"

@interface InputViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSMutableSet *selectedTagsSet;

@end

@implementation InputViewController

- (void)setDetailItem:(id)newDetailItem {
    if (_managedObjectContext != newDetailItem) {
        _managedObjectContext = newDetailItem;
        
        [self configureView];
    }
}

- (void)configureView {
    if (self.managedObjectContext) {
    }
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.date = [NSDate date];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Change functionality of return key based on who is the first responder
    if (textField == self.amountTextField) {
        [self.noteTextField becomeFirstResponder];
    } else if (textField == self.noteTextField) {
        [self.noteTextField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Dismiss the keyboard whenever we touch outside the textfields by telling our textfields to give up first responder status
    [self.noteTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.datePicker resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTagsSet = [[NSMutableSet alloc]init];

    [self fetchTags];
    if (self.tagsArray.count == 0) {
        [self createTags];
    }
}

-(void)fetchTags {
    NSError *error;
    
    // Fetch object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    self.tagsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (self.tagsArray == nil) {
        // Handle the error.
    }
}

-(void)createTags {
    NSError *error;
    
    // Create new object
    Tag *tag1 = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Tag"
                           inManagedObjectContext:self.managedObjectContext];
    tag1.tagName = @"Personal";
    
    Tag *tag2 = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag2.tagName = @"Family";
    
    Tag *tag3 = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag3.tagName = @"Business";
    
    // Save object
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    [self fetchTags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doneButton:(UIButton *)sender {
    
    [self createReceipt];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createReceipt {
    NSError *error;
    
    // Create new object
    Receipt *newReceipt = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Receipt"
                           inManagedObjectContext:self.managedObjectContext];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *receiptNumber = [numFormatter numberFromString:self.amountTextField.text];
    
    
    newReceipt.amount = receiptNumber;
    newReceipt.note = self.noteTextField.text;
    newReceipt.timeStamp = self.datePicker.date;
    newReceipt.tags = self.selectedTagsSet;
    
    // Save object
    if (![self.managedObjectContext save:&error]) {
        // Handle the error.
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.tagsArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    Tag *tag = self.tagsArray[indexPath.row];
    cell.textLabel.text = tag.tagName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    Tag *selectedTag = self.tagsArray[indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.selectedTagsSet addObject:selectedTag];
    } else {
        [self.selectedTagsSet removeObject:selectedTag];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
