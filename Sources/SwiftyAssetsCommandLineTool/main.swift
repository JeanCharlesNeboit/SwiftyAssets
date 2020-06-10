import Foundation
import Basic
import SPMUtility
import SwiftyAssets

func main() {        
    var registry = CommandRegistry(usage: CommandLineTool.usage, overview: CommandLineTool.overview)

    registry.register(command: StringsCommand.self)
    registry.register(command: ColorsCommand.self)
    registry.register(command: FontsCommand.self)
    registry.register(command: ImagesCommand.self)

    registry.run()
}

main()
