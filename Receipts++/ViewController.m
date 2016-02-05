//
//  ViewController.m
//  Receipts++
//
//  Created by Graeme Harrison on 2016-02-04.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"
#import "ReceiptTableViewCell.h"
#import "Receipt.h"
#import "Tag.h"
#import "AppDelegate.h"
@import CoreData;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *receiptsArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
   
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchTags];
    if (self.tagsArray.count == 0) {
        [self createTags];
    }
    
    [self createData];
    [self.tableView reloadData];
    
//    [self fetchReceipt];
}

-(void)createData {
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    for (Tag *tag in self.tagsArray) {
        [results addObject:[tag.receipts allObjects]];
    }
    
    self.receiptsArray = [results copy];
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

//-(void)fetchReceipt {
//    NSError *error;
//    
//    // Fetch object
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt"
//                                              inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    self.receiptsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    
//    if (self.receiptsArray == nil) {
//        // Handle the error.
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showInput"]) {
        InputViewController *controller =  (InputViewController *) [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.tagsArray = self.tagsArray;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receiptsArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell" forIndexPath:indexPath];
    Receipt *receipt = self.receiptsArray[indexPath.section][indexPath.row];
    cell.noteLabel.text = receipt.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"$%@", receipt.amount];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.receiptsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *tag = self.tagsArray[section];
    NSString *header = tag.tagName;
    return header;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
