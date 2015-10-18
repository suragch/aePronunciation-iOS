//
//  SingleSound.swift
//  aePronunciation
//
//  Created by MongolSuragch on 10/2/15.
//  Copyright © 2015 Suragch. All rights reserved.
//

import Foundation

class SingleSound {
    
    private let soundName = [
        "p": "single_p",
        "t": "single_t",
        "k": "single_k",
        "ʧ": "single_ch",
        "f": "single_f",
        "θ": "single_th_voiceless",
        "s": "single_s",
        "ʃ": "single_sh",
        "b": "single_b",
        "d": "single_d",
        "g": "single_g",
        "ʤ": "single_dzh",
        "v": "single_v",
        "ð": "single_th_voiced",
        "z": "single_z",
        "ʒ": "single_zh",
        "m": "single_m",
        "n": "single_n",
        "ŋ": "single_ng",
        "l": "single_l",
        "w": "single_w",
        "j": "single_j",
        "h": "single_h",
        "r": "single_r",
        "i": "single_i_long",
        "ɪ": "single_i_short",
        "ɛ": "single_e_short",
        "æ": "single_ae",
        "ɑ": "single_a",
        "ɔ": "single_c_backwards",
        "ʊ": "single_u_short",
        "u": "single_u",
        "ʌ": "single_v_upsidedown",
        "ə": "single_schwa",
        "e": "single_e",
        "aɪ": "single_ai",
        "aʊ": "single_au",
        "ɔɪ": "single_oi",
        "o": "single_o",
        "ɝ": "single_er_stressed",
        "ɚ": "single_er_unstressed",
        "ɑr": "single_ar",
        "ɛr": "single_er",
        "ɪr": "single_ir",
        "ɔr": "single_or",
        "ʔ": "single_glottal_stop",
        "ɾ": "single_flap_t"
    ]
    
    // test/practice pool excludes "ə", "ɚ", "ʔ", "ɾ"
    //private let ipaTestPool = [ "p", "t", "k", "ʧ", "f", "θ", "s", "ʃ", "b", "d", "g", "ʤ", "v", "ð", "z", "ʒ", "m", "n", "ŋ", "l", "w", "j", "h", "r", "i", "ɪ", "ɛ", "æ", "ɑ", "ɔ", "ʊ", "u", "ʌ", "e", "aɪ", "aʊ", "ɔɪ", "o", "ɝ", "ɑr", "ɛr", "ɪr", "ɔr" ]
    private let ipaTestPoolVowels = [ "i", "ɪ", "ɛ", "æ", "ɑ", "ɔ", "ʊ", "u", "ʌ", "e", "aɪ", "aʊ", "ɔɪ", "o", "ɝ", "ɑr", "ɛr", "ɪr", "ɔr" ]
    private let ipaTestPoolConsonants = [ "p", "t", "k", "ʧ", "f", "θ", "s", "ʃ", "b", "d", "g", "ʤ", "v", "ð", "z", "ʒ", "m", "n", "ŋ", "l", "w", "j", "h", "r" ]
    
    private let exampleOneFile = [
        "p": "pass",
        "t": "toad",
        "k": "cool",
        "ʧ": "chairs",
        "f": "father",
        "θ": "think",
        "s": "set",
        "ʃ": "shoot",
        "b": "bill",
        "d": "delicious",
        "g": "good",
        "ʤ": "jump",
        "v": "very",
        "ð": "there",
        "z": "zoo",
        "ʒ": "usually",
        "m": "me",
        "n": "word_new",
        "ŋ": "ringing",
        "l": "loud",
        "w": "wary",
        "j": "year",
        "h": "her",
        "r": "real",
        "i": "each",
        "ɪ": "it",
        "ɛ": "edge",
        "æ": "ash",
        "ɑ": "on",
        "ɔ": "ought",
        "ʊ": "put",
        "u": "ooze",
        "ʌ": "up",
        "ə": "above",
        "e": "age",
        "aɪ": "im",
        "aʊ": "out",
        "ɔɪ": "oil",
        "o": "oath",
        "ɝ": "earth",
        "ɚ": "mother",
        "ɑr": "arm",
        "ɛr": "aired",
        "ɪr": "ear",
        "ɔr": "oars",
        "ʔ": "put_glottal",
        "ɾ": "water"
    ]
    
    private let exampleTwoFile = [
        "p": "speak",
        "t": "sting",
        "k": "skill",
        "ʧ": "eachof",
        "f": "gift",
        "θ": "jonathan",
        "s": "raced",
        "ʃ": "wished",
        "b": "above",
        "d": "cards",
        "g": "again",
        "ʤ": "agile",
        "v": "every",
        "ð": "father",
        "z": "raised",
        "ʒ": "pleasure",
        "m": "jump",
        "n": "panda",
        "ŋ": "think",
        "l": "cool",
        "w": "twelve",
        "j": "cube",
        "h": "have",
        "r": "rib",
        "i": "read",
        "ɪ": "him",
        "ɛ": "set",
        "æ": "bad",
        "ɑ": "father",
        "ɔ": "call",
        "ʊ": "good",
        "u": "shoot",
        "ʌ": "sun",
        "ə": "delicious",
        "e": "safe",
        "aɪ": "bite",
        "aʊ": "loud",
        "ɔɪ": "voice",
        "o": "cove",
        "ɝ": "birthday",
        "ɚ": "perform",
        "ɑr": "part",
        "ɛr": "chairs",
        "ɪr": "weird",
        "ɔr": "north",
        "ʔ": "button",
        "ɾ": "little"
    ]
    
    private let exampleThreeFile = [
        "p": "stop",
        "t": "it",
        "k": "week",
        "ʧ": "church",
        "f": "word_if",
        "θ": "earth",
        "s": "pass",
        "ʃ": "ash",
        "b": "rib",
        "d": "card",
        "g": "pig",
        "ʤ": "edge",
        "v": "have",
        "ð": "bathe",
        "z": "cars",
        "ʒ": "beige",
        "m": "arm",
        "n": "sun",
        "ŋ": "sung",
        "l": "bill",
        "w": "what",
        "j": "yellow",
        "h": "ahead",
        "r": "roar",
        "i": "me",
        "ɪ": "rib",
        "ɛ": "said",
        "æ": "bat",
        "ɑ": "ma",
        "ɔ": "saw",
        "ʊ": "should",
        "u": "blue",
        "ʌ": "uhhuh",
        "ə": "panda",
        "e": "may",
        "aɪ": "fly",
        "aʊ": "cow",
        "ɔɪ": "boy",
        "o": "low",
        "ɝ": "her",
        "ɚ": "wonderful",
        "ɑr": "car",
        "ɛr": "there",
        "ɪr": "here",
        "ɔr": "roar",
        "ʔ": "uhoh",
        "ɾ": "thirty"
    ]
    
    let allIpaTestPool: [ String ]
    
    // MARK: - init
    
    init() {
        allIpaTestPool = ipaTestPoolVowels + ipaTestPoolConsonants
    }
    
    // MARK: - Methods
    
    func fileNameForIpa(ipa: String) -> String? {
        
        return soundName[ipa]
    }
    
    func exampleOneFileNameFromIpa(ipa: String) -> String? {
        
        return exampleOneFile[ipa]
    }
    
    func exampleTwoFileNameFromIpa(ipa: String) -> String? {
        
        return exampleTwoFile[ipa]
    }
    
    func exampleThreeFileNameFromIpa(ipa: String) -> String? {
        
        return exampleThreeFile[ipa]
    }
    
    func getRandomIpa() -> String {
        
        // get random sound index number
        let index = arc4random_uniform(UInt32(allIpaTestPool.count))
        
        // translate integer to ipa string
        return allIpaTestPool[Int(index)]
    }
    
    func getRandomVowelIpa() -> String {
        
        // get random sound index number
        let index = arc4random_uniform(UInt32(ipaTestPoolVowels.count))
        
        // translate integer to ipa string
        return ipaTestPoolVowels[Int(index)]
    }
    
    func getRandomConsonantIpa() -> String {
        
        // get random sound index number
        let index = arc4random_uniform(UInt32(ipaTestPoolConsonants.count))
        
        // translate integer to ipa string
        return ipaTestPoolConsonants[Int(index)]
    }
    
}