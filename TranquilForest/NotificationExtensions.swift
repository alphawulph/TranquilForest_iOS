import Foundation

extension Notification.Name {
    static let cmdStartPlaying = Notification.Name("cmdStartPlaying")
    static let cmdPausePlaying = Notification.Name("onCmdPausePlaying")
    static let cmdStopPlaying = Notification.Name("cmdStopPlaying")
    static let cmdSetVolume = Notification.Name("cmdSetVolume")
    static let cmdMute = Notification.Name("cmdMute")
}
