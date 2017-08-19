
import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase
import Firebase

class LogInVC: UIViewController {
    
    var ref: DatabaseReference?
    
    var userFbName = ""
    var userFbID = ""
    var userFbEmail = ""
    
    
    @IBAction func fbLoginBtnPressed(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
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
        segueToTabBar()
    }
    
    func segueToTabBar(){
        performSegue(withIdentifier: "loggedIn", sender: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            print("kein token")
            
            segueToTabBar()
        } else{
        print(FBSDKAccessToken.current())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

