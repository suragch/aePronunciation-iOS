import UIKit

// View Controllers must adopt this protocol
protocol KeyboardDelegate: class {
    func keyWasTapped(_ character: String)
    func keyBackspace()
}

class IpaKeyboard: UIView, KeyboardKeyDelegate {
    
    private let numberKeysDouble = 43
    private let numberKeysSingle = 47

    var mode = SoundMode.single {
        didSet {
            if mode == SoundMode.single
                && subviews.count == numberKeysDouble {
                addSpecialKeysBackIn()
                self.setNeedsLayout()
            } else if mode == SoundMode.double
                && subviews.count == numberKeysSingle {
                removeSpecialKeys()
                self.setNeedsLayout()
            }
        }
    }
    
    weak var delegate: KeyboardDelegate? // probably the view controller
    
    // Keyboard Keys
    
    // Row 1
    private let key_i = KeyboardTextKey()
    private let key_i_short = KeyboardTextKey()
    private let key_e_short = KeyboardTextKey()
    private let key_ae = KeyboardTextKey()
    private let key_a = KeyboardTextKey()
    private let key_c_backwards = KeyboardTextKey()
    private let key_u_short = KeyboardTextKey()
    private let key_u = KeyboardTextKey()
    private let key_v_upsidedown = KeyboardTextKey()
    private let key_shwua = KeyboardTextKey()
    
    // Row 2
    private let key_ei = KeyboardTextKey()
    private let key_ai = KeyboardTextKey()
    private let key_au = KeyboardTextKey()
    private let key_oi = KeyboardTextKey()
    private let key_ou = KeyboardTextKey()
    
    // Row 3
    private let key_er_stressed = KeyboardTextKey()
    private let key_er_unstressed = KeyboardTextKey()
    private let key_ar = KeyboardTextKey()
    private let key_er = KeyboardTextKey()
    private let key_ir = KeyboardTextKey()
    private let key_or = KeyboardTextKey()
    
    // Row 4
    private let key_p = KeyboardTextKey()
    private let key_t = KeyboardTextKey()
    private let key_k = KeyboardTextKey()
    private let key_ch = KeyboardTextKey()
    private let key_f = KeyboardTextKey()
    private let key_th_voiceless = KeyboardTextKey()
    private let key_s = KeyboardTextKey()
    private let key_sh = KeyboardTextKey()
    
    // Row 5
    private let key_b = KeyboardTextKey()
    private let key_d = KeyboardTextKey()
    private let key_g = KeyboardTextKey()
    private let key_dzh = KeyboardTextKey()
    private let key_v = KeyboardTextKey()
    private let key_th_voiced = KeyboardTextKey()
    private let key_z = KeyboardTextKey()
    private let key_zh = KeyboardTextKey()
    
    // Row 6
    private let key_m = KeyboardTextKey()
    private let key_n = KeyboardTextKey()
    private let key_ng = KeyboardTextKey()
    private let key_l = KeyboardTextKey()
    private let key_w = KeyboardTextKey()
    private let key_j = KeyboardTextKey()
    private let key_h = KeyboardTextKey()
    private let key_r = KeyboardTextKey()
    private let key_glottal_stop = KeyboardTextKey()
    private let key_flap_t = KeyboardTextKey()
    
    // MARK:- keyboard initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubviews()
        setPrimaryKeyStrings()
        assignDelegates()
    }
    
    private func addSubviews() {
        
        // Row 1
        self.addSubview(key_i)
        self.addSubview(key_i_short)
        self.addSubview(key_e_short)
        self.addSubview(key_ae)
        self.addSubview(key_a)
        self.addSubview(key_c_backwards)
        self.addSubview(key_u_short)
        self.addSubview(key_u)
        self.addSubview(key_v_upsidedown)
        self.addSubview(key_shwua)
        
        // Row 2
        self.addSubview(key_ei)
        self.addSubview(key_ai)
        self.addSubview(key_au)
        self.addSubview(key_oi)
        self.addSubview(key_ou)
        
        // Row 3
        self.addSubview(key_er_stressed)
        self.addSubview(key_er_unstressed)
        self.addSubview(key_ar)
        self.addSubview(key_er)
        self.addSubview(key_ir)
        self.addSubview(key_or)
        
        // Row 4
        self.addSubview(key_p)
        self.addSubview(key_t)
        self.addSubview(key_k)
        self.addSubview(key_ch)
        self.addSubview(key_f)
        self.addSubview(key_th_voiceless)
        self.addSubview(key_s)
        self.addSubview(key_sh)
        
        // Row 5
        self.addSubview(key_b)
        self.addSubview(key_d)
        self.addSubview(key_g)
        self.addSubview(key_dzh)
        self.addSubview(key_v)
        self.addSubview(key_th_voiced)
        self.addSubview(key_z)
        self.addSubview(key_zh)
        
        // Row 6
        self.addSubview(key_m)
        self.addSubview(key_n)
        self.addSubview(key_ng)
        self.addSubview(key_l)
        self.addSubview(key_w)
        self.addSubview(key_j)
        self.addSubview(key_h)
        self.addSubview(key_r)
        self.addSubview(key_glottal_stop)
        self.addSubview(key_flap_t)
    }
    
    private func setPrimaryKeyStrings() {
        
        // Row 1
        key_i.primaryString = Ipa.i
        key_i_short.primaryString = Ipa.i_short
        key_e_short.primaryString = Ipa.e_short
        key_ae.primaryString = Ipa.ae
        key_a.primaryString = Ipa.a
        key_c_backwards.primaryString = Ipa.c_backwards
        key_u_short.primaryString = Ipa.u_short
        key_u.primaryString = Ipa.u
        key_v_upsidedown.primaryString = Ipa.v_upsidedown
        key_shwua.primaryString = Ipa.schwa
        
        // Row 2
        key_ei.primaryString = Ipa.ei
        key_ai.primaryString = Ipa.ai
        key_au.primaryString = Ipa.au
        key_oi.primaryString = Ipa.oi
        key_ou.primaryString = Ipa.ou
        
        // Row 3
        key_er_stressed.primaryString = Ipa.er_stressed
        key_er_unstressed.primaryString = Ipa.er_unstressed
        key_ar.primaryString = Ipa.ar
        key_er.primaryString = Ipa.er
        key_ir.primaryString = Ipa.ir
        key_or.primaryString = Ipa.or
        
        // Row 4
        key_p.primaryString = Ipa.p
        key_t.primaryString = Ipa.t
        key_k.primaryString = Ipa.k
        key_ch.primaryString = Ipa.ch
        key_f.primaryString = Ipa.f
        key_th_voiceless.primaryString = Ipa.th_voiceless
        key_s.primaryString = Ipa.s
        key_sh.primaryString = Ipa.sh
        
        // Row 5
        key_b.primaryString = Ipa.b
        key_d.primaryString = Ipa.d
        key_g.primaryString = Ipa.g
        key_dzh.primaryString = Ipa.dzh
        key_v.primaryString = Ipa.v
        key_th_voiced.primaryString = Ipa.th_voiced
        key_z.primaryString = Ipa.z
        key_zh.primaryString = Ipa.zh
        
        // Row 6
        key_m.primaryString = Ipa.m
        key_n.primaryString = Ipa.n
        key_ng.primaryString = Ipa.ng
        key_l.primaryString = Ipa.l
        key_w.primaryString = Ipa.w
        key_j.primaryString = Ipa.j
        key_h.primaryString = Ipa.h
        key_r.primaryString = Ipa.r
        key_glottal_stop.primaryString = Ipa.glottal_stop
        key_flap_t.primaryString = Ipa.flap_t
    }
    
    private func assignDelegates() {
        
        // Row 1
        key_i.delegate = self
        key_i_short.delegate = self
        key_e_short.delegate = self
        key_ae.delegate = self
        key_a.delegate = self
        key_c_backwards.delegate = self
        key_u_short.delegate = self
        key_u.delegate = self
        key_v_upsidedown.delegate = self
        key_shwua.delegate = self
        
        // Row 2
        key_ei.delegate = self
        key_ai.delegate = self
        key_au.delegate = self
        key_oi.delegate = self
        key_ou.delegate = self
        
        // Row 3
        key_er_stressed.delegate = self
        key_er_unstressed.delegate = self
        key_ar.delegate = self
        key_er.delegate = self
        key_ir.delegate = self
        key_or.delegate = self
        
        // Row 4
        key_p.delegate = self
        key_t.delegate = self
        key_k.delegate = self
        key_ch.delegate = self
        key_f.delegate = self
        key_th_voiceless.delegate = self
        key_s.delegate = self
        key_sh.delegate = self
        
        // Row 5
        key_b.delegate = self
        key_d.delegate = self
        key_g.delegate = self
        key_dzh.delegate = self
        key_v.delegate = self
        key_th_voiced.delegate = self
        key_z.delegate = self
        key_zh.delegate = self
        
        // Row 6
        key_m.delegate = self
        key_n.delegate = self
        key_ng.delegate = self
        key_l.delegate = self
        key_w.delegate = self
        key_j.delegate = self
        key_h.delegate = self
        key_r.delegate = self
        key_glottal_stop.delegate = self
        key_flap_t.delegate = self
    }
    
    override func layoutSubviews() {
        
        // | i | i | e | ae| a | c | u | u | v | e |    Row 1
        // |   ei  |   ai  |   au  |   oi  |   ou  |    Row 2
        // |  er  |  er  |  ar  |  er  |  ir  | or |    Row 3
        // |  p | t  | k | ch |  f | th |  s |  sh |    Row 4
        // |  b | d  | g | dzh|  v | th |  z |  zh |    Row 5
        // | m | n | ng| l | w | j | h | r | ? | r |    Row 6
        
        let numberOfKeysPerRow = getNumberOfKeysPerRow()
        // each row should sum to 1
        let keyWeights = getKeyWeights()
        let numberOfRows = numberOfKeysPerRow.count
        let totalWidth = self.bounds.width
        let totalHeight = self.bounds.height
        var x: CGFloat = 0
        var y: CGFloat = 0
        var keyIndex = 0
        for rowIndex in 0..<numberOfRows {
            let start = keyIndex
            let end = keyIndex + numberOfKeysPerRow[rowIndex]
            for _ in start..<end {
                let key = subviews[keyIndex]
                let keyWidth = totalWidth * keyWeights[keyIndex]
                let keyHeight = totalHeight / CGFloat(numberOfRows)
                key.frame = CGRect(x: x, y: y, width: keyWidth, height: keyHeight)
                x += keyWidth
                keyIndex += 1
            }
            
            x = 0
            y += totalHeight / CGFloat(numberOfRows)
            
        }
    }
    
    private func getNumberOfKeysPerRow() -> [Int] {
        if mode == SoundMode.single {
            return [10, 5, 6, 8, 8, 10] // 47 total
        } else { // double
            return [9, 5, 5, 8, 8, 8] // 43 total
        }
    }

    private func getKeyWeights() -> [CGFloat] {
        // each row should sum to 1

        let eighth: CGFloat = 1/8

        if mode == SoundMode.single {
            let sixth: CGFloat = 1/6
            return [
                0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
                0.2, 0.2, 0.2, 0.2, 0.2,
                sixth, sixth, sixth, sixth, sixth, sixth,
                eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth,
                eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth,
                0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
        } else {
            // excluding special sounds for double keyboard
            let ninth: CGFloat = 1/9
            return [
                ninth, ninth, ninth, ninth, ninth, ninth, ninth, ninth, ninth,
                0.2, 0.2, 0.2, 0.2, 0.2,
                0.2, 0.2, 0.2, 0.2, 0.2,
                eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth,
                eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth,
                eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth]
        }
    }
    
    
    private func addSpecialKeysBackIn() {
        self.insertSubview(key_shwua, aboveSubview: key_v_upsidedown)
        self.insertSubview(key_er_unstressed, aboveSubview: key_er_stressed)
        self.addSubview(key_glottal_stop)
        self.addSubview(key_flap_t)
    }
    
    private func removeSpecialKeys() {
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if Ipa.isSpecial(ipa: key.primaryString) {
                key.removeFromSuperview()
            }
        }
    }
    
    // MARK: - KeyboardKeyDelegate protocol
    
    
    func keyTextEntered(sender: KeyboardKey, keyText: String) {
        // pass the input up to the Keyboard delegate
        self.delegate?.keyWasTapped(keyText)
    }
    
    func keyBackspaceTapped() {
        self.delegate?.keyBackspace()
        //print("key text: backspace")
    }
    
    // MARK: - Public update methods
    
    func updateKeyAppearanceFor(selectedSounds: [String]?) {
        guard let selected = selectedSounds else {return}
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            var isEnabled = false
            innerLoop: for sound in selected {
                if sound == key.primaryString {
                    isEnabled = true
                    break innerLoop
                }
            }
            key.isEnabled = isEnabled
        }
    }
    
    func getEnabledKeys() -> [String] {
        var enabledKeys = [String]()
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if key.isEnabled {
                enabledKeys.append(key.primaryString)
            }
        }
        return enabledKeys
    }
}

