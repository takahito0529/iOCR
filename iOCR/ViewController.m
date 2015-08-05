//
//  ViewController.m
//  iOCR
//
//  Created by 犬飼 貴仁 on 2015/08/05.
//  Copyright (c) 2015年 T.Inukai. All rights reserved.
//

#import "ViewController.h"
#import "TesseractOCR.h"

@interface ViewController ()
@property (nonatomic, strong) UIImage *selectedImage; // イメージ
@property (nonatomic, strong) UIView *loadingView; // ローディング用ビュー
@property (nonatomic, strong) UIActivityIndicatorView *indicator; // ローディングインジケータ
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedCamera:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // デリゲート指定
    [imagePickerController setDelegate:self];
    // トリミング指定
    [imagePickerController setAllowsEditing:YES];
    // カメラの使用有無を確認
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        // カメラを指定
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        // アルバムを指定
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    // コントローラ起動
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// コントローラ終了
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // イメージをメモリに保存
    self.selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    // イメージビューに画像をセット
    [self.imageView setImage:self.selectedImage];
    // 親ビューへ戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // テキストを空に
    [self.textView setText:nil];
    
    // インジケータ開始
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // OCR実行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 英語 : eng を設定 (日本語の場合は jpn を指定)
        G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        
        // OCRを実行する画像を設定
        [tesseract setImage:self.selectedImage];
        
        // OCR実行
        [tesseract recognize];
        
        // 実行結果をアラートビューで表示
        dispatch_async(dispatch_get_main_queue(), ^{
            // 結果をテキストビューに指定
            [self.textView setText:[tesseract recognizedText]];
            // インジケータ停止
            [spinner stopAnimating];
        });
    });
}

@end
