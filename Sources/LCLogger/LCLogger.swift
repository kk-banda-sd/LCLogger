import Foundation

public protocol LCLoggerErrorProtocol {
    var errorDescription: String { get }
}

public final class LCLogger {
    
    public static let shared = LCLogger()
    
    private var outputStream = OutputStream()
    private var countOfInit = 0
    private var countOfDeinit = 0
    
    private init() {}
    
    public func construct(_ message: String = "", filePath: String = #file) {
        let m = String(format: "%.3d   INIT \(filePath.place.prefix)", getInitCount())
        let message = m + (message.isEmpty ? "" : " (" + message + ")")
        outputStream.write(message)
    }
    
    public func log(_ message: String, filePath: String = #file) {
        let message = "\(currentTime) ===" + filePath.place.smallPrefix + " " + message + " ==="
        outputStream.write(message)
    }
    
    public func log(_ error: LCLoggerErrorProtocol, filePath: String = #file) {
        log("‼️ Error: \(error.errorDescription)", filePath: filePath)
    }
    
    public func destruct(_ message: String = "", filePath: String = #file) {
        let m = String(format: "%.3d DEINIT \(filePath.place.prefix)", getDeinitCount())
        let message = m + (message.isEmpty ? "" : " (" + message + ")")
        outputStream.write(message)
    }
}

// MARK: - Private Methods
private extension LCLogger {
    func getInitCount() -> Int {
        countOfInit += 1
        return countOfInit
    }
    
    func getDeinitCount() -> Int {
        countOfDeinit += 1
        return countOfDeinit
    }
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

// MARK: - OutputStream
private struct OutputStream {
    func write(_ message: String) {
#if DEBUG
        print(message)
#endif
    }
}

// MARK: - Place
private struct Place {
    let value: String
    
    var prefix: String {
        let icon = Icon.allCases.first(where: { value.lowercased().contains($0.rawValue.lowercased()) } )?.icon ?? "==="
        var length = icon.count + value.count + 5
        if icon == "===" { length -= 1 }
        let spacesCount = max(50 - length, 1)
        let text = String(format: " %@ %@%@===", icon, value, String(repeating: " ", count: spacesCount))
        return text
    }
    
    var smallPrefix: String {
        let icon = Icon.allCases.first(where: { value.lowercased().contains($0.rawValue.lowercased()) } )?.icon ?? "==="
        let text = String(format: " %@ %@ ===", icon, value)
        return text
    }
    
    enum Icon: String, CaseIterable {
        case diContainer
        case viewController
        case overlayController
        case navigationController
        case rootView
        case viewModel
        case repository
        case userSession
        case session
        case configuration
        case customization
        case keychain
        case useCase
        case textField
        case factory
        case coder
        case manager
        case otherView = "view"
        case helper
        case button
        
        var icon: String {
            switch self {
                case .diContainer: return "🫙"
                case .viewController, .overlayController: return "🎥"
                case .rootView: return "📺"
                case .otherView: return "🏙️"
                case .viewModel: return "🧠"
                case .session: return "💼"
                case .configuration: return "🧾"
                case .customization: return "👕"
                case .keychain: return "🔐"
                case .repository: return "🗄"
                case .useCase: return "🎞"
                case .textField: return "✍️"
                case .userSession: return "🧔🏻‍♂️"
                case .factory: return "🏭"
                case .coder: return "👨‍💻"
                case .navigationController: return "🧭"
                case .manager: return "🤖"
                case .helper: return "🙏"
                case .button: return "⏺️"
            }
        }
    }
}

// MARK: - String Extensions
private extension String {
    var lastPathComponent: String {
        if #available(iOS 16.0, *) {
            URL(filePath: self).lastPathComponent
        } else {
            URL(fileURLWithPath: self).lastPathComponent
        }
    }
    
    var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }
    
    var fileName: String {
        let parts = deletingPathExtension.components(separatedBy: ".")
        guard !parts.isEmpty else { return self }
        var string = ""
        for (index, value) in parts.enumerated() {
            guard let first = value.first else { continue }
            if index == 0 {
                string.append(value)
            } else {
                string.append(first.uppercased() + value.dropFirst())
            }
        }
        return string
    }
    
    var place: Place { Place(value: lastPathComponent.fileName) }
}
