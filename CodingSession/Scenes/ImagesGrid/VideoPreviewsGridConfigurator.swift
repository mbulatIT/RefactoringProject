import UIKit

enum VideoPreviewsGridConfigurator {
    static func makeViewController() -> UIViewController {
        let viewModel = DefaultImagesGridViewModel()
        let viewController = VideoPreviewsGridViewController(viewModel: viewModel)
        return viewController
    }
}
