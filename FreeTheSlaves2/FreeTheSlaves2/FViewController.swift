//
//  FViewController.swift
//  FreeTheSlaves2
//
//  Created by Janson Lau on 10/28/16.
//  Copyright © 2016 Janson LauJanson Lau. All rights reserved.
//

import UIKit

class FViewController: UIViewController {
    var question = 0;
    var answerReportF = [Int]()
    var lastIndex = 0;

    var languageChosen = 0;
    let languageCodes = ["en", "fr","ht","hi","en","ne","en","en","ur"]
    var commentReport = [String](repeating: "", count:45)

    let questionsF = ["There is an anti-slavery community group that meets regularly", "The community group has good leadership", "Slavery survivors participate effectively in the group", "Poorer households participate effectively in the group", "Discriminated groups participate effectively in the group", "Women participate effectively in the group", "The community group has strong internal cohesion", "The community group is well accepted within the community (while recognizing that those connected with slaveholders and trafficking may not accept the group)", "The group can resolve internal disagreements and maintain unity and trust"]
    @IBOutlet weak var questionF: UILabel!
    @IBOutlet weak var commentsField: UITextField!
    @IBOutlet weak var segControlF: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if(languageCodes[languageChosen] != "en") {
            let formattedString = questionsF[question].addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            loadData(input: formattedString!, which: 0); //int 0
            let segControl0 = segControlF.titleForSegment(at: 0)
            let segControl1 = segControlF.titleForSegment(at: 1)
            let segControl2 = segControlF.titleForSegment(at: 2)
            let segControl0formatted = segControl0!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let segControl1formatted = segControl1!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let segControl2formatted = segControl2!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            loadData(input: segControl0formatted!, which: 1) //1
            loadData(input: segControl1formatted!, which: 2)//2
            loadData(input: segControl2formatted!, which: 3)//3

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func enterPressedF(_ sender: Any) {
        if(question < questionsF.count-1) {
            answerReportF[lastIndex+question] = segControlF.selectedSegmentIndex

            question += 1
            questionF.text = questionsF[question]
            commentsField.text = "";
            if(languageCodes[languageChosen] != "en") {
                let formattedString = questionsF[question].addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                loadData(input: formattedString!, which: 0); //int 0
            }


        }
        else {
            performSegue(withIdentifier: "FtoG", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FtoG"  {
            let gviewc = segue.destination as! GViewController
            gviewc.answerReportG = answerReportF
            gviewc.lastIndex = question;
            gviewc.languageChosen = self.languageChosen
            gviewc.commentReport = self.commentReport

        }
        else {
            let gviewc = segue.destination as! EViewController
            gviewc.answerReportE = answerReportF
            gviewc.lastIndex = question;
            gviewc.languageChosen = self.languageChosen
            gviewc.commentReport = self.commentReport
            
        }
    }
    func loadData(input:String, which:Int, completion: @escaping () -> Void = {}) {
        
        
        let chosenLanguageCode = languageCodes[languageChosen]
        let apiKey = "AIzaSyBlyYsRQ6kLmPXfVsXSxJ2QpIVM4ANgvOQ"
        let url = NSURL(string: "https://www.googleapis.com/language/translate/v2?key=\(apiKey)&q=\(input)&source=en&target=\(chosenLanguageCode)");
        print("hipls")
        print("input")
        print(input)
        
        print(url!)
        let request = NSURLRequest(url: url! as URL,
                                   cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData,
                                   timeoutInterval: 10
        );
        
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        );
        
        
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(responseDictionary)
                    
                    let data1 = responseDictionary["data"] as! NSDictionary
                    let translations = data1["translations"] as! NSArray
                    let translationsDict = translations[0] as! NSDictionary
                    let translateString = translationsDict["translatedText"] as! String
                    print(translateString)
                    if(which == 0) {
                        self.questionF.text = translateString
                    }
                    else if(which == 1) {
                        self.segControlF.setTitle(translateString, forSegmentAt: 0)
                        
                    }
                    else if(which == 2) {
                        self.segControlF.setTitle(translateString, forSegmentAt: 1)
                        
                    }
                    else if(which == 3) {
                        self.segControlF.setTitle(translateString, forSegmentAt: 2)
                        
                    }
                    completion();
                }
            }
            else {
                if(error != nil){
                }
            }
        });
        
        task.resume();
    }


}
