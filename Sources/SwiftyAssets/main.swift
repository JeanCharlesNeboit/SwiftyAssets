import Foundation
import Basic
import SPMUtility

func main() {        
    var registry = CommandRegistry(usage: "[--version] [--help] <command> <options>", overview: Spec.overview)

    registry.register(command: StringsCommand.self)
    registry.register(command: ColorsCommand.self)
    registry.register(command: FontsCommand.self)
    registry.register(command: ImagesCommand.self)

    registry.run()
}

main()
