QuoteTableViewController

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController,SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased{
                print("Kullanıcı Ödemesi Başarılı")
                ShowPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if transaction.transactionState == .failed{
                if let error = transaction.error{
                    let errorDescription = error.localizedDescription
                    print("İşlem hata nedeniyle başarısız oldu: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if transaction.transactionState == .restored{
                ShowPremiumQuotes()
                print("İşlem geri yüklendi")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    let productID = "erenlifetime.SKPaymentTransactionObserver"
    var quotesToShow = [
        "En büyük zaferimiz hiç düşmemek değil, her düştüğümüzde ayağa kalkabilmektir. - Konfüçyüs",
                 "Peşinden gidecek cesaretimiz varsa, tüm hayallerimiz gerçek olabilir. - Walt Disney",
                 "Durmadığın sürece ne kadar yavaş gittiğin önemli değil. - Konfüçyüs",
                 "İstediğin her şey korkunun diğer tarafındadır. - George Addair",
                 "Başarı nihai değildir, başarısızlık ölümcül değildir: Önemli olan devam etme cesaretidir. - Winston Churchill",
                 "Zorluklar çoğu zaman sıradan insanları olağanüstü bir kadere hazırlar. - C.S. Lewis"
    ]
    let premiumQuotes = [
        "Kendinize inanın. Düşündüğünüzden daha cesursunuz, sandığınızdan daha yeteneklisiniz ve hayal ettiğinizden daha fazlasını yapabilecek kapasitedesiniz. ― Roy T. Bennett",
                 "Cesaretin korkunun yokluğu değil, korkunun üstesinden gelinmesi olduğunu öğrendim. Cesur adam korkmayan değil, bu korkuyu yenen kişidir. – Nelson Mandela",
        "Bir hayali gerçekleştirmeyi imkansız kılan tek şey vardır: Başarısızlık korkusu. -Paulo Coelho",
                 "Önemli olan yere düşüp düşmemeniz değil, ayağa kalkıp kalkmamanızdır. – Vince Lombardi",
                 "Hayattaki gerçek başarınız ancak yaptığınız işte mükemmel olmaya kararlı olduğunuzda başlar. - Brian Tracy",
                 "Kendinize inanın, zorlukların üstesinden gelin, korkularınızı yenmek için içinizin derinliklerine inin. Kimsenin sizi yıkmasına izin vermeyin. Devam etmelisiniz. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        if isPurchased(){
            ShowPremiumQuotes()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return quotesToShow.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row == quotesToShow.count{
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.black
        }else{
            cell.textLabel?.text = "Daha Fazla Teklif Alın"
            cell.textLabel?.textColor = UIColor.white
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // i bought
        if isPurchased(){
        return quotesToShow.count
        }else{
            return quotesToShow.count + 1
        }
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count{
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func buyPremiumQuotes(){
        if SKPaymentQueue.canMakePayments(){
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }else{
            print("Ödeme Yapılamadı")
        }
}
    func ShowPremiumQuotes(){
        UserDefaults.standard.bool(forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    func isPurchased()->Bool{
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        if purchaseStatus{
            print("Daha Önce Satın Alınanlar")
            return true
        }else{
            print("Daha Önce Satın Alma Gerçekleşmedi")
            return false
        }
    }
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }
}
