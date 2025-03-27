import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/transaction.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/user/purchase_successful.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  void dispose(){
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    listenToPurchases(); // Start listening to the purchase stream
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  sendd(String uide) async {
    try {
      String str = DateTime.now().toString();
      TransactionModel tran = TransactionModel(
          answer: true,
          name:  "Transaction Credited + ${we.toInt()}",
          method: "",
          rupees: we,
          pay: false,
          status: "Credited",
          coins:we.toInt(),
          time: str,
          time2: str,
          nameUid: "Transaction Credited + ${we.toInt()}",
          id: str,
          pic: "",
          transactionId: uide
      );
      await FirebaseFirestore.instance.collection("users").doc(
          FirebaseAuth.instance.currentUser!.uid).collection("Transaction")
          .doc(str).set(tran.toJson());
    }catch(e){

    }

  }
  Razorpay _razorpay = Razorpay();
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    sendd(response.paymentId??"hbjkj");
    setState(() {
      isstarted=false;
    });
    try {
      await FirebaseFirestore.instance.collection("users").doc(uidd).update({
        "amount": FieldValue.increment(we),
      });
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PurchaseSuccessful(sum: we,)));
      Send.message(context, 'Purchase successful: $we', true);
    }catch(e){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PurchaseSuccessful(sum: we,)));
      Send.message(context, 'Purchase successful: $we', true);
      Send.message(context, '$e', false);
    }
    print(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isstarted=false;
    });
    print(response);
    Send.message(context, response.toString(), false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      isstarted=false;
    });
    print(response);
    Send.message(context, response.toString(), false);
  }

  bool isstarted=false;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("Add Money to Wallet",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${_user!.amount.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                Text("₹ ${(_user!.amount+we).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Balance",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                Text("After Paying",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Divider(),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("    Pay",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              Spacer()
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c("10rupees", 10.0, w),
                c("20rupees", 20.0, w),
                c("50rupees", 50.0, w),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c("100rupees", 100.0, w),
                c("200rupees", 200.0, w),
                c("500rupees", 500.0, w),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c("1000rupees", 1000.0, w),
                c("2000rupees", 2000.0, w),
                c("5000rupees", 5000.0, w),
              ],
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
              onTap: () async {
                setState(() {
                  isstarted=true;
                });
                var options = {
                  'key': 'rzp_live_ZKeMZpcZxD7KVs',
                  'amount': we.toInt()*100,
                  'name': 'Add $we to Sukhji Platform Wallet',
                  'description': 'This Transaction will Add $we to Sukhji Platform Wallet',
                  'prefill': {
                    'contact': _user.Email,
                  }
                };
                _razorpay.open(options);
                /*
                final bool available = await InAppPurchase.instance.isAvailable();
                print(available);
                setState(() {
                  isstarted=true;
                });
                final productDetails = await fetchProductDetails(productid);
                if (productDetails == null) {
                  Send.message(context,'Product details not found', false);
                  setState(() {
                    isstarted=false;
                  });
                  return;
                }
                final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                try {
                  await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
                } catch (e) {
                  Send.message(context, 'Purchase failed: $e', false);
                  print('Purchase error: $e');
                } finally {
                  setState(() {
                    isstarted = false;
                  });
                }*/
              },
              child:isstarted?Center(
                child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Send.bg),
              ): Center(child: Send.see(w, "Add ${we.toInt()} to Wallet", Icon(Icons.account_balance_outlined,color: Colors.white,)))),
          Spacer(),
          isstarted?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 10,),
          Text("Pay by UPI, Credit Card, Redeem Code, Netbanking"),
          Center(child: Image.network(width: w-30,"https://buymeds.in/wp-content/webp-express/webp-images/uploads/2022/09/Pay-Using-Any-UPI-App.png.webp"))
          ,SizedBox(height: 15,),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
  String productid="100rupees";
  double we=100.0;

  Widget c(String pid,double ser,double w){
    return InkWell(
      onTap: () async {
        setState(() {
          productid=pid;
          we=ser;
        });
      },
      child: Container(
        width: w/3-20,
        height: 50,
        decoration: BoxDecoration(
            color:ser==we?Colors.blue.shade100: Colors.black,
          border: Border.all(
            color: ser==we?Colors.blue:Colors.black,
            width:ser==we?1.0: 2.5
          )
        ),
        child: Center(child: Text("₹ ${ser.toInt()}",style: TextStyle(fontWeight: FontWeight.w800,color: ser==we?Colors.black:Colors.white),)),
      ),
    );
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Set<String> _productIds = {'100rupees','10rupees','1000rupees','20rupees','200rupees','2000rupees', '50rupees','500rupees','5000rupees'};

  Future<ProductDetails?> fetchProductDetails(String productId) async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      setState(() {
        isstarted=false;
      });
      Send.message(context,'Product not found: ${response.notFoundIDs}', false);
      print('Product not found: ${response.notFoundIDs}');
      return null;
    }
    return response.productDetails.firstWhere((product) => product.id == productId, // Return null if no matching product is found
    );
  }
  final String uidd=FirebaseAuth.instance.currentUser!.uid??"gjg";
  void listenToPurchases() {
    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) async {
      for (var purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          setState(() {
            isstarted = false;
          });

          try {
            await FirebaseFirestore.instance.collection("users").doc(uidd).update({
              "amount": FieldValue.increment(we),
            });
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => PurchaseSuccessful(sum: we,)));
            Send.message(context, 'Purchase successful: ${purchaseDetails.productID}', true);
          }catch(e){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => PurchaseSuccessful(sum: we,)));
            Send.message(context, 'Purchase successful: ${purchaseDetails.productID}', true);
            Send.message(context, '$e', false);
          }
          print('Purchase successful: ${purchaseDetails.productID}');
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            isstarted = false;
          });
          Send.message(context, 'Purchase failed: ${purchaseDetails.error}', false);
          print('Purchase failed: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          setState(() {
            isstarted = false;
          });
          Send.message(context, 'Purchase restored: ${purchaseDetails.productID}', false);
          print('Purchase restored: ${purchaseDetails.productID}');
        }

        // Complete pending purchases
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

}
