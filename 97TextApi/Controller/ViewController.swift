//
//  ViewController.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import UIKit

class ViewController: UIViewController {
    var model = [Datum]()
    var currentLimit = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callAPi()
        setUpTableView()
    }
    
    
    
    func callAPi() {
        APIClient.homeUserApi(pagination: true, limit:currentLimit) { [self] response, error in
            print(response)
            model = response
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
    
    
    func setUpTableView(){
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 248
    }

    
    

}


extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.picture.imageFromURL(urlString: model[indexPath.row].picture ?? "")
//        cell.picture.image = model[indexPath.row].picture
        cell.tapDeleteBtn = { [self] in
            deleteUser(id: self.model[indexPath.row].id ?? "") {
                callAPi()
            }
        
        }
        
        cell.tapUpdateBtn = { [self] in
            let userUpdate = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewUserViewController") as! NewUserViewController
//            userUpdate.fName.text = self.model[indexPath.row].firstName!
//            userUpdate.lName.text = self.model[indexPath.row].lastName ?? ""
//            userUpdate.Email = self.model[indexPath.row]. ?? ""
//            userUpdate.Email.isUserInteractionEnabled = false
//            userUpdate.Email.isHidden = true
            self.navigationController?.pushViewController(userUpdate, animated: true)
            
        }
        
        
        cell.fullname.text = "\(model[indexPath.row].title ?? "") \(model[indexPath.row].firstName ?? "") \(model[indexPath.row].lastName ?? "")"
        
        return cell
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("called")
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            //fetch more data
            self.tableView.tableFooterView = createFooterView()
            print("fetch more")
            
           
            guard !APIClient.isPaginating else {
                //we are already fetching more data
                return
            }
            
                currentLimit+=1
            
            print(self.currentLimit,"currentPagecurrentPage")
            _ = APIClient.homeUserApi(pagination: true,limit: currentLimit, completion: { [self] (response, error) in
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
                for respons in response {
                model.append(respons)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    
    
    private func createFooterView()  -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let sppinner = UIActivityIndicatorView()
        sppinner.color = .gray
        sppinner.center = footerView.center
        sppinner.startAnimating()
        footerView.addSubview(sppinner)
        
        return footerView
    }
    
    func deleteUser(id:String,finished: () -> Void) {

         print("Doing something!")

        let url = URL(string: "https://dummyapi.io/data/v1/user/\(id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue(APIClient.appId, forHTTPHeaderField: "app-id")
print(url,"urll")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            guard let httpBody = try? JSONSerialization.data(withJSONObject:parameters, options: []) else { return }
//            request.httpBody = httpBody
       
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
              
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                  
                } catch {
                    print(error)
                }
            }
        }.resume()
       
         finished()

    }
    
}
