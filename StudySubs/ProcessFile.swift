//
//  ProcessFile.swift
//  StudySubs
//
//  Created by David Duffrin on 10/22/16.
//  Copyright © 2016 David Duffrin. All rights reserved.
//

import Foundation
import Cocoa
//import "TinySegmenter.h"



class processFile {
    var text:NSString;
    var file:String;
    var matches:[String];
    
    init(file:String) {
        text = "";
        self.file = file;
        
    }
    
    func startProcess() {
        
        let cont = readFile();
        if cont {
            //NSLog(self.text)
            processText();
            
            
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Complete"
            myPopup.informativeText = "Successfully created" + self.file + "!"
            myPopup.alertStyle = NSAlertStyle.warning
            myPopup.addButton(withTitle:self.file)
            myPopup.addButton(withTitle:"Cancel")
            myPopup.runModal()
        }
    }
    
    func tokenizeJapanese(word_set:Set<String>) {
        for line in matches{
            let options: NSLinguisticTagger.Options = .OmitWhitespace | .OmitPunctuation | .OmitOther
            let schemes = [NSLinguisticTagSchemeLexicalClass]
            let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
            let range = NSMakeRange(0, (line as NSString).length)
            tagger.string = line
            
            var tokens : [String] = []
            
            tagger.enumerateTags(
                in:range,
                scheme: NSLinguisticTagSchemeLexicalClass,
                options: options) {
                    (tag, tokenRange, _, _) in
                    
                    let token = (line as NSString).substring(with:tokenRange)
                    tokens.append(token)
                }
            word_set.unionInPlace((tokens as Set))
        }
    }
    
    func processText() {
        do {
            let regex = try NSRegularExpression(pattern: "[\u{3040}-\u{30ff}\u{3400}-\u{4dbf}\u{4e00}-\u{9faf}\u{ff62}-\u{ff9f}].*\n?")
            let results = regex.matches(in: (self.text as String), range: NSRange(location: 0, length: self.text.length))
            matches = results.map { self.text.substring(with: $0.range)}
        }
        catch {
            let regexError: NSAlert = NSAlert()
            regexError.messageText = "Error"
            regexError.informativeText = "There was a problem with the regex."
            regexError.alertStyle = NSAlertStyle.warning
            regexError.addButton(withTitle:"OK")
            regexError.runModal()
        }
        var word_set = Set<String>()
        
        
        
        
        
        //csvf = open(filename + '.csv','w+')
        //writer = csv.writer(csvf,delimiter='\t')
        //word_set = set()
        //foo = f.read()
        //try:
        //  f = open(file,'r',encoding='UTF8')
        //  ftext = f.read()
        //  m = re.findall("""[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf\uff62-\uff9f].*\n?""" , ftext)
        //except:
        //  f = open(file,'r',encoding='UTF16')
        //  ftext = f.read()
        //  m = re.findall("""[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf\uff62-\uff9f].*\n?""" , ftext)
        
        //for line in m:
        //  word_set = word_set | set(segmenter.tokenize(line))
        //with open('word_dictionary.json', 'r') as f1:
        //  try:
        //    word_dict = json.load(f1)
        //  except ValueError:
        //    word_dict = {}
        //word_set = word_set & set(word_dict.keys())
        //writer.writerow(['vocab','pronunciation','part of speech','meaning'])
        //for word in word_set:
        //  writer.writerow([word] + word_dict[word].split('\t'))
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func readFile() -> Bool {
        var fin:Bool?;
        do {
            self.text = try NSString(contentsOfFile: self.file, encoding: String.Encoding.utf8);
            fin = true;
        }
        catch {
            do {
                self.text = try NSString(contentsOfFile: self.file, encoding: String.Encoding.utf16);
                fin = true;
            }
            catch {
                let readError: NSAlert = NSAlert()
                readError.messageText = "Error"
                readError.informativeText = "There was a problem reading your file."
                readError.alertStyle = NSAlertStyle.warning
                readError.addButton(withTitle:"OK")
                readError.runModal()
                fin = false;
            }
        }
        return fin!;
    }
    
    func writeFile() {
        do {
            //let pathExtention = file.pathExtension
            let pathPrefix = (self.file as NSString).deletingPathExtension
            try text.write(toFile:pathPrefix + ".csv", atomically: false, encoding: String.Encoding.utf8);
        }
        catch {
            let writeError: NSAlert = NSAlert()
            writeError.messageText = "Error"
            writeError.informativeText = "There was a problem writing your file."
            writeError.alertStyle = NSAlertStyle.warning
            writeError.addButton(withTitle:"OK")
            writeError.runModal()
        }
    }
}
