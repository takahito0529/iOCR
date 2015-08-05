//
//  ViewController.h
//  iOCR
//
//  Created by 犬飼 貴仁 on 2015/08/05.
//  Copyright (c) 2015年 T.Inukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

