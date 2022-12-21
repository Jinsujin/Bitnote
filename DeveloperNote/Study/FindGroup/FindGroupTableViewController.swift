import UIKit
import SnapKit

/**
 그룹 찾기
 */

class FindGroupTableViewController: UITableViewController, UINavigationBarDelegate {
    private let viewModel = FindGroupViewModel()
    
    public var handleSelection: ((Group) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "그룹 찾기"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        
        setupNavigationBar()
    }

    
    private func setupNavigationBar(){
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self

        let navItem = UINavigationItem()
        navItem.title = "그룹 찾기"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: nil)

        navbar.items = [navItem]

        view.addSubview(navbar)

        self.view.backgroundColor = .systemPink
        self.tableView.backgroundColor = .brown
        self.tableView.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
            
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupDataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.groupDataList[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        let group = self.viewModel.groupDataList[indexPath.row]
        self.dismiss(animated: true) { [weak self] in
            self?.handleSelection(group)
        }
    }
}
