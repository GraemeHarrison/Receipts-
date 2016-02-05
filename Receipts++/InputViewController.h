//
//  InputViewController.h
//  Receipts++
//
//  Created by Graeme Harrison on 2016-02-04.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
