//
//  ViewController.swift
//  Fees
//
//  Created by Francesco Zerbinati on 17/05/16.
//  Copyright © 2016 Francesco Zerbinati. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var input: UITextView!

    @IBOutlet weak var output: UITextView!

    var tag : String = "agsito-21"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate for the input textview
        input.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false

        // style both textviews
        setStyleTextView(input)
        setStyleTextView(output)
        
        // tap gesture recognizer to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
        view.addGestureRecognizer(tap)
        
        // call copy clipbord on load of the app
        copyClipboard()
        
        // copy even when coming from background
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(copyClipboard) , name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    
    func copyClipboard() {
        // retrieve pasteboard and output the result
        let pasteboardString:String? = UIPasteboard.generalPasteboard().string
        input.text = pasteboardString
        outputResult(generateLink(input.text))
    }
    

    
    func generateLink (text: String) -> String {
        
        // if string contains amazon.it (it is an amazon.it link)
        if text.rangeOfString("amazon.it") != nil{
            
            // find asin delimiters
            let dp: Range<String.Index> = text.rangeOfString("/dp/")!
            let ref: Range<String.Index> = text.rangeOfString("/ref")!
            
            // calculate start and end of asin
            let startIndex = dp.startIndex.advancedBy(4)
            let endIndex = ref.startIndex
            let asin = text.substringWithRange(startIndex ..< endIndex)
            
            // sponsored link generation
            let sponsored = "http://www.amazon.it/dp/"+asin+"/?tag="+tag
            return sponsored
        } else {
            return "";
        }
    }
    
    func outputResult (link: String) {
        // print text in the output textview
        output.text = link
    }

    func textViewDidEndEditing(textView: UITextView) {
        // when editing is finished, generate the link + output
        outputResult(generateLink(textView.text))
    }
    
    @IBAction func tagChange(sender:UISegmentedControl) {
        
        // the tag is changed, dismiss keyboard (if shown)
        dismissKeyboard()
        
        // change tag based on the selected segment
        switch sender.selectedSegmentIndex {
        case 0:
            tag = "agsito-21";
        case 1:
            tag = "agfacebook-21";
        default:
            break; 
        }
        
        // output the generated link
        outputResult(generateLink(input.text))
    }

    /**** helper functions **/
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setStyleTextView(input: UITextView) {
        input.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 5
    }


}

