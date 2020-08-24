//
//  ImageGalleryDocumentBrowserViewController.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 24.08.2020.
//

import UIKit

class ImageGalleryDocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        allowsPickingMultipleItems = false
        
        allowsDocumentCreation = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: FileManager.SearchPathDomainMask.userDomainMask,
                appropriateFor: nil,
                create: true)
            .appendingPathComponent(templateFilename)
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: IGGallery().json ?? Data())
            }
        }
    }
    
    func presentDocument(at url: URL) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        if let navigationVC = story.instantiateViewController(withIdentifier: "Navigation") as? UINavigationController,
            let imageGalleryCVC = navigationVC.contents as? ImageGalleryCollectionViewController {
            imageGalleryCVC.document = IGDocument(fileURL: url)
            present(navigationVC, animated: true)
        }
    }
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    
    private var template: URL?
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let url = documentURLs.first else { return }
        presentDocument(at: url)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    // MARK: - Constant Values
    
    private let templateFilename = "Untitled.imagegallery"
    private let imageGalleryControllerIdentifier = "ImageGallery"

}
