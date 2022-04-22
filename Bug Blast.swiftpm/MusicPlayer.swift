import AVFoundation

class MusicPlayer {
    var player = AVAudioPlayer()
    let audioName: String
    var volume: Float
    var fileType: String
    var playInfinite: Bool
    
    init(audioName: String, volume: Float, fileType: String, playInfinite: Bool) {
        self.audioName = audioName
        self.volume = volume
        self.fileType = fileType
        self.playInfinite = playInfinite
        let sound = Bundle.main.url(forResource: audioName, withExtension: fileType)!
        try! player = AVAudioPlayer(contentsOf: sound)
        if playInfinite {
        player.numberOfLoops = -1
        }
        player.volume = volume
    }
    
    func play() {
        player.play()
    }
    
}
