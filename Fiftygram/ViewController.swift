import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    let context = CIContext()
    var original: UIImage!
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(original, nil, nil, nil)
    }
    
    @IBAction func randomFilter() {
        if original == nil {
            let alert = UIAlertController(title: "No image", message: "Choose an image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Will do!", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let randomizer = Int.random(in: 1...4)
        
        if randomizer == 1 {
            let filter = CIFilter(name: "CIPhotoEffectChrome")
            filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            display(filter: filter!)
        }
        
        if randomizer == 2 {
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            display(filter: filter!)
        }
        
        if randomizer == 3 {
            let filter = CIFilter(name: "CIPhotoEffectNoir")
            filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            display(filter: filter!)
        }
        
        if randomizer == 4 {
            let filter = CIFilter(name: "CIPhotoEffectProcess")
            filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            display(filter: filter!)
        }
    }
    
    @IBAction func frankfilter() {
        if original == nil {
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applySepia() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
}
