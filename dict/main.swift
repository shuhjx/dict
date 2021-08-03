//
//  main.swift
//  dict
//
//  Created by 舒怀 on 2021/8/3.
//  Copyright © 2021 shuh. All rights reserved.
//

import Foundation

func translate(_ words: [String], callback: (String) -> Swift.Void) {
    if words.isEmpty { return }
    
    let userDefaults = UserDefaults.standard
    guard var dictionaryPreferences = userDefaults.persistentDomain(forName: "com.apple.DictionaryServices") else { return }
    guard let activeDictionaries = dictionaryPreferences["DCSActiveDictionaries"] as? [String] else { return }
    //改成英汉词典
    //词典下载： http://download.huzheng.org/zh_CN/ 懒虫简明英汉词典
    //下载DictUnifier.app转成Dictionary.app可用的词典文件
    dictionaryPreferences["DCSActiveDictionaries"] = [
        "/Users/shuhuai/Library/Containers/com.apple.Dictionary/Data/Library/Dictionaries/lazyworm-ec.dictionary"
    ]
    //设置词典
    userDefaults.setPersistentDomain(dictionaryPreferences, forName: "com.apple.DictionaryServices")
   
    //翻译单词
    words.forEach { (word) in
        if let result = DCSCopyTextDefinition(nil, word as CFString, CFRangeMake(0, word.count))?.takeRetainedValue() as String? {
           callback(result)
        }
    }
    
    //恢复之前的词典设置
    dictionaryPreferences["DCSActiveDictionaries"] = activeDictionaries
    //["/Users/shuhuai/Library/Containers/com.apple.Dictionary/Data/Library/Dictionaries/lazyworm-ec.dictionary", "/Users/shuhuai/Library/Containers/com.apple.Dictionary/Data/Library/Dictionaries/lazyworm-ce.dictionary", "com.apple.dictionary.zh_CN-en.OCD"]
    userDefaults.setPersistentDomain(dictionaryPreferences, forName: "com.apple.DictionaryServices")
}

func wordsFromCMD() -> [String] {
    let predicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]+$")
    var words: [String] = []
    var i = 1
    while i < CommandLine.argc {
        let word = CommandLine.arguments[i]
        if predicate.evaluate(with: word) {
            words.append(word)
        }
        i += 1
    }
    return words
}


if (CommandLine.argc < 2) {
    print("用法: dict word")
}else{
    let words = wordsFromCMD()
    
    translate(words) { (result) in
        print(result)
    }
}








