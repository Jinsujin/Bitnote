import UIKit
import Sketch

/**
 노트 입력 - 그리는 이미지 ViewController
  
 - SketchView 에 backgroundColor 가 들어가면 안됨(지우개 기능 작동 에러)
 */

class NoteDrawingViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var canvasView: SketchView!
    
    @IBOutlet weak var utilView: UIView!
    @IBOutlet var brushSizeView: UIView!
    @IBOutlet var brushColorView: UIView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    private var selectedColorIndex = 2
    private var colorItems: [UIColor] = [
        #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1), #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.2431372549, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.5019607843, blue: 0.2274509804, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    ]
    
    var touchSaveButton: ((UIImage) -> Void)?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "note_item_drawimage_title".localized()
        doneButton.title = "button_done".localized()
        
        setupCollectionView()
        
        // button setting
        let highlightImage_redo = #imageLiteral(resourceName: "icon_redo").withTintColor(UIColor(hex:"CCD9FF"), renderingMode: .alwaysOriginal)
        redoButton.setImage(highlightImage_redo, for: .highlighted)
        
        let highlightImage_undo = #imageLiteral(resourceName: "icon_undo").withTintColor(UIColor(hex: "CCD9FF"), renderingMode:.alwaysOriginal)
        undoButton.setImage(highlightImage_undo, for: .highlighted)
        
        canvasView.drawTool = .pen
        canvasView.lineWidth = CGFloat(10)

        setupViews()
 
    }
    
    private func setupViews(){
        // 브러쉬 사이즈 뷰
        brushSizeView.isHidden = true
         self.view.addSubview(brushSizeView)
         brushSizeView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             brushSizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             brushSizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             brushSizeView.bottomAnchor.constraint(equalTo: utilView.topAnchor, constant: 0)
         ])
         
         
        
        // 브러쉬 컬러뷰
        brushColorView.isHidden = true
        self.view.addSubview(brushColorView)
        brushColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brushColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brushColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            brushColorView.bottomAnchor.constraint(equalTo: utilView.topAnchor, constant: 0),
            brushColorView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
    }
    
    
    
    func setupCollectionView(){
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        colorCollectionView.register(DrawingColorCell.nib(), forCellWithReuseIdentifier: DrawingColorCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let flowLayout = UICollectionViewFlowLayout()
//        let numberOfItemPerRow: CGFloat = 6
//        let lineSpacing: CGFloat = 5
//        let interItemSpacing: CGFloat = 5
//
//        let width = (colorCollectionView.frame.width - (numberOfItemPerRow) * interItemSpacing) / numberOfItemPerRow
//        let height = width
        
//        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 10
        
        colorCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    @IBAction func touchedSaveButton(_ sender: Any) {
        let img = self.canvasView.takeScreenShot()
        self.dismiss(animated: true) {
            self.touchSaveButton?(img)
        }
    }

    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func touchedUndoButton(_ sender: Any) {
        canvasView.undo()
        
    }
    

    @IBAction func touchedResetButton(_ sender: Any) {
        canvasView.clear()
    }
    
    @IBAction func touchedRedoButton(_ sender: Any) {
        canvasView.redo()
    }
    
    @IBAction func touchedBrushButton(_ sender: Any) {
        canvasView.drawTool = .pen
        
        brushSizeView.isHidden = true
        brushColorView.isHidden = false
       
    }
    
    @IBAction func touchedEraserButton(_ sender: Any) {
        canvasView.drawTool = .eraser
        
        brushSizeView.isHidden = false
        brushColorView.isHidden = true
    }
    
    
    @IBAction func changedSizeSlider(_ sender: UISlider) {
        canvasView.lineWidth = CGFloat(sender.value)
        
    }
    
    @IBAction func changedOpacitySlider(_ sender: UISlider) {
        canvasView.lineAlpha = CGFloat(sender.value)
    }

 
}


extension NoteDrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawingColorCell.identifier, for: indexPath) as! DrawingColorCell
        
        if selectedColorIndex == indexPath.row {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        cell.backgroundColor = colorItems[indexPath.row]
        
        cell.layer.cornerRadius = cell.frame.size.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? DrawingColorCell  else {
            return
        }
        
        cell.isSelected = true
        
        self.selectedColorIndex = indexPath.row
        canvasView.lineColor = colorItems[indexPath.row]
        
    }
    
}
