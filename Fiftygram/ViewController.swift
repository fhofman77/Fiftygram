import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    let context = CIContext()
    var original: UIImage!
    
    @IBAction func savePhoto() {
        if original == nil {
            displayNoImage()
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        let alert = UIAlertController(title: "Done!", message: "Your image is saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oké", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func randomFilter() {
        if original == nil {
            displayNoImage()
            return
        }
        let randomizer = Int.random(in: 1...4)
        
        if randomizer == 1 {
            frankfilter()
        }
        
        if randomizer == 2 {
            applySepia()
        }
        
        if randomizer == 3 {
            applyNoir()
        }
        
        if randomizer == 4 {
            applyVintage()
        }
    }
    
    @IBAction func frankfilter() {
        if original == nil {
            displayNoImage()
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        let imageWithFilter: UIImage = filter?.value(forKey: kCIOutputImageKey)
        let secondFilter = CIFilter(name: "CIPhotoEffecNoir")
        secondFilter?.setValue(CIImage(image: imageWithFilter), forKey: kCIInputImageKey)
        display(filter: imageWithFilter!)
    }

    @IBAction func applySepia() {
        if original == nil {
            displayNoImage()
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            displayNoImage()
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            displayNoImage()
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
    
    func displayNoImage() {
        let alert = UIAlertController(title: "No image", message: "Choose an image!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Will do!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
