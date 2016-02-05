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
#import "AppDelegate.h"
@import CoreData;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *receiptsArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchReceipt];
    [self.tableView reloadData];

}

-(void)fetchReceipt {
    NSError *error;
    
    // Fetch object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    self.receiptsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (self.receiptsArray == nil) {
        // Handle the error.
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showInput"]) {
        InputViewController *controller =  (InputViewController *) [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receiptsArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiptCell" forIndexPath:indexPath];
    Receipt *receipt = self.receiptsArray[indexPath.row];
    cell.noteLabel.text = receipt.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"%@", receipt.amount];
    return cell;
}


@end
