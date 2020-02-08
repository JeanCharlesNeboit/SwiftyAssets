import Foundation
import Basic
import SPMUtility

func main() {
    let args = Array(CommandLine.arguments.dropFirst())

    do {
        if args.count == 1, let first = args.first {
            var option: Option? = Option(rawValue: first)
            if option == nil {
                option = Option(shortName: first)
            }
            
            if let _option = option, _option.withAction {
                _option.action()
            }
        }
        
        let parser = ArgumentParser(commandName: Spec.projectName, usage: "", overview: Spec.overview)
        if let swiftyParser = try SwiftyParser(argumentParser: parser, args: args) {
            guard let commandPositional = swiftyParser.positionals[Positional.command],
                let commandArg = swiftyParser.result.get(commandPositional) else {
                return
            }
            
            guard let command = Command(rawValue: commandArg) else {
                throw CommandError.commandNotExist(command: commandArg)
            }
            
            var generator: AssetsGenerator?
            switch command {
            case .strings:
                generator = try StringsGenerator(parser: swiftyParser)
            case .colors:
                break
            case .images:
                break
            case .fonts:
                break
            }
            
            try generator?.generate()
        }
    } catch {
        if let localizedDescriptionError = error as? LocalizedDescriptionError {
            print("\(localizedDescriptionError.localizedDescription)\n")
        } else {
            print("\(error.localizedDescription)\n")
        }
        print("Use --help to see how \(Spec.projectName) works")
        //swiftyParser.argumentParser.printUsage(on: stdoutStream)
    }
}

main()
