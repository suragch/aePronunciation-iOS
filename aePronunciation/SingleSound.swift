import Foundation

class SingleSound {
    
    private var singleSounds: [String]?
    
    // MARK: - Methods
    
    func getSoundCount() -> Int {
        guard let sounds = singleSounds else {return 0}
        return sounds.count
    }
    
    func getRandomIpa() -> String {
        
        if singleSounds == nil {
            includeAllSounds()
        }
        
        // get random integer (0 <= x < numberOfSounds)
        let index = Int(arc4random_uniform(UInt32(singleSounds!.count)))
        
        // translate integer to ipa string
        return singleSounds![index]
    }
    
    private func includeAllSounds() {
        singleSounds = Array(SingleSound.soundMap.keys)
    }
    
    func restrictListTo(consonants: [String], vowels: [String]) {
        if consonants.isEmpty && vowels.isEmpty {return}
        
        singleSounds = consonants + vowels
        
    }
    
    class func getSoundFileName(ipa: String) -> String? {
        return SingleSound.soundMap[ipa]
    }
    
    class func getExampleOneFileName(ipa: String) -> String? {
        return SingleSound.exampleOneMap[ipa]
    }
    
    class func getExampleTwoFileName(ipa: String) -> String? {
        return SingleSound.exampleTwoMap[ipa]
    }
    
    class func getExampleThreeFileName(ipa: String) -> String? {
        return SingleSound.exampleThreeMap[ipa]
    }
    
    private static let soundMap = [
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
        "i": "single_i",
        "ɪ": "single_i_short",
        "ɛ": "single_e",
        "æ": "single_ae",
        "ɑ": "single_a",
        "ɔ": "single_c_backwards",
        "ʊ": "single_u_short",
        "u": "single_u",
        "ʌ": "single_v_upsidedown",
        "ə": "single_shwua",
        "eɪ": "single_ei",
        "aɪ": "single_ai",
        "aʊ": "single_au",
        "ɔɪ": "single_oi",
        "oʊ": "single_ou",
        "ɝ": "single_er_stressed",
        "ɚ": "single_er_unstressed",
        "ɑr": "single_ar",
        "ɛr": "single_er",
        "ɪr": "single_ir",
        "ɔr": "single_or",
        "ʔ": "single_glottal_stop",
        "ɾ": "single_flap_t"
    ]
    
    private static let exampleOneMap = [
        "p": "word_pass",
        "t": "word_toad",
        "k": "word_cool",
        "ʧ": "word_chairs",
        "f": "word_father",
        "θ": "word_think",
        "s": "word_set",
        "ʃ": "word_shoot",
        "b": "word_bill",
        "d": "word_delicious",
        "g": "word_good",
        "ʤ": "word_jump",
        "v": "word_very",
        "ð": "word_there",
        "z": "word_zoo",
        "ʒ": "word_usually",
        "m": "word_me",
        "n": "word_new",
        "ŋ": "word_ringing",
        "l": "word_loud",
        "w": "word_wary",
        "j": "word_year",
        "h": "word_her",
        "r": "word_real",
        "i": "word_each",
        "ɪ": "word_it",
        "ɛ": "word_edge",
        "æ": "word_ash",
        "ɑ": "word_on",
        "ɔ": "word_ought",
        "ʊ": "word_put",
        "u": "word_ooze",
        "ʌ": "word_up",
        "ə": "word_above",
        "eɪ": "word_age",
        "aɪ": "word_im",
        "aʊ": "word_out",
        "ɔɪ": "word_oil",
        "oʊ": "word_oath",
        "ɝ": "word_earth",
        "ɚ": "word_mother",
        "ɑr": "word_arm",
        "ɛr": "word_aired",
        "ɪr": "word_ear",
        "ɔr": "word_oars",
        "ʔ": "word_put_glottal",
        "ɾ": "word_water"
    ]
    
    private static let exampleTwoMap = [
        "p": "word_speak",
        "t": "word_sting",
        "k": "word_skill",
        "ʧ": "word_eachof",
        "f": "word_gift",
        "θ": "word_jonathan",
        "s": "word_raced",
        "ʃ": "word_wished",
        "b": "word_above",
        "d": "word_cards",
        "g": "word_again",
        "ʤ": "word_agile",
        "v": "word_every",
        "ð": "word_father",
        "z": "word_raised",
        "ʒ": "word_pleasure",
        "m": "word_jump",
        "n": "word_panda",
        "ŋ": "word_think",
        "l": "word_cool",
        "w": "word_twelve",
        "j": "word_cube",
        "h": "word_have",
        "r": "word_rib",
        "i": "word_read",
        "ɪ": "word_him",
        "ɛ": "word_set",
        "æ": "word_bad",
        "ɑ": "word_father",
        "ɔ": "word_call",
        "ʊ": "word_good",
        "u": "word_shoot",
        "ʌ": "word_sun",
        "ə": "word_delicious",
        "eɪ": "word_safe",
        "aɪ": "word_bite",
        "aʊ": "word_loud",
        "ɔɪ": "word_voice",
        "oʊ": "word_cove",
        "ɝ": "word_birthday",
        "ɚ": "word_perform",
        "ɑr": "word_part",
        "ɛr": "word_chairs",
        "ɪr": "word_weird",
        "ɔr": "word_north",
        "ʔ": "word_button",
        "ɾ": "word_little"
    ]
    
    private static let exampleThreeMap = [
        "p": "word_stop",
        "t": "word_it",
        "k": "word_week",
        "ʧ": "word_church",
        "f": "word_if",
        "θ": "word_earth",
        "s": "word_pass",
        "ʃ": "word_ash",
        "b": "word_rib",
        "d": "word_card",
        "g": "word_pig",
        "ʤ": "word_edge",
        "v": "word_have",
        "ð": "word_bathe",
        "z": "word_cars",
        "ʒ": "word_beige",
        "m": "word_arm",
        "n": "word_sun",
        "ŋ": "word_sung",
        "l": "word_bill",
        "w": "word_what",
        "j": "word_yellow",
        "h": "word_ahead",
        "r": "word_roar",
        "i": "word_me",
        "ɪ": "word_rib",
        "ɛ": "word_said",
        "æ": "word_bat",
        "ɑ": "word_ma",
        "ɔ": "word_saw",
        "ʊ": "word_should",
        "u": "word_blue",
        "ʌ": "word_uhhuh",
        "ə": "word_panda",
        "eɪ": "word_may",
        "aɪ": "word_fly",
        "aʊ": "word_cow",
        "ɔɪ": "word_boy",
        "oʊ": "word_low",
        "ɝ": "word_her",
        "ɚ": "word_wonderful",
        "ɑr": "word_car",
        "ɛr": "word_there",
        "ɪr": "word_here",
        "ɔr": "word_roar",
        "ʔ": "word_uhoh",
        "ɾ": "word_thirty"
    ]
}
