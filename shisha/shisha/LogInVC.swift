
import UIKit
import FacebookCore
import FacebookLogin
import FirebaseDatabase
import Firebase

class LogInVC: UIViewController {
    
    var ref: DatabaseReference?
    
    var userFbName: String!
    var userFbID: String!
    var userFbEmail: String!
    
    
    @IBAction func fbLoginBtnPressed(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn([.publicProfile, .email], viewController: self) { result in
            
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success(_,_,_):
                self.getUserInfo {userInfo, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if let userInfo = userInfo, let id = userInfo["id"], let name = userInfo["name"], let email = userInfo["email"]{
                        self.userFbID = "\(id)"
                        self.userFbName = "\(name)"
                        self.userFbEmail = "\(email)"

                    }
                    
                 self.addUserToFirebase()

                }
            }
            
        }
    }
    
    func getUserInfo(completion: @escaping (_ : [String: Any]?, _ : Error?) -> Void) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"])
        
        request.start{ response, result in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
            }
        }
    }
    
    func addUserToFirebase(){
        self.ref = Database.database().reference()
        self.ref?.child("Users").child("\(self.userFbID)").child("Name").setValue(self.userFbName)
        self.ref?.child("Users").child("\(self.userFbID)").child("Email").setValue(self.userFbEmail)
        self.performSegue(withIdentifier: "loggedIn", sender: self)
        
    }
    
   /* func addUserInfo(){
        
        ref = Database.database().reference()
    ref?.child("users").childByAutoId().setValue("\(id)")
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

